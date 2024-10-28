function dis = FUN_Sphere_distances_integrated( lon1, lat1)
% dis = FUN_Sphere_distances_integrated( lon1, lat1)
% distance along a line given by (lon1,lat1)
%
%
% V1.01 10/19/2020: replace FUN_is_1D by matlab built-in function isvector
% V1.00 10/17/2017 by L. Chi

%% check

if size(lon1) == size( lat1 )
else
   error('E92:lon1, lat1 must share same size') 
end

if isvector( lon1 ) && isvector( lat1 )
else
   error('E93: only 1-D lon1, lat1 are supported now.');
end

%%
dis    = nan( size(lon1) );
dis(1) = 0 ; 
for ii = 2:length( lon1 )
    dis(ii) = dis(ii-1) + FUN_Sphere_distance( lat1(ii), lon1(ii), lat1(ii-1), lon1(ii-1) );
end
