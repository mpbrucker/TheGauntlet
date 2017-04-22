function lines = getAllLines(r, theta, thresh)

    %THESE DO NOT AFFECT ANYTHING!  They will be subbed in after Matt
    %commits to Git
    rMaxThreshhold = 5; %meters
    ransacIterations = 50;
    ransacThreshhold = 0.005; %meters
    endpointsThreshhold = 0.1;

    r_keep = (r~=0) & (r<=5);
    r_clean = r(r_keep);
    theta_clean = deg2rad(theta(r_keep));
    lines = [];
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)] % Points represented in Cartesian coordinates
    i=1;
    while (size(points,1) > thresh) % While there are still points left
        clf;
        plot(points(:,1), points(:,2), 'bo'); % Plot the original points
        hold on;
        [line, inliers, outliers] = getBestRANSAC(points, 500, .03); % Tweak this
        plot(inliers(:,1), inliers(:,2), 'g*');
%         if(size(inliers,1)<=8)
%             break;
%         end
        [end1, end2, insidePoints] = findEndpoints(inliers, .5);
        
        
        lines(:, :, i) = [end1; end2];
        plot(lines(:,1,end), lines(:,2,end), 'r-*', 'LineWidth', 3);
        disp(lines(:,:,end));
        i = i + 1;
%         plot(insidePoints(:,1), insidePoints(:,2), 'g*');
        points = getOutliers(points, insidePoints); % Remove inlier points
%         plot(points(:,1), points(:,2), 'g*');
%         points = outliers;
    end

end