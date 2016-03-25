function train = bow(k,colorSpace,trainN)
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
    fprintf('   ...setting positive examples'\n);
    train = zeros(trainN+3*floor(trainN/3),k,4);
    for ci = 1:size(classes,2)
        for ii = 1:trainN
            imi = 290+ii;
            D=getDescriptors(char(classes(ci)),imi,colorSpace);
            train(ii,:,ci) = getXdata(D,words);
        end
    end
    
    fprintf('   ...setting negative examples'\n);
    for ci = 1:size(classes,2)
        idx = randi(trainN,1,floor(trainN/3));
        cls = 1:4;
        cn = 0;
        for nci = [cls(1:ci-1) cls(ci+1:4)]
            for ii = 1:floor(trainN/3)
                ixi = trainN+cn*floor(trainN/3)+ii;
                train(ixi,:,ci) = train(idx(ii),:,nci);
            end
            cn = cn+1;
        end
    end
    
    
    
end
