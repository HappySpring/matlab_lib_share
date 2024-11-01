function [cdata, cday_in_year, chour] = FUN_TS_climate_hourly_wDailyCyc_movingWindow( time, data, varargin)
% cdata = FUN_TS_climate_hourly_moving_window( time, data, [hwind] )
%
%  INPUT:
%       time: time in matlab format. It must be hourly data
%       data: 
%  output
%       cdata: [nx, ndays, nhour] climate mean
%       cday_in_year              days in year
%       chour                     hour
%
%
% V1.20 by L. Chi: fix a bug if time & data is given as [n x 1]. (It requires time and data
%                  in [1 x n] size previously. From this version, both are
%                  acceptable. 
%                  add more input checks. 
% V1.10 by L. Chi: support leap year.
%                  correct if condition for warning info.
% V1.00 by L. Chi (L.Chi.Ocean@outlook.com)


% time = t_atm;
% data  = t2m_atm;

is_rm_loadedd_param = true;

% half window for moving mean: it averages data between [ t-hwind : t+hwind],
% totally 2*hwind+1 time slots.
% set 'hwind' as 0 will turn off moving mean.
[hwind, varargin] = FUN_codetools_read_from_varargin( varargin, 'hwind', 5, is_rm_loadedd_param );

if ~isempty(varargin)
    error
end

% hwind = 5; % half of the avg window

%%
% -------------------------------------------------------------------------
% preparation
% -------------------------------------------------------------------------
time = time(:)';
if isvector( data )
    data = data(:)'; % make sure data is 1 x nt if it is a vector.
end


size0 = size(data);
size_spat = size0(1:end-1);
nxx       = prod( size0(1:end-1) );
nt        = size0(end);

data = reshape( data, nxx, nt);

% input must be hourly data
if all( abs( diff(time) - 1/24) < 1/243600 )
else
    error
end

%%
% -------------------------------------------------------------------------
% handle leap year
% -------------------------------------------------------------------------

time_day_in_year = FUN_time_get_days_in_year_int(time);
[time_year, time_mon, time_day] = datevec(time);
ny        = length(unique(time_year));

ind = find(time_mon == 2 & time_day == 29);

if ~isnan(ind)
   % this will return errors if Feb 29 is located at the beginning or end
   % of the time series.
   data(:,ind-24) = ( data(:,ind-24) + data(:,ind)*0.5 ) /1.5;
   data(:,ind+24) = ( data(:,ind-24) + data(:,ind)*0.5 ) /1.5;

   data(:,ind) = [];
   time(ind)   = [];
   time_day_in_year(ind)   = [];
   time_year(ind)  = [];
   time_mon(ind)   = [];
   time_day(ind)   = [];
   nt = nt - length(ind);

   % error('Era5 does not include Feb 29 in leap year?! This part is not finished!') 
   % put values on Feb 29 on Feb 28 and March 1st.
end


% ---- fix time_day_in_year after leap year handled.
time_day_in_year = FUN_time_get_days_in_year_int_365only(time);
time_hours       = hour(time);

%%
% -------------------------------------------------------------------------
% Climate mean
% -------------------------------------------------------------------------

% ---- initialization ----------
t_clim_demo = datenum(1, 1, 1:365); % there are 29 days in feb for year 0000.
[~, cmon, cday] = datevec( t_clim_demo ) ; 

% cday_in_year = FUN_time_get_days_in_year_int( t_clim_demo );
cday_in_year = unique(time_day_in_year);
if length(cday_in_year) == 365
else
    warning(['time_day_in_year = ' num2str(length(cday_in_year)), ', which is not 365 days!!']);
end

% ---- initialization ----------


chour = unique( time_hours );

cdata = nan(nxx, length(cday_in_year), length(chour) ); % [x, year, hour];

for id = 1:length( cday_in_year )
    
    fprintf(' processing day %i \n', id);
    dn = cday_in_year(id);

    % window to be used for calculaitng climate mean
    days_sel = dn-hwind : 1 : dn+hwind;
    days_sel(days_sel<=0) = days_sel(days_sel<=0)  + 365;
    days_sel(days_sel>365)= days_sel(days_sel>365) - 365;    
    %
    for ih = 1:length(chour)
        
        hn = chour(ih);

        tem_loc = ismember(time_day_in_year, days_sel) & time_hours == hn;
        
        if sum( tem_loc ) == (hwind*2+1)*ny
            %pass
        elseif sum( tem_loc ) >= (hwind*2+1)*ny*0.8

        elseif sum( tem_loc ) < (hwind*2+1)*ny*0.8 && sum( tem_loc ) > 0
            warning(sprintf('  %i records  are used for day %i, hour %i, which is less than 80%% of the expectetd number of records: %i ', sum(tem_loc), dn, hn, (hwind*2+1)*ny ))

        else
            error;
        end

        cdata( :, id, ih ) = nanmean( data(:, tem_loc), 2 );

    end
end


%%
% -------------------------------------------------------------------------
% reshape back to original size
% -------------------------------------------------------------------------

cdata = reshape( cdata, [size_spat,  length(cday_in_year), length(chour)] );


