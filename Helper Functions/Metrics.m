% helper function for calculating metrics
function m = Metrics(C)
  % 5 metrics
  m = zeros(1,5);

  % matrix size
  N = size(C,1);
  
  % characteristic path
  CP = distance_wei_floyd(C, 'inv');
  m(1) = sum(sum(CP)) / (N * (N - 1));

  % if CP = Inf, set all metrics to NaN
  if (isinf(m(1)))
    m = NaN(1,5);
  else
    % clustering coefficient
    m(2) = mean(clustering_coef_wu(C));

    % modularity
    [~, m(3)] = modularity_und(C);

    % assortativity
    m(4) = assortativity_wei(C, 0);
    
    % mean degree
    m(5) = mean(degrees_und(C));
  end
end