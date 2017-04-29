function [lines, circX, circY] = getAllLines(points, thresh)
clf;
    rBucket = .11; % Radius of the bucket (m)


    rMaxThreshhold = 5; %meters
    ransacIterations = 1000;
    ransacThreshhold = 0.003; %meters
    endpointsThreshhold = 0.5;
    radiusThreshhold = 0.01; %...meters?
    varianceThreshhold = .05; %Square meters I think
    bucketRad = .146; % Radius of bucket (m)

    
    clf;
    plot(points(:,1), points(:,2), 'bo');
    hold on;
    [circX, circY, ~, bucketOut] = findBucket(points); % Get the bucket first
    if (~isnan(circX))
        points = bucketOut; % Remove the bucket points
        viscircles([circX circY], bucketRad); % Visualize the bucket
    end

    
    lines = {};
    linePoints = {};
    i=1;
    

    while (size(points,1) > thresh) % While there are still points left
        [line, inliers, outliers] = getBestRANSAC(points, ransacIterations, ransacThreshhold); % Tweak this
%         plot(inliers(:,1), inliers(:,2), 'g*');
        [end1, end2, remaining, inPoints] = findEndpoints(inliers, endpointsThreshhold);
        linePoints{i} = inPoints;
        lines{i} = [end1; end2];
%         plot(lines(:,1,end), lines(:,2,end), 'r-*', 'LineWidth', 3);
        i = i + 1;
%         plot(insidePoints(:,1), insidePoints(:,2), 'g*');
%        points = getOutliers(points, insidePoints); % Remove inlier points
        points = [outliers; remaining];
%         plot(points(:,1), points(:,2), 'g*');
%         points = outliers;
    end
    size(lines)
    for j=1:i-1
        plot(lines{j}(:,1), lines{j}(:,2), 'r', 'LineWidth', 3)
        lineData = linePoints{j};
        hold on;
    end
    
end