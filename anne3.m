global slist sx sy hx
close all
dE = diff(energy);
dT = diff(times);
% relative time vector, one-indexed
zt = times - times(1) + 1;
% rel time vec for interval display
zti = zt(1:end-1);

slen = length(times);
ilen = slen - 1;

% trendJ
tJ = zeros(zt(end),1);
% interesting interval
touched = false(ilen,1);

qJ = 3600 ./ dT;

xJ = 3600*dE ./dT + qJ;
nJ = 3600*dE ./dT - qJ;

figure('Name','Forest','KeyPressFcn',@kbCallbackForest2)
plot(zt, power, '-b.')
hold on