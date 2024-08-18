function FUN_fix_ticklabel_degree_EW( axis_str )

% 
% if ispc
%     degree_symple = '?';
% elseif ismac
%     degree_symple = '?N';
% else isunix
%     degree_symple = '?N';
% end
%     

degree_symple = '\circ';
set(gca,'TickLabelInterpreter','tex');

if strcmp(axis_str,'x')
    
    ticklist = get(gca,'xtick');
    
    ticklist(ticklist>180) = ticklist(ticklist>180)  - 360;

    for ii = 1:length( ticklist )
        if ticklist(ii) > 0
            tick_str{ii} =  [num2str( abs(ticklist(ii)) ), degree_symple, 'E'];
        elseif ticklist(ii) < 0
            tick_str{ii} =  [num2str( abs(ticklist(ii)) ), degree_symple, 'W'];
        elseif ticklist(ii) == 0
            tick_str{ii} =  [num2str( abs(ticklist(ii)) ), degree_symple ];
        else 
            error
        end
    end
    
    
    set(gca,'xticklabel',tick_str)
    
elseif  strcmp(axis_str,'y');
    
    ticklist = get(gca,'ytick');
    
    ticklist(ticklist>180) = ticklist(ticklist>180)  - 360;


    for ii = 1:length( ticklist );
        if ticklist(ii) > 0
            tick_str{ii} =  [num2str( abs(ticklist(ii)) ), degree_symple, 'E'];
        elseif ticklist(ii) < 0
            tick_str{ii} =  [num2str( abs(ticklist(ii)) ), degree_symple, 'W'];
        elseif ticklist(ii) == 0
            tick_str{ii} =  [num2str( abs(ticklist(ii)) ), degree_symple ];
        else
            error
        end
    end
    
    set(gca,'yticklabel',tick_str)
    
end