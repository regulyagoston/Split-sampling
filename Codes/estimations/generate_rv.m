%% Generate random variable

function x = generate_rv( N , MC , dStruct , rngNum )

% name = horzcat( 'data/',...
%                 'N_' , num2str( N ) , '_MC_' , num2str( MC ) , '_dist_' , dist ,...
%                 '_eps_' , num2str( eps ) , '_al_' , num2str( a_l ) , '_au_' , ...
%                 num2str( a_u ) , '_rng_' , num2str( rngNum ) ,'.mat' );

% try
%     load( name )
% catch
    %disp( ['Unable to load data! Generation of ' , name ])
    rng( rngNum );

    switch dStruct.dist
        case 'uniform'
            pd  = makedist( 'unif' , dStruct.a_l , dStruct.a_u );
        case 'normal'
            pd  = makedist( 'normal' , dStruct.mu , dStruct.sigma );
        case 'exponential'
            pd  = makedist( 'exponential' , dStruct.lambda );
        case 'weibull'
            pd  = makedist( 'wbl' , dStruct.a , dStruct.b );
        case 'student-t'
            pd  = makedist( 'tLocationScale' , dStruct.mu , dStruct.sigma , dStruct.df );
        case 'logistic'
            pd  = makedist( 'Logistic' , dStruct.mu , dStruct.sigma );
        case 'lognormal'
            pd = makedist( 'Lognormal' , dStruct.mu , dStruct.sigma );
        otherwise
            error('No such distribution implemented')
    end
    
    % Truncate
    switch dStruct.dist
        case {'exponential','weibull','lognormal_std'}
            if isinf( dStruct.a_l )
                dStruct.a_l = 0;
            end
            if dStruct.a_l < 0
                t = truncate( pd , 0 , dStruct.a_u - dStruct.a_l  );
            else
                t = truncate( pd , dStruct.a_l , dStruct.a_u );
            end
        otherwise
            t = truncate( pd , dStruct.a_l , dStruct.a_u );
    end
    
    % Generate
    x = random( t , N , MC );

    % Control for domain for distributions domain >0 by default
    if any( strcmpi( dStruct.dist , {'exponential','weibull','lognormal_std'} ) )
        x = x + dStruct.a_l;
    end
    
    % Save data
    %save( name , 'x');
    
% end

end