function hh = FUN_Plot_rotateXLabels( h_gca, labels, varargin )
    
Nv = length( labels );
    % reset labels into same length
        label_max_len = 1;
        for ii = 1:Nv
            label_max_len = max( [ label_max_len, length(labels{ii}) ] );
        end
        label_max_len = label_max_len + 2;
        
        for ii = 1:Nv
           %labels{ii} = [ labels{ii} repmat(' ', 1, label_max_len - length( labels{ii} ) )];
           labels{ii} = [ repmat(' ', 1, label_max_len - length( labels{ii} ) ) labels{ii} '  '];
        end
    % apply labels for all groups
        set( gca, 'xticklabel',labels);
        hh = rotateXLabels( h_gca, varargin{:} );