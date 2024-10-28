function dis = FUN_Sphere_distance(lat1,lon1,lat2,lon2,R)
% dis = FUN_Sphere_distance(lat1,lon1,lat2,lon2,R)
% Calculate the great circle distance from lon/lat
% R is optional. The default value is the radius of earth.

% By Lequan Chi.

% Example:
%   lat1 = 33;
%   lon1 = 120;
%   lat2 = 56;
%   lon2 = 180;
%   dis = FUN_Sphere_distance(lat1,lon1,lat2,lon2,R)
% 
% % For test only
% S = referenceSphere('unit sphere');
% S.Radius = 6371000;
% dis2 = distance( lat1,lon1,lat2,lon2,S);
%

%% Check the exist of input "R"
if exist('R','var')
else
    R = 6371000; % meters, Radius of earth.
end


%% Calc
% Refer to Wikipedia
% https://en.wikipedia.org/wiki/Great-circle_distance
% #1 basic eq 
% alpha = acos( sind(lat1).*sind(lat2) + cosd(lat1).*cosd(lat2).*cosd(lon2-lon1) );
% #2 more accurate eq.
dlon = abs(lon2-lon1);
Y =    ( cosd( lat2 ) .* sind( dlon ) ).^2 ...
     + ( cosd(lat1) .* sind(lat2) - sind(lat1) .* cosd(lat2) .* cosd( dlon ) ).^2;
Y = sqrt(Y);
X = sind(lat1) .* sind(lat2) + cosd(lat1) .* cosd( lat2) .* cosd( dlon ); 
alpha = atan2( Y, X );
dis   = alpha .* R;

%% double check
if any( alpha < 0 ) | any( alpha > pi )
   error('Unexpected values of alpha!') 
end

% alpha_degree = alpha./pi*180
