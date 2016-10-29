function P = getProbabilitiesForPoints(X, directions, thresholds, leafProbabilities)
% For each point in X, calculate the probability of belonging to the
% implicitly given label described by leafProbabilities.
%
% Based on the learned splits the input data point traverses the tree until
% reaching a leaf node. The learned class probability for the given labael
% at this leaf node is then stored for the input point.

% Dimensions:
% N - number of data points
% D - dimension of data points
% L - number of labels

% N_n - number of split nodes
% N_l - number of leaf nodes

% Input:
% X - input data points
% directions - normal vectors of chosen splits by split nodes [N_n x D]
% thresholds - positions of splits along direction vectors [N_n]
% leafProbabilities - probabilities for current label at leaf nodes [N_l]

% Output:
% P - probabilities for current label for all data points [N]

N = size(X, 1);
N_n = size(directions, 1);

P = zeros(N, 1);

% Store indices of points that reach a given split node
node_point_indices = zeros(N_n, N);

% Mark all points as reaching the root node
node_point_indices(1, :) = 1;

% Store the indices of the leaf cells reached by the data points
point_leaf_indices = zeros(N, 1);

for current_node = 1:N_n

    % Get points that reach the current node
    current_points = find(node_point_indices(current_node, :) == 1);

    if isempty(current_points)
        continue;
    end

    C = classifyPoints(X(current_points,:), directions(current_node, :)', thresholds(current_node));

    left_child = current_node * 2;
    right_child = left_child + 1;

    if left_child <= N_n

        % Children are split nodes
        node_point_indices(left_child, current_points(C == -1)) = 1;
        node_point_indices(right_child, current_points(C == 1)) = 1;

    else 

        % Children are leaf nodes
        current_level = 1 + floor(log2(current_node));

        % Get index of current node among nodes of current level
        current_relative_index = 1 + current_node - (2 ^ (current_level - 1));

        left_leaf =  2 * current_relative_index - 1;
        right_leaf =  2 * current_relative_index;

        point_leaf_indices(current_points(C == -1)) = left_leaf;
        point_leaf_indices(current_points(C == 1)) = right_leaf;
    end
end

P = leafProbabilities(point_leaf_indices);

end

