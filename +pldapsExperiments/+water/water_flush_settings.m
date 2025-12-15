function s = water_flush_settings

%flush water through ports

%%%these can be changed
s.behavior.reward.amount = [50 50 50]; %fill: [5 10 10] %flush: [15 30 30];


%%%do not change these
s.pldaps.nosave = 1;
