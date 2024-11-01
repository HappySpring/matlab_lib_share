function [year_out, month_out, monthly_mean] = FUN_TS_monthly_mean_from_daily( year_in, month_in, day_in, data_in, min_limit_per_month )
% [year_out, month_out, monthly_mean] = FUN_TS_monthly_mean_from_daily( year_in, month_in, day_in, data_in, min_limit_per_month )
% Calculate monthly mean from daily data

% V1.11 By Lequan Chi, 2019-09-07: [x] fix a bug. It may end up with wrong results when time is not in ascending order. 
%                                                    timelist is sorted, but data is not sorted at the same time
%                                  [x] fix a middle-level bug: the starting month might be wrong in some cases.
% V1.10 By Lequan Chi, 2017-04-13: support any diemsions now.
% V1.01 By Lequan Chi, the output year_out & month_out are forced to be Nx1 instead of 1xN 
% V1.00 By Lequan Chi 2015-06-22 
%
% == IMPORTANT ==
% time must be the last dimension of data_in

% debug only --------------------------------------------------------------
% year_in = [FST.daily.year];
% month_in = [FST.daily.month];
% day_in =   [FST.daily.day];
% data_in = [FST.daily.flux];
% min_limit_per_month = 16;
% -------------------------------------------------------------------------

%% reshape =======================================================
size_data = size( data_in );
if FUN_is_1D( data_in )
    n_dim = 1;
    Nx = 1;
    Nt = length( data_in );
else
    n_dim = length( size(data_in) );
    Nx = prod( size_data(1:end-1) );
    Nt = size_data(end);
end
data_in = reshape( data_in, Nx, Nt ); % data will always be [Nx, Nt] afther this.

%% calculation ===================================================
timelist = datenum( year_in, month_in, day_in );
tem_timelist = sort(timelist,'ascend');
[year2, month2, ~, ~, ~, ~] = datevec(tem_timelist);

yearlist = unique(year_in);
yearlist = sort(yearlist, 'ascend');
yearlist = yearlist(1):yearlist(end);


N = 0;
for iy = 1 : length(yearlist)
    
    % ---------------------------------------------
    if length(yearlist) == 1
        monthlist = month2(1) : month2(end);
    else
        if iy == 1
            monthlist = month2(1) : 12 ;
        elseif iy == length(yearlist)
            monthlist =  1 : month2(end);
        else
            monthlist = 1 : 12;
        end
    end
    %---------------------------------------------
    for im = 1 : length(monthlist)
        
        % interface ---------------
        year_now = yearlist(iy) ; 
        month_now = monthlist(im);
        N = N + 1;
        % end interface -----------
        
        year_out(N,1)  = year_now;
        month_out(N,1) = month_now;
            
        dataloc = year_in == year_now & month_in == month_now;
        
        
        if min_limit_per_month >= 0
            % fixed min num of days required ------------------------------
            
            if sum( dataloc ) >= min_limit_per_month
                
                tem_monthly_mean = squeeze( nanmean( data_in(:, dataloc), 2 ) );
                
                % delete values with too much nan in this month.
                tem = ~isnan(data_in(:, dataloc));
                tem_nan_loc = sum(tem,2) < min_limit_per_month ; % Num of ~nan days.
                tem_monthly_mean( tem_nan_loc ) = nan;
                
                monthly_mean(1:Nx,N) = tem_monthly_mean;
                
                clear tem_monthly_mean tem tem_nan_loc
            else
                monthly_mean(1:Nx,N) = nan;
            end
            
        elseif min_limit_per_month == -1 % ---------------------------------
            % min num of days equals  to the total number of days in this month.
            
            tem_N_days_thismonth = datenum( year_now, month_now+1, 1 ) - datenum( year_now, month_now, 1 );
            if sum( dataloc ) >= tem_N_days_thismonth
                
                tem_monthly_mean = squeeze( nanmean( data_in(:, dataloc), 2 ) );
                
                % delete values with too much nan in this month.
                tem = ~isnan(data_in(:, dataloc));
                tem_nan_loc = sum(tem,2) < tem_N_days_thismonth ; % Num of ~nan days.
                tem_monthly_mean( tem_nan_loc ) = nan;
                
                monthly_mean(:,N) = tem_monthly_mean;
                
                clear tem_monthly_mean tem tem_nan_loc tem_N_days_thismonth
                
            else
                monthly_mean(:,N) = nan;
            end
            
        else 
            % unexpected conditions ------------------------------------
            error('Unexcepted value of min_limit_per_month')
            
        end % end if 
        
        clear dataloc
    end % end im

   clear monthlist  im
end % end iy

%% prepare for output
Nt_out = N;
if Nt_out == size( monthly_mean, 2)
else
   error('E82') 
end

if n_dim > 1
    monthly_mean = reshape( monthly_mean, [size_data(1:end-1), Nt_out]  );
end

% % % function [year_out, month_out, monthly_mean] = FUN_TS_monthly_mean_from_daily( year_in, month_in, day_in, data_in, min_limit_per_month )
% % % % [year_out, month_out, monthly_mean] = FUN_TS_monthly_mean_from_daily( year_in, month_in, day_in, data_in, min_limit_per_month )
% % % % Calculate monthly mean from daily data
% % % % V1.01 By Lequan Chi, the output year_out & month_out are forced to be Nx1 instead of 1xN 
% % % % V1.00 By Lequan Chi 2015-06-22 
% % % %
% % % % == IMPORTANT ==
% % % % time must be the last dimension of data_in
% % % 
% % % % debug only --------------------------------------------------------------
% % % % year_in = [FST.daily.year];
% % % % month_in = [FST.daily.month];
% % % % day_in =   [FST.daily.day];
% % % % data_in = [FST.daily.flux];
% % % % min_limit_per_month = 16;
% % % % -------------------------------------------------------------------------
% % % 
% % % if FUN_is_1D( data_in );
% % %     n_dim = 1;
% % % else
% % %     n_dim = length( size(data_in) );
% % % end
% % % 
% % % timelist = datenum( year_in, month_in, day_in );
% % % timelist = sort(timelist,'ascend');
% % % [year2, month2, ~, ~, ~, ~] = datevec(timelist);
% % % 
% % % yearlist = unique(year_in);
% % % yearlist = sort(yearlist, 'ascend');
% % % yearlist = yearlist(1):yearlist(end);
% % % 
% % % 
% % % N = 0;
% % % for iy = 1 : length(yearlist)
% % %     
% % %     % ---------------------------------------------
% % %     if length(yearlist) == 1
% % %         monthlist = month2(1) : month2(end);
% % %     else
% % %         if iy == 1
% % %             monthlist = month_in( month2(1) ) : 12 ;
% % %         elseif iy == length(yearlist)
% % %             monthlist =  1 : month2(end);
% % %         else
% % %             monthlist = 1 : 12;
% % %         end
% % %     end
% % %     %---------------------------------------------
% % %     for im = 1 : length(monthlist)
% % %         
% % %         year_now = yearlist(iy) ; 
% % %         month_now = monthlist(im);
% % %         N = N + 1;
% % % 
% % %         year_out(N,1)  = year_now;
% % %         month_out(N,1) = month_now;
% % %             
% % %         dataloc = year_in == year_now & month_in == month_now;
% % %         
% % %         if sum( dataloc ) >= min_limit_per_month 
% % %             if n_dim == 1
% % %                 tem_monthly_mean = squeeze( nanmean( data_in(dataloc) ) );
% % %                 
% % %                 % delete values with too much nan in this month.
% % %                 tem = ~isnan( data_in(dataloc) );
% % %                 tem_nan_loc = sum(tem) < min_limit_per_month ; % Num of ~nan days.
% % %                 tem_monthly_mean( tem_nan_loc ) = nan;
% % %                 
% % %                 monthly_mean(N) = tem_monthly_mean;
% % %                 
% % %             elseif n_dim == 2
% % %                 tem_monthly_mean = squeeze( nanmean( data_in(:, dataloc), 2 ) );
% % %                 
% % %                 % delete values with too much nan in this month.
% % %                 tem = ~isnan(data_in(:, dataloc));
% % %                 tem_nan_loc = sum(tem,2) < min_limit_per_month ; % Num of ~nan days.
% % %                 tem_monthly_mean( tem_nan_loc ) = nan;
% % %                 
% % %                 monthly_mean(:,N) = tem_monthly_mean;
% % %                 
% % %             elseif n_dim == 3
% % %                 tem_monthly_mean = squeeze( nanmean( data_in(:,:, dataloc), 3 ) );
% % %                 
% % %                 % delete values with too much nan in this month.
% % %                 tem = ~isnan(data_in(:,:, dataloc));
% % %                 tem_nan_loc = sum(tem,3) < min_limit_per_month ; % Num of ~nan days.
% % %                 tem_monthly_mean( tem_nan_loc ) = nan;
% % %                 
% % %                 monthly_mean(:,:,N) = tem_monthly_mean;
% % %                 
% % %             elseif n_dim == 4
% % %                 tem_monthly_mean = squeeze( nanmean( data_in(:,:, :, dataloc), 4 ) );
% % %                 
% % %                 % delete values with too much nan in this month.
% % %                 tem = ~isnan(data_in(:,:,:, dataloc));
% % %                 tem_nan_loc = sum(tem,4) < min_limit_per_month ; % Num of ~nan days.
% % %                 tem_monthly_mean( tem_nan_loc ) = nan;
% % %                 
% % %                 monthly_mean(:,:,:,N) = tem_monthly_mean;
% % %                 
% % %             else
% % %                 error('Support 4 dims at most')
% % %             end
% % %         
% % % 
% % %             
% % %             clear tem_monthly_mean tem tem_nan_loc
% % %         else
% % % 
% % %             if n_dim == 1
% % %                 monthly_mean(N) = nan;
% % %             elseif n_dim == 2
% % %                 monthly_mean(:,N) = nan;
% % %             elseif n_dim == 3
% % %                 monthly_mean(:,:,N) = nan;
% % %             elseif n_dim == 4
% % %                 monthly_mean(:,:,:,N) = nan;
% % %             else
% % %                 error('Support 4 dims at most')
% % %                 
% % %             end
% % %             
% % %         end
% % %         
% % %         clear dataloc
% % %     end
% % %     
% % %     
% % %     
% % %    clear monthlist  im
% % % end
% % % 
% % % return