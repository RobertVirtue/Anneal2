clear wrkJ cJ zJ
wrkJ = J - min(J);
cJ = wrkJ > 15;
iz = ~cJ;
zJ = zeros(length(J),1);
zJ = wrkJ.*cJ;
plot(zJ,'-b.');
aj = abs(diff(J));
hold on,
plot(aj,'r')

fz = find(zJ == 0,1,'first');
ez = find(zJ == 0,1,'last');
rectangle('Position',[fz, 0,ez-fz+1,600]);
tj = zJ(fz:ez);
fp = find(tj>0,1,'first')+fz;
ep = find(tj>0,1,'last')+fz;
rectangle('Position',[fp, 0,ep-fp+1,600],'EdgeColor','m');


frg = find(aj>80 & aj < 120);

stem(frg,200*ones(length(frg),1),'g')