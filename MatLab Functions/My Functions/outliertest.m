clc; clear all; close all;
load('5min_ana2.mat')
[n m] = size(Db);
RS = Db(:,1);
I = Db(:,2:m);
% [f I] = airPLS(I,400);
dt = 60.26667/(m-1);
t =1:m-1;
T = t*dt;
Istd = std(I')';
Iv = Istd.^2;
Im =mean(I')';
plot(RS,I)
for i=1:(m-1);
    for ii = 1:(n-1);
        if abs(Im(ii)-I(ii,i)) >= 3*Istd(ii); 
            if i-1==0;
            I(ii,i) = I(ii,i+1);
            elseif i+1==0;
            I(ii,i) = I(ii,i-1);
            else
            I(ii,i) = (I(ii,i-1)+I(ii,i+1))/2;    
            end    
    end
    end
end
figure 
plot(RS,I)