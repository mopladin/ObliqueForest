function plotPosteriorDistribution( directions, thresholds, leafProbabilities, X, T, limits, h)

% leafProbabilities = zeros(N_l, 2, T);

N_d = 80; % Number of discrete samples for distribution

minimum = [min(X(:,1)) min(X(:,2))];
maximum = [max(X(:,1)) max(X(:,2))];

X_d_x1 = linspace(minimum(1), maximum(1), N_d)';
X_d_x2 = linspace(minimum(2), maximum(2), N_d)';

P = zeros(N_d * N_d, 2, T);

X_d = [repmat(X_d_x1, N_d, 1) zeros(N_d * N_d, 1)];

for i = 1:N_d
    for j = 1:N_d
        index = j + (i - 1) * N_d;
        X_d(index, 2) = X_d_x2(i);
    end
end

%%

for t = 1:T
    
    P(:, 1, t) = getProbabilitiesForPoints(X_d(:,:), directions(:, :, t), thresholds(t, :), leafProbabilities(:, 1, t));
    P(:, 2, t) = getProbabilitiesForPoints(X_d(:,:), directions(:, :, t), thresholds(t, :), leafProbabilities(:, 2, t));
  
end



debug_colors = zeros(N_d * N_d, 3);
debug_colors(:, 1) = sum(P(:, 1, :), 3) / T;
debug_colors(:, 2) = 0;
debug_colors(:, 3) = sum(P(:, 2, :), 3) / T;


subplot(h);
scatter(X_d(:,1), X_d(:,2), 15, debug_colors, 'filled', 's');
title('Probabilities');
axis(limits);

%axis equal;
end

