%% Run Simulations
% LHS paper
% Simul 1 - magnifying, DTO only
% Simul 2 - magnifying, all using DTO
% Simul 3 - magnifying, all with replacement
% Simul 4 - shifting
% Simul 5 - ordered probit
% Simul 6 - ordered logit


clear all
clc

%% Parameters
M  = 5;
S  = [ 1 , 3 , 5 , 10 , 25 , 50 , 100 ];
N  = [ 1000 , 10000 , 100000 ];
MC = 1000;
al_Y = -2;
au_Y = 4;

%% Distributions
distE = struct;
distE.dist = 'normal_std';
distE.a_l =  -1;
distE.a_u =  3;
distX = struct;
distX.dist = 'normal_0_025';
distX.a_l = -1;
distX.a_u =  1;

%% Discretization
objY_s1 = subsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid' );
objY_s1.onlyDTO     = true;
objY_s2 = subsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid');
objY_s2.onlyDTO     = false;
objY_s2.replacement = false;
objY_s4 = subsampling( 'shifting' , NaN , M , NaN , NaN , 'mid');
objY_s4.onlyDTO     = false;
objY_s4.replacement = true;

%% Run
% % Simulation 1 - only DTO
b_s1 = est_multi_NS( N , S , MC , objY_s1 , [] , distX , distE , [ false , false ] , al_Y , au_Y );
% save('output/LHS_DTO_M3.mat','b_s1');
% Simulation 2 - all without replacement
b_s2 = est_multi_NS( N , S , MC , objY_s2 , [] , distX , distE , [ false , false ] , al_Y , au_Y );
% save('output/LHS_all_woR_M3.mat','b_s2');
% Simulation 4 - Shifting method
b_s4 = est_multi_NS( N , S , MC , objY_s4 , [] , distX , distE , [ false , false ] , al_Y , au_Y );
% save('output/LHS_shifting_M3.mat','b_s4');
% Simulation 5 - Ordered probit
% b_s5 = est_multi_NS( N , 1 , MC , objY_s2 , [] , distX , distE , [ true , true ] );
% save('output/LHS_Oprob_M3.mat','b_s5');
% % Simulation 6 - Ordered logit
% b_s6 = est_multi_NS( N , 1 , MC , objY_s2 , [] , distX , distE , [ true , false ] );
% save('output/LHS_Olog_M3.mat','b_s6');
%%
a1 = squeeze( mean( b_s1 , 2 , 'omitnan' ) - 0.5 );
s1 = squeeze( std( b_s1 , 1 , 2 , 'omitnan' ) );
a2 = squeeze( mean( b_s2 , 2 , 'omitnan' ) - 0.5 );
s2 = squeeze( std( b_s2 , 1 , 2 , 'omitnan' ) );
a3 = squeeze( mean( b_s4 , 2 , 'omitnan' ) - 0.5 );
s3 = squeeze( std( b_s4 , 1 , 2 , 'omitnan' ) );
nS = numel( S );
d2w = NaN( nS * 3 * 2 , numel( N ) );
for i = 2 : nS
   d2w( ( i - 1 ) * 2 + 1 ,: ) = a1( i , : );
   d2w( ( i - 1 ) * 2 + 2 ,: ) = s1( i , : );
   d2w( ( i - 1 ) * 2 + 2 * nS + 1 ,: ) = a2( i , : );
   d2w( ( i - 1 ) * 2 + 2 * nS + 2 ,: ) = s2( i , : );
   d2w( ( i - 1 ) * 2 + 4 * nS + 1 ,: ) = a3( i , : );
   d2w( ( i - 1 ) * 2 + 4 * nS + 2 ,: ) = s3( i , : );
end