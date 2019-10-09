function settings = Settings()
  %% development phase
  settings.N = 32; % connectome size
  settings.steps = 200000; % duration
  settings.mu = 4; % gain factor for coupling between NMM
  settings.a_sdp = 0.00002; % SDP step size, 0 means no SDP
  settings.b_sdp = 2;
  settings.a_gdp = 0.00001; % GDP step size, 0 means no GDP
  settings.c_gdp = 0.2;
  settings.a_ss = 2; % synaptic scaling strength
  
  %% recovery phase
  settings.injury = false; % enable or disable injuries
  settings.focal = true; % focal or diffuse injury
  settings.t_l = settings.steps; % timestep at which the injury occurs
  if (settings.injury)
    settings.steps = 2 * settings.steps;
  end
  
  %% track matrix through time
  settings.trackMatrix = true;
end