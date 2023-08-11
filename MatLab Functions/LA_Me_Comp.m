
function LA_Me_Comp(obj)
%{
    Function Name:              LA_Me_Comp.m
    Date of origination:        8/11/2023
    Programmer:                 Seamus Fullerton
    Organizations:              Rowan University,
                                Advanced Materials and Manufacturing 
                                Institute (AMMI)
    
    Description:
        Handles the calculation of the proportionality constants. Passes in
        the mainGUI and automatical handles 

    Revisions:

    Rev "-": Initial release of the code            Seamus Fullerton 
%}
    

    %% Load in variables
        disp("Reading in variables");
        progBar = uiprogressdlg(obj.figure,"Title","LA_Me_Comp",...
        "Indeterminate","on");

        %Get plot save path
        plotSavePath = fullfile(obj.savefilePath,"Plots");
        figureSavePath = fullfile(plotSavePath,"Figures");

        %Get path to variables
        varpath = fullfile(obj.savefilePath,'Variables');

        %Get epoxy type
        epType = obj.activeTestname;
        %Get run name
        runName = obj.activeTest;
    
        % Get LA
        LAName = sprintf("Epoxy_%s_LA_0s_fitparameterssettings.mat",runName);
        LAPath = fullfile(varpath,LAName);
        load(LAPath);
        LA = [result.time',result.conversion'];           %Drop fitparams since it isn't used in active code can add back
    
        % Get ME
        MEName = sprintf("Epoxy_%s_0s_fitparameterssettings.mat",runName);
        MEPath = fullfile(varpath,MEName);                 
        load(MEPath);
        ME = [result.time',result.conversion'];           %Drop fitparams since it isn't used in active code can add back

    %% Calculate Proportionality and Create Plot
        disp("Creating figures");
        %Create Figs
        if obj.hidePlots == 1
            propFig = figure('Visible','off');
            propFigTrimmed = figure('Visible','off');
            combinedFig = figure('Visible','off');
        else
            propFig = figure;
            propFigTrimmed = figure;
            combinedFig = figure;
        end

        %Create Proportionality Fig
        set(0,'currentfigure',propFig)
        plot(LA(:,1),ME(:,2)./LA(:,2),'k--')
        xlabel('Time (s)')
        ylabel('Proportionality')
        titleStr = strjoin([runName,epType]);
        title(titleStr);
        axis([0 size(LA,1) .5 15])
            %Save PNG
            imageData = getframe(propFig);
            imwrite(imageData.cdata,fullfile(plotSavePath,'prop_fig.png'));

        %Trim Data to remove noisy spikes
        Y = ME(:,2)./LA(:,2);
        trimData = filloutliers(Y,"linear","quartiles","ThresholdFactor",4);    %Linear interp outliers
        %trimData = rmoutliers(t,"quartiles","ThresholdFactor",4);              %Remove outliers 

        %Remove any NaN's present
        trimData(isnan(trimData)) = 0;

        %Create Trimmed Proportionality Fig
        set(0,'currentfigure',propFigTrimmed)
        plot(LA(:,1),trimData,'k--')
        xlabel('Time (s)')
        ylabel('Proportionality')
        titleStrTrim = strjoin([runName,epType,'Trimmed Data']);
        title(titleStrTrim);
        axis([0 size(LA,1) .5 2.5])
            %Save PNG
            imageData = getframe(propFigTrimmed);
            imwrite(imageData.cdata,fullfile(plotSavePath,'prop_fig_trimmed.png'));

        %Calculate Proportionality
        c = mean(trimData);
        MSR = mean((ME(:,2)-c.*LA(:,2)).^2);
        std(ME(:,2)./LA(:,2));

        %Create combined plot
        set(0,'currentfigure',combinedFig)
        plot(ME(:,1),ME(:,2),'c.');
        hold("on");
        plot(LA(:,1),c.*LA(:,2),'m.');
        axis("padded");
        titleStr = strjoin([titleStr,'c=',num2str(c),'MSR=',num2str(MSR)]);
        title(titleStr);
        legend('Epoxy','Structural','Location','Southeast');
        xlabel('Time (s)');
        ylabel('Conversion');
            %Save PNG
            imageData = getframe(combinedFig);
            imwrite(imageData.cdata,fullfile(plotSavePath,'combined_plot.png'));

        %Save off variables and figures
        comp = mexext;
        if 1 == strcmp(comp,'mexw64')
            path = fullfile(obj.savefilePath,"Variables",[runName,'_proportionality_consts']);
            save(path,"c","MSR","trimData",'-v7.3');
        else
            disp("Your machine is 32-bit and may have issues with saving matlab variables greater then 2GB")
            path = fullfile(obj.savefilePath,"Variables",[runName,'_proportionality_consts']);
            save(path,"c","MSR","trimData");
        end

        switch obj.savePlotFigs
            case 0
                disp("Setting not selected to save off plot figures")
            case 1
                disp("Saving Plot figures");

                disp("Saving untrimmed prop consts Plot");
                saveLoc = fullfile(figureSavePath,"prop_const.fig");
                str = strjoin(["Untrimmed prop const plot saved at",saveLoc]);
                savefig(propFig,saveLoc,"compact");
                disp(str);

                disp("Saving trimmed prop consts Plot");
                saveLoc = fullfile(figureSavePath,"prop_const_trim.fig");
                str = strjoin(["Trimmed prop const plot saved at",saveLoc]);
                savefig(propFigTrimmed,saveLoc,"compact");
                disp(str);

                disp("Saving combined Plot");
                saveLoc = fullfile(figureSavePath,"combined_plot.fig");
                str = strjoin(["Combined plot saved at",saveLoc]);
                savefig(combinedFig,saveLoc,"compact");
                disp(str);
        end

        delete(progBar);
end