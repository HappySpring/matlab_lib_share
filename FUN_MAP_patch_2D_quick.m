function cbar = FUN_MAP_patch_2D_quick( x, y, data, x0, y0, varargin )


[x_b, y_b] = FUN_MAP_patch_2D( x, y, data, x0, y0, varargin{:} );

set(gca,'fontsize',12);
set(gca,'layer','top');
cbar = colorbar;
FUN_Plot_colormap_new;

xlabel( 'Longitude (\circ)', 'fontsize',14);
ylabel( 'Latitude (\circ)', 'fontsize',14);

xlim( [ min(x_b) max(x_b) ] )
ylim( [ min(y_b) max(y_b) ] )







