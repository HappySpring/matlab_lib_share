function data_empty = FUN_sturct_create_empty_table_from_example( data_in )
% data_empty = FUN_sturct_create_empty_table_from_example( data_in )
%
% This will create an empty table with same structure of "data_in"
% 
% You can extend this table by repmat( data_empty, N, 1 );

% V1.00 by L. Chi (L.Chi.Ocean@outlook.com)

%% initialization

% select the first row as template.
data_in = data_in(1,:);

% preparation
vlist = data_in.Properties.VariableNames;
data_empty = table;


%% create empty table 
for ii = 1:length( vlist )
   
    vn = vlist{ii};
    
    if iscell( data_in.(vn) )
        data_empty.(vn) = { nan };
    elseif isstruct( data_in.(vn) )
        data_empty.(vn) = IFUN_define_empty_struct_recursive( data_in.(vn) );
    else
        data_empty.(vn) = nan ;
    end     

end

%% 
% =========================================================================
% Subfunction
% =========================================================================
function var_out = IFUN_define_empty_struct_recursive( var_in )
% var_out = IFUN_define_empty_struct_recursive( var_in )
%
% set all values of a struct to nan recursively. 
% 

vlist2 = fields( var_in );

for ss = 1:length( vlist2 )
    
    fln2 = vlist2{ss};
    
    if isstruct( var_in.(fln2) )
        var_out.(fln2) = IFUN_define_empty_struct_recursive( var_in.(fln2) );
    else
        var_out.(fln2) = nan;
    end

end






