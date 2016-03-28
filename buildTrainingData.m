function [train, y] = buildTrainingData(classes, trainSet, words, k, colorSpace )

    st= tic;
    trainN = size(trainSet,2);
    % build training data per class
    % select trainN images from 250 up
    fprintf(' building training data ... ');
    train = zeros(4*trainN,k,4);
    for ci = 1:size(classes,2)
        i = 1;
        for ii = trainSet
            D=getDescriptors(char(classes(ci)),'train',ii,colorSpace);
            train(i,:,ci) = getXdata(D,words);
            i = i+1;
        end
    end
    size(train)
    % add trainN negative examples of other classes
    for ci = 1:size(classes,2)
        cls = 1:4;
        cn = 1;
        for nci = [cls(1:ci-1) cls(ci+1:4)]
            ixi_start = cn*trainN+1;
            ixi_end = (cn+1)*trainN;
            train(ixi_start:ixi_end,:,ci) = train(1:trainN,:,nci);
            cn = cn+1;
        end
    end
    
    y = [ones(trainN,1);-1*ones(3*trainN,1)];
    toc(st)
end