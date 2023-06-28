% file to read in Ocean Optics multiple spectrometer files, average scans and save
% as .csv.
function [data] = read_Ondax_files

clear all

% % choose files to convert
% [filename, pathname]=uigetfile('*.csv','MultiSelect','on');
% if ~iscell(filename) && ischar(filename)
%     filename = {filename}; % force it to be a cell array of strings
% end
%Updated 6/28/2023 SF
%Changed to be directory select to avoid windows issue with large dataset
%selection

rootPath = uigetdir;
%Create regexp
csvFiles = fullfile(rootPath,'my*.csv'); %Add my so we don't include _my file


for ii=1:length(csvFiles)
    
   c=dlmread(fullfile(rootPath,csvFiles(ii).name),',',2,0);
      if ii==1
          data(:,1)=c(:,1);
          data(:,2)=c(:,2);
      else
          data(:,ii+1)=c(:,2);
      end
end

dlmwrite(strcat(rootPath,'_',csvFiles(ii).name(1:end-4),'.csv'),data,'precision','%f');

% if length(filename)>1
%     average_data(:,1)=data(:,1);
%     for qq=1:length(data)
%         average_data(qq,2)=mean(data(qq,2:end));
%     end
% dlmwrite(strcat(pathname,'_',filename{1}(1:end-4),'_average.csv'),average_data,'precision','%f');
% figure(1);
% plot(average_data(:,1),average_data(:,2),'b');
end





    