function count_day = FUN_time_tot_day_of_month( time_in )
% Number of days in a specific month given by time.
% time_in: built-in time unit in matlab (days from 0000-00-00)


[yy,mm,~,~,~] = datevec( time_in );
count_day = datenum( yy, mm+1, 1 ) - datenum( yy, mm, 1 );
