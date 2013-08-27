function [wt, wj] = Jtrend(ts, te, windowSize)
    J = evalin('base','J');

   woff = floor(windowSize/2);
   widx = 1;
   for i=ts:te-windowSize
       wt(widx) = i+woff;
       wj(widx) = sum(J(i:i+windowSize-1)) / windowSize;
       widx = widx + 1;
   end

end
            
            
            

        
