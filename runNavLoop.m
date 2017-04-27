tf = rostf;
% wait for a bit so we can build up a few tf frames
pause(2);
subPoints = rossubscriber('/stable_scan'); %Point-cloud subscriber
sub_bump = rossubscriber('/bump');          %Bump sensor to stop script
pub = rospublisher('/raw_vel');             %Velocity publisher to move wheels
msg = rosmessage(pub);                      %The message which will be sent to the wheels

while true
    
    rMaxThreshhold = 5;

    scan_message = recieve(subPoints);
    r = scan_message.Ranges(1:end-1);
    theta = [0:359]';
    
    r_keep = (r~=0) & (r<=rMaxThreshhold);
    r_clean = r(r_keep);
    theta_clean = deg2rad(theta(r_keep));
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)]; % Points represented in Cartesian coordinates
    
    scatter(points(:,1), points(:,2), '.');
    
    gradient = getGradient(points, 0, 0);
    
    [left, right] = gradientToWheels(gradient);
    msg.Data = [left, right];
    send(pub, msg);
    
    b = receive(sub_bump);
    if any(b.Data)
        break;
    end
    
end

msg.Data = [0, 0];
send(pub, msg); %Stop the robot once the loop is done