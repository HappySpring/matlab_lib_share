function data = FUN_Interp_by_area( x0, y0, data0, lat0, x, y )
%% 
% function data = M_FUN_Interp_by_area( x0, y0, data0, lat0, x, y );
% This function is used to interpolate data into given grids by area.
%
%  x0, y0: coordinate of the input grid
%  data0 : input data
%  x,  y : coordinate of the required grid
%  data  : output

% By Lequan Chi
%
%
% V1.1 lat must be a incresing variable for this function. 
% V1.0

%% For test only
% clear all
% close all
% clc
% 
% %
% x0 = [ 0.5 1.5 2.5 3.5 4.5 ];
% y0 = [ 1 3 5 7];
% data0 = rand( length(x0) , length(y0) );
% 
% x = [ 1.3 3.7 ];
% y = [ 2 4 6];

%% check

 if x0(2) < x0(1) | y0(2) < y0(1)
    error('lon/lat must be monotonic increasing.') 
 end

%% get coordinates of the boundaries

 [x0_b, x0_width] = FUN_grid_get_boundary_width( x0 );
 [y0_b, y0_width] = FUN_grid_get_boundary_width( y0 );

 [x_b, x_width] = FUN_grid_get_boundary_width( x );
 [y_b, y_width] = FUN_grid_get_boundary_width( y );

 
%% get the mask matrix for each grid. 

    mask_x = FUN_Interp_by_area_SUBFUN1_gen_1d_mask( x0, x );
    mask_x = repmat( mask_x, 1, 1, length(y0) );% [x, x0, y0]
    
    mask_y = FUN_Interp_by_area_SUBFUN1_gen_1d_mask( y0, y );
    mask_y = repmat( mask_y, 1, 1, length(x) );
    mask_y = permute( mask_y, [1 3 2]); % [y, x, y0]
    
    nanloc = isnan(data0);
    nanmask = double( ~nanloc );
    nanmask(nanmask == 0) = nan;
    nanmask = reshape( nanmask, [1 size(nanmask)]);
    
    mask_x = mask_x .* repmat( nanmask, [ size(mask_x,1) 1 1 ] );
    mask_y = mask_y .* repmat( reshape(cosd(lat0),1,1,[]), [size(mask_y,1) size(mask_y,2) 1] ); 
%% calc
    
    
    for ix = 1:length(x)
        data_count_x(ix,:) = nansum( squeeze(mask_x(ix,:,:)) ,1 );
        data_x(ix,:)       = nansum( squeeze(mask_x(ix,:,:)) .* data0, 1) ;
    end

    for iy = 1:length(y)
        data_count_xy(:,iy) = nansum( squeeze( mask_y(iy,:,:)) .* data_count_x  ,2 );
        data_xy(:,iy)       = nansum( squeeze( mask_y(iy,:,:)) .* data_x, 2) ;
    end
    
    % check ------------------------------------------
        %     [X_width, Y_width] = meshgrid( x_width, y_width);
        %     X_width = X_width';
        %     Y_width = Y_width';
    
        % if all( data_count_xy(:) == X_width(:) .* Y_width(:) )
        % else
        %     error('E01: error')
        % end
    % --------------------------------------------------
    
    
    data = data_xy ./ data_count_xy ; 
    
return
    