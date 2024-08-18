function [LON LAT] = FUN_lonlat2LONLAT(lon,lat)
% get 2-D LON & LAT from 1-D lon & lat

[LON LAT] = meshgrid(lon,lat);
LON = LON';
LAT = LAT';