
%edit your ranges to display here.  important to not include the actual
%location of your object in this grid of points or it will give you
%infinities

[px,py]=meshgrid(-1.5:.2:5.5,-1.5:.2:5.5);
[xlim,ylim] = size(px);
V = zeros(xlim, ylim);

for i=1:xlim
    for j=1:ylim
%this is the equation and integral with ranges for a specific object:  you
%should be able to figure out what this is and edit appropriately to get
%what you want
dV = @(x)  1./(sqrt((px(i,j)-(x+3)).^2 + py(i,j).^2)).^2 + 1./(sqrt(px(i,j).^2 + (py(i,j)-(x+3)).^2)).^2;
V(i,j) = integral(dV,-1,1) - 3./(sqrt((px(i,j)+1).^2+(py(i,j)+1).^2)).^2;
    end
end

hold off
contour(px,py,V, 50)
[Ex,Ey] = gradient(V);

hold on
quiver(px,py,-Ex,-Ey)
line([2 4],[0 0],'LineWidth',2);
line([0 0],[2 4],'LineWidth',2);
plot([-1], [-1], 'r*');