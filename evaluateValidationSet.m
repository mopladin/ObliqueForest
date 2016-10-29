function evaluateValidationSet( directions, thresholds, leafProbabilities, X, Y, T, h )

% leafProbabilities = zeros(N_l, 2, T);

P = zeros(size(X,1), 2, T);

%%

for t = 1:T
    
    P(:, 1, t) = getProbabilitiesForPoints(X(:,:), directions(:, :, t), thresholds(t, :), leafProbabilities(:, 1, t));
    P(:, 2, t) = getProbabilitiesForPoints(X(:,:), directions(:, :, t), thresholds(t, :), leafProbabilities(:, 2, t));
  
end

%%
P_1 = sum(P(:, 1, :), 3) / T;
P_2 = sum(P(:, 2, :), 3) / T; 

C = P_1 > P_2;
C = 2 * C - 1;

false_classifications = length(find(C ~= Y));
display(['false classifications: ' num2str(false_classifications)]);

error_rate = false_classifications / length(Y);
display(['error percentage: ' num2str(error_rate)]);

%%
P_1_conf = sum(P_1(Y == 1));
P_2_conf = sum(P_2(Y == -1));

total_confidence = (P_1_conf + P_2_conf) / size(X,1);
display(['Total confidence: ' num2str(total_confidence)]);

subplot(h);
title([num2str(1 - error_rate) ', ' num2str(false_classifications) ', ' num2str(total_confidence)]);

%{
debug_colors = zeros(N_d * N_d, 3);
debug_colors(:, 1) = sum(P(:, 1, :), 3) / T;
debug_colors(:, 2) = 0;
debug_colors(:, 3) = sum(P(:, 2, :), 3) / T;


figure;
scatter(X_d(:,1), X_d(:,2), 15, debug_colors, 'filled', 's');
%}

end

