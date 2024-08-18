function str = FUN_str_num2str_in_sentific( num_in )
% convert num_in into string with this format: 1.00x10^2;
% V1.00 by Lequan Chi

% num_in = -3.1051e-6;

B = log10( abs(num_in) );
B = floor(B);

A = num_in./10.^B;

str = [ num2str(A,'%.2f') '\times10' '^{ ' num2str(B,'%i') ' }' ];


