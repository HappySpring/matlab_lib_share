function time_out = FUN_time_hour_ind_with_ref_2_time( hour_ind, time_ref );

time_out = double( hour_ind ) ./ 24 + time_ref;
