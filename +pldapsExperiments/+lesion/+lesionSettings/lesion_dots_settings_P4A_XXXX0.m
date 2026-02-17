function s = lesion_dots_settings_P4A_XXXX0
%This phase adjusts the stimulus size  


%%%these parameters can get changed
s.behavior.reward.amount = [0.08 0.25 0.25];
s.stimulus.width=50; %start value (deg)
s.stimulus.delta_width = 5; %step size using keys (deg)
s.display.viewdist = 56; %cm
s.stimulus.duration.ITI = 0.2;


%%%these parameters should not be changed without discussion
s.stimulus.dotSize=0.7; %deg
s.stimulus.dotDensity = 0.75; %dots/deg^2
s.stimulus.dotColor = 0;
s.stimulus.dotCoherence =  1; 
s.stimulus.dotSpeed = 72; %deg/sec
s.stimulus.dotLifetime = 25; %ms, 
s.stimulus.direction = [0 180];
s.stimulus.frameRate = 120;
s.display.bgColor = [.5 .5 .5]; 
s.stimulus.durStim = 30; %sec
s.stimulus.midpointIR = 1; %turn stimulus on when crossing midline

