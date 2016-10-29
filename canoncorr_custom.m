function [ direction ] = canoncorr_custom(X, Y)

N = size(X, 1);

X_mf = X - repmat(mean(X), size(X,1), 1);
Y_mf = Y - repmat(mean(Y), size(Y,1), 1);

C_xx = 1/(N - 1) * (X_mf' * X_mf);
C_yy = 1/(N - 1) * (Y_mf' * Y_mf);
C_xy = 1/(N - 1) * (X_mf' * Y_mf);

C_yx = C_xy';


%C = [C_xx C_xy ; C_yx C_yy];

%R_1 = inv(C_yy)*C_yx*inv(C_xx)*C_xy;
R_2 = inv(C_xx)*C_xy*inv(C_yy)*C_yx;

% Check for NaN values
stable = true;
for i = 1:size(R_2, 1)
    for j = 1:size(R_2, 2)
        if R_2(i,j) ~= R_2(i, j)
            stable = false;
        end
        
        if(R_2(i,j) == inf)
            stable = false;
        end
    end
end

if(stable)    

    %[V_1, D_1] = eig(R_1);
    [V_2, D_2] = eig(R_2);


    %[~, maxD1Index] = max(diag(D_1));
    [~, maxD2Index] = max(diag(D_2));

    %vector_1 = V_1(:,maxD1Index);
    direction = V_2(:,maxD2Index);

    direction = -direction';

else
    [A, ~] = canoncorr(X, Y);
    direction = A';
    
    display('WARNING: CCA was unstable');
end


end

