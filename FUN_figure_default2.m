function fig = FUN_figure_default2(varargin)


%% default setting =======================================
x0 = 100; % left
y0 = 100; % bottom
dx = 975;  % width
dy =  550; % height

%% x0, y0 will be reset to different values in pre-set computers --------
[x0, y0] = FUN_figure_default_x0y0( x0, y0 );

%% =====================================
fig = figure('position',[x0, y0, dx, dy ], varargin{:} );

gcafontsize = 12;
set(gcf,'DefaultTextFontSize',gcafontsize)

set(gcf,'paperpositionMode','auto');



%% =====================================
% fig = figure('position',[100 100 975 550 ] );