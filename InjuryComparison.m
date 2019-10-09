% simulate using artificial matrices

%% init
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./BCT/'));

% load settings
settings = Settings();

% focal or diffuse injury
settings.focal = false;

% distance matrix
Dist = DistMatrix(settings.N);

%% difuse vs focal injury comparison
iterations = 10;

% healthy metrics
M = zeros(iterations, 5);
M_f = zeros(iterations, 5);
M_d = zeros(iterations, 5);

for i = 1:iterations
    % report
    disp(['Iteration: ', num2str(i), '/', num2str(iterations)])

    % simulate
    [C_t, E_t, L_s] = NMM(settings, Dist, true);
    C = squeeze(C_t(settings.steps, :, :));
    M(i,:) = Metrics(C);

    % focal
    [C_f, L_f] = InjuryInit(C, true);
    M_f(i,:) = Metrics(C_f);

    % diffuse
    [C_d, L_d] = InjuryInit(C, false);
    M_d(i,:) = Metrics(C_d);
    
    % in first iteration store matrices
    if (i == 1)
        % save
        csvwrite('./R/Results/matrices/C_h.csv', C);
        csvwrite('./R/Results/matrices/C_f.csv', C_f);
        csvwrite('./R/Results/matrices/L_f.csv', L_f);
        csvwrite('./R/Results/matrices/C_d.csv', C_d);
        csvwrite('./R/Results/matrices/L_d.csv', L_d);
    end       
end

% save
%csvwrite('./R/Results/injury/metrics_connectome.csv', M);
%csvwrite('./R/Results/injury/metrics_focal.csv', M_f);
%csvwrite('./R/Results/injury/metrics_diffuse.csv', M_d);
