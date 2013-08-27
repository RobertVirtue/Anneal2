xv = zeros(length(xition),1);
xv(xition) = abs(xitionObj(xition,3));
xsniff = smooth(xv,11);
figure(3)
ax(1) = subplot(3,1,1);
plot(J)
hold on
plot(zt,power,'r.');

% xtract = joules removed
xtract = zeros(ilen,1);
for i=1:length(xitionObj)-2
    % remove isolated adjacent paired transitions
    if xitionObj(i,2) == 1  && xitionObj(i,3) > 0 && xsniff(i) < 0.4*xitionObj(i,3)
        if xitionObj(i+1,2) == 1  && xitionObj(i+1,3) < 0 
            met = xitionObj(i,3) / xitionObj(i+1,3);
            if met < -0.8 && met > -1.2
                lhsidx = xitionObj(i,1);
                mididx = xitionObj(i+1,1);
                rhsidx = mididx + 1;
                %xval = min(xitionObj(i,3), abs(xitionObj(i+1,3)));
                xval = (power(i)+power(i+2))/2;
                xtract(i) = sum(J(lhsidx:rhsidx)) - xval*(rhsidx-lhsidx+1);
                J(lhsidx:rhsidx) = xval;%J(lhsidx:rhsidx) - xval;
                power(i+1) = xval;%power(i+1) - xval;
                adj = J(lhsidx:rhsidx) - xval;
                
                xitionObj(i,:) = [0 0 0]; 
                xitionObj(i+1,:) = [0 0 0]; 
            end
        end
    end
    % remove spikes
    if xitionObj(i,2) == 2
        lhsj = xitionObj(i,1);
        rhsj = zt(i+1)-1;
        xval = (power(i)+power(i+1))/2;
        J(lhsj:rhsj) = xval;
        xtract(i) = xitionObj(i,3);
       % xitionObj(i,:) = [0 0 0];
    end            
end

% second pass
for i=1:length(xitionObj)-3
    % remove +ve spike -ve transitions
    if xitionObj(i,2) == 1 && xitionObj(i,3) > 0 &&  xitionObj(i+1,2) == 2  
        if xitionObj(i+2,2) == 1 && xitionObj(i+2,3) < 0 
            met = xitionObj(i,3) / xitionObj(i+2,3);
            if met < -0.8 && met > -1.2
                lhsidx = xitionObj(i,1);
                rhsidx = xitionObj(i+2,1) + 1;
                %xval = min(xitionObj(i,3), abs(xitionObj(i+1,3)));
                xval = (power(i)+power(i+3))/2;
                J(lhsidx:rhsidx) = xval;%J(lhsidx:rhsidx) - xval;                
                adj = sum(J(lhsidx:rhsidx)) - xval*(rhsidx-lhsidx+1);
                xtract(i:i+2)  = xtract(i:i+2) + adj;
                power(i+1) = xval;%power(i+1) - xval;
                power(i+2) = xval;
                xitionObj(i,:) = [0 0 0]; 
                xitionObj(i+2,:) = [0 0 0]; 
            end
        end
    end           
end
    

ax(2) = subplot(3,1,2)
plot(J)
hold on
plot(zt,power,'r.');
ax(3) = subplot(3,1,3)
plot(zti,xtract,'-g.')
linkaxes(ax,'x');
