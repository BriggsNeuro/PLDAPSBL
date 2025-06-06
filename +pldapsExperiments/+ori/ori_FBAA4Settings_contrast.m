function s = ori_FBAA4Settings_contrast(Animal,savedata,rewardamounts,trialblocks,displaytime,stimsize,stimposition,numgratings,contrastlevels,datafolder)

%Grating parameters
switch numgratings
    case 1
        s.stimulus.step = 'contrast';
        s.stimulus.locationjitter = stimposition; %stimulus position but only works for 1 grating (stimulus.step ~= 0) set to +10 for 10 degree rightward position shift - DO NOT USE 1 or put multiple numbers here
    case 2
        s.stimulus.step = 0;
        s.stimulus.locationjitter = 0;
end
s.stimulus.radius= stimsize;
s.stimulus.jitter = 0;

s.stimulus.range_var_source = round(logspace(log10(9.2044),log10(56.8107*2),19),2); %until 6/26/2023: [round(logspace(log10(21.2725),log10(56.8107*2),13),2) 121];%[round(logspace(log10(14.0625*2),log10(56.8107*2),11),2) 121]; %[round(logspace(log10(11.61),log10(100),11),2) 121]; %round(logspace(log10(7),log10(100),11),2); round(logspace(log10(5),log10(63.5),12),2);
s.stimulus.select = contrastlevels; %This is range of contrasts per animal from line 14 definition (note: 19 is >100%)
%may also need to include in the inputs whether you want to vary TF,
s.stimulus.duration.pretime = displaytime; %stimulus presentation time
s.stimulus.range = [121]; %contrast, range between 1 and 127, may be a vector

%Trial-task parameters
s.stimulus.higheststep = 10;
s.stimulus.loweststep = 1;
s.stimulus.staircasestep = 3;
s.stimulus.preventSwitch3Times = 0;
s.stimulus.preventMaintain4Times = 0;

%reward parameters
s.behavior.reward.amount =  rewardamounts; %[0.07 0.32 0.28](Waffle)

%%%%%%%%%%%%%%%%%
% training 2 - block
s.stimulus.runtype = trialblocks; %change to 'block' for block trials, 'pseudo6' for pseudorandom without switch bias, 'rand' for random
s.stimulus.nrReps = 5;
s.stimulus.nrBlocks = 32;
%%%%%%%%%%%%%%%%%%
% % turn saving on or off
s.pldaps.nosave = savedata;
s.pldaps.dirs.data = datafolder; % FB updated based on initialization code - 9/26/24

% specifically for diff animals

switch Animal
    case 'New'
        s.behavior.reward.increaseSince = 40; % !! Muffin: 45
        s.behavior.reward.increaseTimes = 3; %reward amount increased by 3 * 0.025 sec
%         s.stimulus.difficultLevels = [7 10];
%         s.stimulus.difficultLevelsProbability = 0.3; % 0.3
        s.stimulus.range_mean = [0]; 
        s.stimulus.duration.pretime_var_source = s.stimulus.duration.pretime; 
        s.stimulus.staircasepause = 1;
        s.stimulus.centralflash = 0;
        s.stimulus.sf = [0.2]; % cycles per degree, may be a vector 
        s.stimulus.tf = 0;
        s.stimulus.block = 0;
        s.stimulus.pretimehelp = 0;
        s.stimulus.higheststep = 19;
        s.stimulus.loweststep = 1;
        %s.stimulus.difficultLevels = [1 4];
        %s.stimulus.difficultLevelsProbability = 0.15;
    case 'New2' %longer delay before increase reward, different contrast mean, staircase pause=0,
        s.behavior.reward.increaseSince = 70; %increae reward since trial 70
        s.behavior.reward.increaseTimes = 3; %reward amount increased by 3 * 0.025 sec
        s.stimulus.range_mean = [65/2]; %[49.4] till 8/29/2022: [65/2]; %80 %(95 + 10)/2 (86 + 18)/2 (127 + 1)/2
        s.stimulus.duration.pretime_var_source = s.stimulus.duration.pretime; 
        s.stimulus.centralflash = 1;
        s.stimulus.staircasepause = 0;
        s.stimulus.sf = [0.2]; % cycles per degree, may be a vector
        s.stimulus.tf = 0;
        s.stimulus.pretimehelp = 0;
        %s.display.heightcm = 20; %use 20 since 1/17/23 to make grating cover larger vertical space
    case 'Vary Contrast levels'
        s.stimulus.range_var_source = round(logspace(log10(5),log10(63.5),12),2);
        s.behavior.reward.increaseSince = 50;
        s.behavior.reward.increaseTimes = 2; 
        s.stimulus.range_mean = [63.5]; 
        s.stimulus.duration.pretime_var_source = s.stimulus.duration.pretime; 
        s.stimulus.centralflash = 1;
        s.stimulus.staircasepause = 0;
        s.stimulus.sf = [0.2]; 
        s.stimulus.tf = 0;
        s.stimulus.pretimehelp = 0;
        s.stimulus.step = 0;
    case 'One contrast vary display time'
        s.behavior.reward.increaseSince = 70;
        s.behavior.reward.increaseTimes = 3;
        s.stimulus.range_var_source = 24.58; %32.5
        s.stimulus.range_mean = [65/2]; %[65/2]; %80 %(95 + 10)/2 (86 + 18)/2 (127 + 1)/2
        s.stimulus.duration.pretime_var_source = linspace(-0.2, 0.35,12);%previous: logspace(log10(0.2199),log10(0.3886),12); % previous: logspace(log10(0.3),log10(0.53),12)
        s.stimulus.staircasepause = 1;
        s.stimulus.centralflash = 1;
        s.stimulus.sf = [0.2]; % cycles per degree, may be a vector 
        s.stimulus.tf = 0;
        s.stimulus.pretimehelp = 1;

    case 'Different contrast range'
        s.behavior.reward.increaseSince = 55;
        s.behavior.reward.increaseTimes = 2;
        s.stimulus.range_var_source = [12.17 16.09 21.2700 28.12 49.1600 65.0000 85.9400 113.6200 121]; % until 11/30/2023: [round(logspace(log10(21.2725),log10(56.8107*2),13),2) 121]; %until 5/11/2023: [round(logspace(log10(14.0625*2),log10(56.8107*2),11),2) 121]; %[round(logspace(log10(11.61),log10(100),11),2) 121]; %round(logspace(log10(7),log10(100),11),2)
        s.stimulus.tf = 0;
        s.stimulus.select = [2 4 5 6 7 8];%[2 4 5 6 7 8]; %Muffin: [12]; toast: 1 3 9 11 13
        s.stimulus.staircasepause = 1;  %0
        s.stimulus.staircasestep = 1;
        s.stimulus.higheststep = 7;
        s.stimulus.loweststep = 1;
        s.stimulus.range_mean = [0]; 
        s.stimulus.duration.pretime_var_source = s.stimulus.duration.pretime; 
        s.stimulus.centralflash = 1;
        s.stimulus.sf = [0.2]; % cycles per degree, may be a vector 
        s.stimulus.nrBlocks = s.stimulus.nrBlocks./length(s.stimulus.tf); 
        s.stimulus.pretimehelp = 0.05;
%         s.stimulus.difficultLevels = [1 4];
%         s.stimulus.difficultLevelsProbability = 0.15;
        %s.display.heightcm = 20; %use 20 since 1/17/23 to make grating cover larger vertical space
    case 'Not sure what this is for'
        s.behavior.reward.increaseSince = 55;
        s.behavior.reward.increaseTimes = 2;
        s.stimulus.tf = 0;
        s.stimulus.staircasepause = 1;
        s.stimulus.staircasestep = 1;
        s.stimulus.higheststep = 6;
        s.stimulus.loweststep = 1;
        s.stimulus.range_mean = [120/2]; 
        s.stimulus.duration.pretime_var_source = s.stimulus.duration.pretime; 
        s.stimulus.centralflash = 1;
        s.stimulus.sf = [0.2]; % cycles per degree, may be a vector 
        s.stimulus.nrBlocks = s.stimulus.nrBlocks./length(s.stimulus.tf); 
        s.stimulus.pretimehelp = 0.05;
        s.stimulus.step = 0;
%         s.stimulus.difficultLevels = [1 4];
%         s.stimulus.difficultLevelsProbability = 0.15;

    case 'Vary tf'
        s.stimulus.range_mean = [0]; 
        s.stimulus.duration.pretime_var_source = s.stimulus.duration.pretime; 
        s.stimulus.staircasepause = 1;
        s.stimulus.centralflash = 1;
        s.stimulus.sf = [0.2]; % cycles per degree, may be a vector 
        s.stimulus.tf = [0];
        s.stimulus.nrBlocks = s.stimulus.nrBlocks./length(s.stimulus.tf); 
        s.stimulus.pretimehelp = 1;
        s.behavior.reward.increaseSince = 70;
        s.behavior.reward.increaseTimes = 3;
%         s.stimulus.preventSwitch3Times = 1;
%         s.stimulus.preventMaintain4Times = 1;
%         s.stimulus.difficultLevels = [2 4];
%         s.stimulus.difficultLevelsProbability = 0.3; % 0.3
%         s.stimulus.difficultLevelsPretime = 0.27;
%         s.stimulus.difficultLevelsRadius = 9;
        %s.display.heightcm = 20; %use 20 since 1/17/23 to make grating cover larger vertical space
    case 'Vary stim size' 
        s.stimulus.range_mean = [49.4]; %[49.4] till 8/29/2022: [65/2]; %80 %(95 + 10)/2 (86 + 18)/2 (127 + 1)/2
        s.stimulus.duration.pretime_var_source = s.stimulus.duration.pretime; 
        s.stimulus.nrBlocks = 8;
        s.stimulus.centralflash = 1;
        s.stimulus.sf = [0.1]; % cycles per degree, may be a vector 
        s.stimulus.tf = 0;
        s.stimulus.pretimehelp = 1;
end

s.stimulus.midpointOpto = 1;
s.midpointreset = 0;
s.stimulus.practice = 3; % number of practice trials, 6 until 3/10/2023
% s.stimulus.tailbreakmidpoint = 1; % Male ferrets' tail can break midpoint while they lick the rear port.
%set orientation and offsets
s.stimulus.LeftRight = [1 2]; % 1 is left, 2 is right, side matched
s.stimulus.angle = [0]; 
s.stimulus.t_period = 0;

% s.stimulus.rangeC = [30, 75, 121]; %contrast, range between 1 and 127, may be a vector
% s.stimulus.rangeI = [10];

s.stimulus.midpointIR = 1; %use midpoint IR beam to turn ON stimulus
s.stimulus.forceCorrect = 0;
% s.stimulus.block = 1;
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



%% Uncomment to use debug mode:
% %turn mouse input on
s.mouse.useAsPort = 1;
s.mouse.use = 1;
% % turn reward off
% s.behavior.reward.amount =  [0.0 0.0 0.0];
% % reduce practice trial
% s.stimulus.practice = 1;
% 

% 
% %turn adc channels off
% s.datapixx.useAsPorts = 0;
% s.datapixx.adc.channels = [];