function p=startcam(p)

%get camera ready (acquisition will start with hardware trigger)
%5/22/25 fwrite commented out (not using this far)

if p.trial.camera.use %just to double check
    msg='G~';
    %fwrite(p.trial.camera.udpHandle,msg);
    pause(2); %needs to wait to make sure camera is started
end
