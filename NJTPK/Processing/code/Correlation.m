% Select sensors to correlate
chan1 = [2 3];
chan2 = [4 5];

%% Load data text file
[dat_name, fname] = uigetfile('.txt');
dat_file = file();
dat_file.name = dat_name; 
dat_file.path = fname;

dat_raw = dlmread(dat_file.fullname);

dat = dat_raw(:,2:end);

% Compute difference
plot(diff(dat(:,chan1),1,2));

% plot correlation
plot(dat(:,chan1),dat(:,chan2))

% plot difference correlation
plot(diff(dat(:,chan1),1,2),diff(dat(:,chan2),1,2))

%% apply low pass filters
%filter out high frequency content
fs = 3200;
forder = 6; % Order of filter function
rip = 0.5; % Pass band ripple
atten_stop = 40; % Stop attenuation in dB
flim = 60; % Frequency pass upper limit
[b,a] = ellip(forder,rip, atten_stop, flim/(fs/2),'low');
% freqz(b,a,32000,fs)

% Apply filter
fdat = filter(b,a,dat);

dat = fdat;

