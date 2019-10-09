% helper function for calculating metrics
function m_t = MetricsThroughTime(C_t)
  sampleRate = 50;
  N = size(C_t, 1);
  
  m_t = zeros(N / sampleRate, 6); 
  
  ix = 1;
  
  for i = 1:sampleRate:N
    C = squeeze(C_t(i, :, :));
    m_t(ix, :) = [i, Metrics(C)]; 
    ix = ix + 1;
  end
end