function [faces,cars, motorbikes,airplanes,words] = bow(k,colorSpace,voc_imgs, train_imgs,binsize)

    classes = {'faces' 'cars' 'motorbikes' 'airplanes'};

    words = getWords(classes,k,voc_imgs, colorSpace,binsize);
    
    [train,y] = buildTrainingData(classes, train_imgs, words, k, colorSpace,binsize);
    
    ts = tic;
    
    % training SVM calssifiers
    fprintf(' training SVMs ... ');
    %faces_svm = fitcsvm(train(:,:,1),y);
    faces_svm = fitcsvm(train(:,:,1),y,'KernelFunction','polynomial','PolynomialOrder',4,'KernelScale','auto');
    %cars_svm = fitcsvm(train(:,:,2),y);
    cars_svm = fitcsvm(train(:,:,2),y,'KernelFunction','polynomial','PolynomialOrder',4,'KernelScale','auto');
    %motorbikes_svm = fitcsvm(train(:,:,3),y);
    motorbikes_svm = fitcsvm(train(:,:,3),y,'KernelFunction','polynomial','PolynomialOrder',4,'KernelScale','auto'); 
    %airplanes_svm = fitcsvm(train(:,:,4),y);
    airplanes_svm = fitcsvm(train(:,:,4),y,'KernelFunction','polynomial','PolynomialOrder',4,'KernelScale','auto'); 
    
    toc(ts);
    [faces,cars,motorbikes, airplanes] = evaluate(classes,words, k, binsize, colorSpace , ...
            faces_svm, cars_svm, motorbikes_svm, airplanes_svm);
    
    
end
