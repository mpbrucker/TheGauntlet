function [ x, y, inliers, outliers ] = findCurveBucket( points )
    plot(points(:,1), points(:,2), 'bo');
    hold on;

    distanceThreshhold = 0.05; %m - the distance to start a new point chunk
    badnessThreshhold = 1;
    pointThreshhold = 4; %min point count
    
    end1 = NaN;
    prev = NaN;
    bestBadness = badnessThreshhold;
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
            thisBadness = constantCurvature(points(end1:prev,:));
            [thisX, thisY, ~, ~] = fitCircleLinear(points(end1:prev,1), points(end1:prev,2));
            if ~isnan(thisBadness) && (thisBadness < bestBadness) && (prev-end1) >= pointThreshhold
                bestX = thisX;
                bestY = thisY;
                bestBadness = thisBadness;
                bestPointSet = [end1, prev];
            end
            end1 = index;
            prev = index;
        else
            norm(points(index,:) - points(prev,:));
            prev = index;
        end
        
    end %end for
            
    
    if (bestBadness == badnessThreshhold) % No bucket has been found
        display('No bucket found!')
        inliers = [];
        outliers = points;
    else
        inliers = points(bestPointSet(1):bestPointSet(2),:);
        outliers = setdiff(points, inliers, 'rows');
        plot(inliers(:,1), inliers(:,2), 'g*');     
    end
    x = bestX; % Assign bestX and bestY to current best X and y values
    y = bestY;

end

