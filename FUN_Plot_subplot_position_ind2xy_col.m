function [fig_ix, fig_iy] = FUN_Plot_subplot_position_ind2xy_col( fig_Nx, fig_Ny, ind )
% find the (x,y) position of the subplot No.ind in total of (fig_Nx,
% fig,Ny) subplots
% Colume first:
%       e.g.,           1  3
%                       2  4

% V1.00

% fig_Nx = 7;
% fig_Ny = 4;
fig_ix = mod( (ind-0.5), fig_Nx ) + 0.5 ;
fig_iy = ceil( ind / fig_Nx ) ;