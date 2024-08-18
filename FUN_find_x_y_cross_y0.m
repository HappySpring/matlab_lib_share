function [x0, ind0] = FUN_find_x_y_cross_y0( x, y, y0 )
% [x0, ind0] = FUN_find_x_y_cross_y0( x, y, y0 )
% find the locations of function (x,y) where y crosses y0
% 
% 
% V1.00 By L. Chi: Initial version.


%%
% # default and check
 if isempty(x)
     x = 1:length( y );
 end

 if ~isvector(x) || ~isvector(y)
    error('input x and y must be a vector');
 end

 if any( diff(x) <= 0 )
    error('x must increase monotonically')
 end
 
%%
% # find the cross point.

 c_ind = FUN_find_cross_zero( y - y0 );
 
 Nx = size(c_ind,1);
 
 x0   = nan(Nx,1);
 ind0 = nan(Nx,1);
 
 for ii = 1 : Nx
     
     x0(ii)   = interp1( y(c_ind(ii,:)), x(c_ind(ii,:)), y0 );
     ind0(ii) = c_ind(ii,1) + abs( y0 - y(c_ind(ii,1)) ) ./ diff(y(c_ind(ii,:)));
     
 end
 
 
 %% set default value
 if Nx == 0
     x0   = nan;
     ind0 = nan;
 end
 
 