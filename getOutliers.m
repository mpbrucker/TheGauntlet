function outliers = getOutliers(points, inliers)
    invalidIdx = ismember(points, inliers);
    invalidPoints = reshape(points(invalidIdx==0), [], 2);
    outliers = invalidPoints;
end