function [dates,date_strings] = get_campbell_dates(fdir,name)
%% get_campbell_data
%
% dates - matlab array of datetime objects
% time - in days 
% date_strings - cell array of raw time info
%
% * uses file class - https://github.com/johndevitis/file
%
% ASSUMES:
% * header ends at line 5, data begins at line 6
% * first vector is strings of dates inside of quotes "2016-05-11 16:45:00"
% 
% author: john devitis
% create date: 04-Aug-2016 04:17:58

    if nargin > 1
        fdir = fullfile(fdir,name);
    end
        
    % create instance of file class
	f = file();
    f.name = fdir;
    
    % 4 Header lines. Data starts on line 5
    Hlines = 4;
    filedata = readtable(fdir,'Delimiter',',','ReadVariableNames',false,'HeaderLines',Hlines);
    
    % Convert table to array
    date_strings = table2array(filedata(:,1));
    
    % Find length of strings
    string_length = zeros(1,size(date_strings,1));
    for ii = 1:size(date_strings,1)
        string_length(ii) = length(date_strings{ii});
    end
    
    % Index different lengths
    % Date to the second - 19
    sec = find(string_length==19);
    % Date to the millisecond - 22
    milli = find(string_length>20);
            
	% convert string to matlab datetime object 
    dates(sec) = datetime(date_strings(sec),'InputFormat','yyyy-MM-dd HH:mm:ss');
    dates(milli) = datetime(date_strings(milli),'InputFormat','yyyy-MM-dd HH:mm:ss.SS');
	
end
