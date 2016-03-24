function feat = quantizeFeatures(image, vdict, nfeat, draw)
% INPUT
% image  : path to image.
% vdict  : an array with clustered SIFT descriptors.
% nfeat  : the number of features/clusters in the visual dictionary.
%
% OUTPUT
% feat   : one-dimensional array with the counts of each feature present in
%          the image.

[~,descriptors] = vl_sift(image);
descriptors = double(descriptors);
feat = zeros(nfeat,1);
dist = vl_alldist2(descriptors,vdict);
for i = 1:nfeat
    [~,index] = min(dist(i,:));
    feat(index) = feat(index)+1;
end

switch draw
    case 1
        % draw a histogram
        figure
        bar(hists./sum(hists))
end