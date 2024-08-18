function days = FUN_time_get_days_in_year_int_365only( time_in )
% convert time in unit of days into time in unit of years.
% This assume 365 days a year. leap years will be ignored in counting days
% For days of Feb 29, it returns nan.

% V1.10 By L. Chi (L.Chi.Ocean@outlook.com)

if any(time_in<0)
    error('This does not work for BC');
end


[yy,mm, dd] = datevec( time_in );

days = fix( time_in - datenum(yy,1,1,0,0,0) ) + 1;

%% handle leap years


yearlist = unique(year( time_in ));

for iy = 1:length(yearlist)

    yn = yearlist(iy);
    if ~leapyear(yn)
        continue
    end

    time_feb29 = datenum( yn, 2, 29 );
    loc = floor(time_in) == time_feb29;
    days(loc) = nan;

    days( yy == yn & mm >= 3 ) = days( yy == yn & mm >= 3 ) - 1;


end


