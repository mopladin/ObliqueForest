function random_forest()

    clear;
    close all;
    
    tic;

    %% Data generation
    N = 2000;   % number of data points
    D = 2;      % Dimensionality
    [X, Y] = generateData(N, D);
    
    % Display all input data
    %visualizeData(X, Y, 'Input data');
    
    %% Execution
    execute(X, Y);
    %executeWithCrossValidation(X, Y);

    toc;
end

%%

function execute(X, Y)
   
    % Parameters
    iterations = 1;     % Number of forests trained        
    T = 1;              % Number of trees for each forest
    max_depth = 4;      % Tree depth including leaf nodes        
    bag_ratio = 3/3;    % Ratio of training samples for each tree
    val_ratio = 1/4;    % Ratio of input samples used for validation        
        
    N = length(Y);
    D = size(X, 2);        
    V = 2; % Number of forest types
    
    if(D == 2)
        visualize = true;
    end
        
    % Split randomly into train and validation set
    train_ratio = 1 - val_ratio;
    
    random_indices = randperm(N);
    train_end = (N * train_ratio);
    train_indices = random_indices(1:train_end);
    val_indices = random_indices((train_end + 1): end);
    
    X_t = X(train_indices, :);
    Y_t = Y(train_indices);
    
    X_v = X(val_indices, :);
    Y_v = Y(val_indices);
        
    % Train forests    
    errors = zeros(iterations, V);
    
    for index = 1 : iterations
        errors(index, 1) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'aligned', visualize);
        errors(index, 2) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'random_projection', visualize);
    end

    mean_accuracies = ones(1, size(errors, 2)) - sum(errors,1) / size(errors,1);
    display(mean_accuracies);

end

%%

function executeWithCrossValidation(X, Y)
 
    % Parameters
    iterations = 1;     % Number of forests trained        
    T = 1;              % Number of trees for each forest
    max_depth = 4;      % Tree depth including leaf nodes        
    bag_ratio = 3/3;    % Ratio of training samples for each tree
    val_ratio = 1/4;    % Ratio of input samples used for validation        
    
    N = size(X, 1);
    V = 1; % Number of forest types
   
    % Prepare for cross validation
    train_ratio = 1 - val_ratio;

    cv_smaller_ratio = min(val_ratio, train_ratio);
    cv_iterations = ceil(1 / cv_smaller_ratio); % Unreliable in Octave?
      
    errors = zeros(iterations, V);
    
    % Train separate forests
    for index = 1 : iterations
        
        % Prepare cross validation for current forest
        random_indices = randperm(N);
        cv_errors = zeros(cv_iterations, V);
        
        % Iterate over all cross validation sets
        for cv_i = 1 : cv_iterations

            [X_t, Y_t, X_v, Y_v] = getCrossValidationSets(X, Y, val_ratio, cv_i, random_indices);

            cv_errors(cv_i, 1) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'aligned', false);

        end
        
        % Get average errors over all cross validation sets
        errors(index, :) = sum(cv_errors,1) / size(cv_errors, 1);
    end

    mean_accuracies = ones(1, size(errors, 2)) - sum(errors,1) / size(errors,1);
    display(mean_accuracies);

end


%%

function [X, Y] = generateData(N, D)
    %% XOR-Clusters 3D
    shift = 100;

    % Generate specific clusters
    %[X, Y] = generateClusters([ 0 0 ; shift 0], N/2 * ones(2,1), [2 3 ] );

    % Generate random clusters
    cluster_count = 8;
    
    [X, Y] = generateRandomClusters(shift, cluster_count, N, D);
end