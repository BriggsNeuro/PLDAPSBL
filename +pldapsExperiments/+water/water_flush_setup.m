function p=water_flush_setup(p)
%flush water through system
%% basic definitions
p = pdsDefaultTrialStructureBL(p); 

%% set the trial function: the function that gets called for each frame state
p.trial.pldaps.trialFunction='pldapsExperiments.water.water_flush_trial';

%% set general parameters
p.trial.stimulus.forceCorrect = 1;

%% set timing parameters
p.trial.stimulus.duration.ITI = 0.5; %ITI in s


%% conditions: just need fake conditions to make pldaps happy
cond.color=[0 1]; %use squares of 2 colors
side.par='color';
side.match=[0 1];

c=generateCondList(cond,side,'pseudo',200);

p.conditions=c;

p.trial.pldaps.finish = length(p.conditions);



