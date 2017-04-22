function lines = getAllLines(r, theta, thresh)

    rMaxThreshhold = 5; %meters
    ransacIterations = 50;
    ransacThreshhold = 0.005; %meters
    endpointsThreshhold = 0.1;

    r_keep = (r~=0) & (r<=rMaxThreshhold);
    r_clean = r(r_keep);
    theta_clean = deg2rad(theta(r_keep));
    lines = [];
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)] % Points represented in Cartesian coordinates
    i=1;
    clf;
    plot(points(:,1), points(:,2), 'bo'); % Plot the original points
    hold on;
    while (size(points,1) > thresh) % While there are still points left
        [line, inliers, outliers] = getBestRANSAC(points, ransacIterations, ransacThreshhold); % Tweak this
%         if(size(inliers,1)<=8)
%             break;
%         end
        [end1, end2, remaining] = findEndpoints(inliers, endpointsThreshhold);
        
        
        lines(:, :, i) = [end1; end2];
        plot(lines(:,1, end), lines(:,2,end), 'r', 'LineWidth', 3);
        i = i + 1;
%         plot(insidePoints(:,1), insidePoints(:,2), 'g*');
%        points = getOutliers(points, insidePoints); % Remove inlier points
        points = [outliers; remaining];
%         plot(points(:,1), points(:,2), 'g*');
%         points = outliers;
    end

end