function isoline = FUN_isoline_detection( lon, lat,  Temp, isothermal )
% V2.00 by L. Chi. It calls "FUN_isoline_detection_NoInterp" from this version.
% V1.02, Nan will be returned if the requred isothermal cannot be found.
% V1.01, Add sort function

% preparation -------------------------------------------------

tem_Temp2 = Temp;

if any( isnan( Temp(:) ) )
   warning('Please be careful of the nan interplation!'); 
   tem_Temp2 = inpaint_nans( tem_Temp2 );   
end


% preparation -------------------------------------------------

isoline = FUN_isoline_detection_NoInterp( lon, lat, tem_Temp2, isothermal );