function s = ori_FBAA4Settings_SZ(savedata,trialblocks,rewardamounts,displaytime,stimsize,numgratings,stimposition,datafolder)
%%%%%%%%%%%%%%%%%
% training 2 - block
s.stimulus.runtype = trialblocks; %change to 'block' for block trials, 'pseudo8' for pseudorandom without switch bias, 'rand' for random
%%%%%%%%%%%%%%%%%%
% turn saving off
s.pldaps.nosave = savedata;
s.pldaps.dirs.data = datafolder; % FB updated based on initialization code - 9/26/24
% specifically for diff animals
s.behavior.reward.amount =  rewardamounts;  %[0.06 0.24 0.24](orange) [0.06 0.27 0.32](waffle) [0.06 0.4 0.35](pancake) % [0.06 0.22 0.22](orange) [0.06 0.205 0.255](waffle) [0.06 0.29 0.24](pancake) % Erika: [0.15 0.35 0.35]
s.behavior.reward.increaseSince = 60;
s.behavior.reward.increaseTimes = 3;
s.stimulus.duration.pretime = displaytime; %[0.15 0.2 0.25 0.3] % in sec, 0 means infinite presentation time 
s.stimulus.nrBlocks = 32; %nr blocks for all conditions
s.stimulus.radius= stimsize; %[10:2:30];  % cycles per degree, may be a vector % SZ: this is actually 2*diameter, not radius, because we limit it to 1/4 of the screen. 20 value: 11 cm diameter horitzonal, 13 cm vertical,about 11 visual angle. 8 degree is about the size of V1 neurons.
s.stimulus.block = 0;
s.stimulus.nrReps = 3; %nr reps per condition per block, a random jitter of 0-2 can be added in generateCondList.m
%set orientation and offsets
s.midpointreset = 0;
s.stimulus.sf = [0.2]; % cycles per degree, may be a vector % SZ: this is actually 1/2 of the real sf, because we limit it to 1/4 of the screen.
s.stimulus.centralflash = 0;
s.stimulus.angle = [0 90]; 
s.stimulus.range_mean = [65/2+62]; %[65/2]; %80 %(95 + 10)/2 (86 + 18)/2 (127 + 1)/2
s.stimulus.range_var_source = round(logspace(log10(5.5607),log10(65/2),12),2); % 40 %[20.0800]; % round(logspace(log10(5.5607),log10(65/2),12),2); 
s.stimulus.higheststep = 11;
s.stimulus.loweststep = 1;
% s.stimulus.rangeC = [30, 75, 121]; %contrast, range between 1 and 127, may be a vector
% s.stimulus.rangeI = [10];
 
s.stimulus.midpointIR = 1; %use midpoint IR beam to turn ON stimulus
switch numgratings
    case 1
        s.stimulus.step = 0;
        s.stimulus.locationjitter = stimposition; %stimulus position but only works for 1 grating (stimulus.step ~= 0) set to +10 for 10 degree rightward position shift - DO NOT USE 1 or put multiple numbers here
    case 2
        s.stimulus.step = 0;
        s.stimulus.locationjitter = 0;
end
s.stimulus.forceCorrect = 0;
s.midpointreset = 1;
s.stimulus.tf = 0;


s.stimulus.select =  [12]; %use a single contrast in the middle of range
s.stimulus.practice = 3; % number of practice trials, 10

s.stimulus.locationjitterY = 10;
s.stimulus.midpointOpto = 1;
s.stimulus.jitter  =0;

%set viewing parameters
s.stimulus.fullField = 0; %may be a vector [1 0]
s.stimulus.sigma=2*s.stimulus.radius/16.5;
s.stimulus.maskLimit=.6*s.stimulus.radius; %switch from open mask to exponential function
s.stimulus.duration.ITI = 1.5;
%set up the viewing distance
s.display.viewdist = 55; 


% avoid using adc, comment out for adc IR
s.datapixx.adc.channels = [];
s.datapixx.din.useFor.ports = 1;
s.datapixx.dio.useForReward = 1;
s.datapixx.adc.useForReward = 0;


% %
% % Debugging settings % currently can't see the mouse and port, don't know why (makePortsPos.m) - SZ
% % 
%turn adc channels off
% s.datapixx.useAsPorts = 0;
% s.datapixx.adc.channels = [];
% 
% %turn mouse input on
% s.mouse.useAsPort = 1;
% s.mouse.use = 1;
