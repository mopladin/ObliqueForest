function [error_rate] = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, tree_type )

%%
[directions, thresholds, leafProbabilities] = train_forest( X_t, Y_t, T, bag_ratio, max_depth, tree_type);
    
%%
[C, confidence] = predictPointClasses( directions, thresholds, leafProbabilities, X_v, T);


%%
false_classifications = length(find(C ~= Y_v));
error_rate = false_classifications / length(Y_v);


debug = 0;