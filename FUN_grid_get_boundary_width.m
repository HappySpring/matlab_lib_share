function [x_b, x_width ]= FUN_grid_get_boundary_width( x, x0 )
% get the boundary of x axis
%  INPUT:
%        x:  center of each grid
%        x0: western/southern boundary of the grid, x0 should be a 1x1 matrix 
%           (x0 is necessary when the grid is not uniform. )
%  OUTPUT:
%        x_b is the boundary of x
%        x_width is the width of each grid

% By Lequan Chi
% V 1.00

%% basic check

 if ~exist('x0','var') || isempty(x0)
    x0 = x(1) - ( x(2) - x(1) ) / 2; 
    wh_x0_input = false;
 else
    wh_x0_input = true;
 end

 if exist('x0','var') && length(x0) ~= 1
     error('x0 should be a 1x1 matrix')
 end
 
 if all( x(2:end) - x(1:end-1) > 0 )  || all( x(2:end) - x(1:end-1) < 0 ) 
 else
    error('x must be monotonously!') 
 end
%% check whether dx dy are uniform. 
    dx = x(2:end) - x(1:end-1);
    if all( abs( dx - dx(1) ) < abs(dx(1))*1e-3 )
        is_uniform = 1;
    else
        if wh_x0_input == false
            warning('dx is not uniform! the locaiton of the original point should be provided from input parameters in this condition.')
        end
        is_uniform = 0;
        
        if ~exist('x0','var')
            error('x0 is necessary in non-uniform cases!')
        end
    end

    
%% get boundaries


x_b = nan( length(x) + 1, 1 );
if exist('x0','var')
   x_b(1) = x0;
   
   % check---------------------
       if is_uniform == 1
          if  abs(  x_b(1) - ( x(1) - (x(2)-x(1))/2 )  ) < 1e-3*abs( x(2)-x(1) );
          else
              error('The input x0 is wrong')
          end
       end
   % --------------------------
else 
   x_b(1) = x(1) - ( x(2) - x(1) )/2;
end



for ii = 1:length(x)
    if ii == 1 && x(1) == x_b(1)
        x_width = (x(2)-x(1))/2;
    else
        x_width(ii) = 2 * ( x(ii) - x_b(ii) );
    end
    x_b(ii+1) = x_b(ii) + x_width(ii);
end








