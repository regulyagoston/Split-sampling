

function [ mse ] = MSE3D( betas , beta_true )

nD = ndims( betas );
if nD == 2
    S = 1;
    N = size( betas , 1 );
elseif nD == 3
    [ S , ~ , N ] = size( betas );
else
    error('No such dimensions, use 2D or 3D doubles!')
end


mse = NaN( S , N );
if nD == 2
    for n = 1 : N
        b_n = betas( n , : );
        b_n = b_n( ~isnan( b_n ) );
        mse( n ) = mean( ( beta_true - b_n ).^2 ); 
    end
else
    for n = 1 : N
        bn = squeeze( betas( : , : , n ) );
        for s = 1 : S
            bns = bn( s , : );
            bns_n = bns( ~isnan( bns ) );
            mse( s , n ) = mean( ( beta_true - bns_n ).^2 );
        end
    end
end


end

