function [lon, lat, depth] = FUN_Dataset_GEBCO( file_Address, lonlimit, latlimit )
% [lon, lat, depth] = FUN_Dataset_GEBCO( file_Address, lonlimit, latlimit )
% Load depth data from GEBCO 2014. (GEBCO 08 is not supportted by this function)
% 
% INPUT:
%      file_Address: the address of the GEBCO 2014, e.g., 'I:\Data\GEBCO\GEBCO_2014\GEBCO_2014_2D.nc'
%      lonlimit/latlimit: [-180 to 180] 
%

% V1.20 22024-09-30 by L. Chi: update default GEBCO file path
% V1.10 2021-01-11 by L. Chi: support reading data cross 180deg.
% V1.00 2016-07-10 By Lequan Chi

%% debug only
% lonlimit = [-100 -50];
% latlimit = [0 50];

%%
if isempty( file_Address ) % Default address will be used if "file_Address" is empty
    Data_root_dir = FUN_0_machine_info;
    
    if isfield(Data_root_dir,'Data_basic')
        file_Address = fullfile( Data_root_dir.Data_basic, 'GEBCO','GEBCO_2022.nc' );

        if exist( file_Address, 'file' )
            is_file_found = true;
        else
            is_file_found = false;
        end
    end

    if ~is_file_found

        Data_root_dir = Data_root_dir.Data_root_dir;
        file_Address = fullfile( Data_root_dir, 'GEBCO', 'gebco_2020_netcdf', 'GEBCO_2020.nc' );

        if exist( file_Address, 'file' )
            is_file_found = true;
        else
            is_file_found = false;
        end
    end

    if ~is_file_found

        file_Address = fullfile( Data_root_dir, 'GEBCO', 'GEBCO_2014', 'GEBCO_2014_2D.nc' );

        if exist( file_Address, 'file' )
            is_file_found = true;
        else
            is_file_found = false;
        end
    end

    if ~is_file_found
        error('GEBCO file cannot be found!')
    end
    
end

% loading data
if all(lonlimit<=180)

    [ out_dim, depth ] = FUN_nc_varget_enhanced_region_2( file_Address, 'elevation', {'lon','lat'}, {lonlimit latlimit} );
    lon = out_dim.lon;
    lat = out_dim.lat;

elseif all(lonlimit>180)
    
    lonlimit = lonlimit-360;
    [ out_dim, depth ] = FUN_nc_varget_enhanced_region_2( file_Address, 'elevation', {'lon','lat'}, {lonlimit latlimit} );

    lon = out_dim.lon+360;
    lat = out_dim.lat;

else
    
    lonlimit1 = [lonlimit(1) 180];
    [ out_dim, depth ] = FUN_nc_varget_enhanced_region_2( file_Address, 'elevation', {'lon','lat'}, {lonlimit1 latlimit} );

    lonlimit2 = [-180+1e-10, lonlimit(2)-360];

    [ out_dim2, depth2 ] = FUN_nc_varget_enhanced_region_2( file_Address, 'elevation', {'lon','lat'}, {lonlimit2 latlimit} );
     out_dim2.lon = out_dim2.lon + 360;  
    
    lon = [out_dim.lon; out_dim2.lon];
    lat = out_dim.lat;
    
    depth = [depth; depth2];
end





%% debug only - plot
% figure
% cbarid = FUN_pcolor_2Dlonlat(lon,lat,depth);
% hold on
% contour(lon,lat,depth',[0 inf],'-k','linewidth',1)
% 
% set( get(cbarid,'ylabel'),'string','Depth (m)','fontsize',12)
% FUN_relative_position_text(0.02, 0.05,'GEBCO')