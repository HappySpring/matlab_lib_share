function se_ind = FUN_time_get_se_ind( timelist )
% The timelist is supposed to located at the middle of each month. And
% seasons should begin with DJF or JFM.

[yearlist, monthlist, ~] = datevec( timelist );

if any( monthlist == 3 | monthlist == 6 |  monthlist == 9 | monthlist == 12 ) 
   error('Only seasons start with DJF or JFM are acceptable.')
end

se_ind = yearlist * 4 + floor( monthlist/3 );