%% Replication of Table 2
clear all
clc

%% Parameters
% Number of choice by each survey
M  = 3;
% Number of split samples
S  = 10;%[ 1 , 10 , 50 , 100 ];
% Number of observations
N  = 10000;%[ 10000 , 100000 ];
% Number of Monte-Carlo repetitions
MC = 1000;
% Beta
beta = 0.5;

%% Creating distributions
% Distrubance term epsilon
distE       = struct;
distE.dist  = 'normal';
distE.mu    = 0;
distE.sigma = 5;
distE.a_l   = -Inf;
distE.a_u   =  Inf;
% Covariate X's distribution
distX        = struct;
distX.dist   = 'exponential';
distX.lambda = 0.5;
distX.a_l    = 0;
distX.a_u    = 1;

%% Method of split sampling:
% Choose the mid value as numerical value for each class
use_val = 'mid';
% Creating magnifying method for split sampling
obj_magn = splitsampling( 'shifting' , [] , M , distX.a_l , distX.a_u , use_val );
% Use all observations
% obj_magn.onlyDTO = false;
% obj_magn.replacement = false;

%% Run method
[ b_mc , N_mc ] = est_multi_NS( N , S , MC , beta , [] , obj_magn , distX , distE , [ false , false ] , [] , [] );
%%
%sprintf( horzcat( 'Average bias:' , num2str( mean( 0.5 -  b_mc , 2 ) ) , ' \n' ,...
%                'Std of the MC estimates: ' , num2str( std( b_mc , 0 , 2 ) ) ) )
