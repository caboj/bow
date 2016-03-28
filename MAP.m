function [map,p] = MAP(resStruct)
    reals = resStruct.reals;
    predictions = resStruct.labels;
    
    n = size(predictions,1);
    map = 0;
    c = 0;
    for i = 1:n
        ci = f(predictions(i),reals(i));
        if ci == 1
            c = c + 1;
            map = map +c/i;
        end
    end
    map = map/50;
    p = sum(predictions == reals)/n;
end

function s = f(p,r)
    if p==1 && r==1 
        s = 1;
    else
        s=0;
    end
end