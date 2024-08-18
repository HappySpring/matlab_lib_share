function out_str = FUN_str_cat_with_delimiter_h( Note_str, delimiter )
% Link strings in horizontal
% 
% e.g.
%     Note_str = {'a', 'b'};
%     delimiter = ', ';
%     out_str = FUN_cat_str_with_delimiter_h( Note_str, delimiter );
%     out_str = 'a,b';
  
% by L Chi

%% == 
if ~exist('delimiter','var') 
   delimiter = ', '; 
end

%%
Note_str = Note_str(:)';
tem_str = cell( size(Note_str) );
tem_str(:) = {delimiter};
Note_str = [ Note_str; tem_str ];
Note_str = Note_str(:);
out_str = strcat( Note_str{1:end-1} );