function lines = getAllLines(r, theta, thresh)
    theta_clean = deg2rad(theta(r~=0)); % Get clean theta values
    r_clean = (r(r~=0)); % Get clean r values
    lines = []
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)]; % Points represented in Cartesian coordinates
    i=1;

    while (size(points,1) > thresh) % While there are still points left
        clf;
        plot(points(:,1), points(:,2), 'bo'); % Plot the original points
        hold on;
        [line, inliers, outliers] = getBestRANSAC(points, 500, .01); % Tweak this
%         if(size(inliers,1)<=8)
%             break;
%         end
        [end1, end2, insidePoints] = findEndpoints(inliers, 1);
        
        
        lines(:, :, i) = [end1; end2];
        for j=1:i
            plot(lines(:,1,i), lines(:,2,i), 'r', 'LineWidth', 3);
            
        end
        i = i + 1;
%         plot(insidePoints(:,1), insidePoints(:,2), 'g*');
        points = getOutliers(points, insidePoints); % Remove inlier points
%         plot(points(:,1), points(:,2), 'g*');
%         points = outliers;
    end

end