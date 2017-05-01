tf = rostf;
% wait for a bit so we can build up a few tf frames
pause(2);
sub_points = rossubscriber('/stable_scan'); %Point-cloud subscriber
sub_nump = rossubscriber('/bump');          %Bump sensor to stop script
sub_odom = rossubscriber('/odom');
pub = rospublisher('/raw_vel');             %Velocity publisher to move wheels
msg = rosmessage(pub);                      %The message which will be sent to the wheels
omega = .4; % Angular velocity
d = 0.254; % Length of the wheel base


lastX = NaN;
lastY = NaN;

while true
    rMaxThreshhold = 5;
    

    scan_message = receive(sub_points);
    r = scan_message.Ranges(1:end-1);
    theta = [0:359]';
    
    r_keep = (r~=0) & (r<=rMaxThreshhold);
    r_clean = r(r_keep);
    theta_clean = deg2rad(theta(r_keep));
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean)]; % Points represented in Cartesian coordinates
    
    clf;

    odom_message = receive(sub_odom);   %Yes, we receive position twice per
                                        %loop.  It's not ideal, but given 
                                        %that the slow call 
                                        %(noRANSAC) is one command I think
                                        %it's the best we can do.  Ideally
                                        %it shouldn't have a huge impact
                                        %because the bucket should be
                                        %sighted often.  Please check to be
                                        %sure the measuring and math happen
                                        %at the right places -- we don't
                                        %want to use position data from a
                                        %previous iteration on accident.
    this_pos = [odom_message.Pose.Pose.Position.X, odom_message.Pose.Pose.Position.Y];
    this_dir = odom_message.Pose.Pose.Orientation.W;
    
    if (~isnan(bucketX)) %Position adjustment should happen here
        lastX = bucketX;
        lastY = bucketY;
    end
    
    
    [gradient, bucketX, bucketY] = noRANSAC(points, lastX, lastY);
    
    odom_message = receive(sub_odom);
    last_pos = [odom_message.Pose.Pose.Position.X, odom_message.Pose.Pose.Position.Y];
    last_dir = odom_message.Pose.Pose.Orientation.W;

    [Vl, Vr] = gradientToWheels(gradient);

    %sending the wheel velocities to the NEATO
    msg.Data = [double(Vl), double(Vr)];
    send(pub, msg);
    
    b = receive(sub_nump);
    if any(b.Data(2:4))
        break;
    end
    
end

msg.Data = [0, 0];
send(pub, msg); %Stop the robot once the loop is done