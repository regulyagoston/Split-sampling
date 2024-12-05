%% Compare different discretization schemes for Australian gender wage gap
% Reproduces Table 4

%% Load data
%clear all
clc
%load('ato_merged.mat');

%% Logicals for filtering and model construct
logID  = age_exp >= 25 & age_exp <= 65 & w > ( 672.7 * 52 ) & w < 225000;
%% Variables
% outcome is wage
y  = w( logID ) ;
N0 = numel( y );
% Use all the covariates
covariates = [ ones( N0 , 1 ) , gender( logID , : ) , age_exp( logID , : ) , age_exp( logID , : ).^2 , ...
               spouse_d( logID , : ) , phi( logID , : ) , ...lodge_dummies( logID , 1 ) , ...
               occ_dummies( logID , 1 : end - 1 ) , reg_dummies( logID , 1 : end - 1 ) ];
% Add cross products for occupation dummies and expected age
covariates = [ covariates , occ_dummies( logID , 1 : end - 1 ) .* repmat( age_exp( logID , : ) , [ 1 , size( occ_dummies , 2 ) - 1 ] ) ];
% Define the place of parameter of interest
K = 2;
%% Discretization base setup
use_val = 'mid';
M = [ 3, 5, 10 ];
S   = 10;
a_l = 1;
a_u = 225000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Estimate different models %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% True parameter estimate
y_o = log( y );
[ b_true , bSE_true ] = lscov( covariates , y_o );

%% Mid-pont regressions
b_mpr = NaN(numel(M),1);
bSE_mpr = NaN(numel(M),1);
eps_privacy_mid = NaN(numel(M),1);
for i = 1:numel(M)
    % Discretize the outcome
    obj_midpoint   = splitsampling( 'simple' , 1 , M(i) , a_l , a_u , use_val );
    set_boundaries_midpoints( obj_midpoint );
    dv_mpr = disc_procedure( obj_midpoint , y );
    % Simple parameter estimates on discretized log wage
    ln_dv_mpr = log( dv_mpr );
    [ b_mpr_i , bSE_mpr_i ] = lscov( covariates , ln_dv_mpr );
    b_mpr(i) = b_mpr_i( K );
    bSE_mpr(i) = bSE_mpr_i( K );
    [ eps_i ] = epsilon_differential( obj_midpoint , dv_mpr, FALSE );
    eps_privacy_mid(i) = eps_i
end


%% Shifting
b_sft = NaN(numel(M),1);
bSE_sft = NaN(numel(M),1);
eps_privacy_shift = NaN(numel(M),1);
for i = 1:numel(M)
    obj_shifting             = splitsampling( 'shifting' , S , M(i) , a_l , a_u , use_val );
    obj_shifting.onlyDTO     = false;
    obj_shifting.replacement = true;
    % As gender variable is a dummy
    obj_shifting.L = 2;
    set_boundaries_midpoints( obj_shifting );
    % Discretize
    [ Ys_s , Yd_s ] = disc_procedure( obj_shifting , y );
    % Replacement estimator
    [ Y_ws_all , X_n ] = create_double_means( Yd_s , covariates(:,1) , obj_shifting.L );
    % Take the log
    t_oc_shift = log( Ys_s );
    [ b_sh , bSE_sh ] = lscov( covariates, t_oc_shift );
    b_sft( i ) = b_sh( K );
    bSE_sft( i ) = bSE_sh( K );
    [ eps_i ] = epsilon_differential( obj_shifting , Ys_s, FALSE );
    eps_privacy_shift(i) = eps_i
end



%% Report parameter estimates on gender
disp( horzcat( 'Directly observed: '      , num2str( b_true( K ) ) , ' (' , num2str( bSE_true( K ) ) , ')' ) );
disp( horzcat( 'Number of intervals ', num2str( M ) ) );
disp( horzcat( 'Mid-point regression: ' , num2str( b_mpr' ) ) );
disp( horzcat( '  ' , num2str( bSE_mpr' ) ) );
disp( horzcat( 'eps-privacy: ' , num2str( eps_privacy_mid' ) ) );
disp( horzcat( 'Shifting: ' , num2str( b_sft' ) ) );
disp( horzcat( '  ' , num2str( bSE_sft' ) ) );
disp( horzcat( 'eps-privacy: ' , num2str( eps_privacy_shift' ) ) );
disp( horzcat('N: ', num2str(size(y,1))))