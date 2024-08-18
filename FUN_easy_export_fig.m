function FUN_easy_export_fig(filename,varargin)
% interface for Saving pictures by export_fig
% By Lequan Chi, 2014-03-16
%
% example
%    FUN_easy_export_fig(filename,[ optional params for export_fig ])
%

    set(gcf,'color','w')
    set(gcf,'paperpositionmode','auto')
    set(gcf,'renderer','zbuffer')
    
    
if exist('export_fig','file')
  
    export_fig( filename ,varargin{:} )

else
    disp('============================================================')
    warning('>>>>>==== export_fig is necessary for this ====<<<<<')
    warning('>>>>>====using saveas instead of export_fig====<<<<<')
    disp('============================================================')
    
    saveas(gca,filename)
    
end




