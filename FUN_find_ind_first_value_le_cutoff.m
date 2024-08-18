function max_lag = FUN_find_ind_first_value_le_cutoff( acf, cut_off )
% max_lag = FUN_find_ind_first_value_le_cutoff( acf, cut_off );
% This function will find the first value less than or euqal than the cut-off values
% INPUT
%       acf ([1xN], [MxN]): input data
%       cut_off [1x1] or [Mx1]: the cut-off value
% OUTPUT
%       the matrix ind in which acf is less or equal to cut_off values at the
%       first time at each row.
%
% V1.00 By LC.

%% ==== check ====
% check - 1: acf must be 2-D([1xN], [MxN])
if ndims( acf ) == 2  && FUN_is_1D( cut_off ) && size(acf,1) == length( cut_off )
    % Pass
else
    error('input acf must be 2-D, and the 2nd dim is time');
end

    %neg_loc = acf <= cut_off ;
    neg_loc = bsxfun(@le, acf, cut_off(:) );
    [~,max_lag] = max( neg_loc, [], 2 ); % true is 1. max( neg_loc, [], 2 ) will return the location of first 1 in each raw.
    
    % The above code will return wrong results if acf is above cut_off all
    % the time. Thus, the following checker is added to fix the problem.
    if any( all( ~neg_loc, 2 ) )
       error('Autocorrelations at all lags are above the cut off value') 
    end
    
%     max_lag = max_lag - 1; 
%     
%     ind2D = repmat( [1:size(acf,2)], size(acf,1), 1 );
%     rm_loc = bsxfun( @gt, ind2D, max_lag );
%     acf(rm_loc) = 0;
