N = 20;

indices = 1:N;

% Perform a cross validation
val_ratio = 0.8;
train_ratio = 1 - val_ratio;

cv_ratio = min(val_ratio, train_ratio);
cv_iterations = 1 / cv_ratio;

if( abs(round(cv_iterations) - cv_iterations) > 0.01)
	cv_iterations = ceil(cv_iterations);
else
	cv_iterations = round(cv_iterations);
end

display([num2str(cv_iterations) ' iterations for cross validation']);

% Rows are blocks, columns are start and end index
cv_blocks = zeros(cv_iterations, 2);

for i = 1 : cv_iterations
	
	block_start = (i - 1) * cv_ratio;
	block_end = i * cv_ratio;
	block_end = min(block_end, N);
	
	cv_blocks(i, 1) = block_start * N + 1;
	cv_blocks(i, 2) = block_end * N;
end	

cv_blocks = uint8(cv_blocks);


for i = 1:cv_iterations

	block_start = cv_blocks(i, 1);
	block_end = cv_blocks(i, 2);
		
	if(val_ratio > train_ratio)
		train_indices = indices( block_start : block_end);
		val_indices = [indices(1:block_start - 1) indices(block_end + 1 : end)];
	else
		val_indices = indices( block_start : block_end);
		train_indices = [indices(1:block_start - 1) indices(block_end + 1 : end)];		
	end
	
	display(['train indices iteration ' num2str(i) ': ' ]);
	display(train_indices);
	
	display(['val indices iteration ' num2str(i) ': ' ]);
	display(val_indices);
end
