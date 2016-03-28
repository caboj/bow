exps = { 'experiment1results.mat' 'experiment2results.mat' 'experiment3results.mat' 'experiment4results.mat' 'experiment6results.mat'};

map = zeros(4,5);
spaces = {};
classes = {'faces' 'cars' 'motorbikes' 'airplanes'};
for i = 1:5
    load(char(exps(i)))
    spaces(i) = { colorSpace};
    for ci = 1:4
        map(ci,i) = MAP(eval(char(classes(ci))));
    end
end