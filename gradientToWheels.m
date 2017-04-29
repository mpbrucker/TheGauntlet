function [ left, right ] = gradientToWheels( gradient )

    linearSpeedMax = 0.3;       %m/s
    rotateSpeedMult = 1;      %Rad/Rad, this is 1/the number of seconds it takes for the Neato to "correct" its direction if it gets no more commands
    rotateThreshhold = 0.3;     %Rad/s -- above this rotation speed the Neato no longer moves forward
    d = 0.24765;                %distance between wheels in meters

    
    gradientUnit = gradient / norm(gradient);
    angle = atan2(gradientUnit(1), gradientUnit(2));
    
    rotateSpeed = angle * rotateSpeedMult;
    if abs(rotateSpeed) > rotateThreshhold
        linearSpeed = 0;
    else
        linearSpeed = (rotateThreshhold - abs(rotateSpeed)) * linearSpeedMax;
    end
        
    left = linearSpeed - (rotateSpeed * d / 2);
    right = linearSpeed + (rotateSpeed * d / 2);

end

