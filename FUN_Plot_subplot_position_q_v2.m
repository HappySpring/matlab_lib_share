function [sub_po, info] = FUN_Plot_subplot_position_q_v2(Nx, Ny, ix, iy, x_blank_interval, y_blank_interval, ol_pos )
% subplot_position = FUN_subplot_position_quick(Nx, Ny, ix, iy, [x_blank_interval], [y_blank_interval], [ol_pos] )
% Generate the [ix iy] subplot position with totally [Nx, Ny] axes.
%
% INPUT
%   ol_pos:  [left, bottom, width, height] defines the outlier of all subpltos 

% V2.20 
%       ol_pos: [left, bottom, width, height] defines the outlier of all subpltos 
% V2.10 
%        x_blank_interval, y_blank_interval  can be assigned when it is called. Otherwise, the default value will be used
% V2.00
%       update minimal distance to the bottom
% V1.10
%       Adjust the default values
%       Add output for suggesting position of colorbars
% V1.00 
% By Lequan Chi
% input
%% example 
%  Nx = 9;
%  Ny = 2;
%  figure
%  for iy = 1:2
%      for ix = 1:9
%          disp(['ix = ' num2str(ix) ', and iy = ' num2str(iy)])
%          subplot('position',FUN_Plot_subplot_position_q(Nx, Ny, ix, iy))
%          text( .5, .5, ['ix = ' num2str(ix) ', and iy = ' num2str(iy)] )
%          pause
%      end
%  end
%  
 
%% bulit-in parameters

 if ~exist('ol_pos') || isempty( ol_pos )
    ol_pos = [ 0.1, 0.1, 0.75, 0.85] ;
 end
 

%  po_left0    = .1;
%  po_right0   = .15;
%  po_bottom0  = .1;
%  po_upper0   = .05;

 po_left0    = ol_pos(1); %0.1
 po_right0   = 1 - ol_pos(1) - ol_pos(3); % 0.15
 po_bottom0  = ol_pos(2); %0.1
 po_upper0   = 1 - ol_pos(2) - ol_pos(4) ; %0.05
 
 
 if ~exist('x_blank_interval') || isempty( x_blank_interval )
    x_blank_interval =  0.015 ;
 end
 
 if ~exist('y_blank_interval') || isempty( y_blank_interval )
    y_blank_interval =  0.01 ; 
 end
 
 
 
 
 
 %other varialbes
 dy = (1 - po_left0   - po_right0 - y_blank_interval*(Ny-1) ) / Ny; % dy per single subplot
 dx = (1 - po_bottom0 - po_upper0 - x_blank_interval*(Nx-1) ) / Nx; % dx per single subplot
 po_NN_left   = po_left0   + (iy-1)*( dy + y_blank_interval ); % distance from the left edge
 po_NN_bottom = po_bottom0 + (Nx-ix)*( dx + x_blank_interval ); % distance from the bottom edge

 % final position
 sub_po = [po_NN_left po_NN_bottom dy dx ];

%%

% boundary location
info.bd.left   = po_left0;
info.bd.right  = 1-po_right0;
info.bd.upper  = 1-po_bottom0;
info.bd.bottom = po_bottom0;

% colorbar
h_ad = 0.2;
info.cbar.po1 = [.87 po_bottom0+h_ad/2 .02 1-po_upper0-po_bottom0-0.2 ];
info.cbar.pof = @(x)[.87 sub_po(2)+x/2 .02 sub_po(4)-x];
info.cbar.poN = info.cbar.pof(0.1);


%% 
% if nargout is zero, call subplot automatically
if nargout == 0
   subplot( 'position', sub_po );
end

 