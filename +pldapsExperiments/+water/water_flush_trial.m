function water_flush_trial(p,state)
%flush water system

%use normal functionality in states
pldapsDefaultTrialFunction(p,state);

%add functions to particular states
switch state
    case p.trial.pldaps.trialStates.trialSetup
        %trialSetup(p);
        p.trial.state=p.trial.stimulus.states.START;
        
    case p.trial.pldaps.trialStates.framePrepareDrawing
        
        %check port status and set states accordingly
        checkState(p);
                
end


 

%-------------------------------------------------------------------%
%check port status and set events accordingly
function p=checkState(p)

activePort=find(p.trial.ports.status==1);

switch p.trial.state
    case p.trial.stimulus.states.START %trial started
 
            p.trial.state=p.trial.stimulus.states.STIMON;
        
    case p.trial.stimulus.states.STIMON %stimulus shown; port selected in response

        if activePort==p.trial.stimulus.port.LEFT
            %deliver reward
            amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT);
            pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.LEFT);
            p.trial.stimulus.timeTrialFinalResp = p.trial.ttime;
            p.trial.state=p.trial.stimulus.states.CORRECT;

        end

        if activePort==p.trial.stimulus.port.RIGHT
            %deliver reward
            amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT);
            pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.RIGHT);
            p.trial.stimulus.timeTrialFinalResp = p.trial.ttime;
            p.trial.state=p.trial.stimulus.states.CORRECT;

        end

        if activePort==p.trial.stimulus.port.START
            %deliver reward
            amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.START);
            pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.START);
            p.trial.stimulus.timeTrialFinalResp = p.trial.ttime;
            p.trial.state=p.trial.stimulus.states.CORRECT;

        end

                  
    case p.trial.stimulus.states.CORRECT %correct port selected for stimulus
        %wait for ITI
        if p.trial.ttime > p.trial.stimulus.timeTrialFinalResp + p.trial.stimulus.duration.ITI
            
            %advance state, mark as correct trial and flag next trial
            p.trial.state=p.trial.stimulus.states.TRIALCOMPLETE;
            p.trial.pldaps.goodtrial = 1;
            p.trial.flagNextTrial = true;
        end

end
        

        



  

