%% Convergene results for RHS
%
% Table S.8 form online supplement - Midpoint and Shifting

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
objY_s1 = splitsampling( 'shifting' , NaN , M , NaN , NaN , 'mid');

%% Run
% Simulation 4 - Shifting method
b_s1 = est_multi_NS( N , S , MC , objY_s1 , [] , distX , distE , [ false , false ] , al_Y , au_Y, false );

%% Create output
a1 = squeeze( mean( b_s1 , 2 , 'omitnan' ) - 0.5 );
s1 = squeeze( std( b_s1 , 1 , 2 , 'omitnan' ) );
nS = numel( S );
d2w = NaN( nS * 2 , numel( N ) );
d2w(1:2:end-1,:) = a1;
d2w(2:2:end,:) = s1;
%%
round(d2w,4)