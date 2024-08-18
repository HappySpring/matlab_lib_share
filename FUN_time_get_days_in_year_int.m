function days = FUN_time_get_days_in_year_int( time_in )
% convert time in unit of days into time in unit of years.
%

% V1.00 By L. Chi (L.Chi.Ocean@outlook.com)

if any(time_in<0)
    error('This does not work for BC');
end


[yy,~,~] = datevec( time_in );

days = fix( time_in - datenum(yy,1,1,0,0,0) ) + 1;

