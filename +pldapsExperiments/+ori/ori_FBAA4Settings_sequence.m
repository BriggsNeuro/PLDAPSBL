function s = ori_FBAA4Settings_sequence(savedata,rewardamounts,trialblocks,stimsize,datafolder)
%%%%%%%%%%%%%%%%%
% training 2 - block
s.stimulus.runtype = trialblocks; %change to 'block' for block trials, 'pseudo' for pseudorandom
% s.stimulus.nrReps = 5;
%%%%%%%%%%%%%%%%%%
% turn saving off
s.pldaps.nosave = savedata;
%set reward amounts
s.behavior.reward.amount = rewardamounts;
%set orientation and offsets
s.stimulus.sf = [0.03]; % cycles per degree, may be a vector
s.stimulus.angle = [0]; % side matched
s.stimulus.range = [121]; %contrast, range between 1 and 127, may be a vector
s.stimulus.midpointIR = 0; %use midpoint IR beam to turn off stimulus
s.stimulus.nrBlocks = 20; %nr blocks for all conditions
s.stimulus.jitter = 0;
s.stimulus.nrReps = 10; %nr reps per condition per block, there is random jitter of 0-2 in generateCondList.m

%set viewing parameters
s.stimulus.fullField = 0; %may be a vector [1 0]
s.stimulus.radius=stimsize; %stimulus radius in deg
s.stimulus.sigma=2*s.stimulus.radius/16.5;
s.stimulus.maskLimit=.6*s.stimulus.radius; %switch from open mask to exponential function
s.stimulus.duration.ITI = 2;
%set up the viewing distance
s.display.viewdist = 55; 

% avoid using adc, comment out for adc IR
s.datapixx.adc.channels = [];
s.datapixx.din.useFor.ports = 1;
s.datapixx.dio.useForReward = 1;
s.datapixx.adc.useForReward = 0;

%savapath
s.	pldaps.	dirs.	data = datafolder;
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