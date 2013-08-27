function kbCallbackForest(src, event)
global slist sx sy istart iend fitslope ze hx jx jn avgPmax avgPmin
        
energy = evalin('base','energy');
power = evalin('base','power');
times = evalin('base','times');
zt = evalin('base','zt');
ze = energy - energy(1);
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
    
    function dolines
        persistent curt trect jplot
        % istart: the index of the first selected sample
        % iend: index last selected sample 
        
        %tt = times(istart:iend);
        tt = zt(istart:iend);
        te = energy(istart:iend);
        tspan = zt(iend)-zt(istart);
        bott = min(power);
        for w=120:120:1880%(tspan/2)
            [wjt, wjx, wjn] = trend(tt, te, w);
            if ishandle(curt)
                delete(curt)
            end
            if ishandle(jplot)
                delete(jplot)
            end            
            if ishandle(trect)
                delete(trect)
            end
            hold on
            [mval, mind] = max(wjx);
            curt = plot(gca,wjt,wjx,'-r.')
            trect = rectangle('Position',[zt(mind-w/30) bott zt(mind+w/30)-zt(mind-w/30) mval-bott],'EdgeColor','m');
            clear wjt wjx wjn
            [jt,jj] = Jtrend(zt(istart),zt(iend),w);
            jplot = plot(gca,jt,jj,'-g.')
            pause
        end
        
        
    end
            
end



















