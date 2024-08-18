function timelimit = FUN_time_month_limit( time0 )
% timelimit = FUN_time_month_limit( time0, is_start_from_Sun )
% Find the limit of a week by providing one time
% V1.00 By Lq C 2019-03-04
%



[yy,mm,dd] = datevec( time0 );
      
timelimit(:,1) = datenum(yy,mm  , 1, 0, 0, 0 );   
timelimit(:,2) = datenum(yy,mm+1, 1, 0, 0, 0 ) - 1 / 24 / 3600 / 1000;

% datestr( timelimit)
