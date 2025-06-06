function oritrial_free_SZ(p,state)
%%%% Note: includes staircase functionality for spatial frequency. Set
%%%% stimulus.step = 0 in settings file to suppress staircase. 

%use normal functionality in states
pldapsDefaultTrialFunction(p,state);

%add functions to particular states
switch state
    case p.trial.pldaps.trialStates.trialSetup
        trialSetup(p);
        
    case p.trial.pldaps.trialStates.framePrepareDrawing
        
        %check port status and set states accordingly
        checkState(p);
        
    case p.trial.pldaps.trialStates.frameDraw
        if p.trial.screenoff && p.trial.state == p.trial.stimulus.states.START
            % Screen(p.trial.display.ptr,'Close')
            Screen(p.trial.display.ptr,'FillRect',0);
        end
        if p.trial.state==p.trial.stimulus.states.START && ~p.trial.screenoff
            Screen(p.trial.display.ptr, 'FillRect', 0.5)
        elseif p.trial.state==p.trial.stimulus.states.STIMON || (p.trial.state==p.trial.stimulus.states.INCORRECT && p.trial.stimulus.forceCorrect ~= 0)
            if p.trial.stimulus.midpointIR 
                if ~p.trial.stimulus.midpointCrossed
                   Screen(p.trial.display.ptr, 'FillRect', 0.5)
                elseif p.trial.stimulus.midpointCrossed == 1 && ~isfield(p.trial.stimulus,'timemidpointCrossed')
                        Screen('DrawTexture',p.trial.display.ptr,p.trial.gratTexC,[],p.trial.gratPosC,0);
                        if p.conditions{p.trial.pldaps.iTrial}.centralflash %&& ((p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd) == 5) % substite level 5 with central flash
                            Screen('DrawTexture',p.trial.display.ptr,p.trial.gratTexCentral,[],p.trial.gratPosCentral,0);
                        end
                elseif p.trial.stimulus.duration.pretime_final~=0 && p.trial.ttime >= p.trial.stimulus.timemidpointCrossed + p.trial.stimulus.duration.pretime_final
                        Screen(p.trial.display.ptr, 'FillRect', 0.5)
                        if p.trial.ttime <= p.trial.stimulus.timemidpointCrossed + 2*p.trial.stimulus.duration.pretime_final % no need to do that long time
                            digital_out(p.trial.behavior.optogenetics.channel,0); %also turn off opto here
                            digital_out(p.trial.behavior.outputtimestamp.channel,0);
                        end
                else
                    Screen('DrawTexture',p.trial.display.ptr,p.trial.gratTexC,[0  0+p.trial.stimulus.locationjitterY p.trial.display.screenSize(3) p.trial.display.screenSize(4)+p.trial.stimulus.locationjitterY],p.trial.gratPosC,0);
                    if p.conditions{p.trial.pldaps.iTrial}.centralflash %&& ((p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd) == 5)
                        Screen('DrawTexture',p.trial.display.ptr,p.trial.gratTexCentral,[],p.trial.gratPosCentral,0);
                    end
                    % trigger LED here, so that it starts at the same time as visual stimulus
                    if p.trial.stimulus.midpointCrossed && p.trial.stimulus.midpointOpto == 1 && p.trial.ttime < p.trial.stimulus.timemidpointCrossed + p.trial.stimulus.duration.pretime_final/5 % no need to do that long time
                        if any(strcmp(p.trial.stimulus.step,{'pretime','contrast'}))
                            if mod(p.trial.pldaps.iTrial,2)  % TEMPORARILY use this code because of the connection we have
                                %amount=0.1;
                                %pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.MIDDLE); % this is not reward, but trigger of laser
                                digital_out(p.trial.behavior.optogenetics.channel,1);
                                %pause(amount);
                                %digital_out(p.trial.behavior.optogenetics.channel,0);
                            end
                        else
                            % digital_out(p.trial.behavior.optogenetics.channel,1); % commented out since 09/14/22
                        end
                    end
                end
            else
                Screen('DrawTexture',p.trial.display.ptr,p.trial.gratTexC,[0  0+p.trial.stimulus.locationjitterY p.trial.display.screenSize(3) p.trial.display.screenSize(4)+p.trial.stimulus.locationjitterY],p.trial.gratPosC,0);
                if p.conditions{p.trial.pldaps.iTrial}.centralflash %&& ((p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd) == 5)
                    Screen('DrawTexture',p.trial.display.ptr,p.trial.gratTexCentral,[],p.trial.gratPosCentral,0);
                end
            end
        end
     
    case p.trial.pldaps.trialStates.trialCleanUpandSave
        cleanUpandSave(p);
        
end


 

%-------------------------------------------------------------------%
%check port status and set events accordingly
function p=checkState(p)

activePort=find(p.trial.ports.status==1);

switch p.trial.state
    case p.trial.stimulus.states.START %trial started
        
        if p.trial.led.state==0
            %turn LED on
            pds.LED.LEDOn(p);
            p.trial.led.state=1;
            %note timepoint
            p.trial.stimulus.timeTrialLedOn = p.trial.ttime;
            p.trial.stimulus.frameTrialLedOn = p.trial.iFrame;
            %send trigger pulse to camera
            if p.trial.camera.use 
                pds.behavcam.triggercam(p,1);
                p.trial.stimulus.timeCamOn = p.trial.ttime;
                p.trial.stimulus.frameCamOn = p.trial.iFrame;
            end
        end
        
        if any(activePort==p.trial.stimulus.port.START) %start port activated
            %turn LED off
            if p.trial.led.state==1
                pds.LED.LEDOff(p);
                p.trial.led.state=0;
            end
            % Note first beam break for synchronization
            if ~isfield(p.trial.stimulus, 'timeTrialStartResp')
                p.trial.stimulus.timeTrialStartResp_First = p.trial.ttime;
                p.trial.stimulus.frameTrialStartResp_First = p.trial.iFrame;
%                 if p.trial.midpointOpto == 0
%                     digital_out(p.trial.behavior.optogenetics.channel,1);
%                     digital_out(p.trial.behavior.optogenetics.channel,0);
%                 end           
                % added since 09/14/22
                %if ~any(strcmp(p.trial.stimulus.step,{'pretime','contrast'}))
                    digital_out(p.trial.behavior.outputtimestamp.channel,1);
                %end
            end
            
            %note timepoint
            p.trial.stimulus.timeTrialStartResp = p.trial.ttime;
            p.trial.stimulus.frameTrialStartResp = p.trial.iFrame;
            
            %deliver reward
            amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.START);
            pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.START);
            
            %advance state
            if ~p.trial.stimulus.midpointIR
                p.trial.state=p.trial.stimulus.states.STIMON;
            else
                p.trial.state=p.trial.stimulus.states.PRESTIMON;
            end
            p.trial.stimulus.phase = mod(180, (rand < 0.5)*180 + 180);
        end
        
    case p.trial.stimulus.states.PRESTIMON
%         if p.trial.led.state==0
%             %turn LED on
%             pds.LED.LEDOn(p);
%             p.trial.led.state=1;
%         end
        
        if ~isfield(p.trial.stimulus,'timeTrialPreSTIMON') || ~isfield(p.trial.stimulus,'frameTrialPreSTIMON')
            p.trial.stimulus.timeTrialPreSTIMON = p.trial.stimulus.timeTrialStartResp;
            p.trial.stimulus.frameTrialPreSTIMON = p.trial.stimulus.frameTrialStartResp;
        end
        if any(activePort==p.trial.stimulus.port.START) % if rear port still activated
            %note timepoint
            p.trial.stimulus.timeTrialPreSTIMON = p.trial.ttime;
            p.trial.stimulus.frameTrialPreSTIMON = p.trial.iFrame;
        end
        if p.trial.ttime >= p.trial.stimulus.timeTrialPreSTIMON + 0.1 % till 3/28/2023: 0.5 s after last rear port break
            p.trial.state = p.trial.stimulus.states.STIMON;
        end   
        
    case p.trial.stimulus.states.STIMON %stimulus shown; port selected in response
        %check whether any port chosen
        if p.trial.stimulus.midpointIR && any(find(p.trial.ports.status==1) == p.trial.stimulus.port.MIDDLE) %check IR beam for box midpoint
            p.trial.stimulus.midpointCrossed = 1;
            %note timepoint
            if ~isfield(p.trial.stimulus,'timemidpointCrossed')
                p.trial.stimulus.timemidpointCrossed = p.trial.ttime;
                p.trial.stimulus.framemidpointCrossed = p.trial.iFrame;
                disp(['midpoint crossed!!!'])
            end
        end
        
        if length(p.trialMem.locationjitter) >= 10 && isfield(p.trial.stimulus,'framemidpointCrossed') && isfield(p.trial.stimulus,'timemidpointCrossed') 
            if p.trial.ttime - p.trial.stimulus.timemidpointCrossed < p.trial.stimulus.duration.pretime_final
                number_frame_during_pretime = round(1/p.trial.display.ifi) * (p.conditions{p.trial.pldaps.iTrial}.pretime + p.conditions{p.trial.pldaps.iTrial}.pretimeadd);
                p.trialMem.locationjitter_progress = linspace(p.trialMem.locationjitter(1),p.trialMem.locationjitter(end),number_frame_during_pretime);
                if ((p.trial.iFrame - p.trial.stimulus.framemidpointCrossed + 1) <= number_frame_during_pretime)
                    p.trial.stimulus.locationjitter = p.trialMem.locationjitter_progress(p.trial.iFrame - p.trial.stimulus.framemidpointCrossed + 1); 
                    p.trial.gratPosC = [(0 + p.trial.stimulus.locationjitter + 256) 0 (p.trial.display.screenSize(3) + p.trial.stimulus.locationjitter - 256 ) p.trial.display.screenSize(4)]; % change to your resolution - SZ
                end
            end
        end
        
        if p.trial.stimulus.midpointIR && isfield(p.trial.stimulus,'timemidpointCrossed') && ~any(find(p.trial.ports.status==1) == p.trial.stimulus.port.MIDDLE) 
            p.trial.stimulus.timemidpointCrossedend = p.trial.ttime;
            p.trial.stimulus.framemidpointCrossedend = p.trial.iFrame;
%             if ((p.trial.stimulus.timemidpointCrossedend - p.trial.stimulus.timemidpointCrossed) <= 0.1)   % if breaking is too short, probably tail break, rescue it
%                 if ~isfield(p.trial.stimulus,'reset')
%                    p.trial.stimulus.reset = [];
%                 end
%                 p.trial.stimulus.reset = [p.trial.stimulus.reset p.trial.stimulus.timemidpointCrossed];
%                 p.trial.stimulus = rmfield(p.trial.stimulus,'timemidpointCrossed');
%                 p.trial.stimulus.midpointCrossed = 0;  
%                 disp(['midpoint reset'])
% %                 p.trial.stimulus = rmfield(p.trial.stimulus,'timemidpointCrossed');
% %                 p.trial.stimulus.midpointCrossed = 0; 
% %                 if ~isfield(p.trial.stimulus,'reset')
% %                    p.trial.stimulus.reset = -1;
% %                 end
% %                 p.trial.stimulus.reset = p.trial.stimulus.reset + 1;
% %                 disp(['midpoint reset'])
%             end
        end
        
        % Drift grating
%         if p.trial.stimulus.t_period > 0 && isfield(p.trial.stimulus,'framemidpointCrossed') && isfield(p.trial.stimulus,'timemidpointCrossed') 
%             %shift per frame
%             p.trial.t_period = p.conditions{p.trial.pldaps.iTrial}.t_period;
%             p.trial.stimulus.pCycle=deg2pixNL(p,1/p.trial.stimulus.sf,'none',2);
%             if p.trial.t_period >0 
%                 p.trial.stimulus.dFrame=p.trial.stimulus.pCycle/p.trial.t_period;
%             else
%                 p.trial.stimulus.dFrame = 0;
%             end
%             yoffset = mod(((p.trial.iFrame - p.trial.stimulus.framemidpointCrossed + 1))*p.trial.stimulus.dFrame+p.trial.stimulus.phase/360*p.trial.stimulus.pCycle,p.trial.stimulus.pCycle*1.1);
% %             [] = [0 yoffset p.trial.stimulus.sN-1 yoffset + p.trial.stimulus.sN-1];
%             [] = [0 yoffset p.trial.gratPosC(3)-p.trial.gratPosC(1) yoffset + p.trial.gratPosC(4)-p.trial.gratPosC(2)];
%         else
%             [] = [];
%         end
        p.trial.stimulus.tf_final =  p.conditions{p.trial.pldaps.iTrial}.tf +  p.conditions{p.trial.pldaps.iTrial}.tfadd;
        if p.trial.stimulus.tf_final > 0 && isfield(p.trial.stimulus,'framemidpointCrossed') && isfield(p.trial.stimulus,'timemidpointCrossed') && (p.trial.ttime <= p.trial.stimulus.timemidpointCrossed + p.trial.stimulus.duration.pretime || p.trial.stimulus.duration.pretime == 0)
            % cycle of movement per frame
            tf = p.trial.stimulus.tf_final;
            dCycle = 1/Screen('FrameRate',2) * tf;
            % phase of movement per frame
            dPhase = dCycle * 360;
            % phase of each frame
            newPhase = mod(p.trial.stimulus.phase + p.trial.stimulus.direction * dPhase * (p.trial.iFrame - p.trial.stimulus.framemidpointCrossed + 1),360);
            sdom1=cos(p.trial.removelater.sdom-newPhase*pi/90);
            grating = sdom1.*p.trial.removelater.maskdom;
            gratingC = round(grating*p.trial.stimulus.rangeC) + 127;
%             gratingI = round(grating*p.trial.stimulus.rangeI) + 127;
            p.trial.gratTexC = Screen('MakeTexture',p.trial.display.ptr,gratingC);
            %p.trial.gratTexI = Screen('MakeTexture',p.trial.display.ptr,gratingI);
        elseif p.trial.stimulus.tf_final > 0 && isfield(p.trial.stimulus,'framemidpointCrossed') && isfield(p.trial.stimulus,'timemidpointCrossed') && p.trial.ttime > p.trial.stimulus.timemidpointCrossed + p.trial.stimulus.duration.pretime && isfield(p.trial.removelater,'sdom')  && p.trial.stimulus.duration.pretime ~= 0
            p.trial.removelater = rmfield(p.trial.removelater,{'sdom','maskdom'});
        end
        
        if  any(find(p.trial.ports.status==1)==p.trial.stimulus.port.START) % if rear port activated again, rescue midpoint
            if isfield(p.trial.stimulus,'timemidpointCrossed')
            p.trial.stimulus = rmfield(p.trial.stimulus,'timemidpointCrossed');
            end
            p.trial.stimulus.midpointCrossed = 0; 
            p.trial.state = p.trial.stimulus.states.PRESTIMON;
        end
        
        % trigger optogenetics each other trial
%         if p.trial.stimulus.midpointCrossed && p.trial.midpointOpto == 1 && p.trial.ttime < p.trial.stimulus.timemidpointCrossed + p.trial.stimulus.duration.pretime_final
%             if strcmp(p.trial.stimulus.step,'pretime')
%                 if mod(p.trial.pldaps.iTrial,2)  % TEMPORARILY use this code because of the connection we have
%                     %amount=0.1;
%                     %pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.MIDDLE); % this is not reward, but trigger of laser
%                     digital_out(p.trial.behavior.optogenetics.channel,1);
%                     %pause(amount);
%                     %digital_out(p.trial.behavior.optogenetics.channel,0);
%                 end
%             else
%                 digital_out(p.trial.behavior.optogenetics.channel,1);
%             end
%         end
            
        
        if ismember(activePort, [p.trial.stimulus.port.LEFT p.trial.stimulus.port.RIGHT])
            %note time
            p.trial.stimulus.timeTrialFirstResp = p.trial.ttime;
            p.trial.stimulus.frameTrialFirstResp = p.trial.iFrame;
        
            %note response
            %p.trial.stimulus.respTrial=activePort;
            p.trial.stimulus.respTrial=p.trial.ports.status; % [1 0 0 0] means right port, [0 0 0 1] means left port
            
            % reset
            if ~isfield(p.trial.stimulus,'reset')
                   p.trial.stimulus.reset = [];
            end
%             if ~isfield(p.trial.stimulus,'reset')
%               p.trial.stimulus.reset = -1;
%             end
%             if p.trial.stimulus.reset == -1
%               p.trial.stimulus.reset = 0;
%             end
            
            %check whether correct port chosen
            correct=checkPortChoice(activePort,p);
            if p.conditions{p.trial.pldaps.iTrial}.centralflash %&& ((p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd) == 5)
                correct = 1;
            end
            if correct==1
                %play tone
               % pds.audio.playDatapixxAudio(p,'reward_short');

                %give reward
                if activePort==p.trial.stimulus.port.LEFT
                    amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT);
                    pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.LEFT);
                elseif activePort==p.trial.stimulus.port.RIGHT
                    amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT);
                    pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.RIGHT);
                else
                    amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.MIDDLE);
                    pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.MIDDLE);
                end
                %advance state
                p.trial.state=p.trial.stimulus.states.CORRECT;
            else
                %play tone
                % pds.audio.playDatapixxAudio(p,'breakfix');
                %advance state
                p.trial.state=p.trial.stimulus.states.INCORRECT;
            end
        end
        
    case p.trial.stimulus.states.CORRECT %correct port selected for stimulus
        %wait for ITI
        if p.trial.ttime > p.trial.stimulus.timeTrialFirstResp + p.trial.stimulus.duration.ITI
            %trial done - note time
            p.trial.stimulus.timeTrialFinish = p.trial.ttime;
            p.trial.stimulus.frameTrialFinish = p.trial.iFrame;
            
            %advance state, mark as correct trial and flag next trial
            p.trial.state=p.trial.stimulus.states.TRIALCOMPLETE;
            p.trial.pldaps.goodtrial = 1;
            p.trial.flagNextTrial = true;
          %  p.trialMem.UD = PAL_AMUD_updateUD(p.trialMem.UD,1);
        end
        
    case p.trial.stimulus.states.INCORRECT %incorrect port selected for stimulus
        p.trial.pldaps.goodtrial = 0; 
        
        if p.trial.stimulus.forceCorrect == 1 %must give correct response before ending trial            
            %check whether any port chosen
            if ismember(activePort, [p.trial.stimulus.port.MIDDLE p.trial.stimulus.port.LEFT p.trial.stimulus.port.RIGHT])
                %check whether correct port chosen
                correct=checkPortChoice(activePort,p);                
                if correct==1 %now has chosen correct port
                    %note time
                    p.trial.stimulus.timeTrialFinalResp = p.trial.ttime;
                    p.trial.stimulus.frameTrialFinalResp = p.trial.iFrame;
                    
                    if activePort==p.trial.stimulus.port.LEFT
                        amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT);
                        pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.LEFT);
                    elseif activePort==p.trial.stimulus.port.RIGHT
                        amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT);
                        pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.RIGHT);
                    else
                        amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.MIDDLE);
                        pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.MIDDLE);
                    end
                    
                    %advance state
                    p.trial.state=p.trial.stimulus.states.FINALRESP;
                   % p.trialMem.UD = PAL_AMUD_updateUD(p.trialMem.UD,0);
                end
            end
        elseif p.trial.stimulus.forceCorrect == 2
                if ismember(activePort, [p.trial.stimulus.port.MIDDLE p.trial.stimulus.port.LEFT p.trial.stimulus.port.RIGHT])
                %check whether correct port chosen
                    correct=checkPortChoice(activePort,p);                
                    if correct==1 %now has chosen correct port
                        %note time
                        p.trial.stimulus.timeTrialFinalResp = p.trial.ttime;
                        p.trial.stimulus.frameTrialFinalResp = p.trial.iFrame;

                        if activePort==p.trial.stimulus.port.LEFT
                            amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT);
                            pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.LEFT);
                        elseif activePort==p.trial.stimulus.port.RIGHT
                            amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT);
                            pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.RIGHT);
                        else
                            amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.MIDDLE);
                            pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.MIDDLE);
                        end
                        
                        %advance state
                        p.trial.state=p.trial.stimulus.states.FINALRESP;
                     %   p.trialMem.UD = PAL_AMUD_updateUD(p.trialMem.UD,0);
                    end

                else
                    
                    if ismember(activePort, [p.trial.stimulus.port.START])
%                         p.trial.pldaps.goodtrial = 1;
%                         p.trial.flagNextTrial = true;
                        %deliver reward
                        amount=p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.START);
                        pds.behavior.reward.give(p,amount,p.trial.behavior.reward.channel.START);

                        %advance state
                        p.trial.state=p.trial.stimulus.states.STIMON;
                    end

                end
                
        else %incorrect responses end trial immediately
            %wait for ITI
            if p.trial.ttime > p.trial.stimulus.timeTrialFirstResp + p.trial.stimulus.duration.ITI
                %trial done
                p.trial.state=p.trial.stimulus.states.TRIALCOMPLETE;
                p.trial.flagNextTrial = true;
               % p.trialMem.UD = PAL_AMUD_updateUD(p.trialMem.UD,0);
            end
        end
        
    case p.trial.stimulus.states.FINALRESP
        %wait for ITI
        if p.trial.ttime > p.trial.stimulus.timeTrialFinalResp + p.trial.stimulus.duration.ITI
            %trial done
            p.trial.state=p.trial.stimulus.states.TRIALCOMPLETE;
            p.trial.flagNextTrial = true;
        end
end

        

        
%------------------------------------------------------------------%
%setup trial parameters, prep stimulus as far as possible
function p=trialSetup(p)  % SZ: in defaultTrialFunction, timing.datapixxPreciseTime is read at this point

if isfield(p.trial,'masktxtr')
    Screen('Close',p.trial.masktxtr);
end
p.trial.masktxtr=[];

if isfield(p.trial,'gtxtr')
    Screen('Close',p.trial.gtxtr)
end
p.trial.gtxtr=[];

% get parameters from setting file
p.trial.stimulus.sf = p.conditions{p.trial.pldaps.iTrial}.sf;
p.trial.stimulus.angle = p.conditions{p.trial.pldaps.iTrial}.angle;
%p.trial.stimulus.LeftRight = p.conditions{p.trial.pldaps.iTrial}.LeftRight;
if p.trialMem.locationjitter == 1
    p.trial.stimulus.locationjitter = (2*randi(2,1)-3) * 40;
    p.trial.stimulus.locationjitter = [-40 0 40];
    p.trial.stimulus.locationjitter = p.trial.stimulus.locationjitter(randi(3,1));
%     p.trial.stimulus.locationjitter = randi([-85,85],1,1);
%     disp(['location jitter: ' num2str(p.trial.stimulus.locationjitter)])
elseif length(p.trialMem.locationjitter) == 1 && (p.trialMem.locationjitter < 0 || p.trialMem.locationjitter > 1)
    p.trial.stimulus.locationjitter = p.trialMem.locationjitter;
    disp(['location jitter: ' num2str(p.trial.stimulus.locationjitter)])
elseif length(p.trialMem.locationjitter) == 2 && ~isfield(p.trialMem,'locationjitter_progress')
    p.trial.stimulus.locationjitter = p.trialMem.locationjitter(1);
end
p.trial.stimulus.phase = mod(180, (rand < 0.5)*180 + 180); % phase is random 0 or 180
p.trial.stimulus.direction = -1 + 2*(randi(2)-1); % direction of drifting if tf >0
% p.trial.stimulus.phase = p.conditions{p.trial.pldaps.iTrial}.phase; % phase is pseudorandom
%get side for condition
if p.conditions{p.trial.pldaps.iTrial}.side==2
    p.trial.side=p.trial.stimulus.side.LEFT;
else
    p.trial.side=p.trial.stimulus.side.RIGHT;
end
% adjust stimulus parameters with keyboard
% if ~isfield(p.trial,'range_meanadd')
%         p.trial.range_meanadd = 0;
% end
% if ~isfield(p.trial,'range_varadd')
%         p.trial.range_varadd = 0;
% end
% if ~isfield(p.trial,'radiusadd')
%         p.trial.radiusadd = 0;
% end

%% staircase
% p.conditions{p.trial.pldaps.iTrial}.select = p.trialMem.UD.xCurrent;
% don't use staircase to change the stimulus presentation time, because you
% are aiming at a specific time, not to pilot the range
if p.trial.pldaps.iTrial > p.trialMem.practice +4 && ~p.trialMem.staircasepause
    switch p.trial.stimulus.step
        case 'var'
            p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial-1}.select;
            % decrease step
            if p.trialMem.lock ==0 && p.trial.pldaps.iTrial >= 4 && all(~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,{'quit','step'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,{'quit','step'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,{'quit'}))...
                    && isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,'goodtrial') && isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,'goodtrial') && isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,'goodtrial')  && p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd ~= 12
                if p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd > p.trialMem.loweststep 
                    p.trial.pldaps.step = -2;
                    p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial}.select - 2;
                    disp('step-1')
                else
                    disp('lowest step')
                end
            % increase step
            elseif p.trialMem.lock ==0 && p.trial.pldaps.iTrial >= 5 && all(~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-4}.pldaps,{'quit'}))...
                    && ~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,'goodtrial') && (~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,'goodtrial') || ~isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,'goodtrial') || ~isfield(p.data{p.trial.pldaps.iTrial-4}.pldaps,'goodtrial')) ... % incorrect + another incorrect in previous three trials
                    && p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd ~= 11
                if p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd < p.trialMem.higheststep
                    p.trial.pldaps.step = 2;
                    p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial}.select +2;
                    disp('step+1')
                else
                    disp('highest step')
                end
                % level 3 & 1, only one error needed to go up.
            elseif p.trialMem.lock ==0 && p.trial.pldaps.iTrial >= 5 && all(~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-4}.pldaps,{'quit'}))...
                    && ~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,'goodtrial') ... % incorrect + another incorrect in previous three trials
                    && p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd < 5
                    p.trial.pldaps.step = 2;
                    p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial}.select +2;
                    disp('step+1')
                % Practice trials at level 12
            elseif p.trialMem.lock ==0 && p.trial.pldaps.iTrial >= 4 && all(~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,{'quit'})) ...
                    && isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,'goodtrial') && isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,'goodtrial') && isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,'goodtrial')  ...
                    && p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd == 12 ... %|| p.trialMem.repractice ==1)
                    && ~p.data{p.trial.pldaps.iTrial-1}.stimulus.trialMem.lock && ~p.data{p.trial.pldaps.iTrial-2}.stimulus.trialMem.lock % no need of lock
                    p.trial.pldaps.step = -1;
                    p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial}.select - 1;
                    disp('step-1')
                    %p.trialMem.repractice = 0;
            elseif p.trialMem.lock ==0 && p.trial.pldaps.iTrial >= 5 && all(~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,{'quit'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,{'quit'}))&& all(~isfield(p.data{p.trial.pldaps.iTrial-4}.pldaps,{'quit'}))...
                    && ~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,'goodtrial') && (~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,'goodtrial') || ~isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,'goodtrial')|| ~isfield(p.data{p.trial.pldaps.iTrial-4}.pldaps,'goodtrial')) ... % incorrect + another incorrect in previous two trials
                    && p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd == 11 ...
                    && any((p.trialMem.stats.val(3,:) - p.trialMem.stats.val(4,:))./2 == p.trial.stimulus.range_var_source(9)) % already got to level 9
                % p.trialMem.lock ==0 && p.trial.pldaps.iTrial >= 4 && all(~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,{'quit','step'})) && ~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,'goodtrial') && p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd == 11
                    p.trial.pldaps.step = 1;
                    p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial}.select +1;
                    disp('step+1')
                    %p.trialMem.repractice = 1;
            end
    %      This was removed, because what we modify in p.conditions here wouldn't be upgraded to the final record:
    %         while p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd <1
    %             p.conditions{p.trial.pldaps.iTrial}.range_varadd = p.conditions{p.trial.pldaps.iTrial}.range_varadd + 1;
    %             disp('step too low')
    %         end
    %         while p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd  > length(p.trial.stimulus.range_var_source)
    %             p.conditions{p.trial.pldaps.iTrial}.range_varadd = p.conditions{p.trial.pldaps.iTrial}.range_varadd - 1;
    %             disp('step too high')
    %        end
        case 'radius'
            p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial-1}.select;
            if p.trialMem.lock ==0 && p.trial.pldaps.iTrial >= 4 && all(~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,{'quit','step'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,{'quit','step'})) && all(~isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,{'quit'}))...
                    && isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,'goodtrial') && isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,'goodtrial') && isfield(p.data{p.trial.pldaps.iTrial-3}.pldaps,'goodtrial')  
                if p.conditions{p.trial.pldaps.iTrial}.select  + p.conditions{p.trial.pldaps.iTrial}.radiusadd > 1 
                    p.trial.pldaps.step = -1;
                    p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial}.select - 1;
                    disp('step-1')
                else
                    disp('lowest step')
                end
            elseif p.trialMem.lock ==0 && p.trial.pldaps.iTrial >= 4 && all(~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,{'quit'})) ...% && all(~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,{'quit'}))...
                    && ~isfield(p.data{p.trial.pldaps.iTrial-1}.pldaps,'goodtrial') % && ~isfield(p.data{p.trial.pldaps.iTrial-2}.pldaps,'goodtrial')
                if p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.radiusadd < length(p.trial.stimulus.radius)
                    p.trial.pldaps.step = 1;
                    p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial}.select +1;
                    disp('step+1')
                else
                    disp('highest step')
                end
            end
    end
elseif p.trial.pldaps.iTrial > p.trialMem.practice +4 && p.trialMem.staircasepause
    p.conditions{p.trial.pldaps.iTrial}.select = p.conditions{p.trial.pldaps.iTrial-1}.select;
end
%%
p.trial.stimulus.range_mean = p.conditions{p.trial.pldaps.iTrial}.range_mean + p.conditions{p.trial.pldaps.iTrial}.range_meanadd; % C: correct choice, I: incorrect
switch p.trial.stimulus.step 
    case {0,'var'}
    p.trial.stimulus.range_var = p.trial.stimulus.range_var_source(p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.range_varadd);
    p.trial.stimulus.radius_final = p.conditions{p.trial.pldaps.iTrial}.radius + p.conditions{p.trial.pldaps.iTrial}.radiusadd;
    case 'radius'
    p.trial.stimulus.range_var = p.conditions{p.trial.pldaps.iTrial}.range_var;
    p.trial.stimulus.radius_final = p.trial.stimulus.radius(p.conditions{p.trial.pldaps.iTrial}.select + p.conditions{p.trial.pldaps.iTrial}.radiusadd);
end
p.trial.stimulus.duration.pretime_final = p.conditions{p.trial.pldaps.iTrial}.pretime + p.conditions{p.trial.pldaps.iTrial}.pretimeadd;
p.trial.stimulus.range_varadd = p.conditions{p.trial.pldaps.iTrial}.range_varadd;
p.trial.stimulus.range_meanadd = p.conditions{p.trial.pldaps.iTrial}.range_meanadd;
% p.trial.stimulus.sf_final = p.conditions{p.trial.pldaps.iTrial}.sf + p.conditions{p.trial.pldaps.iTrial}.sfadd;
p.trial.stimulus.tf_final = p.conditions{p.trial.pldaps.iTrial}.tf + p.conditions{p.trial.pldaps.iTrial}.tfadd;
%p.trial.stimulus.select = p.conditions{p.trial.pldaps.iTrial}.select;
p.trial.stimulus.rangeC = p.trial.stimulus.range_mean + p.trial.stimulus.range_var;
p.trial.stimulus.rangeI = p.trial.stimulus.range_mean - p.trial.stimulus.range_var;
% for those going to be displayed in the command window, add to p.condition{p.trial.pldaps.iTrial}, otherwise counting doesn't work
p.conditions{p.trial.pldaps.iTrial}.rangeC = p.trial.stimulus.rangeC;
% p.conditions{p.trial.pldaps.iTrial}.rangeI = p.trial.stimulus.rangeI;
p.conditions{p.trial.pldaps.iTrial}.pretime_final = p.trial.stimulus.duration.pretime_final;
p.conditions{p.trial.pldaps.iTrial}.radius_final = p.trial.stimulus.radius_final;
% p.conditions{p.trial.pldaps.iTrial}.sf_final = p.trial.stimulus.sf_final;
p.conditions{p.trial.pldaps.iTrial}.tf_final = p.trial.stimulus.tf_final;
% maintain the adjustment from previous trials
p.conditions{p.trial.pldaps.iTrial+1}.range_varadd = p.conditions{p.trial.pldaps.iTrial}.range_varadd;
p.conditions{p.trial.pldaps.iTrial+1}.range_meanadd = p.conditions{p.trial.pldaps.iTrial}.range_meanadd;
p.conditions{p.trial.pldaps.iTrial+1}.radiusadd = p.conditions{p.trial.pldaps.iTrial}.radiusadd;
p.conditions{p.trial.pldaps.iTrial+1}.pretimeadd = p.conditions{p.trial.pldaps.iTrial}.pretimeadd;
% p.conditions{p.trial.pldaps.iTrial+1}.sfadd = p.conditions{p.trial.pldaps.iTrial}.sfadd;
p.conditions{p.trial.pldaps.iTrial+1}.tfadd = p.conditions{p.trial.pldaps.iTrial}.tfadd;
% setup the parameter displayed in the command window
if ~isempty(find(ismember(p.trialMem.stats.cond,'radius_final'), 1)) ... 
        && isempty(intersect(intersect(find(p.trialMem.stats.val(2,:) == p.trial.stimulus.radius_final),find(p.trialMem.stats.val(3,:) == p.trial.stimulus.rangeC)) ,find(p.trialMem.stats.val(4,:) == p.trial.stimulus.duration.pretime_final)))
    p.trialMem.stable(2,:) = [p.trial.stimulus.radius_final p.trial.stimulus.radius_final];
    p.trialMem.stats.val = horzcat(p.trialMem.stats.val,vertcat(p.trialMem.stable,[p.trial.stimulus.rangeC p.trial.stimulus.rangeC],[p.trial.stimulus.duration.pretime_final p.trial.stimulus.duration.pretime_final])); % add the adjusted parameter
    [p.trialMem.stats.val,rankind]  = (sortrows(p.trialMem.stats.val',[3,4,2,1],{'ascend' 'ascend' 'ascend' 'ascend'})); % rank the adjusted parameter
    p.trialMem.stats.val = p.trialMem.stats.val';
    rankind = rankind';
    % number of trials and correct rate
    p.trialMem.stats.count.Ntrial = horzcat([p.trialMem.stats.count.Ntrial zeros(1:2)]);
    p.trialMem.stats.count.Ntrial = p.trialMem.stats.count.Ntrial(rankind);
    p.trialMem.stats.count.correct = horzcat([p.trialMem.stats.count.correct zeros(1:2)]);
    p.trialMem.stats.count.correct = p.trialMem.stats.count.correct(rankind);
    p.trialMem.stats.count.incorrect = horzcat([p.trialMem.stats.count.incorrect zeros(1:2)]);
    p.trialMem.stats.count.incorrect = p.trialMem.stats.count.incorrect(rankind);
    
    if ~isfield(p.trialMem.stats.count,'accumC')
        p.trialMem.stats.count.accumC = zeros(length(p.trialMem.stats.count.correct),1)';
        p.trialMem.stats.count.accumI = zeros(length(p.trialMem.stats.count.correct),1)';
    else
    p.trialMem.stats.count.accumC = horzcat([p.trialMem.stats.count.accumC zeros(size(p.trialMem.stats.count.accumC,1),2)]);
    p.trialMem.stats.count.accumI = horzcat([p.trialMem.stats.count.accumI zeros(size(p.trialMem.stats.count.accumI,1),2)]);
    p.trialMem.stats.count.accumC = p.trialMem.stats.count.accumC(:,rankind);
    p.trialMem.stats.count.accumI = p.trialMem.stats.count.accumI(:,rankind);
    end
        
end
if isempty(find(p.trialMem.stats.val(3,:) == p.trial.stimulus.rangeC))%,find(p.trialMem.stats.val(4,:) == p.trial.stimulus.rangeI)))
    p.trialMem.stats.val = horzcat(p.trialMem.stats.val,vertcat(p.trialMem.stable,[p.trial.stimulus.rangeC p.trial.stimulus.rangeC]));%,[p.trial.stimulus.rangeI p.trial.stimulus.rangeI])); % add the adjusted parameter
    [p.trialMem.stats.val,rankind]  = (sortrows(p.trialMem.stats.val',[3,4,2,1],{'ascend' 'ascend' 'ascend' 'ascend'})); % rank the adjusted parameter
    p.trialMem.stats.val = p.trialMem.stats.val';
    rankind = rankind';
    p.trialMem.stats.count.Ntrial = horzcat([p.trialMem.stats.count.Ntrial zeros(1:2)]);
    p.trialMem.stats.count.Ntrial = p.trialMem.stats.count.Ntrial(rankind);
    p.trialMem.stats.count.correct = horzcat([p.trialMem.stats.count.correct zeros(1:2)]);
    p.trialMem.stats.count.correct = p.trialMem.stats.count.correct(rankind);
    p.trialMem.stats.count.incorrect = horzcat([p.trialMem.stats.count.incorrect zeros(1:2)]);
    p.trialMem.stats.count.incorrect = p.trialMem.stats.count.incorrect(rankind);
    
    if ~isfield(p.trialMem.stats.count,'accumC')
        p.trialMem.stats.count.accumC = zeros(length(p.trialMem.stats.count.correct),1)';
        p.trialMem.stats.count.accumI = zeros(length(p.trialMem.stats.count.correct),1)';
    else
    p.trialMem.stats.count.accumC = horzcat([p.trialMem.stats.count.accumC zeros(size(p.trialMem.stats.count.accumC,1),2)]);
    p.trialMem.stats.count.accumI = horzcat([p.trialMem.stats.count.accumI zeros(size(p.trialMem.stats.count.accumI,1),2)]);
    p.trialMem.stats.count.accumC = p.trialMem.stats.count.accumC(:,rankind);
    p.trialMem.stats.count.accumI = p.trialMem.stats.count.accumI(:,rankind);
    end
end

p.trial.stimulus.fullField = p.conditions{p.trial.pldaps.iTrial}.fullField;
% if p.trial.stimulus.fullField 
p.trial.gratPosC = [(0 + p.trial.stimulus.locationjitter) 0 (p.trial.display.screenSize(3) + p.trial.stimulus.locationjitter) p.trial.display.screenSize(4)]; % change to your resolution - SZ

% else
%     switch p.trial.stimulus.LeftRight
%         case 1
%              p.trial.gratPosC = [0 192 p.trial.display.screenSize(3)/2 576]; % change to your resolution - SZ
%              p.trial.gratPosI = [p.trial.display.screenSize(3)/2 192 p.trial.display.screenSize(3) 576];
%             % p.trial.stimulus.sf = (p.conditions{p.trial.pldaps.iTrial}.sf);
%         case 2
%              p.trial.gratPosC = [p.trial.display.screenSize(3)/2 192 p.trial.display.screenSize(3) 576];
%              p.trial.gratPosI = [0 192 p.trial.display.screenSize(3)/2 576];
%             % p.trial.stimulus.sf = (p.conditions{p.trial.pldaps.iTrial}.sf)./2;
%     end
% end
%make grating
%make grating
    %DegPerPix = p.trial.display.dWidth/p.trial.display.pWidth;
    %PixPerDeg = 1/DegPerPix;

    % GET GRATING SPECIFICATIONS
%     nCycles = 24*p.trial.stimulus.sf;
%     DegPerCyc = 1/p.trial.stimulus.sf;
    ApertureDeg = 2*p.trial.stimulus.radius_final;%DegPerCyc*nCycles;

    % CREATE A MESHGRID THE SIZE OF THE GRATING
    x=linspace(-(p.trial.display.dWidth/2),p.trial.display.dWidth/2,p.trial.display.pWidth);%-p.trial.stimulus.shift(p.trial.side);
    y=linspace(-(p.trial.display.dHeight/2),p.trial.display.dHeight/2,p.trial.display.pHeight); % p.trial.display.screenSize(3)/2 = p.trial.display.screenSize(4)/1.5
    [x,y] = meshgrid(x,y);


    % Transform to account for orientation
    % note: transformation changed from headfixed
    sdom=x*sin(p.trial.stimulus.angle*pi/180)-y*cos(p.trial.stimulus.angle*pi/180);

    % GRATING
    sdom=sdom*p.trial.stimulus.sf*2*pi;
    sdom1=cos(sdom-p.trial.stimulus.phase*pi/180);
    if p.trial.stimulus.tf_final > 0 
        p.trial.removelater.sdom = sdom;
    end

    if isfield(p.trial.stimulus,'fullField') && p.trial.stimulus.fullField == 1
        grating = sdom1;
    else
        % CREATE A GAUSSIAN TO SMOOTH THE OUTER 10% OF THE GRATING
        r = sqrt(x.^2 + y.^2);
        sigmaDeg = ApertureDeg/16.5;
        MaskLimit=.6*ApertureDeg/2;
        maskdom = exp(-.5*(r-MaskLimit).^2/sigmaDeg.^2);
        maskdom(r<MaskLimit) = 1;
        grating = sdom1.*maskdom;
        if p.trial.stimulus.tf_final > 0 
            p.trial.removelater.maskdom = maskdom;
        end
    end
    % p.trial.stimulus.grating = grating;

    % TRANSFER THE GRATING INTO AN IMAGE
    gratingC = round(grating*p.trial.stimulus.rangeC) + 127;
%    gratingI = round(grating*p.trial.stimulus.rangeI) + 127;
    if p.conditions{p.trial.pldaps.iTrial}.centralflash % central flash
        p.trial.stimulus.radiusCentral = 12;
        ApertureDeg = 2*p.trial.stimulus.radiusCentral;
        p.trial.stimulus.sfCentral = 0;
        p.trial.stimulus.phaseCentral = 0;
        x=linspace(-(p.trial.display.dWidth/2),p.trial.display.dWidth/2,p.trial.display.pWidth);%-p.trial.stimulus.shift(p.trial.side);
        y=linspace(-(p.trial.display.dHeight/1.5),p.trial.display.dHeight/1.5,p.trial.display.pHeight);
        [x,y] = meshgrid(x,y);
        sdom=x*sin(p.trial.stimulus.angle*pi/180)-y*cos(p.trial.stimulus.angle*pi/180);
        sdom=sdom*p.trial.stimulus.sfCentral*2*pi;
        sdom1=cos(sdom-p.trial.stimulus.phaseCentral*pi/180);
        % CREATE A GAUSSIAN TO SMOOTH THE OUTER 10% OF THE GRATING
        r = sqrt(x.^2 + y.^2);
        sigmaDeg = ApertureDeg/16.5;
        MaskLimit=.6*ApertureDeg/2;
        maskdom = exp(-.5*(r-MaskLimit).^2/sigmaDeg.^2);
        maskdom(r<MaskLimit) = 1;
        grating = sdom1.*maskdom;
        gratingCentral = round(grating*127) + 127;
        p.trial.gratPosCentral = p.trial.display.screenSize;
        p.trial.gratTexCentral = Screen('MakeTexture',p.trial.display.ptr,gratingCentral);
    end

    p.trial.gratTexC = Screen('MakeTexture',p.trial.display.ptr,gratingC);
    p.trial.stimulus.rangeC_M = (max(gratingC,[],'all') - min(gratingC,[],'all'))./(max(gratingC,[],'all') + min(gratingC,[],'all'));

%set state
p.trial.state=p.trial.stimulus.states.START;
if p.trial.stimulus.midpointIR
    p.trial.stimulus.midpointCrossed = 0;
end
if p.trial.camera.use;
    pds.behavcam.startcam(p);
end

% record the correctness in every trial & every condition
accum_tempC = p.trialMem.stats.count.correct;
if ~isfield(p.trialMem.stats.count, 'accumC')
   p.trialMem.stats.count.accumC = [];
   p.trialMem.stats.count.accumC = vertcat(p.trialMem.stats.count.accumC, accum_tempC);
else
   p.trialMem.stats.count.accumC = vertcat(p.trialMem.stats.count.accumC, (accum_tempC -  sum(p.trialMem.stats.count.accumC,1)));
end

% record the incorrectness in every trial & every condition
accum_tempI = p.trialMem.stats.count.incorrect;
if ~isfield(p.trialMem.stats.count, 'accumI')
   p.trialMem.stats.count.accumI = zeros(size(accum_tempI,1),size(accum_tempI,2));
end
p.trialMem.stats.count.accumI = vertcat(p.trialMem.stats.count.accumI, (accum_tempI -  sum(p.trialMem.stats.count.accumI,1)));
% automatically update reward difference to remove bias
if p.trial.pldaps.iTrial >= 14
    totalcorrectrate14 = sum(p.trialMem.stats.count.accumC(end-13:end,:),'all')./(sum(p.trialMem.stats.count.accumC(end-13:end,:),'all')+ sum(p.trialMem.stats.count.accumI(end-13:end,:),'all'));
    leftcorrectrate14 = sum(p.trialMem.stats.count.accumC(end-13:end,1:2:end),'all')./(sum(p.trialMem.stats.count.accumC(end-13:end,1:2:end),'all')+ sum(p.trialMem.stats.count.accumI(end-13:end,1:2:end),'all'));
    rightcorrectrate14 = sum(p.trialMem.stats.count.accumC(end-13:end,2:2:end),'all')./(sum(p.trialMem.stats.count.accumC(end-13:end,2:2:end),'all')+ sum(p.trialMem.stats.count.accumI(end-13:end,2:2:end),'all'));

    if leftcorrectrate14 - rightcorrectrate14 >= 0.125 && leftcorrectrate14 - rightcorrectrate14 < 0.25 && (p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT)-p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT)) < 2*p.trialMem.amountDelta
        pds.behavior.reward.updateAmount(p,3);
        pds.behavior.reward.updateAmount(p,6);
    elseif leftcorrectrate14 - rightcorrectrate14 <= -0.125 && leftcorrectrate14 - rightcorrectrate14 > -0.25 && (p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT)-p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT)) > -2*p.trialMem.amountDelta
        pds.behavior.reward.updateAmount(p,4);
        pds.behavior.reward.updateAmount(p,5);
    elseif leftcorrectrate14 - rightcorrectrate14 >= 0.25 && (p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT)-p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT)) < 4*p.trialMem.amountDelta
        pds.behavior.reward.updateAmount(p,3);
        pds.behavior.reward.updateAmount(p,6);
    elseif leftcorrectrate14 - rightcorrectrate14 <= -0.25 && (p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT)-p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT)) > -4*p.trialMem.amountDelta
        pds.behavior.reward.updateAmount(p,4);
        pds.behavior.reward.updateAmount(p,5);
    elseif leftcorrectrate14 - rightcorrectrate14 >= 0.375 && p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT) < 2*p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT)
        pds.behavior.reward.updateAmount(p,3);
        pds.behavior.reward.updateAmount(p,6);
    elseif leftcorrectrate14 - rightcorrectrate14 <= -0.375 && p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT) < 2*p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT)
        pds.behavior.reward.updateAmount(p,4);
        pds.behavior.reward.updateAmount(p,5);
    elseif leftcorrectrate14 - rightcorrectrate14 < 0.2 && (p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT)-p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT)) > 2*p.trialMem.amountDelta
        pds.behavior.reward.updateAmount(p,4);
        pds.behavior.reward.updateAmount(p,5);
    elseif leftcorrectrate14 - rightcorrectrate14 > -0.2 && (p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT)-p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT)) < -2*p.trialMem.amountDelta
        pds.behavior.reward.updateAmount(p,3);
        pds.behavior.reward.updateAmount(p,6);
    elseif leftcorrectrate14 - rightcorrectrate14 < 0.3 && (p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT)-p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT)) > 4*p.trialMem.amountDelta
        pds.behavior.reward.updateAmount(p,4);
        pds.behavior.reward.updateAmount(p,5);
    elseif leftcorrectrate14 - rightcorrectrate14 > -0.3 && (p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.RIGHT)-p.trial.behavior.reward.amount(p.trial.stimulus.rewardIdx.LEFT)) < -4*p.trialMem.amountDelta
        pds.behavior.reward.updateAmount(p,3);
        pds.behavior.reward.updateAmount(p,6);
    end
    
    if all(isfield(p.trial.behavior.reward,{'increaseSince','increaseTimes'})) && p.trial.pldaps.iTrial == p.trial.behavior.reward.increaseSince
        if p.trial.behavior.reward.increaseTimes == 3
            pds.behavior.reward.updateAmount(p,4);
            pds.behavior.reward.updateAmount(p,4);
            pds.behavior.reward.updateAmount(p,4);
            pds.behavior.reward.updateAmount(p,6);
            pds.behavior.reward.updateAmount(p,6);
            pds.behavior.reward.updateAmount(p,6);
        elseif p.trial.behavior.reward.increaseTimes == 2
            pds.behavior.reward.updateAmount(p,4);
            pds.behavior.reward.updateAmount(p,4);
            pds.behavior.reward.updateAmount(p,6);
            pds.behavior.reward.updateAmount(p,6);
        end
    end
end

%------------------------------------------------------------------%
%display stats at end of trial
function cleanUpandSave(p)
%stop camera and set trigger to low
pds.behavcam.stopcam(p);
pds.behavcam.triggercam(p,0);

disp('----------------------------------')
disp(['Trialno: ' num2str(p.trial.pldaps.iTrial)])
%show reward amount
if p.trial.pldaps.draw.reward.show
    pds.behavior.reward.showReward(p,{'S';'L';'R'})
end
%show parameter
showParameter2(p) %,{'RangeC';'RangeL'})
%show stats
pds.behavior.countTrial(p,p.trial.pldaps.goodtrial); % update stats.count!
p.trialMem.stats.val_round = round(p.trialMem.stats.val,2);
num2str(vertcat(p.trialMem.stats.val_round,p.trialMem.stats.count.Ntrial,...
    round(p.trialMem.stats.count.correct./p.trialMem.stats.count.Ntrial*100,1)))  % show the correct rate
totalcorrectrate = sum(p.trialMem.stats.count.correct)./sum(p.trialMem.stats.count.Ntrial);
leftcorrectrate = sum(p.trialMem.stats.count.correct(1:2:end))./sum(p.trialMem.stats.count.Ntrial(1:2:end));
rightcorrectrate = sum(p.trialMem.stats.count.correct(2:2:end))./sum(p.trialMem.stats.count.Ntrial(2:2:end));
disp(['total: ' num2str(totalcorrectrate) '; left: ' num2str(leftcorrectrate) ',' num2str(sum(p.trialMem.stats.count.Ntrial(1:2:end))) ' ;' '  Right: ' num2str(rightcorrectrate) ',' num2str(sum(p.trialMem.stats.count.Ntrial(2:2:end))) ' ;'])
if p.trial.pldaps.iTrial >= 14
    totalcorrectrate14 = sum(p.trialMem.stats.count.accumC(end-13:end,:),'all')./(sum(p.trialMem.stats.count.accumC(end-13:end,:),'all')+ sum(p.trialMem.stats.count.accumI(end-13:end,:),'all'));
    leftcorrectrate14 = sum(p.trialMem.stats.count.accumC(end-13:end,1:2:end),'all')./(sum(p.trialMem.stats.count.accumC(end-13:end,1:2:end),'all')+ sum(p.trialMem.stats.count.accumI(end-13:end,1:2:end),'all'));
    rightcorrectrate14 = sum(p.trialMem.stats.count.accumC(end-13:end,2:2:end),'all')./(sum(p.trialMem.stats.count.accumC(end-13:end,2:2:end),'all')+ sum(p.trialMem.stats.count.accumI(end-13:end,2:2:end),'all'));
    disp(['total14: ' num2str(totalcorrectrate14) '; left14: ' num2str(leftcorrectrate14) ',' num2str(sum(p.trialMem.stats.count.accumC(end-13:end,1:2:end),'all')+ sum(p.trialMem.stats.count.accumI(end-13:end,1:2:end),'all')) ' ;' '  Right14: ' num2str(rightcorrectrate14) ',' num2str(sum(p.trialMem.stats.count.accumC(end-13:end,2:2:end),'all')+ sum(p.trialMem.stats.count.accumI(end-13:end,2:2:end),'all')) ' ;'])
% %show stats
% pds.behavior.countTrial(p,p.trial.pldaps.goodtrial);
% disp(['C: ' num2str(p.trialMem.stats.val)])
% disp(['N: ' num2str(p.trialMem.stats.count.Ntrial)])
% disp(['P: ' num2str(p.trialMem.stats.count.correct./p.trialMem.stats.count.Ntrial*100)])
end
% save trialMem data
p.trial.stimulus.trialMem = p.trialMem;


%%%%%%Helper functions
%-------------------------------------------------------------------%
%check whether a particular port choice is correct
function correct=checkPortChoice(activePort,p)

correct=0;

switch p.trial.side
    case p.trial.stimulus.side.LEFT
        if activePort==p.trial.stimulus.port.LEFT
            correct=1;
        end
    case p.trial.stimulus.side.RIGHT
        if activePort==p.trial.stimulus.port.RIGHT
            correct=1;
        end
end

function showParameter2(p)
%this function prints the current reward values in the command window
%input: 
% p - pldaps structure
% mapString - names for reward channels for easier display
disp([p.trial.stimulus.rangeC])
if ~isempty(find(ismember(p.trialMem.stats.cond,'radius_final'), 1))
    disp(p.trial.stimulus.radius_final)
end
if p.trial.stimulus.duration.pretime_final ~=0
    disp([num2str(p.trial.stimulus.duration.pretime_final) ' sec'])
end