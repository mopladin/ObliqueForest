function [ X, Y ] = generateRandomClusters(scale, N_c, N, D)

cluster_centers = normrnd(0, 1, N_c, D) * scale;

labels = ones(N_c, 1);

random_clusters = randperm(N_c);
labels(random_clusters(1: N_c / 2) ) = 2;

[ X, Y ] = generateClusters(cluster_centers, N / N_c * ones(N_c, 1), labels);

X = floor(X);

end