function [X, Y] = FUN_meshgrid_quick( x, y )
% keep x in first dim and y in second dim
% V1.00 By Lequan Chi

[X, Y] = meshgrid( x(:), y(:) );
X = X';
Y = Y';
