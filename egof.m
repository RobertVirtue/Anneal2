ft = fittype( 'poly1' );
opts = fitoptions( ft );

span = 20;
egof = zeros(slen,1);
for i=1:slen-span
    [xData, yData] = prepareCurveData( zt(i:i+span-1), energy(i:i+span-1));
    [fitresult, gof] = fit( xData, yData, ft, opts );

    egof(i) = gof.rsquare;
%         dt = zt(eidx) - zt(sidx);
%         de = 3600*(energy(eidx)-energy(sidx)) / dt;
%         equant = 3599 / dt;
%         jmin = de - equant;
%         jmax = de + equant;
% 
%         % check endpoints
%         ep = fitresult([zt(sidx) zt(eidx)]);
end