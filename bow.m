function [faces,cars, motorbikes,airplanes,words] = bow(k,colorSpace,trainN)
    if strcmp(colorSpace,'gray')
        dlen = 128;
    else
        dlen = 384;
    end
    D = zeros(dlen,1);
    % build vocabulary with all classes with first range voc_imgs
    voc_imgs = 1:250;
    classes = {'faces' 'cars' 'motorbikes' 'airplanes'};
    ts = tic;
    fprintf(' extracting SIFT desciptors ... ');

    for i = 1:size(classes,2)
        d = getDescriptors(char(classes(i)),'train',voc_imgs,colorSpace);
        D=cat(2,D,d);
    end
    D=D(:,2:end);
    fprintf( 'found %d - ',size(D,2));
    toc(ts);
    
    ts = tic;
    fprintf(' finding vocab - clustering ... ');
    [words,~] = vl_kmeans(single(D),k);
    words = words';
    %[~,words] = kmeans(single(D'),k,'MaxIter',1e10);
    toc(ts);
    
    % build training data per class
    % select trainN images from 250 up
    ts = tic;
    fprintf(' building training data ... ');
    train = zeros(4*trainN,k,4);
    for ci = 1:size(classes,2)
        for ii = 1:trainN
            imi = 250+ii;
            D=getDescriptors(char(classes(ci)),'train',imi,colorSpace);
            train(ii,:,ci) = getXdata(D,words);
        end
    end
    
    % add trainN negative examples of other classes
    for ci = 1:size(classes,2)
        idx = randi(trainN,1,trainN);
        cls = 1:4;
        cn = 1;
        for nci = [cls(1:ci-1) cls(ci+1:4)]
            ixi_start = cn*trainN+1;
            ixi_end = (cn+1)*trainN;
            train(ixi_start:ixi_end,:,ci) = train(1:150,:,nci);
            cn = cn+1;
        end
    end
    
    y = ones(4*trainN,1);
    y(trainN+1:end) = -1;
    
    toc(ts);
    ts = tic;
    
    % training SVM calssifiers
    fprintf(' training SVMs ... ');
    faces_svm = fitcsvm(train(:,:,1),y);
    cars_svm = fitcsvm(train(:,:,2),y);
    motorbikes_svm = fitcsvm(train(:,:,3),y); 
    airplanes_svm = fitcsvm(train(:,:,4),y); 
    
    toc(ts);
    ts = tic;
    
    fprintf(' evaluating ... ');
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
        
        [labels,scores] =  predict(faces_svm,testD);
        faces.labels(range) = labels;
        faces.scores(range) = scores(:,2);
        faces.fns(range) = filePath';
        [labels,scores] = predict(cars_svm,testD);
        cars.labels(range) = labels;
        cars.scores(range) = scores(:,2);
        cars.fns(range) = filePath';
        [labels,scores] = predict(motorbikes_svm,testD);
        motorbikes.labels(range) = labels;
        motorbikes.scores(range) = scores(:,2);
        motorbikes.fns(range) = filePath';
        [labels,scores] = predict(airplanes_svm,testD);
        airplanes.labels(range) = labels;
        airplanes.scores(range) = scores(:,2);
        airplanes.fns(range) = filePath';
    end
    toc(ts);
    
    
    faces.reals = [ones(50,1);-1*ones(150,1)];
    [~,order] = sort(faces.scores,1,'descend');
    faces.fns = faces.fns(order);
    faces.labels = faces.labels(order);
    faces.scores = faces.scores(order);
    faces.reals = faces.reals(order);
    
    cars.reals = [-1*ones(50,1);ones(50,1);-1*ones(100,1)];
    [~,order] = sort(cars.scores,1,'descend');
    cars.fns = cars.fns(order);
    cars.labels = cars.labels(order);
    cars.scores = cars.scores(order);
    cars.reals = cars.reals(order);
    
    motorbikes.reals = [-1*ones(100,1);ones(50,1);-1*ones(50,1)];
    [~,order] = sort(motorbikes.scores,1,'descend');
    motorbikes.fns = motorbikes.fns(order);
    motorbikes.labels = motorbikes.labels(order);
    motorbikes.scores = motorbikes.scores(order);
    motorbikes.reals = motorbikes.reals(order);
    
    airplanes.reals = [-1*ones(150,1);ones(50,1)];
    [~,order] = sort(airplanes.scores,1,'descend');
    airplanes.fns = airplanes.fns(order);
    airplanes.labels = airplanes.labels(order);
    airplanes.scores = airplanes.scores(order);
    airplanes.reals = airplanes.reals(order);
    
    
    
end
