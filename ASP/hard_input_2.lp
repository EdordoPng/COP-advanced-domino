#const n = 5.
#const input_tiles_number = 5.

% The color is just a simple reference to the shape of the input tile
% tile 1 : blu 
% tile 2 : fuxia 
% tile 3 : arancione 
% tile 4 : viola
% tile 5 : verde

tile(1, 1, 6, 0, 0).
tile(1, 2, 6, 1, 0).
tile(1, 3, 4, 2, 0).

tile(2, 1, 1, 0, 0).
tile(2, 2, 2, 0, 1).
tile(2, 3, 5, 1, 0).

tile(3, 1, 2, 0, 0).
tile(3, 2, 2, 1, 0).
tile(3, 3, 6, 1, 1).

tile(4, 1, 2, 0, 0).
tile(4, 2, 6, 0, 1).
tile(4, 3, 0, 1, 0).
tile(4, 4, 4, 1, 1).

tile(5, 1, 1, 0, 0).
tile(5, 2, 2, 0, 1).
tile(5, 3, 2, 0, 2).
