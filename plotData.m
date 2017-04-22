load 'scan_data.mat'

phi_vals = [0 pi/4 0 pi/4]; % Robot angles at each position
pos_vals = [0 0; 0 0; .914 .914; 1.37 .61]; % Robot positions
d = .0089; % Distance between center of NEATO and center of LIDAR
T_NL = [1 0 -d; 0 1 0; 0 0 1]; % Translate between LIDAR frame and NEATO frame

for i=1:4
%     clf;
    r = r_all(:,i);
    theta = theta_all(:,i);
    phi = phi_vals(i);
    pos = pos_vals(i,:);
    r_keep = (r~=0) & (r<=5); % Removes extraneous values
    r_clean = r(r_keep); % Get clean r values
    theta_clean = deg2rad(theta(r_keep)); % Get clean theta values
    
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean) ones(size(r_clean,1), 1)]';
    R_GN = [cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1]; % Rotation from NEATO to lab frame
    T_GN = [1 0 pos(1); 0 1 pos(2); 0 0 1]; % Translation from NEATO to lab frame
    
    
    points_lab = T_GN*R_GN*points; % Translates points from NEATO to lab coordinate frame
    plot(points_lab(1,:), points_lab(2,:), 'o'); % Plot points
    hold on;
    input('Move to next position.');
end

