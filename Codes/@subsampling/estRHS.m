%% Estimation with RHS only

function [ b , nObs , nUq ] = estRHS( objX , Y_n , Xs_n , Xd_n , Id_n , DTO_n )

if objX.onlyDTO
    X_ws_all = Xd_n( DTO_n );
    Y_n      = Y_n(  DTO_n );
    Id_s     = Id_n( DTO_n );
else
    % Estimate conditional means
    X_ws_all = conditional_working_sample( objX , Xs_n , Xd_n , Id_n , objX.perception );
    Id_s = Id_n;
end
% Remove NaNs
ln   = ~isnan( X_ws_all );
Xws  = X_ws_all( ln );
nObs = sum( ln );
nUq  = numel( unique( Xws ) );
if nObs > 3 && nUq > 2
    Yws   = Y_n( ln );
    if objX.perception
        %% De-mean each sub-sample
        Id_ws = Id_s( ln );
        Yws_dm = NaN( nObs , 1 );
        Xws_dm = NaN( nObs , 1 );
        for s = 1 : objX.S
            log_s = Id_ws == s;
            Yws_dm( log_s ) = Yws( log_s ) - mean( Yws( log_s ) );
            Xws_dm( log_s ) = Xws( log_s ) - mean( Xws( log_s ) );
        end
        % De-meaned regression
        b = lscov( Xws_dm , Yws_dm );
    else
        % Simple regression
        b0 = lscov( [ ones( nObs , 1 ) , Xws ] , Yws );
        b = b0( 2 );
    end
else
    b = NaN;
end

end