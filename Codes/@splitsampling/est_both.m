% Estimate LHS with OLS

function [ b , nObs , nUq ] = est_both( objY , objX, Ys_n, Yd_n, Id_nY, DTO_nY, Xs_n, Xd_n, Id_nX, DTO_nX )

if objX.S == 1 && objY.S == 1
    Y_ws_all = Ys_n;
    X_ws_all = Xs_n;
else
    if objX.onlyDTO && objY.onlyDTO
        DTO_n    = DTO_nY & DTO_nX;
        Xd_n     = Xd_n( DTO_n );
        Yd_n     = Yd_n( DTO_n ); 
        Ys_n     = Ys_n( DTO_n );
        Xs_n     = Xs_n( DTO_n ); 
        Id_nY    = Id_nY( DTO_n );
        Id_nX    = Id_nX( DTO_n );
    end
    % Estimate conditional means
    [Y_ws_all, X_ws_all] = conditional_working_sample_joint( objY , Ys_n , Yd_n , Id_nY, objX , Xs_n , Xd_n , Id_nX );
end

% Remove NaNs
ln   = ~isnan( Y_ws_all ) & ~isnan( X_ws_all );
Yws   = Y_ws_all( ln );
nObs = sum( ln );
nUq  = numel( unique( Yws ) );
if nObs >= 3 && nUq >= 3
    Xws   = X_ws_all( ln );
    % Simple regression
    b0 = lscov( [ ones( nObs , 1 ) , Xws ] , Yws );
    b = b0( 2 );
else
    b = NaN;
end

end