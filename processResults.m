exps = { 'experiment1results.mat' 'experiment15results.mat' 'experiment16results.mat' 'experiment17results.mat'};

map = zeros(4,2);
kernels = {'linear' 'rbf' 'polynomial 3' 'polynomial 4'};
classes = {'faces' 'cars' 'motorbikes' 'airplanes'};
for i = 1:4
    load(char(exps(i)))

    for ci = 1:4
        map(ci,i) = MAP(eval(char(classes(ci))));
    end
end