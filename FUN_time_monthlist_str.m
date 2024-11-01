function out_str = FUN_time_monthlist_str(monthlist, varargin)
% generate strings represent the input month(s).
% V1.00 

is_rm_loadedd_param = true;
[language, varargin] = FUN_codetools_read_from_varargin( varargin, 'language', 'en', is_rm_loadedd_param );



month_style = 'mmm';

if length(varargin) == 1
    month_style = varargin{1};
end

% ========================================================================

if strcmpi( language, 'en')

    if length( monthlist ) == 1
        % output will be in three characters format, like JAN.
        out_str = datestr( datenum( 1, monthlist, 1), month_style );
    else
        % output will be the combination of the first characters of all monthls
        out_str = [];
        
        for ii = 1:length( monthlist )
           
            month_now = monthlist(ii);
            out_str = [ out_str datestr( datenum( 1, month_now, 1), 'm' ) ];
            
        end   
    end

elseif strcmpi( language, 'cn' )
    
    if length( monthlist ) == 1
        out_str = [num2str(monthlist), '月'];
    else
        error('multi-month feature is not supported for Chinese yet!')
    end




else
    error('Unknown language!')
end


% 
if length( monthlist) == 12 && isempty( setdiff( monthlist, [ 1:12] ) )
    out_str = 'Annually';
end