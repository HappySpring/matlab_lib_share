function  out_str = FUN_str2formate10( x, e_format )

if ~exist('e_format','var') || isempty( e_format )
   e_format = '%.2e' ;    
elseif e_format(end) == 'e'
   % ok
else
    error('e_format must end with g');
end


out_str = num2str( x, e_format );

e_ind = strfind( out_str, 'e');

out_str = [ out_str(1:e_ind-1)  '\times10^{' out_str(e_ind+1:end) '}' ];
