% Incredible number of repeated calculations here and multiple avenues for
% improving and utilizing fit results.
%
% Constant fit: Good for a steady load. The slope of the interpolation fit
% should be zero. As the number of intervals included in the fit increases,
% the weight of any power reading 'spikes' decreases: larger fits require
% larger magnitude transitions to flag them as such, while smaller fits
% flag smaller transitions.
%
% Constant rate of load change: For example load droop for a fridge. The
% slope of the interpolation fit is non-zero.
%
% Non-linear load profiles: Fits here could still prove useful. Later.
%
% First pass is for a constant fit. Once the interpolation slope predicts
% endpoints outside xJ or nJ, we'll stop and call it constant up to that
% point - it is more accurately a higher order of change.
%
% Linear fit
ft = fittype( 'poly1' );
opts = fitoptions( ft );

% fit start index
fsidx = 1;

done = false;
while ~done
    % find first non-transition interval in interval range
    while (fsidx < numIntervals - 2) && (xition(fsidx) || xition(fsidx + 1))
        fsidx = fsidx + 1;
    end
    % fit end index = feidx
    feidx = fsidx + 1;
    % sniff ahead to find next transition
    while feidx < numIntervals && ~xition(feidx + 1)
        feidx = feidx + 1;
    end
    if feidx == numIntervals
        done = true;
    else
        % It would be nice to recursively partition this interval, but again,
        % brute force for now
        %
        % fsidx points at the first _interval_ and therefore the first sample.
        % feidx points at the (beginning of, if you will) the last interval.
        % The number of samples is therefore:
        fsidx % progress indicator
        maxspan = feidx - fsidx + 2;
        if maxspan > 5
            for span = maxspan:-1:5
                % 
                % The slope of the power interpolation is slope in EnergySpace.
                % By adjusting the energy intercept point so that the
                % quantization of energy readings is satisfied, a narrow range
                % of sub-Whr energy values can be obtained. Higher-order
                % interpolations (constrained by both power readings and energy
                % quantization) may be used in a similar fashion. Test results
                % obtained energy values with ~ 1/15Whr.
                %
                % Utilizing this mechanism is deferred as a refinement step :(
                %
                % Slide the progressively smaller interpolation span within the
                % interpolation limits. Just grab the min/max and see if things
                % break.

                for j = fsidx + maxspan - span:fsidx + maxspan
                    eidx = j + span - 1;
                    [xData, yData] = prepareCurveData( relativeTime(j:eidx), power(j:eidx));
                    [fitresult, gof] = fit( xData, yData, ft, opts );

                    % Calculate linear energy 'box'
                    dt = relativeTime(eidx) - relativeTime(j);
                    de = (3600*(energy(eidx)-energy(j) - power(eidx))) / (dt - 1);
                    dq = 3599 / dt;            
                    jmin = de - dq;
                    jmax = de + dq;
                    % get endpoints of interpolated line
                    ep = fitresult([relativeTime(j) relativeTime(eidx)]);
                    % dp the endpoints lie within the box?
                    if max(ep) < jmax  && min(ep) > jmin
                    % The following constrains power readings to lie within the
                    % 'box' as well.
                    % if max(max(epR), max(power(istart:iend+1)) ) < jmax  && min(min(epR),min(power(istart:iend+1))) > jmin
                        for i = j:eidx+1
                            xJ(i) = min(xJ(i),jmax);
                            nJ(i) = max(nJ(i),jmin);
                        end
                        % There is probably a better way to do the above rather
                        % than a loop
                    end
                end
            end
        end
        fsidx = feidx + 2;
        if fsidx > numIntervals - 10
            done = true;
        end
    end
end