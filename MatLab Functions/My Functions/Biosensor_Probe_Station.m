clear; close all; clc;

% Run Input Paramater GUI%

prompt = {'Staring Voltage (V)','Final Voltage (V)',...
    'Voltage Stepsize (V)','Chip ID','Reader ID','Repetitions'};

date = string(datetime(now,'ConvertFrom','datenum'));
dlgtitle = date;
dims = [1 50];
definput = {'0','1.2','0.01','B3-W1-D20', 'BR-BB-003','5'};

Vset = inputdlg(prompt,dlgtitle,dims,definput);
Vmin = str2double(Vset{1});
Vmax = str2double(Vset{2});
dV = str2double(Vset{3});
if Vmax < Vmin
    dV = -dV;
end
ID = strcat({'Chip ID:'}, Vset{4},{' Reader ID:'},Vset{5});
n = str2double(Vset{6});

list = {'Forward','Forwad & Back'};
d = listdlg('PromptString','Select Scan Direction',...
    'ListString',list,'SelectionMode','single','ListSize',[150,50]);

v = Vmin:dV:Vmax;
if d == 2
   v = [v flip(v)];
end
m = length(v);

%Open COM and Configure Source Meter & Picoammeter%

port = 'COM7';
s = serial(port, 'BaudRate', 9600);
s.Terminator = 'CR';
port = 'COM1';
p = serial(port, 'BaudRate', 9600);
p.Terminator = 'CR';

fopen(s);
fopen(p);

fprintf(s,"SOUR:FUNC VOLT");
fprintf(s,"SOUR:VOLT:MODE FIX");
fprintf(s,"SOUR:VOLT:RANG 1");
fprintf(s,"SENS:CURR:PROT 0.01");
fprintf(s,"SOUR:VOLT:LEV 0");
fprintf(s,"OUTP:STAT ON");
fprintf(s,"SOUR:CLE:AUTO OFF");
fprintf(s,"INIT");
fprintf(s,":FORM:ELEM CURR");

fprintf(p,"*RST");
fscanf(p);
fprintf(p,"FORM:ELEM READ");
fscanf(p);
fprintf(p,"TRIG:DEL 0");
fscanf(p);
fprintf(p,"TRIG:COUN 1");
fscanf(p);
fprintf(p,"NPLC .001");
fscanf(p);
fprintf(p,"RANG .010");
fscanf(p);
fprintf(p,"SYST:ZCH OFF");
fscanf(p);
fprintf(p,"SYST:AZER:STAT OFF");
fscanf(p);
fprintf(p,"DISP:ENAB OFF");
fscanf(p);
fprintf(p,"*CLS");
fscanf(p);
fprintf(p,"TRAC:POIN 1");
fscanf(p);
fprintf(p,"STAT:MEAS:ENAB 512");
fscanf(p);

% Run Measureemnt Loop%

i = zeros(n,m);

f = waitbar(0,['Measurement Number ', num2str(0), ' of ' num2str(n)]);
for j = 1:n
    f = waitbar(j./n,f,['Measurement Number ' num2str(j) ' of ' num2str(n)]);
    tic
    for k = 1:m
        g = ['SOUR:VOLT:LEV ' num2str(v(k))];
        fprintf(s,g);
        fprintf(s,"TRAC:FEED:CONT NEV");
        fprintf(s,"TRAC:CLE");
        fprintf(s,"READ?");
        fscanf(s);
        fprintf(s,"TRAC:CLE");
        fprintf(p,"TRAC:FEED:CONT NEXT");
        fscanf(p);
        fprintf(p,"INIT");
        fscanf(p);
        fprintf(p,"TRAC:DATA?");
        fscanf(p);
        i(j,k) = str2double(strsplit(char(fscanf(p)),','));
        fprintf(p,"TRAC:FEED:CONT NEV");
        fscanf(p);
        fprintf(p,"TRAC:CLE");
        fscanf(p);
        pause(0.5)
    end
    toc
end
close(f)

fprintf(p,"DISP:ENAB ON");
fscanf(p);
fprintf(s,"OUTP:STAT OFF");
%Close serial port conections%

fclose(s);
fclose(p);

%Plot results%

i = i*1000;
fig = plot(v,i);
xlabel('Voltage (V)')
ylabel('Current (mA)')
axis tight
title(date,ID)

if n >= 2
    i_m = mean(i);
    i_std = std(i);
    figure
    fig2 = errorbar(v,i_m,i_std);
    ylabel('Current (mA)')
    axis tight
    title(date,ID,'Mean Scan')
end

%Save data%

t = strrep(strcat(date,{'_'},ID),' ','_');
t = strrep(t,'-','_');
t = strrep(t,':','_');
if n == 1
    R = [v;i];
else
    R = [v;i;i_m;i_std];
end
save(t,'R')
writematrix(R,strcat(t, '.csv'))
saveas(fig,t,'jpg')
if n >= 2
    saveas(fig2,strcat(t,{'_mean'}))
end