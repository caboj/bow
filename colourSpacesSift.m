function Features = colourSpacesSift(Image, Colour_Space)
    

%     img=imread(Image);
    img = Image;
    switch (Colour_Space)
        case 'rgb'
            summed=sum(img(:,:,:),3);
            r=double(img(:,:,1));
            g=double(img(:,:,2));
            b=double(img(:,:,3));
            rn=r./summed;
            gn=g./summed;
            bn=b./summed;
            
        case 'opponent'
            r=double(img(:,:,1));
            g=double(img(:,:,2));
            b=double(img(:,:,3));
            rn=(r-g)./sqrt(2);
            gn=(r+g-2*b)./sqrt(6);
            bn=sum(img,3)./sqrt(3);
        case 'hsv'
            hsv=rgb2hsv(img);
            rn=hsv(:,:,1);
            gn=hsv(:,:,2);
            bn=hsv(:,:,3);
    end
    
    [~,feature1] = vl_sift(im2single(rn));
    [~,feature2] = vl_sift(im2single(gn));
    [~,feature3] = vl_sift(im2single(bn));
    Features = cat(2,feature1,feature2,feature3);
    