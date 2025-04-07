% To execute this code use : 
% 
%       clingo completed_code.lp easy_input_1.lp --stats

% Author : Edoardo Diana

% Definition of the adjacency predicate to identify is two cells of the grid are close to each other.
adjacent(X1, Y1, X2, Y2) :- grid_cell(X1, Y1), grid_cell(X2, Y2), X1 = X2, Y2 = Y1 + 1.
adjacent(X1, Y1, X2, Y2) :- grid_cell(X1, Y1), grid_cell(X2, Y2), Y1 = Y2, X2 = X1 + 1.
adjacent(X1, Y1, X2, Y2) :- adjacent(X2, Y2, X1, Y1).

% Definition of the grid, X and Y coordinates less than n+1
grid_cell(X, Y) :- X = 1..n, Y = 1..n.

% We decide which tiles to place
{ use_tile(Tile_ID) } :- Tile_ID = 1..input_tiles_number.

% Base position only for tiles we decide to use
1 { base(Tile_ID, X, Y) : grid_cell(X, Y) } 1 :- use_tile(Tile_ID).   

% Placement of cells, conditional on the use of the tile
1 { positioned(Tile_ID, Cell_Index, X, Y) : grid_cell(X, Y) } 1 :- 
    tile(Tile_ID, Cell_Index, _, OffsetX, OffsetY),
    use_tile(Tile_ID),
    base(Tile_ID, BaseX, BaseY),
    X = BaseX + OffsetX,
    Y = BaseY + OffsetY.

% If a tile is not used, none of its cells should be positioned
:- positioned(Tile_ID, _, _, _), not use_tile(Tile_ID).

% If a tile is used, all its cells must be placed
:- use_tile(Tile_ID), tile(Tile_ID, Cell_Index, _, _, _),
   not positioned(Tile_ID, Cell_Index, _, _).

% The connected atom is obtained only for used tiles
connected(Tile_ID) :- use_tile(Tile_ID), positioned(Tile_ID, _, X1, Y1), 
    positioned(AltroID, _, X2, Y2), use_tile(AltroID),
    AltroID != Tile_ID, adjacent(X1, Y1, X2, Y2).

% This rule verifies whether there is a direct link between two tiles on the grid
reachable(ID1, ID2) :- use_tile(ID1), use_tile(ID2),
    positioned(ID1, _, X1, Y1), positioned(ID2, _, X2, Y2),
    ID1 != ID2, adjacent(X1, Y1, X2, Y2).
% Here we are connecting tiles that are not directly adjacent but part of the same chain
reachable(ID1, ID2) :- reachable(ID1, ID3), reachable(ID3, ID2),
    ID1 != ID2.

% No cell can be used by more than one tile
:- positioned(Tile_ID1, Cell_Index, X, Y), positioned(Tile_ID2, Cell_Index2, X, Y), Tile_ID1 != Tile_ID2.

% Two cells of different tiles can be adjacent only if they have the same value
:- positioned(Tile_ID1, Cell_Index, X1, Y1), positioned(Tile_ID2, Cell_Index2, X2, Y2),
    tile(Tile_ID1, Cell_Index, Value_1, _, _), tile(Tile_ID2, Cell_Index2, Value_2, _, _),
    adjacent(X1, Y1, X2, Y2), Value_1 != Value_2, Tile_ID1 != Tile_ID2.

% Every tile used must be connected (except if it is the only one)
:- use_tile(Tile_ID), #count{ID : use_tile(ID)} > 1, not connected(Tile_ID).

% If we use more than one tile, they must all be reachable from the first used tile
:- use_tile(ID1), use_tile(ID2), ID1 < ID2,
   #count{ID : use_tile(ID)} > 1,
   not reachable(ID1, ID2).

% Goal: Maximize the number of tiles placed
#maximize { 1,Tile_ID : use_tile(Tile_ID) }.

#show positioned/4.
#show use_tile/1.