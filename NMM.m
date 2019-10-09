% our neural mass model
function [C_t, E_t, L_s] = NMM(settings, Dist, showProgress)
  %% constants
  dT = 0.002; % update step
  n_d = 20; % sliding window size
  P = 550; % input level [s^-1]
  
  %% initialization
  % basic
  N = settings.N; % connectome size
  steps = settings.steps; % number of steps
  mu = settings.mu ; % gain factor for coupling between NMM
  
  % gdp and sdp settings
  a_sdp = settings.a_sdp;
  b_sdp = settings.b_sdp;
  a_gdp = settings.a_gdp;
  c_gdp = settings.c_gdp;
  
  % injury
  injury = settings.injury; % on/off
  t_l = settings.t_l; % time of injury
  
  % track matrix through time
  trackMatrix = settings.trackMatrix;
  
  C = zeros(N); % starting matrix

  L_s = zeros(N); % empty injury severity
    
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

  % propagation delay
  t_c = 0.005; % minimum conduction time over the human brain is under 5 ms
  t_1 = t_c / (max(max(Dist)) * dT);
  D_m = ceil(Dist .* t_1);
  
  % SDP
  h_sdp = 1; % determines value for which SDP changes sign
  H_sdp = power(h_sdp, b_sdp);
  
  % GDP
  eta_gdp = 1; % gdp noise
 
  t_0 = 0.05; % clamp to zero value
  
  % init neural masses
  h_e = zeros(N, 2);
  h_e2 = zeros(N, 2);
  h_i = zeros(N, 2);
  
  % inhibition init
  I = zeros(N, 1);
  
  % distant input
  di = zeros(N, 1);
   
  % connectome through time
  if (trackMatrix)
    C_t = zeros(steps, N, N);
  else
    C_t = zeros(N, N);
  end
  
  % excitation through time
  E_t = zeros(N, steps);
  
  % synaptic scaling
  a_ss = settings.a_ss;
  SS = ones(N, 1);
 
  %% simulate
  for i = 1:steps
    %% calculations
    % display progress?
    if (showProgress && mod(i, 10000) == 0)
        disp(['Progress: ', num2str(i), '/', num2str(steps)])
    end
    
    % gaussian noise
    Pt = normrnd(PxdT, 0.1, N, 1);
    
    % convolutions and sigmoids
    % h_e
    i_e = Pt + di;
    
    % synaptic scaling
    i_e = i_e .* SS;
    
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
    % calculate delay for each node pair
    di = zeros(N, 1);
    for j = 1:N - 1
      for k = j + 1:N
        % get index offset
        ix = i - D_m(j, k);
        if (ix > 0)
          % excitation of j and k at that time
          E_j = E_t(j, ix);
          E_k = E_t(k, ix);
          di(j) = di(j) + (E_k * C(j, k)); 
          di(k) = di(k) + (E_j * C(k, j)); 
        end
      end
    end
    di = di .* mu;
    
    %% save connectome
    % clamp small values to zero
    C_temp = C;
    C_temp(C_temp < t_0) = 0;
    % store
    if (trackMatrix)
      C_t(i, :, :) = C_temp;
    else
      C_t = C_temp;
    end
    
    %% plasticity
    GDP = zeros(N, N);
    SDP = zeros(N, N);
    
    if (i >= n_d)
      % SDP
      j = (i - n_d) + 1;
      D = E_t(:, j:i)';
      cor = corr(D);
      cor(logical(eye(size(cor)))) = 0;
      r = power(cor + 1, b_sdp);
      SDP = a_sdp .* ((r ./ (r + H_sdp)) - 0.5);
    
      % set SDP to zero where C equals 0
      SDP(C == 0) = 0;
      SDP(logical(eye(size(SDP)))) = 0;

      % GDP
      theta = ones(N) .* -1;
      theta(C < (exp(-c_gdp .* Dist))) = 1;
      GDP = a_gdp .* theta .* (rand * eta_gdp);
    end
    
    % update matrix
    C = C + SDP + GDP;
    
    % set diagonal to 0
    C(logical(eye(size(C)))) = 0;
    
    % clamp matrix to 0..1 interval
    C = max(0, min(1, C));

    %% synaptic scaling
    K = sum(C)';
    SS = a_ss ./ sqrt(K + 1);
    
    %% init injury
    if (injury && i == t_l)
      % get injury profile
      [C_l, L_s] = InjuryInit(C);

      % injure
      C = C_l;
    end
  end
end