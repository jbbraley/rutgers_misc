[fname, fpath, ~] = uigetfile('.txt');
fs = 400;
chan_inds = [5];

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

%% Clip data
clip_threshold = 2*386.09; % g
dat_clip = dat_imp(:,chan_inds);
dat_clip(dat_clip>clip_threshold)= clip_threshold;
dat_clip(dat_clip<-clip_threshold) = -clip_threshold;
figure
plot(time(event_inds(1):event_inds(2)),dat_imp(event_inds(1):event_inds(2),chan_inds))
hold all
plot(time(event_inds(1):event_inds(2)),dat_clip(event_inds(1):event_inds(2),:))
xlabel('time (sec)')
ylabel('acceleration (in/sec^2)')



%% FFT of event
% compute fft
dt = 1/fs;
ll = length(dat_imp(event_inds(1):event_inds(2),:));
yy = fft(dat_imp(event_inds(1):event_inds(2),chan_inds));
y2 = fft(dat_clip(event_inds(1):event_inds(2),:));

p2 = abs(yy/ll);
p1 = p2(1:floor(ll/2)+1,:);
p1(2:end-1) = 2*p1(2:end-1);

q2 = abs(y2/ll);
q1 = q2(1:floor(ll/2)+1,:);
q1(2:end-1) = 2*q1(2:end-1);


ff = fs*(0:floor(ll/2))/ll;

figure('Position',[100 50 350 300]);
ah = axes;
plot(ff,(q1-p1)./p1*100);
xlabel('frequency (Hz)')
% ylabel('percent change of acceleration amplitude')
ah.YTick
ah.YTickLabel = [num2str(ah.YTick') repmat('%',size(ah.YTick,2),1)];


figure('Position',[100 50 350 300]);
plot(ff,p1)
xlim([0 60])
xlabel('frequency (Hz)');
ylabel('accel (in/sec^2)');
hold all
plot(ff,(q1-p1));
legend({'original signal'; 'difference in signals'})

