function FUN_MAP_patch_dilution_input2( lon, lat, is_dilution, alpha_val )

% find current caxis
caxis_now = get(gca,'clim');

% apply dilution
is_dilution_now = nan( size(is_dilution) );
if islogical( is_dilution_now )
    is_dilution_now( is_dilution ) = 1;
else
    is_dilution_now( is_dilution == 1 ) = 1;
end

FUN_MAP_patch_2D_simpleinterp(  lon, lat, is_dilution_now, 'FaceColor','w', 'FaceAlpha',alpha_val,'linestyle','none');

% reset caxis
caxis( caxis_now );
