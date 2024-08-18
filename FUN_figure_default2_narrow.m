function fig = FUN_figure_default2_narrow(varargin)
% open a figure with just enough width for 300 dpi printing with -m2
% V1.1 By Lequan Chi, 2017-12-05

%% default setting =======================================
x0 = 100; % left
y0 = 350; % bottom
dx = 975;  % width
dy =  400; % height

%% x0, y0 will be reset to different values in pre-set computers --------
[x0, y0] = FUN_figure_default_x0y0( x0, y0 );



%% Open the figure
fig = figure( 'position', [x0, y0, dx, dy ], varargin{:} );

gcafontsize = 12;
set(gcf,'DefaultTextFontSize',gcafontsize);

set(gcf,'paperpositionMode','auto');
