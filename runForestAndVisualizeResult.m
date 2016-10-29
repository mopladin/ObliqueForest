function [error_rate] = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, tree_type, visualize )
% Dimensions:
% N - number of data points
% D - dimension of data points

% Input:
% X_t - training data [NxD]
% Y_t - training labels [N]
% X_v - validation data [NxD]
% Y_v - validation labaels [N]
% T   - number of trees
%
% bag_ratio - ratio of training points used as input for each tree
% max_depth - highest allowed tree depth 
%             (in the implementation trees always have this depth, but may
%              be artificially shortened by performing redundant splits)
% tree_type - split strategy, available: 
%             'aligned', 'pca', 'cca', 'random_projections'
% visualize - plot training data and distribution as well as splits if T=1

% Output:
% error_rate - ratio of false classifications on validation data

%%
[directions, thresholds, leafProbabilities] = train_forest( X_t, Y_t, T, bag_ratio, max_depth, tree_type);

%%
[C, confidence] = predictPointClasses( directions, thresholds, leafProbabilities, X_v, T);


%%
false_classifications = length(find(C ~= Y_v));
error_rate = false_classifications / length(Y_v);

%%
if(visualize)
    
    figure('Name', [tree_type ', Accuracy: ' num2str(1 - error_rate)], 'Position', [64 100 920 460]);
    h = subplot(1, 2, 1);
    visualizeData(X_t, Y_t, 'Training set', h);
    
    hold on;    
    %visualizeClassLines(directions, thresholds, X_t, h);
    xlim = get(gca,'xlim');
    ylim = get(gca,'ylim');
     
    h = subplot(1, 2, 2);
    plotPosteriorDistribution( directions, thresholds, leafProbabilities, X_t, T, [xlim ylim], h);    
    
end