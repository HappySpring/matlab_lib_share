function dirlist = FUN_File_find_dir( address )
% V1.10: '.' & '..' won't be included.

dirlist = dir( address );


for ii = 1:length(dirlist)
    % keep dir only. 
    % '.' and '..' will be removed
   if dirlist(ii).isdir == 1 && ~strcmp( dirlist(ii).name, '.') && ~strcmp( dirlist(ii).name, '..')
       isdir_loc(ii) = true;
   else
       isdir_loc(ii) = false;
   end
end

dirlist = dirlist( isdir_loc );
