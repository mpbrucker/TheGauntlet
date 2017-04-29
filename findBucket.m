function [ x, y, inliers, outliers ] = findBucket( points )
%     plot(points(:,1), points(:,2), 'bo');
    hold on;

    distanceThreshhold = 0.15; %m - the distance to start a new point chunk
    targetRadius = 0.11; % m
   	radiusThreshhold = 0.015; %...meters?
    varianceThreshhold = 2.5; %Square meters I think
    pointThreshhold = 4; %min point count
    
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
        
%         plot(points(end1:prev,1), points(end1:prev, 2), 'g.');

        if (norm(points(index,:) - points(prev,:)) > distanceThreshhold) || index == length(points)
           [thisX, thisY, thisRadius, thisVariance] = fitCircleLinear(points(end1:prev,1), points(end1:prev,2));
           if (abs(thisRadius - targetRadius) < radiusThreshhold) && (thisVariance < bestVariance) && (prev-end1) >= pointThreshhold
               bestX = thisX;
               bestY = thisY;
               bestVariance = thisVariance;
               bestPointSet = [end1, prev];
           end
           end1 = index;
           prev = index;
        else
            norm(points(index,:) - points(prev,:));
            prev = index;
        end
        
    end %end for
            
    
    if (bestVariance == varianceThreshhold) % No bucket has been found
        display('No bucket found!')
        inliers = [];
        outliers = points;
    else
        inliers = points(bestPointSet(1):bestPointSet(2),:);
        outliers = setdiff(points, inliers, 'rows');
%         plot(outliers(:,1), outliers(:,2), 'g*');     
    end
    x = bestX; % Assign bestX and bestY to current best X and y values
    y = bestY;

end

