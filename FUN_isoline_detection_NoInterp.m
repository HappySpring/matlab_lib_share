function isoline = FUN_isoline_detection_NoInterp( lon, lat,  data, isoline_value, fillvalue )
% isoline = FUN_isoline_detection_NoInterp( lon, lat,  data, isoline_value )
% 
% INPUT:
%       lon: longitude (or x)
%       lat: latitute (or y)
%       data [2-D matrix], {lon, lat}: 
%       isoline_value: isoline required
%       fillvalue (optional): replace nan by this value. It helps to keep a closed contour
%
% OUTPUT: 
%       isoline (structure)
%

% V2.12 replace subfunction FUN_is_1D by built-in function isvector 
% V2.11 [temporary solution]: replace contourc by contour if the input lon is n-D (n>1)
%           contourc returns error for 2-D lon/lat input.
% V2.10 add fillvalue
% V2.00 Use contourc instead of contour. 
%          This function will not open new figures any more.
%
% V1.10 Add support for 2D lon/lat cases
%
% same as FUN_isoline_detection but "tem_data2 = inpaint_nans( tem_data2 );" is commentted
% V1.10 Update codes to make it consistent with earlier matlab verison when
% none isolines found.
% V1.01, Add sort function


% ==========================================================
% # save current status
% ==========================================================

% select 15 isoline_value from contour ---------------------------
%original_active_fig = get(0,'CurrentFigure');
%if ~isempty( original_active_fig )
%    original_active_axes= get(gcf,'CurrentAxes');
%end



if exist('fillvalue','var') && ~isempty( fillvalue )
    data( isnan(data) ) = fillvalue;
end

% ==========================================================
% # Calculate contours
% ==========================================================

% isoline_value(1) is repeated in case of single input.

if isempty( isoline_value )
    warning('(isoline_value) is empty!')
    a = [];
    
else
    % repeat isoline_value(1) in case it is a 1x1 matrix
    if isvector(lon) && isvector(lat) %
        a = contourc( lon, lat, data', [isoline_value, isoline_value(1)] );
    elseif all( size(lon) == size( data ) )
        %a = contourc( lon, lat, data,  [isoline_value, isoline_value(1)] );
        temfig = figure('visible','off');
        [a,~] = contour( lon, lat, data,  [isoline_value, isoline_value(1)] );
        close(temfig);
    else
        error('Unexpected dimension problems')
    end
end

% ---- Can not find any isolines with the given value ----
if isempty(a)
    
    isoline(1).x = nan;
    isoline(1).y = nan;
    isoline(1).length = 1;
    
    return
end

% ==========================================================
% core part: find each contours
% ==========================================================
N = 0;
ind_now = 1;
while ind_now <= size(a,2)
    
    N = N + 1;
    tem_Np = a(2,ind_now);%Num of points in this isoline_value
    tem = a( : , ind_now+1 : ind_now + tem_Np );
    
    isoline(N).x = tem(1,:);
    isoline(N).y = tem(2,:);
    isoline(N).length = size( tem,2 );
    
    ind_now = ind_now + tem_Np + 1;
    clear tem tem_Np
    
end

% ==========================================================
% END core part
% ==========================================================

% sort, lengest isolines is leading. -----------------------
[~, l_loc ] = sort( [isoline.length], 'descend' );
isoline = isoline( l_loc );

% ----------------------------------------------------------

%if ~isempty( original_active_fig )
%    set(0, 'CurrentFigure', original_active_fig )
%    set( gcf, 'CurrentAxes', original_active_axes)
%end
