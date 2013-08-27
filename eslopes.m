i = 1;
reps = zeros(length(energy)-1,1);
zt = times-times(1)+1;
minspan=6;
ze = energy-energy(1);
ft = fittype( 'poly1' );
opts = fitoptions( ft );
xJ = zeros(zt(end),1);
nJ = zeros(zt(end),1);


while i<length(energy)-minspan
    ei = i + minspan;
    notfound = true;
    while ei <= length(ze) && notfound
        evals = ze(i:ei);
        slope = 3600*(ze(ei)-ze(i)) / (zt(ei) - zt(i));
        zit = zt(i:ei) - zt(i)+1;
        appmin = 3600*ze(i) + 0;
        appmax = 3600*ze(i) + 3599;
        amax = slope.*zit + appmax;
        amin = slope.*zit + appmin;
        emins = floor(amin/3600);
        emaxs = floor(amax/3600);
        cn =(evals < emins);
        cx = (evals > emaxs);
        ck = any(cn);
        dk = any(cx);
        if dk | ck
            match = true;
            [xData, yData] = prepareCurveData( zt(i:ei-1), 3600*ze(i:ei-1));
            [fitresult, gof] = fit( xData, yData, ft, opts );   
            ep = fitresult([zt(i) zt(ei-1)]);
            fitslope = (ep(2) - ep(1)) / (zt(ei-1) - zt(i));
            slope = 3600*(ze(ei-1)-ze(i)) / (zt(ei-1) - zt(i));
            %pslope = sum(
            %fitslope = slope;
            
            minlim = appmin;
            maxlim = appmax;
%             fastsearch = 1800;
            espan = evals(1:end-1);
            lowslope = (fitslope*zt(i:ei-1) + minlim)/3600;
            rampmin = floor(lowslope);
            highslope = (fitslope*zt(i:ei-1) + maxlim)/3600;
            rampmax = floor(highslope);
            while any(espan > rampmin) && match
                minlim = minlim+10;
                if minlim > appmax
                    display('no good minlim')
                    match = false;
                    %pause
                end
                lowslope = lowslope + 1;
                rampmin = floor(lowslope);
                %rampmin = floor((fitslope*zt(i:ei-1) + minlim)/3600);
            end
            
            if match
                while any(espan < rampmax) && match
                    maxlim = maxlim-10;
                    if maxlim < minlim
                       % display('no good maxlim')
                        match = false;
                        %pause
                    end
                    highslope = highslope + 1;
                    rampmax = floor(highslope);
                    %rampmax = floor((fitslope*zt(i:ei-1) + maxlim)/3600);
                end   
            end

            if match
                xJ(zt(i):zt(ei-2)) = fitslope;%maxlim / (3600*(zt(ei-1) - zt(i)));%
                nJ(zt(i):zt(ei-2)) = fitslope;%minlim / (3600*(zt(ei-1) - zt(i)));%
            end
            %i = ei
            notfound = false;


            
        else
            ei = ei + 1;
        end
        
        
    end
    i = ei - 1
end

plot(xJ,'-g.')
hold on
plot(nJ,'-r.')
plot(zt,power,'b.')
        