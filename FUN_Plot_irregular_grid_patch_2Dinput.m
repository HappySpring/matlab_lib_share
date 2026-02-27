function pid = FUN_Plot_irregular_grid_patch_2Dinput( lon, lat, data, varargin )
% FUN_Plot_patch_on_irregular_grid( lon, lat, data, varargin )
% 
% INPUT
%       lon  [M x N]: it must be a 2-d variable
%       lat  [M x N]: it must be a 2-d variable
%       data [M x N]: it must be a 2-d variable
%
% Output
%       pid: figure handle
%

%
% V1.00 By L. Chi (L.Chi.Ocean@outlook.com)

%% Initialization

% ---- optional parameters ------------------------------------------------
is_rm_loadedd_param = true;

% facecolor in patch: ['flat'] | 'interp'
[facecolor, varargin] = FUN_codetools_read_from_varargin( varargin, 'facecolor', 'flat', is_rm_loadedd_param );

% linestyle in patch: ['none'] | '-' | '--' | ... (see linesytle in matlab help documents 
[linestyle, varargin] = FUN_codetools_read_from_varargin( varargin, 'linestyle', 'none', is_rm_loadedd_param );

% if ~isempty( varargin )
%    error('Unknown input paramters!'); 
% end

% ---- check --------------------------------------------------------------

if ~isvector(lon) && ~isvector(lat) && isequal( size(lon), size(lat) )
else
    error('Input variables lon & lat must be 2-D variable sharing same size');
end

%% prepare temporal variables


IND = 1: numel(lon)  ;
IND = reshape( IND, size(lon) );


nv1 = IND( 1:end-1, 1:end-1 );
nv2 = IND( 2:end,   1:end-1 );
nv3 = IND( 1:end-1, 2:end   );

nv4 = IND( 2:end,   1:end-1 );
nv5 = IND( 2:end,   2:end   );
nv6 = IND( 1:end-1, 2:end   );


nv = [ [nv1(:) nv2(:) nv3(:)]; [ nv4(:) nv5(:) nv6(:) ] ];

loc = abs( lon(nv(:,1)) - lon(nv(:,2)) ) > 180 ;
loc = loc | abs( lon(nv(:,2)) - lon(nv(:,3)) ) > 180;
loc = loc | abs( lon(nv(:,1)) - lon(nv(:,3)) ) > 180;

nv(loc,:) = [];

vert = [lon(:) lat(:)];

%% plot by patch 
if isempty( data )
    pid = patch( 'Faces', nv, 'Vertices', vert, 'linestyle', linestyle,  varargin{:} );
else
    pid = patch( 'Faces', nv, 'Vertices', vert, 'FaceVertexCData', data(:), 'linestyle', linestyle, 'facecolor', facecolor, varargin{:} );
end






