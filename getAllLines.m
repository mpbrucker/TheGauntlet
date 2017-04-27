function [lines, circX, circY, circR] = getAllLines(r, theta, thresh)
    rBucket = .146; % Radius of the bucket (m)


    rMaxThreshhold = 5; %meters
    ransacIterations = 500;
    ransacThreshhold = 0.01; %meters
    endpointsThreshhold = 0.5;
    radiusThreshhold = 0.01; %...meters?
    varianceThreshhold = .05; %Square meters I think

    r_keep = (r~=0) & (r<=rMaxThreshhold);
    r_clean = r(r_keep);
    theta_clean = deg2rad(theta(r_keep));
    lines = {};
    linePoints = {};
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)] % Points represented in Cartesian coordinates
    i=1;
    clf;
%     plot(points(:,1), points(:,2), 'bo'); % Plot the original points
    hold on;
    circleData = [];
    
    for k=1:size(points,1)-5
        testPoints = points(k:k+5, :);
        [xc, yc, r, variance] = fitCircleLinear(testPoints(:,1), testPoints(:,2));
        circleData(k,:) = [xc yc abs(r-rBucket) variance];
        if (abs(r-rBucket) < radiusThreshhold && variance < varianceThreshhold)
            viscircles([xc yc], r);
            circX = xc; % Set the x-position of the circle
            circY = yc; % Set the y-position of the circle
            circR = r; % Set the circle radius
        end
    end

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
%         [xc, yc, r, variance] = fitCircleLinear(lineData(:,1), lineData(:,2));
%         if (abs(r-rBucket) < radiusThreshhold && variance < varianceThreshhold)
%             viscircles([xc yc], r);
%         end
        hold on;
    end
    


end