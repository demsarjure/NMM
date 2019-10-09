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

% set 400000 steps, the same as in case of Stam for stability exploration
settings.steps = 400000;

% distance matrix
Dist = DistMatrix(settings.N);

% number of iterations and the variable to store results
iterations = 10;
iteration = 0;
R = zeros(iterations, 1);

for i = 1:iterations
    %% simulate
    iteration = iteration + 1;
    disp(['Processing: ', num2str(iteration), '/', num2str(iterations)])

    % run
    [C_t, E_t, L_s] = NMM(settings, Dist, true);
    
    % extract once it is stable
    s = (size(C_t, 1)/2)+1;
    C_s = C_t(s:end,:,:);

    minC = ones(32);
    minC(logical(eye(size(minC)))) = 0;
    maxC = zeros(32);
    maxC(logical(eye(size(maxC)))) = 0;
    for k = 1:size(C_s, 1)
        C = squeeze(C_s(k,:,:));

        minC(C < minC) = C(C < minC);
        maxC(C > maxC) = C(C > maxC);
    end

    % calculate
    D = maxC - minC;
    maxD = max(max(D));

    R(iteration,:) = maxD;
end

% save
csvwrite('./R/Results/stability/Model_extensive.csv', R);
