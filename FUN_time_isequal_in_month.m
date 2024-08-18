function is_time_match = FUN_time_isequal_in_month(timelist1, timelist2)

timelist1 = timelist1(:);
timelist2 = timelist2(:);

[year1, month1, ~] = datevec( timelist1 );
[year2, month2, ~] = datevec( timelist2 );

if isequal( year1, year2) && isequal( month1, month2 )
    is_time_match = true;
else
    is_time_match = false;
end