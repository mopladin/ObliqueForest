clear;
%clc;
close all;

%addpath(genpath('C:\Users\mopladin\Matlab_toolboxes\drtoolbox'));
addpath(genpath('D:\Taro\Matlab-Toolboxes\drtoolbox'));

N = 2000;

tic;

%% Data generation

iterations = 1;
errors = zeros(iterations, 4);

%% XOR-Clusters 3D
shift = 150;
[X, Y] = generateClusters([ 0 0 ; shift 0], N/2 * ones(2,1), [2 3 ] );

figure;
scatter(X(:,1), X(:,2), 15, Y, 'filled');

%cluster_count = 8;
%D = 3;
%[X, Y] = generateRandomClusters(shift, cluster_count, N, D);
%scatter3(X(:,1), X(:,2), X(:,3), 4, Y, 'filled');

%{
X_t = load('synthetic_data\UCI\SPECT.train');
Y_t = X_t(:,1);
Y_t = 2 * Y_t - 1;
X_t = X_t(:,2:end);

X_v = load('synthetic_data\UCI\SPECT.test');
Y_v = X_v(:,1);
Y_v = 2 * Y_v - 1;
X_v = X_v(:,2:end);

%}


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

toc;