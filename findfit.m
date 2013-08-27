function [ep, jmin, jmax] = findfit(sidx, eidx)
zt = evalin('base','zt');
energy = evalin('base','energy');
power = evalin('base','power');
    ft = fittype( 'poly1' );
    opts = fitoptions( ft );
    [xData, yData] = prepareCurveData( zt(sidx:eidx), power(sidx:eidx));
    [fitresult, gof] = fit( xData, yData, ft, opts );
        % find energy 'trend'
    dt = zt(eidx) - zt(sidx);
    de = 3600*(energy(eidx)-energy(sidx)) / dt;
    equant = 3599 / dt;
    jmin = de - equant;
    jmax = de + equant;

    % check endpoints
    ep = fitresult([zt(sidx) zt(eidx)]);
end