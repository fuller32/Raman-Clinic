% file to read in Ocean Optics multiple spectrometer files, average scans and save
% as .csv.
function [data] = read_ocean_optics_files

clear all

% choose files to convert
[filename, pathname]=uigetfile('*.txt','MultiSelect','on');
if ~iscell(filename) && ischar(filename)
    filename = {filename}; % force it to be a cell array of strings
end


for ii=1:length(filename)
    
      fid=fopen(strcat(pathname,filename{ii}));
      for xx=1:14
          fgetl(fid);
      end
      [c, a]=fscanf(fid,'%f %f',[2 inf]);
      fclose(fid);
      c=c';
      if ii==1
          data(:,1)=c(:,1);
          data(:,2)=c(:,2);
      else
          data(:,ii+1)=c(:,2);
      end
      % use dlmwrite instead of csvwrite because csvwrite limited to 5
      % significant digits
      %dlmwrite(strcat(pathname,filename{ii}(1:end-4),'.csv'),c,'precision','%f');
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





    