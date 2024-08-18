function [x_b, y_b] = FUN_MAP_patch_2D( x, y, data, x0, y0, varargin )
% Plot grid color based on its original grid size
%
% INPUT: x, y, data
%        x0, y0: south-western boundary of the grid ( x(1), y(1) )  (optional)
%        addtional options for field
%
% e.g. without grid lines: FUN_patch_2D( x, y, data, boundary_type, 'EdgeColor','none');

% V1.00 By Lequan Chi
    
%% ==== ## set default values ====
    if ~exist('x0','var')
        x0 = [];
    end
    
    if ~exist('y0','var')
        y0 = [];
    end
        
%% ==== ## prepare boundaries ====

    [x_b, x_width ]= FUN_grid_get_boundary_width( x, x0 );
    [y_b, y_width ]= FUN_grid_get_boundary_width( y, y0 );
    
%% ==== ## plot ====
    data = squeeze( data );
    FUN_MAP_patch_2D_from_xb_yb( x_b, y_b, data, varargin{:} );
    
%% ==== ## others ====
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






