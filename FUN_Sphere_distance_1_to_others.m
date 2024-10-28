function dis = FUN_Sphere_distance_1_to_others( lon0, lat0, lon1, lat1)
% distance betwen (lon0, lat0) and all points defined by (lon1,lat1);
% V1.00 2017-04-20

%% check
if all( size(lon0) ) == 1 && all( size( lat0 ) == 1 )
else
   error('E91: lon0 & lat0 cannot be matrix') 
end

if size(lon1) == size( lat1 );
else
   error('E92:lon1, lat1 must share same size') 
end

if FUN_is_1D( lon1 ) && FUN_is_1D( lat1 )
else
   error('E93: only 1-D lon1, lat1 are supported now.');
end

%%
dis = nan( size(lon1) );
for ii = 1:length( lon1 )
    dis(ii) = FUN_Sphere_distance( lat1(ii), lon1(ii), lat0, lon0 );
end
