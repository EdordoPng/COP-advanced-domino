% ##### Input 11 ##### 

#const n = 7.
#const input_tiles_number = 13.

% tile 1 : verde 
% tile 2 : fuxia 
% tile 3 : fuxia 
% tile 4 : viola
% tile 5 : azzurro
% tile 6 : verde
% tile 7 : viola
% tile 8 : arancione
% tile 9 : azzurro
% tile 10 : blue
% tile 11 : blue
% tile 12 : blue
% tile 13 : blue

tile(1, 1, 1, 0, 0).
tile(1, 2, 2, 0, 1).
tile(1, 3, 1, 0, 2).

tile(2, 1, 1, 0, 0).
tile(2, 2, 0, 0, 1).
tile(2, 3, 3, 1, 0).

tile(3, 1, 0, 0, 0).
tile(3, 2, 1, 0, 1).
tile(3, 3, 6, 1, 0).

tile(4, 1, 1, 0, 0).
tile(4, 2, 2, 0, 1).
tile(4, 3, 1, 1, 0).
tile(4, 4, 4, 1, 1).

tile(5, 1, 1, 0, 1).
tile(5, 2, 2, 1, 0).
tile(5, 3, 1, 1, 1).

tile(6, 1, 0, 0, 0).
tile(6, 2, 2, 0, 1).
tile(6, 3, 0, 0, 2).

tile(7, 1, 0, 0, 0).
tile(7, 2, 1, 0, 1).
tile(7, 3, 0, 1, 0).
tile(7, 4, 1, 1, 1).

tile(8, 1, 1, 0, 0).
tile(8, 2, 2, 1, 0).
tile(8, 3, 3, 1, 1).

tile(9, 1, 0, 0, 1).
tile(9, 2, 0, 1, 0).
tile(9, 3, 6, 1, 1).

tile(10, 1, 1, 0, 0).
tile(10, 2, 2, 1, 0).
tile(10, 3, 3, 2, 0).

tile(11, 1, 0, 0, 0).
tile(11, 2, 0, 1, 0).
tile(11, 3, 1, 2, 0).

tile(12, 1, 6, 0, 0).
tile(12, 2, 2, 1, 0).
tile(12, 3, 0, 2, 0).

tile(13, 1, 2, 0, 0).
tile(13, 2, 2, 1, 0).
tile(13, 3, 0, 2, 0).