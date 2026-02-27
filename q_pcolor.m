function [hd, cbar_hd] = q_pcolor(varargin)
% q_ series are designed for quick look instead of plotting high quality figure
%

% V1.00 By Lequan Chi


if nargin == 1 || ischar(varargin{2})
    varargin{1} = squeeze( varargin{1} );
else
    varargin{3} = squeeze( varargin{3} );
end

hd = pcolor( varargin{:} );
shading interp;
cbar_hd = colorbar;