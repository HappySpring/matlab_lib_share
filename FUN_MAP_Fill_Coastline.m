function [maskbound, hd_patch] = FUN_MAP_Fill_Coastline(lon_coast,lat_coast,varargin)
% same as Coastline_fill
% By Lequan Chi
%
% lon_coast = coastline.lon;
% lat_coast = coastline.lat;

lon_coast = lon_coast(:);
lat_coast = lat_coast(:);

% check 
if isnan(lon_coast(end))
    lon_coast(end) = [];
end

if isnan(lat_coast(end))
    lat_coast(end) = [];
end

%
nanloc = find(isnan(lon_coast));
coastN = length(nanloc) + 1;


NN = 0;
for coast_i=1:coastN
    if coast_i==1
        beg_bound = 1;
    else
        beg_bound = nanloc(coast_i-1)+1;
    end
    
    if coast_i == coastN
        end_bound = length(lon_coast);
    else
        end_bound = nanloc(coast_i)-1;
    end
    
    NN = NN + 1;
    tem_lon = [lon_coast(beg_bound:end_bound);lon_coast(beg_bound)];
    tem_lat = [lat_coast(beg_bound:end_bound);lat_coast(beg_bound)];
    
    maskbound(NN).lon = tem_lon;
    maskbound(NN).lat = tem_lat;    
    
    hold on
    hd_patch(NN) = patch( tem_lon,tem_lat, nan(length(tem_lon),1),varargin{:});
end