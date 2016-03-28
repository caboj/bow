function [faces,cars,motorbikes, airplanes] = evaluate(classes,words, k,binsize, ...
            colorSpace, faces_svm, cars_svm, motorbikes_svm, airplanes_svm)

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
            D = getDescriptors(char(classes(ci)),'test',imi,colorSpace,binsize);
            testD(imi,:) = getXdata(D,words);
        end
        range = (ci-1)*50+1:ci*50;
        
        [labels,scores] =  predict(faces_svm,testD);
        faces.labels(range,1) = labels;
        faces.scores(range,1) = scores(:,2);
        faces.fns(range,1) = filePath';
        [labels,scores] = predict(cars_svm,testD);
        cars.labels(range,1) = labels;
        cars.scores(range,1) = scores(:,2);
        cars.fns(range,1) = filePath';
        [labels,scores] = predict(motorbikes_svm,testD);
        motorbikes.labels(range,1) = labels;
        motorbikes.scores(range,1) = scores(:,2);
        motorbikes.fns(range,1) = filePath';
        [labels,scores] = predict(airplanes_svm,testD);
        airplanes.labels(range,1) = labels;
        airplanes.scores(range,1) = scores(:,2);
        airplanes.fns(range,1) = filePath';
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
