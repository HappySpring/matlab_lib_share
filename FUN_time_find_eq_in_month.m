function match_ind = FUN_time_find_eq_in_month( timelist, time_required )
% timelist is a MxN or NxM matrix
% time_required is 1x1.
% both the two above must be given in the unit of matlab date

timelist = timelist(:);

if FUN_is_1D( timelist )
else
   error('timelist must be 1D!') 
end

if length( time_required ) == 1
else
   error('time_required must be 1x1!'); 
end

monthind_list = FUN_time_get_month_ind( timelist );
month_ind_required = FUN_time_get_month_ind( time_required );

match_ind = find( monthind_list == month_ind_required );