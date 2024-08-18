function time_out = FUN_time_get_235959_of_the_day( time_in );

[year, month, day, ~, ~, ~ ] = datevec( time_in );

time_out = datenum( year, month, day, 23, 59, 59 );