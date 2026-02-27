function [M, coast_line]= FUN_load_shp_files( lonlimit, latlimit, data_address, resolution, level, varargin )
% prepare coastline data for further usage
% V1.21 2024-01-11 update default path for GSHHS
% V1.20 2023-09-03 Add support for longitude range: 0-360. (The old versions supports -180~180 only.) 
% V1.11 2021-03-04 M(ii).X and M(ii).Y will be set to empty if the two fields do not exist
% V1.10 2017-10-23 update resolution setting
% V1.00 2017-07-25
%
%
% This is based on the m_shaperead function by Prof. R. Pawlowicz rpawlowicz@eos.ubc.ca 24/Jan/2011
% m_shaperead is part of m_map toolbox by Prof. R. Pawlowicz.

%% debug only 
% % clear 
% % close all
% % clc
% % 
% % lonlimit = [-inf inf];
% % latlimit = [-inf inf];
% % level = 1:2;

[Nmax_areas, varargin] = FUN_codetools_read_from_varargin( varargin, 'Nmax_areas', inf, true );

if ~isempty(varargin)
    error
end

%% default setting

% data address
    if ~exist('data_address','var') || isempty( data_address )
        env = FUN_0_machine_info;
        data_address = fullfile( env.Data_root_dir, 'Coastlines', 'GSHHS', 'GSHHS_shp' );

        if ~exist(data_address,'dir')
            data_address = fullfile( env.Data_basic, 'GSHHS', 'GSHHS_shp' );
        end
    end

% resolution
    if ~exist('resolution','var') || isempty( resolution )

        DmoainArea=abs( (lonlimit(2)-lonlimit(1))*(latlimit(2)-latlimit(1)) );
        if DmoainArea<4
            disp('m_gshhs_f will beused')
            resolution = 'f';
        elseif DmoainArea<16
            disp('m_gshhs_h will beused')
            resolution = 'h';
        elseif DmoainArea<100
            disp('m_gshhs_i will beused')
            resolution = 'i';
        else
            disp('m_gshhs_l will beused')
            resolution = 'l';
        end
    end

% level ===================================================================
    if ~exist('level','var') || isempty( level )
        level = 1;
    end

%% loading data
for ii = 1:length( level )
    
    filename_now = fullfile( data_address, resolution, ['GSHHS_' resolution '_L' num2str(level(ii))] );
    
    M(ii) = m_shaperead( filename_now, [ lonlimit(1) latlimit(1) lonlimit(2) latlimit(2) ] ); 
    
end

% handle range 0 : 360;
is_0360 = false;
if max( lonlimit ) > 180
    is_0360 = true;
    for ii = 1:length( level )
        filename_now = fullfile( data_address, resolution, ['GSHHS_' resolution '_L' num2str(level(ii))] );
        M2(ii) = m_shaperead( filename_now, [ -180, latlimit(1) lonlimit(2)-360 latlimit(2) ] ); 
    end
    
end


%% genreating coastlines

for ii = 1:length( level )
    for jj = 1: min( length( M(ii).ncst ), Nmax_areas )
        M(ii).X{jj} = [ M(ii).ncst{jj}(:,1) ; nan ];
        M(ii).Y{jj} = [ M(ii).ncst{jj}(:,2) ; nan ];
    end
    
    if isfield( M(ii),'X')
        M(ii).X = cat(1,M(ii).X{:});
        M(ii).Y = cat(1,M(ii).Y{:});
    else
        M(ii).X = [];
        M(ii).Y = [];
    end
end

if is_0360
    for ii = 1:length( level )
        
        M2loc = ~ismember( M2(ii).id, M(ii).id );
        M2(ii).ncst  = M2(ii).ncst(M2loc);
        M2(ii).id    = M2(ii).id(M2loc);
        M2(ii).level = M2(ii).level(M2loc);
        M2(ii).source= M2(ii).source(M2loc);
        M2(ii).sibling_id = M2(ii).sibling_id(M2loc);
        M2(ii).area  = M2(ii).area(M2loc);
        
        for jj = 1: min( length( M2(ii).ncst ), Nmax_areas )
            M2(ii).X{jj} = [ M2(ii).ncst{jj}(:,1) ; nan ];
            M2(ii).Y{jj} = [ M2(ii).ncst{jj}(:,2) ; nan ];
        end

        if isfield( M2(ii),'X')
            M2(ii).X = cat(1,M2(ii).X{:})+360;
            M2(ii).Y = cat(1,M2(ii).Y{:});
        else
            M2(ii).X = [];
            M2(ii).Y = [];
        end
    end
end

if is_0360

    coast_line.X = cat(1, M(:).X, M2(:).X );
    coast_line.Y = cat(1, M(:).Y, M2(:).Y );

else

    coast_line.X = cat(1, M(:).X);
    coast_line.Y = cat(1, M(:).Y);

end


% FUN_MAP_Fill_Coastline(coast_line.X,coast_line.Y,'facecolor', [255 179 102]/255)
% 
% FUN_MAP_Fill_Coastline(M(1).X,M(1).Y,'facecolor', [255 179 102]/255)
% FUN_MAP_Fill_Coastline(M(2).X,M(2).Y,'facecolor', )

