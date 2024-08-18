function ind = FUN_subset_get_its_ind_in_original_array( x_sub, x_raw )
% ind = FUN_subset_get_its_ind_in_original_array( x_sub, x_raw )
% 
%  if lon is a sebset of lon0 (e.g., lon = lon0(10:20)), then 
%   "ind = FUN_subset_get_its_ind_in_original_array( x_sub, x_raw ) "
%  returns ind = 10:20.
%

[ is_mbr, ind ] = ismember( x_sub, x_raw ) ;

if all( is_mbr )
    % pass
else
    error( 'Input x_sub must be a subset of x_raw!');
end

if all( diff(ind) == 1)
else
    error
end

