%% Run MC Simulations - both discretization
%
% Reproduces tables:
%   Main paper:
%       Table 1. -- results for discretization on both sides
%   Online supplement:
%       Table S9-S11


clear all
clc

%% Parameters
M  = 5;
S  = 10;
xa_l = -3;
xa_u = 1;
N  = 10000;
MC = 1000;

%% Distributions
distX = struct;
distX.dist = 'normal_0_025';
distX.a_l = -1;
distX.a_u =  1;
% Distributions for epsilon
dists = {'normal_std','logistic_std','lognormal_std','uniform','exponential_05','weibull_1_15'};

ya_l = xa_l+distX.a_l;
ya_u = xa_u+distX.a_u;

%% Discretization
objX_s1 = splitsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid' );
objX_s1.onlyDTO     = true;
objX_s1.a_l = xa_l;
objX_s1.a_u = xa_u;
objY_s1 = splitsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid' );
objY_s1.onlyDTO     = true;
objY_s1.a_l = ya_l;
objY_s1.a_u = ya_u;

objX_s2 = splitsampling( 'shifting' , NaN , M , NaN , NaN , 'mid');
objX_s2.replacement = true;
objX_s2.a_l = xa_l;
objX_s2.a_u = xa_u;
objY_s2 = splitsampling( 'shifting' , NaN , M , NaN , NaN , 'mid');
objY_s2.replacement = true;
objY_s2.a_l = ya_l;
objY_s2.a_u = ya_u;

objX_s3 = splitsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid' );
objX_s3.onlyDTO     = false;
objX_s3.replacement = true;
objX_s3.a_l = xa_l;
objX_s3.a_u = xa_u;
objY_s3 = splitsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid' );
objY_s3.onlyDTO     = false;
objY_s3.replacement = true;
objY_s3.a_l = ya_l;
objY_s3.a_u = ya_u;

%% Run
nD = numel( dists );
distE = struct;
distE.a_l = xa_l;
distE.a_u = xa_u;
b_si  = cell( nD , 1 );
b_d  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distE.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , objY_s1, objX_s1 , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , objY_s2 , objX_s2 , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_3 = d2w';



%% APPENDIX - Further MC evidences

%%  Moderate sample size - N = 1,000
N = 1000;

b_d  = cell( nD , 1 );
b_m  = cell( nD , 1 );
b_m2  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distE.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , objY_s1, objX_s1 , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , objY_s2 , objX_s2 , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_a9 = d2w';

%%  Symmetric boundaries 
N = 10000;

distE.a_l = -2;
distE.a_u =  2;
ya_l = -3;
ya_u = 3;

b_d  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distE.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , objY_s1, objX_s1 , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , objY_s2 , objX_s2 , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_a10 = d2w';

%% Smaller number of intervals M = 3

M = 3;
objY_s1.M = M;
objY_s2.M = M;
objY_s3.M = M;
objX_s1.M = M;
objX_s2.M = M;
objX_s3.M = M;


distE.a_l = -1;
distE.a_u =  3;
ya_l = -2;
ya_u = 4;

b_d  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distE.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , objY_s1, objX_s1 , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , objY_s2 , objX_s2 , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_a11 = d2w';

%% Results
% Table 3
disp('Table 3.')
disp(round(table_3,4))
%
disp('Table A9.')
disp(round(table_a9,4))
%
disp('Table A10.')
disp(round(table_a10,4))
%
disp('Table A11.')
disp(round(table_a11,4))



