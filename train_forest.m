function [directions, thresholds, leafProbabilities] = train_forest( X, Y, T, bag_ratio, max_depth, tree_type)
% Dimensions:
% N - number of data points
% D - dimension of data points
% L - number of labels

% N_n - number of split nodes
% N_l - number of leaf nodes

% Input:
% X_t - training data [NxD]
% Y_t - training labels [N]
% T   - number of trees
%
% bag_ratio - ratio of training points used as input for each tree
% max_depth - highest allowed tree depth 
%             (in the implementation trees always have this depth, but may
%              be artificially shortened by performing redundant splits)
% tree_type - split strategy, available: 
%             'aligned', 'pca', 'cca', 'random_projections'

% Output:
% directions - normal vectors of chosen splits by split nodes [N_n x D x T]
% thresholds - positions of splits along direction vectors [T x N_n]
% leafProbabilities - learned label probabilities at leaf nodes [N_l x L x T]

N = size(X, 1);
D = size(X, 2);
L = max(Y);

% Number of split nodes and leafs
N_n = (2 ^ (max_depth - 1)) - 1; 
N_l = 2 ^ (max_depth - 1);

% Bootstrap set size
B = floor(bag_ratio * N);

directions = zeros(N_n, D, T);
thresholds = zeros(T, N_n);

% Likelihoods for a class (second dimension) at leaf node
leafProbabilities = zeros(N_l, L, T);

%% Train trees
for t = 1:T

    % Get random subset of training data
    bootstrap_indices = randperm(N);
    bootstrap_indices = bootstrap_indices(1:B);
        
    X_b = X(bootstrap_indices, :);
    Y_b = Y(bootstrap_indices);
    
    % Train tree on subset
    [ directions(:, :, t), thresholds(t, :), leafProbabilities(:, :, t)] = ...
        train_tree(X_b, Y_b, max_depth, tree_type);

end

%% Save result to file
%save(['temp/' tree_type '_directions.txt'], 'directions', '-ASCII');
%save(['temp/' tree_type '_thresholds.txt'], 'thresholds', '-ASCII');
%save(['temp/' tree_type '_leafProbabilities.txt'], 'leafProbabilities', '-ASCII');
