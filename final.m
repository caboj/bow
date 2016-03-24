% %% Load images
% planes = dir(fullfile('Caltech4','ImageData','airplanes_train','*.jpg'));
% planes = {planes.name}';
% %% Compute SIFT descriptors and perform k-means clustering
% n = 50;
% for i = 1:n
%     im = imread(planes{i});
%     im = single(rgb2gray(im));
%     [~,D] = vl_sift(im);
%     planesDlist{i} = D;
% end
% planesDarray = [planesDlist{:}];
% planesDarray = double(planesDarray);
% % We can compare the performance of the different k-means methods.
% [planesC,planesA] = vl_kmeans(planesDarray,10);
% planesK = kmeans(planesDarray,10);
%% Compute histograms
planes = dir(fullfile('Caltech4','ImageData','airplanes_train','*.jpg'));
planes = {planes.name}';
cars = dir(fullfile('Caltech4','ImageData','cars_train','*.jpg'));
cars = {cars.name}';
faces = dir(fullfile('Caltech4','ImageData','faces_train','*.jpg'));
faces = {faces.name}';
motorbikes = dir(fullfile('Caltech4','ImageData','airplanes_train','*.jpg'));
motorbikes = {motorbikes.name}';
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
test = single(rgb2gray(imread(faces{1}))); % Example histogram for one face image.
[~,Dtest] = vl_sift(test); Dtest = double(Dtest);
hists = zeros(size(Karray,2),1);
dist = vl_alldist2(Dtest,Karray);
for i = 1:size(Dtest,2)
    [~,index] = min(dist(i,:));
    hists(index) = hists(index)+1;
end
disp('Check!')
figure; bar(hists./sum(hists))
%% SVM for faces
% Must use labeled data: -1 = negative example, +1 = positive example.
% clear test hists
% features = zeros(200,400);
% labels = ones(200,1);
% labels(51:end) = -1;
% test_features = zeros(50,400);
% for i = 1:50
%     test = single(rgb2gray(imread(faces{i})));
%     [~,Dtest] = vl_sift(test); Dtest = double(Dtest);
%     hists = zeros(size(Karray,2),1);
%     dist = vl_alldist2(Dtest,Karray);
%     for j = 1:size(Dtest,2)
%         [~,index] = min(dist(j,:));
%         hists(index) = hists(index)+1;
%     end
%     test_features(i,:) = hists(:);
% end

% NOTE: You can run the following code using the faces_features.mat,
% faces_labels.mat and faces_test.mat files. You don't need to uncomment
% the above code.
model_linear = svmtrain(faces_labels,faces_features);
[predict_label,accuracy,dec_values] = svmpredict(ones(50,1),faces_test,model_linear);