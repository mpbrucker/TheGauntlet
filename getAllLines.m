function lines = getAllLines(r, theta, thresh)
    r_keep = (r~=0) & (r<=5);
    r_clean = r(r_keep);
    theta_clean = deg2rad(theta(r_keep));
    lines = [];
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)] % Points represented in Cartesian coordinates
    i=1;
    clf;
    plot(points(:,1), points(:,2), 'bo'); % Plot the original points
    hold on;
    while (size(points,1) > thresh) % While there are still points left
        [line, inliers, outliers] = getBestRANSAC(points, 50, .005); % Tweak this
%         if(size(inliers,1)<=8)
%             break;
%         end
        [end1, end2, insidePoints] = findEndpoints(inliers, .1);
        
        
        lines(:, :, i) = [end1; end2];
        plot(lines(:,1, end), lines(:,2,end), 'r', 'LineWidth', 3);
        i = i + 1;
%         plot(insidePoints(:,1), insidePoints(:,2), 'g*');
        points = getOutliers(points, insidePoints); % Remove inlier points
%         plot(points(:,1), points(:,2), 'g*');
%         points = outliers;
    end

end