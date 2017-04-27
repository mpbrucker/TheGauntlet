function [ x, y, inliers, outliers ] = findBucket( points )
    clf;
    plot(points(:,1), points(:,2), 'bo');
    hold on;

    distanceThreshhold = 0.1; %m - the distance to start a new point chunk
    targetRadius = 0.146; % m
   	radiusThreshhold = 0.1; %...meters?
    varianceThreshhold = 0.1; %Square meters I think
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
        
        plot(points(end1:prev,1), points(end1:prev, 2), 'g.');

        if (norm(points(index,:) - points(prev,:)) > distanceThreshhold) || index == length(points)
           [thisX, thisY, thisRadius, thisVariance] = fitCircleLinear(points(end1:prev,1), points(end1:prev,2));
           if (abs(thisRadius - targetRadius) < radiusThreshhold) && (thisVariance < bestVariance) && (prev-end1) >= pointThreshhold
               bestX = thisX;
               bestY = thisY;
               bestVariance = thisVariance;
               bestPointSet = [end1 : prev];
           end
           end1 = index;
           prev = index;
        else
            norm(points(index,:) - points(prev,:))
            prev = index;
        end
        
    end %end for
            
    
    if (isnan(bestVariance))
        points
        error('No bucket found!')
    end
    
    x = bestX;
    y = bestY;
    
    inliers = points(bestPointSet,:);
    outliers = points(~bestPointSet,:);
    
    plot(inliers(:,1), inliers(:,2), 'r*');    


end

