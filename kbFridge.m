function kbFridge(src,event)
persistent maxpos minpos highneg lowneg hs winmin winmax bulk choice intervalmin intervalmax
if isempty(maxpos)
    maxpos = 0;
    minpos = 0;
    highneg = 0;
    lowneg = 0;
    winmax = 0;
    winmin = 0;
    bulk = 0;
    choice = 1;
end
power = evalin('base','power');
Jxition = evalin('base','Jxition');
xidx = evalin('base','xidx');
xvals = evalin('base','xvals');
ztc = evalin('base','ztc');
zt = evalin('base','zt');

switch event.Key
    case 'f'
        if strcmp(event.Modifier,'shift')
            cleanfridge
        else
            choice = 1;
            maxpos = 135;
            minpos = 80;
            highneg = -75;
            lowneg = -110;
            winmax = 1920;
            winmin = 1205;%1355;
            intervalmin = 3850;
            intervalmax = 4200;
            bulk = 80;    
        end
    case 'uparrow'
        if strcmp(event.Modifier,'shift')
            maxpos = maxpos - 5
        else
            maxpos = maxpos + 5
        end
    case 'downarrow'
        if strcmp(event.Modifier,'shift')
            minpos = minpos - 5
        else
            minpos = minpos + 5
        end        
    case 'leftarrow'
        if strcmp(event.Modifier,'shift')
            highneg = highneg - 5
        else
            highneg = highneg + 5
        end
    case 'rightarrow'
        if strcmp(event.Modifier,'shift')
            lowneg = lowneg - 5
        else
            lowneg = lowneg + 5
        end    
    case 'a'
        if strcmp(event.Modifier,'shift')
            winmin = winmin - 5
        else
            winmin = winmin + 5
        end 
    case 'd'
        if strcmp(event.Modifier,'shift')
            winmax = winmax - 5
        else
            winmax = winmax + 5
        end         
end

fup = find((Jxition > minpos) & (Jxition < maxpos));
fdown = find((Jxition < highneg) & (Jxition > lowneg));
fr = find( ((Jxition > minpos) & (Jxition < maxpos)) | (Jxition < highneg & Jxition > lowneg) );
assignin('base','fup', fup);
assignin('base','fdown', fdown);
assignin('base','frxnts', fr);
assignin('base','winmax', winmax);
assignin('base','winmin', winmin);
% for iu = 1:length(fup)
%     ts = ztc(fup(iu));
%     
%     spanmin = 

if ishandle(hs)
    delete(hs)
end
hs(1) = stem(gca,fup,Jxition(fup),'g.');
hs(2) = stem(gca,fdown,Jxition(fdown),'r.');
hs(3) = line([1 zt(end)], [minpos minpos],'LineStyle', ':','Color','g');
hs(4) = line([1 zt(end)], [maxpos maxpos],'LineStyle', '--','Color','g');
hs(5) = line([1 zt(end)], [highneg highneg],'LineStyle', ':','Color','r');
hs(6) = line([1 zt(end)], [lowneg lowneg],'LineStyle', '--','Color','r');
%hs(7) = line([1 zt(end)], [highneg highneg],'LineStyle', ':','Color','r');
%hs(8) = line([1 zt(end)], [lowneg lowneg],'LineStyle', '--','Color','r');
%


% ptimes = diff(ztc(fup));
% ntimes = diff(ztc(fdown));
% pmed = median(ptimes);
% nmed = median(ntimes);
% predpos = ztc(fup) + pmed;
% %predneg = ztc(fup)
% amp = median(xition(fup))*ones(length(predpos),1);
% 
% hs(3) = stem(gca,predpos,amp,'m.');

