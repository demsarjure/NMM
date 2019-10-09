% simulate using artificial matrices

%% init
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./BCT/'));

% load settings
settings = SettingsReal();
 
% do not track matrix through time
settings.trackMatrix = false;

% distance matrix
%Dist = DistMatrix(settings.N);
% real dist matrix
load('./Data/Dist90.mat');

%% simulate
[C_t, E_t, L_s] = NMM(settings, Dist, true);
HeatMap(C_t);

%% metrics
M = Metrics(C_t);

%% save matrix
csvwrite('./R/Results/real/C.csv', C_t);
