defmodule GOL do
    defstruct board: nil, height: nil, width: nil

    def create_game(board) do
      if length(board) === 0, do: raise(ArgumentError, message: "empty board")

      firstRowLength = length(Enum.at(board, 0))
      if Enum.any?(board, fn(row) -> length(row) !== firstRowLength end),
         do: raise(ArgumentError, message: "rows needs to have the same length")

      %GOL{board: board, height: length(board), width: firstRowLength}
    end

    def next_generation(gol) do
        limit_y = (gol.height - 1)
        limit_x = (gol.width - 1)

        for y <- 0..limit_y do
            for x <- 0..limit_x do
                if cell_state(gol.board, y, x) === :alive do
                  stay_alive(gol.board, y, x)
              else
                  create_cell(gol.board, y, x)
                end
            end
        end
    end

    def create_cell(board, y, x) do
      if living_neighbours(board, y, x) === 3 do
        :alive
        else
        :dead
      end
    end

    def stay_alive(board, y, x) do
      living_neighbours = living_neighbours(board, y, x)
      if living_neighbours === 2 or living_neighbours === 3 do
        :alive
        else
        :dead
      end
    end

    def living_neighbours(board, y, x) do
        neighbourList =
        for othersY <- (y-1)..(y+1), othersX <- (x-1)..(x+1) do
            unless othersX === x and othersY === y do
              cell_state(board, othersY, othersX)
             else
              :dead
            end
        end
        living_neighbours = Enum.filter(neighbourList, fn(x) -> x !== :dead end)
        Enum.count(living_neighbours)
    end

    def cell_state(board, y, x) do
        if x < 0 or y < 0 do
            :dead
         else
            row = Enum.at(board, y, :dead)
            if row === :dead do
                :dead
            else
                Enum.at(row, x, :dead)
            end
        end
    end
end
