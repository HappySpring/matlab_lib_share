function [ time, year, month ] = FUN_time_month_ind2time( month_ind, day_of_month )

if ~exist('day_of_month','var') || isempty( day_of_month )
    day_of_month = 16;
end

year = floor( month_ind ./ 12 );
month = mod( month_ind, 12 ) ;

loc = month == 0;
year(loc) = year(loc) - 1 ;
month(loc)= 12;

time = datenum( year, month, day_of_month );