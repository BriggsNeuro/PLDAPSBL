function s = lesion_dots_settings_P3_Gouda
%This phase adjusts the dot density and dot size 

%%%these parameters can get changed
s.behavior.reward.amount = [0.1 0.275 0.275];
s.stimulus.dotSize = 0.7; %start size (deg)
s.stimulus.delta_size = .2; %step size for size (up/down key)
s.stimulus.dotDensity = 0.75; %start density (dots/deg^2)
s.stimulus.delta_den = 0.08; %step size for density (left/right key)
s.display.viewdist = 56; %cm
s.stimulus.duration.ITI = 0.2;

%%%these parameters should not be changed without discussion
s.stimulus.dotColor = 0;
s.stimulus.dotCoherence =  1; 
s.stimulus.dotSpeed = 48; %deg/sec
s.stimulus.dotLifetime = 25; %ms, 
s.stimulus.direction = [0 180];
s.stimulus.frameRate = 120;
s.display.bgColor = [.5 .5 .5]; 
s.stimulus.durStim = 30; %sec
s.stimulus.midpointIR = 1; %turn stimulus on when crossing midline


%s.datapixx.adc.channels = [2 4 6];
%s.ports.nports=3;
