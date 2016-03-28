function spaced = color_spaces(im,space)
    spaced = zeros(size(im));
    if strcmp(space,'gray')
        if size(size(im),2) == 2
            spaced = im;
        else
            spaced = rgb2gray(im);
        end
    % if space is other than gray, but image is in gray,
    % replicate grayscale to ensure correct amount of descriptors
    else
        if size(size(im),2) == 2
            im = repmat(im,1,1,3);
        end
        if strcmp(space,'RGB')
            ch1 = im(:,:,1);
            ch2 = im(:,:,2);
            ch3 = im(:,:,3);
        elseif strcmp(space,'hsv') 
            % convert image, then separate channels
            rgb2hsv(im);
            ch1 = im(:,:,1); ch2 = im(:,:,2); ch3 = im(:,:,3);
        elseif strcmp(space,'opponent')
            % calculate the opponent colors following the 
            % formulae in the assignment
            ch1 = (im(:,:,1)-im(:,:,2)) ./ sqrt(2);
            ch2 = (im(:,:,1)+im(:,:,2)-2*im(:,:,3))./ sqrt(6);
            ch3 = (im(:,:,1)+im(:,:,2)+im(:,:,3))./ sqrt(3);
        elseif strcmp(space,'rgb')
            % seperate chanels
            ch1 = im(:,:,1); ch2 = im(:,:,2); ch3 = im(:,:,3);
            % pointwise normalize
            n = double(ch1+ch2+ch3);
            ch1 = double(ch1)./n;
            ch2 = double(ch2)./n;
            ch3 = double(ch3)./n;
        end

        spaced(:,:,1) = ch1;
        spaced(:,:,2) = ch2;
        spaced(:,:,3) = ch3;
    end
end
