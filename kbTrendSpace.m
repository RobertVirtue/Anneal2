function kbCallbackForest(src, event)
global slist sx sy istart iend fitslope ze hx jx jn
        
energy = evalin('base','energy');
power = evalin('base','power');
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
      
        % istart: the index of the first selected sample
        % iend: index last selected sample 
        
        dt = zt(iend) - zt(istart);
        halftime = dt / 2;
        
        % determine sizing for time-based intervals (vs sample count based
        % intervals)
        lhs = (zt(istart:iend) < zt(istart) + halftime);
        cntlhs = sum(lhs);
        cntrhs = iend - istart - cntlhs + 1;
        %construct padded sample
        lpad = ones(cntlhs,1)*power(istart);
        rpad = ones(cntrhs,1)*power(iend);
        newpwr = [lpad; power(istart:iend); rpad];
        
        % now make time series for newpwr 
        newt = zeros(length(newpwr),1);
        newt(1:cntlhs,1) = zt(istart:istart+cntlhs-1)-halftime;
        newt(cntlhs+1:length(slist)+cntlhs,1) = zt(istart:iend);
        newt(length(slist)+cntlhs + 1:end,1) = zt(istart+cntlhs:iend)+halftime;

        display('trap')
        
        figure(2)
        plot(zt(istart:iend),power(istart:iend),'r*')
        hold on
        plot(newt,newpwr,'-b.')
        
        slen = length(newt);
        
        
    end
            
end



















