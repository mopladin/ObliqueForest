function [directions, thresholds, leafProbabilities] = train_forest( X, Y, T, bag_ratio, max_depth, tree_type)


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

for t = 1:T

    %% Get random subset of training data
    bootstrap_indices = randperm(N);
    bootstrap_indices = bootstrap_indices(1:B);
        
    X_b = X(bootstrap_indices, :);
    Y_b = Y(bootstrap_indices);
    
    %%
    [ directions(:, :, t), thresholds(t, :) leafProbabilities(:, :, t)] = train_tree(X_b, Y_b, max_depth, tree_type);

end


%%
if(T == 1)
    %visualizeClassLines(directions(:, :, t), thresholds(t, :), X, lineHandle);
end

%plotPosteriorDistribution( directions, thresholds, leafProbabilities, X, T, distrHandle);
%plotClassificationResult(directions, thresholds, leafProbabilities, X, T, distrHandle);

%% Run on validation set
%evaluateValidationSet( directions, thresholds, leafProbabilities, X_v, Y_v, T, distrHandle );

%% Save result to file
%save(['temp/' tree_type '_directions.txt'], 'directions', '-ASCII');
%save(['temp/' tree_type '_thresholds.txt'], 'thresholds', '-ASCII');
%save(['temp/' tree_type '_leafProbabilities.txt'], 'leafProbabilities', '-ASCII');
