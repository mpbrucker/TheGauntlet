pub = rospublisher('/raw_vel');             %Velocity publisher to move wheels
msg = rosmessage(pub);                      %The message which will be sent to the wheels
msg.Data = [0,0];
send(pub, msg);