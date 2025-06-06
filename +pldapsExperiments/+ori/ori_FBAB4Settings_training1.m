function s = ori_FBAB4Settings_training1(savedata,rewardamounts,trialblocks,stimsize,datafolder)
% SZ: traing stage 1 - get reward from all ports in any sequence, modified from ori_FBAB4Settings
% turn saving off
s.pldaps.nosave = savedata; %1 means no data saved
s. behavior.reward. manualAmount = 0.2;
%set reward amounts
s.behavior.reward.amount = rewardamounts;

%set orientation and offsets
s.stimulus.sf = [0.25]; % cycles per degree, may be a vector
s.stimulus.angle = [0 90]; % side matched
s.stimulus.range = [0]; %contrast, range between 1 and 127, may be a vector
s.stimulus.runtype = trialblocks; %change to 'block' for block trials
s.stimulus.midpointIR = 1; %use midpoint IR beam to turn off stimulus
s.stimulus.nrBlocks = 100; %nr blocks for all conditions
s.stimulus.nrReps = 1; %nr reps per condition per block

%set viewing parameters
s.stimulus.fullField = 0; %may be a vector [1 0]
s.stimulus.radius=stimsize; %stimulus radius in deg
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

s.	pldaps.	dirs.	data = datafolder; % FB updated based on initialization code - 9/26/24