function [x_b, y_b] = FUN_MAP_patch_2D_simpleinterp( x, y, data, varargin )
% Plot grid color based on its original grid size
%
% INPUT: x, y, data
%        x0, y0: south-western boundary of the grid ( x(1), y(1) )  (optional)
%        addtional options for field
%
% e.g. without grid lines: FUN_patch_2D( x, y, data, boundary_type, 'EdgeColor','none');

% V1.10 by LC, Support 2-D x/y input
% V1.00 By Lequan Chi

if FUN_is_1D(x)
    [x_b, x_width ]= FUN_grid_get_boundary_width_simple_interp( x, [] );
    [y_b, y_width ]= FUN_grid_get_boundary_width_simple_interp( y, [] );
    
elseif all( size(x) == size(y) ) & ndims( x ) == 2
    
    % gen boundaries from curve grid
    [x_b, y_b ] = FUN_grid_curve2D_gen_boundary_from_LON_LAT( x, y );
    
end
    
    
    data = squeeze( data );
    FUN_MAP_patch_2D_from_xb_yb( x_b, y_b, data, varargin{:} );
    
box on

% % % hold on
% % % for jj = 1:length(y)
% % %     for ii = 1:length(x)
% % %         if ~isnan( data(ii,jj) )
% % % %         x_tem = [ x_b(ii) x_b(ii+1) x_b(ii+1) x_b(ii)   x_b(ii)]';
% % % %         y_tem = [ y_b(jj) y_b(jj)   y_b(jj+1) y_b(jj+1) y_b(jj)]';
% % %         x_tem = [ x_b(ii) x_b(ii+1) x_b(ii+1) x_b(ii)  ]';
% % %         y_tem = [ y_b(jj) y_b(jj)   y_b(jj+1) y_b(jj+1) ]';
% % %         %patch(x_tem, y_tem, data(ii,jj), 'FaceColor','flat', 'EdgeColor','none');
% % %         patch(x_tem, y_tem, data(ii,jj), 'FaceColor','flat', varargin{:});
% % %         end
% % %     end
% % %     
% % % end






