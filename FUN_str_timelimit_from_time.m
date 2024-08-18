function str_out = FUN_str_timelimit_from_time( timelist, time_format, connectiong_str )
% V1.1: Add 
%

if ~exist('time_format','var') || isempty( time_format )
    time_format = 'yyyy-mm-dd';
end

if ~exist('connectiong_str','var') || isempty( connectiong_str )
    connectiong_str = ' - ';
end


% 

t_min = min(timelist);
t_max = max(timelist);

if isinf( t_min )
    if t_min > 0
        tem1 = ['+inf'];
    elseif t_min < 0
        tem1 = ['-inf'];
    else
        error
    end
else
    tem1 = datestr(t_min,time_format);
end


if isinf( t_max )
    if t_max > 0
        tem2 = ['+inf'];
    elseif t_max < 0
        tem2 = ['-inf'];
    else
        error
    end
else
    tem2 = datestr(t_max,time_format);
end

str_out = [ tem1, connectiong_str, tem2 ];