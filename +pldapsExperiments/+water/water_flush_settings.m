function s = water_flush_settings

%flush water through ports

%%%these can be changed
s.behavior.reward.amount = [50 50 50]; %fill: [10 20 20] %flush: [30 50 50];


%%%do not change these
s.pldaps.nosave = 1;
