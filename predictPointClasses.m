function [C, confidence] = predictPointClasses( directions, thresholds, leafProbabilities, X, T)

L = size(leafProbabilities, 2);
N = size(X, 1);
P = zeros(N, L, T);

for t = 1:T
    
    for label = 1:L
        P(:, label, t) = getProbabilitiesForPoints(X(:,:), directions(:, :, t), thresholds(t, :), leafProbabilities(:, label, t));
    end
    %P(:, 1, t) = getProbabilitiesForPoints(X(:,:), directions(:, :, t), thresholds(t, :), leafProbabilities(:, 1, t));  
end

C = ones(size(X,1), 1);

P_summed = zeros(L, N);

% Sum probabilities over all trees
for label = 1:L
    P_summed(label, :) = sum(P(:, label, :), 3) / T;
end

%%
confidence = zeros(N, 1);

% Determine maximum probability per data point
for index = 1:N
    [~, maxLabel] = max(P_summed(:, index));
    
    C(index) = maxLabel;
    confidence(index) = P_summed(maxLabel, index);
end


end

