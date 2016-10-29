function [ minThreshold, minConfig, minC, noGain] = optimizeNode( X, Y, tree_type, pca_components )

D = size(X, 2);

minThreshold = 0;
minConfig = [0 0];
minC = [];

% Define norm directions of class lines, row-wise
directions = [];

%% ALIGNED
if strcmp(tree_type, 'aligned')

    % Search along axis-parallel vectors for each dimension
    for i = 1:D        
        axis = [zeros(1, i - 1) 1 zeros(1, D - i)];
        directions = [ directions ; axis ; -axis];
    end
    
end

%% PCA
if strcmp(tree_type, 'pca')    
        
    % Search along principal component vectors
    directions = [pca_components(:,1)'; 
             -pca_components(:,1)';
             pca_components(:,2)'
             -pca_components(:,2)'];
    
end

%% RANDOM PROJECTION
if strcmp(tree_type, 'random_projection')
    
   % Search along random vector
    rand_direction = rand(1, D);
    rand_direction = rand_direction / norm(rand_direction);

    directions = [rand_direction ; 
                 -rand_direction];

end

%% CCA
if strcmp(tree_type, 'cca')
    
    [Wx, ~, ~] = borga_cca(X',Y');
    cca_direction = Wx(:,1);

    directions = [cca_direction' ; 
                 -cca_direction'];

end
[ minThreshold, minConfig, minC] = findBestSplit( X, Y, directions );


noGain = false;
if (size(minThreshold, 1) ~= 1) || (size(minThreshold, 2) ~= 1) || (size(minConfig, 2) == 0)
    noGain = true;
    minConfig = zeros(D, 1);
end


end

