function [faces,cars, motorbikes,airplanes, faces_svm,cars_svm,motorbikes_svm,aiplanes_svm] = bow(k,colorSpace,trainN)

    shuffled = randperm(400);
    classes = {'faces' 'cars' 'motorbikes' 'airplanes'};

    words = getWords(classes,k,shuffled(1:200), 'gray');
    
    train = buildTrainingData(classes, trainN, words, k, 'gray');
    
    ts = tic;
    
    % training SVM calssifiers
    fprintf(' training SVMs ... ');
    faces_svm = fitcsvm(train(:,:,1),y);
    cars_svm = fitcsvm(train(:,:,2),y);
    motorbikes_svm = fitcsvm(train(:,:,3),y); 
    airplanes_svm = fitcsvm(train(:,:,4),y); 
    
    toc(ts);
    [faces,cars,motorbikes, airplanes] = evaluate(classes,words, ...
            faces_svm, cars_svm, motorbikes_svm, airplanes_svm);
    
    getMAP(faces);
    
end
