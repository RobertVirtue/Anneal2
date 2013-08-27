global slist sx sy hx
close all
dE = diff(energy);
dT = diff(times);
% relative time vector, one-indexed
zt = times - times(1) + 1;
% rel time vec for interval display
zti = zt(1:end-1);

slen = length(times);
ilen = slen - 1;

% trendJ
tJ = zeros(zt(end),1);
% interesting interval
touched = false(ilen,1);

qJ = 3600 ./ dT;

xJ = 3600*dE ./dT + qJ;
nJ = 3600*dE ./dT - qJ;

figure('Name','Forest','KeyPressFcn',@kbCallbackForest2)
plot(zt, power, '-b.')
hold on

%ihandle = 1;
%flag intervals using one-interval quantization
for i=1:ilen
    maxp = max(power(i),power(i+1));
    minp = min(power(i),power(i+1));
    if ~( (minp > nJ(i)) && (minp < xJ(i)) && (maxp < xJ(i)) && (maxp > nJ(i)) )
%         display('.')
%     else
        touched(i) = true;

       % rectangle('Position',[zt(i) minp zt(i+1)-zt(i) maxp-minp],'FaceColor','k');
        %ihandle = ihandle + 1;
    end
end

hx(1) = stairs(zti,xJ,'g');
hold on
hx(2) = stairs(zti,nJ,'r');
hold on
%pause

%
% max p==p+1
try
    idx = 1;
    pp = zeros(ilen,1);
    %
    % find long stretches of sequential identical power
    while idx < ilen
        if power(idx) == power(idx+1)
            sidx = idx;
            pp(sidx) = 1;
            idx = idx + 1;
            while power(idx) == power(idx+1)
                pp(sidx) = pp(sidx) + 1;
                idx = idx + 1;
            end                
        else
            idx = idx + 1;
        end
    end
catch exception
    if ~(strcmp(exception.identifier,'MATLAB:badsubscript'))
        rethrow(exception);
    end
end

ft = fittype( 'poly1' );
opts = fitoptions( ft );

while max(pp) > 0
    pk = max(pp);
    pks = find(pp == pk);

    for i=1:length(pks)
        % select equal power sequence
        istart = pks(i);
        iend = istart + pk;

        % A missed spike or long dT might have spoiled this sequence.
        % Mop it up later
        if any(touched(istart:iend))
            pp(pks(i)) = 0;
            continue;
        end
        
        tryLeft = true;
        tryRight = true;
        while tryLeft || tryRight
            % if we peg out to the right ...
            if iend == ilen
                tryRight = false;
                slopeR = Inf;
            end
            if tryRight
                slopeR = Inf;
                % Interval already touched
                if touched(iend + 1)
                    tryRight = false;
                else
                    % new fit
                    [epR, jminR, jmaxR] = findfit(istart, iend + 1);
                    % linear assumption 'valid' if fit endpoints lie within range
                    % can't grind unless powers also lie within range
                    if epR(1) == epR(2)
                        display(['Zero!' i]);
                    end
                    if max(epR) < jmaxR+20 && min(epR) > jminR-20
                    %if max(max(epR), max(power(istart:iend+1)) ) < jmaxR  && min(min(epR),min(power(istart:iend+1))) > jminR
                        slopeR = abs( (epR(2)-epR(1)) / (zt(iend+1) - zt(istart)) );
                    else
                        tryRight = false;
                    end
                end
            end
            % if we peg out to the left ...
            if istart == 1
                tryLeft = false;
                slopeL = Inf;
            end
            if tryLeft
                slopeL = Inf;
                % Interval already touched
                if touched(istart - 1)
                    tryLeft = false;
                else                
                    [epL, jminL, jmaxL] = findfit(istart - 1, iend);
                    if epL(1) == epL(2)
                        display('Zero!');
                    end
                    %if max(max(epL), max(power(istart:iend+1)) ) < jmaxL  && min(min(epL),min(power(istart:iend+1))) > jminL
                    if max(epL) < jmaxL+20 && min(epL) > jminL-20
                        slopeL = abs( (epL(2)-epL(1)) / (zt(iend) - zt(istart-1)) );
                    else
                        tryLeft = false;
                    end
                end                                        
            end

            if ~isinf(slopeR) && abs(slopeR) == abs(slopeL)
                iend = iend + 1;
                istart = istart - 1;
            end
            if tryRight && abs(slopeR) < abs(slopeL)
                iend = iend + 1;
            end
            if tryLeft && abs(slopeL) < abs(slopeR)
                istart = istart - 1;
            end
        end % done with this particular 'peak' of flatness

        [ep, jmin, jmax] = findfit(istart, iend);
        xJ(istart:iend-1) = min(jmax,xJ(istart:iend-1));
        nJ(istart:iend-1) = max(jmin,nJ(istart:iend-1));
        % done this one
        pp(pks(i)) = 0;
    end
end

stairs(zti,xJ,'c')
hold on
stairs(zti,nJ,'m')
    % congruent?
  %  if max(ep) > jmax || min(ep) < jmin    
        
%end

% figure(2)
% plot(pp,'-b.')
    
% 
% ft = fittype( 'poly1' );
% opts = fitoptions( ft );
% 
% iend = 3;
% istart = 1;
% %find first non-flagged interval
% 
% try
% iint = 1;
% 
% while iend < slen
%     while intint(iint) || intint(iint+1)
%         iint = iint + 1;
%     end
%     istart = iint;
%     iend = istart + 2;
%     % find power trend
%     [xData, yData] = prepareCurveData( zt(istart:iend), power(istart:iend));
%     [fitresult, gof] = fit( xData, yData, ft, opts );
% 
%     % find energy 'trend'
%     dt = zt(iend) - zt(istart);
%     de = 3600*(energy(iend)-energy(istart)) / dt;
%     equant = 3599 / dt;
%     jmin = de - equant;
%     jmax = de + equant;
% 
%     % check endpoints
%     ep = fitresult([zt(istart) zt(iend)]);
%     % congruent?
%     if max(ep) > jmax || min(ep) < jmin
%         % no good.
%         % were we good?
%         if iend - istart > 2
%             iend = iend - 1;
%             dt = zt(iend) - zt(istart);
%             de = 3600*(energy(iend)-energy(istart)) / dt;
%             equant = 3599 / dt;
%             jmin = de - equant;
%             jmax = de + equant;
%             % adjust limits
%             avgPmax(istart:iend) = jmax;
%             avgPmin(istart:iend) = jmin;
%             % re-get good fit
%             [xData, yData] = prepareCurveData( zt(istart:iend), power(istart:iend));
%             [fitresult, gof] = fit( xData, yData, ft, opts );
%             % fill tJ
%             tJ(zt(istart):zt(iend)) = fitresult(zt(istart):zt(iend));
%             hold on
%             plot(zt(istart):zt(iend),tJ(zt(istart):zt(iend)))
%             % flag interval to be of interest
%             intint(iend) = true;
%             % skip intint and continue
%             iend = iend + 3;
%             istart = iend - 2;
%         else
%             % single step
%             iend = iend + 1;
%             istart = iend - 2;
%         end
%     else
%         % Still a good fit, continue stretch
%         iend = iend + 1;
%     end
% end
% 
% catch exception
%     if ~(strcmp(exception.identifier,'MATLAB:badsubscript'))
%         rethrow(exception);
%     end
% end
% hold on
% hx(3) = stairs(zti,avgPmax,'k');
% hold on
% hx(4) = stairs(zti,avgPmin,'c');
% hold on
% plot(tJ,'-b.')


    
    
    
    
    
    
    
    
    
    