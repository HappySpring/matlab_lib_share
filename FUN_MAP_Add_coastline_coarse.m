function FUN_MAP_Add_coastline_coarse(lonlimit, latlimit, varargin )
%
%   FUN_MAP_Add_coastline_coarse : working by default completely (keep current lon/lat limit)
% Or
%   FUN_MAP_Add_coastline_coarse(lonlimit, latlimit, varargin )
%

% V1.13 add "set(gca,'layer','top');"
% V1.12 add support for input lon/lat instead of lonlimit latlimit
% V1.11 coast can be loaded from pre-generated data.
% V1.10 The function can be called without any parameter.
% 
%
% Add coastlines. varargins please refer to "doc patch"
% data from built-in matlab coastlines. 

%% Interface
if nargin == 0
   lonlimit = get( gca,'xlim' ) ;
   latlimit = get( gca,'ylim' ) ;
end

if isempty( lonlimit ) 
   lonlimit = get( gca,'xlim' ) ;
end

if isempty( latlimit ) 
   latlimit = get( gca,'ylim' ) ;
end

if length( lonlimit ) > 2
    lonlimit = [ min( lonlimit(:) ) max( lonlimit(:) ) ];
end


if length( latlimit ) > 2
    latlimit = [ min( latlimit(:) ) max( latlimit(:) ) ];
end

env = FUN_0_machine_info;

%%
if exist( 'shaperead','file')
    S = shaperead( 'landareas.shp','BoundingBox' ,[lonlimit(1) latlimit(1); lonlimit(2) latlimit(2)]);
elseif exist('Data_Preload_landareas.shp.mat','file')
    S = load('Data_Preload_landareas.shp.mat');
    S = S.S;
elseif exist( fullfile( env.Data_root_dir, 'Coastlines', 'GSHHS', 'GSHHS_shp' ) ,'dir')
    [~, S] = FUN_load_shp_files( lonlimit, latlimit, [], [], [] );
    
else
    error('shaperead.m doesn''t exist and pre-generated data cannot be found')
end

coast_lon = [S.X];
coast_lat = [S.Y];

if nargin >= 4
    FUN_MAP_Fill_Coastline(coast_lon',coast_lat', varargin{:});
else
    FUN_MAP_Fill_Coastline(coast_lon(:),coast_lat(:),'facecolor', [255 179 102]/255 );
end

FUN_Plot_xlim_fit(lonlimit);
FUN_Plot_ylim_fit(latlimit);

set(gca,'layer','top')
