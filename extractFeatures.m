function [Features, Descriptors] = extractFeatures(Class, featureType, colorSpace)
    
    
    switch Class
        case 'faces'
            path='Caltech4\ImageSets\faces_train.txt';
        case 'airplanes'
            path='Caltech4\ImageSets\airplanes_train.txt';
        case 'cars'
            path='Caltech4\ImageSets\cars_train.txt';
        case 'motorbikes'
            path='Caltech4\ImageSets\motorbikes_train.txt';
    end
    
    filePath=importdata(path);
    
    switch featureType
        case 'dense'
            switch colorSpace
                case 'RGB'
                    
                case 'rgb'
                    
                case 'opponent'
                    
                case 'gray'
                    for img=1:length(filePath)
                        path = strcat('Caltech4/ImageData/',filePath{img},'.jpg');
                        path = strrep(path,'/','\'); %Replace for Mac and Linux
                        i=imread(path);
                        gray=im2single(rgb2gray(i));
                        [f,d] = vl_dsift(gray);
                        Features=cat(3,Features,f);
                        Descriptors=cat(3,Descriptors,d);
                    end
            end

        case 'pixel'
            switch colorSpace
                case 'RGB'
                    
                case 'rgb'
                    
                case 'opponent'
                    
                case 'gray'
                    for img=1:length(filePath)
                        path = strcat('Caltech4/ImageData/',filePath{img},'.jpg');
                        path = strrep(path,'/','\'); %Replace for Mac and Linux
                        i=imread(path);
                        gray=im2single(rgb2gray(i));
                        [f,d] = vl_sift(gray);
                        Features=cat(3,Features,f);
                        Descriptors=cat(3,Descriptors,d);
                    end
            end
            
    end
end