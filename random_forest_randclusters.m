clear;
%clc;
close all;

%addpath(genpath('C:\Users\mopladin\Matlab_toolboxes\drtoolbox'));
addpath(genpath('D:\Taro\Matlab-Toolboxes\drtoolbox'));

N = 2000;


tic;

%% Data generation
iterations = 20;

errors = ones(iterations, 4);

for i = 1:iterations

	%% XOR-Clusters 3D
	%shift = 150;
    shift = 100; %for 8D
	%{
	[X, Y] = generateClusters([ 0 0 0 ; 
								0 0 shift;
								0 shift 0;
								shift 0 0;                            
								0 shift shift; 
								shift 0 shift;
								shift shift 0;
								shift shift shift], 
								N/8 * ones(8,1), [1 1 -1 -1 -1 -1 1 1] );
	%}
	
	cluster_count = 50;
	D = 7;
	[X, Y] = generateRandomClusters(shift, cluster_count, N, D);
	%scatter3(X(:,1), X(:,2), X(:,3), 4, Y, 'filled');

	% Perform cross validation
	val_ratio = 1/4;
	train_ratio = 1 - val_ratio;

	cv_smaller_ratio = min(val_ratio, train_ratio);
	%cv_iterations = ceil(1 / cv_smaller_ratio);
	cv_iterations = 4;
	
	cv_errors = zeros(cv_iterations, 4);
	random_indices = randperm(N);

    display(['Iteration ' num2str(i) '(' num2str((i - 1) / iterations *100) '%)']);
    
	for cv_i = 1 : cv_iterations
		
		[X_t, Y_t, X_v, Y_v] = getCrossValidationSets(X, Y, val_ratio, cv_i, random_indices);
		
		% Apply dimension reduction to validation data
		%[X_v_t, mapping] = compute_mapping(X_v, 'LPP', 2);
		%%
		X_v_t = X_v;
		mapping = [];

		% Number of trees
		T = 20;

		% Tree depth including leaf nodes
		max_depth = 4;

		% Ratio of training samples for each tree
		bag_ratio = 2/3;

		%figureMetrics = [128 128 1024 512];
		%pointSize = 10;

		%{
		hFig = figure('name', ['Trees: ' num2str(T) ', depth: ' num2str(max_depth) ', bag_ratio: ' num2str(bag_ratio)]);
		scatter(X_v_t(:, 1), X_v_t(:, 2), 4, Y_v, 'filled');

		ratio = length(find(Y_v == 1))/length(Y_v);
		ratio = max(ratio, 1 - ratio);
		title(['Ground Truth, ratio ' num2str(ratio)]);
		%}

		%cv_errors(cv_i, 1) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'aligned');
		%cv_errors(cv_i, 2) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'pca');
		cv_errors(cv_i, 3) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'cca');
		%cv_errors(cv_i, 4) = runForestAndVisualizeResult( X_t, Y_t, X_v, Y_v, T, bag_ratio, max_depth, 'random_projection');
	end
	
	errors(i, :) = sum(cv_errors,1) / size(cv_errors, 1);
end	

save(['errors.txt'], 'errors', '-ascii'); 

display(ones(1, size(errors, 2)) - sum(errors,1) / size(errors,1));

toc;