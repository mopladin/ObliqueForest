function [infoGain] = calculateInfoGain(base_entropy, C, Y)

%% Calculate base entropy
labels = unique(Y);

Y_pos = Y(C == 1);
Y_neg = Y(C == -1);

pos_entropy = 0;
if(~isempty(Y_pos))
    for i = 1:length(labels)
        current_label = labels(i);
        p_i = length(find(Y_pos == current_label)) / length(Y_pos);        
        
        if(p_i ~= 0)
            pos_entropy = pos_entropy - p_i * log2(p_i);
        end
    end
end
    

neg_entropy = 0;
if(~isempty(Y_neg))
    for i = 1:length(labels)
        current_label = labels(i);
        p_i = length(find(Y_neg == current_label)) / length(Y_neg);
        
        if(p_i ~= 0)
            neg_entropy = neg_entropy - p_i * log2(p_i);
        end
    end
end

infoGain = base_entropy - length(Y_pos)/length(Y)*pos_entropy - ...
                          length(Y_neg)/length(Y)*neg_entropy;


end
