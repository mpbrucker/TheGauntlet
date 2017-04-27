function [lines, circX, circY, circR] = getAllLines(points, thresh)
clf;
    rBucket = .146; % Radius of the bucket (m)


    rMaxThreshhold = 5; %meters
    ransacIterations = 500;
    ransacThreshhold = 0.01; %meters
    endpointsThreshhold = 0.5;
    radiusThreshhold = 0.01; %...meters?
    varianceThreshhold = .05; %Square meters I think
    bucketRad = .146; % Radius of bucket (m)

    [circX, circY, inliers, bucketOut] = findBucket(points); % Get the bucket first
    points = bucketOut; % Remove the bucket points

    
    lines = {};
    linePoints = {};
    i=1;
    clf;
    plot(points(:,1), points(:,2), 'bo');
    hold on;
    viscircles([circX circY], bucketRad); % Visualize the bucket
    circleData = [];
    

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