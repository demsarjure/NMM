% Stam et al.'s model where we can change a_sdp and a_gdp
function [C_t, E_t] = NMMStamStability(a_sdp, a_gdp)
  %% scripts
  addpath(genpath('./Helper Functions/'));

  %% initialization
  N = 32; % connectome size
  steps = 400000; % simulation steps
  dT = 0.002; % delta time
  report = 10000; % report frequency
  
  % excitation parameters
  P = 550; % output excitation
  mu = 1; % coupling constant

  % plasticity
  b_sdp = 2;
  n_d = 20; % delay window - used for SDP
  t_p = 20; % plasticity every 20 steps
  c_gdp = 0.2;

  % clamping constant
  t_0 = 0.05;

  % starting matrix
  C = zeros(N);

  % distance matrix
  Dist = DistMatrix(N);

  % input excitation
  PxdT = P * dT; % calculate this

  % coupling constants
  C_ei = 32; % strength between excitatory and inhibitory
  C_ie = 3; % strength between inhibitory and excitatory

  % EPSP
  A_e = 1.6; % amplitude of EPSP [mV]
  a_e = 55; % shape parameter of EPSP [s^-1]
  b_e = 605; % shape parameter of EPSP [s^-1]
  exp_ae = exp(-a_e * dT); % helper calculation
  exp_be = exp(-b_e * dT); % helper calculation

  % IPSP
  A_i = 32; % amplitude of IPSP [mV]
  a_i = 27.5; % shape parameter of IPSP [s^-1]
  b_i = 55; % shape parameter of IPSP [s^-1]
  exp_ai = exp(-a_i * dT); % helper calculation
  exp_bi = exp(-b_i * dT); % helper calculation

  % sigmoid function
  V_de = 7; % threshold potential for excitatotry neurons [mV]
  V_di = 7; % threshold potential for inhibitory neurons [mV]
  g = 25; % relates membrane potential to input density [s^-1]
  q = 0.34; % relates membrane potential to input density [mV^-1]

  % SDP
  h_sdp = 1; % determines value for which SDP changes sign
  H_sdp = power(h_sdp, b_sdp);

  % GDP
  eta_gdp = 1; % gdp noise

  % init neural masses
  h_e = zeros(N, 2);
  h_e2 = zeros(N, 2);
  h_i = zeros(N, 2);

  % inhibition init
  I = zeros(N, 1);

  % distant input
  di = zeros(N, 1);

  % excitation through time
  E_t = zeros(N, steps);

  % connectome through time
  C_t = zeros(steps / t_p, N, N);

  %% simulate
  for i = 1:steps
    %% calculations
    % display progress
    if (mod(i, report) == 0)
      disp(['Progress: ', num2str(i), '/', num2str(steps)])
    end

    % gaussian noise
    Pt = normrnd(PxdT, 0.1, N, 1);

    % convolutions and sigmoids
    % h_e
    i_e = Pt + di;

    h_e(:, 1) = exp_ae * h_e(:, 1) + i_e;
    h_e(:, 2) = exp_be * h_e(:, 2) + i_e;
    c1 = A_e * (h_e(:, 1) - h_e(:, 2));

    % h_i
    i_i = C_ie * I;

    h_i(:,1) = exp_ai * h_i(:, 1) + i_i;
    h_i(:,2) = exp_bi * h_i(:, 2) + i_i;
    c2 = A_i * (h_i(:, 1) - h_i(:, 2));

    % V_e
    V_e = c1 - c2;

    % E
    % if V_e <= V_d1
    cond = V_e <= V_de; % condition
    E = g * exp(q * (V_e - V_de)) * dT .* cond;
    E = E + g * (2.0 - exp(q * (V_de - V_e))) * dT .* (~cond);

    % store excitation
    E_t(:, i) = E;

    % h_e2
    i_ei = C_ei * E;
    h_e2(:, 1) = exp_ae * h_e2(:, 1) + i_ei;
    h_e2(:, 2) = exp_be * h_e2(:, 2) + i_ei;
    V_i = A_e * (h_e2(:, 1) - h_e2(:, 2));

    % I
    % if V_e <= V_d2
    % condition
    cond = V_i <= V_di;
    I = g * exp(q * (V_i - V_di)) * dT .* cond;
    I = I + g * (2.0 - exp(q * (V_di - V_i))) * dT .* (~cond);

    %% coupling
    % take previous excitations
    % delayed input equals the mu * sum of (w_ij * delayed e_tj)
    if (i > 1)
      D = E_t(:, i - 1);
      di = mu .* sum(bsxfun(@times, C, D));
      di = di';
    end

    %% plasticity
    % every t_p steps
    if (mod(i, t_p) == 0)
      %% save connectome
      % clamp small values to zero
      C_temp = C;
      C_temp(C_temp < t_0) = 0;

      % store matrix
      C_t(i / t_p, :, :) = C_temp;

      % SDP
      SDP = zeros(N, N);
      
      % correlations
      if (i > n_d)
        j = (i - n_d);
        D = E_t(:, j:i - 1)';
        cor = corr(D);
        cor(logical(eye(size(cor)))) = 0;
        r = power(cor + 1, b_sdp);
        SDP = a_sdp .* ((r ./ (r + H_sdp)) - 0.5);
      end

      % set SDP to zero where C equals 0
      SDP(C == 0) = 0;
      SDP(logical(eye(size(SDP)))) = 0;

      % GDP
      theta = ones(N) .* -1;
      theta(C < (exp(-c_gdp .* Dist))) = 1;
      GDP = a_gdp .* theta .* (rand * eta_gdp);

      % update matrix
      C = C + SDP + GDP;

      % set diagonal to 0
      C(logical(eye(size(C)))) = 0;

      % clamp matrix to 0..1 interval
      C = max(0, min(1, C));
    end
  end
end


