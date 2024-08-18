function time_out = FUN_time_get_0am_of_the_day( time_in );

[year, month, day, hh, mm, ss ] = datevec( time_in );

time_out = datenum( year, month, day );