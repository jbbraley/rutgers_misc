% get directory for data
dirname = uigetdir();

fnames = ls([dirname '\*.txt']);

% choose file by index
display(fnames)
file_ind = 13;

% Load data
datfile = file();
datfile.name = fnames(file_ind,:);
datfile.path = dirname;
dat = dlmread(datfile.fullname,'\t');

% create time vector
fs = 400; %Hz
dt = 1/fs;
time = 0:dt:(size(dat,1)-1)*dt;

figure
plot(time,dat(:,:))

% Choose event windows
%import datatip data to "bounds"
clear tind
for ii = 1:length(bounds)
    tind(ii) = bounds(ii).DataIndex;
end
event_inds = reshape(tind,2,[])';
event_inds = event_inds(end:-1:1,end:-1:1);

% loop through data file and isolate events
clear data
for jj = 1:size(event_inds,1)
    data{jj} = dat(event_inds(jj,1):event_inds(jj,2),:);
end

% save data to file
% choose location to save data files
putdir = uigetdir(dirname);
base_name = [num2str(fs) 'Hz_4_event'];
putfile = file();
putfile.path = putdir;
putfile.ext = '.txt';
for jj = 1:length(data)
    putfile.name = [base_name num2str(jj+3)];
    dlmwrite(putfile.fullname, data{jj}, '\t');
end