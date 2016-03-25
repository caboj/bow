function D = getDescriptors(class,type,im_range, colorSpace)
    filePath=importdata(sprintf('Caltech4/ImageSets/%s_%s.txt',class,type));
    if strcmp(colorSpace,'gray')
        dlen = 128;
    else
        dlen = 384;
    end
    D = zeros(dlen,1);
    for img=im_range %length(filePath)
        path = strcat('Caltech4/ImageData/',filePath{img},'.jpg');
        im = color_spaces(imread(path),colorSpace);
        [~,d] = vl_phow(im2single(im),'Color',colorSpace);
        D=cat(2,D,d);
    end
    D = D(:,2:end);
end