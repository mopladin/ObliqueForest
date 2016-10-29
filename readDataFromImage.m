function [X, Y] = readDataFromImage(path, name)

I = imread([path  name]);

X = [];
Y = [];

for x = 1:size(I, 2)
    for y = 1:size(I, 1)

        rgb = I(y, x, :);

        marked = false;
        
        if(rgb(1) > rgb(2))
            Y = [Y ; 1];
            marked = true;
        else
            if(rgb(3) > rgb(2))     
                   Y = [Y ; -1];
                marked = true;
            end
        end

        if(marked)
            X = [X ; x y];
        end
    end
end

X(:,2) = max(X(:,2)) - X(:,2);

save([path  'X.txt'], 'X', '-ASCII');
save([path  'Y.txt'], 'Y', '-ASCII');
end
