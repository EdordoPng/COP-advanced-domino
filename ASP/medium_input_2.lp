#const n = 5.
#const input_tiles_number = 4.

% The color is just a simple reference to the shape of the input tile
% tile 1 : verde 
% tile 2 : arancione
% tile 3 : azzurro
% tile 4 : blu

tile(1, 1, 1, 0, 0).
tile(1, 2, 2, 0, 1).
tile(1, 3, 3, 0, 2).

tile(2, 1, 1, 0, 0).
tile(2, 2, 2, 1, 0).
tile(2, 3, 3, 1, 1).

tile(3, 1, 3, 0, 1).
tile(3, 2, 2, 1, 0).
tile(3, 3, 0, 1, 1).

tile(4, 1, 1, 0, 0).
tile(4, 2, 2, 1, 0).
tile(4, 3, 3, 2, 0).

