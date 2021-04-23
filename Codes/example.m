%% Simple example for split sampling method
% 1) M=5 Ordered Choices - for graph and for table - with MC = 1000

%% 1)
clear all
clc

%% Parameters
% Number of choice by each survey
M  = 5;
% Number of split samples
S  = 1;
% Number of observations
N  = 10000;
% Number of Monte-Carlo repetitions
MC = 1;

%% Creating distributions
% Distrubance term epsilon
distE = struct;
distE.dist = 'exponential';
distE.a_l =  0;
distE.a_u =  4;
% Covariate X's distribution
distX = struct;
distX.dist = 'normal_std';
distX.a_l = -1;
distX.a_u =  1;

%% Method of split sampling:
% Choose the mid value as numerical value for each class
use_val = 'mid';
% Set the lower and upper bound
a_l = distE.a_l + distX.a_l;
a_u = distE.a_u + distX.a_u;
% Creating magnifying method for split sampling
obj_magn = splitsampling( 'magnifying' , S , M , a_l , a_u , use_val );
% Use only DTOs
obj_magn.onlyDTO = true;

%% Run method
b_mc = est_multi_NS( N , S , MC , obj_magn , [] , distX , distE , [ false , false ] , a_l , a_u );

sprintf( horzcat( 'Average bias:' , num2str( 0.5 - mean( b_mc ) ) , ' \n' ,...
                'Std of the MC estimates: ' , num2str( std( b_mc ) ) ) );

