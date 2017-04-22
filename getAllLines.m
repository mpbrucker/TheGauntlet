function lines = getAllLines(r, theta, thresh)

    rMaxThreshhold = 5; %meters
    ransacIterations = 500;
    ransacThreshhold = 0.01; %meters
    endpointsThreshhold = 0.5;

    r_keep = (r~=0) & (r<=rMaxThreshhold);
    r_clean = r(r_keep);
    theta_clean = deg2rad(theta(r_keep));
    lines = [];
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)] % Points represented in Cartesian coordinates
    i=1;
    while (size(points,1) > thresh) % While there are still points left
        clf;
        plot(points(:,1), points(:,2), 'bo'); % Plot the original points
        hold on;
        [line, inliers, outliers] = getBestRANSAC(points, ransacIterations, ransacThreshhold); % Tweak this
        plot(inliers(:,1), inliers(:,2), 'g*');
%         if(size(inliers,1)<=8)
%             break;
%         end
        [end1, end2, remaining] = findEndpoints(inliers, endpointsThreshhold);
        
        
        lines(:, :, i) = [end1; end2];
        plot(lines(:,1,end), lines(:,2,end), 'r-*', 'LineWidth', 3);
        disp(lines(:,:,end));
        i = i + 1;
%         plot(insidePoints(:,1), insidePoints(:,2), 'g*');
%        points = getOutliers(points, insidePoints); % Remove inlier points
        points = [outliers; remaining];
%         plot(points(:,1), points(:,2), 'g*');
%         points = outliers;
    end

end