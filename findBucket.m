function [ x, y, inliers, outliers ] = findBucket( points )

    distanceThreshhold = 0.1; %m - the distance to start a new point chunk
    targetRadius = 0.146; % m
   	radiusThreshhold = 0.2; %...meters?
    varianceThreshhold = 2; %Square meters I think
    pointThreshhold = 5; %min point count
    
    end1 = NaN;
    prev = NaN;
    bestVariance = varianceThreshhold;
    bestX = NaN;
    bestY = NaN;
    bestPointSet = [];
    
    [theta,~] = cart2pol(points(:,1),points(:,2));
    pointsWithIndices = [points theta];
    points = sortrows(pointsWithIndices,3);
    points = points(:,1:2);

    for index = 1 : length(points)
        
        if isnan(end1)
            end1 = index;
        end
        
        if isnan(prev)
            prev = index;
        end
        
        if (norm(points(index,:) - points(prev,:)) > distanceThreshhold) || index == length(points)
           [thisX, thisY, thisRadius, thisVariance] = fitCircleLinear(points(end1:prev,1), points(end1:prev,2))
           if (abs(thisRadius - targetRadius) < radiusThreshhold) && (thisVariance < bestVariance) && (prev-end1) >= pointThreshhold
               bestX = thisX;
               bestY = thisY;
               bestVariance = thisVariance;
               bestPointSet = [end1, prev];
           end
           end1 = index;
           prev = index;
        else
            prev = index;
        end
        
    end %end for
        
    
    if (isnan(bestVariance))
        error('No bucket found!')
        points
    end
    
    x = bestX;
    y = bestY;
    
    inliers = points(bestPointSet(1):bestPointSet(2),:);
    outliers = setdiff(points, inliers, 'rows');
    plot(outliers(:,1), outliers(:,2), 'g*');

end

