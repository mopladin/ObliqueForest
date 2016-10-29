function visualizeData(X, Y, name, h)

    N = length(Y);    
    D = size(X, 2);
    colors = Y;
    
    % If only two labels, make colors match prob distribution
    if(length(unique(Y)) == 2)        
        colors = zeros(N, 3);        
        colors(Y == 1, 1) = 1;
        colors(Y == 2, 3) = 1;
    end
    
    if(D == 1 || D > 3)
        display(['Cannot display input data due to dimensionality of ' num2str(D)]);
        return;
    end
    
    subplot(h);
    
    % Display according to dimensionality
    if (D == 2)
        scatter(X(:,1), X(:,2), 15, colors, 'filled');
    elseif (D == 3)            
        scatter3(X(:,1), X(:,2), X(:,3), 4, Y, 'filled');
    end
    
    title(name);    
end
