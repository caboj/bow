load('shuffled.mat')
voc_imgs=shuffled(1:200);
train_imgs=shuffled(201:400);
k=2000;
colorSpace='gray';
[faces,cars,motorbikes,airplanes,words]=bow(k,colorSpace,voc_imgs,train_imgs);