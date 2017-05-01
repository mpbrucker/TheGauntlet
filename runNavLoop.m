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
lidarOffset = 0.1; %m - distance between center of LIDAR and center of bot

bucketMaxAge = 2; %Number of iterations to keep the last-seen bucket in memory
bucketAge = bucketMaxAge+1; %So it's not used at first

% pastBuckets = []; %Stores the locations of past bucket sightings

bucketX = NaN;
bucketY = NaN;
    
odom_message = receive(sub_odom);
last_pos = [odom_message.Pose.Pose.Position.X, odom_message.Pose.Pose.Position.Y];
last_dir = odom_message.Pose.Pose.Orientation.W;

while true
    rMaxThreshhold = 5;
    

    scan_message = receive(sub_points);
    r = scan_message.Ranges(1:end-1);
    theta = [0:359]';
    
    r_keep = (r~=0) & (r<=rMaxThreshhold);
    r_clean = r(r_keep);
    theta_clean = deg2rad(theta(r_keep));
    points = [r_clean.*cos(theta_clean) r_clean.*sin(theta_clean) - lidarOffset]; % Points represented in Cartesian coordinates

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
    new_pos = [odom_message.Pose.Pose.Position.X, odom_message.Pose.Pose.Position.Y];
    new_dir = odom_message.Pose.Pose.Orientation.W;
    
    if ~isnan(bucketX) && bucketAge <= bucketMaxAge %Position adjustment should happen here

        bucketPos = [bucketX; bucketY; 1];
        trans1 = [1 0 -last_pos(1); 0 1 -last_pos(2); 0 0 1];
        rot1 = [cos(last_dir) sin(last_dir) 0; -sin(last_dir) cos(last_dir) 0; 0 0 1];
        bucketPos = rot1 * (trans1 * bucketPos);
        
        rot2 = [cos(new_dir) -sin(new_dir) 0; sin(new_dir) cos(new_dir) 0; 0 0 1];
        trans2 = [1 0 new_pos(1); 0 1 new_pos(2); 0 0 1];
        bucketPos = trans2 * (rot2 * bucketPos);
        
        lastX = bucketPos(1);
        lastY = bucketPos(2);
        
    end
    
    
    [gradient, thisX, thisY] = noRANSAC(points, lastX, lastY);
    if (~isnan(thisX))
        bucketX = thisX;
        bucketY = thisY;
        bucketAge = 0;
    else
        bucketX = lastX;
        bucketY = lastY;
        bucketAge = bucketAge + 1;
    end
    quiver(0, 0, gradient(1), gradient(2), 'r');
    
    odom_message = receive(sub_odom);
    last_pos = [odom_message.Pose.Pose.Position.X, odom_message.Pose.Pose.Position.Y];
    last_dir = odom_message.Pose.Pose.Orientation.W;

    [Vl, Vr] = gradientToWheels(gradient);

    %sending the wheel velocities to the NEATO
    msg.Data = [double(Vl), double(Vr)];
     send(pub, msg);
    
    b = receive(sub_nump);
    if any(b.Data)
        break;
    end
    
end

msg.Data = [0, 0];
send(pub, msg); %Stop the robot once the loop is done