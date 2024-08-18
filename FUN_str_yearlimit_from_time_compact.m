function str_out = FUN_str_yearlimit_from_time_compact( timelist )

str_out = [ datestr(min(timelist),'yyyy') '-' datestr( max(timelist), 'yyyy' ) ];