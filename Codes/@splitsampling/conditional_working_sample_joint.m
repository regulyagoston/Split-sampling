%% Creating working sample using joint conditional


function [ Y_ws, X_ws ] = conditional_working_sample_joint( objY , Ys_n , Yd_n , Id_nY, objX , Xs_n , Xd_n , Id_nX )

% Create variable for working sample
Y_ws = NaN( size( Ys_n ) );
X_ws = NaN( size( Xs_n ) );

% Get the relevant artificial R.V.
%Yd_n = Yd_n( ~isnan( Yd_n ) );
%Xd_n = Xd_n( ~isnan( Xd_n ) );
logNaN = ~isnan( Yd_n ) & ~isnan( Xd_n );

% Brute force...
for s_x = 1 : objX.S
    for s_y = 1 : objY.S
        % Logical for sub-sample s
        log_s = ( Id_nY == s_y & Id_nX == s_x );
        % For each mid-value
        for m_x = 1 : objX.M
            for m_y = 1 : objY.M
                log_mid = Xs_n == objX.z_s( s_x , m_x ) & Ys_n == objY.z_s( s_y , m_y ) & log_s;
                % Number of observation within the class in the given sub-sample
                n_a = sum( log_mid );
                % If no observation then skip
                if n_a > 0
                    % Bounds for selecting values from the artificial rv
                    bounds_Y = [ objY.c_s( s_y , m_y ) , objY.c_s( s_y , m_y + 1 ) ];
                    bounds_X = [ objX.c_s( s_x , m_x ) , objX.c_s( s_x , m_x + 1 ) ];
                    % Values in artX_s which are within that range
                    log_Y = Yd_n >= bounds_Y( 1 ) & Yd_n <= bounds_Y( 2 );
                    log_X = Xd_n >= bounds_X( 1 ) & Xd_n <= bounds_X( 2 );
                    log_v = log_X & log_Y & logNaN;
                    if sum( log_v ) > 0
                        % Conditional sample average using the artificial rv
                        cond_avg_Y = mean( Yd_n( log_v ) );
                        cond_avg_X = mean( Xd_n( log_v ) );
                        Y_ws( log_mid ) = cond_avg_Y;
                        X_ws( log_mid ) = cond_avg_X;
                    end
                end
            end
        end
    end
end

end