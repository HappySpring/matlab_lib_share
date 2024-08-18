function data = FUN_struct_apply_ind( data, ind, exclude_fields )
% Cut selected data from all fields of a structure. 
% The selected field is defined by a logical matrix
% Only logical matrix is support at this point. 
%

% V1.10 L. Chi, 2020-10-14: Add exclude_fields.
% V1.00 Lequan Chi, 2017-07-26


field_list = fields( data );

if exist('exclude_fields','var') && ~isempty( exclude_fields )
    field_list = setdiff( field_list, exclude_fields );
end


for ii = 1:length( field_list );
   
    fn = field_list{ii};
    
    if FUN_is_1D( data.(fn) ) && all( isnumeric( data.(fn) ) )
       data.(fn) = data.(fn)(ind); 
       
    end
    
end