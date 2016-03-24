%% Load images
planes = dir(fullfile('Caltech4','ImageData','airplanes_train','*.jpg'));
planes = {planes.name}';
%% Compute SIFT descriptors and perform k-means clustering
n = 50;
for i = 1:n
    im = imread(planes{i});
    im = single(rgb2gray(im));
    [~,D] = vl_sift(im);
    planesDlist{i} = D;
end
planesDarray = [planesDlist{:}];
planesDarray = double(planesDarray);
% We can compare the performance of the different k-means methods.
[planesC,planesA] = vl_kmeans(planesDarray,10);
planesK = kmeans(planesDarray,10);
%% Compute histograms
