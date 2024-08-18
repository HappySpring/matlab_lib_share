function [week_ind, week_timelimit] = FUN_time_get_week_ind( time_in )
% Generate an ID for each week
%   Note: To avoid any potential problems in using this function, the
%   timelimit for each week will be derived here, too.
%
% 0000-01-01 is a Saturday. 
% the first week is till 0000-01-01, the second week is 0000-01-02 ~
% 0000-01-08
%
% V1.00 LC
% 

% the first day of the second is 0000-01-02!
week_ind = ceil( ( time_in - 1 ) / 7 ) + 1;

if FUN_is_1D( time_in )
    week_timelimit = nan( length( time_in ), 2 );
    %                     |The first day of the first week | + | days for all week before the current one |
    week_timelimit(:,1) = ( datenum( 0000, 1, 2 ) - 7 )      + ( week_ind-1 ) * 7  ;
    %                     |The first day of the first week | + | days for all week including the current one | - | 0.001 second   |
    week_timelimit(:,2) = ( datenum( 0000, 1, 2 ) - 7 )      + ( week_ind  ) * 7                               -  1/24/3600/1000  ;

else
    error( 'Only for 1-D input now');
end






