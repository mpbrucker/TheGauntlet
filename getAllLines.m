function lines = getAllLines(r, theta, thresh)
    theta_clean = deg2rad(theta(r~=0)); % Get clean theta values
    r_clean = deg2rad(r(r~=0)); % Get clean r values
    lines = []
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)] % Points represented in Cartesian coordinates
    i=1;
    clf;
    plot(points(:,1), points(:,2), 'bo'); % Plot the original points
    hold on;
    while (size(points,1) > thresh) % While there are still points left
        [line, inliers, outliers] = getBestRANSAC(points, 100, .001); % Tweak this
        lines(:, :, i) = line;
        i = i + 1;
        points = outliers;
    end
    lines
    for i=1:size(lines,3)
        plot(lines(:,1, i), lines(:,2,i), 'r');
        hold on;
    end

end