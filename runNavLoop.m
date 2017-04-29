tf = rostf;
% wait for a bit so we can build up a few tf frames
pause(2);
subPoints = rossubscriber('/stable_scan'); %Point-cloud subscriber
sub_bump = rossubscriber('/bump');          %Bump sensor to stop script
pub = rospublisher('/raw_vel');             %Velocity publisher to move wheels
msg = rosmessage(pub);                      %The message which will be sent to the wheels
omega = .4; % Angular velocity
d = 0.254; % Length of the wheel base

while true
    rMaxThreshhold = 5;
    clf;

    scan_message = receive(subPoints);
    r = scan_message.Ranges(1:end-1);
    theta = [0:359]';
    
    r_keep = (r~=0) & (r<=rMaxThreshhold);
    r_clean = r(r_keep);
    theta_clean = deg2rad(theta(r_keep));
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)]; % Points represented in Cartesian coordinates
    
    scatter(points(:,1), points(:,2), '.');
    
    %gradient = getGradient(points, 0, 0);
    gradient = noRANSAC(points);
    
    %thetaGrad = atan(gradient(2)/gradient(1))
    %t_rot = abs(thetaGrad/omega) % Time to rotate
    
    %calculate the wheel velocities
    %Vl = -omega * d/2*sign(thetaGrad)
    %Vr = omega * d/2*sign(thetaGrad)
    [Vl, Vr] = gradientToWheels(gradient);

    %sending the wheel velocities to the NEATO
    msg.Data = [double(Vl), double(Vr)];
    send(pub, msg);
    %pause(t_rot);
    
    %msg.Data = [.1, .1];
    %send(pub, msg);
    pause(1);
    msg.Data = [0, 0];
    send(pub,msg);
    pause(.1);
    
    b = receive(sub_bump);
    if any(b.Data(2:4))
        break;
    end
    
end

msg.Data = [0, 0];
send(pub, msg); %Stop the robot once the loop is done