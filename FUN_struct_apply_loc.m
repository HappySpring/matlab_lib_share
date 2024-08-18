function data = FUN_struct_apply_loc( data, loc, exclude_fields )
% Cut selected data from all fields of a structure. 
% The selected field is defined by a logical matrix
% Only logical matrix is support at this point. 
%
% exclude_fields is optional.
%
% V1.10 L. Chi, 2020-10-14: Add exclude_fields.
% V1.01 Lequan Chi, 2019-01-17: The type of loc is checked first (must be
% logical)
% V1.00 Lequan Chi, 2017-07-26

% ---- Ini ----
if islogical(loc)
else
   error('Input loc must be a logical variable!') 
end

flag_is_changed = false;

% ------
field_list = fields( data );

if exist('exclude_fields','var') && ~isempty( exclude_fields )
    field_list = setdiff( field_list, exclude_fields );
end

% ------
for ii = 1:length( field_list );
   
    fn = field_list{ii};
    
    if length( data.(fn) ) == length( loc ) && FUN_is_1D(data.(fn) ) 
       data.(fn) = data.(fn)(loc); 
       flag_is_changed = true;
    end
    
end

if ~flag_is_changed
   error('Can not find any match!') 
end