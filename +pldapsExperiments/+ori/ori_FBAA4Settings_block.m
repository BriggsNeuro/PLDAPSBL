function s = ori_FBAA4Settings_block
%%%%%%%%%%%%%%%%%
% training 2 - block
% s.stimulus.runtype = 'block'
% s.stimulus.nrReps = 5;
%%%%%%%%%%%%%%%%%%
% turn saving off
% s.pldaps.nosave = 1;
%set reward amounts
s.behavior.reward.amount = [0.05 0.25 0.25];
%set orientation and offsets
s.stimulus.sf = [0.25]; % cycles per degree, may be a vector
s.stimulus.angle = [0 90]; % side matched
s.stimulus.range = [121]; %contrast, range between 1 and 127, may be a vector
s.stimulus.runtype = 'block'; %change to 'block' for block trials, 'pseudo' for pseudorandom
s.stimulus.midpointIR = 1; %use midpoint IR beam to turn on stimulus
s.stimulus.nrBlocks = 100; %nr blocks for all conditions
s.stimulus.jitter  =1;
s.stimulus.nrReps = 7; %nr reps per condition per block, there is random jitter of 0-2 in generateCondList.m
s.stimulus.duration.pretime = 0;

%set viewing parameters
s.stimulus.fullField = 0; %may be a vector [1 0]
s.stimulus.radius=12; %stimulus radius in deg
s.stimulus.sigma=2*s.stimulus.radius/16.5;
s.stimulus.maskLimit=.6*s.stimulus.radius; %switch from open mask to exponential function
s.stimulus.duration.ITI = 2;
%set up the viewing distance
s.display.viewdist = 75; 

% avoid using adc, comment out for adc IR
s.datapixx.adc.channels = [];
s.datapixx.din.useFor.ports = 1;
s.datapixx.dio.useForReward = 1;
s.datapixx.adc.useForReward = 0;

% %
% % Debugging settings % currently can't see the mouse and port, don't know why (makePortsPos.m) - SZ
% 
% %turn adc channels off
% s.datapixx.useAsPorts = 0;
% s.datapixx.adc.channels = [];
% 
% %turn mouse input on
% s.mouse.useAsPort = 1;
% s.mouse.use = 1;

% turn saving off
s.pldaps.nosave = 0;