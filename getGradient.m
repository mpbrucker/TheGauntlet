function gradOut = getGradient(r, theta, xPos, yPos);
    clf;
    RANSACThresh = 30; % The number of "noise points" in our RANSAC search
    [lines, cx, cy, r] = getAllLines(r, theta, RANSACThresh);
    
    [px,py]= meshgrid(xPos-0.01:0.01:xPos+0.01, yPos-0.01:0.01:yPos+0.01);
    [xlim,ylim] = size(px);
    V = zeros(xlim, ylim);

    for i=1:xlim
        for j=1:ylim
    %this is the equation and integral with ranges for a specific object:  you
    %should be able to figure out what this is and edit appropriately to get
    %what you want
            curV= 0; % Keep track of the current potential
            for k=1:length(lines)
                curLine = lines{k};
%                 line([curLine(1,1) curLine(2,1)], [curLine(1,2) curLine(2,2)], 'Color','b', 'LineWidth', 3);
                lineVector = curLine(2,:) - curLine(1,:); % Vector of the current line
                x0 = curLine(1,1); % Beginning x pos
                y0 = curLine(1,2); % Beginning y pos
                m = lineVector(2)/lineVector(1); % Slope of the lines
                dV = @(u) sqrt(1+m.^2)./sqrt((px(i,j)-(u+x0)).^2+(py(i,j)-(m*u+y0)).^2);
                curV = curV - integral(dV, 0, lineVector(1)); % Get potential at current point
%                 keyboard;
            end
            V(i,j) = curV - 3./sqrt((px(i,j)-cx).^2+(py(i,j)-cy).^2); % Add to the matrix of potentials and include goal point
        end
    end
    
%     contour(px,py,V, 10)
    [Ex,Ey] = gradient(V);

    hold on
    quiver(px(2,2),py(2,2),-Ex(2,2),-Ey(2,2), 'AutoScale', 'off')
    plot(xPos, yPos, 'r*');

end