%Images=[];
% tic;
% classes={'airplanes','cars','faces','motorbikes'};
% descriptors={};
% for m=1:4
%     for n=1:25
%         i=imread(strcat('Caltech4\ImageData\',classes{m},'_train\img',sprintf('%03i',n),'.jpg'));
%         gray=rgb2gray(i);
%         gray=im2single(gray);
%         [~,d]=vl_sift(gray);
%         tmp=num2cell(d);
%         descriptors=cat(1,descriptors,d);
%         %Images=cat(3,Images,gray);
%     end
% end
% toc;


tic;
load('words.mat');
pos_train_histogram=zeros(50,400);
k=1;
for n=351:400
    i=imread(strcat('Caltech4\ImageData\airplanes_train\img',sprintf('%03i',n),'.jpg'));
    dims=ndims(i);
    if dims>2
        gray=im2single(rgb2gray(i));
    else
        gray=im2single(i);
    end
    [~,d]=vl_sift(gray);
    dist = pdist2(words,single(d)');
    h = zeros(size(words',2),1);
    tmp2=dist';
    for j = 1:size(d,2)
        [~,ind] = min(tmp2(j,:));
        h(ind) = h(ind)+1;
    end
    pos_train_histogram(k,:)=h';
    k=k+1;
end
neg_train_histogram=zeros(150,400);
k=1;
for n=351:400
    i=imread(strcat('Caltech4\ImageData\cars_train\img',sprintf('%03i',n),'.jpg'));
    dims=ndims(i);
    if dims>2
        gray=im2single(rgb2gray(i));
    else
        gray=im2single(i);
    end
    [~,d]=vl_sift(gray);
    dist = pdist2(words,single(d)');
    h = zeros(size(words',2),1);
    tmp2=dist';
    for j = 1:size(d,2)
        [~,ind] = min(tmp2(j,:));
        h(ind) = h(ind)+1;
    end
    neg_train_histogram(k,:)=h';
    k=k+1;
end
for n=351:400
    i=imread(strcat('Caltech4\ImageData\faces_train\img',sprintf('%03i',n),'.jpg'));
    dims=ndims(i);
    if dims>2
        gray=im2single(rgb2gray(i));
    else
        gray=im2single(i);
    end
    [~,d]=vl_sift(gray);
    dist = pdist2(words,single(d)');
    h = zeros(size(words',2),1);
    tmp2=dist';
    for j = 1:size(d,2)
        [~,ind] = min(tmp2(j,:));
        h(ind) = h(ind)+1;
    end
    neg_train_histogram(k,:)=h';
    k=k+1;
end
for n=351:400
    i=imread(strcat('Caltech4\ImageData\motorbikes_train\img',sprintf('%03i',n),'.jpg'));
    dims=ndims(i);
    if dims>2
        gray=im2single(rgb2gray(i));
    else
        gray=im2single(i);
    end
    [~,d]=vl_sift(gray);
    dist = pdist2(words,single(d)');
    h = zeros(size(words',2),1);
    tmp2=dist';
    for j = 1:size(d,2)
        [~,ind] = min(tmp2(j,:));
        h(ind) = h(ind)+1;
    end
    neg_train_histogram(k,:)=h';
    k=k+1;
end
labels=ones(200,1);
labels(51:200,1)=-1;
features=zeros(200,400);
features(1:50,:)=pos_train_histogram(:,:);
features(51:200,:)=neg_train_histogram(:,:);
toc;
tic;
model_airplane=svmtrain(labels,features);
toc;
tic;
pos_test_histogram=zeros(50,400);
for n=1:50
    i=imread(strcat('Caltech4\ImageData\airplanes_test\img',sprintf('%03i',n),'.jpg'));
    dims=ndims(i);
    if dims>2
        gray=im2single(rgb2gray(i));
    else
        gray=im2single(i);
    end
    [~,d]=vl_sift(gray);
    dist = pdist2(words,single(d)');
    h = zeros(size(words',2),1);
    tmp2=dist';
    for j = 1:size(d,2)
        [~,ind] = min(tmp2(j,:));
        h(ind) = h(ind)+1;
    end
    pos_test_histogram(n,:)=h';
end
toc;
[predict_label,accuracy,dec_values] = svmpredict(ones(50,1),pos_test_histogram,model_airplane);



sigma = 2e-3;
% rbfKernel = @(X,Y) exp(-sigma .* pdist2(X,Y,'euclidean').^2);
% tanh(gamma*u'*v + coef0)
coef0=0;

rbfKernel = @(X,Y) tanh((sigma .* (X*Y)) + coef0);

numTrain=size(features,1);
numTest=size(pos_test_histogram,1);

tmp2=rbfKernel(features,pos_test_histogram');
tmp3=zeros(size(tmp2,1));
tmp4=(1:numTrain)';
tmp3=zeros(size(tmp2,1),1);
tmp3(1:size(tmp4,1),:)=tmp4;

K =  [ tmp3 , tmp2 ];

tmp2=rbfKernel(features,pos_test_histogram');
tmp3=zeros(size(tmp2,1));
tmp4=(1:numTrain)';
tmp3=zeros(size(tmp2,1),1);
tmp3(1:size(tmp4,1),:)=tmp4;

KK = [ tmp3  , tmp2  ];

model = svmtrain(labels, K, '-t 4');
[predClass, acc, decVals] = svmpredict(ones(50,1), KK, model);
