%% Recreates Table 4 in Online Appendix
% shows evidence on N and S convergence

clear all
clc

%% Parameters:
% Number of choices
M  = 5;
% Number of sub-samples
S  = [ 3 , 5 , 10 , 25 , 50 , 100 ];
% Number of observations
N  = [ 1000 , 10000 , 100000 ];
% Number of Monte-Carlo repetition
MC = 1000;
% Lower and upper bounds for Y
al_Y = -2;
au_Y = 4;
% Parameter of interest 
%   (Changing here wont affect the DGP, only how the bias is calculated!)
beta = 0.5;

%% Distributions:
% Disturbance term
distE = struct;
distE.dist = 'normal_std';
distE.a_l =  -1;
distE.a_u =  3;
% Covariate X
distX = struct;
distX.dist = 'normal_0_025';
distX.a_l = -1;
distX.a_u =  1;

%% Discretization
% Magnifying - only DTO
objY_s1 = splitsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid' );
objY_s1.onlyDTO     = true;
% Magnifying - with Replacement
objY_s2 = splitsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid');
objY_s2.onlyDTO     = false;
objY_s2.replacement = false;
% Shifting
objY_s4 = splitsampling( 'shifting' , NaN , M , NaN , NaN , 'mid');
objY_s4.onlyDTO     = false;
objY_s4.replacement = true;

%% Run different simulations
% % Simulation 1 - only DTO
b_s1 = est_multi_NS( N , S , MC , objY_s1 , [] , distX , distE , [ false , false ] , al_Y , au_Y );
% Simulation 2 - all without replacement
b_s2 = est_multi_NS( N , S , MC , objY_s2 , [] , distX , distE , [ false , false ] , al_Y , au_Y );
% Simulation 4 - Shifting method
b_s4 = est_multi_NS( N , S , MC , objY_s4 , [] , distX , distE , [ false , false ] , al_Y , au_Y );


%% Get the MC average bias and standard errors
% Magnifying only DTO - avg. bias
m_dto_b = squeeze( mean( b_s1 - beta , 2 , 'omitnan' ) );
% and standard deviation
m_dto_sd = squeeze( std( b_s1 , 1 , 2 , 'omitnan' ) );

% Magnifying all observation - avg. bias
m_all_b = squeeze( mean( b_s2 - beta , 2 , 'omitnan' ) );
% and standard deviation
m_all_sd = squeeze( std( b_s2 , 1 , 2 , 'omitnan' ) );

% Shifting method - avg. bias
shifting_b = squeeze( mean( b_s4 - beta , 2 , 'omitnan' ) );
% and standard deviation
shifting_sd = squeeze( std( b_s4 , 1 , 2 , 'omitnan' ) );

%% Ordered choice models
% They are extremly slow...
%
% Simulation 5 - Ordered probit
b_s5 = est_multi_NS( N , 1 , MC , objY_s2 , [] , distX , distE , [ true , true ] , al_Y , au_Y );
% % Simulation 6 - Ordered logit
b_s6 = est_multi_NS( N , 1 , MC , objY_s2 , [] , distX , distE , [ true , false ] , al_Y , au_Y );

% Ordered probit model - avg. bias
probit_b = squeeze( mean( b_s5 - beta , 2 , 'omitnan' ) )';
% and standard deviation
probit_sd = squeeze( std( b_s5 , 1 , 2 , 'omitnan' ) )';

% Ordered logit model - avg. bias
logit_b = squeeze( mean( b_s6 - beta , 2 , 'omitnan' ) )';
% and standard deviation
logit_sd = squeeze( std( b_s6 , 1 , 2 , 'omitnan' ) )';


