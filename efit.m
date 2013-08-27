ft = fittype( 'poly1' );
opts = fitoptions( ft );
sidx = 1;
for span = 5:5:30

for i=1:slen-span-1
    [xData, yData] = prepareCurveData( zt(i:i+span-1), energy(i:i+span-1));
    [fitresult, gof] = fit( xData, yData, ft, opts );

    egof(i,sidx) = gof.sse;%rsquare;
    % sse
    % rmse
%         dt = zt(eidx) - zt(sidx);
%         de = 3600*(energy(eidx)-energy(sidx)) / dt;
%         equant = 3599 / dt;
%         jmin = de - equant;
%         jmax = de + equant;
% 
%         % check endpoints
%         ep = fitresult([zt(sidx) zt(eidx)]);
end
sidx = sidx+1;
end