function s = lesion_dots_settings_P7Level_XXXX0
%This phase adjusts the stimulus duration

%%%these parameters can get changed
s.behavior.reward.amount = [0.08 0.225 0.225];
s.display.viewdist = 56; %cm
s.stimulus.duration.ITI = 0.2;
s.stimulus.durStim = 0.5; %default stimulus duration

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
s.stimulus.width=10; %deg
s.stimulus.stimSide= [-1 1];
s.stimulus.midpointIR = 1; %turn stimulus on when crossing midline
s.stimulus.centerY=860; %vertical stimulus position (pixels)
s.stimulus.offset=15; %horizontal offset in deg (from point where stimulus turns on)
%s.datapixx.din.channels.ports = [0 2 4 6 10];
%s.ports.nPorts = 5;
s.stimulus.dotCoherence = [1:-0.2:0.2];

s.stimulus.iniMatchType=0; %value:  0-normal, 1-non-matching choice, 2-matching choice
s.stimulus.cond.Ncond=[4,20]; %either 2 sides x 2 dir, or 2 sides x 2 dir x 5 coh 
%mapping: separate for sides and coherence, but not dir
s.stimulus.cond.counterIdx{1}=[1 3 2 4]; %index into the counter for each condition
s.stimulus.cond.counterIdx{2}=[1:5 1:5 6:10 6:10]; %index into the counter for each condition
s.stimulus.cond.counterNames{1}={'L-0';'R-0';'L-180';'R-180'};
s.stimulus.cond.counterNames{2}={'L-100';'L-80';'L-60';'L-40';'L-20';...
    'R-100';'R-80';'R-60';'R-40';'R-20'};