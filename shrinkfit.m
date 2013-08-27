
dE = diff(energy);
dT = diff(times);

numSamples = length(times);
numIntervals = numSamples - 1;
numSecs = times(end) - times(1) + 1;
K = zeros(numSecs,1);

relativeTime = times - times(1) + 1; % The + 1 is to non-zero index J ...
stepTimes = relativeTime(1:end-1);

halfTime = dT / 2;
midIntervalTime = relativeTime(1:end-1) + halfTime;

xition = false(numIntervals,1);

% quantization on finest scale
qJ = 3599 ./ dT;
xJ = 3600*dE ./ dT + qJ;
nJ = 3600*dE ./ dT - qJ;

epsilon = 30;

%
% Method One: Improves EnergySpace but not TransitionSpace
%
% reduce qJ so long as all power samples are within average power
% quantization limits
for span = 2:250  % 25 sample span is completely arbitrary
    for i = 1:numSamples - span
        dt = times(i+span) - times(i);
        dq = 3599 / dt;
        de = 3600*(energy(i+span)-energy(i)) / dt;
        dex = de + dq;
        den = de - dq;
        
        if ~any(power(i:i+span) > dex + epsilon) && ~any(power(i:i+span) < den - epsilon)
            for j=i:i+span - 1
                xJ(j) = min(xJ(j), dex);
                nJ(j) = max(nJ(j), den);
            end
        end
    end
end

%
% Method Two: Improves EnergySpace and TransitionSpace with some
% potentially erroneous assumptions. Not theoretically robust atm.
%

% first, flag any existing transitions
for i = 1:numIntervals
    maxp = max(power(i),power(i+1));
    minp = min(power(i),power(i+1));
    if ~( (minp > nJ(i)) && (minp < xJ(i)) && (maxp < xJ(i)) && (maxp > nJ(i)) )
        xition(i) = true;
    end
    % add this cheat in here for fridges until regressionFit is complete
    if maxp - minp > 60
        xition(i) = true;
    end
end

% remainder lives in regressionFit.m

% regrind

% i = 1;
% while i < numIntervals - 2
%     % linear fill within 'box'
%     if ~xition(i)&& ~xition(i+1)&& ~xition(i+2)
%         startTime = relativeTime(i);
%         si = i;
%         while i < numIntervals-2 && ~xition(i+2)
%             i = i + 1;
%         end
%         endTime = relativeTime(i+1);
%         ei = i+3;
%         ft = fittype( 'gauss3' );
%         opts = fitoptions( ft );
%         [xData, yData] = prepareCurveData( relativeTime(si:ei), power(si:ei));
%         [fitresult, gof] = fit( xData, yData, ft, opts );
%         
%         timespan = startTime:endTime;
%         K(timespan) = fitresult(timespan);
%     end
%     i = i + 1;
% end
% 
% plot(relativeTime,power,'b.')
% hold on
% plot(K,'g.')
    




























 