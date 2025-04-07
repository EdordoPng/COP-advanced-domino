#const n = 5.
#const input_tiles_number = 5.

% The color is just a simple reference to the shape of the input tile
% tile 1 : verde 
% tile 2 : verde 
% tile 3 : blu
% tile 4 : viola
% tile 5 : viola

tile(1, 1, 1, 0, 0).
tile(1, 2, 2, 0, 1).
tile(1, 3, 3, 0, 2).

tile(2, 1, 1, 0, 0).
tile(2, 2, 2, 0, 1).
tile(2, 3, 3, 0, 2).

tile(3, 1, 1, 0, 0).
tile(3, 2, 2, 1, 0).
tile(3, 3, 3, 2, 0).

tile(4, 1, 4, 0, 0).
tile(4, 2, 2, 0, 1).
tile(4, 3, 3, 1, 0).
tile(4, 4, 4, 1, 1).

tile(5, 1, 1, 0, 0).
tile(5, 2, 3, 0, 1).
tile(5, 3, 2, 1, 0).
tile(5, 4, 4, 1, 1).