function timelimit_str = FUN_time_get_period_str( timelist, date_format )

time_0 = min( timelist );
time_1 = max( timelist );

timelimit_str = [ datestr( time_0, date_format ) ' - ' datestr( time_1, date_format ) ];