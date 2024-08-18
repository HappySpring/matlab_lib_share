function lon_str = FUN_str_lon( lon, num_format )

if ~exist('num_format','var') || isempty(num_format)
    num_format = '%f';
end

if lon > 180
    error('Input longitude must be in the range of -180 to 180');
end

% Input must be -180 to 180

if lon > 0 
    lon_str = [num2str(lon,num_format) '\circE'];
elseif lon < 0
    lon_str = [num2str(-lon,num_format) '\circW'];    
elseif lon == 0
    klon_str = [num2str(lon,num_format) '\circ'];    
end