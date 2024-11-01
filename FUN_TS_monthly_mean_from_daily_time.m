function [year_out, month_out, monthly_mean] = FUN_TS_monthly_mean_from_daily_time( time_in, data_in, min_limit_per_month )
% [year_out, month_out, monthly_mean] = FUN_TS_monthly_mean_from_daily_time( time_in, data_in, min_limit_per_month )


[year_in, month_in, day_in] = datevec( time_in );
[year_out, month_out, monthly_mean] = FUN_TS_monthly_mean_from_daily( year_in, month_in, day_in, data_in, min_limit_per_month );