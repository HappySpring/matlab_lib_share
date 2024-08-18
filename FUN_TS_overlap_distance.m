function [dis_overlap, range_overlap] = FUN_TS_overlap_distance( x, y )
% INPUT:
%       x [1x2] or [2x1]
%       y [1x2] or [2x1]
%
% find the length of the overlap distance between x and y

% V1.10 By L. Chi. If length(x) > 2, it will be replaced by [min(x), max(x)] 
% V1.00 By Lequan Chi

%% debug only
% x = [0 5];
% y = [3 10];


%% check

if isvector( x ) && isvector( y )
else
   error('input variables must be vectors'); 
end

if length(x)>2
   x = [min(x), max(x)];
end

if length(y)>2
   y = [min(y), max(y)];
end

x = x(:);
y = y(:);

% if (all( size(x)==[2 1] ) || all( size(x)==[1 2] )) && (all( size(y) == [2 1])  || all( size(x)==[2 1] ))
% else
%    error('Unexcepted xrange/yrange size') 
% end

x = sort( x, 'ascend');
y = sort( y, 'ascend');

%% 
if y(2) <= x(1) || y(1) >= x(2)
    % No overlay between x & y -------------------------------------------
    dis_overlap = 0;
    range_overlap = [nan nan];
    
elseif y(2) >= x(1) && y(2) <= x(2) && y(1) <= x(1)
    %----------------------------------------------------------------------
    %      |--------- x ----------|
    %  |----- y ----- |
    range_overlap = [x(1) y(2)];
    
elseif y(2) >= x(2) && y(1) <= x(2) && y(1) >= x(1)
    %----------------------------------------------------------------------
    %      |--------- x ----------|
    %                   |----- y ----- |
    range_overlap = [y(1) x(2)];

elseif x(1) <= y(1) && x(2) >= y(2)
    %----------------------------------------------------------------------
    %      |--------- x ----------|
    %          |----- y ----- |
    range_overlap = [y(1) y(2)];

elseif x(1) >= y(1) && x(2) <= y(2)
    %----------------------------------------------------------------------
    %      |--------- x ----------|
    % |-------------- y -------------- |
    range_overlap = [x(1) x(2)];

else
    %----------------------------------------------------------------------
    error('This part of the code should never be reached. if it does, you find a bug');
end

if any( isnan( range_overlap ) )
    dis_overlap = 0;
else
    dis_overlap = range_overlap(2) - range_overlap(1);
end


%% %% TEST ================================================================
% % for ii = 1:9
% %     
% %     switch ii
% %         case 1
% %             %----------------------------------------------------------------------
% %             %      |--------- x ----------|
% %             %  |----- y ----- |
% %             x = [5 10];
% %             y = [1 7];
% %             expect.range_overlap = [5 7];
% %             
% %         case 2
% %             %----------------------------------------------------------------------
% %             %      |--------- x ----------|
% %             %                   |----- y ----- |
% %             x = [1 10];
% %             y = [8 19];
% %             expect.range_overlap = [8 10];
% %             
% %         case 3
% %             %----------------------------------------------------------------------
% %             %      |--------- x ----------|
% %             %          |----- y ----- |
% %             x = [0 12];
% %             y = [5 7];
% %             expect.range_overlap = [5 7];
% %             
% %         case 4
% %             %----------------------------------------------------------------------
% %             %      |--------- x ----------|
% %             % |-------------- y -------------- |
% %             x = [4 9];
% %             y = [1 10];
% %             expect.range_overlap = [4 9];
% %             
% %         case 5
% %             %----------------------------------------------------------------------
% %             %      |--------- x ----------|
% %             %      |----- y ----- |
% %             x = [5 10];
% %             y = [5 9];
% %             expect.range_overlap = [5 9];
% %             
% %         case 6
% %             %----------------------------------------------------------------------
% %             %      |--------- x ----------|
% %             %              |----- y ----- |
% %             x = [1 10];
% %             y = [7 10];
% %             expect.range_overlap = [7 10];
% %             
% %         case 7
% %             %----------------------------------------------------------------------
% %             %      |--------- x ----------|
% %             %    |---------- y ---------- |
% %             x = [0 12];
% %             y = [-3 12];
% %             expect.range_overlap = [0 12 ];
% %             
% %         case 8
% %             %----------------------------------------------------------------------
% %             %      |--------- x ----------|
% %             %      |--------- y --------- |
% %             x = [4 9];
% %             y = [4 9];
% %             expect.range_overlap = [4 9];
% %             
% %         case 9
% %             %----------------------------------------------------------------------
% %             %      |--------- x ----------|
% %             %      |----------- y ----------- |
% %             x = [-4 9];
% %             y = [-4 12];
% %             expect.range_overlap = [-4 9];
% %     end
% %     expect.dis_overlap = expect.range_overlap(2) - expect.range_overlap(1);
% % 
% %     [dis_overlap, range_overlap] = FUN_TS_overlap_distance( x, y );
% %     
% %     if dis_overlap == expect.dis_overlap &&  all( range_overlap ==  expect.range_overlap ) 
% %         disp(['test #' num2str(ii) ' Expected overlap ' num2str( expect.range_overlap ) ', returned overlap ' num2str(range_overlap) ' Passed!'])
% %     else
% %         disp(['test #' num2str(ii) ' Expected overlap ' num2str( expect.range_overlap ) ', returned overlap ' num2str(range_overlap) ' Failed'])
% %     end
% % end
% % 
% % 
