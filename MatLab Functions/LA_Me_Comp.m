clear all; close all;clc;
%%
load('RK-01-30-3_LA_0s_fitparameters');
LA = [fitparams.time fitparams.conversion fitparams.fitting];
load('RK-01-30-3_0s_fitparameters');
Me = [fitparams.time fitparams.conversion fitparams.fitting];

% subplot(2,2,1)
% plot(LA(:,1),LA(:,2),'r')
% hold on
% plot(Me(:,1),Me(:,2),'b')
% 
% axis padded
% subplot(2,2,2)
figure
plot(LA(:,1),Me(:,2)./LA(:,2),'k--')
xlabel('Time (s)')
ylabel('Proportionality')
title({'RK-01-32-1' 'PM-EM828'})
axis([0 3500 1.8 2.8])
% 
% subplot(2,2,3)
% plot(LA(:,1),LA(:,3),'r')
% hold on
% plot(Me(:,1),Me(:,3),'b')
% axis padded
% subplot(2,2,4)
% figure
% plot(LA(:,1),Me(:,2)./LA(:,2),'k--')
% figure
% axis padded
% mean(Me(:,3)./LA(:,3))
% std(Me(:,3)./LA(:,3))
% 
figure
c = mean(Me(35:3244,2)./LA(35:3244,2))
MSR = mean((Me(:,2)-c.*LA(:,2)).^2)
std(Me(35:3244,2)./LA(35:3244,2))
plot(Me(:,1),Me(:,2),'b')
hold on
plot(LA(:,1),c.*LA(:,2),'r')
axis padded
title({'RK-01-32-1' 'PM-EM828' ['c = ' num2str(c) '   MSR = ' num2str(MSR)]})
legend('Methacrylate','Structural','Location','Southeast')
xlabel('Time (s)')
ylabel('Conversion')

%%
figure
load('AMS-01-5-11_LA_0s_fitparameters');
LA = [fitparams.time fitparams.conversion fitparams.fitting];
load('AMS-01-5-11_0s_fitparameters');
Me = [fitparams.time fitparams.conversion fitparams.fitting];

% subplot(2,2,1)
% plot(LA(:,1),LA(:,2),'r')
% hold on
% plot(Me(:,1),Me(:,2),'b')
% 
% axis padded
% subplot(2,2,2)
% plot(LA(:,1),Me(:,2)./LA(:,2),'k--')
% axis padded
% 
% subplot(2,2,3)
% plot(LA(:,1),LA(:,3),'r')
% hold on
% plot(Me(:,1),Me(:,3),'b')
% axis padded
% subplot(2,2,4)
% plot(LA(:,1),Me(:,3)./LA(:,3),'k--')
% axis padded
% mean(Me(:,3)./LA(:,3))
% std(Me(:,3)./LA(:,3))
% 
% figure
c = mean(Me(35:3480,2)./LA(35:3480,2))
MSR = mean((Me(:,2)-c.*LA(:,2)).^2)
std(Me(35:3480,2)./LA(35:3480,2))
plot(Me(:,1),Me(:,2),'b')
hold on
plot(LA(:,1),c.*LA(:,2),'r')
axis padded
title({'AMS-01-5-11' 'DA-2' ['c = ' num2str(c) '   MSR = ' num2str(MSR)]})
legend('Methacrylate','Structural','Location','Southeast')
xlabel('Time (s)')
ylabel('Conversion')

%%
figure
load('AMC-04-11-1_LA_0s_fitparameters');
LA = [fitparams.time fitparams.conversion fitparams.fitting];
load('AMC-04-11-1_0s_fitparameters');
Me = [fitparams.time fitparams.conversion fitparams.fitting];

% subplot(2,2,1)
% plot(LA(:,1),LA(:,2),'r')
% hold on
% plot(Me(:,1),Me(:,2),'b')
% 
% axis padded
% subplot(2,2,2)
% plot(LA(:,1),Me(:,2)./LA(:,2),'k--')
% axis padded
% 
% subplot(2,2,3)
% plot(LA(:,1),LA(:,3),'r')
% hold on
% plot(Me(:,1),Me(:,3),'b')
% axis padded
% subplot(2,2,4)
% plot(LA(:,1),Me(:,3)./LA(:,3),'k--')
% axis padded
% mean(Me(:,3)./LA(:,3))
% std(Me(:,3)./LA(:,3))
% figure

c = mean(Me(35:3471,2)./LA(35:3471,2))
MSR = mean((Me(:,2)-c.*LA(:,2)).^2)
std(Me(35:3471,2)./LA(35:3471,2))
plot(Me(:,1),Me(:,2),'b')
hold on
plot(LA(:,1),c.*LA(:,2),'r')
axis padded
title({'AMC-04-11-1' 'PM-BisGMA-Epon828' ['c = ' num2str(c) '   MSR = ' num2str(MSR)]})
legend('Methacrylate','Structural','Location','Southeast')
xlabel('Time (s)')
ylabel('Conversion')

%%
figure
load('AMC-04-11-2_LA_0s_fitparameters');
LA = [fitparams.time fitparams.conversion fitparams.fitting];
load('AMC-04-11-2_0s_fitparameters');
Me = [fitparams.time fitparams.conversion fitparams.fitting];

% subplot(2,2,1)
% plot(LA(:,1),LA(:,2),'r')
% hold on
% plot(Me(:,1),Me(:,2),'b')
% 
% axis padded
% subplot(2,2,2)
% plot(LA(:,1),Me(:,2)./LA(:,2),'k--')
% axis padded
figure
plot(LA(:,1),Me(:,2)./LA(:,2),'k--')
xlabel('Time (s)')
ylabel('Proportionality')
title({'AMS-01-6-2' 'PM-BisGMA-Epon828'})
axis([0 3500 1.5 3])
% subplot(2,2,3)
% plot(LA(:,1),LA(:,3),'r')
% hold on
% plot(Me(:,1),Me(:,3),'b')
% axis padded
% subplot(2,2,4)
% plot(LA(:,1),Me(:,3)./LA(:,3),'k--')
% axis padded
% mean(Me(:,3)./LA(:,3))
% std(Me(:,3)./LA(:,3))
% figure
figure
c = mean(Me(35:8026,2)./LA(35:8026,2))
MSR = mean((Me(:,2)-c.*LA(:,2)).^2)
std(Me(35:8026,2)./LA(35:8026,2))
plot(Me(:,1),Me(:,2),'b')
hold on
plot(LA(:,1),c.*LA(:,2),'r')
axis padded
title({'AMC-04-11-2' 'PM-BisGMA-Epon828' ['c = ' num2str(c) '   MSR = ' num2str(MSR)]})
legend('Methacrylate','Structural','Location','Southeast')
xlabel('Time (s)')
ylabel('Conversion')