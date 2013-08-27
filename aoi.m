% mark areas of interest. Needs uber.m

areas = cell(5, 1);
areas{1} = [times(1) 0 0 0 0 1 length(dT)];
for i = 2:5
    disp(int64(1800/(i - 1)));
    areas{i} = find_aois(areas{i - 1}, int64(1800/(i - 1)), interval, times, power);
end