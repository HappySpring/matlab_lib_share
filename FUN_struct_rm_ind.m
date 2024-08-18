function data = FUN_struct_rm_ind( data, ind, exclude_fields )
% remove data at certain locations from all fields of a structure. 

% Edited from FUN_struct_apply_ind.m (v1.10)


field_list = fields( data );

if exist('exclude_fields','var') && ~isempty( exclude_fields )
    field_list = setdiff( field_list, exclude_fields );
end


for ii = 1:length( field_list );
   
    fn = field_list{ii};
    
    if FUN_is_1D( data.(fn) ) && all( isnumeric( data.(fn) ) )
       data.(fn)(ind) = []; 
       
    end
    
end