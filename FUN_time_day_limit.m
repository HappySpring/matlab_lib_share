function timelimit = FUN_time_day_limit( time0 )
% timelimit = FUN_time_week_limit( time0, is_start_from_Sun )
% Find the limit of a week by providing one time
% V1.00 By Lq C 2019-03-04
%

% For Debug:
% time0(1) = datenum( 2019,3, 4 );
% time0(2) = datenum( 2019,2,4);


[yy,mm,dd] = datevec( time0 );
      
timelimit(:,1) = datenum(yy,mm, dd,0,0,0);   
timelimit(:,2) = datenum(yy,mm, dd,23,59,59.999);


