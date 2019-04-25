function [strain,temp] = get_campbell_data(fdir,name,R,C)
%% get_campbell_data
% 
% optional R (rows) and C (cols) to skip. if empty R=4; C=2
%
% assumes:
% 
% * first 5 rows are header info - it is skipped
% * first 2 columns are time/date/timestep info - skipped also
% * channels are split by [gauge1 gauge2 temp1 temp2] column logic
%
%
% author: john devitis
% create date: 04-Aug-2016 04:17:58

    % setup defaults for optional inputs
    if nargin > 1; fdir = fullfile(fdir, name); end
    if nargin < 3; R = 4; end
    if nargin < 4; C = 2; end
    
    % Create file handle instance
    f = file();
    f.name = fdir; % populate handle properties
    
    % Read rows to determine channels
    strings = f.read;  % read every row into string
        
    try
        % import raw data
        rawdata = dlmread(fdir,',',R,C); % skip header rows and time columns
    catch
        % Resolve NAN read error
        match = regexp(strings,'"NAN"');    % find matches of NAN in each row

        for ii= 1:length(strings)        
            NAN_ind(ii) = isempty(match{ii});   % Record indices where no NAN's exist 
        end 
        % Find row to begin
        num_st = find(NAN_ind,1, 'first');
        num_end = find(NAN_ind,1, 'last');
        nan_st = find(~NAN_ind,1, 'first');
        nan_end = find(~NAN_ind,1, 'last');
        r_range = [max(num_st,R+1) min(nan_st, num_end)]
        R_new = r_range(1)-1;
        Ce = length(strsplit(strings{R_new},','))-1;
        % try again to import raw data
        rawdata = dlmread(fdir,',',[R_new C r_range(2)-1 Ce]); % skip header rows and time columns
    end
    
	
    % index strain and temp records
    nchans = size(rawdata,2);
%     if mod(nchans,2) ~= 0 % not even
%         error('not an even channel count, check the file')
%     end
    
    % Check if any channels are temperature
    temp_match = regexp(strings{1},'Temp'); % indices of the string 'Temp' in each row
    if ~isempty(temp_match)  % if there are channels with the 'Temp' in the header label
        if length(temp_match)~=nchans/2  % if half of the channels are not Temp channels
            error('temperature channels not equal to strain channels, check the file')
        else % if half of the channels are temperature channels
            strain = rawdata(:,1:nchans/2);     % concat left side
            temp = rawdata(:,nchans/2+1:end);   % concat right side
        end
    else % if there are no temperature channels
        strain = rawdata(:,1:nchans);   % write all channels to strain
        temp = [];
        disp('Note:  No temperature channels found in file. Strain only returned.');
    end

	
end
