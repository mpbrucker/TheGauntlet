tf = rostf;
% wait for a bit so we can build up a few tf frames
pause(2);
subPointCloud = rossubscriber('/projected_stable_scan'); %Point-cloud subscriber
sub_bump = rossubscriber('/bump');          %Bump sensor to stop script
pub = rospublisher('/raw_vel');             %Velocity publisher to move wheels
msg = rosmessage(pub);                      %The message which will be sent to the wheels

while true
    
    pointCloud = receive(subPointCloud);
    points = readXYZ(pointCloud);
    
    scatter(points(:,1), points(:,2), '.');
    
    [left, right] = dummyNavFunction(points);
    msg.Data = [left, right];
    send(pub, msg);
    
    b = receive(sub_bump);
    if any(b.Data)
        break;
    end
    
end

msg.Data = [0, 0];
send(pub, msg); %Stop the robot once the loop is done