frxnts = evalin('base','frxnts');
fup = evalin('base','fup');
fdown = evalin('base','fdown');
winin = evalin('base','winmin');
winmax = evalin('base','winmax');
J=evalin('base','J');
jx=evalin('base','jx');
jn=evalin('base','jn');
Jxition=evalin('base','Jxition');
power=evalin('base','power');
zt=evalin('base','zt');

% Redraw figure
hold off
axis manual
plot(J,'-b.')
hold on
stairs(zt(1:end-1),jx,'g')
stairs(zt(1:end-1),jn,'r')
fr = find( Jxition ~= 0 );
stem(fr,Jxition(fr),'m*')
plot(zt,power,'r.')

% fup are times of up transition
% fdown are times of downs transitions

valup = Jxition(fup);
valdwn = Jxition(fdown);

box = zeros(2,2);
boxidx=1;
%
% Find off-transitions within the fridge window
for i=1:length(fup)
    sniff = fdown - fup(i);
   % cand(:,i) 
    maybe = sniff>winmin & sniff<winmax;
    if any(maybe)
        % clean fridge up, return to zero
        fm = median(J(fup(i):fdown(maybe))) - (J(fup(i)-1) + J(fdown(maybe)+1))/2;
        if abs(fm - 97) < 10
            rectangle('Position',[fup(i), 0, fdown(maybe) - fup(i), fm],'LineWidth',2,'EdgeColor','r');
            box(boxidx,:) = [fdown(maybe) - fup(i) fup(i)];
            boxidx = boxidx+1;
        end
    end    
end

bdiff = diff(box(:,2));
bclose = bdiff(bdiff < 5700 & bdiff > 2500);
bmean = mean(bclose);
bsi = box(:,1);
bm = mean(bsi);
bmd = median(bsi);
bst = box(:,2);
bd = box(bclose,1);
bdur = mean(bd);


numBspots = floor(length(J) / bmean);
bspots = zeros(numBspots,1);
firstfound = floor(box(1,2)/bmean);

sidx=1;
bidx = 1;

if box(1,2) > bmean
    for i=box(1,2):-bmean:0
        rectangle('Position',[i, 0, bdur, fm],'LineWidth',2,'EdgeColor','g');
    end
end
    
    
%
% Select from candidate transitions within the windows
% Data structure: duration, initiation
fridgetracker = zeros(2,2);
ftidx = 1;
for i=1:length(fup)
    cnt = sum(cand(:,i));
    if cnt == 0
        % no transition, but maybe still a fridge
        continue
    else
        if cnt == 1
            idx = cand(:,i)>0;
            %
            % assume this is a fridge. Track durations for parameterization
            fridgetracker(ftidx, :) = [fdown(idx)-fup(i) fup(i)];
            ftidx = ftidx+1;
%             fduration = fdown(idx)-fup(i);
%             fridgetracker(1) = fridgetracker(1) + fduration;
%             fridgetracker(2) = fridgetracker(2) + 1;
            rectangle('Position',[fup(i), J(fup(i)), fdown(idx)-fup(i), 200],'LineWidth',2,'EdgeColor','m');
            rectangle('Position',[fup(i), J(fup(i)), winmin, 220],'EdgeColor','r');
            rectangle('Position',[fup(i), J(fup(i)), winmax, 180],'EdgeColor','g');
        end
    end
end
assignin('base','ftrack',fridgetracker);
estduration = round(sum(fridgetracker(:,1))/length(fridgetracker(:,1)));

fintervals = diff(fup);
goodintervals = fintervals(find(fintervals>3300 & fintervals < 4340));
estinterval = round(sum(goodintervals)/length(goodintervals))
%estinterval = 3971;
%
% interval variation can be large...
intvar = 660;
% work with intervals
mininterval = estinterval - intvar;%360;
maxinterval = estinterval + intvar;%360;
flen = length(fridgetracker(:,1));
cycleone = fridgetracker(1,2);
detected = fridgetracker(:,2);
targettimes = cycleone:estinterval:length(J)-cycleone;
expectedcycles = length(targettimes);  %~21
tgtidx=1;
for i=1:length(targettimes)
    % should find the detected() *closest* to targettimes
    candidates = abs(detected - targettimes(tgtidx));
    [cval cidx] = min(candidates);
    if candidates(cidx) > intvar%360 %outside our target range
        % look in fup
        candidates = abs(fup - targettimes(tgtidx));
        [cval cidx] = min(candidates);
        % and look in fdown
        dcandidates = abs(fdown - targettimes(tgtidx)-estduration);
        [dcval dcidx] = min(dcandidates);        
        if candidates(cidx) < intvar | dcandidates(dcidx) < intvar %found one
        %if candidates(cidx) < 360 | dcandidates(dcidx) < 360 %found one
            if cval < dcval
                targettimes(tgtidx) = fup(cidx);
            else
                targettimes(tgtidx) = fdown(dcidx) - estduration;
            end
            for j=1:length(targettimes)-tgtidx
                targettimes(tgtidx+j)= targettimes(tgtidx) + j*estinterval;
            end      
        end
        % draw an indication
        rectangle('Position',[targettimes(tgtidx), 135, estduration, 200],'EdgeColor','g','LineWidth',4);
        tgtidx = tgtidx+1;
        continue;
    else
        %adjust predicted targettimes
        targettimes(tgtidx) = detected(cidx);
        for j=1:length(targettimes)-tgtidx
            targettimes(tgtidx+j)= targettimes(tgtidx) + j*estinterval;
        end
        tgtidx = tgtidx+1;
        continue;
    end
end
    


% 
% for i=1:length(fup)
%     cnt = sum(cand(:,i));
%     if cnt > 1
%         approxt = estduration + fup(i);
%         ck = fdown(cand(:,i)) - approxt;%
%      %   [a b] = 
%         eds = abs(fdown.*cand(:,i) - approxt);
%         [best pos] = min(eds);
%         rectangle('Position',[fup(i), J(fup(i)), fdown(pos)-fup(i), 200],'FaceColor','r');
%     end
% end
%     
% 
% 
% % test first xtn
% t1 = fup(2);
% p1 = J(t1);
% p2 = J(t1+1);
% t2 = t1+winmin;
% while  t2<t1+winmax && t2<length(J) && (J(t2)>p1)
%     t2 = t2+1;
% end





