%% Create tables
clear all
clc

%%
load('output/LHS_DTO_M3.mat');
load('output/LHS_all_woR_M3.mat');
%load('output/LHS_all_wR.mat');
load('output/LHS_shifting_M3.mat');
load('output/LHS_Oprob_M3.mat');
load('output/LHS_Olog_M3.mat');
%%
M  = 10;
b0 = 0.5;
Nb = [ 100 , 1000 , 5000 ,...
       10000  : 10000 : 90000 ,...
       100000 : 50000 : 300000 , 500000 ];
%Nb  = [ 100 , 1000 , 10000 , 100000 , 300000 , 500000 ];
%Nb  = [ 1000 , 10000 ,...
%       100000 : 50000 : 300000 , 500000 ];
N  = [ 1000 , 10000 , 100000 , 500000 ];
Nid = [2,3,4,6];%find( ismember( Nb , N ) );

%% Get the means
mb1 = squeeze( mean( b_s1( : , : , Nid ) , 2 , 'omitnan' ) );
mb2 = squeeze( mean( b_s2( : , : , Nid ) , 2 , 'omitnan' ) );
%mb3 = squeeze( mean( b_s3( : , : , Nid ) , 2 , 'omitnan' ) );
mb4 = squeeze( mean( b_s4( : , : , Nid ) , 2 , 'omitnan' ) );

%% Get the MC averages
[ mse_s1 ] = MSE3D( b_s1( : , : , Nid ) , b0 );
[ mse_s2 ] = MSE3D( b_s2( : , : , Nid ) , b0 );
%[ mse_s3 ] = MSE3D( b_s3 , b0 );
[ mse_s4 ] = MSE3D( b_s4( : , : , Nid ) , b0 );
% [ mse_sp ] = MSE3D( b_s5( : , : , Nid ) , b0 );
% [ mse_sl ] = MSE3D( b_l_5( : , : , Nid ) , b0 );
%%
[ mse_sp ] = MSE3D( b_p_3 , b0 );
[ mse_sl ] = MSE3D( b_l_3 , b0 );

%% MSE table mse_sp ; mse_sl ;'Ordered Probit', 'Ordered Logit',
matrix = [  mse_s1 ; mse_s2( 2 : end , : ) ; mse_s4( 2 : end , : ) ];
ss = {  };
rowLabels = {'S=1',...
             'S=3','S=5','S=10','S=25','S=50','S=100',...
             'S=3','S=5','S=10','S=25','S=50','S=100',...
             'S=3','S=5','S=10','S=25','S=50','S=100'};
columnLabels = {'N=1,000','N=10,000','N=100,000','N=300,000'};
matrix2latex(matrix, 'output/mse_M3.tex', 'rowLabels', rowLabels,...
            'columnLabels', columnLabels, 'alignment', 'c', 'format', '%-6.4f', 'size', 'scriptsize');
