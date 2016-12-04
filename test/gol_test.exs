defmodule GOLTest do
  use ExUnit.Case
  doctest GOL

  test "does not work with empty board" do
    assert_raise ArgumentError, "empty board", fn ->
        GOL.create_game([])
    end
  end

  test "does not work if rows have not the same length" do
    assert_raise ArgumentError, "rows needs to have the same length", fn ->
        GOL.create_game([
                    [:dead, :dead, :dead],
                    [:dead, :dead],
                    [:dead, :dead, :dead]
                ])
    end
  end

  test "dead board is dead" do
    for row <- GOL.create_game(
        [
            [:dead, :dead, :dead],
            [:dead, :dead, :dead],
            [:dead, :dead, :dead]
        ]
    ).board do
      for cell <- row do
        assert cell == :dead
      end
    end
  end

  test "there is life out there" do
    assert Enum.at(Enum.at(
        GOL.create_game(
            [
                [:dead, :dead, :dead],
                [:dead, :dead, :alive],
                [:dead, :dead, :dead]
            ]
        ).board, 1), 2)
     == :alive
  end

  test "next gen kills single cells" do
    assert Enum.at(Enum.at(
            GOL.next_generation(GOL.create_game(
                [
                    [:dead, :dead, :dead],
                    [:dead, :dead, :alive],
                    [:dead, :dead, :dead]
                ]
            )), 1), 2)
         == :dead
  end

  test "spawn something" do
    assert Enum.at(Enum.at(
            GOL.next_generation(GOL.create_game(
                [
                    [:dead, :dead, :dead],
                    [:alive, :dead, :alive],
                    [:dead, :alive, :dead]
                ]
            )), 1), 1)
         == :alive
  end

  test "flip it" do
    assert GOL.next_generation(GOL.create_game(
                [
                    [:dead, :dead, :dead],
                    [:alive, :alive, :alive],
                    [:dead, :dead, :dead]
                ]
            ))
         == [
                [:dead, :alive, :dead],
                [:dead, :alive, :dead],
                [:dead, :alive, :dead]
            ]
  end

  test "flip it back" do
    assert GOL.next_generation(GOL.create_game(
                [
                    [:dead, :alive, :dead],
                    [:dead, :alive, :dead],
                    [:dead, :alive, :dead]
                ]
            ))
         == [
             [:dead, :dead, :dead],
             [:alive, :alive, :alive],
             [:dead, :dead, :dead]
            ]
  end

  test "creation on small field" do
    assert GOL.next_generation(GOL.create_game(
                [
                    [:dead,  :alive],
                    [:alive, :alive]
                ]
            ))
         == [
                    [:alive, :alive],
                    [:alive, :alive]
            ]
  end

  test "dead on small field" do
    assert GOL.next_generation(GOL.create_game(
                [
                    [:dead,  :alive],
                    [:alive, :dead]
                ]
            ))
         == [
                    [:dead, :dead],
                    [:dead, :dead]
            ]
  end

end
