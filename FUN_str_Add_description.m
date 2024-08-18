function  [ strid, axes_id ] = FUN_str_Add_description(x, y, str, varargin );
% Add more description to the figure
% 
% V1.00
% By Lequan Chi, 2015-11-30

tem_gca_previous = gca;

axes_id = axes( 'position', [ x, y, 0.1, 0.05 ] );
xlim([0 1]);
ylim([0 1])
strid = text( 0, 0.5, str, varargin{:} );

axis off

set(gcf,'currentAxes',tem_gca_previous);


