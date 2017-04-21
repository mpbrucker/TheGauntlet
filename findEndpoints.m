function [ end1, end2 ] = findEndpoints( points, sensitivity )
    
    [lineDir, lineOffset] = bestFit(points);
    
    adj = points - lineOffset; %Center points and line
    proj = sort(adj * lineDir')
    
    
    count = length(proj);                     %number of points
    dist = abs(proj(count) - proj(1));     %Total line length
    avgDist = dist / count;
    threshhold = avgDist / sensitivity;
    
    
    maxLen = 0;
    end1 = NaN;
    end2 = NaN;
    start = NaN;
    prev = proj(1);
    
    for i = proj'
        
        if isnan(start)
            start = i;
        end
        
        if (abs(i-prev) >  threshhold) || (i == proj(length(proj))) %If the gap was above the threshhold or we're at the last point
            if (prev - start) > maxLen             %If this is the new longest
                maxlen = (prev - start)        %Note that we should use the *previous* value because if it just failed then we've crossed the gap
                end1 = start;
                end2 = prev;
            end
            start = NaN;                        %So it gets reset at the next iteration
        end %end if gap or last point
            
        prev = i;
        
    end
    
    assert(~isnan(end1) && ~isnan(end2)); %Case with zero points, I think
    
end
