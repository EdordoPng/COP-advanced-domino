% Finds the solution that provides the maximum number of tiles that can be placed.

% List of constraints:
%  1) Place the tiles in grid and place_grid.
%  2) Each tile must be adjacent to at least one other tile.
%  3) Adjacent cells of different tiles must have the same value.
%  4) The number of usable cells is limited to the number of cells in the input tiles.
%  5) A cell is occupied if a tile is placed on it.
%  6) Start connecting from an occupied cell.
%  7) Propagate the connection in all directions for adjacent occupied cells.

% -----------------------------------------------------------------------------------------------------------

% Author : Edoardo Diana

% Size of the grid n x n
int: n;

% Number of available tiles
int: tile_number;

set of int: allowed_values = {0,1,2,3,4,5,6};

% Matrix representing the game board grid, with the values of the tiles
array[1..n, 1..n] of var allowed_values: grid;

% Matrix representing occupied cells in the grid
% 0 = empty cell, otherwise it contains the index of the placed tile
array[1..n, 1..n] of var 0..tile_number: place_grid;

% Number of cells for each tile
array[1..tile_number] of int: number_of_cells;

% Matrix for each tile containing triplets (value, x, y) ideally plotted on a 3x3 matrix
array[1..tile_number, 1..4] of tuple(int, int, int): tiles;

% Variable counting the number of occupied cells (different from 0) in place_grid
var 0..n*n: occupied_cells;

% Binary variable indicating if a cell is connected to the main component
array[1..n, 1..n] of var 0..1: connected;

% Binary variable for each tile indicating whether the tile is placed (1) or not (0)
array[1..tile_number] of var 0..1: tile_placed;

% Constraint 1:
% To place a tile, there must exist a free starting cell such that all the positions
% occupied by the cells of that tile are free.

% This constraint evaluates whether it is possible to place a tile at a given position.
% A valid starting position, identified by coordinates X and Y, must exist, satisfying the conditions
% specified below.
% An auxiliary constant "k" keeps track of the number of cells in the tile being analyzed.
% By iterating through each cell of the tile, new coordinates "cellX" and "cellY" are calculated
% by adding the starting coordinates and an offset specific to the current cell being analyzed.
% For each of these coordinates, the value in "grid" must match the value of the cell in the tile 
% (provided in input), and the value in "place_grid" must match the current tile's index.
% If these conditions are met for all the cells of the tile, it can be placed on the board.

constraint forall(t in 1..tile_number)(
    if tile_placed[t] == 1 then
        exists(startX, startY in 1..n)(
            let {
                int: k = number_of_cells[t]
            } in
            forall(i in 1..k)(
                let {
                    int: cellX = startX + tiles[t, i].2,
                    int: cellY = startY + tiles[t, i].3
                } in
                cellX >= 1 /\ cellX <= n /\       % The cell must be valid
                cellY >= 1 /\ cellY <= n /\       % The column must be valid
                % The value in the grid must match the value of the cell in the tile
                grid[cellX, cellY] == tiles[t, i].1 /\ 
                % The cell in the grid with tile indices must be occupied by tile t
                place_grid[cellX, cellY] == t     
            )
        )
    else
        % If the tile is not placed, it should not occupy any cells
        forall(cellX, cellY in 1..n)(
            place_grid[cellX, cellY] != t
        )
    endif
  )   
;

% Predicate that is True only if at least one tile has been placed on the board.
predicate at_least_one_tile_placed() =
  sum(t in 1..tile_number)(tile_placed[t]) > 1;

% Constraint 2: 
% Each placed tile must be adjacent to at least one other tile.

% This constraint applies to all tiles except the first placed tile on the board.
% It ensures that a tile is placeable if there exists a cell belonging to it that is adjacent to 
% a cell of a different tile.

constraint forall(t1 in 1..tile_number)(
    if tile_placed[t1] == 1 /\ at_least_one_tile_placed() then (
        exists(cellX, cellY in 1..n)(
            place_grid[cellX, cellY] == t1 /\
            % Check that at least one adjacent cell belongs to a tile other than t1
            (
                % Cell above
                (cellX > 1 /\ place_grid[cellX - 1, cellY] != 0 /\ place_grid[cellX - 1, cellY] != t1) \/ 
                % Cell below
                (cellX < n /\ place_grid[cellX + 1, cellY] != 0 /\ place_grid[cellX + 1, cellY] != t1) \/ 
                % Cell to the left
                (cellY > 1 /\ place_grid[cellX, cellY - 1] != 0 /\ place_grid[cellX, cellY - 1] != t1) \/ 
                % Cell to the right
                (cellY < n /\ place_grid[cellX, cellY + 1] != 0 /\ place_grid[cellX, cellY + 1] != t1)    
            )
        )
    ) endif
);

% Constraint 3: 
% Ensure that if two cells of different tiles are adjacent, they have the same value in grid.

% This constraint ensures that adjacent cells of different tiles have the same value inside them.
% It applies to every cell in the "place_grid" matrix where a tile has been placed.
% The check starts from a cell and analyzes the four adjacent cells.

constraint
  forall(cellX, cellY in 1..n where place_grid[cellX, cellY]!=0)(
    if (cellY < n /\ place_grid[cellX, cellY] != place_grid[cellX, cellY + 1] /\ place_grid[cellX, cellY + 1] != 0)
      then grid[cellX, cellY] == grid[cellX, cellY + 1]
    endif
    /\
    if (cellY > 1 /\ place_grid[cellX, cellY] != place_grid[cellX, cellY - 1] /\ place_grid[cellX, cellY - 1] != 0)
      then grid[cellX, cellY] == grid[cellX, cellY - 1]
    endif
    /\
    if (cellX > 1 /\ place_grid[cellX, cellY] != place_grid[cellX - 1, cellY] /\ place_grid[cellX - 1, cellY] != 0)
      then grid[cellX, cellY] == grid[cellX - 1, cellY]
    endif
    /\
    if (cellX < n /\ place_grid[cellX, cellY] != place_grid[cellX + 1, cellY] /\ place_grid[cellX + 1, cellY] != 0)
      then grid[cellX, cellY] == grid[cellX + 1, cellY]
    endif
  );

% Constraint 4: 
% Prevent the solver from adding occupied cells that do not belong to any tile.

% This constraint ensures that each tile occupies a number of cells in the "place_grid" matrix 
% corresponding to the number of cells it consists of.
constraint 
  forall(t in 1..tile_number)(
    if tile_placed[t] == 1 then (
      count(cellX, cellY in 1..n)(place_grid[cellX, cellY] == t ) == number_of_cells[t]
    ) 
    else 
      count(cellX, cellY in 1..n)(place_grid[cellX, cellY] == t ) == 0
    endif
  );  

% Constraint 5: 
% Start connecting from an occupied cell.

% This constraint ensures that each cell in the "connected" matrix is set to 1 if the "place_grid" matrix
% contains a value different from 0 at the same coordinates.
% In other words, if a tile cell is placed at certain coordinates on the game board.

constraint exists(cellX, cellY in 1..n where place_grid[cellX, cellY] != 0) (
    connected[cellX, cellY] == 1
);

% Constraint 6: 
% Ensure that all occupied cells are connected to the main component.

constraint forall(cellX, cellY in 1..n)(
    place_grid[cellX, cellY] != 0 -> connected[cellX, cellY] == 1
);

% Constraint 7: 
% Propagate the connection in all directions for adjacent occupied cells.

% This constraint ensures that if a cell on the game board is occupied, the connection to the main component 
% is propagated to all adjacent components.
% This was done to achieve a single main component and prevent tiles from being placed far from it.

constraint 
    forall(cellX, cellY in 1..n)(
      if place_grid[cellX, cellY] != 0 then (
          % If a cell is connected, propagate the connection to adjacent cells
          (cellX > 1 /\ place_grid[cellX - 1, cellY] != 0) -> (connected[cellX, cellY] == 1 -> cellX > 1 /\ connected[cellX - 1, cellY] == 1 )
          /\
          (cellX < n /\ place_grid[cellX + 1, cellY] != 0) -> (connected[cellX, cellY] == 1 -> cellX < n /\ connected[cellX + 1, cellY] == 1 )
          /\
          (cellY > 1 /\ place_grid[cellX, cellY - 1] != 0) -> (connected[cellX, cellY] == 1 -> cellY > 1 /\ connected[cellX, cellY - 1] == 1 )
          /\
          (cellY < n /\ place_grid[cellX, cellY + 1] != 0) -> (connected[cellX, cellY] == 1 -> cellY < n /\ connected[cellX, cellY + 1] == 1 )
      )
      endif
  );

% Objective: maximize the number of placed tiles
solve maximize sum(t in 1..tile_number)(tile_placed[t]);

% Output
output [
  "Grid:\n" ++
  show2d(grid) ++ "\n" ++
  "Tile placement:\n" ++
  show2d(place_grid) ++ "\n" ++
  "Placed tiles: " ++ show([t | t in 1..tile_number where tile_placed[t]==1]) ++ "\n"
];
