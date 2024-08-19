function [X_OUT, Y_OUT] = FUN_MAP_load_GSHHS_coastlines(fileaddress, xlimit, ylimit);
%
%% For debug Only
% clear all
% close all
% clc
% 
% fileaddress = 'D:\basic_data\GSHHS\GSHHS_shp\f\GSHHS_f_L1.shp'
% xlimit = [ 80 150 ];
% ylimit = [  0 80  ];
% 

% load data
S = shaperead(fileaddress,'BoundingBox',[xlimit(1) ylimit(1); xlimit(2) ylimit(2)]);

% delete points out of assigned region. 
for ii = 1:length( S )
    tem_xloc = ( S(ii).X < xlimit(1)  |  S(ii).X > xlimit(2) );
    tem_yloc = ( S(ii).Y < ylimit(1)  |  S(ii).Y > ylimit(2) );
    tem_loc = tem_xloc | tem_yloc ;
    
    tem_ind = find( tem_loc == 1);
    tem_delete_ind =  tem_ind(2:end) - tem_ind(1:end-1) == 1 ;
    tem_delete_ind = tem_ind(tem_delete_ind);
    
    isdoublecheck = 1; % Double check to make sure only nan points can be deleted. 
    if isdoublecheck == 1
            S(ii).X(tem_loc) = nan;
            S(ii).Y(tem_loc) = nan; 
            if sum( isnan( S(ii).X(tem_delete_ind) ) ) == length( S(ii).X(tem_delete_ind) ) && ...
                     sum( isnan( S(ii).Y(tem_delete_ind) ) ) == length( S(ii).Y(tem_delete_ind) ) 
            else
                error('Error #2: Non-nan value may be deleted!')
            end
    end
    
    S(ii).X(tem_delete_ind) = [];
    S(ii).Y(tem_delete_ind) = [];
    
   
    
    
    
    clear tem_xloc tem_yloc tem_loc  tem_nan_group tem_delete_ind
end

X_OUT = [S.X];
Y_OUT = [S.Y];


return