function [cw2, cw2_mat] = FUN_atm_coldwave_temp_stat_v3( cw_event, timelist, temp, u10, v10 )
% [cw2, cw2_mat] = FUN_atm_coldwave_temp_stat( cw_time_start, timelist, temp )
%
% create stat of cold air/cold wave events
%
% INPUT:
%     cw_event should contains at least the following 4 fields. 
%              cw_event(ii).time_start: start time of the cold wave event. It must be located at 0 o'clock of the day
%              cw_event(ii).time_end;   end time of the cold wave event. It must be located at 0 o'clock of the day
%              cw_event(ii).level;    intensity level
%              cw_event(ii).length;   duration of the cold air events in days 
%
%              cw_event can be created by FUN_atm_coldwave_day_detection
%
% OUTPUT
%
%     cw2: results by event
%     cw2_mat: a matrix summarizing major outputs
%

% V3.11 by L. Chi: timelimit in matrix is saved in [2, nt] now
% V3.10 by L. Chi: fix a bug;
%                  add cumulated cold wave strength.
% V3.01 by L. Chi: fix a bug. min_temp is used for v10;
% V3.00 by L. Chi: add more variables.
% V1.01 by L. Chi
%            Fix a bug in "cw2(ii).min_temp_v10" & "cw2(ii).max_hourly_drop_d1.v10": u10 is used by mistake
% V1.00 by L. Chi.


%%
% =========================================================================
% processing each event 
% =========================================================================

for ii = 1:length(cw_event)

    cw2(ii).time_start = cw_event(ii).time_start;
    cw2(ii).time_end   = cw_event(ii).time_end;
    cw2(ii).length     = cw_event(ii).length;
    cw2(ii).level      = cw_event(ii).level;
    
    time_period_day1   = [floor( cw2(ii).time_start )-10/24,  floor( cw2(ii).time_start )+14/24];
    time_period_coldair= [floor( cw2(ii).time_start )-10/24,  floor( cw2(ii).time_end   )+14/24+1];

    time_period_all    = [floor( cw2(ii).time_start )-10/24,  floor( cw2(ii).time_end   )+14/24+72/24];

    % exntended period: from -3 to +3
    time_period_alle   = [floor( cw2(ii).time_start )-10/24-3,  floor( cw2(ii).time_end )+14/24+72/24+3];

    % time_period_24h  = [floor( cw2(ii).time_start )+14/24,  floor( cw2(ii).time_end   )+14/24 + 1];
    % time_period_48h  = [floor( cw2(ii).time_start )+14/24,  floor( cw2(ii).time_end   )+14/24 + 2];
    % time_period_72h  = [floor( cw2(ii).time_start )+14/24,  floor( cw2(ii).time_end   )+14/24 + 3];


    %% ref ( day1 )
    timeloc = timelist > time_period_day1(1) & timelist <= time_period_day1(2);
    tem_time= timelist(timeloc);
    tem_temp= temp(timeloc);
    tem_u10 = u10(timeloc);
    tem_v10 = v10(timeloc);

    
    cw2(ii).ref.timelimit = time_period_day1;
    cw2(ii).ref.temp_min = min( tem_temp );
    cw2(ii).ref.temp_mean= mean( tem_temp);
    cw2(ii).ref.u10_mean = mean( tem_u10 );
    cw2(ii).ref.v10_mean = mean( tem_v10 );

    %% cum (ref)

    timeloc = timelist > time_period_coldair(1) & timelist <= time_period_coldair(2);
    tem_time= timelist(timeloc);
    tem_temp= temp(timeloc);
    tem_u10 = u10(timeloc);
    tem_v10 = v10(timeloc);


    tem_int_val = sum( cw2(ii).ref.temp_mean - tem_temp );

    cw2(ii).cum.temp_drop_ref_day1 = sum( cw2(ii).ref.temp_mean - tem_temp );
    cw2(ii).cum.v10_ref_day1       = sum( tem_v10 - cw2(ii).ref.v10_mean );
    cw2(ii).cum.v10_abs            = sum( tem_v10 );
    cw2(ii).cum.u10_ref_day1       = sum( tem_u10 - cw2(ii).ref.u10_mean );
    cw2(ii).cum.u10_abs            = sum( tem_u10 );


    %% the entire event
    timeloc = timelist > time_period_all(1) & timelist <= time_period_all(2);
    tem_time= timelist(timeloc);
    tem_temp= temp(timeloc);
    tem_u10 = u10(timeloc);
    tem_v10 = v10(timeloc);

    cw2(ii).hourly.time = tem_time;
    cw2(ii).hourly.temp = tem_temp;
    cw2(ii).hourly.u10  = tem_u10;
    cw2(ii).hourly.v10  = tem_v10;

    %% the entire event extended 
    timeloc = timelist > time_period_alle(1) & timelist <= time_period_alle(2); 
    cw2(ii).hourly_extend.time = timelist(timeloc); 
    cw2(ii).hourly_extend.temp = temp(timeloc); 
    cw2(ii).hourly_extend.u10  = u10(timeloc); 
    cw2(ii).hourly_extend.v10  = v10(timeloc); 

    %% min temperature  
    time_period_finding_min = time_period_all;
    if ii < length(cw_event)
        if time_period_finding_min(2) > cw_event(ii+1).time_start-10/24           
            time_period_finding_min(2) = cw_event(ii+1).time_start-10/24;
        end
    end

    timeloc = timelist > time_period_finding_min(1) & timelist <= time_period_finding_min(2);
    tem_time= timelist(timeloc);
    tem_temp= temp(timeloc);
    tem_u10 = u10(timeloc);
    tem_v10 = v10(timeloc);
    
    % temperature
    [cw2(ii).min_temp.temp, tem_ind2] = min( tem_temp );
    cw2(ii).min_temp.time          = tem_time(tem_ind2);
    cw2(ii).min_temp.max_temp_drop = cw2(ii).ref.temp_min - cw2(ii).min_temp.temp;
    cw2(ii).min_temp.u10           = tem_u10(tem_ind2);
    cw2(ii).min_temp.v10           = tem_v10(tem_ind2);

    % v10
    [cw2(ii).min_v10.v10, tem_ind2] = min( tem_v10 );
    cw2(ii).min_v10.time           = tem_time(tem_ind2);
    cw2(ii).min_v10.max_v10_drop   = cw2(ii).ref.v10_mean - cw2(ii).min_v10.v10;
    cw2(ii).min_v10.u10            = tem_u10(tem_ind2);
    cw2(ii).min_v10.temp           = tem_temp(tem_ind2);

    
    %% the max drop rate
    % max drop will only search days matching cold air standards. 
    % this will avoid getting max drop graident from a following cold air event 
    timeloc = timelist > time_period_coldair(1) & timelist <= time_period_coldair(2);
    tem_time= timelist(timeloc);
    tem_temp= temp(timeloc);
    tem_u10 = u10(timeloc);
    tem_v10 = v10(timeloc);
    
    % temperature
    [cw2(ii).max_hourly_drop.temp.drop_rate, tem_ind] = max( -diff( tem_temp ) );
    cw2(ii).max_hourly_drop.temp.time       = tem_time(tem_ind) + 1/24/2;
    cw2(ii).max_hourly_drop.temp.ind_local  = tem_ind; % index in the local time series.
    cw2(ii).max_hourly_drop.temp.u10        = mean(tem_u10(tem_ind:tem_ind+1)); % index in the local time series.
    cw2(ii).max_hourly_drop.temp.v10        = mean(tem_v10(tem_ind:tem_ind+1)); % index in the local time series.
    cw2(ii).max_hourly_drop.temp.temp       = mean(tem_temp(tem_ind:tem_ind+1)); % index in the local time series.

    % v10
    [cw2(ii).max_hourly_drop.v10.drop_rate, tem_ind] = max( -diff( tem_v10 ) );
    cw2(ii).max_hourly_drop.v10.time       = tem_time(tem_ind) + 1/24/2;
    cw2(ii).max_hourly_drop.v10.ind_local  = tem_ind; % index in the local time series.
    cw2(ii).max_hourly_drop.v10.u10        = mean(tem_u10(tem_ind:tem_ind+1)); % index in the local time series.
    cw2(ii).max_hourly_drop.v10.v10        = mean(tem_v10(tem_ind:tem_ind+1)); % index in the local time series.
    cw2(ii).max_hourly_drop.v10.temp       = mean(tem_temp(tem_ind:tem_ind+1)); % index in the local time series.

    %% the max drop on day 1
    % This is used to identify the beginning of the event.
    time_period_coldair_d1   = [floor( cw2(ii).time_start )-10/24,  floor( cw2(ii).time_start )+14/24+1];

    timeloc = timelist > time_period_coldair_d1(1) & timelist <= time_period_coldair_d1(2);
    tem_time= timelist(timeloc);
    tem_temp= temp(timeloc);
    tem_u10 = u10(timeloc);
    tem_v10 = v10(timeloc);
    
    % temperature
    [cw2(ii).max_hourly_drop_d1.temp.drop_rate, tem_ind] = max( -diff( tem_temp ) );
    cw2(ii).max_hourly_drop_d1.temp.time       = tem_time(tem_ind) + 1/24/2;
    cw2(ii).max_hourly_drop_d1.temp.ind_local  = tem_ind; % index in the local time series.
    cw2(ii).max_hourly_drop_d1.temp.u10        = tem_u10(tem_ind); % index in the local time series.
    cw2(ii).max_hourly_drop_d1.temp.v10        = tem_v10(tem_ind); % index in the local time series.
    cw2(ii).max_hourly_drop_d1.temp.temp       = tem_temp(tem_ind); % index in the local time series.

    % v10
    [cw2(ii).max_hourly_drop_d1.v10.drop_rate, tem_ind] = max( -diff( tem_v10 ) );
    cw2(ii).max_hourly_drop_d1.v10.time       = tem_time(tem_ind) + 1/24/2;
    cw2(ii).max_hourly_drop_d1.v10.ind_local  = tem_ind; % index in the local time series.
    cw2(ii).max_hourly_drop_d1.v10.u10        = tem_u10(tem_ind); % index in the local time series.
    cw2(ii).max_hourly_drop_d1.v10.v10        = tem_v10(tem_ind); % index in the local time series.
    cw2(ii).max_hourly_drop_d1.v10.temp       = tem_temp(tem_ind); % index in the local time series.

end


%%
% =========================================================================
% summarize regional events
% =========================================================================
 
    cw2_mat.time_start    = [cw2(:).time_start];
    cw2_mat.time_end      = [cw2(:).time_end  ];
    cw2_mat.level         = [cw2(:).level     ];
    cw2_mat.length        = [cw2(:).length    ];

    % ref
    tem1 = arrayfun( @(x)x.ref.timelimit(1), cw2 );
    tem2 = arrayfun( @(x)x.ref.timelimit(2), cw2 );
    cw2_mat.ref.timelimit = [tem1(:)'; tem2(:)'];
    cw2_mat.ref.temp_min = arrayfun( @(x)x.ref.temp_min, cw2 );
    cw2_mat.ref.u10_mean = arrayfun( @(x)x.ref.u10_mean, cw2 );
    cw2_mat.ref.v10_mean = arrayfun( @(x)x.ref.v10_mean, cw2 );

    % cum
    cw2_mat.cum.temp_drop_ref_day1 = arrayfun( @(x)x.cum.temp_drop_ref_day1, cw2 );
    cw2_mat.cum.v10_ref_day1       = arrayfun( @(x)x.cum.v10_ref_day1, cw2 );
    cw2_mat.cum.v10_abs            = arrayfun( @(x)x.cum.v10_abs, cw2 );
    cw2_mat.cum.u10_ref_day1       = arrayfun( @(x)x.cum.u10_ref_day1, cw2 );
    cw2_mat.cum.u10_abs            = arrayfun( @(x)x.cum.u10_abs, cw2 );
    
    % min temp
    cw2_mat.min_temp.time          = arrayfun( @(x)x.min_temp.time, cw2 );
    cw2_mat.min_temp.temp          = arrayfun( @(x)x.min_temp.temp, cw2 );
    cw2_mat.min_temp.max_temp_drop = arrayfun( @(x)x.min_temp.max_temp_drop, cw2 );
    cw2_mat.min_temp.u10           = arrayfun( @(x)x.min_temp.u10, cw2 );
    cw2_mat.min_temp.v10           = arrayfun( @(x)x.min_temp.v10, cw2 );

    % min v10
    cw2_mat.min_v10.time         = arrayfun( @(x)x.min_v10.time, cw2 );
    cw2_mat.min_v10.temp         = arrayfun( @(x)x.min_v10.temp, cw2 );
    cw2_mat.min_v10.max_v10_drop = arrayfun( @(x)x.min_v10.max_v10_drop, cw2 );
    cw2_mat.min_v10.u10          = arrayfun( @(x)x.min_v10.u10, cw2 );
    cw2_mat.min_v10.v10          = arrayfun( @(x)x.min_v10.v10, cw2 );

    % min temp drop
    cw2_mat.max_hourly_drop.temp.time      = arrayfun( @(x)x.max_hourly_drop.temp.time, cw2 );
    cw2_mat.max_hourly_drop.temp.drop_rate = arrayfun( @(x)x.max_hourly_drop.temp.drop_rate, cw2 );
    cw2_mat.max_hourly_drop.temp.temp      = arrayfun( @(x)x.max_hourly_drop.temp.temp, cw2 );
    cw2_mat.max_hourly_drop.temp.u10       = arrayfun( @(x)x.max_hourly_drop.temp.u10, cw2 );
    cw2_mat.max_hourly_drop.temp.v10       = arrayfun( @(x)x.max_hourly_drop.temp.v10, cw2 );

    % min v10 drop
    cw2_mat.max_hourly_drop.v10.time      = arrayfun( @(x)x.max_hourly_drop.v10.time,      cw2 );
    cw2_mat.max_hourly_drop.v10.drop_rate = arrayfun( @(x)x.max_hourly_drop.v10.drop_rate, cw2 );
    cw2_mat.max_hourly_drop.v10.temp      = arrayfun( @(x)x.max_hourly_drop.v10.temp,      cw2 );
    cw2_mat.max_hourly_drop.v10.u10       = arrayfun( @(x)x.max_hourly_drop.v10.u10,       cw2 );
    cw2_mat.max_hourly_drop.v10.v10       = arrayfun( @(x)x.max_hourly_drop.v10.v10,       cw2 );

    % min temp drop - the first day
    cw2_mat.max_hourly_drop_d1.temp.time      = arrayfun( @(x)x.max_hourly_drop_d1.temp.time, cw2 );
    cw2_mat.max_hourly_drop_d1.temp.drop_rate = arrayfun( @(x)x.max_hourly_drop_d1.temp.drop_rate, cw2 );
    cw2_mat.max_hourly_drop_d1.temp.temp      = arrayfun( @(x)x.max_hourly_drop_d1.temp.temp, cw2 );
    cw2_mat.max_hourly_drop_d1.temp.u10       = arrayfun( @(x)x.max_hourly_drop_d1.temp.u10, cw2 );
    cw2_mat.max_hourly_drop_d1.temp.v10       = arrayfun( @(x)x.max_hourly_drop_d1.temp.v10, cw2 );

    % min v10 drop - the first day
    cw2_mat.max_hourly_drop_d1.v10.time      = arrayfun( @(x)x.max_hourly_drop_d1.v10.time,      cw2 );
    cw2_mat.max_hourly_drop_d1.v10.drop_rate = arrayfun( @(x)x.max_hourly_drop_d1.v10.drop_rate, cw2 );
    cw2_mat.max_hourly_drop_d1.v10.temp      = arrayfun( @(x)x.max_hourly_drop_d1.v10.temp,      cw2 );
    cw2_mat.max_hourly_drop_d1.v10.u10       = arrayfun( @(x)x.max_hourly_drop_d1.v10.u10,       cw2 );
    cw2_mat.max_hourly_drop_d1.v10.v10       = arrayfun( @(x)x.max_hourly_drop_d1.v10.v10,       cw2 );








    

