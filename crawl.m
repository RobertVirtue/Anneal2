dE = diff(energy);
dT = diff(times);
% relative sample time vector, one-indexed
zt = times - times(1) + 1;
% for interval stairs
zti = zt(1:end-1);
% relative interval time centre, wrt zt
ztc = zti + diff(zt)/2;
% sample length
slen = length(power);
% interval length
ilen = slen - 1;

% prepare to pick off big transitions
jdE = 3600*dE;% - power(2:end);
qj = 3599 ./ dT;

jx = jdE ./ dT + qj;
jn = jdE ./ dT - qj;

xition = zeros(ilen,1);
% first, flag any existing transitions
for i = 1:ilen
    maxp = max(power(i),power(i+1));
    minp = min(power(i),power(i+1));
    if ~( (minp > jn(i)) && (minp < jx(i)) && (maxp < jx(i)) && (maxp > jn(i)) )
        xition(i) = power(i+1) - power(i);
    end
    % add this cheat in here for fridges until regressionFit is complete
    if maxp - minp > 80
        xition(i) = power(i+1) - power(i);
    end
end
    
%
% Method One: Improves EnergySpace but not TransitionSpace
%
% reduce qJ so long as all power samples are within average power
% quantization limits
for span = 2:250  % 25 sample span is completely arbitrary
    for i = 1:slen - span
        dt = times(i+span) - times(i);
        dq = 3599 / dt;
        de = 3600*(energy(i+span)-energy(i)) / dt;
        dex = de + dq;
        den = de - dq;
        %if ~any(power(i:i+span) > dex + dq) && ~any(power(i:i+span) < den - dq) & ~any(xition(i:i+span-1))
        if ~any(power(i:i+span) > dex ) && ~any(power(i:i+span) < den ) & ~any(xition(i:i+span-1))
            for j=i:i+span - 1
                jx(j) = min(jx(j), dex);
                jn(j) = max(jn(j), den);
            end
        end
    end
end

xitiongrind
%grind
xidx = find(xition ~= 0);
xvals = xition(xidx);

figure('Name','Forest','KeyPressFcn',@kbFridge)
% plot(zt, power, '-b.')
% hold on
plot(J,'-b.')
hold on
stairs(zt(1:end-1),jx,'g')
stairs(zt(1:end-1),jn,'r')
fr = find( Jxition ~= 0 );
stem(fr,Jxition(fr),'m*')
plot(zt,power,'r.')
% returnfraction = 0.1;
% 
% [mval midx] = max(xvals);
% pstart = power(midx);
% sumXition = xition(midx);
% pslop = xition(midx) * returnfraction;
% eidx = midx + 1;
% % checks
% %sumXition = sumXition + 
% fxition = abs(xition(midx)+xition(eidx)) < pslop;
% flevel = power(eidx+1) < pstart;

% plot(zt, power, '-b.')
% hold on
% stairs(zti,jx,'-g.')
% stairs(zti,jn,'-r.')
% stem(ztc,xition,'m.')