% simulate using artificial matrices

%% init
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./BCT/'));

% start parameters
a_sdp = [0.01, 0.005, 0.004, 0.00375 0.0035, 0.00325, 0.003, 0.002, 0.001, 0.0005, 0.0001];
a_gdp = [0.001, 0.0005, 0.0004, 0.000375, 0.00035, 0.000325, 0.0003, 0.0002, 0.0001, 0.00005, 0.00001];

% number of steps and the variable to store results
iterations = 10;
iteration = 0;
steps = size(a_sdp, 2);
R = zeros(steps*iterations, 3);

for i = 1:iterations
    for j = 1:steps
        %% simulate
        iteration = iteration + 1;
        disp(['Processing: ', num2str(iteration), '/', num2str(steps*iterations)])

        % run
        [C_t, E_t] = NMMStamStability(a_sdp(j), a_gdp(j));

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

        R(iteration,:) = [maxD, a_sdp(j), a_gdp(j)];
    end
end

% save
csvwrite('./R/Results/stability/Stam_extensive.csv', R);
