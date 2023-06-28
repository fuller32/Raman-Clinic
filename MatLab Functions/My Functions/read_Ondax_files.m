% file to read in Ocean Optics multiple spectrometer files, average scans and save
% as .csv.
function [data] = read_Ondax_files

clear all

% choose files to convert
[filename, pathname]=uigetfile('*.csv','MultiSelect','on');
if ~iscell(filename) && ischar(filename)
    filename = {filename}; % force it to be a cell array of strings
end


for ii=1:length(filename)
    
   c=dlmread(strcat(pathname,filename{ii}),',',2,0);
      if ii==1
          data(:,1)=c(:,1);
          data(:,2)=c(:,2);
      else
          data(:,ii+1)=c(:,2);
      end
end

dlmwrite(strcat(pathname,'_',filename{ii}(1:end-4),'.csv'),data,'precision','%f');

% if length(filename)>1
%     average_data(:,1)=data(:,1);
%     for qq=1:length(data)
%         average_data(qq,2)=mean(data(qq,2:end));
%     end
% dlmwrite(strcat(pathname,'_',filename{1}(1:end-4),'_average.csv'),average_data,'precision','%f');
% figure(1);
% plot(average_data(:,1),average_data(:,2),'b');
end





    