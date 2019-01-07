% get data file
[fname, fpath, ~] = uigetfile('.txt');
fs = 400;
chan_inds = [1 5 15 4 8 12];


% load data file
datfile = file([fpath fname]);
dat = dlmread(datfile.fullname,'\t');
% convert acceleration from g to in/sec^2
dat_imp = dat*386.09;

%create time vector
time = 0:1/fs:(length(dat_imp)-1)/fs;

%% select bounds on plot and export datatip data to workspace (as 'bounds')
figure
plot(time,dat(:,chan_inds))
legend(num2str(chan_inds'))

for ii = 1:length(bounds)
    tind(ii) = bounds(ii).DataIndex;
end
event_inds = reshape(tind,2,[])';
event_inds = event_inds(end:-1:1,end:-1:1);

%% FFT of event
% compute fft
dt = 1/fs;
ll = length(dat_imp(event_inds(1):event_inds(2),:));
yy = fft(dat_imp(event_inds(1):event_inds(2),:));

p2 = abs(yy/ll);
p1 = p2(1:floor(ll/2)+1,:);
p1(2:end-1) = 2*p1(2:end-1);

ff = fs*(0:floor(ll/2))/ll;

chan_inds = [15 1; 12 8];

figure('Position',[100 50 600 300]);
ah1 = subplot(2,1,1);
plot(ff,p1(:,chan_inds(1,:)));
xlim([0 100]);
ylim([0 25]);
xlabel('Frequency (Hz)');
ylabel('in/sec^2');
legend({'misaligned'; 'smooth'});
title('Midspan of Transit Beams')
ah2 = subplot(2,1,2);
plot(ff,p1(:,chan_inds(2,:)));
xlim([0 100]);
ylim([0 12.5]);
xlabel('Frequency (Hz)');
ylabel('in/sec^2');
legend({'misaligned'; 'smooth'});
title('Floor Beams')

chan_inds = [15 1; 12 4];
figure('Position',[100 50 800 300]);
ah1 = axes; %subplot(2,1,1);
plot((time(event_inds(1):event_inds(2)))-time(event_inds(1)),dat(event_inds(1):event_inds(2),chan_inds(1,:)));
% xlim([0 100]);
ylim([-5.5 5.5]);
xlabel('time (sec)');
ylabel('acceleration (g)');
legend({'misaligned'; 'smooth'});
% title('Midspan of Transit Beams')
% ah2 = subplot(2,1,2);
% plot((time(event_inds(1):event_inds(2)))-time(event_inds(1)),dat_imp(event_inds(1):event_inds(2),chan_inds(2,:)));
% % xlim([0 100]);
% ylim([-2500 2500]);
% xlabel('time (sec)');
% ylabel('in/sec^2');
% legend({'misaligned'; 'smooth'});
% title('Floor Beams')




%% lets look at displacement
% Because of the sensors used and the nature of the loading...
% Accel data is not below 0.5Hz or above 2KHz
% Therefore we will only examine the displacement caused by vibrations
% between 1 and 60 Hz
freq_bounds =[]; [0.5 100]; % [0.5 60]; %Hz
clear disp A
for ii = 1:size(dat,2)
 [disp(:,ii) A(:,ii)] = iomega_freq(dat_imp(event_inds(1):event_inds(2),ii),dt,3,1,freq_bounds);
end

figure

p3 = abs(A/ll);
p4 = p3(1:floor(ll/2)+1,:);
p4(2:end-1) = 2*p4(2:end-1);
plot(ff,p4(:,chan_inds))
xlabel('Frequency (Hz)');
ylabel('(in)');
legend(num2str(chan_inds'))
xlim([0.5 10])

figure
plot(time(event_inds(1):event_inds(2)),-disp(:,chan_inds))
xlabel('time (sec)');
ylabel('displacement (in)');
legend(num2str(chan_inds'))

%% PSD - examine in frequency domain
addpath(genpath('C:\Users\John\Projects_Git\vma'))
nAvg = 5;  % number of averages
perc = 75;  % percent overlap
nfft = [];  % use default nfft lines

% get psd
[pxx,f] = getpsd(dat(event_inds(1):event_inds(2),:),nAvg,perc,nfft,fs);
[pxx2,f2] = getpsd(dat(event_inds(1):event_inds(2),:),nAvg,perc,nfft,fs);

% display frequency resolution
fprintf('Observable frequency range: 0-%s[Hz]\n',num2str(f(end)));
fprintf('Frequency resolution: %s[Hz]\n',num2str(f(2)));


ind = 7; %1:size(fdat_t,2);
figure
plot(f,mag2db([pxx(:,ind) pxx2(:,ind)]))
title('PSD');
xlabel('Frequency [Hz]')
ylabel('Power [dB]')
grid minor

