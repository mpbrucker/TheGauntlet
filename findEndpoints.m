function [ end1, end2, insidePoints] = findEndpoints( points, sensitivity )

    [lineDir, lineOffset] = bestFit(points);
    
    adj = points - lineOffset; %Center points and line
    proj = sort(adj * lineDir');
    
    
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
        
        if (abs(i-prev) >  threshhold) %If the gap was above the threshhold
            if abs(prev - start) > maxLen             %If this is the new longest
                maxLen = (prev - start);        %Note that we should use the *previous* value because if it just failed then we've crossed the gap
                end1 = start;
                end2 = prev;
            end
            start = NaN;                        %So it gets reset at the next iteration
        end %end if gap or last point
            
        prev = i;
        
    end
    
                                        % Also run after the last point
    if abs(prev - start) > maxLen          %If this is the new longest
    	maxLen = (prev - start);        %Note that we should use the *previous* value because if it just failed then we've crossed the gap
        end1 = start;
        end2 = prev;
    end
    
    %assert(~isnan(end1) && ~isnan(end2)); %Case with zero points, I think
    
    if (isnan(end1) || isnan(end2))
        error("Endpoint is NaN!");
        points
    end
    
    
    insidePoints = [];
    
    for point = points'
        thisProj = (point' - lineOffset) * lineDir';
        
        
        if (thisProj > end1) && (thisProj < end2)
            insidePoints = [insidePoints; point'];
        end
    end
    
    
    end1 = (end1 * lineDir) + lineOffset;
    end2 = (end2 * lineDir) + lineOffset;
    
end

