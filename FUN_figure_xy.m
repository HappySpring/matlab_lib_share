function fig = FUN_figure_xy(dx,dy,varargin)
% V1.00 by LC

%% default setting =======================================
x0 = 100; % left
y0 = 50; % bottom
% dx = 975;  % width%
% dy =  400; % height%

%% x0, y0 will be reset to different values in pre-set computers --------
if exist('FUN_0_machine_info','file')
   env = FUN_0_machine_info;
   
   if strcmp( env.machine_name, 'Desktop_HS' )
      x0 = 2080;
      y0 = 50;
   end
    
end


%% Open the figure
fig = figure( 'position', [x0, y0, dx, dy ], varargin{:} );

gcafontsize = 12;
set(gcf,'DefaultTextFontSize',gcafontsize)

set(gcf,'paperpositionMode','auto');
