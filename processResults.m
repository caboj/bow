exps = { 'experiment11results.mat' 'experiment1results.mat' 'experiment7results.mat' 'experiment8results.mat' 'experiment9results.mat' 'experiment10results.mat'};

map = zeros(4,5);
ks = zeros(5,1);
classes = {'faces' 'cars' 'motorbikes' 'airplanes'};
for i = 1:6
    load(char(exps(i)))
    ks(i) = k;
    for ci = 1:4
        map(ci,i) = MAP(eval(char(classes(ci))));
    end
end