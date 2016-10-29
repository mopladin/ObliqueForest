function [directions, thresholds, leaf_probabilities] = train_tree( X, Y, max_depth, tree_type)

N = size(X, 1);
D = size(X, 2);
L = max(Y);

N_n = (2 ^ (max_depth - 1)) - 1; 
N_l = 2 ^ (max_depth - 1);

directions = zeros(N_n, D);
thresholds = zeros(N_n, 1);
leaf_probabilities = zeros(N_l, L);

% Iterate over the tree, splitting up the training data
unprocessed_nodes = [1];

% Store indices of points that reach a given split node
node_point_indices = zeros(N_n, N);

% Mark all points as reaching the root node
node_point_indices(1, :) = 1;

% Store the indices of the leaf cells reached by the data points
point_leaf_indices = zeros(N, 1);

% If PCA tree chosen, transform input
pca_components = [1 0 ; 0 1];
if strcmp(tree_type, 'pca')
    pca_components = princomp(X);
end

% Loop over tree node in pseudo-recursion
while ~isempty(unprocessed_nodes)
    
    % Get most an unprocessed node
    current_node = unprocessed_nodes(end);
    unprocessed_nodes = unprocessed_nodes(1:end - 1);
  
    % Get points that reach the current node
    current_points = find(node_point_indices(current_node, :) == 1);

    if isempty(current_points) 
        % No split is possible since there are no points to split on.
        % Redundantly perform parent split
        parent_node = floor(current_node / 2);

        thresholds(current_node) = thresholds(parent_node);
        directions(current_node, :) = directions(parent_node, :);

        C = [];
    else

        X_node = X(current_points, :);
        Y_node = Y(current_points);    

        % Check whether all points reaching the node have the same label
        singleLabel = (length(unique(Y)) == 1);

        % If all points are at the same position, no split can be performed
        separable = false;
        for i = 2:size(X_node,1)
            if ~isequal(X_node(1,:), X_node(i, :))
                separable = true;
            end
        end
        
        % Attempt an optimization of the node if
        % -More than one label is present in the training data
        % -The data points are separable and not all identical
        % -The current node is not the first in the tree
        optimize = (~singleLabel && separable) || current_node == 1;
        
        % Attempt an optimization and note whether any information gain occurs
        noGain = false;
        if(optimize)
            [ thresholds(current_node), directions(current_node, :), C, noGain] = optimizeNode(X_node, Y_node, tree_type, pca_components);
        end
        
        % If no split is possible or necessary, perform the parent split redundantly       
        if ~optimize || noGain

            % No split is necessary. Redundantly perform parent split
            parent_node = floor(current_node / 2);

            thresholds(current_node) = thresholds(parent_node);
            directions(current_node, :) = directions(parent_node, :);

            C = classifyPoints( X_node, directions(current_node, :)', thresholds(current_node) );                       
        end
    end
    
    current_level = 1 + floor(log2(current_node));

    % Assign data points to child nodes
    if(current_level < (max_depth - 1))
        
        left_child = current_node * 2;
        right_child = left_child + 1;
        
        node_point_indices(left_child, current_points(C == -1)) = 1;
        node_point_indices(right_child, current_points(C == 1)) = 1;
        
        unprocessed_nodes = [unprocessed_nodes left_child right_child];
    else
        
        % Get index of current node among nodes of current level
        current_relative_index = 1 + current_node - (2 ^ (current_level - 1));
        
        left_leaf =  2 * current_relative_index - 1;
        right_leaf =  2 * current_relative_index;
        
        point_leaf_indices(current_points(C == -1)) = left_leaf;
        point_leaf_indices(current_points(C == 1)) = right_leaf;
    end
end

%% Calculate leaf probabilities

for current_leaf = 1:size(leaf_probabilities, 1)
    
    leaf_labels = Y(point_leaf_indices == current_leaf);
    
    if isempty(leaf_labels)
        leaf_probabilities(current_leaf, :) = 1 / L;
    else
        
        for label = 1:L
            leaf_probabilities(current_leaf, label) = length(find(leaf_labels == label)) / length(leaf_labels);
        end
    end
end


end

