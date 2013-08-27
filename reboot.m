clear vv Txp Txn Tx
dE = diff(energy);
dT = diff(times);
zt = times - times(1);
slen = length(times);
ilen = length(dT);
%
% Inital bounds on interval energy are
% established by truncation quantization
quantJ = 3600    ./dT;
jmax   = 3600*dE ./dT + quantJ;
jmin   = 3600*dE ./dT - quantJ;

peak = 350;%max(power);

highvar = false(slen,1);
% 
% for i=2:slen-1
%     vv(i) = var(power(i-1:i+1));
%     if vv(i) > peak
%         vv(i) = peak*2;
%         highvar(i) =true;
%     end
% end
% figure(1)
% plot(zt,power,'-b.')
% hold on
%Tx = zeros(ilen,1);
%Tt = zeros(ilen,1);

dP = diff(power);
idx = 1;
tidx = 1;
while idx < ilen
    Tx(tidx) = dP(idx);
    Tt(tidx) = zt(idx);
    if dP(idx) < 0        
        while idx < ilen-1 && dP(idx+1)<0
            idx = idx+1;
            Tx(tidx) = Tx(tidx)+dP(idx);
        end
    else
        while idx < ilen-1 && dP(idx+1)>0
            idx = idx+1;
            Tx(tidx) = Tx(tidx)+dP(idx);
        end
    end
    tidx = tidx+1;
    idx = idx + 1;
end

pidx=1;
nidx=1;
for i=1:length(Tx)
    if Tx(i) > -150 && Tx(i)<150
        Tx(i)=0;
    end
    if Tx(i) < 0 
        Txn(nidx) = Tx(i);
        nidx = nidx+1;
    end
    if Tx(i) > 0 
        Txp(pidx) = Tx(i);
        pidx=pidx+1;
    end
end
figure(1)
plot(zt(1:end-1),dP,'-b.'),hold on,plot(Tt,Tx,'-r.')

L = logical(Tx);
nonztx = Tx(L);
nonztt = Tt(L);

atx = abs(nonztx);
figure(2)
sc = 0:100:7000;
sn = -6000:100:0;
hist(atx, sc)
figure(3)
AxesHandle(1) = subplot(2,1,1)
hist(Txp,sc)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','g','EdgeColor','w')
AxesHandle(2) = subplot(2,1,2)
pp=abs(Txn);
hist(pp,sc)
h = findobj(gca,'Type','patch');
set(h,'FaceColor','r','EdgeColor','w')

allYLim = get(AxesHandle, {'YLim'});
allYLim = cat(2, allYLim{:});
set(AxesHandle, 'YLim', [min(allYLim), max(allYLim)]);

sum(Txp)
sum(Txn)

figure(666)
plot(times(2:end),dP,'-b.'),hold on,plot(times,power,'r')
%hist(Txn,sn)
%     if dP(i) > 80 && dP(i) < 120
%         rectangle('Position',[zt(i) power(i) zt(i+1)-zt(i) 300],'FaceColor','g');
%     end
%     if dP(i) < -70 && dP(i) > -120
%         rectangle('Position',[zt(i) power(i+1) zt(i+1)-zt(i) 300],'FaceColor','r');
%     end
%     if dP(i) > 1500 && dP(i) < 3250
%         rectangle('Position',[zt(i) power(i) zt(i+1)-zt(i) 2000],'FaceColor','g');
%     end
%     if dP(i) < -1500 && dP(i) > -3250
%         rectangle('Position',[zt(i) power(i+1) zt(i+1)-zt(i) 2000],'FaceColor','r');
%     end    
% end
% for i=1:ilen
%     vo(i) = var(power(i:i+1));
%     
%     if vo(i) > peak
%         vo(i) = peak*2;
%     end
% end
% 
% figure(2)
% hold on
% %tidx = 2;
% sidx = 2;
% tend = length(highvar)-1;
% tidx = 2;
% while tidx < tend
%     while (highvar(tidx+1) == highvar(tidx)) && tidx < tend
%         tidx = tidx + 1;
%     end
%     if tidx < tend
%         eidx = tidx-1;
%         ij = (energy(eidx) - energy(sidx) + 0.5)*3600 / (zt(eidx) - zt(sidx));
%         rectangle('Position',[sidx 0 eidx-sidx ij],'FaceColor','c');
%         sidx = tidx;
%     end
%     tidx = tidx + 1;
% end
    
% plot(zt,power,'-b.')
% hold on 
% off = median(power);
% amp = max(power)-min(power);
% ssmax = max(stderr);
% scaled = stderr * amp / ssmax;
% plot(zt(2:end-1),scaled+off,'-r.')


% plot(v,'-b.')
% hold on
% stairs(vv,'-r.')
% hold on
% plot(power,'-g.')
% hold on
% plot(vv,'-r.')

% hold on
% stairs(vv(:,3),'b')

