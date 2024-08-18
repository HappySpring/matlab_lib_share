function hd = FUN_fprintf( fid, varargin )
% This will not only write into a file (if fid is not empty) but also print
% onto the screen.

is_rm_loadedd_param  = true; % r
[is_print_screen, varargin] = FUN_codetools_read_from_varargin( varargin, 'is_print_screen', true, is_rm_loadedd_param );


if ~isempty( fid )
    fprintf( fid, varargin{:} );
end

if is_print_screen
    fprintf( varargin{:} );
end
