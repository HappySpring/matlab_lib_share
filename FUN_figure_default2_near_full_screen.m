function fig = FUN_figure_default2_near_full_screen(varargin)

%% default setting =======================================
x0 = 100; % left
y0 = 0; % bottom
dx = 1800;  % width
dy =  1000; % height

%% x0, y0 will be reset to different values in pre-set computers --------
if exist('FUN_0_machine_info','file')
   env = FUN_0_machine_info;
   
   if strcmp( env.machine_name, 'Desktop_HS' )
      x0 = 1975;
      y0 = 0;
   end
    
end


%% Open the figure
fig = figure( 'position', [x0, y0, dx, dy ], varargin{:} );

gcafontsize = 12;
set(gcf,'DefaultTextFontSize',gcafontsize)

set(gcf,'paperpositionMode','auto');
