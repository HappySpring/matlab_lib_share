function [dis, ind] = FUN_find_closest_point1D( x, x0, N )
% find x closest to x0.
% V1.00
%% check
if FUN_is_1D( x )
else
   error('Only 1-D data are acceptable!') 
end


if all( size(x0) == 1 )
else
   warning('x0 must be a 1x1 matrix' )
end

%%
dis = abs( x - x0 );

[dis, ind]= sort( dis, 'ascend');

if exist('N','var') && ~isempty(N)
    dis = dis(1:N);
    ind = ind(1:N);
end

% check 
% if length( unique( dis ) ) == length( dis )
% else
%     warning('Multiple points share same distance!')
% end