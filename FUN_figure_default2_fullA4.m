function fig = FUN_figure_default2_fullA4(varargin)

%% default setting =======================================
x0 = 100; % left
y0 = 0; % bottom
dx = 975;  % width
dy =  1550; % height

%% x0, y0 will be reset to different values in pre-set computers --------
if exist('FUN_0_machine_info','file')
   env = FUN_0_machine_info;
   
   if strcmp( env.machine_name, 'Desktop_HS' )
      x0 = 1975;
      y0 = 0;
   elseif strcmp( env.machine_name, 'EdwardsLab_Lequan' )
      x0 = -1000;
      y0 = 10;
   end
    
end


%% Open the figure
fig = figure( 'position', [x0, y0, dx, dy ], varargin{:} );

gcafontsize = 12;
set(gcf,'DefaultTextFontSize',gcafontsize)

set(gcf,'paperpositionMode','auto');
