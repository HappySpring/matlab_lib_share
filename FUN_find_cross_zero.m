function c0 = FUN_find_cross_zero( x )
% Find the ind where x cross 0;

tem = x(1:end-1) .* x(2:end) ; 

cross0 = find( tem < 0 );
eq0    = find( x == 0 );

c0 = [ cross0(:)  cross0(:)+1];
c0 = [ c0; repmat( eq0(:), [1, 2]) ];

% resort ascendly
[~, ic] = sort( c0(:,1), 'ascend');
c0 = c0(ic,:);
