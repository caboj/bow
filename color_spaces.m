% Computer Vision course UvA - MSc AI - Assignment 1.2
% Ildefonso Ferreira Pica & Jacob Verdegaal

% choose colorspace, convert and display in grayscale.
% assuming images are in rgb colorspace
function spaced = color_spaces(im,space)
    spaced = zeros(size(im));
    if strcmp(space,'hsv') 
        % convert image, then separate channels
        rgb2hsv(im);
        ch1 = im(:,:,1); ch2 = im(:,:,2); ch3 = im(:,:,3);
    elseif strcmp(space,'opponent')
        % calculate the opponent colors following the 
        % formulae in the assignment
        ch1 = (im(:,:,1)-im(:,:,2)) ./ sqrt(2);
        ch2 = (im(:,:,1)+im(:,:,2)-2*im(:,:,3))./ sqrt(6);
        ch3 = (im(:,:,1)+im(:,:,2)+im(:,:,3))./ sqrt(3);
    elseif strcmp(space,'normalized')
        % seperate chanels
        ch1 = im(:,:,1); ch2 = im(:,:,2); ch3 = im(:,:,3);
        % pointwise normalize
        n = double(ch1+ch2+ch3);
        ch1 = double(ch1)./n;
        ch2 = double(ch2)./n;
        ch3 = double(ch3)./n;
    else
        disp('please specify one color space: hsv - opponent - normalized');
    end
    
    spaced(:,:,1) = ch1;
    spaced(:,:,2) = ch2;
    spaced(:,:,3) = ch3;
    % show channels in grayscale
    %imshow([ch1,ch2,ch3]);
    
end
