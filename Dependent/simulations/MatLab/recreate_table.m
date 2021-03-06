%% Replicate Simulation results
% Modelling with Discretized Ordered Choice Models (2021)
%   Chan-Matyas-Reguly
%
% The codes contains results only for:
%   Midpoint regression
%   Split sampling methods: Magnifying and Shifting
%       Ordered Probit and logit is contained, but commented out due to
%       extremly slow implementation
% Stata folder contains results on:
%   Set identification, Ordered probit/logit models, and interval
%   regression

%%
% The default setting is to replicate Table 1 in the paper.
%   To replicate tables from appendix:
%       For Appendix Table 1, change N to 1000
%       For Appendix Table 2, change a_l_Y = -3 and a_u_Y = 3
%       For Appendix Table 3, change M = 3
%       For Appendix Table 4, refer to 'recreate_table_ns.m' file
%       For Appendix Table 5, one needs to refer to the second column of
%           the referred setup (it is included in each run, but we have
%           replaced them into a separate table)


%%
clear all
clc

%% Parameters
% Number of choice
M  = 5;
% Number of sub-samples if employed
S  = 10;
% Number of observations
N  = 10000;
% Number of Monte Carlo repetition
MC = 1000;
% Random number generator
rngNum = 100;

% Lower and upper bound for Y
a_l_Y = -2;
a_u_Y = 4;

%% Generate distributions
% Disturbance term: epsilon
distE_all = { 'normal_std' , 'logistic_std' , 'lognormal_std' , 'uniform' , 'exponential' , 'weibull' };
nEps = numel( distE_all );
% Covariate X
distX = struct;
distX.dist = 'normal_0_025';
distX.a_l = -1;
distX.a_u =  1;
% Parameter of interest
beta = 0.5;

%% Different methods:
% Magnifying method only DTO
objY_m_dto = splitsampling( 'magnifying' , NaN , M , a_l_Y , a_u_Y , 'mid' );
objY_m_dto.onlyDTO     = true;
% Magnifying method with usage of NDTOs -> with replacement
objY_m_all = splitsampling( 'magnifying' , NaN , M , a_l_Y , a_u_Y , 'mid');
objY_m_all.onlyDTO     = false;
objY_m_all.replacement = false;
% Shifting method
objY_shift = splitsampling( 'shifting' , NaN , M , a_l_Y , a_u_Y , 'mid');
objY_shift.onlyDTO     = false;
objY_shift.replacement = true;

% Define the matrices
avg_bias = NaN( nEps , 6 );
mc_std   = NaN( nEps , 6 );

% It takes a lot of time due to ordered choice models. If not interested in
% those, comment them out and adjust lines 86 and 87 accordingly. Also may
% consider parfor instead of for cycle.
for i = 1 : nEps
    % Specify the disturbance term
    distE = struct;
    distE.dist = distE_all{ i };
    distE.a_l =  -1;
    distE.a_u =  3;

    % Generate Y, X and epsilon
    X   = generate_rv( N , 1  , distX.dist , false , distX.a_l , distX.a_u , rngNum );
    eps = generate_rv( N , MC , distE.dist , true  , distE.a_l , distE.a_u  , rngNum );
    Y   = beta .* repmat( X , [ 1 , MC ] ) + eps;

    %% Run different methods:
    % Note: Set identification method and interval regression is run in Stata
    
    % Magnifying method - only DTO
    b_m_dto = estimate_DOC( Y , X , N , S , objY_m_dto , [] , [ false , false ] );
    % Magnifying method - all observations (w/ NDTO)
    b_m_all = estimate_DOC( Y , X , N , S , objY_m_all , [] , [ false , false ] );
    % Shifting method
    b_shift = estimate_DOC( Y , X , N , S , objY_shift , [] , [ false , false ] );
    % Ordered probit
    %b_op    = estimate_DOC( Y , X , N , 1 , objY_m_dto , [] , [ true , true ] );
    % Ordered logit
    %b_ol    = estimate_DOC( Y , X , N , 1 , objY_m_dto , [] , [ true , false ] );
    % Midpoint regression
    b_mr    = estimate_DOC( Y , X , N , 1 , objY_m_dto , [] , [ false , false ] );

    %% Save the estimates for Monte Carlo average bias and standard deviations
    avg_bias( i , 1 : 4 ) = mean( [ b_m_dto , b_m_all , b_shift , b_mr ] - beta , 'omitnan' ); %mean( [ b_m_dto , b_m_all , b_shift , b_op , b_ol , b_mr ] - beta , 'omitnan' );
    mc_std( i , 1 : 4 )   = std(  [ b_m_dto , b_m_all , b_shift , b_mr ] , 'omitnan' );        %std(  [ b_m_dto , b_m_all , b_shift , b_op , b_ol , b_mr ] , 'omitnan' );
end
%% Results
% MC Average bias of the estimated parameters
disp( avg_bias );
% MC standard deviations of the estimated parameters
disp( mc_std );

%% Example: print out the MC results for (truncated) standard normal
% disturbance term:
k = 1; % set k = 2,...6, one gets another distribution
sprintf( horzcat( ' *** Disturbance term has the distribution of: ' , distE_all{ k } , ' *** \n' ,...
                  'Method ; Average bias; Standard deviation', '\n' , ...
                  'Magnifying (S=10) - DTO only: ' , num2str( avg_bias( k , 1 ) ) , ' ; ' , num2str( mc_std( k , 1 ) ) , '\n' , ...
                  'Magnifying (S=10) - all obs:  ' , num2str( avg_bias( k , 2 ) ) , ' ; ' ,  num2str( mc_std( k , 2 ) ) , '\n' ,...
                  'Shifting method (S=10): ' , num2str( avg_bias( k , 3 ) ) , ' ; ' ,  num2str( mc_std( k , 3 ) ) , '\n' ,...
                  'Midpoint regression: ' , num2str( avg_bias( k , 4 ) ) , ' ; ' ,  num2str( mc_std( k , 4 ) ) ) )
                  %'Ordered probit: ' , num2str( avg_bias( k , 4 ) ) , ' ; ' ,  num2str( mc_std( k , 4 ) ) , '\n' , ...
                  %'Ordered logit: ' , num2str( avg_bias( k , 5 ) ) , ' ; ' ,  num2str( mc_std( k , 5 ) ) , '\n' , ...
                  
                  
