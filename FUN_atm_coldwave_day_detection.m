function out = FUN_atm_coldwave_day_detection( timelist, temp, varargin )
%  out = FUN_atm_coldwave_detection( timelist, temp )
%  Identify cold air events and cold wave events from 2-meter temperature
%
% INPUT:
%        timelist [ 1, nt ] or [nt, 1]: time in matlab format (e.g., datenum)
%        temp     [m, n, ..., nt]:     2-meter temperature 
%
% OUTPUT: 
%      
% out = 
% 
%   struct with fields:
%      ------------- daily output for each station ----------------------------
%                        time: [1, nd]         time
%                   daily_min: [x, y, ..., nd]     
%               daily_min_24h: [x, y, ..., nd] 
%               daily_min_48h: [x, y, ..., nd] 
%               daily_min_72h: [x, y, ..., nd] 
%                   tdrop_24h: [x, y, ..., nd] 
%                   tdrop_48h: [x, y, ..., nd] 
%                   tdrop_72h: [x, y, ..., nd] 
%              cold_day_level: [x, y, ..., nd] 
%     cold_day_level_notes_en: {'2： cold air'  '3： strong cold air'  '4： cold wave'  '5： strong cold wave'  '6： extreme cold wave'}
%     cold_day_level_notes_cn: {'2： 冷空气'  '3： 强冷空气'  '4： 寒潮'  '5： 强寒潮'  '6： 超强寒潮'}
%
%      ------------- regional mean cold events ----------------------------
%     regional_cold_day_level: [1, nd]
%                  reg_events: [1, ne] structures 


% V1.11 by L. Chi: cold air events are listed by time instead of by event duration. 
% V1.10 by L. Chi: merging continuous days into a single events. 
% V1.00 by L. Chi

%%
% =========================================================================
% debug
% =========================================================================
% timelist = timelist + 8/24;
% temp     = t2m ;
% temp = temp - 273.15;

%%
% =========================================================================
% parameters
% =========================================================================

is_rm_loadedd_param = true;


% if is_identify_cold_wave is false, this is only used for calculating
%   t2m drop in 24/48/72h. It may also be used to count 24/48/72 hour drop
%   of other variables like v10.
[is_identify_cold_wave, varargin] = FUN_codetools_read_from_varargin( varargin, 'is_identify_cold_wave', true, is_rm_loadedd_param );

if ~isempty(varargin)
    error('Unknown parameters!')
end
%%
% =========================================================================
% check & prepare input
% =========================================================================


% --- check time ---------------------------------
if isvector( timelist ) 
else
    error
end

if all(diff(timelist)>0)
else
    error
end

if max( abs(diff(timelist)-1/24) ) < 1e-5
    %pass
else
    error('hourl data without gaps required!')
end

if abs( minute( timelist(1) ) - 0 ) < 1e-5
    %pass
else
    error('It must located at 0 min of each hour, like 1:00, 2:00 ...; 00:30 is not supported.')
end


timelist = timelist(:)';

% --- check & reshape temp ---------------------------------

if any( temp(:) > 200 )
    error('Temperature over 200 degc! Please convert K to degC!')
end

if isvector( temp )
    temp = temp(:)';
end

size0    = size(temp);
size0_xy = size0(1:end-1);
nx0   = prod(size0(1:end-1));
nt0   = size0(end);

if nt0 == length( timelist )
else
    error('timelist & temp must share same time periods')
end

% reshape temp to a 2-D variable:
%    dim-1: space
%    dim-2: time
temp = reshape( temp, [], nt0 );

%%
% =========================================================================
% chunk time: 
% =========================================================================

% It must starts from 15 o'clock
tem24 = timelist(1:24);

ind0 = find( hour(tem24) == 15 | (hour(tem24) == 14 & minute(tem24)>0 ) );

if length(ind0) > 1 | isempty(ind0)
    error('Unexpected data: code 101')
end


tem2 = nt0 - ind0 + 1;
n_tail_cut = mod(tem2, 24);
ind1 = nt0 - n_tail_cut;

timelist = timelist( ind0 : ind1 );
temp     = temp( :, ind0:ind1 );

nt1_hour = length( timelist );
nt1_day  = nt1_hour/24;


temp_xdh = reshape( temp, [nx0, 24, nt1_day] ); % [ space, hour, day ]
temp_xdh = permute( temp_xdh, [1 3 2 ]); % -> [ space, day, hour ]

%%
% =========================================================================
% find daily min, 24h min, 48h min and 72h min
% =========================================================================

timelist_24h_day = reshape( timelist, 24, nt1_day );

ind_cd   = 2: nt1_day-2; % index of available current day.
                         % 1: the day before the first day
                         % nt1_day-2: 24 hours after the last available "current day" 
                         % nt1_day-1: 48 hours after the last available "current day" 
                         % nt1_day  : 72 hours after the last available "current day" 

out.time      = timelist_24h_day(1, ind_cd);
out.time      = floor(out.time);

out.daily_min     = min( temp_xdh(:,ind_cd-1,:), [], 3);
out.daily_min_24h = min( temp_xdh(:,ind_cd,:),   [], 3);
out.daily_min_48h = min( temp_xdh(:,ind_cd+1,:), [], 3); % this only counts min temp betwen 24-48h
out.daily_min_48h = bsxfun(@min, out.daily_min_24h, out.daily_min_48h); % find t2m minimal in 0-24h & 24-48h

out.daily_min_72h = min( temp_xdh(:,ind_cd+2,:), [], 3); % this only counts min temp betwen 48-72h
out.daily_min_72h = bsxfun(@min, out.daily_min_48h, out.daily_min_72h); % find t2m minimal in 0-48h & 48-72h

out.tdrop_24h = out.daily_min - out.daily_min_24h ;
out.tdrop_48h = out.daily_min - out.daily_min_48h ;
out.tdrop_72h = out.daily_min - out.daily_min_72h ;


%%
if is_identify_cold_wave

% =========================================================================
% identify cold air and cold wave
% cold air  冷空气
% cold wave 寒潮
% =========================================================================


% ---- mid cold air -------------------------------------------------------
% 较强冷空气(in GB/T 20484-2017) 或 中等强度冷空气(in QX/T 393-2017)



% ---- mid cold air -------------------------------------------------------

% cold air
tem_cold_day_2 = ( out.tdrop_48h >= 6 & out.tdrop_48h < 8 & out.daily_min_48h <= 8 ) | ( out.tdrop_48h > 8 & out.daily_min_48h > 8 );

% strong cold air
tem_cold_day_3 = out.tdrop_48h >= 8 & out.daily_min_48h <= 8;

% cold wave
%tem_cold_day_4 = ( out.tdrop_24h >= 8 | out.tdrop_48h >= 10 | out.tdrop_72h >= 12 ) & out.daily_min_72h <= 4 & out.daily_min_48h <= out.daily_min_24h & out.daily_min_72h <= out.daily_min_48h;
tem_cold_day_4 = ( out.tdrop_24h >= 8 | out.tdrop_48h >= 10 | out.tdrop_72h >= 12 ) & out.daily_min_72h <= 4 ;

% strong cold wave
tem_cold_day_5 = ( out.tdrop_24h >= 10 | out.tdrop_48h >= 12 | out.tdrop_72h >= 14 ) & out.daily_min_72h <= 2 ;

% extreme cold wave
tem_cold_day_6 = ( out.tdrop_24h >= 12 | out.tdrop_48h >= 14 | out.tdrop_72h >= 16 ) & out.daily_min_72h <= 0;


% n2 = sum( any(tem_cold_day_2, 1) )
% n2b= sum( sum( tem_cold_day_2, 1 ) / 26 >= 0.2 )cold_day_level

% n3 = sum( any(tem_cold_day_3, 1) )
% n3b=  sum( sum( tem_cold_day_3, 1 ) / 26 >= 0.2 )

% n4 = sum( any(tem_cold_day_4, 1) )
% n4b=  sum( sum( tem_cold_day_4, 1 ) / 26 >= 0.2 )
% n5b=  sum( sum( tem_cold_day_5, 1 ) / 26 >= 0.2 )
% n6 = sum( any(tem_cold_day_6, 1) )
% n6b=  sum( sum( tem_cold_day_6, 1 ) / 26 >= 0.2 )


out.cold_day_level = zeros( size(out.daily_min) );
out.cold_day_level(tem_cold_day_2) = 2;
out.cold_day_level(tem_cold_day_3) = 3;
out.cold_day_level(tem_cold_day_4) = 4;
out.cold_day_level(tem_cold_day_5) = 5;
out.cold_day_level(tem_cold_day_6) = 6;

out.cold_day_level_notes_en{1} = '2： cold air';
out.cold_day_level_notes_en{2} = '3： strong cold air';
out.cold_day_level_notes_en{3} = '4： cold wave';
out.cold_day_level_notes_en{4} = '5： strong cold wave';
out.cold_day_level_notes_en{5} = '6： extreme cold wave';


out.cold_day_level_notes_cn{1} = '2： 冷空气';
out.cold_day_level_notes_cn{2} = '3： 强冷空气';
out.cold_day_level_notes_cn{3} = '4： 寒潮';
out.cold_day_level_notes_cn{4} = '5： 强寒潮';
out.cold_day_level_notes_cn{5} = '6： 超强寒潮';


%%
% =========================================================================
% regional cold air/wave detection
% =========================================================================
% According to QX/T 393-2017, regional cold air day is defined as >= 20%
% stations affected by cold air.

tem_nx = size(out.cold_day_level,1);
tem_nt = size(out.cold_day_level,2);
reg_ratio = 0.2;% at least reg_ratio percent of sta reaches a level.

out.regional_cold_day_level = zeros( 1, tem_nt );

avail_cold_day_level_list = 2:6; % only level 2 to level 6 are available here.

for ii = 1:length( avail_cold_day_level_list )
    level_now = avail_cold_day_level_list(ii);
    out.regional_cold_day_level(  sum( out.cold_day_level>= level_now, 1 ) >= reg_ratio*tem_nx   ) = level_now;
end
 

%%
% =========================================================================
% regional: merging continuous cold day into one events
% =========================================================================

out.reg_events = FUN_TS_continuous_nan_detect( out.regional_cold_day_level >= 2, 'is_resort_by_length', false );
[~,sort_ind] = sort( arrayfun(@(x)x.index(1), out.reg_events) );
out.reg_events = out.reg_events(sort_ind);

for ii = 1:length( out.reg_events )
    
    % ---- interface ----
    tem_ind = out.reg_events(ii).index;
    tem_ind = sort(tem_ind,'ascend');

    out.reg_events(ii).level        = max( out.regional_cold_day_level( tem_ind ) );
    out.reg_events(ii).time_start   = out.time( tem_ind(1)   );
    out.reg_events(ii).time_end     = out.time( tem_ind(end) );
    

    % ---- daily stats ----
    % mean values from each station!
    % Please note that this is different from values based on regional mean temperature
    % e.g., [out.reg_events(ii).temp_min_24h.mean] is the mean value of
    %            minmal temperature within 24 hours at each station.
    %            However, different stations may reach their minimal
    %            temperature at different hours. 

    out.reg_events(ii).temp_min_day1.mean = nanmean( out.daily_min(:, tem_ind(1) ), 1);
    out.reg_events(ii).temp_min_day1.max  = max(     out.daily_min(:, tem_ind(1) ), [], 1);
    out.reg_events(ii).temp_min_day1.min  = min(     out.daily_min(:, tem_ind(1) ), [], 1);

    out.reg_events(ii).temp_min_24h.mean = nanmean( min( out.daily_min_24h(:,tem_ind), [], 2 ), 1 );
    out.reg_events(ii).temp_min_24h.max  = max(     min( out.daily_min_24h(:,tem_ind), [], 2 ), [], 1 );
    out.reg_events(ii).temp_min_24h.min  = min(     min( out.daily_min_24h(:,tem_ind), [], 2 ), [], 1 );

    out.reg_events(ii).temp_min_48h.mean = nanmean( min( out.daily_min_48h(:,tem_ind), [], 2 ), 1 );
    out.reg_events(ii).temp_min_48h.max  = max(     min( out.daily_min_48h(:,tem_ind), [], 2 ), [], 1 );
    out.reg_events(ii).temp_min_48h.min  = min(     min( out.daily_min_48h(:,tem_ind), [], 2 ), [], 1 );

    out.reg_events(ii).temp_min_72h.mean = nanmean( min( out.daily_min_72h(:,tem_ind), [], 2 ), 1 );
    out.reg_events(ii).temp_min_72h.max  = max(     min( out.daily_min_72h(:,tem_ind), [], 2 ), [], 1 );
    out.reg_events(ii).temp_min_72h.min  = min(     min( out.daily_min_72h(:,tem_ind), [], 2 ), [], 1 );

    out.reg_events(ii).tdrop_24h.mean    = nanmean( max( out.tdrop_24h(:,tem_ind), [], 2 ), 1 );
    out.reg_events(ii).tdrop_24h.max     = max(     max( out.tdrop_24h(:,tem_ind), [], 2 ), [], 1 );
    out.reg_events(ii).tdrop_24h.min     = min(     max( out.tdrop_24h(:,tem_ind), [], 2 ), [], 1 );

    out.reg_events(ii).tdrop_48h.mean    = nanmean( max( out.tdrop_48h(:,tem_ind), [], 2 ), 1 );
    out.reg_events(ii).tdrop_48h.max     = max(     max( out.tdrop_48h(:,tem_ind), [], 2 ), [], 1 );
    out.reg_events(ii).tdrop_48h.min     = min(     max( out.tdrop_48h(:,tem_ind), [], 2 ), [], 1 );
    
    out.reg_events(ii).tdrop_72h.mean    = nanmean( max( out.tdrop_72h(:,tem_ind), [], 2 ), 1 );
    out.reg_events(ii).tdrop_72h.max     = max(     max( out.tdrop_72h(:,tem_ind), [], 2 ), [], 1 );
    out.reg_events(ii).tdrop_72h.min     = min(     max( out.tdrop_72h(:,tem_ind), [], 2 ), [], 1 );

    % % % % % % % This is removed. please refer to FUN_atm_coldwave_temp_stat.m
    % % % % % % % --------------------------------------------------------------------------------------------------
    % % % % % % % hourly stats
    % % % % % % %
    % % % % % % % values here are based on regional mean temperature. 
    % % % % % % 
    % % % % % % 
    % % % % % % % ---- 72h ----
    % % % % % % tem_time_period(1) = floor( out.reg_events(ii).time_start ) - 10/24 ; % day 1 is definied as (14:00 of the previous day (excluded),  14:00 of the current day(indcluded)].
    % % % % % % tem_time_period(2) = floor( out.reg_events(ii).time_end ) + 14/24 + 72/24 ; % consider 72 hours after the arrivial of the cold wave
    % % % % % % 
    % % % % % % timeloc_h = timelist > tem_time_period(1) & timelist <= tem_time_period(2);
    % % % % % % out.reg_events(ii).hourly.time = timelist(timeloc_h);
    % % % % % % out.reg_events(ii).hourly.temp = nanmean( temp(:,timeloc_h),  1 );
    % % % % % % 
    % % % % % % % ref temperature
    % % % % % % out.reg_events(ii).hourly.ref_daily_min = out.reg_events(ii).temp_min_day1.mean;
    % % % % % % 
    % % % % % % % 72h min temperature
    % % % % % % [tem_min_val, tem_min_ind ] = min(out.reg_events(ii).hourly.temp);
    % % % % % % out.reg_events(ii).hourly.min_temp_72h.temp = tem_min_val;
    % % % % % % out.reg_events(ii).hourly.min_temp_72h.time = out.reg_events(ii).hourly.time(tem_min_ind);
    % % % % % % 
    % % % % % % % temperature drop rate with time
    % % % % % % tem_loc = out.reg_events(ii).hourly.time <= out.reg_events(ii).hourly.min_temp_72h.time;
    % % % % % % 
    % % % % % % tem_time= out.reg_events(ii).hourly.time(tem_loc);
    % % % % % % tem_temp= out.reg_events(ii).hourly.temp(tem_loc);
    % % % % % % [tem_min_val, tem_min_ind ] = max( -diff( tem_temp ));
    % % % % % % out.reg_events(ii).hourly.max_hourly_tdrop_rate.gradient = tem_min_val;
    % % % % % % out.reg_events(ii).hourly.max_hourly_tdrop_rate.time     = tem_time(tem_min_ind)+1/24/2;
    % % % % % % 
    % % % % % % % 72h max drop
    % % % % % % out.reg_events(ii).hourly.max_tdrop_72h.tdrop = out.reg_events(ii).hourly.ref_daily_min - out.reg_events(ii).hourly.min_temp_72h.temp;
    % % % % % % out.reg_events(ii).hourly.max_tdrop_72h.time  = out.reg_events(ii).hourly.min_temp_72h.time;
    % % % % % % 

end

%%
% =========================================================================
% summarize regional events
% =========================================================================

    out.reg_events_mat.time_start    = [out.reg_events(:).time_start];
    out.reg_events_mat.time_end      = [out.reg_events(:).time_end  ];
    out.reg_events_mat.level         = [out.reg_events(:).level    ];
    out.reg_events_mat.length        = [out.reg_events(:).length   ];
    out.reg_events_mat.ref_daily_min = arrayfun(@(x)x.temp_min_day1.mean, out.reg_events);

    % % % % out.reg_events_mat.hourly.max_hourly_tdrop_rate.gradient = arrayfun(@(x)x.hourly.max_hourly_tdrop_rate.gradient, out.reg_events);
    % % % % out.reg_events_mat.hourly.max_hourly_tdrop_rate.time = arrayfun(@(x)x.hourly.max_hourly_tdrop_rate.time, out.reg_events);
    % % % % 
    % % % % out.reg_events_mat.hourly.min_temp_72h.time      = arrayfun(@(x)x.hourly.min_temp_72h.time, out.reg_events);
    % % % % out.reg_events_mat.hourly.min_temp_72h.temp      = arrayfun(@(x)x.hourly.min_temp_72h.temp, out.reg_events);
    % % % % out.reg_events_mat.hourly.max_tdrop_72h.tdrop    = arrayfun(@(x)x.hourly.max_tdrop_72h.tdrop, out.reg_events);

    % out.reg_events.mat.time_start = [out.reg_events(:).time_start];

end
%%
% =========================================================================
% reshape output results
% =========================================================================

if length( size0_xy ) == 1 
    % not necessary

else

    % reshape
    nt2 = length( out.time );
    
    fields_list_to_resize = {'daily_min','daily_min_24h','daily_min_48h','daily_min_72h','tdrop_24h','tdrop_48h','tdrop_72h','cold_day_level'};
    
    for ii = 1:length(fields_list_to_resize)
    
        vn = fields_list_to_resize{ii};
        out.(vn) = reshape( out.(vn), [size0_xy, nt2] );
    
    end

end

%%
% =========================================================================
% Additional notes
% =========================================================================

    out.note{1} = 'positive tdrop indicate decreasing temerature with time!';
    out.note{2} = 'daily_min is the mean temperature before cold wave arrivals! And so does out.reg_events(ii).ref_daily_min!';
    out.note{3} = 'out.reg_events(ii).ref_daily_min is the mean temperature before cold wave arrivals (regonal mean)!';
    out.note{4} = '[out.reg_events(ii).temp_min_48h.mean] is the mean value of min 48h temperature. However, the different stations may reach the min temperature at different time!';
    out.note{5} = '[out.reg_events(ii).hourly.(:)] are derived from regional mean temperature!';
    %out.note{4} = '[out.reg_events(ii).temp_min_48h.mean] is the mean value of min 48h temperature. However, the different stations may reach the min temperature at different time!';
























