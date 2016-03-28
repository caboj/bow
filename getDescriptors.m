function D = getDescriptors(class,type,im_range, colorSpace)
    filePath=importdata(sprintf('Caltech4/ImageSets/%s_%s.txt',class,type));
    D = [];
    for img=im_range %length(filePath)
        path = strcat('Caltech4/ImageData/',filePath{img},'.jpg');
        im = color_spaces(imread(path),colorSpace);
        if strcmp(colorSpace,'gray')
            [~,d] = vl_sift(im2single(im));
        else
            d = colourSpacesSift(im,colorSpace);
        end
        %[~,d] = vl_phow(im2single(im),'Color',colorSpace);
        D=cat(2,D,d);
    end
end