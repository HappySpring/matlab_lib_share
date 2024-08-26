function is1D = FUN_is_1D(data)
% quck judge whether input data is 1D or not. 
%
%
%
% This could be replaced by isvector
%   This is slightly different from isvector: 
%   isvector returns true for [ 1 x 0 ]  or [ 0 x 1 ], while this function 
%   return false in the same situation. However, the difference should not be a
%   problem and the isvector is still recommended.


if length(size(data)) < 2.9 & ( size(data,1) == 1 | size(data,2) == 1 )
    is1D = logical( 1 > 0 );
else
    is1D = logical( 1 < 0 );
end