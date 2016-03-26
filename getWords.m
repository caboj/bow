function  words  = getWords(classes, k, voc_imgs, colorSpace)
    D =[];
    % build vocabulary with all classes with first range voc_imgs
    ts = tic;
    fprintf(' extracting SIFT desciptors ... ');

    for i = 1:size(classes,2)
        d = getDescriptors(char(classes(i)),'train',voc_imgs,colorSpace);
        D=cat(2,D,d);
    end
    fprintf( 'found %d - ',size(D,2));
    toc(ts);
    
    ts = tic;
    fprintf(' finding vocab - clustering ... ');
    %load('words.mat');
    %[words,~] = vl_kmeans(single(D'),k);
    %words = words';
    [~,words] = kmeans(double(D'),k,'MaxIter',1e6, 'OnlinePhase', 'on');
    toc(ts);
end

