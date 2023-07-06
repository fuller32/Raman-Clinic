function [Data] = Epoxy_Raman_Cure(obj)

disp("Setting up paths")
path = fullfile(obj.savefilePath,"Variables",[obj.activeTest,'.mat']);

load(path,'data');
name = obj.activeTest;
Figname = strrep(name,'_',' ');

plotSavePath = fullfile(obj.savefilePath,"Plots");

settings = obj.fntOrder.Epon828.Epoxy_Raman_Cure.settings;

range = str2num(string(settings(4)));
RSL1 = 1000;
RSL2 = 1300;


[n m] = size(data);
RS = data(:,1);
RSL1n = findpeak(RS,RSL1);
RSL2n = findpeak(RS,RSL2);
I = data(:,2:m);

disp("Creating Raman Plot")
RamanPlot = figure;
plot(RS,I);
xlabel('Raman Shift (cm^-^1)');
ylabel('Counts (arb.)');
axis("padded");
title(Figname);
str = strjoin(["Saving Raman Plot",fullfile(plotSavePath,'Raman_Plot.png')]);
disp(str)
saveas(RamanPlot,fullfile(plotSavePath,'Raman_Plot.png'))

disp("Creating Reduced Raman Plot")
reducedRaman = figure;
I = removeoutliers(I);
I = I(RSL2n:RSL1n,:);
RS = RS(RSL2n:RSL1n,:);

P1 = 1250;
P2 = 1103;

[vH vHi]=findpeak(RS,P1,7);
[vL vLi]=findpeak(RS,P2,7);
Lambda = str2num(string(settings(6)));
[I,X] = airPLS(I',Lambda);
I=I';
I = removeoutliers(I);
In = I./max(I(vLi,:));
plot(RS,In)
xlabel('Raman Shift (cm^-^1)');
ylabel('Counts (arb.)');
axis("padded");
title(Figname);
str = strjoin(["Saving Reduced Raman Plot",fullfile(plotSavePath,'Reduced_Raman.png')]);
disp(str)
saveas(reducedRaman,fullfile(plotSavePath,'Reduced_Raman.png'));



[n m] = size(data);
[y, mm, d, h, mn, s]=datevec(string(obj.activeTestInfo.("Experiment Start csv")));
Ti = 1440*d+60*h+mn+s/60;
[y, mm, d, h, mn, s]=datevec(string(obj.activeTestInfo.("Experiment Stop csv")));
Tf = 1440*d+60*h+mn+s/60;
Tmax = Tf-Ti;

dt = 60*Tmax/(m-1);
t =1:m-1;
T = t*dt;
disp("Creating Surface Plot")
surfPlot = figure;
[X Y] = meshgrid(T,RS);
surf(X,Y, I./max(I(vLi,:)))
%axis([0 60 1590 1650 0 1.1]) Commented out since current frame removes all
%data.
str = strjoin(["Saving Surface Plot",fullfile(plotSavePath,'Surf_Plot.png')]);
disp(str)
saveas(surfPlot,fullfile(plotSavePath,'Surf_Plot.png'));

disp("Creating Cure Kinetics Plot")
cureKinetics = figure;
Ir = sum(I(vHi,:))./sum(I(vLi,:));
alpha = (Ir(1)-Ir)./Ir(1);
plot(T,alpha,'b.')
axis padded
xlabel('Time (s)')
ylabel('Conversion')
title({Figname, 'Extent of Cure Kinetics'})
str = strjoin(["Saving Cure Kinetics Plot",fullfile(plotSavePath,'Cure_Kinetics.png')]);
disp(str)
saveas(cureKinetics,fullfile(plotSavePath,'Cure_Kinetics.png'));
hold off

range = str2num(string(settings(5)))- str2num(string(settings(4)));

if range == 0
else
    T = T(1+str2num(string(settings(4))):str2num(string(settings(5))));
    alpha = alpha(1+str2num(string(settings(4))):str2num(string(settings(5))));
end

Fitp = obj.fntOrder.Epon828.Epoxy_Raman_Cure.settings(7:end);

a = str2num(char(Fitp(1))):str2num(char(Fitp(3))):str2num(char(Fitp(2)));
k = str2num(char(Fitp(4))):str2num(char(Fitp(6))):str2num(char(Fitp(5)));
n = str2num(char(Fitp(7))):str2num(char(Fitp(9))):str2num(char(Fitp(8)));


disp("Calculating fit may take awhile to complete")
[fitparams, sse] = stepfittingreactionkinetics(T',alpha',a,k,n,0);

a = fitparams.au;
k = fitparams.k;
n = fitparams.n;
disp("Creating Cure Kinetics Fit Plot")
kineticsFit = figure;
[fitparams, sse] = stepfittingreactionkinetics(T',alpha',a,k,n,1);
disp("Fit calculated may take awhile to complete")
axis padded
xlabel('Time (s)')
ylabel('Conversion')
title({Figname, 'Extent of Cure Kinetics'})
s = {['\alpha_u = ' num2str(fitparams.au)]...
    ['k = ' num2str(fitparams.k)] ...
    ['n = ' num2str(fitparams.n)]...
    ['SSE = ' num2str(sse)]};
disp(s)
text(max(T)*.7,.1,s)

str = strjoin(["Saving Cure Kinetics Fit Plot",fullfile(plotSavePath,'Cure_Kinetics_Fit.png')]);
disp(str)
saveas(kineticsFit,fullfile(plotSavePath,'Cure_Kinetics_Fit.png'));

R = [alpha;T];
if range == 0
    path = fullfile(obj.savefilePath,"Variables",['Epoxy_',name,'_full_range.csv']);
    writematrix(R,path);
else
    path = fullfile(obj.savefilePath,"Variables",['Epoxy_',name,'_',num2str(range),'s.csv']);
    writematrix(R,path);
end
%Updated 6/28/2023 SF
%Have the save function set to version -7.3 to allow for variables of size
%>=2GB. Needs to be a 64 bit machine to work so check has been added.

comp = mexext;
if 1 == strcmp(comp,'mexw64')
    path = fullfile(obj.savefilePath,"Variables",['Epoxy_',name,'_',num2str(range),'s_fitparameters','settings']);
    save(path,'fitparams','-v7.3');
else
    disp("Your machine is 32-bit and may have issues with saving matlab variables greater then 2GB")
    path = fullfile(obj.savefilePath,"Variables",['Epoxy_',name,'_',num2str(range),'s_fitparameters','settings']);
    save(path,'fitparams');
end

end
