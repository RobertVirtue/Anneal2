 idx = 0
 for span=3:2:23
%     span
     idx = idx + 1;
% jm(:,idx) = smooth(avgPmax,span);
% jl1(:,idx) = smooth(avgPmax,span,'lowess');
% loess ignores outliers
  jl2x(:,idx) = smooth(xJ,span,'loess');
  jl2n(:,idx) = smooth(nJ,span,'loess');
  jl2(:,idx) = (jl2x(:,idx) + jl2n(:,idx))/2;
%  jrl1(:,idx) = smooth(avgPmax,span,'rlowess');
  jrl2x(:,idx) = smooth(xJ,span,'rloess');
  jrl2n(:,idx) = smooth(nJ,span,'rloess');
  jrl2(:,idx) = (jrl2x(:,idx) + jrl2n(:,idx))/2;
%  jg1(:,idx) = smooth(avgPmax,'sgolay',1);
% % jg2 = smooth(J,'sgolay',2);
% % jg3 = smooth(J,'sgolay',3);
% 
 end

q=times - times(1);
qq = diff(q);
xq = qq/2 + q(1:end-1);
pd = diff(power);
plot(J,'-c.')

hold on
xpd = pd(xition);
xti = xq(xition);
ptx = find(xpd>0);
pty = find(xpd<0);
stem(xti(ptx),xpd(ptx),'g.')
stem(xti(pty),abs(xpd(pty)),'r.')
plot(zt,power,'b.')
%pause
axis manual
for j=1:idx
    j   
   %h(2) = plot(zti,jm(:,j),'-r.')
   % h(2) = plot(zti,jl1(:,j),'-g.')
  % j2diff(:,1) = jl2(:,j) - jrl2(:,j)
    h(1) = plot(midIntervalTime,jl2(:,j),'-m.');

   % h(4) = plot(zti,jrl1(:,j),'-m.')
    h(2) = plot(midIntervalTime,jrl2(:,j),'-r.');
    %h(3) = plot(midIntervalTime,jl2(:,j) - jrl2(:,j),'k')
    h(3) = plot(midIntervalTime,(jl2(:,j) + jrl2(:,j))/2,'g')
   % h(3) = stem(zti(xition),pd(xition),'-r.');
    %h(7) = plot(zti,jg1(:,j),'-k.')
    pause
    
    if j~=idx
        delete(h);
    end
end

