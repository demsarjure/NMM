function Dist = DistMatrix(N)
  Dist = zeros(N);

  for i = 1:N
    for j = i+1:N
      dist = abs(j - i);
      if (dist > N/2)
        dist = N - dist;
      end
      Dist(i,j) = dist;
      Dist(j,i) = dist;
    end
  end
  
  % clamp to 0..16
  Dist = ceil(Dist ./ (N / 2 / 16));
end
