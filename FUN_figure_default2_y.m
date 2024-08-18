function fig = FUN_figure_default2_y( height,varargin )

%% default setting =======================================
x0 = 100; % left
y0 = 100; % bottom
dx = 975;  % width
dy =  height; % height

%% x0, y0 will be reset to different values in pre-set computers --------
[x0, y0] = FUN_figure_default_x0y0( x0, y0 );


%% Open the figure
fig = figure( 'position', [x0, y0, dx, dy ], varargin{:} );
% fig = figure('position',[100,100,975,height]);

gcafontsize = 12;
set(gcf,'DefaultTextFontSize',gcafontsize)

set(gcf,'paperpositionMode','auto');
