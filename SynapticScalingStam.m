% simulate using artificial matrices

%% init
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./BCT/'));

% start parameters
a_ss = 0.2:0.2:4;

% number of steps and the variable to store results
iterations = 10;
iteration = 0;
steps = size(a_ss, 2);
R = zeros(steps*iterations, 2);

for i = 1:iterations
    for j = 1:steps
        %% simulate
        iteration = iteration + 1;
        disp(['Processing: ', num2str(iteration), '/', num2str(steps*iterations)])

        %% simulate
        [C_t, E_t] = NMMStamSS(a_ss(j));

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

        R(iteration,:) = [maxD, a_ss(j)];
    end
end

% save
csvwrite('./R/Results/stability/a_ss_stability.csv', R);
