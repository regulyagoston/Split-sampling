%% Run MC Simulations - RHS discretization
%
% Reproduces tables:
%   Main paper:
%       Table 1.
%   Online supplement:
%       Table A1-A3


clear all
clc

%% Parameters
M  = 5;
S  = 10;
xa_l = -1;
xa_u = 3;
N  = 10000;
MC = 1000;

%% Distributions
distE = struct;
distE.dist = 'normal_0_025';
distE.a_l = -1;
distE.a_u =  1;
% Distributions for epsilon
dists = {'normal_std','logistic_std','lognormal_std','uniform','exponential_05','weibull_1_15'};

%% Mid-point discretization and Shifting method
% Mid-point
objX_s1 = splitsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid' );
objX_s1.onlyDTO     = true;
objX_s1.a_l = xa_l;
objX_s1.a_u = xa_u;
% Shifting
objX_s2 = splitsampling( 'shifting' , NaN , M , NaN , NaN , 'mid');
objX_s2.onlyDTO     = false;
objX_s2.replacement = true;
objX_s2.a_l = xa_l;
objX_s2.a_u = xa_u;

%% Run
nD = numel( dists );
distX = struct;
distX.a_l = xa_l;
distX.a_u = xa_u;
b_d  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distX.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , [] , objX_s1 , distX , distE , [ false , false ] , [] , [], false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , [] , objX_s2 , distX , distE , [ false , false ] , [] , [], false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_1 = d2w';


%% APPENDIX - Further MC evidences

%%  Moderate sample size - N = 1,000
N = 1000;

b_d  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distX.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , [] , objX_s1 , distX , distE , [ false , false ] , [] , [], false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , [] , objX_s2 , distX , distE , [ false , false ] , [] , [], false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_a1 = d2w';

%%  Symmetric boundaries 
N = 10000;

distX.a_l = -2;
distX.a_u = 2;

b_d  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distX.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , [] , objX_s1 , distX , distE , [ false , false ] , [] , [], false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , [] , objX_s2 , distX , distE , [ false , false ] , [] , [], false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_a2 = d2w';

%% Smaller number of intervals M = 3

M = 3;
objY_s1.M = M;
objY_s2.M = M;
distX.a_l = -1;
distX.a_u = 3;
b_d  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distX.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , [] , objX_s1 , distX , distE , [ false , false ] , [] , [], false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , [] , objX_s2 , distX , distE , [ false , false ] , [] , [], false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_a3 = d2w';

%% Results
% Table 2
disp('Table 1.')
disp(round(table_1,4))
%
disp('Table A1.')
disp(round(table_a1,4))
%
disp('Table A2.')
disp(round(table_a2,4))
%
disp('Table A3.')
disp(round(table_a3,4))

