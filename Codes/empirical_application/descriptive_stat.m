%% Descriptive statistics -- Replicate Table A.13
clear all
clc
% Unfortunately original data is confidential
load('ato_merged.mat');

%% Logicals to get proper set
logID   = age_exp >= 25 & age_exp <= 65 & w > ( 672.7 * 52 ) & w < 225000;


%% Displaying the values for descriptive tables
disp('wage: ')
disp(num2str( [ mean( w( logID ) ) , median( w( logID ) ) , std( w( logID ) ) , min( w( logID ) ) , max( w( logID ) ) ] , '%1.0f & ' ));
disp('total income: ')
disp(num2str( [ mean( t_inc( logID ) ) , median( t_inc( logID ) ) , std( t_inc( logID ) ) , min( t_inc( logID ) ) , max( t_inc( logID ) ) ] , '%1.0f & ' ));
disp('expected age: ')
disp(num2str( [ mean( age_exp( logID ) ) , median( age_exp( logID ) ) , std( age_exp( logID ) ) , min( age_exp( logID ) ) , max( age_exp( logID ) ) ] , '%1.2f & ' ));
disp('Total income positive: ')
disp(num2str( [ 1 - mean( t_inc( logID ) <= 0 ) , mean( t_inc( logID ) <= 0 ) ] , '%1.4f & ' ));
disp('gender: ')
disp(num2str( [ 1 - mean( gender( logID ) ) , mean( gender( logID ) ) ] , '%1.4f & ' ));
disp('Spouse: ')
disp(num2str( [ 1 - mean( spouse_d( logID ) ) , mean( spouse_d( logID ) ) ] , '%1.4f & ' ));
disp('LM: ')
disp(num2str( mean( lodge_dummies( logID , : ) ) , '%1.4f & ' ));
disp('PHI: ')
disp(num2str( [ 1 - mean( phi( logID ) ) , mean( phi( logID ) ) ] , '%1.4f & ' ));
disp('Occ Codes: ')
disp(num2str( mean( occ_dummies( logID , 1 : 5 ) ) , '%1.4f & ' ));
disp(num2str( mean( occ_dummies( logID , 6 : 10 ) ) , '%1.4f & ' ));
disp('Regional Codes: ')
disp(num2str( mean( reg_dummies( logID , 2 : 6 ) ) , '%1.4f & ' ));
disp(num2str( mean( reg_dummies( logID , 10 : 14 ) ) , '%1.4f & ' ));
disp(num2str( mean( reg_dummies( logID , 19 : 23 ) ) , '%1.4f & ' ));
disp(num2str( mean( reg_dummies( logID , 24 : 28 ) ) , '%1.4f & ' ));
disp(num2str( mean( reg_dummies( logID , 29 : 33 ) ) , '%1.4f & ' ));
disp(num2str( mean( reg_dummies( logID , [ 1 , 15 : 18 ] ) ) , '%1.4f & ' ));
disp(num2str( mean( reg_dummies( logID , [ 7:9 , 34 ] ) ) , '%1.4f & ' ));

