function [lon360,  data360] = FUN_lon180to360(lon, data)
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
lon_180360 = lon <  0;
lon_0180 = lon >= 0;

lon(lon_180360) = lon(lon_180360)+360;
lon360 = [ lon(lon_0180) lon(lon_180360) ];

if ndims(data) == 1
    data360 = cat(1, data(lon_0180),data(lon_180360));
    
elseif ndims(data) == 2
    data360 = cat(1, data(lon_0180,:),data(lon_180360,:));
    
elseif ndims(data)==3
    data360 = cat(1, data(lon_0180,:,:),data(lon_180360,:,:));
    
elseif ndims(data)==4
    data360 = cat(1, data(lon_0180,:,:,:),data(lon_180360,:,:,:));
    
elseif ndims(data)==5
    data360 = cat(1, data(lon_0180,:,:,:,:),data(lon_180360,:,:,:,:));
    
else
    error('dimension of data should be 2-5. Please modify the code if you want to deal with data with more dimensions.')
end


%% convert lon as its original size. 
lon = reshape(lon, lonsize);
