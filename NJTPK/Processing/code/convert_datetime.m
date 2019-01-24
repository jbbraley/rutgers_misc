function b = convert_datetime(time)
%% convert_datetime
%
%
%
% author: john devitis
% create date: 23-Jan-2017 16:02:03

if nargin < 1, time = 1.407402319318948e+12; end

% current data storage and type format
scale = 1e9;            % nano seconds -> seconds
signed = false;         % signed or unsigned
word_length = 64;       % fxp word length in bits
fraction_length = 20;   % fxp fraction length in bits
time_format = 'dd-MMM-uuuu HH:mm:ss.SSSS';
time_zone = 'local';

% get fixed point number
a = fi(time,signed,word_length,fraction_length);

% form matlab datetime array
b = datetime(double(a.int)/scale,'ConvertFrom','posixtime',...
		'TimeZone',time_zone,'Format',time_format);

% convert datetime array to cell array of strings
%time_format_string = 'dd-mm-yyyy HH:MM:SS.FFF';
%time_string = datestr(b,time_format_string);
%time_string = cellstr(time_string);


end
