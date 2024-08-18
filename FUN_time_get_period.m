function [timelimit, yearlimit, monthlimit, daylimit ] = FUN_time_get_period( timelist )

time_0 = min( timelist );
time_1 = max( timelist );

timelimit = [ time_0 time_1 ];
[ yearlimit, monthlimit, daylimit ] = datevec( timelimit );
