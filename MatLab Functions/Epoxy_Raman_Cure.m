function [Data] = Epoxy_Raman_Cure
prompt = {'MAT-File','Start Time', 'End Time','Time Lower Limit',...
    'Time Upper Limit','Lambda'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'','mm-dd-yyyy HH:MM:SS','mm-dd-yyyy HH:MM:SS','0','0','1000'};
Inputs = inputdlg(prompt,dlgtitle,dims,definput);

load(string(Inputs(1)))
name = string(Inputs(1));
Figname = strrep(name,'_',' ');

range = str2num(string(Inputs(4)));
RSL1 = 1000;
RSL2 = 1300;


[n m] = size(Db);
RS = Db(:,1);
RSL1n = findpeak(RS,RSL1);
RSL2n = findpeak(RS,RSL2);
I = Db(:,2:m);


plot(RS,I)
xlabel('Raman Shift (cm^-^1)')
ylabel('Counts (arb.)')
axis padded
title(Figname)
figure
I = removeoutliers(I);
I = I(RSL2n:RSL1n,:);
RS = RS(RSL2n:RSL1n,:);

P1 = 1250;
P2 = 1103;

[vH vHi]=findpeak(RS,P1,7);
[vL vLi]=findpeak(RS,P2,7);
Lambda = str2num(string(Inputs(6)));
[I,X] = airPLS(I',Lambda);
I=I';
I = removeoutliers(I);
In = I./max(I(vLi,:));
plot(RS,In)
xlabel('Raman Shift (cm^-^1)')
ylabel('Counts (arb.)')
axis padded
title(Figname)




[n m] = size(Db);
[y, mm, d, h, mn, s]=datevec(string(Inputs(2)),'mm-dd-yyyy HH:MM:SS');
Ti = 1440*d+60*h+mn+s/60;
[y, mm, d, h, mn, s]=datevec(string(Inputs(3)),'mm-dd-yyyy HH:MM:SS');
Tf = 1440*d+60*h+mn+s/60;
Tmax = Tf-Ti;

dt = 60*Tmax/(m-1);
t =1:m-1;
T = t*dt;
figure
[X Y] = meshgrid(T,RS);
surf(X,Y, I./max(I(vLi,:)))
axis([0 60 1590 1650 0 1.1])


figure
Ir = sum(I(vHi,:))./sum(I(vLi,:));
alpha = (Ir(1)-Ir)./Ir(1);
plot(T,alpha,'b.')
axis padded
xlabel('Time (s)')
ylabel('Conversion')
title({Figname, 'Extent of Cure Kinetics'})

hold off

range = str2num(string(Inputs(5)))- str2num(string(Inputs(4)));

if range == 0
else
    T = T(1+str2num(string(Inputs(4))):str2num(string(Inputs(5))));
    alpha = alpha(1+str2num(string(Inputs(4))):str2num(string(Inputs(5))));
end

prompt = {'/alpha_u Min Value','/alpha_u Max Value','/alpha_u Step Size',...
    'k Min Value','k Max Value','k Step Size','n Min Value','n Max Value','n Step Size'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'.1','1','.01','0.01','1','0.01','1','10','.1'};
Fitp = inputdlg(prompt,dlgtitle,dims,definput);

a = str2num(char(Fitp(1))):str2num(char(Fitp(3))):str2num(char(Fitp(2)));
k = str2num(char(Fitp(4))):str2num(char(Fitp(6))):str2num(char(Fitp(5)));
n = str2num(char(Fitp(7))):str2num(char(Fitp(9))):str2num(char(Fitp(8)));


[fitparams, sse] = stepfittingreactionkinetics(T',alpha',a,k,n,0);

a = fitparams.au;
k = fitparams.k;
n = fitparams.n;
figure
[fitparams, sse] = stepfittingreactionkinetics(T',alpha',a,k,n,1);

axis padded
xlabel('Time (s)')
ylabel('Conversion')
title({Figname, 'Extent of Cure Kinetics'})
s = {['\alpha_u = ' num2str(fitparams.au)]...
    ['k = ' num2str(fitparams.k)] ...
    ['n = ' num2str(fitparams.n)]...
    ['SSE = ' num2str(sse)]}
text(max(T)*.7,.1,s)
R = [alpha;T];
if range == 0
    writematrix(R,'Epoxy' + name + '_full_range.csv')
else
    writematrix(R,'Epoxy' + name + '_'+ num2str(range)+ 's.csv')
end


save('Epoxy' + name + '_' + num2str(range) + 's_fitparameters','fitparams')
end
