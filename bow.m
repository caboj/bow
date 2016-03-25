function [faces,cars ] = bow(k,colorSpace,trainN)
    if strcmp(colorSpace,'gray')
        dlen = 128;
    else
        dlen = 384;
    end
    D = zeros(dlen,1);
    % build vocabulary with all classes
    classes = {'faces' 'cars' 'motorbikes' 'airplanes'};
    fprintf(' extracting SIFT desciptors for vocabulary ...\n');

    for i = 1:size(classes,2)
        d = getDescriptors(char(classes(i)),'train',1:3,colorSpace);
        D=cat(2,D,d);
    end
    D=D(:,2:end);
    
    fprintf(' finding vocab - clustering ...\n');
    %[words,~] = vl_kmeans(single(D),k);
    [~,words] = kmeans(single(D'),k);

    % build training data per class
    fprintf(' building training data ...\n');
    fprintf('   ... setting positive examples\n');
    train = zeros(4*trainN,k,4);
    for ci = 1:size(classes,2)
        for ii = 1:trainN
            imi = 290+ii;
            D=getDescriptors(char(classes(ci)),'train',imi,colorSpace);
            train(ii,:,ci) = getXdata(D,words);
        end
    end
    
    fprintf('   ... setting negative examples\n');
    for ci = 1:size(classes,2)
        idx = randi(trainN,1,trainN);
        cls = 1:4;
        cn = 0;
        for nci = [cls(1:ci-1) cls(ci+1:4)]
            for ii = 1:trainN
                ixi = trainN+cn*trainN+ii;
                train(ixi,:,ci) = train(idx(ii),:,nci);
            end
            cn = cn+1;
        end
    end
    
    y = ones(4*trainN,1);
    y(trainN+1:end) = -1;
    % training SVM calssifiers
    fprintf(' training SVMs ... \n');
    faces_svm = fitcsvm(train(:,:,1),y);
    cars_svm = fitcsvm(train(:,:,2),y);
    motorbikes_svm = fitcsvm(train(:,:,3),y); 
    airplanes_svm = fitcsvm(train(:,:,4),y); 
    
    fprintf(' evaluating ...\n');
    faces = struct;
    cars= struct;
    motorbikes = struct;
    airplanes = struct;
    for ci = 1:4
        filePath=importdata(sprintf('Caltech4/ImageSets/%s_test.txt',char(classes(ci))));
        testD = zeros(50,k);
        for imi = 1:50
            D = getDescriptors(char(classes(ci)),'test',imi,colorSpace);
            testD(imi,:) = getXdata(D,words);
        end
        range = (ci-1)*50+1:ci*50;
        
        [label,score] =  predict(faces_svm,testD);
        faces.res(range,1:2) = [label,score(:,2)];
        faces.fns(range) = filePath;
        [label,score] = predict(cars_svm,testD);
        cars.res(range,1:2)= [label,score(:,2)];
        cars.fns(range) = filePath;
        [label,score] = predict(motorbikes_svm,testD);
        motorbikes.res(range,1:2) = [label,score(:,2)];
        motorbikes.fns(range) = filePath;
        [label,score] = predict(airplanes_svm,testD);
        airplanes.res(range,1:2) = [label,score(:,2)];
        airplanes.fns(range) = filePath;
    end
end
