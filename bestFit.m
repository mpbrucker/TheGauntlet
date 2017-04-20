function [slope, y_int] = bestFit (points)
    
    xMean = mean(points(:,1));                  %Mean-center points
    yMean = mean(points(:,2));                  
    adj = [points(:,1) - xMean, points(:,2) - yMean];
    
    [eigs, ~] = eig(adj' * adj);                %Find eigenvectors
    dir = eigs(:, size(eigs, 2));               %Take the most significant one
    
    slope = dir(2) / dir(1);
    y_int = yMean - (xMean * slope);

end