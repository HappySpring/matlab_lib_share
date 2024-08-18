function FUN_disp_print_by_filename(info, is_disp, filename)

if is_disp == 1
   disp( info ) 
end

if ~isempty(filename) 
    fid = fopen( filename, 'a+');
    fprintf(fid, '%s \n', info);
	fclose(fid);
end