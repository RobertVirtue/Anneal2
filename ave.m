clf
clear ae ap aet
zt=times-times(1);
de =energy - energy(1);
dde=3600*diff(de)./diff(zt);
figure(1) 
span = 5
sp=smooth(dde,span);
plot(zt(736:848),power(736:848),'-b.')
hold on
plot(zt(736:848),sp(736:848),'-r.')



    