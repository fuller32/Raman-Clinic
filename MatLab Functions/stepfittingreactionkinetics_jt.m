function [fitparams, sse] = stepfittingreactionkinetics(time,conversion,...
                        ultimateConversion,rateConstant,reactionOrder,p)
                    
%% explanation of terms
% fitparams - fitting result
% sse - smallest summation of square errors
%
% time - a column vector; time of experiment
% conversion - a column vector; experimental conversion values
%
% ultimateConversion - guessed approximate values for ultimate conversion
% rateConstant - guessed approximate values for rate constant
% reactionOrder - guessed approximate values for reaction order
% 
% I recommend to start with coarse values to obtain approximate ranges for 
% ultimate conversion, rate constant, and reaction order, then tune in to 
% get more accurate fittings.
%
% p: 0 or 1; 0 for no plotting, 1 for plotting

%%

fitparams = struct('time',[],'conversion',[],'fitting',[],...
                   'au',[],'k',[],'n',[],'gof',struct('sse',[],'meanSE',[]));

t = time;
a0 = conversion;

au = ultimateConversion;
k = rateConstant;
n = reactionOrder;

sse = zeros(length(au),length(k),length(n)); 

tic
for i1 = 1:length(au)
    for i2 = 1:length(k)
        for i3 = 1:length(n)
            switch n(i3)
                case 1
                    a1 = au(i1)-exp(log(au(i1))-k(i2)*t);
                    sse(i1,i2,i3) = (a1-a0)'*(a1-a0);
                otherwise
                    a1 = au(i1)-(au(i1)^(1-n(i3))-(1-n(i3))*k(i2)*t).^(1/(1-n(i3)));
                    sse(i1,i2,i3) = (a1-a0)'*(a1-a0);
            end
        end
    end
end
toc

[minsse,loc] = min(sse(:));
[i1,i2,i3] = ind2sub(size(sse),loc);
au = au(i1); k = k(i2); n = n(i3);

switch n
    case 1
        a1 = au-exp(log(au)-k*t);
    otherwise
        a1 = au-(au^(1-n)-(1-n)*k*t).^(1/(1-n));
end

if p
    afigure; hold on
    set(gcf,'Position',[200 150 600 600])
    scatter(t,a0,'sizedata',12,...
           'markerfacecolor','b',...
           'markeredgecolor','none');
    plot(t,a1,'r');
end
    

fitparams.time = t;
fitparams.conversion = a0;
fitparams.fitting = a1;

fitparams.au = au;
fitparams.k = k;
fitparams.n = n;

fitparams.gof.sse = minsse;
fitparams.gof.meanSE = minsse/length(a0)*100;