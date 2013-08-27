dE = diff(energy);
dT = diff(times);

sampleInterval = 30;
sampleMedian = median(dT);
if abs(sampleMedian - 60) < abs(sampleMedian - sampleInterval)
    sampleInterval = 60;
end

minInterval = 2 * sampleInterval;

% arbitrary window max of one hour
maxInterval = 3600;

% relative time vector, one-indexed
zt = times - times(1) + 1;
% rel time vec for interval display
zti = zt(1:end-1);

slen = length(times);
ilen = slen - 1;

% trendJ
tJ = zeros(zt(end),1);
% interesting interval
% touched = false(ilen,1);

quantJ = 3600 ./ dT;

avgPmax = 3600*dE ./dT + quantJ;
avgPmin = 3600*dE ./dT - quantJ;



figure('Name','TrendSpace','KeyPressFcn',@kbTrendSpace)
hp = plot(zt, power, '-b.')
hold on