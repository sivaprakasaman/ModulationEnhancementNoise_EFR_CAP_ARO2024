%Here's where you can define your own parameters for input/output
%directories.
addpath(pwd);

close all;
clear;

condition = 'Carboplatin';
protocol = 'EFR_RAM';
subj = 'Q403_awake';
ram_sam = 'SAM';
freq = '503';
noise = '40dB';

search_str = ['p*',ram_sam,'*',freq,'*_',noise,'.mat'];

fmod = 103;

uname = 'sivaprakasaman';
prefix = ['/media/',uname,'/AndrewNVME/Pitch_Study/PilotModulationEnhancementARO2024/',protocol,'/Chin/'];
suffix = [condition,'/',subj];

datapath = [prefix,suffix];
cwd = pwd;
cd(datapath)
datafile = {dir(fullfile(cd,search_str)).name};

write_out = [subj,'_',condition,'_',ram_sam,'_',freq,'_',noise];

processChin;