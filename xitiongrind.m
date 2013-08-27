% To clamp negative excursions
lowestPower = min(power);

numSecs = times(end) - times(1) + 1;  % inclusive
rects   = zeros(ilen,4);
J       = zeros(numSecs,1);
Jxition = zeros(numSecs,1);

idxJ = 1;
iRect = 1;
its = 1;
for i = 1:ilen
    % 
    % Stash the power reading
    J(idxJ) = power(i);
    idxJ = idxJ + 1;

    %
    % One second interval would be a problem
    if dT(i) == 1
        continue;
    end
    %
    % fillTime is the number of seconds between power() stamps
    fillTime = dT(i) - 1;
    
    %
    % Find range of Joules per second (jps) for the interval due to 
    % quantization. Don't count the J already accounted for in power(i+1)   
%     jpsmax = ((energy(i+1)-energy(i) +1)*3600 - power(i+1)) / fillTime;
%     jpsmin = ((energy(i+1)-energy(i) -1)*3600 - power(i+1)) / fillTime;
    jpsmax = jx(i);
    jpsmin = jn(i);
    %
    % Mitigate error by choosing the mid-range jps as default
    jpsp = (jpsmax + jpsmin) / 2;
    
    maxp = max(power(i),power(i+1));
    minp = min(power(i),power(i+1));
    % 
    % Energy indicates average 'power' (ie jps) for an interval lies somewhere
    % in the range [jpsmin jpsmax].
    % If both stamped power readings lie within that range, the first
    % approximation is linear
    if  (maxp <= jpsmax) && (minp >= jpsmin) && ~xition(i)
        slope = (power(i+1) - power(i)) / dT(i);
        x = 1:fillTime;
        % idxJ already points at the first interval second, 
        % so the span is fillTime - 1
        J(idxJ:idxJ + fillTime - 1) = slope * x + power(i);
        % point past filled values
        idxJ = idxJ + fillTime;   
         
    else
        % 
        % If both power readings are cleanly above or below
        % the jps quantization band, one or more pulses have been
        % missed by the power sampling.
        %
        % Predicting the shape and number of pulses can benefit from
        % activity in the 'neighbourhood' and other factors, so for the
        % first pass we flag and fill as a linear spike
        if (( (power(i) > jpsmax) && (power(i+1) > jpsmax) ) || ...
            ( (power(i) < jpsmin) && (power(i+1) < jpsmin) ) )

            slope = (power(i+1) - power(i)) / dT(i);
            x = 1:fillTime;

            %
            % Add best-guess offset
            testLine = slope * x + power(i);
            % energy in the interval excludes power(i+1)
            adjustJ = (jpsp*(fillTime+1)-power(i+1)) / fillTime;
            comp = adjustJ - sum(testLine) / length(testLine);
            testLine = testLine + comp;
            
            Jxition(idxJ) = comp;
            Jxition(idxJ + fillTime-1) = -comp;
            J(idxJ:idxJ+fillTime - 1) = testLine;
            idxJ = idxJ + fillTime;

        else
            % Transition
            %
            % A 'spike' could still appear here due to quantization.
            % that is, jpsp might exceed pmax or be below pmin, while
            % values for jpsp closer to jpsmax or jpsmin clamp the waveform
            % to pmin <= val <= pmax ... thereby reducing 'noise' (that
            % could well be signal, but we can't tell)
            %pmax = max(power(i),power(i+1));
            %pmin = min(power(i),power(i+1));
            jpsp = max(jpsp, minp);
            jpsp = min(jpsp, maxp);
            pdiff = maxp - minp;
            % find excess over pmin being constant
            leftIdx = idxJ;
            rightIdx = idxJ + fillTime - 1;
            J(leftIdx:rightIdx) = minp;
            rezFillmin = (jpsp - minp) * fillTime;

            % allocate joules to high value
            while( rezFillmin > pdiff)
                if(maxp == power(i+1))
                    J(rightIdx) = maxp;
                    rightIdx = rightIdx - 1;
                else
                    J(leftIdx) = maxp;
                    leftIdx = leftIdx + 1;
                end
                rezFillmin = rezFillmin - pdiff;
            end
            % the bit left over becomes a transition point
            % but this screws up clean transitions so just peg it
            % out one way or the other
            if(maxp - rezFillmin) < (rezFillmin - minp)
                perror = maxp;
            else
                perror = minp;
            end
            if(maxp == power(i+1))
                J(rightIdx) = perror;%J(rightIdx) + rezFillmin;
                if perror == maxp
                    Jxition(rightIdx) = pdiff;
                else
                    Jxition(rightIdx+1) = pdiff;
                end
            else
                J(leftIdx) = perror;% maxpJ(leftIdx) + rezFillmin;
                if perror == maxp
                    Jxition(leftIdx) = -pdiff;
                else
                    Jxition(leftIdx-1) = -pdiff;
                end                
            end
            idxJ = idxJ + fillTime;

        end
    end
end  
J(end) = power(end);
totalJ = sum(J)/3600
totalE = (energy(end) - energy(1))