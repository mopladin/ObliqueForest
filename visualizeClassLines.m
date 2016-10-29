function  visualizeClassLines(directions, thresholds, X, h)

subplot(h);

% Get range of values to test
minimum = [min(X(:,1)) min(X(:,2))];
maximum = [max(X(:,1)) max(X(:,2))];

scale = 10;

N_n = length(thresholds);

% Keep track of plotted lines to avoid redundancy
plottedArrows = [];

for current_node = 1:N_n

    direction = directions(current_node, :);
    threshold = thresholds(current_node);

    %%

    normStart = direction * threshold;
    %normStart = direction * threshold;
    normEnd = normStart + (direction * scale);

    normArrow = [normStart' normEnd'];

    % Check if line has been plotted before
    redundant = false;
    for i = 1:size(plottedArrows,1)
        currentArrow = plottedArrows(i, :);

        if [normArrow(1,1) normArrow(2,1)] == currentArrow
            redundant = true;
        end
    end

    if redundant == true
        continue;
    end

    plot(normArrow(1,:), normArrow(2,:), 'g'); 
    hold on;
    plot(normArrow(1,1), normArrow(2,1), 'g*');
    hold on;

    plottedArrows = [plottedArrows ; normArrow(1,1) normArrow(2,1)];

    label = cellstr( num2str(current_node) );

    text(normArrow(1,1), normArrow(2,1), label, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')

    %%
    %{
    if(direction(2) == 0)
        orthogonalStart = [threshold minimum(2)];
        orthogonalEnd = [threshold maximum(2)];

        orthogonal = [orthogonalStart' orthogonalEnd'];

        plot(orthogonal(1,:), orthogonal(2,:), 'g'); 
    end

    if(direction(1) == 0)
        orthogonalStart = [minimum(1) threshold];
        orthogonalEnd = [maximum(1) threshold];

        orthogonal = [orthogonalStart' orthogonalEnd'];

        plot(orthogonal(1,:), orthogonal(2,:), 'g'); 

    end
    %}
    
    ortho = [direction(2) -direction(1)];

    xlim = get(gca,'xlim');
    ylim = get(gca,'ylim');

    if(ortho(1) ~= 0 && ortho(2) ~= 0)

        a = ortho(2)/ortho(1);
        b = -normStart(1)*a + normStart(2);


        y_left = a * xlim(1) + b;
        y_right = a * xlim(2) + b;

        x_bottom = (ylim(1) - b) / a;
        x_top = (ylim(2) - b) / a;

        point0 = [xlim(1) y_left];
        point1 = [xlim(2) y_right];

        if(y_left < ylim(1))
            point0 = [x_bottom ylim(1)];
        end

        if(y_left > ylim(2))
            point0 = [x_top ylim(2)];
        end

        if(y_right < ylim(1))
            point1 = [x_bottom ylim(1)];
        end

        if(y_right > ylim(2))
            point1 = [x_top ylim(2)];
        end

    else

        if(ortho(1) == 0)
            point0 = [normStart(1) ylim(1)];
            point1 = [normStart(1) ylim(2)];
        else
            point0 = [xlim(1) normStart(2)];
            point1 = [xlim(2) normStart(2)];
        end
    end

    plot([point0(1) point1(1)], [point0(2) point1(2)], 'g');

end
axis equal;
end

