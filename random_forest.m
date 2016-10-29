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

    N = length(Y);
    D = size(X, 2);
        
    % Parameters
    iterations = 1;     % Number of forests trained        
    T = 1;             % Number of trees for each forest
    max_depth = 4;      % Tree depth including leaf nodes        
    bag_ratio = 3/3;    % Ratio of training samples for each tree
    val_ratio = 1/4;    % Ratio of input samples used for validation        
        
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
    errors = zeros(iterations, 1);
    
    for index = 1 : iterations
        runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'aligned', visualize);
        runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'random_projection', visualize);
    end

    %accuracies = ones(1, size(errors, 2)) - sum(errors,1) / size(errors,1);
    %display(accuracies);

end

%%

% TODO: Fix
function executeWithCrossValidation(X, Y)

    % Perform cross validation
    val_ratio = 1/4;
    train_ratio = 1 - val_ratio;

    cv_smaller_ratio = min(val_ratio, train_ratio);
    %cv_iterations = ceil(1 / cv_smaller_ratio);
    cv_iterations = 4;

    cv_errors = zeros(cv_iterations, 4);
    random_indices = randperm(N);

    [X_t, Y_t, X_v, Y_v] = getCrossValidationSets(X, Y, val_ratio, 1, random_indices);
    N = size(X_t,1);

    for index = 1 : iterations
    %for cv_i = 1 : cv_iterations

        %[X_t, Y_t, X_v, Y_v] = getCrossValidationSets(X, Y, val_ratio, cv_i, random_indices);

        % Apply dimension reduction to validation data
        %[X_v_t, mapping] = compute_mapping(X_v, 'LPP', 2);
        %%
        X_v_t = X_v;
        mapping = [];

        % Number of trees
        T = 1;

        % Tree depth including leaf nodes
        max_depth = 5;

        % Ratio of training samples for each tree
        bag_ratio = 3/3;

        %figureMetrics = [128 128 1024 512];
        %pointSize = 10;

        %{
        hFig = figure('name', ['Trees: ' num2str(T) ', depth: ' num2str(max_depth) ', bag_ratio: ' num2str(bag_ratio)]);
        scatter(X_v_t(:, 1), X_v_t(:, 2), 4, Y_v, 'filled');

        ratio = length(find(Y_v == 1))/length(Y_v);
        ratio = max(ratio, 1 - ratio);
        title(['Ground Truth, ratio ' num2str(ratio)]);
        %}

        %{
        cv_errors(cv_i, 1) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'aligned', mapping, X_v_t);
        cv_errors(cv_i, 2) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'pca', mapping, X_v_t);
        cv_errors(cv_i, 3) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'cca', mapping, X_v_t);
        cv_errors(cv_i, 4) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'random_projection', mapping, X_v_t);
        %}
    %end


    %errors(1, :) = sum(cv_errors,1) / size(cv_errors, 1);

        errors(index, 1) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'aligned');
        %errors(index, 2) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'pca');
        %errors(index, 3) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'cca');
        %errors(index, 4) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'random_projection');
    end



    save('errors.txt', 'errors', '-ascii'); 

    display(ones(1, size(errors, 2)) - sum(errors,1) / size(errors,1));



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