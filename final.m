%% Load images
<<<<<<< Updated upstream
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
=======
% planes = dir(fullfile('Caltech4','ImageData','airplanes_train','*.jpg'));
% planes = {planes.name}';
faces = dir(fullfile('Caltech4','ImageData','faces_train','*.jpg'));
faces = {faces.name}';
%% Compute SIFT descriptors and perform k-means clustering
n = 50;
facesDlist = cell(n,1);
for i = 1:n
    face = single(rgb2gray(imread(faces{i})));
    [~,Dface] = vl_sift(face);
    facesDlist{i} = Dface;
end
facesDarray = [facesDlist{:}];
facesDarray = double(facesDarray);
% [minsize, minidx] = min(cellfun('size', facesDlist, 2));
%% K-means clustering
% We can compare the performance of the different k-means methods.
[facesC, facesA] = vl_kmeans(facesDarray,400);
% planesK = kmeans(planesDarray,100);
Karray = facesC;
%% Feature quantization
test = single(rgb2gray(imread(faces{300}))); % Example histogram for one face image.
[~,Dtest] = vl_sift(test); Dtest = double(Dtest);
test_quant = zeros(size(Karray,2),1);
dist = vl_alldist2(Dtest,Karray);
for i = 1:size(Dtest,2)
    [~,index] = min(dist(i,:));
    test_quant(index) = test_quant(index)+1;
end
disp('Check!')
figure; bar(test_quant./sum(test_quant))
%% SVM for faces
% Must use labeled data: -1 = negative example, +1 = positive example.
for i = 1:n
    test = single(rgb2gray(imread(faces{end-i})));
end
>>>>>>> Stashed changes
