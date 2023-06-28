% file to read in Ocean Optics multiple spectrometer files, average scans and save
% as .csv.
function [data] = read_Horiba_profile

clear all

% choose files to convert
[filename, pathname]=uigetfile('*.txt','MultiSelect','on');
if ~iscell(filename) && ischar(filename)
    filename = {filename}; % force it to be a cell array of strings
end


for ii=1:length(filename)
    
   data=dlmread(strcat(pathname,filename{ii}),'\t',0,0);
%       if ii==1
%           data(:,1)=c(:,1);
%           data(:,2)=c(:,2);
%       else
%           data(:,ii+1)=c(:,2);
%       end
end

 
% dlmwrite(strcat(pathname,'_',filename(1:end-4),'.csv'),data,'precision','%f');


end





    