%% Estimate LHS with OLS

function [ b , nObs , nUq ] = estLHS( objY , X_n , Yd_n , DTO_n )

% Use only DTO for estimation
if objY.onlyDTO
    Y_ws_all = Yd_n( DTO_n );
    X_n      = X_n(  DTO_n );
else
    % Use double means
    [ Y_ws_all , X_n ] = create_double_means( Yd_n , X_n , objY.L );
end
% Remove NaNs
ln   = ~isnan( Y_ws_all );
Yws   = Y_ws_all( ln );
nObs = sum( ln );
nUq  = numel( unique( Yws ) );
if nObs > 3
    Xws   = X_n( ln );
    % Simple regression
    b0 = lscov( [ ones( nObs , 1 ) , Xws ] , Yws );
    b = b0( 2 );
else
    b = NaN;
end

end