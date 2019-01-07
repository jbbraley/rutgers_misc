% get directory where data files are stored
dirname = uigetdir();
% get files in dir
fnames = ls([dirname '\*.txt']);
file_ind = 23;

% load data file
datfile = file();
datfile.path = dirname;
datfile.name = fnames(file_ind,:);
datfile.ext = '.txt';
dat = dlmread(datfile.fullname,'\t');

figure
plot(dat(:,[5 7 9 11]))

%% filter data to remove high-frequency content

%filter out high frequency content
fs = 400;
forder = 6; % Order of filter function
rip = 0.5; % Pass band ripple
atten_stop = 40; % Stop attenuation in dB
flim = 60; % Frequency pass upper limit
[b,a] = ellip(forder,rip, atten_stop, flim/(fs/2),'low');
% freqz(b,a,32000,fs)

% Apply filter
fdat_t = filter(b,a,dat);

% convert acceleration from g to in/sec^2
fdat_t = fdat_t*386.09;

%create time vector
time = 0:1/fs:(length(fdat_t)-1)/fs;

figure
plot(time,fdat_t(:,[1 5 9 15]))
clear tind
for ii = 1:length(bounds)
    tind(ii) = bounds(ii).DataIndex;
end
event_inds = reshape(tind,2,[])';
event_inds = event_inds(end:-1:1,end:-1:1);

%% examine in frequency domain
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

%% FFT of event
% compute fft
dt = 1/fs;
ll1 = length(dat(event_inds(1,1):event_inds(1,2),:));
ll = length(dat(event_inds(2,1):event_inds(2,2),:));
yy1 =fft(dat(event_inds(1,1):event_inds(1,2),:)); 
yy = fft(dat(event_inds(2,1):event_inds(2,2),:));

p2_1 = abs(yy1/ll1);
p1_1 = p2_1(1:floor(ll1/2)+1,:);
p1_1(2:end-1) = 2*p1_1(2:end-1);

f1 = fs*(0:floor(ll1/2))/ll1;

p2 = abs(yy/ll);
p1 = p2(1:floor(ll/2)+1,:);
p1(2:end-1) = 2*p1(2:end-1);

ff = fs*(0:floor(ll/2))/ll;

inds = 9;
figure
ah = axes;
plot(ff,p1(:,inds));
hold all
plot(f1,p1_1(:,inds));

xlims = [0 120];
xlim(xlims);
xlabel('Frequency (Hz)');
ylabel('(g)');
legend({'Train on rail A'; 'Train on rail B'})

figure
plot(ff,p1(:,[15 1 5]))
xlabel('Frequency (Hz)');
ylabel('(g)');
legend({'misaligned splice'; 'good splice'; 'no splice'})

%% lets look at displacement
% Because of the sensors used and the nature of the loading...
% Accel data is not below 0.5Hz or above 2KHz
% Therefore we will only examine the displacement caused by vibrations
% between 1 and 60 Hz
freq_bounds =[0.5 100]; % [0.5 60]; %Hz
clear disp A
for ii = 1:size(dat,2)
 [disp(:,ii) A(:,ii)] = iomega_freq(dat(event_inds(2,1):event_inds(2,2),ii)*386.09,dt,3,1,freq_bounds);
end

p3 = abs(A/ll);
p4 = p3(1:floor(ll/2)+1,:);
p4(2:end-1) = 2*p4(2:end-1);

figure
plot(ff,p4(:,[15 1 5]))
xlabel('Frequency (Hz)');
ylabel('(in)');
legend({'misaligned splice'; 'good splice'; 'no splice'})
xlim([0.5 5])

figure
plot(time(event_inds(2,1):event_inds(2,2)),-disp(:,[15 1 5]))
xlabel('time (sec)');
ylabel('disp (in)');
legend({'misaligned splice'; 'good splice'; 'no splice'})

plot(dat(event_inds(2,1):event_inds(2,2),[15 1 5]))
