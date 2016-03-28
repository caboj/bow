function D = getDescriptors(class,type,im_range, colorSpace,binsize)
    filePath=importdata(sprintf('Caltech4/ImageSets/%s_%s.txt',class,type));
    D = [];
    for img=im_range %length(filePath)
        path = strcat('Caltech4/ImageData/',filePath{img},'.jpg');
        im = color_spaces(imread(path),colorSpace);
        if strcmp(colorSpace,'gray')
            if binsize == 0
                [~,d] = vlsift(im2single(im));
            else
                im = vl_imsmooth(im2single(im),binsize/2);
                [~,d] = vl_dsift(im2single(im),'size',binsize);
            end
        else
            d = colourSpacesSift(im,colorSpace);
        end
        %[~,d] = vl_phow(im2single(im),'Color',colorSpace);
        D=cat(2,D,d);
    end
end