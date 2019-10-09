% simulate using artificial matrices

%% init
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./BCT/'));

%% simulate
[C_t, E_t, L_s] = NMMStam();
C = squeeze(C_t(end,:,:));
%HeatMap(C);

%% stability plot
%con = C_t(1 : size(C_t, 1), 1, 10);
%csvwrite('./R/Results/stability/stam.csv', con);

%% power spectrum
% most injured node
L_n = sum(L_s);
[~, ix] = max(L_n);
 
steps = 400000;
duration = 50000;
pre = (steps / 2 - duration + 1 : steps / 2);
post = (steps / 2 + 1 : steps / 2 + duration);

Fs = 600;
[preF, preP] = PowerSpectrum(E_t(ix, pre), Fs);
[postF, postP] = PowerSpectrum(E_t(ix, post), Fs);
PS_most_pre = [preF; preP'];
PS_most_post = [postF; postP'];

csvwrite('./R/Results/injury/PS_stam_pre.csv', PS_most_pre);
csvwrite('./R/Results/injury/PS_stam_post.csv', PS_most_post);