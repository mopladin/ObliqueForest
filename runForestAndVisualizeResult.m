function [error_rate] = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, tree_type, visualize )

% Available tree types:
% 'aligned'
% 'pca'
% 'cca'
% 'random_projection'

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