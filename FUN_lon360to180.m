function [lon180,  data180] = FUN_lon360to180(lon, data)
% [lon, data] = FUN_lon360to180(lon,data)
% input
%       lon: longitude of data. lon should be [1 x n] or [n x 1]
%       data: size of data should be [ length(lon) x ? x ? ... ]
% output:
%       lon
%       data
%
% V1.00 By Lequan Chi, 2015-06-23
%

% check -------------------------------------------------------------------
if length(lon) == size(data,1) 
else
   error('Dimension dismatch: dimension-1 of data should lon, lon itself should be 1 dimensional matrix') 
end

% preparation
lonsize = size(lon);

lon = reshape(lon,1,[]);

%% main part 
% transform
lon_eastloc = lon <= 180;
lon_westloc = lon >  180;

lon(lon>180) = lon(lon>180)-360;
lon180 = [ lon(lon_westloc) lon(lon_eastloc) ];

if ndims(data) == 1
    data180 = cat(1, data(lon_westloc),data(lon_eastloc));
elseif ndims(data) == 2
    data180 = cat(1, data(lon_westloc,:),data(lon_eastloc,:));
    
elseif ndims(data)==3
    data180 = cat(1, data(lon_westloc,:,:),data(lon_eastloc,:,:));
    
elseif ndims(data)==4
    data180 = cat(1, data(lon_westloc,:,:,:),data(lon_eastloc,:,:,:));
    
elseif ndims(data)==5
    data180 = cat(1, data(lon_westloc,:,:,:,:),data(lon_eastloc,:,:,:,:));
    
else
    error('dimension of data should be 2-5. Please modify the code if you want to deal with data with more dimensions.')
end


%% convert lon as its original size. 
lon = reshape(lon, lonsize);
