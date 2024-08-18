function [ time2, unit_str ] = FUN_time_to_diff_unit( time, unit, time_ref )


time2 = time - time_ref;

if strcmpi( unit, 'day' );
    unit_str = [ 'days since ' datestr( time_ref, 'yyyy-mm-dd HH:MM:SS') ] ;

elseif strcmpi( unit, 'hour' );
    time2 = time2 * 24;
    unit_str = [ 'hours since ' datestr( time_ref, 'yyyy-mm-dd HH:MM:SS') ] ;
    
elseif strcmpi( unit, 'minute' );
    time2 = time2 * 24 * 60 ;
    unit_str = [ 'minutes since ' datestr( time_ref, 'yyyy-mm-dd HH:MM:SS') ] ;
    
elseif strcmpi( unit, 'second' );
    time2 = time2 * 24 * 3600 ;
    unit_str = [ 'seconds since ' datestr( time_ref, 'yyyy-mm-dd HH:MM:SS') ] ;
    
else
   error('The unit is not supported by this function'); 
   
end

