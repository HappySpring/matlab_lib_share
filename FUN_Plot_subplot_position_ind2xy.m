function [fig_ix, fig_iy] = FUN_Plot_subplot_position_ind2xy( fig_Nx, fig_Ny, ind )
% find the (x,y) position of the subplot No.ind in total of (fig_Nx,
% fig,Ny) subplots

% V1.00

% fig_Nx = 7;
% fig_Ny = 4;
fig_iy = ceil( ind / fig_Nx ) ;
fig_ix = ind - fig_Nx * ( fig_iy - 1 ) ;