function cbar = FUN_MAP_patch_2D_simpleinterp_quick( x, y, data, varargin )
%  'EdgeColor','none' 

[x_b, y_b] = FUN_MAP_patch_2D_simpleinterp( x, y, data, varargin{:} );

set(gca,'fontsize',12);
set(gca,'layer','top');
cbar = colorbar;
FUN_Plot_colormap_new;

xlabel( 'Longitude (\circ)', 'fontsize',14);
ylabel( 'Latitude (\circ)', 'fontsize',14);

xlim( [ min(x_b(:)) max(x_b(:)) ] )
ylim( [ min(y_b(:)) max(y_b(:)) ] )







