function [line, inliers, outliers] = getBestRANSAC(points, n, d)
    maxInliers = 0; % Running tally of maximum number of inlier points
    bestLine = [0; 0]; % The best line
    inliers = []; % Keep track of inliers
    outliers = []; % Keep track of outliers
    for i=1:n
        randRows = randperm(size(points,1)); % Sort the rows randomly
        pointRows = randRows(1:2); % Get two random rows
        testPoints = points(pointRows, :) % Pick the two random points
        
        testLine = testPoints(2,:) - testPoints(1,:) % Get vector between the points
        standPoints = points - testPoints(1,:); % Standardize points to pass through origin
        clf;
        plot(points(:,1), points(:,2), 'r*');
        hold on;
%         plot(standPoints(:,1), standPoints(:,2), 'b*');
        perpVec = [-testLine(2) testLine(1)]; % Get perpendicular vector
        standPerp = perpVec/norm(perpVec) % Standardize the perpendicular vector
        
        quiver(testPoints(1,1), testPoints(1,2), testLine(1), testLine(2), 'Color', 'r');
        quiver(testPoints(1,1), testPoints(1,2), standPerp(1), standPerp(2), 'Color', 'g');
        
%         quiver(0, 0, testLine(1), testLine(2), 'Color', 'b');
%         quiver(0, 0, standPerp(1), standPerp(2), 'Color', 'k');
        grid on
        daspect([1 1 1])
        
        projPoints = standPerp*standPoints' % Project points onto the perpendicular vector
        validPoints = abs(projPoints) < d % Find valid points
        numValid = 
        inliers = points(find(validPoints),:) % Filter valid points
        plot(inliers(:,1), inliers(:,2), 'go');
        if 
    end
end