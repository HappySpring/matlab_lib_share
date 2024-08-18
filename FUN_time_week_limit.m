function timelimit = FUN_time_week_limit( time0, is_start_from_Sun )
% timelimit = FUN_time_week_limit( time0, is_start_from_Sun )
% Find the limit of a week by providing one time
% V1.00 By Lq C 2019-03-04
%

% For Debug:
% time0(1) = datenum( 2019,3, 4 );
% time0(2) = datenum( 2019,2,4);

if ~exist('is_start_from_Sun','var') || isempty( is_start_from_Sun )
   is_start_from_Sun = false; 
end

[yy,mm,dd] = datevec( time0 );
      
nd = weekday( time0 ); % nd starts from Sun.

if is_start_from_Sun
    % Day-1 is Sunday
else
    % Day-1 is Monday
    nd = nd - 1;
end
    

timelimit(:,1) = datenum(yy,mm, dd - nd + 1,0,0,0);   
timelimit(:,2) = datenum(yy,mm,dd + 7 - nd,23,59,59);

datestr( timelimit)
