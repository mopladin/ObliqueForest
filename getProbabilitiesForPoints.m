function P = getProbabilitiesForPoints(X, directions, thresholds, leaf_probabilities)

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
    
    P = leaf_probabilities(point_leaf_indices);
    
    %{
    C = classifyPoints(X(:,:), directions(1, :)', thresholds(1));
    
    X_r = X(C == -1, :);    
    C_r = classifyPoints(X_r(:,:), directions(2, :)', thresholds(2));
    
    X_l = X(C == 1, :);    
    C_l = classifyPoints(X_l(:,:), directions(3, :)', thresholds(3));
    
    P_r = zeros(size(C_r));
    P_l = zeros(size(C_l));
    
    % rr
    P_r(C_r == -1) = leafProbabilities(1);
    
    % rl
    P_r(C_r == 1) = leafProbabilities(2);
    
    % lr
    P_l(C_l == -1) = leafProbabilities(3);
    
    % ll
    P_l(C_l == 1) = leafProbabilities(4);
    
    P(C == -1) = P_r;
    P(C == 1) = P_l;
    %}
end

