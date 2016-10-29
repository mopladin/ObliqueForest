function [ X, Y ] = generateClusters(centers, counts, labels)

X = [];
Y = [];

D = size(centers, 2);

for index = 1:size(centers, 1)
    
    % Generate random samples
    %X_a = random('normal', 0, 1, counts(index), D); % Octave
    X_a = normrnd(0, 1, counts(index), D);
    X_a = round(X_a * 10);

    shift = centers(index, :);
    
    shift_mat = repmat(shift, size(X_a, 1), 1);
    %X_a = [X_a(:, 1) + shift(1) X_a(:, 2) + shift(2)]; % Octave
    X_a = X_a + shift_mat;
    Y_a = labels(index) * ones(size(X_a, 1), 1);

    X = [X ; X_a];
    Y = [Y ; Y_a];
end

end

