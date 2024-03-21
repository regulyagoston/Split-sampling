%% Run MC Simulations - LHS discretization
%
% Reproduces tables:
%   Main paper:
%       Table 2.
%   Online supplement:
%       Table A5-A7


clear all
clc

%% GENERAL SETUP
M  = 5;
S  = 10;
ya_l = -2;
ya_u = 4;
N  = 10000;
MC = 1000;

% Distributions
distX = struct;
distX.dist = 'normal_0_025';
distX.a_l = -1;
distX.a_u =  1;
% Distributions for epsilon
dists = {'normal_std','logistic_std','lognormal_std','uniform','exponential_05','weibull_1_15'};

% Discretization
objY_s1 = splitsampling( 'magnifying' , NaN , M , NaN , NaN , 'mid' );
objY_s1.onlyDTO     = true;
objY_s2 = splitsampling( 'shifting' , NaN , M , NaN , NaN , 'mid');
objY_s2.onlyDTO     = false;
objY_s2.replacement = true;

%% Run - Table 1 - Mid-point, Magnify and Shifting
nD = numel( dists );
distE = struct;
distE.a_l = -1;
distE.a_u =  3;
b_d  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distE.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , objY_s1 , [] , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , objY_s2 , [] , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_2 = d2w';


%% APPENDIX - Further MC evidences

%%  Moderate sample size - N = 1,000
N = 1000;

b_d  = cell( nD , 1 );
b_s = cell( nD , 1 );
d2w  = NaN( nD , 4 );
for d = 1 : nD
    distE.dist = dists{ d };
    % Mid-regression
    b_d{ d } = est_multi_NS( N , 1 , MC , objY_s1 , [] , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , objY_s2 , [] , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_a5 = d2w';

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
    b_d{ d } = est_multi_NS( N , 1 , MC , objY_s1 , [] , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , objY_s2 , [] , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_a6 = d2w';

%% Smaller number of intervals M = 3

M = 3;
objY_s1.M = M;
objY_s2.M = M;

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
    b_d{ d } = est_multi_NS( N , 1 , MC , objY_s1 , [] , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 1 ) = mean( b_d{ d } , 'omitnan' ) - 0.5;
    d2w( d , 2 ) = std( b_d{ d } , 'omitnan' );
    % Shifting
    b_s{ d } = est_multi_NS( N , S , MC , objY_s2 , [] , distX , distE , [ false , false ] , ya_l , ya_u, false );
    d2w( d , 3 ) = mean( b_s{ d } , 'omitnan' ) - 0.5;
    d2w( d , 4 ) = std( b_s{ d } , 'omitnan' );
end

table_a7 = d2w';

%% Results
% Table 2
disp('Table 2.')
disp(round(table_2,4))
%
disp('Table A5.')
disp(round(table_a5,4))
%
disp('Table A6.')
disp(round(table_a6,4))
%
disp('Table A7.')
disp(round(table_a7,4))


