% Bifurcation Diagram simulations

%% init
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./BCT/'));

% load real or model settings
settings = Settings();
settings.steps = 20000;

% disable SDP, GDP
% !!! also set C = ones(N) in NMM
settings.a_sdp = 0;
settings.a_gdp = 0;

% mu
mu_m = 0; % min mu
mu_M = 7; % max mum
mu_s = 0.2; % mu step

% number of steps and iterations
muSteps = ceil((mu_M - mu_m) / mu_s) + 1;

% variables to store results
E = zeros(muSteps, settings.steps);
parameters = zeros(1, muSteps);

% index of iterations
ix = 1;

%% simulate
for mu = mu_m:mu_s:mu_M
  % progress
  disp(['Step: ', num2str(ix), '/', num2str(muSteps)])

  % settings
  settings.mu = mu;

  % NMM simulation
  [C_t, E_t, ~] = NMM(settings, false);

  % store results
  E(ix, :) = E_t(1, 1 : size(E_t, 2));
  parameters(1, ix) = mu;

  % increase index
  ix = ix + 1;
end

%% save data
csvwrite('./R/Results/bifurcation/E_model.csv', E);
csvwrite('./R/Results/bifurcation/bifurcation_parameters.csv', parameters);
