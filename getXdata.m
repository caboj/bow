function X = getXdata(D,words)
    dists = pdist2(single(words),single(D)');
    [~,c] = min(dists);
    X = hist(c,size(words,1));
    X = X/norm(X);
end