%% Monte-Carlo simulation for multiple values of N and M the underlying distribution
%
% Case: Known domain

function [ b_0 , N_eff ] = est_multi_NS( N , S , MC , beta , objY , objX , distX , distE , ordered , a_l_Y , a_u_Y )

rngNum = 100;
nS = numel( S );
nN = numel( N );
% Statistics
b_0 = NaN( nS , MC , nN );
N_eff = NaN( nS , MC , nN );
crit_num = 100000000;

if max( N ) * MC <= crit_num
    %% Random Variables
    if ~isempty( objX )
        X = generate_rv( max( N ) , MC , distX , rngNum );
    else
        X = generate_rv( max( N ) , 1  , distX, rngNum );
        X = repmat( X , [ 1 , MC ] );
    end
    eps = generate_rv( max( N ) , MC , distE , rngNum + 1 );
    
    %% Outcome and fine tune sub-sampling object
    Y   = beta .* X + eps;
    if ~isempty( objY )
        objY.a_l = a_l_Y;
        objY.a_u = a_u_Y;
    end
    
    %% Estimation for each sub-sample
    for s = 1 : nS
        disp( [ 'Number of sub-sample: ' , num2str( S( s ) ) ] )
        [ b_0( s , : , : ) , N_eff( s , : , : ) ] = estimate_DOC( Y , X , N , S( s ) , objY , objX , ordered );
    end    
    
else
    warning( [ 'For memory usage reasons use N*MC<=' , num2str( crit_num ) ] )
    MC_i = floor( crit_num / max( N ) );
    K = ceil( MC ./ MC_i );
    for k = 1 : K 
        disp( [' MC partition: ', num2str( k ) ] )
        if k == K
            MC_i = MC - (K-1).*MC_i;
        end
        if ~isempty( objX )
            X = generate_rv( max( N ) , MC_i , distX , rngNum + k );
        else
            X = generate_rv( max( N ) , 1    , distX , rngNum );
            X = repmat( X , [ 1 , MC_i ] );
        end
        eps = generate_rv( max( N ) , MC_i , distE , 2*rngNum + k );
        Y = beta .* X + eps;
        if ~isempty( objY )
            objY.a_l = a_l_Y;%floor( min( Y( : ) ) );
            objY.a_u = a_u_Y;%ceil( max( Y( : ) ) );
        end
        b_k = NaN( nS , MC_i , nN );
        N_k = NaN( nS , MC_i , nN );
        for s = 1 : nS
            disp( [ 'Number of sub-sample: ' , num2str( S( s ) ) ] )
            [ b_1 , N_s ] = estimate_DOC( Y , X , N , S( s ) , objY , objX , ordered );
            b_k( s , : , : ) = b_1;
            N_k( s , : , : ) = N_s;
        end
        b_0( : , 1 + ( k - 1 ) * MC_i : k * MC_i , : ) = b_k;
        N_eff( : , 1 + ( k - 1 ) * MC_i : k * MC_i , : ) = N_k;
        save([ num2str(ordered),'_',num2str(k),'.mat'],'b_k')
    end
    
end



    

end