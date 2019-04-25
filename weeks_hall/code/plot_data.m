% get filename and path of data file
[fname, fdir] = uigetfile('.dat');

% import data
[date, data] = import_campbell_data(fdir,fname);

%% Plot formatting
% Date time format
dateform_l = 'eee h:mm a'; % For viewing long time histories. Ex: Wed 10:25 PM
dateform_s = 'h:mm:ss a'; % For viewing short time histories. Ex: 10:25:15 PM

%% Plot Time History
figure
plot(date, data.strain,'DatetimeTickFormat',dateform_s);
   

col_skip = 8;
col_num = 16;
row_skip = 4;
row_end = 735641;
flname = fullfile(fdir, fname)
data = dlmread(flname,',',[row_skip col_skip row_end col_skip+col_num-1]);



