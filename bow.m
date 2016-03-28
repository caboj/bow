function [faces,cars, motorbikes,airplanes,words] = bow(k,colorSpace,voc_imgs, train_imgs)

    classes = {'faces' 'cars' 'motorbikes' 'airplanes'};

    words = getWords(classes,k,voc_imgs, colorSpace);
    
    [train,y] = buildTrainingData(classes, train_imgs, words, k, colorSpace);
    
    ts = tic;
    
    % training SVM calssifiers
    fprintf(' training SVMs ... ');
    faces_svm = fitcsvm(train(:,:,1),y);
    cars_svm = fitcsvm(train(:,:,2),y);
    motorbikes_svm = fitcsvm(train(:,:,3),y); 
    airplanes_svm = fitcsvm(train(:,:,4),y); 
    
    toc(ts);
    [faces,cars,motorbikes, airplanes] = evaluate(classes,words, k, colorSpace, ...
            faces_svm, cars_svm, motorbikes_svm, airplanes_svm);
    
    
end
