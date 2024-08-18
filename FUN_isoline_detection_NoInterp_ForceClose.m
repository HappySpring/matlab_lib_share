function isoline = FUN_isoline_detection_NoInterp_ForceClose( x, y,  data, isoline_value, fillvalue )


% # check =================================================================
if FUN_is_1D(x)
    
else
   error('This only support 1-D data now'); 
end

% # close data by fillvalue to make sure the output contours are closed ===

Nx = size(data,1);
Ny = size(data,2);

tem_data2 = fillvalue .* ones( Nx+2, Ny+2 );
tem_data2(2:end-1, 2:end-1) = data;

x2 = [ 2*x(1)-x(2), x(:)', 2*x(end)-x(end-1) ];
y2 = [ 2*y(1)-y(2), y(:)', 2*y(end)-y(end-1) ];


% # Contour without interpolation
isoline = FUN_isoline_detection_NoInterp( x2, y2,  tem_data2, isoline_value, fillvalue );
