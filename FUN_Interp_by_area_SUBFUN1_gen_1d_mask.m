function mask_x = FUN_Interp_by_area_SUBFUN1_gen_1d_mask( x0, x )
% subfunction specific for M_FUN_Interp_by_area
% This function is used to generate the mask in each dimension.
%
%  x0, y0: coordinate of the input grid
%  data0 : input data
%  x,  y : coordinate of the required grid
%  data  : output

% By Lequan Chi
%
% V1.0
%% For test only
% x0 = [ 0.5 1.5 2.5 3.5 4.5 ];
% x = [ 1.3 3.7 ];
%
%% get coordinates of the boundaries

 [x0_b, x0_width] = FUN_grid_get_boundary_width( x0 );
 % [y0_b, y0_width] = M_FUN_grid_get_boundary_width( y0 );

 [x_b, x_width] = FUN_grid_get_boundary_width( x );
 % [y_b, y_width] = M_FUN_grid_get_boundary_width( y );

 
%% get the mask matrix for each grid. 

mask_x = zeros( length(x), length(x0) ); % mask_x(i,j) means the 
% mask_y = zeros( length(y), length(y0) );

for ig = 1 : length( x )
    
    ind_0 = find( x0_b > x_b(ig)   );
    ind_0 = min(ind_0);
    ind_1 = find( x0_b < x_b(ig+1) );
    ind_1 = max(ind_1);
    
    if ind_0 == ind_1 % condition #1 --------------------------------------
      
        if ind_0 == 1
            mask_x(ig,ind_0)   = x_b(ig+1) -   x0_b(ind_0) ; %x0_width(ind_0);
        elseif  ind_1 == length( x0_b )
            mask_x(ig,ind_1-1) =  x0_b(ind_1) - x_b(ig) ;  % x0_width(ind_1-1);
        else
            mask_x(ig,ind_0-1) = x0_b(ind_0) - x_b(ig) ; 
            mask_x(ig,ind_1  ) = x_b(ig+1) -   x0_b(ind_1)  ; 
        end          
    
    elseif ind_0 < ind_1 % condition  #2 ----------------------------------
       
        if ind_0 == 1
        else
            mask_x( ig, ind_0-1 ) = x0_b(ind_0) - x_b(ig) ; 
        end
        
        if ind_1 == length( x0_b )
        else
            mask_x( ig, ind_1 )  = x_b(ig+1) -   x0_b(ind_1)  ; 
        end
        
        mask_x(ig, ind_0:ind_1-1) = x0_width(ind_0:ind_1-1);
        
    elseif ind_0 > ind_1 % condition  #3 ----------------------------------
        mask_x(ig,ind_1) = x_width(ig) ;
    elseif isempty( ind_0 ) | isempty( ind_1)
        
    else % error condition ------------------------------------------------
        error('Unpredicted condition, please check the codes above!')
    end


    
    
             
    clear ind_0 ind_1
end












