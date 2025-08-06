function FUN_download_HYCOM_GOFS31_v1a_general_1994_to_present( var_download_list_shortname, output_fn_prefix, lonlimit, latlimit, depthlimit, timelimit )
% FUN_download_HYCOM_GOFS31_v1a_general_1994_to_present( var_download_list_shortname, output_fn_prefix, lonlimit, latlimit, depthlimit, timelimit )
% 
% Download hycom data from hycom.org via opendap
% It requires easy_netcdf
%
%
% INPUT: 
%      var_download_list_shortname [cell]: variable to be downloaded. 
%                                   **the input variable here must be a cell**
%                                   available options: ssh/temp/salt/u/v 
%                                   e.g., {'ssh'}, {'ssh','temp'}, {'ssh','temp','u','v'}
%                                  
%      output_fn_prefix: prefix of the output file
%      lonlimit:         range of longigude to be donwloaded like [166 168];
%                        Please note that hycom use 0-360 for longitude
%      latlimit:         range of latitude to be donwloaded like [65 66];
%      depthlimit:       range of depth to be donwloaded like [0 10];
%      timelimit:       range of depth to be donwloaded like [datenum(2016,6,1) datenum(2016,6,6)];
%
% V1.2b: fix a bug introduced in recent versions.
% V1.2: fix a bug: the script may return no exp found 
%                      if timelimit(1) == timelimit(2)
% V1.1: update time limits for Exp 53.X
% by L. Chi (L.Chi.Ocean@outlook.com)
%
%
% ========================= DEMO ==========================================
% var_download_list_shortname = {'temp'};
% output_fn_prefix  = 'test01';
% lonlimit          =  [165 166];
% latlimit          =  [50 51];
% depthlimit        =  [0 5];
% timelimit         =  [datenum(2016,6,1) datenum(2016,6,2,23,59,59)];
% 
% 
% FUN_download_HYCOM_GOFS31_v1a_general_1994_to_present( var_download_list_shortname, output_fn_prefix, lonlimit, latlimit, depthlimit, timelimit )
% =========================================================================


%% prepare the input
if ~iscell( var_download_list_shortname )
    var_download_list_shortname = {var_download_list_shortname};
end

if any(lonlimit<0)
    warning('Please note that hycom.org use 0-360 for longitude!')
end

%% available variables
iv = 0;

iv = iv + 1;
var_list(iv).short_name = 'ssh';
var_list(iv).name = 'surf_el';
var_list(iv).is3D = false;
var_list(iv).var_url_style{1} = 'ssh'; % extra name used in URL.

iv = iv + 1;
var_list(iv).short_name = 'temp';
var_list(iv).name = 'water_temp';
var_list(iv).is3D = true;
var_list(iv).var_url_style{1} = 't3z';

iv = iv + 1;
var_list(iv).short_name = 'salt';
var_list(iv).name = 'salinity';
var_list(iv).is3D = true;
var_list(iv).var_url_style{1} = 's3z';

iv = iv + 1;
var_list(iv).short_name = 'u';
var_list(iv).name = 'water_u';
var_list(iv).is3D = true;
var_list(iv).var_url_style{1} = 'u3z';

iv = iv + 1;
var_list(iv).short_name = 'v';
var_list(iv).name = 'water_v';
var_list(iv).is3D = true;
var_list(iv).var_url_style{1} = 'v3z';


%% exp information

sourcebase = 'http://tds.hycom.org/thredds/dodsC' ;


% Please note that the timelimit in this section is extracted from 
%  "https://www7320.nrlssc.navy.mil/GLBhycomcice1-12/"
% Data may be still available out of the timelimit below on hycom.org 

ie = 0;

% Reanalysis --------------------------------------------------------------

for year_now = 1994:2015
    
    ie = ie + 1;
    exp(ie).id        = '53.X';
    exp(ie).name      = ['expt_' exp(ie).id];
    exp(ie).group     = 'GLBv0.08';
    exp(ie).url       = [ sourcebase, '/', exp(ie).group, '/', exp(ie).name, '/data/', num2str(year_now) ];
    exp(ie).url_style = 0;
    
    if year_now == 2015 
        exp(ie).timelimit = [ datenum( year_now, 1, 1, 12, 0, 0 ), datenum(year_now, 12, 31, 9, 0, 0)];
    elseif year_now == 1994
        exp(ie).timelimit = [ datenum( year_now, 1, 1, 12, 0, 0 ), datenum(year_now, 12, 31, 21, 0, 0)];
    else
        exp(ie).timelimit = [ datenum( year_now, 1, 1,  0, 0, 0 ), datenum(year_now, 12, 31, 21, 0, 0)];

    end
    
end

% handcast archived -------------------------------------------------------
ie = ie + 1;
exp(ie).id        = '56.3';
exp(ie).name      = ['expt_' exp(ie).id];
exp(ie).group     = 'GLBv0.08';
exp(ie).url       = [ sourcebase, '/', exp(ie).group, '/', exp(ie).name ];
%exp(ie).timelimit = [ datenum(2014, 7, 1, 12, 0, 0), datenum(2016, 5, 1, 9, 0, 0)];
exp(ie).timelimit = [ datenum(2015, 12, 31, 12, 0, 0), datenum(2016, 5, 1, 9, 0, 0)]; % It is shorten to follow expt 53.X
exp(ie).url_style = 0;

ie = ie + 1;
exp(ie).id        = '57.2';
exp(ie).name      = ['expt_' exp(ie).id];
exp(ie).group     = 'GLBv0.08';
exp(ie).url       = [ sourcebase, '/', exp(ie).group, '/', exp(ie).name ];
exp(ie).timelimit = [ datenum(2016, 5, 1, 12, 0, 0), datenum(2017, 2, 1, 9, 0, 0)];
exp(ie).url_style = 0;

ie = ie + 1;
exp(ie).id        = '92.8';
exp(ie).name      = ['expt_' exp(ie).id];
exp(ie).group     = 'GLBv0.08';
exp(ie).url       = [ sourcebase, '/', exp(ie).group, '/', exp(ie).name ];
exp(ie).timelimit = [ datenum(2017, 2, 1, 12, 0, 0), datenum(2017, 6, 1, 9, 0, 0)];
exp(ie).url_style = 0;

ie = ie + 1;
exp(ie).id        = '57.7';
exp(ie).name      = ['expt_' exp(ie).id];
exp(ie).group     = 'GLBv0.08';
exp(ie).url       = [ sourcebase, '/', exp(ie).group, '/', exp(ie).name ];
exp(ie).timelimit = [ datenum(2017, 6, 1, 12, 0, 0), datenum(2017, 10, 1, 9, 0, 0)];
exp(ie).url_style = 0;

ie = ie + 1;
exp(ie).id        = '92.9';
exp(ie).name      = ['expt_' exp(ie).id];
exp(ie).group     = 'GLBv0.08';
exp(ie).url       = [ sourcebase, '/', exp(ie).group, '/', exp(ie).name ];
exp(ie).timelimit = [ datenum(2017, 10, 1, 12, 0, 0), datenum(2018, 1, 1, 9, 0, 0)];
exp(ie).url_style = 0;

ie = ie + 1;
exp(ie).id        = '93.0';
exp(ie).name      = ['expt_' exp(ie).id];
exp(ie).group     = 'GLBv0.08';
exp(ie).url       = [ sourcebase, '/', exp(ie).group, '/', exp(ie).name ];
exp(ie).timelimit = [ datenum(2018, 1, 1, 12, 0, 0), datenum(2020,2,19, 9, 0, 0)];
exp(ie).url_style = 0;

ie = ie + 1;
exp(ie).id        = '93.0';
exp(ie).name      = ['expt_' exp(ie).id];
exp(ie).group     = 'GLBy0.08'; % << it is GLBy, not GLBv!
exp(ie).url       = [ sourcebase, '/', exp(ie).group, '/', exp(ie).name ];
exp(ie).timelimit = [ datenum(2020,2,19, 12, 0, 0), datenum(2024,9, 4, 23, 59, 59 ) ]; % it actually ends at 2024-09-05T09:00:00.000Z
exp(ie).url_style = 0;

% handcast (active) -------------------------------------------------------

ie = ie + 1;
exp(ie).id        = '03.1';
exp(ie).name      = ['expt_' exp(ie).id];
exp(ie).group     = 'ESPC-D-V02'; % << it is GLBy, not GLBv!
exp(ie).url       = [ sourcebase, '/', exp(ie).group ];
exp(ie).timelimit = [ datenum(2024, 9, 5, 0, 0, 0), now ];
exp(ie).url_style = 1;



%%
for ie = 1:length( exp )
    
    exp_now = exp(ie);
    
    [ time_period, timelimit_now] = FUN_TS_overlap_distance( exp_now.timelimit, timelimit );
    
    if isnan(timelimit_now(1))
        continue 
    end

    for ivar = 1:length( var_download_list_shortname )
        
        % ---- interface ---- %
        var_shortname_now = var_download_list_shortname{ivar};
        
        iv = FUN_struct_find_field_ind( var_list, 'short_name', var_shortname_now );
        var_now     = var_list(iv);

        % 
        if exp_now.url_style == 0
            filename0 = exp_now.url;
        elseif exp_now.url_style == 1
            filename0 = [exp_now.url, '/', var_now.var_url_style{1}];
        else
            error
        end
        
        % get time from the remote netcdf file ------------
        count_err = 0;
        N_max_retry = 10;
        pause_seconds = 15;
        
        while count_err <= N_max_retry
            
            try
                [ time_limit_in_ori, time_mtl ] = FUN_nc_gen_time_val_limit( filename0, 'time', timelimit_now );
                count_err = inf;
            catch err_log
                fprintf('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n' );
                FUN_ErrorInfoDisp( err_log )
                
                count_err = count_err + 1;
                
                fprintf(' \n' );
                warning(['Err, retry count: ' num2str( count_err )] );
                
                if count_err >= N_max_retry %0 ">=" is adopted in case N_max_retry is set to 0.
                    warning('>>>>>> Reach N_max_retry(=%i), stop <<<<<< \n', N_max_retry)
                    % This will return an error message by default
                    continue
                    
                else % sleep for a while before next try.
                    
                    fprintf('Wait for %.2f seconds ... \n', pause_seconds );
                    pause(pause_seconds) %retry after 30 seconds
                    
                    fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n' );
                    
                end
            end    
        end
        % -----------------------------------------------
        
        if any( isnan( time_limit_in_ori ) )
            fid_log2 = fopen('Log.File_not_created.log','w+');
            fprintf('[%s] No data available during %s from %s\n', datestr(now,0), FUN_str_timelimit_from_time( timelimit_now, 'yyyymmdd HH:MM', ' - '), filename0 )
            fprintf(fid_log2,'[%s] No data available during %s from %s\n', datestr(now,0), FUN_str_timelimit_from_time( timelimit_now, 'yyyymmdd HH:MM', ' - '), filename0 )
            fclose(fid_log2);
            continue    
        end
        
        year_limit_now_str = FUN_str_timelimit_from_time( time_mtl, 'yyyymmdd', '-' );
        filename1 = [output_fn_prefix '_'  year_limit_now_str '_' exp_now.group exp_now.name '_' var_now.name '.nc'];
        
        if var_now.is3D == 1
            dim_limit_var = {'lon','lat', 'depth', 'time' };
            dim_limit_val =  { lonlimit, latlimit, depthlimit, time_limit_in_ori};

        else
            dim_limit_var = {'lon','lat', 'time' };
            dim_limit_val =  { lonlimit, latlimit, time_limit_in_ori};
            
        end
        
        var_download = { var_now.name, 'lon','lat', 'time','depth'} ;
        var_divided  =  var_now.name;
        divided_dim_str = ['time'];
        Max_Count_per_group = 48;
        
        fprintf('-------------------------------------------------------------------\n')
        fprintf('[%s] Downloading variable: %s (Period: %s)\n', datestr(now,0), var_now.name, FUN_str_timelimit_from_time(timelimit_now,'yyyymmdd HH:MM', ' - ') );
        fprintf('[%s] Downloading from %s \n',  datestr(now,0), filename0 );
        fprintf('[%s]             to   %s \n',  datestr(now,0), filename1 );
        FUN_nc_OpenDAP_with_limit( filename0, filename1, dim_limit_var, dim_limit_val, var_download, var_divided, divided_dim_str, Max_Count_per_group  );
        fprintf('[%s] Done \n',  datestr(now,0) )
        fprintf('-------------------------------------------------------------------\n')
    end
end

%%
% =========================================================================
% script for setting time boundary of exp 53.x 
% =========================================================================


% % % 
% % % =======================================================================
% % % SCRIPTS: update dataset boundary 
% % % =======================================================================
% % 
% % ie = 0;
% % sourcebase = 'http://tds.hycom.org/thredds/dodsC' ;
% % 
% % % Reanalysis --------------------------------------------------------------
% % for year_now = 1994:2015    
% %     ie = ie + 1;
% %     exp(ie).id        = '53.X';
% %     exp(ie).name      = ['expt_' exp(ie).id];
% %     exp(ie).group     = 'GLBv0.08';
% %     exp(ie).url       = [ sourcebase, '/', exp(ie).group, '/', exp(ie).name, '/data/', num2str(year_now) ];
% % 
% %     if year_now == 2015 
% %         exp(ie).timelimit = [ datenum( year_now, 1, 1, 12, 0, 0 ), datenum(year_now, 12, 31, 9, 0, 0)];
% %     else
% %         exp(ie).timelimit = [ datenum( year_now, 1, 1, 12, 0, 0 ), datenum(year_now+1, 1, 1, 9, 0, 0)];
% %     end
% % end
% % 
% % for ii = 1:length(exp)
% %     t1 = FUN_nc_get_time_in_matlab_format( exp(ii).url, 'time', 0, 1, 1);
% % 
% %     nn = FUN_nc_get_dim_length( exp(ii).url, 'time');
% %     t2 = FUN_nc_get_time_in_matlab_format( exp(ii).url, 'time', nn-1, 1, 1);
% % 
% %     disp([ exp(ii).url,  '   ' , datestr(t1,0), ' ------ ',   datestr(t2,0) ])
% % end
% % 



% % % 
% % % =======================================================================
% % % RESULTS:
% % % =======================================================================
% % 
%      http://tds.hycom.org/thredds/dodsC/GLBv0.08/expt_53.X/data/1994   01-Jan-1994 12:00:00 ------ 31-Dec-1994 21:00:00








