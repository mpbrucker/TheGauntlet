function [ gradient ] = noRANSAC( points )

    pointConstWeight = 0.1; 
    pointDistWeight = 1; %Weight per meter
    circleConstWeight = 10;
    circleDistWeight = 0;
    
    
    gradient = [0 0];
    
    % First, find the bucket, if possible.
    [circX, circY, ~, outliers] = findBucket(points); % Get the bucket first
    if (~isnan(circX))
        points = outliers; % Remove the bucket points
        viscircles([circX circY], 0.11); % Visualize the bucket -- r=0.11m
        
        dist = norm([circX circY]);
        unit = [circX circY]/dist;
        force = unit * (circleConstWeight + circleDistWeight/dist);
        gradient = gradient + force;
    end
    
    for i = 1 : length(points)
        
        dist = norm(points(i,:));
        unit = points(i,:) / dist;
        force = unit * (pointConstWeight + pointDistWeight/dist);
        gradient = gradient + force;
        
    end

end

