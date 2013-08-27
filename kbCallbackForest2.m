function kbCallbackForest(src, event)
global slist sx sy istart iend fitslope ze hx
        
energy = evalin('base','energy');
power = evalin('base','power');
zt = evalin('base','zt');
ze = energy - energy(1);
switch event.Key
    case 'space'
        if strcmp(event.Modifier,'shift')
            [slist,sx,sy]=selectdata('SelectionMode','Brush','BrushSize',0.05);
            
        else
            if ishandle(hx)
                [slist,sx,sy]=selectdata('SelectionMode','Rect','Ignore',hx);
            else
                [slist,sx,sy]=selectdata('SelectionMode','Rect');
            end
        end

        istart = slist(1);
        iend = slist(end);
        dolines;
    
case 'a'
    if strcmp(event.Modifier,'shift')
        istart = istart + 1;
    else
        istart = istart - 1;
    end
    dolines
case 'd'
    if strcmp(event.Modifier,'shift')
        iend = iend - 1;
    else
        iend = iend + 1;
    end
    dolines

case 'e'
    zz = zt(istart:iend) - zt(istart);
  
    spanE = ze(istart:iend);% - ze(istart);
    %approx0 = energy(istart) + 0.5;
    approxMin = 3600*ze(istart) + 0;
    approxMax = 3600*ze(istart) + 3599;
    amax = fitslope*zz + approxMax;
    amin = fitslope*zz + approxMin;
    rampmax = floor(amax/3600);
    rampmin = floor(amin/3600);
    
    
    
    while sum(rampmax - spanE) > 0
        approxMax = approxMax - 1;
        rampmax = floor((fitslope*zz + approxMax)/3600);
        if sum(any(rampmax < 0))>0
            display('boom');
            pause
        end
    end
    
    while sum(spanE - rampmin ) > 0
        approxMin = approxMin + 1;
        rampmin = floor((fitslope*zz + approxMin)/3600);
    end
    if rampmin > rampmax
        display('rampmin > rampmax');
    end
    
    xdt = zz(end)-zz(1);
    mx = approxMax/3600
    mxend = approxMax + fitslope*xdt
    mnend = approxMin + fitslope*xdt
    dq = approxMax - approxMin
    qmax = (amax(end)-amax(1))/xdt
    qmin = (amin(end)-amin(1))/xdt
    mn = approxMin/3600
    
    emx = mx + fitslope*xdt
    emn = mn + fitslope*xdt
    %(approxMax/xdt + fitslope)/3600
    dx = emx / xdt
    %(amax(end) - amax(1)) / (xdt)
    dn = emn / xdt
    %(amin(end) - amin(1)) / (xdt)
    
    
%     approx = 3600*energy(istart) + 1800;
%     quant = floor((fitslope*zz + approx)/3600);
    
    
%     a(:,1) = fitslope*zz + approx0;
%     ramp(:,1) = floor(a/3600);
    
    figure(999)
    plot(zt(istart:iend),rampmin- 14200,'-r*','LineWidth',2)
    hold on
    plot(zt(istart:iend),rampmax- 14200,'-g.')
    hold on
    plot(zt(istart:iend),spanE- 14200,'b.')
    hold on
    emid = (mx+mn)/2;
    topL = fitslope*zz/3600 + mx;
    midL = fitslope*zz/3600 + emid;
    botL = fitslope*zz/3600 + mn;
    plot(zt(istart:iend),midL- 14200,'m')
    hold on
    plot(zt(istart:iend),topL- 14200,'m')
    hold on
    plot(zt(istart:iend),botL- 14200,'m')
    grid on
    figure(1)
    hold on
    rectangle('Position',[zt(istart) mn zt(iend)-zt(istart) mx-mn],'FaceColor','g');
%     assignin('base','a',a);
%     assignin('base','ramp',ramp);
%     assignin('base','c',c);

end
    
    function dolines
      
        persistent he hp hf
        if ishandle(he)
            delete(he)
        end
%         if ishandle(hp)
%             delete(hp)
%         end
        if ishandle(hf)
            delete(hf)
        end  
        
        dt = zt(iend) - zt(istart);
        de = 3600*(energy(iend)-energy(istart)) / dt;
        equant = 3599 / dt;
        
        jmin = de - equant;
        jmax = de + equant;
        
        %pavg = sum(power(istart:iend)) / (iend - istart+1);
        
        %hp = line([zt(istart) zt(iend)], [pavg pavg], 'Color','g'); 
        
        
        [xData, yData] = prepareCurveData( zt(istart:iend), power(istart:iend));
        ft = fittype( 'poly1' );
        opts = fitoptions( ft );
        [fitresult, gof] = fit( xData, yData, ft, opts );

        tf = zt(istart):zt(iend);
        
        ep = fitresult([zt(istart) zt(iend)])
        jmax - jmin

        
       % r = fitresult(tf);
        pf(zt(istart)+1:zt(iend)+1) = fitresult(tf);
        fitslope = (ep(1)+ep(2))/2;
        %fitslope = sum(pf(zt(istart)+1:zt(iend)+1)) / length(pf);
        %ip = sum(pf(zt(istart)+1:zt(iend)+1)) / length(tf);
       % fitslope = (ep(2)-ep(1)) / (zt(iend)-zt(istart));
        %display([jmin jmax ip])

        if max(ep) > jmax || min(ep) < jmin
            he = rectangle('Position',[zt(istart) jmin dt jmax-jmin],'EdgeColor','m','FaceColor','r');
        else
            he = rectangle('Position',[zt(istart) jmin dt jmax-jmin],'EdgeColor','m');
        end
        hold on
        hf = plot(tf, pf(zt(istart)+1:zt(iend)+1),'k');
        hold on
    end
            
end