%% Create double means based on intervals of Xs



function [ y_bar , x_bar ] = create_double_means( Yd , Xs , L )

N = numel( Yd );
a_l_x = min( Xs );
a_u_x = max( Xs );

D_l = linspace( a_l_x , a_u_x , L + 1 );

y_bar = NaN( N , 1 );
x_bar = NaN( N , 1 );

for l = 1 : L 
    % Logical indexing for X
    log_x = D_l( l ) <= Xs & D_l( l + 1 ) >= Xs;
    % Conditional means for x based on x in D_l
    x_bar( log_x ) = mean( Xs( log_x ) );
    % Conditional means for y\dagger based on x in D_l
    y_bar( log_x ) = mean( Yd( log_x ) , 'omitnan' );    
end

end