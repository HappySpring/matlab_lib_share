function FUN_MAP_patch_2D_from_xb_yb( x_b, y_b, data, varargin )
% V1.10 Support 2D data by LC
%%
data = squeeze( data );

Nx = size( data, 1);
Ny = size( data, 2);

if FUN_is_1D( x_b ) && Nx == length(x_b) -1 && Ny == length(y_b)-1
    is_1D = true;
elseif ~FUN_is_1D( x_b ) && Nx == size(x_b,1) -1 && Ny == size(x_b,2)-1 && all( size(x_b) == size(y_b) )
    is_1D = false;
else
    error('E59')
end

%%
hold on

if is_1D
    
    % % ----------------------------------------------
    % % Try to speed up the codes by arrayfun
    % % test results show no improvement
    % % Thus, this arrayfun code will not be applied
    %     x0 = x_b(1:end-1); 
    %     x1 = x_b(2:end);
    %     y0 = y_b(1:end-1);
    %     y1 = y_b(2:end);
    %     
    %     [X0, Y0]=meshgrid( x0, y0 );
    %     Y0 = Y0';
    %     X0 = X0';   
    % 
    %     [X1, Y1]=meshgrid( x1, y1 );
    %     X1 = X1';
    %     Y1 = Y1';
    %     
    %     arrayfun( @(x0,x1,y0,y1,c)patch([x0, x1, x1, x0], [y0, y0, y1, y1], c, 'FaceColor','flat', varargin{:} ), X0, X1, Y0, Y1, data);
    % ---------------------------------------------------------------------
    
    % x_b and y_b are 1-D matrix
    for jj = 1:Ny
        for ii = 1:Nx
            if ~isnan( data(ii,jj) )
                x_tem = [ x_b(ii) x_b(ii+1) x_b(ii+1) x_b(ii)  ]';
                y_tem = [ y_b(jj) y_b(jj)   y_b(jj+1) y_b(jj+1) ]';
                %patch(x_tem, y_tem, data(ii,jj), 'FaceColor','flat', 'EdgeColor','none');
                patch(x_tem, y_tem, data(ii,jj), 'FaceColor','flat', varargin{:});
            end
        end
    end
    
else
    % x_b and y_b are 2-D matrix
    for jj = 1:Ny
        for ii = 1:Nx
            if ~isnan( data(ii,jj) )
                x_tem = [ x_b(ii,jj) x_b(ii+1,jj)  x_b(ii+1,jj+1) x_b(ii,jj+1)  ]';
                y_tem = [ y_b(ii,jj) y_b(ii+1,jj)  y_b(ii+1,jj+1) y_b(ii,jj+1)  ]';
                %patch(x_tem, y_tem, data(ii,jj), 'FaceColor','flat', 'EdgeColor','none');
                patch(x_tem, y_tem, data(ii,jj), 'FaceColor','flat', varargin{:});
            end
        end
    end
    
end






