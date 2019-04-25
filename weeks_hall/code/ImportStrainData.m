%% Import all of the strain Data (Campbell)
% Uses file class 

% Data path
fdir = 'E:\data\weeks\converted';
fh = file();
fh.path = fdir;
% Find all files with the following match
fname_base = 'TOA5_20Hz_strain_data_';
base_char = length(fname_base);
% All files in the data path
fnames = dir(fdir);

%% Loop through all files
data = [];
date = [];
order = [];
n=1;
for ii = 3:size(fnames,1)
    % Find matching filenames
    if length(fnames(ii).name)>base_char && strcmp(fnames(ii).name(1:base_char),fname_base)
        % Populate file handle with file name
        fh.name = fnames(ii).name;
        % Import Data
        [date{n}, data(n)] = import_campbell_data(fdir,fnames(ii).name);
        % Record File number
        order(n) = str2double(fnames(ii).name(base_char+1:end-4));
        max_time(n) = date{n}(end);
        n=n+1;
    end
end

% Sort files by date
[~, order_time] = sort(max_time);

%Reorder cell array of data
for ii = 1:length(order_time)
    strain{ii} = data{order_time(ii)}.strain(:,1:12);
    % Zero strain data
    for jj=1:size(strain{ii},2)
        strain_z{ii}(:,jj) = strain{ii}(:,jj)-mean(strain{ii}(:,jj));
    end
end
dates = date(order_time);

%% Save imported Data
save('StrainData','strain_z','dates');

%% Plot formatting
% Date time format
dateform_l = 'eee h:mm a'; % For viewing long time histories. Ex: Wed 10:25 PM
dateform_s = 'h:mm:ss a'; % For viewing short time histories. Ex: 10:25:15 PM

%% Plot Time Histories
figure
for ii = 1:length(strain)
    plot(dates{ii}, strain_z{ii},'DatetimeTickFormat',dateform_l);
    ylim([-100 200]);
    pause
end

%% Plot all data continuously
% Concat data
strainz_all = cell2mat(strain_z');
strain_all = cell2mat(strain');
% Zero
zero_ind = 1050000:1200000;
for jj=1:size(strain_all,2)
        strain_all_z(:,jj) = strain_all(:,jj)-mean(strain_all(zero_ind,jj));
end

% Concat time stamps
time_all = [];
for ii = 1:length(dates)
    time_all = cat(2,time_all, dates{ii});
end

% set labels
dof.labels = {'BF Midspan G1' ...
              'BF Midspan G4' ...
              'BF Midspan G5' ...
              'WEB Midspan G4' ...
              'BF 3/4 span G4' ...
              'Web Box Girder' ...
              'RIGHT BF'...
              'LEFT BF' ...
              'WEB LOWER' ...
              'WEB UPPER'...
              'Top Box Girder' ...
              'Bottom Box Girder'};
          
%Plot all
figure
plot(time_all,strain_all_z,'DatetimeTickFormat',dateform_l)
ylim([-150 200]);
legend(dof.labels);

%% Isolate period of greatest response
isol_ind = 1580000:2700000;
strain_reg = strainz_all(isol_ind,:);
time_reg = time_all(isol_ind);

%% Save concatted data
save('CatStrain','strainz_all','strain_all_z','strain_all','time_all');
