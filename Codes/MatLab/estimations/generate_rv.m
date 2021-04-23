%% Generate random variable

function x = generate_rv( N , MC , dist , eps , a_l , a_u , rngNum )

name = horzcat( 'data/',...
                'N_' , num2str( N ) , '_MC_' , num2str( MC ) , '_dist_' , dist ,...
                '_eps_' , num2str( eps ) , '_al_' , num2str( a_l ) , '_au_' , ...
                num2str( a_u ) , '_rng_' , num2str( rngNum ) ,'.mat' );

try
    load( name )
catch
    %disp( ['Unable to load data! Generation of ' , name ])
    if nargin < 7
        rngNum = 100;
    end

    % Generate continuous random variable
    if eps
        rng( rngNum + 1 );
    else
        rng( rngNum );
    end

    switch dist
        case 'uniform'
            pd  = makedist( 'unif' , a_l , a_u );
        case 'normal_std'
            pd  = makedist( 'normal' , 0 , 1 );
        case 'normal_1_2'
            pd  = makedist( 'normal' , 1 , 2 );
        case 'normal_0_025'
            pd  = makedist( 'normal' , 0 , 0.5 );
        case {'exponential','exponential_05'}
            pd  = makedist( 'exponential' , 0.5 );
        case {'weibull','weibull_1_15'}
            pd  = makedist( 'wbl' , 1 , 1.5 );
        case 'student-t'
            pd  = makedist( 'tLocationScale' , 0 , 1 , 1 );
        case { 'Logistic' , 'logistic_std' }
            pd  = makedist( 'Logistic' );
        case 'logistic_1_2'
            pd  = makedist( 'Logistic' , 1 , 2 );
        case 'lognormal_std'
            pd = makedist( 'Lognormal' , 0 , 1 );
        otherwise
            error('No such distribution implemented')
    end
    
    % Truncate
    switch dist
        case {'exponential','exponential_05','weibull','weibull_1_15','lognormal_std'}
            if a_l < 0
                t = truncate( pd , 0 , a_u - a_l  );
            else
                t = truncate( pd , a_l , a_u );
            end
        otherwise
            t = truncate( pd , a_l , a_u );
    end
    
    % Generate
    x = random( t , N , MC );

    % Control for domain for distributions domain >0 by default
    if any( strcmpi( dist , {'exponential','exponential_05','weibull','weibull_1_15','lognormal_std'} ) )
        x = x + a_l;
    end
    
    % Save data
    %save( name , 'x');
    
end

end