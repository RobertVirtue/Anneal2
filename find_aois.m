function aois = find_aois(areas, intervalSize, interval, times, power)
    seenArea = false;
    lastTrans = 1;    
    startIdx = 1;
    aois = zeros(length(areas(:, 1)), 7);
    numAreas = 0;
    for areaIdx = 1:length(areas(:, 1))
        area = areas(areaIdx, :);
        for i = area(6):area(7)
            if (seenArea)
                if (times(i) - times(lastTrans) <= intervalSize)
                    if (interval(i, 1) == 1 || interval(i, 1) == 2)
                        lastTrans = i;
                    end
                else
                    seenArea = false;
                    rectY = min(power(startIdx:(i-1)));
                    aois(numAreas, :) = [times(startIdx) ...
                                         rectY ...
                                         times(i - 1) - times(startIdx) ...
                                         max(power(startIdx:i-1)) - rectY ...
                                         countTransitions(startIdx, i-1, interval) ...
                                         startIdx ...
                                         i - 1;];
                    rectangle('Position', aois(numAreas, 1:4));
                    startIdx = i;
                end
            elseif (countTransitions(i, i, interval) > 0)
                seenArea = true;
                startIdx  = i;
                lastTrans = i;
                numAreas = numAreas + 1;
            end
        end
    end
    
    aois = aois(1:numAreas, :);
end

function t = countTransitions(s, e, interval)
    t = sum(1 == interval(s:e)) + sum(2 == interval(s:e));
end
    
        
        