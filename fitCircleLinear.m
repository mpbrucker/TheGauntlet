function [xc, yc, r, variance] = fitCircleLinear(x, y)
% This script runs through the task of samplinig points from an arc of
% a circle with a little bit of noise added.  Next, the best fitting circle
% is extracted using least squares optimization
%
% Finally, the circle and the poitns are plotted

% set up an overconstrained system of linear equations
% A*w = b
A = [x y ones(size(x))];
b = -x.^2 - y.^2;
w = A\b;

% convert from the least squares solution to the more familiar parameters
% of a circle.
xc = -w(1)/2;
yc = -w(2)/2;
r = sqrt(xc.^2 + yc.^2 - w(3));

radii = sqrt(x.^2 + y.^2);
variance = mean((radii - r).^2);

end