function [date, data] = import_campbell_data(fdir,name,R,C)
%% import_campbell_data
% 
% * uses file class - https://github.com/johndevitis/file 
% 
% author: John Braley
% create date: 19-Aug-2016 14:11:03
	
    % Declare file instance
    f = file();
    % setup filename for optional inputs
    if nargin == 1; f.name = fdir; fdir = f.path; name = [f.name f.ext]; end    
    if nargin < 3; R = 4; end
    if nargin < 4; C = 2; end    
    
    % Get campbell data
    [strain,temp] = get_campbell_data(fdir,name,R,C);
    
    % Write data to data structure
    data.strain = strain;
    % Only add temp field if temperature data existed
    if ~isempty(temp)
        data.temp = temp;
    end
    
    % Get dates from campbell file
    [dates,~] = get_campbell_dates(fdir,name);
    % Keep only dates that correspond to data pulled
    date = dates(end-size(strain,1)+1:end);	
	
end
