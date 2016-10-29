clc;
clear;

load('experiments\numerical\7D_randClusters-aligned-pca-cca-rand_t20\errors.txt');

acc = ones(size(errors)) - errors;

maxAcc = max(acc(:));
minAcc = min(acc(:));

names = {'Aligned' 'PCA' 'CCA' 'Random'};

hFig = figure;
figureMetrics = [128 128 1024 640];
set(hFig, 'Position', figureMetrics);
set(hFig, 'name', '7D');

for index = 1:4
    
    subplot(1, 4, index);
    
    X = 1:size(acc, 1);
    Y = acc(:, index);
    
    my = mean(Y);
    sigma = std(Y);
    
    plot([0 20], [my my], 'r');
    hold on;
    plot([0 20], [my + sigma my + sigma], ':r');
    plot([0 20], [my - sigma my - sigma], ':r');
    
    scatter(X, Y, 'filled');
    axis([0 20 minAcc maxAcc]);
    
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    
    title(names(index));
end