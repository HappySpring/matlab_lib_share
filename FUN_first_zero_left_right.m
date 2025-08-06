function [ out_x_at_y0, out_ind_at_y0 ] = FUN_first_zero_left_right( x, y, x0 )

% x = lat_interp;
% y = vel_now(:,1);
% x0 = GS_lat1;

if FUN_is_1D( y );
else
   error('Only 1-D input is accepted.'); 
end

if isnan(y)
    error('Nan found in the input data!')
end

[ x_at_y0, ~, ind_at_y0, ~ ]= intersections( x, y, [min(x) max(x)], [0 0] );

% ---- for debug and verification propose only ----
% This will compare the results with another independent function.
%     L1 = [ x(:)' ; y(:)' ];
%     L2 = [ min(x) max(x) ; 0 0 ];
%     P = InterX(L1, L2);
%     Px = P(1,:);
%     Px = unique(Px);
%     if max( abs( sort(x_at_y0(:)', 'ascend') - sort(P(1,:), 'ascend') ) ) < 1e-10;
%         % PASS
%     else
%         error('Conflict results from two functions!')
%     end
% ---- ----

[~, ind ] = FUN_TS_first_left_right_point( x0, x_at_y0 );

out_x_at_y0   = nan(2,1);
out_ind_at_y0 = nan(2,1);

nanloc = isnan( ind );

out_x_at_y0(~nanloc)   = x_at_y0( ind(~nanloc) );
out_ind_at_y0(~nanloc) = ind_at_y0( ind(~nanloc) );