function FUN_disp_print(info, is_disp, fid)

if is_disp == 1
   disp( info ) 
end

if ~isempty(fid) && fid >=0
    
    fprintf(fid, '%s \n', info);
    
end