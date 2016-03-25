function [Features, Descriptors] = extractFeatures(Class, featureType, colorSpace)
   
switch Class
    case 'faces'
        path='Caltech4/ImageSets/faces_train.txt';
    case 'airplanes'
        path='Caltech4/ImageSets/airplanes_train.txt';
    case 'cars'
        path='Caltech4/ImageSets/cars_train.txt';
    case 'motorbikes'
        path='Caltech4/ImageSets/motorbikes_train.txt';
end

filePath=importdata(path);

switch featureType
    case 'dense'
        for img=1:length(filePath)
            path = strcat('Caltech4/ImageData/',filePath{img},'.jpg');
            %path = strrep(path,'/','\'); %Replace for Mac and Linux
            im = color_space(imread(path),colorSpace);
            [f,d] = vl_phow(im,'Color',colorSapce);
            Features=cat(2,Features,f);
            Descriptors=cat(2,Descriptors,d);
        end

    case 'pixel'
        for img=1:length(filePath)
            path = strcat('Caltech4/ImageData/',filePath{img},'.jpg');
            path = strrep(path,'/','\'); %Replace for Mac and Linux
            i=rgb2gray(imread(path));
            [f,d] = vl_phow(gray,'Color',colorSapce);
            Features=cat(3,Features,f);
            Descriptors=cat(3,Descriptors,d);
        end
        
end
end
