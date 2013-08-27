function kbCallbackForest(src, event)
global slist sx sy istart iend
        
energy = evalin('base','energy');
power = evalin('base','power');
zt = evalin('base','zt');
switch event.Key
    case 'space'
        if strcmp(event.Modifier,'shift')
            [slist,sx,sy]=selectdata('SelectionMode','Brush','BrushSize',0.05);
            
        else
            [slist,sx,sy]=selectdata('SelectionMode','Rect');
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
end
% case 'e'
%     
% end
    
    function dolines
      
        persistent he hp hf
        if ishandle(he)
            delete(he)
        end
        if ishandle(hp)
            delete(hp)
        end
        if ishandle(hf)
            delete(hf)
        end  
        de = energy(iend)-energy(istart);
        dt = zt(iend) - zt(istart);
        jmin = 3600*(de-1)/dt;
        jmax = 3600*(de+1)/dt;
        javg = 3600*de/dt;
        pavg = sum(power(istart:iend)) / (iend - istart+1);
        he = rectangle('Position',[zt(istart) jmin dt jmax-jmin],'EdgeColor','m');
        hp = line([zt(istart) zt(iend)], [pavg pavg], 'Color','g'); 
        
        jmax - jmin
        
        [xData, yData] = prepareCurveData( zt(istart:iend), power(istart:iend));
        ft = fittype( 'poly1' );
        opts = fitoptions( ft );
        [fitresult, gof] = fit( xData, yData, ft, opts );

        tf = zt(istart):zt(iend);

        
       % r = fitresult(tf);
        pf(zt(istart)+1:zt(iend)+1) = fitresult(tf);
        
        ip = sum(pf(zt(istart)+1:zt(iend)+1)) / length(tf);
        display([jmin jmax ip])
        hold on
        hf = plot(tf, pf(zt(istart)+1:zt(iend)+1),'r');
    end
            
end