function time_ind = FUN_time_get_hour_ind_with_ref( time_in, time_ref, varargin )
% time_ind = FUN_time_get_hour_ind_with_ref( time_in, time_ref );
% 

% V1.00 by L. Chi (L.Chi.Ocean@outlook.com)


%% parameters

[is_exact, varargin] = FUN_codetools_read_from_varargin( varargin, 'is_exact', true, true );

[max_error_allow, varargin] = FUN_codetools_read_from_varargin( varargin, 'max_error_allow', 1/24/6, true );

if ~isempty( varargin )
    error('Unknown parameters found!');
end
 
%%
time_ind0 = ( time_in - time_ref ) * 24;

time_ind = round( time_ind0 );

if is_exact && any( abs( time_ind - time_ind0 ) > max_error_allow )
    
    error('E10: Errors exceed pre-set limit');
    
end
    