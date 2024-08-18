function out_str = FUN_time_monthlist_str(monthlist)
% generate strings represent the input month(s).
% V1.00 

if length( monthlist ) == 1
    % output will be in three characters format, like JAN.
    out_str = datestr( datenum( 1, monthlist, 1), 'mmm' );
    
else
    % output will be the combination of the first characters of all monthls
    out_str = [];
    
    for ii = 1:length( monthlist )
       
        month_now = monthlist(ii);
        out_str = [ out_str datestr( datenum( 1, month_now, 1), 'm' ) ];
        
    end
    
    
end


% 
if length( monthlist) == 12 && isempty( setdiff( monthlist, [ 1:12] ) )
    out_str = 'Annually';
end