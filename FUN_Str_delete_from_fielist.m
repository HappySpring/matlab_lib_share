function filelist=FUN_Str_delete_from_fielist( filelist, delete_str )
% Delete specific records from filelist.
%
% e.g. filelist = dir('b*') ;
%      FUN_Str_delete_from_fielist( filelist, 'restart' )
% V1.00 2016-07-15

is_restart = false(  size(filelist)  );
for ii = 1:length(filelist);
    if isempty( strfind(filelist(ii).name, delete_str) )
    else
        is_restart(ii) = 1;
    end
    
end
filelist( is_restart ) = [];




