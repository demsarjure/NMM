% BCT path
addpath(genpath('../BCT/'));

% path to helper scripts
addpath(genpath('../Helper Functions/'));

% load matrix
load('C90.mat');
M = Metrics(C);

