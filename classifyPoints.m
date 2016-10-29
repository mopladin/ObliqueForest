function C = classifyPoints( X, direction, threshold )

Proj = X * direction;

C = ones(size(X, 1), 1);
C(Proj < threshold ) = -1; 

end

