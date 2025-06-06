function p=ori_setup_free_SZ(p)
%experiment setup file for a simple test experiment

%% basic definitions
p = pdsDefaultTrialStructureNL(p); 

%% set the trial function: the function that gets called for each frame state
p.trial.pldaps.trialFunction='pldapsExperiments.ori.oritrial_free_SZ';

%% set general parameters
p.trial.stimulus.forceCorrect = p.defaultParameters.stimulus.forceCorrect;

%% set timing parameters
p.trial.stimulus.duration.ITI = p.defaultParameters.stimulus.duration.ITI; %ITI in s


%% conditions:
side.par = 'angle';
side.match = [90 0];
% side.par = 'LeftRight';
% side.match = [2 1]; % the sequence in s.stimulus.LeftRight need to be switched 

for i = 1:length(p.defaultParameters.stimulus.fullField)
    cond(i).sf = p.defaultParameters.stimulus.sf;
%     cond(i).sf_final = p.defaultParameters.stimulus.sf;
%     cond(i).sfadd = 0;
%     cond(i).LeftRight = p.defaultParameters.stimulus.LeftRight;
    cond(i).locationjitter = p.defaultParameters.stimulus.locationjitter;
    cond(i).centralflash = p.defaultParameters.stimulus.centralflash;
    cond(i).angle = p.defaultParameters.stimulus.angle;
    cond(i).range_mean = p.defaultParameters.stimulus.range_mean;
    cond(i).range_meanadd = 0;
    cond(i).select = p.defaultParameters.stimulus.select;
%     if ~strcmp(p.trial.stimulus.step,'var')
%         cond(i).range_var = p.defaultParameters.stimulus.range_var_source;
%     end
    cond(i).range_varadd = 0;
    cond(i).radius = p.defaultParameters.stimulus.radius;
    cond(i).radius_final = p.defaultParameters.stimulus.radius;
    cond(i).radiusadd = 0;
    cond(i).pretime = p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretime_final = p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretimeadd = 0;
    cond(i).rangeC = 0;
    cond(i).tf = p.defaultParameters.stimulus.tf;
    cond(i).tf_final = p.defaultParameters.stimulus.tf;
    cond(i).tfadd = 0;
%     cond(i).rangeI = 0;
%     cond(i).rangeC = p.defaultParameters.stimulus.range_mean + p.defaultParameters.stimulus.range_var;
%     cond(i).rangeI = p.defaultParameters.stimulus.range_mean - p.defaultParameters.stimulus.range_var;
    if length(p.defaultParameters.stimulus.fullField) > 1
        cond(i).fullField = p.defaultParameters.stimulus.fullField(i);
    else
        cond(i).fullField = p.defaultParameters.stimulus.fullField;
    end
    % c{i} =
    % generateCondList_sides(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks,
    % p.defaultParameters.stimulus.nrReps); _side makes pseudorandom less
    % predictable
    c{i} = generateCondList(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks, p.defaultParameters.stimulus.nrReps, p.defaultParameters.stimulus.jitter);
end

for i = 2
    cond(i).sf = p.defaultParameters.stimulus.sf;
%     cond(i).sf_final = p.defaultParameters.stimulus.sf;
%     cond(i).sfadd = 0;
%     cond(i).LeftRight = p.defaultParameters.stimulus.LeftRight;
    cond(i).locationjitter = p.defaultParameters.stimulus.locationjitter;
    cond(i).centralflash = p.defaultParameters.stimulus.centralflash;
    cond(i).angle = p.defaultParameters.stimulus.angle;
    cond(i).range_mean = p.defaultParameters.stimulus.range_mean;
    cond(i).range_meanadd = 0;
    cond(i).select = p.defaultParameters.stimulus.select;
%     if ~strcmp(p.trial.stimulus.step,'var')
%         cond(i).range_var = p.defaultParameters.stimulus.range_var_source;
%     end
    cond(i).range_varadd = 0;
    cond(i).radius = p.defaultParameters.stimulus.radius;
    cond(i).radius_final = p.defaultParameters.stimulus.radius;
    cond(i).radiusadd = 0;
    cond(i).pretime = 0.2; %p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretime_final = p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretimeadd = 0;
    cond(i).rangeC = 0;
    cond(i).tf = p.defaultParameters.stimulus.tf;
    cond(i).tf_final = p.defaultParameters.stimulus.tf;
    cond(i).tfadd = 0;
%     cond(i).rangeI = 0;
%     cond(i).rangeC = p.defaultParameters.stimulus.range_mean + p.defaultParameters.stimulus.range_var;
%     cond(i).rangeI = p.defaultParameters.stimulus.range_mean - p.defaultParameters.stimulus.range_var;
    if length(p.defaultParameters.stimulus.fullField) > 1
        cond(i).fullField = p.defaultParameters.stimulus.fullField(i);
    else
        cond(i).fullField = p.defaultParameters.stimulus.fullField;
    end
    % c{i} =
    % generateCondList_sides(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks,
    % p.defaultParameters.stimulus.nrReps); _side makes pseudorandom less
    % predictable
    c{i} = generateCondList(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks, p.defaultParameters.stimulus.nrReps, p.defaultParameters.stimulus.jitter);
end

for i = 3
    cond(i).sf = p.defaultParameters.stimulus.sf;
%     cond(i).sf_final = p.defaultParameters.stimulus.sf;
%     cond(i).sfadd = 0;
%     cond(i).LeftRight = p.defaultParameters.stimulus.LeftRight;
    cond(i).locationjitter = p.defaultParameters.stimulus.locationjitter;
    cond(i).centralflash = p.defaultParameters.stimulus.centralflash;
    cond(i).angle = p.defaultParameters.stimulus.angle;
    cond(i).range_mean = p.defaultParameters.stimulus.range_mean;
    cond(i).range_meanadd = 0;
    cond(i).select = p.defaultParameters.stimulus.select;
%     if ~strcmp(p.trial.stimulus.step,'var')
%         cond(i).range_var = p.defaultParameters.stimulus.range_var_source;
%     end
    cond(i).range_varadd = 0;
    cond(i).radius = p.defaultParameters.stimulus.radius;
    cond(i).radius_final = p.defaultParameters.stimulus.radius;
    cond(i).radiusadd = 0;
    cond(i).pretime = 0.25; %p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretime_final = p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretimeadd = 0;
    cond(i).rangeC = 0;
    cond(i).tf = p.defaultParameters.stimulus.tf;
    cond(i).tf_final = p.defaultParameters.stimulus.tf;
    cond(i).tfadd = 0;
%     cond(i).rangeI = 0;
%     cond(i).rangeC = p.defaultParameters.stimulus.range_mean + p.defaultParameters.stimulus.range_var;
%     cond(i).rangeI = p.defaultParameters.stimulus.range_mean - p.defaultParameters.stimulus.range_var;
    if length(p.defaultParameters.stimulus.fullField) > 1
        cond(i).fullField = p.defaultParameters.stimulus.fullField(i);
    else
        cond(i).fullField = p.defaultParameters.stimulus.fullField;
    end
    % c{i} =
    % generateCondList_sides(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks,
    % p.defaultParameters.stimulus.nrReps); _side makes pseudorandom less
    % predictable
    c{i} = generateCondList(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks, p.defaultParameters.stimulus.nrReps, p.defaultParameters.stimulus.jitter);
end

for i = 4
    cond(i).sf = p.defaultParameters.stimulus.sf;
%     cond(i).sf_final = p.defaultParameters.stimulus.sf;
%     cond(i).sfadd = 0;
%     cond(i).LeftRight = p.defaultParameters.stimulus.LeftRight;
    cond(i).locationjitter = p.defaultParameters.stimulus.locationjitter;
    cond(i).centralflash = p.defaultParameters.stimulus.centralflash;
    cond(i).angle = p.defaultParameters.stimulus.angle;
    cond(i).range_mean = p.defaultParameters.stimulus.range_mean;
    cond(i).range_meanadd = 0;
    cond(i).select = [7 9 11];
%     if ~strcmp(p.trial.stimulus.step,'var')
%         cond(i).range_var = p.defaultParameters.stimulus.range_var_source;
%     end
    cond(i).range_varadd = 0;
    cond(i).radius = p.defaultParameters.stimulus.radius;
    cond(i).radius_final = p.defaultParameters.stimulus.radius;
    cond(i).radiusadd = 0;
    cond(i).pretime = 0.3; %p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretime_final = p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretimeadd = 0;
    cond(i).rangeC = 0;
    cond(i).tf = p.defaultParameters.stimulus.tf;
    cond(i).tf_final = p.defaultParameters.stimulus.tf;
    cond(i).tfadd = 0;
%     cond(i).rangeI = 0;
%     cond(i).rangeC = p.defaultParameters.stimulus.range_mean + p.defaultParameters.stimulus.range_var;
%     cond(i).rangeI = p.defaultParameters.stimulus.range_mean - p.defaultParameters.stimulus.range_var;
    if length(p.defaultParameters.stimulus.fullField) > 1
        cond(i).fullField = p.defaultParameters.stimulus.fullField(i);
    else
        cond(i).fullField = p.defaultParameters.stimulus.fullField;
    end
    % c{i} =
    % generateCondList_sides(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks,
    % p.defaultParameters.stimulus.nrReps); _side makes pseudorandom less
    % predictable
    c{i} = generateCondList(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks, p.defaultParameters.stimulus.nrReps, p.defaultParameters.stimulus.jitter);
end

for i = 5
    cond(i).sf = p.defaultParameters.stimulus.sf;
%     cond(i).sf_final = p.defaultParameters.stimulus.sf;
%     cond(i).sfadd = 0;
%     cond(i).LeftRight = p.defaultParameters.stimulus.LeftRight;
    cond(i).locationjitter = p.defaultParameters.stimulus.locationjitter;
    cond(i).centralflash = p.defaultParameters.stimulus.centralflash;
    cond(i).angle = p.defaultParameters.stimulus.angle;
    cond(i).range_mean = p.defaultParameters.stimulus.range_mean;
    cond(i).range_meanadd = 0;
    cond(i).select = [5 7 9 11];
%     if ~strcmp(p.trial.stimulus.step,'var')
%         cond(i).range_var = p.defaultParameters.stimulus.range_var_source;
%     end
    cond(i).range_varadd = 0;
    cond(i).radius = p.defaultParameters.stimulus.radius;
    cond(i).radius_final = p.defaultParameters.stimulus.radius;
    cond(i).radiusadd = 0;
    cond(i).pretime = p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretime_final = p.defaultParameters.stimulus.duration.pretime;
    cond(i).pretimeadd = 0;
    cond(i).rangeC = 0;
    cond(i).tf = p.defaultParameters.stimulus.tf;
    cond(i).tf_final = p.defaultParameters.stimulus.tf;
    cond(i).tfadd = 0;
%     cond(i).rangeI = 0;
%     cond(i).rangeC = p.defaultParameters.stimulus.range_mean + p.defaultParameters.stimulus.range_var;
%     cond(i).rangeI = p.defaultParameters.stimulus.range_mean - p.defaultParameters.stimulus.range_var;
    if length(p.defaultParameters.stimulus.fullField) > 1
        cond(i).fullField = p.defaultParameters.stimulus.fullField(i);
    else
        cond(i).fullField = p.defaultParameters.stimulus.fullField;
    end
    % c{i} =
    % generateCondList_sides(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks,
    % p.defaultParameters.stimulus.nrReps); _side makes pseudorandom less
    % predictable
    c{i} = generateCondList(cond(i),side,p.defaultParameters.stimulus.runtype,p.defaultParameters.stimulus.nrBlocks, p.defaultParameters.stimulus.nrReps, p.defaultParameters.stimulus.jitter);
end

p.trial.allconditions = c;
p.trialMem.whichConditions = 0;
p.trialMem.practice = p.defaultParameters.stimulus.practice;
% p.trialMem.repractice = 0;
p.trialMem.higheststep = p.defaultParameters.stimulus.higheststep;
p.trialMem.loweststep = p.defaultParameters.stimulus.loweststep;
p.conditions=p.trial.allconditions{p.trialMem.whichConditions + 1};
p.trial.pldaps.finish = length(p.conditions);
p.trialMem.amountDelta = p.defaultParameters.behavior.reward.amountDelta;
% block
p.trialMem.nrReps = p.defaultParameters.stimulus.nrReps;
p.trialMem.nrReps_new = p.trialMem.nrReps;
p.trialMem.nrReps_save = p.trialMem.nrReps;
p.trialMem.jitter = p.defaultParameters.stimulus.jitter;
p.trialMem.locationjitter = p.defaultParameters.stimulus.locationjitter;
p.trialMem.side = side;
%% display stats
p.trialMem.stats.cond={'angle','radius_final','rangeC','pretime_final'}; %conditions to display; in oritrial file, for those going to be displayed in the command window, add to p.condition{p.trial.pldaps.iTrial}, otherwise counting doesn't work
switch p.trial.stimulus.step
    case {'var',0}
        [A,B,C,D] = ndgrid(unique(horzcat(cond(1).angle)),unique(horzcat(cond(1).radius_final)),unique(horzcat(cond(1).range_mean+p.defaultParameters.stimulus.range_var_source(cond(1).select))),unique(p.defaultParameters.stimulus.duration.pretime));%cond(1).range_mean+cond(1).range_var
    case 'radius'
        [A,B,C,D] = ndgrid(unique(horzcat(cond(1).angle)),unique(horzcat(cond(1).radius(cond(1).select))),unique(horzcat(cond(1).range_mean+p.defaultParameters.stimulus.range_var_source)),unique(p.defaultParameters.stimulus.duration.pretime));
end
p.trialMem.stats.val = [A(:),B(:),C(:),D(:)]';
% remove combinations that never exist
% E = [C(:)] + [D(:)] - cond(i).range_mean .* 2;
% p.trialMem.stats.val = p.trialMem.stats.val(:,find(~E));
p.trialMem.stats.val  = (sortrows(p.trialMem.stats.val',[3,4,2,1],{'ascend','ascend', 'ascend' 'ascend'}));
p.trialMem.stats.val = p.trialMem.stats.val';
p.trialMem.stable = p.trialMem.stats.val(1:2,1:2);
% if size(p.trialMem.stats.val,2) == 18
%     p.trialMem.stats.val = p.trialMem.stats.val(:,[5,6,9,10,13,14]);
%     p.trialMem.stable = p.trialMem.stats.val(1:2,1:2);
% end
% if size(p.trialMem.stats.val,2) == 8
%     p.trialMem.stats.val = p.trialMem.stats.val(:,[3,4,5,6]);
%     p.trialMem.stable = p.trialMem.stats.val(1:2,1:2);
% end
% prepare for adding new combination if the difficulty is manually adjusted
% supposedsize = length(cond.LeftRight) .* length(cond.range_mean) .* length(cond.range_var);
% if size(p.trialMem.stats.val,2) ~= supposedsize
%     sizecorrection = size(p.trialMem.stats.val,2)./supposedsize;
%     p.trialMem.stats.val_1 = []
%     for i = 1: sizecorrection
%         p.trialMem.stats.val_1 = [p.trialMem.stats.val_1 p.trialMem.stats.val(:,[sizecorrection.*2.*i-1,sizecorrection.*2.*i])];
%         p.trialMem.stats.val = p.trialMem.stats.val_1;
%     end
% end

nCond=size(p.trialMem.stats.val,2);
p.trialMem.stats.count.correct=zeros(1,nCond);
p.trialMem.stats.count.incorrect=zeros(1,nCond);
p.trialMem.stats.count.Ntrial=zeros(1,nCond);