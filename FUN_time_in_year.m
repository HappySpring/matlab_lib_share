function time_in_year = FUN_time_in_year( time_in )
% convert time in unit of days into time in unit of years.

[yy,~,~] = datevec( time_in );

days = time_in - datenum(yy,1,1,0,0,0);

time_in_year = yy + days ./ ( datenum(yy+1,1,1,0,0,0) - datenum(yy,1,1,0,0,0) );
