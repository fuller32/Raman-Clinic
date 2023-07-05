% file to read in Ocean Optics multiple spectrometer files, average scans and save
% as .csv.
function [data] = read_Ondax_files(obj)
% % choose files to convert
% [filename, pathname]=uigetfile('*.csv','MultiSelect','on');
% if ~iscell(filename) && ischar(filename)
%     filename = {filename}; % force it to be a cell array of strings
% end
%Updated 6/28/2023 SF
%Changed to be directory select to avoid windows issue with large dataset
%selection

%Create regexp
rootPath = fullfile(cd,"Data",obj.activeTest);
csvRegExp = fullfile(rootPath,'my*.csv'); %Add my so we don't include _my file
csvFiles = dir(csvRegExp);

fullLength = length(csvFiles);
progBar = uiprogressdlg(obj.figure,"Title","Reading in Ondax files");

for ii=1:fullLength
    
   c=dlmread(fullfile(rootPath,csvFiles(ii).name),',',2,0);
      if ii==1
          data(:,1)=c(:,1);
          data(:,2)=c(:,2);
      else
          data(:,ii+1)=c(:,2);
      end
  % Added so I can see where we are in the loop.
  progBar.Value = ii/fullLength;

end
disp("Succesfully read in all CSVs.")
delete(progBar);
str = strjoin(["Writing out compiled CSV to",fullfile(obj.savefilePath,"Variables")]);
disp(str)
savePath = fullfile(obj.savefilePath,"Variables",['_',csvFiles(ii).name(1:end-4),'.csv']);

progBar = uiprogressdlg(obj.figure,"Title","Writing out Ondax files",...
    "Indeterminate","on");
writematrix(data,savePath); %Significantly faster and uses less memory
delete(progBar);
str = strjoin(["Succesfully wrote compiled CSV to",fullfile(obj.savefilePath,"Variables")]);
disp(str);

% if length(filename)>1
%     average_data(:,1)=data(:,1);
%     for qq=1:length(data)
%         average_data(qq,2)=mean(data(qq,2:end));
%     end
% dlmwrite(strcat(pathname,'_',filename{1}(1:end-4),'_average.csv'),average_data,'precision','%f');
% figure(1);
% plot(average_data(:,1),average_data(:,2),'b');
end





    