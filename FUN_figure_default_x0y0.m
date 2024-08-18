function [x0, y0] = FUN_figure_default_x0y0(x0, y0)
% [x0, y0] = FUN_figure_default_x0y0
% get default x0, y0 for figures
% this will be call by other FUN_figure_*.m

screensize = get(0,'MonitorPositions');

% single 2K monitor setup at studio room
if isequal( screensize, [ 1           1        2560        1440] ) % single 2K monitor
    x0 = 20;
    y0 = 50;
    
% two screen setup at office
elseif isequal( screensize, [1, 1, 1920, 1080; -1919, 1, 1920, 1080] )
    x0 = -1800;
    y0 = 50;
    
elseif exist('FUN_0_machine_info','file')
    env = FUN_0_machine_info;
    
    if strcmp( env.machine_name, 'Desktop_HS' )
        x0 = 2050;
        y0 = 30;
    elseif strcmp( env.machine_name, 'EdwardsLab_Lequan' )
        x0 = -1800;
        y0 = 50;
    end
    
else
    % the input x0, y0 will be unchanged.
end