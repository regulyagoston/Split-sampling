%% Report different model estimates


function D = report_models_ATO( name , oc_true, covariates , Mtype , use_logs , use_OC )


N = numel( oc_true );
K = size( covariates , 2 );
S = [ 3 , 5 , 10 ];
a_l = 1;
if strcmp( name , 'Wage' )
    a_u = 225000;
elseif strcmp( name , 'tinc' )
    a_u = 300000;
else
    error('No such name!')
end

% Simple discretization process
if strcmpi( Mtype( 1 : 2 ) , 'M=' )
    M = str2double( Mtype( 3 ) );
    obj_simple   = subsampling( 'simple' , 1 , M , a_l , a_u );
    set_boundaries_midpoints( obj_simple );
    oc_doc = disc_procedure( obj_simple , oc_true );
elseif strcmpi( Mtype , 'HILDA' )
    bounds = [ a_l , 10000 , 20000 , 30000 , 40000 , 50000 , 60000 , 80000 , 100000 , 125000 , 150000 , 200000 , a_u ];
    M = numel( bounds ) - 1;
    obj_simple      = subsampling( 'simple' , 1 , M , bounds( 1 ) , bounds( end ) );
    obj_simple.c_s = bounds;
    obj_simple.c_b = bounds;
    obj_simple.z_s = ( bounds( 1 : end - 1 ) + bounds( 2 : end ) ) / 2;
    obj_simple.z_b = ( bounds( 1 : end - 1 ) + bounds( 2 : end ) ) / 2;
    oc_doc = disc_procedure( obj_simple , oc_true );
else
    error('No such discretization process!')
end

%% Subsampling methods
nS = numel( S );
oc_magnify = NaN( N , nS );
oc_DTO_ID  = NaN( N , nS );
oc_shift   = NaN( N , nS );
for s = 1 : nS
    % Magnifying case
    obj_magnify  = subsampling( 'magnifying' , S( s ) , M , a_l , a_u );
    obj_magnify.onlyDTO = true;
    set_boundaries_midpoints( obj_magnify );
    [ oc_magnify( : , s ) , ~ , ~ , oc_DTO_ID( : , s ) ] = disc_procedure( obj_magnify , oc_true );
    % Shifting case
    obj_shifting = subsampling( 'shifting'   , S( s ) , M , a_l , a_u );
    obj_shifting.onlyDTO     = false;
    obj_shifting.replacement = true;
    set_boundaries_midpoints( obj_shifting );
    oc_shift( : , s ) = disc_procedure( obj_shifting , oc_true );
end


%% Scale the outcome variables to have reasonable outcomes
if use_logs
    oc_true    = [ oc_true ./ 10^4    , log( oc_true ) ];
    oc_doc     = [ oc_doc ./ 10^4     , log( oc_doc ) ];
    oc_magnify = [ oc_magnify ./ 10^4 , log( oc_magnify ) ];
    oc_shift   = [ oc_shift ./ 10^4   , log( oc_shift ) ];
    iter = 2;
    n_row = 20;
else
    oc_true    = oc_true ./ 10^4;
    oc_doc     = oc_doc ./ 10^4;
    oc_magnify = oc_magnify ./ 10^4;
    oc_shift   = oc_shift ./ 10^4;
    iter = 1;
    n_row = 12;
end

% If ordered choice models are estimated as well standardize them
if use_OC
    oc_true    = oc_true    ./ repmat( std( oc_true )    , [ N , 1 ] );
    oc_doc     = oc_doc     ./ repmat( std( oc_doc )     , [ N , 1 ] );
    oc_magnify = oc_magnify ./ repmat( std( oc_magnify ) , [ N , 1 ] );
    oc_shift   = oc_shift   ./ repmat( std( oc_shift )   , [ N , 1 ] );
    covariates = covariates ./ repmat( std( covariates ) , [ N , 1 ] );
end

int0 = ones( N , 1 );
X0   = [ int0 , covariates ];

numModel = 3;
covIDs = [ { 1 : 2 } , { 1 : 4 } , { 1 : size( X0 , 2 ) } ];

%% Output table
n_col = 6 + nS * 4;
if use_OC
    n_col = n_col + 4;
end
D = cell( n_row , n_col );
D{ 1 , 1 } = '\begin{tabular}{';
D{ 1 , 2 } = '|l|';
D{ 1 , 3 } = repmat('c|' , [ 1 , n_col - 1 ] );
D{ 1 , 4 } = '}';
D{ 2 , 1 } = '\hline';
D( 3 , 1 : 5 ) = [ {'\multicolumn{'} , { num2str( ceil( n_col /2 ) ) } , {'}{|c|}{'} , { name } , {' } \\ \hline'} ];
D( 4 : end - 1 , 2 : 2 : end - 2 ) = repmat( {'&'} , size( D( 4 : end - 1 , 2 : 2 : end - 2 ) ) );
D( 4 , 1 : 2 : 5 ) = [ {''} , {'True'} , { Mtype } ];
for s = 1 : nS
    D{ 4 , 3 + 4 * s } = horzcat( 'Mf, $S=' , num2str( S( s ) ) , '$' );
    D{ 4 , 5 + 4 * s } = horzcat( 'Sh, $S='   , num2str( S( s ) ) , '$' );
end
if use_OC
    D{ 4 , end - 4 } = 'Probit';
    D{ 4 , end - 2 } = 'Logit';
end
D{ 5 , 1 } = '\multirow{2}{*}{Design 1}';
D{ 7 , 1 } = '\multirow{2}{*}{Design 2}';
D{ 9 , 1 } = '\multirow{2}{*}{Design 3}';
D( 4 : 2 : 10 , end ) = repmat( {'\\ \hline'} , size( D( 4 : 2 : 10 , end ) ) );
D( 5 : 2 : 9 , end )  = repmat(  {'\\ '} , size( D( 5 : 2 : 9 , end ) ) );
if use_logs
    D( 11 , 1 : 5 ) = [ {'\multicolumn{'} , { num2str( ceil( n_col /2 ) ) } , {'}{|c|}{ Log of '} , { name } , {' } \\ \hline'} ];
    D( 11 , 6 : end ) = cell( size( D( 11 , 6 : end ) ) );
    D( 12 , : ) = D( 4 , : );
    D( 13 : 2 : 17 , 1 ) = D( 5 : 2 : 9 , 1 );
    D( 12 : 2 : 18 , end ) = repmat( {'\\ \hline'} , size( D( 12 : 2 : 18 , end ) ) );
    D( 13 : 2 : 17 , end ) = repmat(  {'\\ '} , size( D( 13 : 2 : 17 , end ) ) );
end
D{ end - 1 , 1 } = 'No.';
D{ end , 1 } = '\end{tabular}';

format_beta = '%1.4f';
format_N    = '%1.0f';

%% Modelling with raw and log values
for i = 1 : iter
    %% For each model setup
    for j = 1 : numModel
        X0_j = X0( : , covIDs{ j } );
        % True OLS model
        if use_OC
            [ b0 , b0_int ] = regress( oc_true( : , i ) , X0_j );
        else
            [ b0 , b0_se ] = lscov( X0_j , oc_true( : , i ) );
        end
        % Simple OLS model w DOC outcome
        if use_OC
            [ b_doc , b_doc_int ] = regress( oc_doc( : , i ) , X0_j );
        else
            [ b_doc , b_doc_se ] = lscov( X0_j , oc_doc( : , i ) );
        end
        % Probit and Logit models with DOC outcomes
        if use_OC
            ordinal_oc_doc = ordinal( oc_doc( : , i ) );
            % Probit
            [ B_prob  , ~  , stats_probit ] = mnrfit( X0_j( : , 2 : end ) , ordinal_oc_doc , 'model','ordinal','link','probit');
            bp = recover_underlying( B_prob( M : end ) , std( X0_j( : , 2 : end ) )' , stats_probit.covb( M : end , M : end ) , 1 );
            % Confidence intervals
            if j == 1
                Ki = 1;
            elseif j == 2
                Ki = 3;
            else
                Ki = K;
            end
            bp_int = NaN( Ki , 2 );
            bp_int( : , 1 ) = recover_underlying( B_prob( M : end ) - 1.96 * stats_probit.se( M : end )  , ...
                                                  std( X0_j( : , 2 : end ) )' , stats_probit.covb( M : end , M : end ) , 1 );
            bp_int( : , 2 ) = recover_underlying( B_prob( M : end ) + 1.96 * stats_probit.se( M : end ) , ...
                                                  std( X0_j( : , 2 : end ) )' , stats_probit.covb( M : end , M : end ) , 1 );
            % Logit
            [ B_logit , ~ , stats_logit ]  = mnrfit( X0_j( : , 2 : end ) , ordinal_oc_doc , 'model','ordinal','link','logit');
            bl = recover_underlying( B_logit( M : end ) , std( X0_j( : , 2 : end ) )' , stats_logit.covb( M : end , M : end ) , pi^2/3 );
            % Confidence intervals
            bl_int = NaN( Ki , 2 );
            bl_int( : , 1 ) = recover_underlying( B_logit( M : end ) - 1.96 * stats_logit.se( M : end ) , ...
                                                  std( X0_j( : , 2 : end ) )' , stats_logit.covb( M : end , M : end ) , pi^2/3 );
            bl_int( : , 2 ) = recover_underlying( B_logit( M : end ) + 1.96 * stats_logit.se( M : end ) , ...
                                                  std( X0_j( : , 2 : end ) )' , stats_logit.covb( M : end , M : end ) , pi^2/3 );
        end
        % Sub-sampling methods
        b_mag = NaN( 1 , nS );
        b_mag_int = NaN( 2 , nS );
        b_mag_se = b_mag;
        b_shift = NaN( 1 , nS );
        b_shift_int = NaN( 2 , nS );
        b_shift_se = b_mag;
        for s = 1 : nS            
            logYs = oc_DTO_ID( : , s ) == 1;
            if i == 1
                y_s = oc_magnify( : , s );
                nSk = 0;
            else
                y_s = oc_magnify( : , nS + s );
                nSk = nS;
            end
            if use_OC
                % Magnifying observations
                [ b_mag_i , b_mag_int_i  ]  = regress( y_s( logYs ) , X0_j( logYs , : ) );
                b_mag_int( : , s ) = b_mag_int_i( 2 , : );
                % Shifting observations
                [ b_shift_i , b_shift_int_i ] = regress( oc_shift( : , s + nSk  ) , X0_j );
                b_shift_int( : , s ) = b_shift_int_i( 2 , : );
            else
                % Magnifying observations
                [ b_mag_i , b_mag_se_i ]    = lscov( X0_j( logYs , : ) , y_s( logYs ) );
                b_mag_se( s ) = b_mag_se_i( 2 );
                % Shifting observations
                [ b_shift_i , b_shift_se_i ] = lscov( X0_j , oc_shift( : , s + nSk ) );
                b_shift_se( s ) = b_shift_se_i( 2 );
            end
            b_mag( s ) = b_mag_i( 2 );
            b_shift( s ) = b_shift_i( 2 );
        end

        %% Fill up the report
        if i == 1 && j == 1
            ct = 5;
            D( end - 1 , [ 3 , 5 , 9 : 4 : end - 1 ] ) = repmat( { num2str( N , format_N ) } ,...
                                                                size( D( end - 1 , [ 3 , 5 , 9 : 4 : end - 1 ] ) ) );
            D{ end - 1 , end } = '\\ \hline';
            for s = 1 : nS
                D( end - 1 , 7 + 4 * ( s - 1 ) ) = { num2str( sum( oc_DTO_ID( : , s ) ), format_N ) };
            end
        elseif i == 2 && j == 1
            ct = 13;
        end
        % Point estimates and SE or CI
        o_v = 2;
        D( ct , [ 3 , 5 ] ) = [ { num2str( b0( o_v )    , format_beta ) } ,...
                                { num2str( b_doc( o_v ) , format_beta ) } ];
        for s = 1 : nS
            D( ct , [ 3 + 4 * s , 5 + 4 * s ] ) = [ { num2str( b_mag(   s )   , format_beta ) } , ...
                                                    { num2str( b_shift( s ) , format_beta ) } ];
        end
        if use_OC
            D( ct , [ n_col - 3 , n_col - 1 ] ) = [ { num2str( bp( o_v - 1 ) , format_beta ) }  ,...
                                                    { num2str( bl( o_v - 1 ) , format_beta ) } ];
            D( ct + 1 , [ 3 , 5 , n_col - 3 , n_col - 1 ] ) = [ ci_s( b0_int( o_v , : ) ) , ...
                                                                ci_s( b_doc_int( o_v , : ) ) , ...
                                                                ci_s( bp_int( o_v - 1 , : ) ) , ...
                                                                ci_s( bl_int( o_v - 1 , : ) ) ];
            for s = 1 : nS
                D( ct + 1 , [ 3 + 4 * s , 5 + 4 * s ] ) = [ ci_s( b_shift_int( : , s ) ) , ...
                                                            ci_s( b_mag_int( : , s ) ) ];
            end
        else
            D( ct + 1 , [ 3 , 5 ] ) = [ { num2str( b0_se( o_v )    , format_beta ) } , ...
                                        { num2str( b_doc_se( o_v ) , format_beta ) } ];
            for s = 1 : nS
                D( ct + 1 , [ 3 + 4 * s , 5 + 4 * s ] ) = [ { num2str( b_mag_se(   s ) , format_beta ) } , ...
                                                            { num2str( b_shift_se( s ) , format_beta ) } ];
            end
        end
        ct = ct + 2;
    end
end
if strcmp( Mtype , 'HILDA' )
    name = horzcat( name , 'HILDA' );
else
    name = horzcat( name , 'M_' , num2str( M ) );
end
if use_OC
    name = horzcat( name , '_OC' );
end
name = horzcat( name , '.txt' );
filePh = fopen( name , 'w' );
Dt = D';
fprintf( filePh , '%s ' , Dt{ : } );
fclose( filePh );

end

function out = ci_s( nums )

nstr_int = { '(' , num2str( nums( 1 ) , '%1.4f' ) , ',' , num2str( nums( 2 ) , '%1.4f' ) , ')' };

out = { [ nstr_int{ : } ] };
end