function [ minThreshold, minConfig, minC, noGain] = optimizeNode( X, Y, tree_type, pca_components )
% Return the optimal split configuration for the input data.
%
% Define the directions of the split normal vectors according to the tree
% type and run findBestSplit for an exhaustive search of thresholds.

% Dimensions:
% N - number of data points
% D - dimension of data points
% L - number of labels

% Input:
% X - training data [NxD]
% Y - training labels [N]
% pca_components - contains axis of highest variation on non-bagged data
% tree_type      - split strategy, available: 
%                  'aligned', 'pca', 'cca', 'random_projections'

% Output:
% minThreshold - threshold value minimizing entropy
% minConfig    - normal vector of chosen split
% minC         - classification by chosen split
% noGain       - true if no split resulted in lowered entropy

D = size(X, 2);

minThreshold = 0;
minConfig = [0 0];
minC = [];

% Define norm directions of split, each row forming a vector
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
    
    % Perform canonical correlation analysis,
    % yielding axis with highest correlation to label variance
    [Wx, ~, ~] = borga_cca(X',Y');
    cca_direction = Wx(:,1);

    directions = [cca_direction' ; 
                 -cca_direction'];

end

% Try all splits
[ minThreshold, minConfig, minC] = findBestSplit( X, Y, directions );

% Check if any gainful split was found
noGain = false;
if (size(minThreshold, 1) ~= 1) || (size(minThreshold, 2) ~= 1) || (size(minConfig, 2) == 0)
    noGain = true;
    minConfig = zeros(D, 1);
end


end

