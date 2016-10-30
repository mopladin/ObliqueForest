function [ minThreshold, minConfig, minC] = findBestSplit( X, Y, directions )
% Find the split yielding the lowest entropy of labels.
%
% Try splitting the input data at all data points along the given
% directions. Return the configuration of direction and threshold with the
% lowest resulting entropy. If multiple configurations with equal
% information gain exist, randomly choose one of them.
%
% No margin maximization is attempted. Optimizing this function would
% probably speed up the entire learning process significantly.

% Dimensions:
% N - number of data points
% D - dimension of data points
% L - number of labels

% Input:
% X - training data [NxD]
% Y - training labels [N]
% directions - normal vectors of splits to be evaluated

% Output:
% minThreshold - threshold value minimizing entropy
% minConfig    - normal vector of chosen split
% minC         - classification by chosen split

minThreshold = 0;
minConfig = [];
minC = [];

maxInfoGain = 0;

minRandomChoice = 1;

% Attempt to divide the input set into roughly equal halves
minDivisionDifference = realmax;

%% Calculate base entropy
labels = unique(Y);
base_entropy = 0;
for i = 1:length(labels)
    current_label = labels(i);
    p_i = length(find(Y == current_label)) / length(Y);
    base_entropy = base_entropy - p_i * log2(p_i);
end


% Loop over directions
for j = 1:size(directions, 1)

    direction = directions(j, :);

    % Project points onto direction
    X_p = X * direction';

    % Loop over thresholds for current direction
    for index = 1:length(X_p)
        
        threshold = X_p(index);
        
        C = ones(length(X_p), 1);
        C(X_p < threshold) = -1;

        infoGain = calculateInfoGain(base_entropy, C, Y);

        if(infoGain < maxInfoGain)
            % Current split is less accurate than previous best, ignore
            continue;
        end

        newBest = infoGain > maxInfoGain;

        % Check how large the difference in the split subsets sizes is
        divisionDifference = abs(length(find(C == -1)) - length(find(C == 1)));
    
        % If there is more than one point and split still classifies all the same, skip it
        if(size(X,1) > 1 && divisionDifference == size(X,1))
            continue;
        end

        % Split is as accurate and as even, use random decision
        randomChoice = rand;              

        if(~newBest)
            % Split is equally accurate as previous best
              
            if(divisionDifference > minDivisionDifference)
                % Split is as accurate but more uneven, ignore
                continue;
            end

            if(divisionDifference < minDivisionDifference)
                % Split is as accurate and more even, take
                newBest = true;
            else
                
                if(randomChoice < minRandomChoice)
                    % All things equal, randomly take this split
                    newBest = true;
                end
            end
        end

        if(newBest)
                    
            minDivisionDifference = divisionDifference;
            
            minRandomChoice = randomChoice;
            
            minThreshold = threshold;
            minConfig = direction;
            minC = C;

            maxInfoGain = infoGain;
        end
    end    
end

end

