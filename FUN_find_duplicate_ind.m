function dup = FUN_find_duplicate_ind( data );
% find the ind of the duplicate values.
% Note: Nan will be ignored.
% Refer to this page: https://www.mathworks.com/matlabcentral/answers/336500-finding-the-indices-of-duplicate-values-in-one-array
% V1.00


[~, uniqueInd] = unique( data );
dup_val = data( setdiff( 1:numel(data), uniqueInd ) );
dup_val = unique( dup_val );

if isempty( dup_val ) 
    dup = [];
else
    for ii = 1:length( dup_val );
       dup(ii).val = dup_val(ii);
       dup(ii).ind = find( data == dup(ii).val );
    end
end

