function time_loc = FUN_time_apply_timelimit( timelist, timelimit )


if timelimit(1) > timelimit(2)
   error('timelimit(1) should not be greater than timelimit(2)'); 
end

if length( timelimit ) ~= 2
    error;
end

time_loc = timelist >= timelimit(1) & timelist <= timelimit(2);
