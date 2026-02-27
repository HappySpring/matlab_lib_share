function [coast_lon, coast_lat] = FUN_MAP_Add_coastline_coarse_V2(lonlimit, latlimit, is_save_temfile, varargin )
%   FUN_MAP_Add_coastline_coarse : working by default completely (keep current lon/lat limit)
%   FUN_MAP_Add_coastline_coarse(lonlimit, latlimit, is_save_temfile, ... )
%
% INPUT: 
%       lonlimit
%       latlimit
%       is_save_temfile
%    others:
%       ShpFile: load the coastline from specific .shp file
%
% OUTPUT:
%
%

% V1.18 add new parameter: "is_plot"; update codes for reading optional
%                              parameters
% V1.17 fix a bug related to variable "M"
% V1.16 is_save_temfile accept output filename as input
% V1.15 ignore empty coastlines
% V1.14 The pre-generated file will be loaded if it existed.
% V1.13 add "set(gca,'layer','top');"
% V1.12 add support for input lon/lat instead of lonlimit latlimit
% V1.11 coast can be loaded from pre-generated data.
% V1.10 The function can be called without any parameter.
% 
%
% Add coastlines. varargins please refer to "doc patch"
% data from built-in matlab coastlines. 

%% find parameters

% ShpFile = [];
% ghssh_resolution = [];
% rm_id = [];
% for ii = 1:2:length(varargin)
%    if strcmpi(varargin{ii},'ShpFile')
%        ShpFile = varargin{ii+1};
%        rm_id = [ii, ii+1];
%    end
%    
%    if strcmpi(varargin{ii},'gshhs_resolution')
%        ghssh_resolution = varargin{ii+1};
%        rm_id = [ii, ii+1];
%    end
%    
% end
% varargin(rm_id)=[];

is_rm_loadedd_param = true;
[is_plot, varargin] = FUN_codetools_read_from_varargin( varargin, 'is_plot', true, is_rm_loadedd_param );
[ShpFile, varargin] = FUN_codetools_read_from_varargin( varargin, 'ShpFile', [], is_rm_loadedd_param );
[ghssh_resolution, varargin] = FUN_codetools_read_from_varargin( varargin, 'gshhs_resolution', [], is_rm_loadedd_param );

%% Interface

if ~exist('lonlimit','var') || isempty( lonlimit )
   lonlimit = get( gca,'xlim' ) ;
end

if ~exist('latlimit','var') || isempty( latlimit )
   latlimit = get( gca,'ylim' ) ;
end


if length( lonlimit ) > 2
    lonlimit = [ min( lonlimit(:) ) max( lonlimit(:) ) ];
end


if length( latlimit ) > 2
    latlimit = [ min( latlimit(:) ) max( latlimit(:) ) ];
end


if ~exist('is_save_temfile','var') || isempty( is_save_temfile )
    is_save_temfile = false;
    
elseif ischar( is_save_temfile )
    tem_filename = is_save_temfile; 
    is_save_temfile = true;
    
else
    is_save_temfile = logical( is_save_temfile );
    tem_filename = 'TEM_coastline_preloaded_dfau48fsa.mat';
    
end


%%
use_data_from_preload_mat = false;

if is_save_temfile && exist( fullfile( '.', tem_filename ),'file')
    data0 = load(  fullfile( '.', tem_filename ) );
    if isequal( lonlimit, data0.lonlimit ) && isequal( latlimit, data0.latlimit )
        use_data_from_preload_mat = true;
    end
end

%%

if use_data_from_preload_mat
    coast_lon = data0.coast_lon;
    coast_lat = data0.coast_lat;
else

    path_gshhs=[];
    if exist( 'FUN_0_machine_info','file' ) == 2
        env = FUN_0_machine_info;

        path_gshhs = fullfile( env.Data_root_dir, 'Coastlines', 'GSHHS', 'GSHHS_shp' );
        if ~exist( path_gshhs, 'dir' )
            path_gshhs = fullfile( env.Data_basic, 'GSHHS', 'GSHHS_shp' );

            if ~exist( path_gshhs, 'dir' )
                path_gshhs = [];
            end
        end

    end
    % if exist('Data_Preload_landareas.shp.mat','file')
    %     S = load('Data_Preload_landareas.shp.mat');
    %     S = S.S;
    if ~isempty(ShpFile)
        % -- load specific shp file --
          M = m_shaperead( ShpFile, [ lonlimit(1) latlimit(1) lonlimit(2) latlimit(2) ] ); 
        % -- generate coastline --
            for jj = 1:length( M.ncst )
                M.X{jj} = [ M.ncst{jj}(:,1) ; nan ];
                M.Y{jj} = [ M.ncst{jj}(:,2) ; nan ];
            end

            S.X = cat(1,M.X{:});
            S.Y = cat(1,M.Y{:});

    elseif ~isempty(path_gshhs)
        [~, S] = FUN_load_shp_files( lonlimit, latlimit, [], ghssh_resolution, [] );

    elseif exist( 'shaperead','file')
        S = shaperead( 'landareas.shp','BoundingBox' ,[lonlimit(1) latlimit(1); lonlimit(2) latlimit(2)]);

        if lonlimit(2) > 180
            lonlimit2 = [-180 lonlimit(2)-360];
            S2 = shaperead( 'landareas.shp','BoundingBox' ,[lonlimit2(1) latlimit(1); lonlimit2(2) latlimit(2)]);
            for kk = 1:length(S2)
                S2(kk).X =  S2(kk).X+360;
            end

            S = [S ; S2];
        end

    elseif exist('Data_Preload_landareas.shp.mat','file')
        S = load('Data_Preload_landareas.shp.mat');
        S = S.S;
    else
        error('shaperead.m doesn''t exist and pre-generated data cannot be found')
    end

    coast_lon = [S.X];
    coast_lat = [S.Y];
    
end
 
% ---- plot ----

if is_plot 
    if ~isempty( coast_lon )
        if length(varargin) > 0
            FUN_MAP_Fill_Coastline(coast_lon(:),coast_lat(:), varargin{:});
        else
            FUN_MAP_Fill_Coastline(coast_lon(:),coast_lat(:),'facecolor', [255 179 102]/255 );
        end
    end
    
    xlim(lonlimit);
    ylim(latlimit);
    % FUN_Plot_xlim_fit(lonlimit);
    % FUN_Plot_ylim_fit(latlimit);

    set(gca,'layer','top')
end

if is_save_temfile && ~use_data_from_preload_mat
    time_now = now;
    save(tem_filename, 'coast_lon', 'coast_lat', 'lonlimit','latlimit', 'time_now');
end
