function [wjt, wjx, wjn] = trend(times, energy, windowSize)
global  avgPmax avgPmin
% As sample intervals are irregular, Matlab's smooth() won't do the job
% quite right.
% Very large intervals are a problem not yet addressed explicitly
    dT = diff(times);

    % minWindow = 30;
    % % Target sampling rates are generally 30s or 60s (is this true?)
    % % Try to keep our window size big enough to 
    % sampleInterval = 30;
    % sampleMedian = median(dT);
    % if abs(sampleMedian - 60) < abs(sampleMedian - sampleInterval)
    %     sampleInterval = 60;
    % end
    % 
    % minInterval = 2 * sampleInterval;

    %
    % This must be passed in
   % windowSize = 600;

    slen = length(times);

    idx = 1;
    done = false;

    widx = 1;

    while ~done
        eidx = idx + 1;
        if eidx > slen-1
            break;
        end
        %found = false;
        %try
        % Find indices of timestamps that bracket the called-for interval
        targetTime = times(idx) + windowSize;
        while times(eidx + 1) < targetTime
            eidx = eidx + 1;
            if eidx > slen - 1            
                done = true;
                break;
            end
        end

        if ~done            
            % pick the sample so the interval most closely matches the
            % target interval
            if times(eidx + 1) - targetTime < targetTime - times(eidx)
                eidx = eidx + 1;
            end

            % max, avg, min jps
            dt = times(eidx) - times(idx);
            qe = 3599 / dt;
            jm = 3600*(energy(eidx) - energy(idx)) / dt;            
            jx = jm + qe;
            jn = jm - qe;
%             jx = avgPmax(eidx) - avgPmin(idx);
%             jn = avgPmin(eidx) - avgPmax(idx);
            % midpoint of time window
            jt = round((times(eidx) + times(idx)) / 2);

            % fill our results
            wjx(widx,1) = jx;
            wjn(widx,1) = jn;
            wjt(widx,1) = jt;

            widx = widx + 1;
            idx = idx + 1;
        end
    end
end
            
            
            

        
