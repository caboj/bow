function [p,map, ap] = getAP(resStruct)
    reals = resStruct.reals;
    predictions = resStruct.labels;
    
    n = size(predictions,1);
    ap = zeros(n,1);
    ap(1) = f(predictions(1),reals(1));
    
    for i = 2:n
        ap(i) = sum(ap(1:i-1))+f(predictions(i),reals(i))/i;
    end
    map = (1/50)*ap(n);
    p = sum(predictions == reals)/n;
end

function s = f(p,r)
    if p==r
        s = 1;
    else
        s=0;
    end
end