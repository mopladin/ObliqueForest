function [C, confidence] = predictPointClasses( directions, thresholds, leafProbabilities, X, T)
% Classify the input points X with the forest defined by the input
% directions, thresholds and leafProbabilities

% Dimensions:
% N - number of data points
% D - dimension of data points
% L - number of labels

% N_n - number of split nodes
% N_l - number of leaf nodes

% Input:
% directions - normal vectors of chosen splits by split nodes [N_n x D x T]
% thresholds - positions of splits along direction vectors [T x N_n]
% leafProbabilities - learned label probabilities at leaf nodes [N_l x L x T]
% X - input data points [N x D]
% T - number of trees

% Output:
% C - class labels assigned to the points in X by the forest [N]
% confidence - confidence of classification for each point in X [N]

L = size(leafProbabilities, 2);
N = size(X, 1);
P = zeros(N, L, T);

for t = 1:T
    
    % Get probabilities for all labels
    % TODO: There is a lot of redundancy here, could be optimized
    for label = 1:L
        P(:, label, t) = getProbabilitiesForPoints(X(:,:), directions(:, :, t), thresholds(t, :), leafProbabilities(:, label, t));
    end
    
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

