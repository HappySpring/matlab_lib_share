function str_out = FUN_str_yearlimit( yearlimit, str_connector )

if ~exist( 'str_connector', 'var' )
    str_connector = ' - ';
end

str_out = [ num2str(yearlimit(1),'%i'), str_connector, num2str( yearlimit(end), '%i' ) ];