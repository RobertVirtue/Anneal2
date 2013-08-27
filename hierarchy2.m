global slist sx sy hx jx jn
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
% touched = false(ilen,1);

quantJ = 3600 ./ dT;

avgPmax = 3600*dE ./dT + quantJ;
avgPmin = 3600*dE ./dT - quantJ;



figure('Name','Heir','KeyPressFcn',@kbCallbackForest3)
hp = plot(zt, power, '-b.')
hold on
hx(1) = stairs(zti,avgPmax,'g')
hx(2) = stairs(zti,avgPmin,'r')
drawnow
%pause
for window = 2:60;
    for i=1:slen - window
        tj = zt(i+window) - zt(i);
        jx(i,window) = 3600*(energy(i+window) - energy(i) + 1) / tj;
        jn(i,window) = 3600*(energy(i+window) - energy(i) - 1) / tj;
    end
end
%refresh
axis manual
% ce = cumsum(dE);
% ct = cumsum(dT);
% ax = 3600*(ce+1) ./ct;
% an = 3600*(ce-1) ./ct;
% stairs(zti,ax,'c')
% stairs(zti,an,'m')


