function s = lesion_dots_settings_P7_XXXX0

%measure psychometric functions for both sides using staircase
%left arrpw turns left staircase on/off
%right arrow turns right staircase on/off

%%%these parameters can get changed
s.behavior.reward.amount = [0 0 0];
s.stimulus.stairL= 0; %staircase state L (off initially)
s.stimulus.dotCoherenceL =  1; %start level L
s.stimulus.delta_cohL =  0.2; %coherence staircase step L
s.stimulus.stairR= 0; %staircase state R 
s.stimulus.dotCoherenceR =  1; %start level R
s.stimulus.delta_cohR =  0.2; %coherence staircase step R
s.display.viewdist = 56; %cm
s.stimulus.duration.ITI = 0.2;


%%%these parameters should not be changed without discussion
s.stimulus.dotSize=0.7; %deg
s.stimulus.dotDensity = 0.75; %dots/deg^2
s.stimulus.dotCohDefaultL=1; %level if there is no staircase
s.stimulus.dotCohDefaultR=1; %level if there is no staircase
s.stimulus.dotColor = 0;
s.stimulus.dotSpeed = 72; %deg/sec
s.stimulus.dotLifetime = 25; %ms, 
s.stimulus.direction = [0 180];
s.stimulus.frameRate = 120;
s.display.bgColor = [.5 .5 .5]; 
s.stimulus.width=10; %deg
s.stimulus.stimSide= [-1 1];
s.stimulus.midpointIR = 1; %turn stimulus on when crossing midline
s.stimulus.centerY=860; %vertical stimulus position (pixels)
s.stimulus.offset=15; %horizontal offset in deg (from point where stimulus turns on)
s.stimulus.durStim = 2; %default duration (sec)
s.ports.nPorts = 5;
s.datapixx.din.channels.ports = [0 2 4 6 10];


