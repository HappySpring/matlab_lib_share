function month_ind = FUN_time_get_month_ind( timelist )
% month_ind = FUN_time_get_month_ind( timelist )

% V1.2 by L. Chi: add support for "datetime"
% V1.1 by Lequan Chi
%      Support inf and -inf
% V1.0 by L Chi, ini version.



if isa( timelist, 'datetime')
% ==== datetime ===========================================================
    [yearlist, monthlist, ~] = datevec( timelist );
    month_ind = yearlist * 12 + monthlist;
    
else
% ==== datenum ============================================================
    % ---- pre-processing: mark inf ----
    inf_loc  = isinf( timelist );
    inf_sign = sign( timelist(inf_loc) );

    timelist( inf_loc ) = nan;

    % ---- calculation ----
    [yearlist, monthlist, ~] = datevec( timelist );
    month_ind = yearlist * 12 + monthlist;

    % ---- post-processing: revert inf ----
    month_ind( inf_loc ) = inf .* inf_sign ; 

end
