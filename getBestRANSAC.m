function [line, inliers] = getBestRANSAC(points, n, d)
    maxInliers = 0; % Running tally of maximum number of inlier points
    bestLine = [0; 0]; % The best line
    inliers = []; % Keep track of inliers
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
        standPerp = perpVec/norm(perpVec); % Standardize the perpendicular vector
        
%         quiver(testPoints(1,1), testPoints(1,2), testLine(1), testLine(2), 'Color', 'r');
%         quiver(testPoints(1,1), testPoints(1,2), standPerp(1), standPerp(2), 'Color', 'g');
        
%         quiver(0, 0, testLine(1), testLine(2), 'Color', 'b');
%         quiver(0, 0, standPerp(1), standPerp(2), 'Color', 'k');
        grid on
        daspect([1 1 1])
        
        projPoints = standPerp*standPoints' % Project points onto the perpendicular vector
        validPoints = abs(projPoints) < d; % Find valid points
        numValid = sum(validPoints); % Get number of valid points
        if (numValid > maxInliers)
            bestLine = testPoints; % Update the points for best line
            maxInliers = numValid; % Update the best
            inliers = points(find(validPoints),:); % Filter valid points
        end 
    end
    line = bestLine
    plot(inliers(:,1), inliers(:,2), 'go');
    plot(line(:,1), line(:,2), 'b');
end

