% helper function for creating artificial injuries
% C_l: injured connectome
% L_s: injury severity matrix
function [C_l, L_s] = InjuryInit(C, focal)
  N = size(C, 1); % number of neural masses
  
  % severity of edge injuries is drawn from a normal distribution
  % N(mu_s, sigma_s^2)
  mu_s = 0.75;
  sigma_s = 0.25;

  % injury probability for focal injuries
  p_e = 0.75;
  
  % amount of injured nodes for focal injuries
  n_n = N / 4;
  
  % injured nodes and their indexes
  if (focal)
    ix = randi(N - n_n);
    L_n = ix:(ix + n_n - 1);
  else  
    % reduce probability
    p_e = p_e * (n_n / N);
    
    % target all nodes
    n_n = N;
    L_n = 1:N;
  end
 
  % artificial injuries matrix
  L = ones(N);

  % injury severity matrix
  L_s = zeros(N);

  % iterate over injured nodes
  for i = 1:n_n
    % index
    ix = L_n(i);
    % iterate over all edges
    for j = 1:N
      % is edge already injured?
      if (L(ix,j) == 1 && C(ix,j) > 0 && rand < p_e)       
        % get normrnd injury severity, max severity = 1
        severity = min(1, normrnd(mu_s, sigma_s));
        
        % injury severity matrix
        L_s(ix, j) = severity;
        L_s(j,ix) = L_s(ix,j);
        
        % injury matrix used in NMM simulations
        L(ix,j) = max(0, C(ix,j) - severity);
        L(j,ix) = L(ix,j);
      end
    end
  end
  
  % injure
  C(L ~= 1) = L(L ~= 1);
  C_l = C;
end
