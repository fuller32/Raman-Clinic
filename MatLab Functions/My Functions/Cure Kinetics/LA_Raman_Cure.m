function LA_Raman_Cure(obj)

disp("Setting up paths")
path = fullfile(obj.savefilePath,"Variables",[obj.activeTest,'.mat']);

load(path,'data');
name = obj.activeTest;
Figname = strrep(name,'_',' ');

plotSavePath = fullfile(obj.savefilePath,"Plots");
figureSavePath = fullfile(plotSavePath,"Figures");

settings = obj.fntOrder.Epon828.LA_Raman_Cure.settings;

progBar = uiprogressdlg(obj.figure,"Title","Creating Plots",...
    "Indeterminate","on");

range = str2num(string(settings(4)));
RSL1 = -300;
RSL2 = 300;


[n m] = size(data);
RS = data(:,1);
RSL1n = findpeak(RS,RSL1);
RSL2n = findpeak(RS,RSL2);
I = data(:,2:m);

disp("Creating LA Raman Plot")
RamanPlot = figure("Visible","off");
I = removeoutliers(I);
I = I(RSL2n:RSL1n,:);
RS = RS(RSL2n:RSL1n,:);



P1 = 14;
P2 = 85;

[vH vHi]=findpeak(RS,P1,3);
[vL vLi]=findpeak(RS,P2,7);
[q w] = size(I);
if str2num(string(settings(6))) ~= 0
    F = ones(size(I)); 
    for i = 1:m-1
        P = [I(1,i)  I(143,i) I(144,i)  I(286,i)];
        PR = [RS(1)  RS(143) RS(144)  RS(286)];
        X = polyfit(PR,P,str2num(string(settings(6))));
        F(:,i) = polyval(X,RS);
    end
    I = I-F;
elseif str2num(string(settings(6))) == 0
    I = I;
end

In = I./max(I(vLi,:));
plot(RS,In)
xlabel('Raman Shift (cm^-^1)')
ylabel('Counts (arb.)')
axis padded
title(Figname)
str = strjoin(["Saving  LA Raman Plot",fullfile(plotSavePath,'LA_Raman_Plot.png')]);
disp(str);
saveas(RamanPlot,fullfile(plotSavePath,'LA_Raman_Plot.png'))
imageData = getframe(RamanPlot);
imwrite(imageData.cdata,fullfile(plotSavePath,'LA_Raman_Plot.png'));


[n m] = size(data);
[y, mm, d, h, mn, s]=datevec(string(obj.activeTestInfo.("Experiment Start csv")));
Ti = 1440*d+60*h+mn+s/60;
[y, mm, d, h, mn, s]=datevec(string(obj.activeTestInfo.("Experiment Stop csv")));
Tf = 1440*d+60*h+mn+s/60;
Tmax = Tf-Ti;

dt = 60*Tmax/(m-1);
t =1:m-1;
T = t*dt;
% figure
% [X Y] = meshgrid(T,RS);
% surf(X,Y, I./max(I(vLi,:)))
% axis([0 60 1590 1650 0 1.1])

disp("Creating LA Cure Kinetics Plot")
if obj.hidePlots == 1
    cureKinetics = figure('Visible','off');
else
    cureKinetics = figure;
end
Ir = sum(I(vHi,:))./sum(I(vLi,:));
alpha = (Ir(1)-Ir)./Ir(1);
plot(T,alpha,'b.')
axis padded
xlabel('Time (s)')
ylabel('Conversion')
title({Figname, 'Extent of Cure Kinetics'})
str = strjoin(["Saving Cure Kinetics Plot",fullfile(plotSavePath,'LA_Cure_Kinetics.png')]);
disp(str)
imageData = getframe(cureKinetics);
imwrite(imageData.cdata,fullfile(plotSavePath,'LA_Cure_Kinetics.png'));

hold off

range = str2num(string(settings(5)))- str2num(string(settings(4)));

if range == 0
else
    T = T(1+str2num(string(settings(4))):str2num(string(settings(5))));
    alpha = alpha(1+str2num(string(settings(4))):str2num(string(settings(5))));
end

Fitp = obj.fntOrder.Epon828.LA_Raman_Cure.settings(7:end);

a = str2num(char(Fitp(1))):str2num(char(Fitp(3))):str2num(char(Fitp(2)));
k = str2num(char(Fitp(4))):str2num(char(Fitp(6))):str2num(char(Fitp(5)));
n = str2num(char(Fitp(7))):str2num(char(Fitp(9))):str2num(char(Fitp(8)));

delete(progBar)

disp("Calculating fit")
progBar = uiprogressdlg(obj.figure,"Title","Calculating Fit","Indeterminate","on");
lowerValues = [str2double(settings{7}) str2double(settings{10}) str2double(settings{13})];
upperValues = [str2double(settings{8}) str2double(settings{11}) str2double(settings{14})];
%[fitparams, sse] = stepfittingreactionkinetics(T',alpha',a,k,n,0);
[fitparams, gof] = stepfittingreactionkinetics_NLLS(T,alpha,lowerValues,upperValues);
sse = gof.sse;
results = fitparams;
delete(progBar);
disp("Fit calculated")
a = fitparams.au;
k = fitparams.k;
n = fitparams.n;
disp("Creating Cure Kinetics Fit Plot")

if obj.hidePlots == 1
    kineticsFit = figure('Visible','off');
else
    kineticsFit = figure;
end

plot(fitparams,T,alpha)
legend("off");
axis padded
xlabel('Time (s)')
ylabel('Conversion')
title({Figname, 'Extent of Cure Kinetics'})
s = {['\alpha_u = ' num2str(a)]...
    ['k = ' num2str(k)] ...
    ['n = ' num2str(n)]...
    ['SSE = ' num2str(sse)]};
text(max(T)*.7,.1,s)
delete(progBar);
str = strjoin(["Saving LA Cure Kinetics Fit Plot",fullfile(plotSavePath,'LA_Cure_Kinetics_Fit.png')]);
disp(str)
imageData = getframe(kineticsFit);
imwrite(imageData.cdata,fullfile(plotSavePath,'LA_Cure_Kinetics_Fit.png'));

progBar = uiprogressdlg(obj.figure,"Title","Saving Files",...
    "Indeterminate","on");

R = [alpha;T];
if range == 0
    path = fullfile(obj.savefilePath,"Variables",['Epoxy_',name,'__LA_full_range.csv']);
    writematrix(R,path);
else
    path = fullfile(obj.savefilePath,"Variables",['Epoxy_',name,'_LA_',num2str(range),'s.csv']);
    writematrix(R,path);
end

plotData.x = T;
plotData.y = alpha;

comp = mexext;
if 1 == strcmp(comp,'mexw64')
    path = fullfile(obj.savefilePath,"Variables",['Epoxy_',name,'_LA_',num2str(range),'s_fitparameters','settings']);
    save(path,'fitparams','gof','-v7.3');
    path = fullfile(obj.savefilePath,"Variables","LA_Kinetics_PlotData");
    save(path,'plotData','-v7.3')
else
    disp("Your machine is 32-bit and may have issues with saving matlab variables greater then 2GB")
    path = fullfile(obj.savefilePath,"Variables",['Epoxy_',name,'_LA_',num2str(range),'s_fitparameters','settings']);
    save(path,'fitparams','gof');
    path = fullfile(obj.savefilePath,"Variables","LA_Kinetics_PlotData");
    save(path,'plotData')
end
delete(progBar);

switch obj.savePlotFigs
    case 0
        disp("Setting not selected to save off plot figures")
    case 1
        disp("Saving Plot figures");
        progBar = uiprogressdlg(obj.figure,"Title","Saving Plot Figures");
        progBar.Message = "Saving LA Raman Plot";
        path = fullfile(obj.savefilePath,"Variables",[name,'.mat']);
        loc = dir(path);
        if loc.bytes < (obj.plotFileSizeLimit*1024^2*4) %Added a 4 times multipier since these are smaller.
            disp("Saving LA Raman Plot");
            saveLoc = fullfile(figureSavePath,"LA_Raman_Plot.fig");
            str = strjoin(["LA Raman Plot saved at",saveLoc]);
            savefig(RamanPlot,saveLoc,"compact");
            disp(str);
        else
            str = strjoin(["Figure exceeds maximum figure size.",num2str(loc.bytes),"bytes"]);
            disp(str);
        end

        progBar.Message = "Saving LA Cure Kinetics Plot";
        progBar.Value = .33;
        disp("Saving LA Cure Kinetics Plot");
        saveLoc = fullfile(figureSavePath,"LA_Cure_kinetics_Plot.fig");
        str = strjoin(["LA_Cure Kinetics Plot saved at",saveLoc]);
        savefig(cureKinetics,saveLoc,"compact");
        disp(str);

        progBar.Message = "Saving LA Cure Kinetics Fit Plot";
        progBar.Value = .66;
        disp("Saving LA Cure Kinetics Fit Plot");
        saveLoc = fullfile(figureSavePath,"LA_Cure_kinetics_fit_Plot.fig");
        str = strjoin(["LA Cure Kinetics Fit Plot saved at",saveLoc]);
        savefig(kineticsFit,saveLoc,"compact");
        disp(str);

        progBar.Value = 1;
        delete(progBar)
end

end
