function w = omega_Calc(obj)
%{
    Function Name:              omega_Calc.m
    Date of origination:        9/13/2023
    Programmer:                 Robert V. Chimenti
                                Seamus Fullerton
    Organizations:              Rowan University,
                                Advanced Materials and Manufacturing 
                                Institute (AMMI)
    
    Description:
        Function that handles the calculation of the omega values for both
        chemical and structural.

    Revisions:

    Rev "-": Initial release of the code updated the original code done by Rob.            Seamus Fullerton 
%}

    %Check the active Resin type.
    activeResin = obj.activeTestname;
    %Cycle through the excel and grab all the data with that name.
    matches = obj.excelData(obj.excelData.Resin == activeResin,:);

    %See if processed Data is present
    runNames = matches.Experiment;
    intensities = matches.("Light Intensity Before (mW/cm2)");
    sz = size(runNames,1);
    itter = 1; %Itterator for indexing
    basePath = regexp(obj.savefilePath,filesep,"split");
    basePath = strjoin(basePath(1:end-1),filesep);

    dataLength = 0; %For tracking shortest data run.

    for i = 1:sz
        activeRun = runNames{i};
        filePath = fullfile(basePath,activeRun,'Variables');
        %Check to see if fitparams exist
        fitPath = fullfile(filePath,"*fit*.mat");
        fitVars = dir(fitPath);
        %If size == 2 then all files are present load them into a variable.
        if size(fitVars,1) == 2
            %Log available run names.
            names{itter,1} = activeRun;
            %Log intensity so we can relate by index without going into
            %cells.
            idxItens(itter,1) = intensities(i);
            %Get variables.
            chemPath = fullfile(fitVars(1).folder,fitVars(1).name);
            strucPath = fullfile(fitVars(2).folder,fitVars(2).name);

            %Load Chem data
            load(chemPath,'result');
            result.Intensity = intensities(i);
            dataChem{itter,1} = result;

            %Load Structrual data
            load(strucPath,'result');
            result.Intensity = intensities(i);
            dataStruc{itter,1} = result;

            %Check for shortest data set for trimming.
            currSz = size(result.conversion,2);
            if dataLength == 0 || dataLength > currSz
                dataLength = currSz;
            end
            itter = itter + 1;
        end
    end

    %After the loop ends need to trim all the data so they are identical
    %size.
    for i = 1:size(names,1)
        activeChem = dataChem{i};
        activeStruc = dataStruc{i};
        %Resize time and conversion
        activeChem.time = activeChem.time(1:dataLength);
        activeChem.conversion = activeChem.conversion(1:dataLength);

        activeStruc.time = activeStruc.time(1:dataLength);
        activeStruc.conversion = activeStruc.conversion(1:dataLength);

        %Store them back into the data strucs
        dataChem{i} = activeChem;
        dataStruc{i} = activeStruc;
    end

    %Take the average of matching intensity runs
    uniqIntens = unique(intensities);
    itter = 1;
    for i = 1:size(uniqIntens,1)
        %Find any matches
        idx = find(idxItens == uniqIntens(i));

        if isempty(idx) ~= 1
            for k = 1:size(idx,1)
                aIdx = idx(k);
                %Get struct data
                activeChem = dataChem{aIdx};
                activeStruc = dataStruc{aIdx};

                %Temp Variables
                tempAChem(k,:) = activeChem.conversion;
                tempTChem(k,:) = activeChem.time;

                tempAStruc(k,:) = activeStruc.conversion;
                tempTStruc(k,:) = activeStruc.time;
            end

            %Avearge the temp variables and store them in preminent
            %variable.
            alphaChem(itter,:) = mean(tempAChem);
            timeChem(itter,:) = mean(tempTChem);

            alphaStruc(itter,:) = mean(tempAStruc);
            timeStruc(itter,:) = mean(tempTStruc);

            IntensityMap(itter,1) = uniqIntens(i);

            itter = itter + 1;
        end
    end

    %Find inflection point and trim
    %Chemical
    [trimmedTimeChem, trimmedAlphaChem] = FindInflectionPoint(timeChem, alphaChem, 0.005,3);
    %Structual
    [trimmedTimeStruc, trimmedAlphaStruc] = FindInflectionPoint(timeStruc, alphaStruc, 0.005,3);

    %Find fit
    %Chemical
    [rateChem,rateFitChem,AfChem] = findRateFit(trimmedAlphaChem, trimmedTimeChem, 0.99999); %0.99999
    %Structual
    [rateStruc,rateFitStruc,AfStruc] = findRateFit(trimmedAlphaStruc, trimmedTimeStruc, 0.9999999);

    %Plot Chemical
    chemAx = plotRates(rateChem, rateFitChem, trimmedAlphaChem, AfChem, IntensityMap);
    title(chemAx,'DA-2 Chemical','FontSize',18) %Fix later to be any name

    %Plot Structual
    strucAx = plotRates(rateStruc, rateFitStruc, trimmedAlphaStruc, AfStruc, IntensityMap);
    title(strucAx,'DA-2 Structual','FontSize',18) %Fix later to be any name

    %Find Omega Chemical
    [wChem,wAxChem] = plotOmega(IntensityMap, rateFitChem, trimmedAlphaChem, AfChem);
    title(wAxChem,'DA-2 Chemical','FontSize',18) %Fix later to be any name
    %Find Omega Structual
    [wStruc,wAxStruc] = plotOmega(IntensityMap, rateFitStruc, trimmedAlphaStruc, AfStruc);
    title(wAxStruc,'DA-2 Structual','FontSize',18) %Fix later to be any name
end


function [trimmedTime,trimmedAlpha] = FindInflectionPoint(time, alpha, spec,order)
%Function that handles the finding of the inflection point and trims the
%data.
%% Debug Code
fig = figure;
plot(time',alpha');
hold on 
yline(0,'k--')
axis([0 50 -.1 .5])
ylabel('\alpha')
xlabel('time')

%% Calc the derivative for the first 50 points
colors = {'r','g','k','b','m'};
for i = 1:4
    timeSubSet = time(i,1:50);
    alphaSubSet = alpha(i,1:50);
    pFit{i} = polyfit(timeSubSet,alphaSubSet,order);
    pVal{i} = polyval(pFit{i},timeSubSet);
    pDiff{i} = polyder(pFit{i});
    
    pDiffVal{i} = polyval(pDiff{i},timeSubSet);
    
    % Debug Plots
    set(0,"CurrentFigure",fig);
    hold on
    plot(timeSubSet,pVal{i},colors{i},'LineWidth',5);


    temp = pDiffVal{i};
    itter = 1;
    while temp(itter) < spec
        itter = itter + 1;
    end

    xline(timeSubSet(itter),'Color',colors{i});
    hold off
    tempAlpha{i} = alpha(i,itter:end);
end
trimSz = 500000000;        
%Big just to initialize
for a = 1:size(tempAlpha,2)
    t = tempAlpha{a};
    if size(t,2) < trimSz
        trimSz = size(t,2);
    end
end

for a = 1:size(tempAlpha,2)
    d = tempAlpha{a};
    trimmedAlpha(a,:) = d(1,1:trimSz);
    trimmedTime(a,:) = time(a,1:trimSz);
end


% Debug Plots
Trim = figure;
plot(trimmedTime',trimmedAlpha');
hold on 
yline(0,'k--')
axis([0 50 -.1 .5])
ylabel('\alpha')
xlabel('time')
title('Trimmed Zoomed in')

TrimFull = figure;
plot(trimmedTime',trimmedAlpha');
hold on 
yline(0,'k--')
axis([0 trimSz -.1 .75])
ylabel('\alpha')
xlabel('time')
title('Trimmed Zoomed in')
end

function [Rate,RateFit,Af] = findRateFit(trimmedAlpha, trimmedTime, g)
sz = size(trimmedAlpha,1);
Af = 0:.001:max(max(trimmedAlpha));
syms f(x)

for i = 1:sz
    T = trimmedTime(i,:);
    A = trimmedAlpha(i,:);
    %Calculate Fit
    fitF =  kineticsrational(T, A);
    %Deals with the x^4 having no coeff
    qMatrix(1,1) = 1;
    for k = 1:9
        %Stores each coeff into a matrix
        if k < 6
            str = sprintf("p%d",k);
            pMatrix(1,k) = fitF.(str);
        else
            str = sprintf("q%d",k-5);
            qMatrix(1,k-4) = fitF.(str); 
        end
    end
    %Convert poly into symbolic
    %Just an fyi
    %[2,3,0,1] = 2x^3+3x^2+1
    p = poly2sym(pMatrix);
    q = poly2sym(qMatrix);

    clear('qMatrix','pMatrix');
    
    %Get function
    f(x) = p/q;
    
    %Diff function
    R_ = diff(f,x);
    Rate{i} = double(subs(R_,x,T));
    R_f = fit(A',Rate{i}','smoothingspline','SmoothingParam',g,'Exclude', Rate{i} <= 0);
    RateFit{i} =  ppval(R_f.p,Af);
end
end

function ax = plotRates(rate, rateFit, trimmedAlpha, Af, IntensityMap)
%Create plots
f = figure;
ax = axes(f);
hold(ax,"on");
sz = size(rate,2);

%Plot colors for consistant colors
colors = {'r','b','g','k','m','c','y'};
for i = 1:sz
    activeRate = rate{i};
    activeFit = rateFit{i};
    %Format string for plot style
    plotStyle = sprintf("%s.",colors{i});
    plot(ax,trimmedAlpha(i,:),activeRate,plotStyle);
    
    %Format string for plot style
    plotStyle = sprintf("%s--",colors{i});
    plot(ax,Af,activeFit,plotStyle);
end
xlabel(ax,'\alpha')
ylabel(ax,'R')
axis(ax,[0 1.1.*max(max(trimmedAlpha)) 0 1.01.*max(activeRate)])
legend(ax);
end

function [w,ax] = plotOmega(IntensityMap, rateFit, trimmedAlpha, Af)
Ilog = log(IntensityMap)';
rateArray = cell2mat(rateFit'); 
for i = 1:length(Af)
    R = log(rateArray(:,i))';
    if imag(R) == 0
        p(i,:) = polyfit(Ilog,R,1);
    else 
        p(i,:) = [0 0];
    end
end
%Omega
w = p(:,1);
%Omega Mean
wm = mean(w);
%Omega STD
wstd = std(w);

c = polyfit(Af,w,1);
b = polyval(c,Af);
f = figure;
ax = axes(f);
plot(ax,Af,w);
hold(ax,"on");
plot(ax,Af,b,'k--')
xlabel(ax,'\alpha')
ylabel(ax,'\omega')
axis(ax,[0 1.1.*max(max(trimmedAlpha)) 0 1])
text(.1,0.1,['mean \omega = ' num2str(wm) char(177) num2str(wstd)],'FontSize',16)
end