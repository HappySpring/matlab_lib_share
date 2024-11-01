function nan_group = FUN_TS_continuous_nan_detect( data, varargin )
% detect continuous nan values 
%
% INPUT:
%        data [m*1] or [1*m]: time series 
%
%            when data is double, this function returns locations of NaNs
%            when data is logical, this function returns locations of trues. 
% OUTPUT: 
%        nan_group: [1*m], m<n
%            nan_group(:).index: ind of each continuous nan group
%            nan_group(:).length is the length of each nan_group.index
%
% v1.10 by L. Chi 
%                 + support logical variable as input.
%                 + Add an option for resoring by length
% V1.01 By LC, empty will be returned if nan does not exist in data
% V1.00 By Lequan Chi 2015-06-19

is_rm_loadedd_param = true;
[is_resort_by_length, varargin] = FUN_codetools_read_from_varargin( varargin, 'is_resort_by_length', true, is_rm_loadedd_param );

if ~isempty( varargin )
    error('Unknown input parameters')
end

% For debug only ------------------------
%data = [FST.daily.flux];
% ---------------------------------------

if isa( data, 'double' )
    nanloc = isnan(data);
elseif islogical( data )
    nanloc = data;
end
nanindex = find( nanloc == 1 );

% Cannot find any nan values.
if isempty( nanindex )
   nan_group = [];
   return
end


N = 0;
ii= 1;
while 1
    
    N = N + 1;
    nan_group(N).index = nanindex(ii);
    
    if ii == length( nanindex )
       break 
    end
    
    while ( nanindex(ii+1)-nanindex(ii) == 1 )
        ii = ii + 1;
        nan_group(N).index = [ nan_group(N).index nanindex(ii)];
        
        if ii+1 > length(nanindex)
            break
        end
        
    end
    
    ii = ii + 1;
    
    if ii > length(nanindex)
        break
    end
    
end

clear ii

for ii = 1:length( nan_group )
    nan_group(ii).length = length( nan_group(ii).index );
end


if is_resort_by_length
    [~, ind_descend] = sort([nan_group(:).length], 'descend');
    nan_group = nan_group(ind_descend);
end

%% check
if length( [ nan_group(:).index ]) == length( nanindex )
else
   error('number of nan values detected is different from the number of input nan values!') 
end


%% END
return

    
    
