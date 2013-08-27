global slist sx sy hx jx jn avgPmax avgPmin ph
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

figure('Name','Heir','KeyPressFcn',@kbTrend)
hp = plot(zt, power, '-b.')
hold on
ph(1) = stairs(zti,avgPmax,'g');
ph(2) = stairs(zti,avgPmin,'r');
%pause
  finegrind
  
q=times - times(1);
qq = diff(q);
xq = qq/2 + q(1:end-1);
pd = diff(power);
ph(3) = plot(J,'-c.')

hold on
xpd = pd(xition);
xti = xq(xition);
ptx = find(xpd>0);
pty = find(xpd<0);
stem(xti(ptx),xpd(ptx),'g.')
stem(xti(pty),abs(xpd(pty)),'r.')
plot(zt,power,'b.')
%pause
set(gca,'DrawMode','fast') ;
axis manual

% find minJx minJn for all t
for span = 2:25
    for i=1:slen-span

        dt = times(i+span) - times(i);
        dq = 3599 / dt;
        de = 3600*(energy(i+span)-energy(i)) / dt;
        dex = de + dq;
        den = de - dq;
        
        if ~any(power(i:i+span) > dex) && ~any(power(i:i+span) < den)
            for j=i:i+span - 1
                avgPmax(j) = min(avgPmax(j), dex);
                avgPmin(j) = max(avgPmin(j), den);
            end
        end


      %  drawnow
    end
    delete(ph);
    %clf
    ph(1) = stairs(zti,avgPmax,'g');
    hold on
    ph(2) = stairs(zti,avgPmin,'r'); 
  %  refresh
  clear J
  finergrind
  
q=times - times(1);
qq = diff(q);
xq = qq/2 + q(1:end-1);
pd = diff(power);
ph(3) = plot(J,'-c.')

hold on
xpd = pd(xition);
xti = xq(xition);
ptx = find(xpd>0);
pty = find(xpd<0);
stem(xti(ptx),xpd(ptx),'g.')
stem(xti(pty),abs(xpd(pty)),'r.')
plot(zt,power,'b.')
% if span < 5
%     pause
% end
    span
end

finergrind
% stairs(zti,avgPmax,'m')
% stairs(zti,avgPmin,'c')

                
        



% figure('Name','Heir','KeyPressFcn',@kbTrend)
% hp = plot(zt, power, '-b.')
% hold on
% hx(1) = stairs(zti,avgPmax,'g')
% hx(2) = stairs(zti,avgPmin,'r')
% drawnow
% %pause
% for window = 2:60;
%     for i=1:slen - window
%         tj = zt(i+window) - zt(i);
%         jx(i,window) = 3600*(energy(i+window) - energy(i) + 1) / tj;
%         jn(i,window) = 3600*(energy(i+window) - energy(i) - 1) / tj;
%     end
% end
% %refresh
% axis manual
% ce = cumsum(dE);
% ct = cumsum(dT);
% ax = 3600*(ce+1) ./ct;
% an = 3600*(ce-1) ./ct;
% stairs(zti,ax,'c')
% stairs(zti,an,'m')


