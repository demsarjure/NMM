% path to data
addpath(genpath('./Data/'));

% load data
load('Data90.mat');

% get regions coordinates
xyz = regionXYZfs;

% init empty dist matrix
N = 90;
Dist = zeros(N);

% calculate euclidean distances between nodes
for i = 1:N
  p1 = [xyz(i,1), xyz(i,2), xyz(i,3)];
  for j = i+1:N
    p2 = [xyz(j,1), xyz(j,2), xyz(j,3)];
    d = sqrt(sum((p1 - p2) .^ 2));
    Dist(i,j) = d;
    Dist(j,i) = d;
  end
end

% clamp to 1..16 interval
% subtract min value
minDist = min(Dist(Dist>0));
Dist = Dist ./ minDist;

% cast to 0..1
Dist = Dist - 1;
maxDist = max(max(Dist));
Dist = Dist ./ maxDist;

% cast to 0..16
Dist = (Dist .* (16 - 1)) + 1;

% set diagonal to zero
Dist(logical(eye(size(Dist)))) = 0;
