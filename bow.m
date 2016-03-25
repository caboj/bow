function train = bow(k,colorSpace)
    if strcmp(colorSpace,'gray')
        dlen = 128;
    else
        dlen = 384;
    end
    D = zeros(dlen,1);
    % build vocabulary with all classes
    classes = {'faces' 'cars' 'motorbikes' 'airplanes'};
    for i = 1:size(classes,2)
        fprintf(' extracting SIFT desciptors for vocabulary from %s\n',char(classes(i)));
        d = getDescriptors(char(classes(i)),1:3,colorSpace);
        D=cat(2,D,d);
    end
    D=D(:,2:end);
    
    fprintf(' finding vocab - clustering...\n');
    %[words,~] = vl_kmeans(single(D),k);
    [~,words] = kmeans(single(D'),k);

    % build training data per class
    fprintf(' building training data...\n');
    train = zeros(10,k,4);
    for ci = 1:size(classes,2)
        for ii = 1:10
            imi = 290+ii;
            D=getDescriptors(char(classes(ci)),imi,colorSpace);
            train(ii,:,ci) = getXdata(D,words);
        end
    end
end
