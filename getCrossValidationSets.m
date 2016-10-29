function [X_t, Y_t, X_v, Y_v] = getCrossValidationSets(X, Y, val_ratio, block_index, indices)

N = size(X, 1);

train_ratio = 1 - val_ratio;
cv_ratio = min(val_ratio, train_ratio);

block_start = (block_index - 1) * cv_ratio;
block_end = block_index * cv_ratio;
block_end = min(block_end, 1.0);

block_start = int32(block_start * N + 1);
block_end = int32(block_end * N);

if(val_ratio > train_ratio)
	train_indices = indices( block_start : block_end);
	val_indices = [indices(1:block_start - 1) indices(block_end + 1 : end)];
else
	val_indices = indices( block_start : block_end);
	train_indices = [indices(1:block_start - 1) indices(block_end + 1 : end)];		
end
	
X_t = X(train_indices, :);
X_v = X(val_indices, :);
	
Y_t = Y(train_indices);
Y_v = Y(val_indices);
