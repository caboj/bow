load('shuffled.mat')
voc_imgs=shuffled(1:200);
train_imgs=shuffled(201:400);
k=400;
colorSpace='RGB';
[faces,cars,motorbikes,airplanes,words]=bow(k,colorSpace,voc_imgs,train_imgs);