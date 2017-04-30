function [ badness ] = constantCurvature( points )


    if length(points) < 3
        badness = NaN;
        return 
    end

    targetRadius = 0.11; % m
    radiusWeight = 200; 
    varianceWeight = 0; 
    angleWeight = 1;
    smoothWeight = 100;
    countWeight = -0.5;

    angles = zeros(length(points)-2, 1);
    da = zeros(length(points)-3, 1);
    totalLen = 0;
    
    %Initialize with first direction
    diff = points(2,:) - points(1,:);
    lastUnit = diff / norm(diff);
    totalLen = totalLen + norm(diff);

    for i = 2 : (length(points)-1)
        
        diff = points(i+1,:) - points(i,:);
        thisUnit = diff / norm(diff);
        
        angles(i-1) = acos(dot(thisUnit, lastUnit));
        
        lastUnit = thisUnit;
        totalLen = totalLen + norm(diff);
    end
    
    for i = 1 : length(points)-3
        da(i) = angles(i+1) - angles(i);
    end
    
    %thisRadius = (totalLen / length(points)) / ( 2*mean(arrayfun(@(th) cos(th*2), angles)) )
    [~, ~, thisRadius, variance] = fitCircleLinear(points(:,1), points(:,2));
    
    angleVar = var(angles, 1) * mean(angles .^2);
    
    thisSmooth = var(da, 1) * mean(da .^ 2);
    
    badness = ...
        (thisRadius - targetRadius)^2 *radiusWeight + ...
        angleVar*angleWeight + ...
        countWeight/length(points) + ...
        thisSmooth*smoothWeight + ...
        variance*varianceWeight;

end

