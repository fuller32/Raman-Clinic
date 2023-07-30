classdef mainGUI < handle
%{
    Function Name:              mainGUI.m
    Date of origination:        7/3/2023
    Programmer:                 Seamus Fullerton
    Organizations:              Rowan University,
                                Advanced Materials and Manufacturing 
                                Institute (AMMI)
    
    Description:
        GUI that will handle the calling of all the necessary functions to
        fully process test data. Also will read in the excel file we
        maintain of test data and appropriately update it.

        GUI will make use of uigrids to handle layout. Run the following
        from the command window to read more doc uigridlayout. Allows for 
        much easier maitance of UI's through code.

        Also will allow features like batch processing based of desired
        user settings with minimum input.

    Revisions:

    Rev "-": Initial release of the code            Seamus Fullerton 
%}
    properties
        versionCtrl
        fntOrder
        excelName = "Copy of Kinetics Experiments.xlsx";
        fontSz
        figure
        UIGrids
        UIelements
        excelData
        avaliableData
        activeTest
        activeTestInfo
        activeTestname
        activeTestOrder
        progUI
        savefilePath
        interupt = 0;
        savePlotFigs = 1;
        plotFileSizeLimit = 500; %Size in MBs
        useTrim = 1;
        hidePlots;
        PlotList
        screenHeight
        screenWidth
    end
    
    methods
        function obj = mainGUI
            %Check what commit number we are working under. This assumes
            %modifications to the code haven't been made since last commit,
            %can be made more robust but good enough for now.
            disp("Getting GIT Version");
            [~,obj.versionCtrl] = system('git rev-parse HEAD');

            %Read in function Execution Order
            obj.fntOrder = executionOrder;

            %Call the method to generate the form
            disp("Creating UI Form");
            createForm(obj);

            %Create layoutGrids.
            disp("Creating UI Grids");
            createGrids(obj);

            %Create UI elements
            disp("Creating UI Elements")
            createUI(obj);
        end
        
        function createForm(obj)
            %Handles creation of the form based of the screen size of the
            %monitor.
            
            %Get screensize
            screenInfo = get(groot,'ScreenSize');
            obj.screenHeight = screenInfo(4);
            obj.screenWidth = screenInfo(3);
            height = screenInfo(4);
            width = screenInfo(3);

            %Set fontsizes based off screensize
            obj.fontSz = fontSizes(height,width);

            %Create form
            obj.figure = uifigure("Name","Ramen Clinic","Position",...
                [0,0,.75*width,.75*height],"CloseRequestFcn",...
                @(h,e)delete(obj));
            %Center form
            movegui(obj.figure,"center");
        end

        function createGrids(obj)
            %Handles creation of the UI Grids from which all UI elements
            %will be placed.

            %Main Grid that splits the screen in third.
            grids.mainGrid = uigridlayout(obj.figure,[3,1]);
            grids.mainGrid.RowHeight = {'.2x','1x','.6x'};
            
            %Top Grid
            grids.topGrid = uigridlayout(grids.mainGrid,[1,3]);
            grids.topGrid.Layout.Row = 1;
            grids.topGrid.ColumnWidth = {'.1x','1x','.1x'};

            %Middle Grid
            grids.midGrid = uigridlayout(grids.mainGrid,[1,3]);
            grids.midGrid.Layout.Row = 2;
            grids.midGrid.ColumnWidth = {'.5x','1x','.25x'};
                %Grid that will hold the plots
                grids.midPlot = uigridlayout(grids.midGrid,[2,1]);
                grids.midPlot.Layout.Column = 2;
                grids.midPlot.Layout.Row = 1;
                grids.midPlot.RowHeight = {'1x','.15x'};

                %Grid that will hold test selection
                    %Size will change depending on test selected
                grids.midL = uigridlayout(grids.midGrid,[1,3]);
                grids.midL.RowHeight = {'fit'};
                grids.midL.Layout.Column = 1;
                grids.midL.Layout.Row = 1;

                %Grid that will hold the plots
                grids.midR = uigridlayout(grids.midGrid,[4,1]);
                grids.midR.Layout.Column = 3;
                grids.midR.Layout.Row = 1;

            %Bottom Grid
            grids.bottomGrid = uigridlayout(grids.mainGrid,[3,2]);
            grids.bottomGrid.Layout.Row = 3;
            grids.bottomGrid.ColumnWidth = {'1x','1x'};
            grids.bottomGrid.RowHeight = {'.15x','1x','.15x'};
            obj.UIGrids = grids;
        end

        function createUI(obj)
            %Handles creation of the UI elements and will store all
            %elements to be accessed in UIelements property. Which will be
            %a struct so if you wanted to access a specific element you
            %would call.Example

            %obj.UIelements.buttons.settingsBtn

            %Load grids as local variables to make calls shorter.
            tgrid = obj.UIGrids.topGrid;
            mLgrid = obj.UIGrids.midL;
            mPlotgrid = obj.UIGrids.midPlot;
            mRgrid = obj.UIGrids.midR;
            bgrid = obj.UIGrids.bottomGrid;

            %Top Grid
                %Logo top left
                misc.logo = uiimage(tgrid,"ImageSource","RowanLogo.png");
                misc.logo.Layout.Column = 1;

                %Title label
                labels.titleLbl =uilabel(tgrid,"Text","Ramen Clinic",...
                    "FontSize",obj.fontSz.titleFontSize,"FontWeight",'bold',...
                    'HorizontalAlignment',"center");
                labels.titleLbl.Layout.Column = 2;

                %Git version
                gitTxt = ["GIT Rev",obj.versionCtrl];
                labels.gitLbl =uilabel(tgrid,"Text",gitTxt,...
                    "FontSize",obj.fontSz.labelFontSize,...
                    'HorizontalAlignment',"center","FontWeight",'bold');
                labels.gitLbl.Layout.Column = 3;

            %Bottom Grid
                %Read in excel data
                sheets = sheetnames(obj.excelName);
                %Assume sheet 3 for now
                obj.excelData = readtable(obj.excelName,"Sheet",sheets(3),"VariableNamingRule","preserve");
                %Drop down of all tabs in excel
                misc.excelDrpDwn = uidropdown(bgrid,"Items",sheets,...
                    "Value",sheets(3),"FontSize",obj.fontSz.subheadingFontSize,...
                    "ValueChangedFcn",@(h,e)updateTable(obj,e));
                misc.excelDrpDwn.Layout.Row = 3;
                misc.excelDrpDwn.Layout.Column = 1;
                %Table to hold excel data
                misc.excelTable = uitable(bgrid,"Data",obj.excelData);
                misc.excelTable.Layout.Row = 2;
                misc.excelTable.Layout.Column = [1 2];

                %Get a dropdown of all the subfolders in Data
                folders = dir("Data\");
                subFolders = folders([folders(:).isdir]);
                subFolders = subFolders(~ismember({subFolders(:).name},{'.','..'}));
                subFolders = {subFolders.name};
                obj.avaliableData = subFolders;
                misc.dataDrpDwn = uidropdown(bgrid,"Items",subFolders,...
                    "FontSize",obj.fontSz.subheadingFontSize,"ValueChangedFcn",...
                    @(h,e)selectedTest(obj));
                misc.dataDrpDwn.Layout.Row = 3;
                misc.dataDrpDwn.Layout.Column = 2;
                obj.activeTest = misc.dataDrpDwn.Value;

                %Create buttons
                buttons.runBtn = uibutton(bgrid,"Text","Run Selected Functions",...
                    "FontSize",obj.fontSz.subheadingFontSize,"ButtonPushedFcn",...
                    @(h,e)runFunctions(obj));
                buttons.runBtn.Layout.Row = 1;
                buttons.runBtn.Layout.Column = 1;

                buttons.settingsBtn = uibutton(bgrid,"Text","Settings",...
                    "FontSize",obj.fontSz.subheadingFontSize,"ButtonPushedFcn",...
                    @(h,e)settingsButton(obj));
                buttons.settingsBtn.Layout.Row = 1;
                buttons.settingsBtn.Layout.Column = 2;
            

            %Middle Grid
            %Left side
                labels.checkLbl = uilabel(mLgrid,"Text","Enable Function",...
                    "FontSize",obj.fontSz.subheadingFontSize,"FontWeight","bold",...
                    "HorizontalAlignment","left");
                labels.checkLbl.Layout.Row = 1;
                labels.checkLbl.Layout.Column = 1;

                labels.fnNameLbl = uilabel(mLgrid,"Text","Function Name",...
                    "FontSize",obj.fontSz.subheadingFontSize,"FontWeight","bold",...
                    "HorizontalAlignment","center");
                labels.fnNameLbl.Layout.Row = 1;
                labels.fnNameLbl.Layout.Column = 2;

                labels.statusLbl = uilabel(mLgrid,"Text","Function Status",...
                    "FontSize",obj.fontSz.subheadingFontSize,"FontWeight","bold",...
                    "HorizontalAlignment","center");
                labels.statusLbl.Layout.Row = 1;
                labels.statusLbl.Layout.Column = 3;

            %Plot
                axes.plotAxes = uiaxes(mPlotgrid);
                axes.plotAxes.Layout.Row = 1;
                axes.plotAxes.Layout.Column = 1;

                misc.axesDrpDown = uidropdown(mPlotgrid,"FontSize",...
                    obj.fontSz.subheadingFontSize,"ValueChangedFcn",...
                    @(h,e)plotData(obj));
                misc.axesDrpDown.Layout.Row = 2;
                misc.axesDrpDown.Layout.Column = 1;

            %Right Side
                buttons.MultiSelect = uibutton(mRgrid,"Text","Multi-Select",...
                    "FontSize",obj.fontSz.subheadingFontSize,"ButtonPushedFcn",...
                    @(h,e)multSelectWindow(obj));
                buttons.MultiSelect.Layout.Row = 1;
                buttons.MultiSelect.Layout.Column = 1;

                buttons.TrimdataBtn = uibutton(mRgrid,"Text","Trim Data",...
                    "FontSize",obj.fontSz.subheadingFontSize,"ButtonPushedFcn",...
                    @(h,e)callTrimWindow(obj));
                buttons.TrimdataBtn.Layout.Row = 2;
                buttons.TrimdataBtn.Layout.Column = 1;


            %Collect UI elements
            elements.misc = misc;
            elements.labels = labels;
            elements.buttons = buttons;
            elements.axes = axes;

            %Write UI elements to class property
            obj.UIelements = elements;

            selectedTest(obj);

        end

        function updateTable(obj,e)
            disp("Updating excel table")
            index = strmatch(obj.UIelements.misc.excelDrpDwn.Value,...
                obj.UIelements.misc.excelDrpDwn.Items);
            sheets = sheetnames(obj.excelName);
            obj.excelData = readtable(obj.excelName,"Sheet",sheets(index),"VariableNamingRule","preserve");
            obj.UIelements.misc.excelTable.Data = obj.excelData;
            cla(obj.UIelements.axes.plotAxes,"reset");
        end

        function selectedTest(obj)
            cla(obj.UIelements.axes.plotAxes,"reset");
            obj.activeTest = obj.UIelements.misc.dataDrpDwn.Value;
            str = strjoin(["Updating selected test to",obj.activeTest]);
            disp(str);
            [validFlag,idx] = max(strcmp(obj.excelData.Experiment(:),obj.activeTest));
            if validFlag == 0
                disp("Data isn't in excel alerting user")
                uialert(obj.figure,"Data isn't present in Excel, add data to excel and try again","Missing Data");
                return
            end
            obj.activeTestInfo = obj.excelData(idx,:);
            obj.activeTestname = strrep(obj.activeTestInfo.Resin{1}," ","");
            obj.activeTestOrder = obj.fntOrder.(obj.activeTestname);
            obj.savefilePath = fullfile(cd,"Results",obj.activeTest);

            %Loop to create the updating test selection
            for i=1:size(obj.activeTestOrder.order,2)
                UI.ckbox(i) = uicheckbox(obj.UIGrids.midL,"Value",1,"Text",...
                    "");
                UI.ckbox(i).Layout.Row = i+1;
                UI.ckbox(i).Layout.Column = 1;

                UI.lbl(i) = uilabel(obj.UIGrids.midL,"Text",...
                    obj.activeTestOrder.order(i),"FontSize",...
                    obj.fontSz.bodyFontSize,...
                    "HorizontalAlignment","center");
                UI.lbl(i).Layout.Row = i+1;
                UI.lbl(i).Layout.Column = 2;

                UI.status(i) = uilabel(obj.UIGrids.midL,"Text",...
                    "N/A","FontSize",...
                    obj.fontSz.bodyFontSize,"FontWeight","bold",...
                    "HorizontalAlignment","center");
                UI.status(i).Layout.Row = i+1;
                UI.status(i).Layout.Column = 3;
            end

            %Add UI elements to the property.
            obj.progUI = UI;

            %Check if plots are present
            path = fullfile(obj.savefilePath,'Variables','Kinetics_PlotData.mat');
            pathLA = fullfile(obj.savefilePath,'Variables','LA_Kinetics_PlotData.mat');
            if exist(path,"file") > 0 && exist(pathLA,"file") > 0
                obj.PlotList = {'Kinetics Fit','LA Kinetics Fit'};
                obj.UIelements.misc.axesDrpDown.Items = obj.PlotList;
                plotData(obj);
            elseif exist(path,"file") > 0
                obj.PlotList = {'Kinetics Fit'};
                obj.UIelements.misc.axesDrpDown.Items = obj.PlotList;
                plotData(obj);
            elseif exist(pathLA,"file") > 0
                obj.PlotList = {'LA Kinetics Fit'};
                obj.UIelements.misc.axesDrpDown.Items = obj.PlotList;
                plotData(obj);
            else
                obj.PlotList = "";
            end
        end

        function runFunctions(obj)
            disp("Setting up folders");
            obj.savefilePath = fullfile(cd,"Results",obj.activeTest);
            if exist(obj.savefilePath,"dir")<1
                mkdir(obj.savefilePath);
                mkdir(fullfile(obj.savefilePath,"Plots"));
                mkdir(fullfile(obj.savefilePath,"Plots","Figures"));
                mkdir(fullfile(obj.savefilePath,"Variables"));
                mkdir(fullfile(obj.savefilePath,"Reports"));
            end
            disp("Checking selected functions");
            numTests = size(obj.progUI.ckbox,2);
            idx = zeros(numTests,1);
            for i = 1:numTests
                idx(i) = obj.progUI.ckbox(i).Value;
            end

            disp("Starting test cycle")
            numOfselTests = sum(idx);
            tests = 0;
            response = "Yes";
            for i = 1:numTests
                if idx(i) == 1
                    tests = tests+1;
                    str = strjoin(["Running",obj.activeTestOrder.order(i)]);
                    disp(str);
                    feval(obj.activeTestOrder.order(i),obj);
                    str = strjoin(["Completed",obj.activeTestOrder.order(i)]);
                    disp(str)
                    if obj.interupt == 1 && tests~=numOfselTests
                        response = questdlg('Continue with next function?',...
                            'Interupt test','Yes','No','Yes');
                        switch response
                            case "Yes"
                            case "No"
                                break
                        end
                    end
                end
            end

            if strcmp(response,"No")==1 && obj.interupt == 1
                disp("Test cycle was interupted by user")
            else
                disp("Completed test cycle")
            end
            %Write Git version out
            str = strjoin(["Writing GIT version to",fullfile(obj.savefilePath,"Reports")]);
            disp(str);
            fileID = fopen(fullfile(obj.savefilePath,"Reports","GIT_Version.txt"),"w");
            fprintf(fileID,"%s",obj.versionCtrl);
            fclose(fileID);

            str = strjoin(["Writing diary log out to",fullfile(obj.savefilePath,"Reports")]);
            disp(str)
            copyfile("diaryLog",fullfile(obj.savefilePath,"Reports"))
            if obj.hidePlots == 0
                selectedTest(obj);
            end
        end

        function settingsButton(obj)
            disp("Settings button selected");
            avalTests = [{'General'},obj.activeTestOrder.order];
            idx = listdlg("ListString",avalTests,"SelectionMode","single",...
                "Name","Settings Selection");
            selection = avalTests{idx};
            if strcmp(selection,'General') == 1
                disp("Opening general settings");
                prompt = {'Interupt Between Functions:','Enable Saving of Plot Figures(Will increase file sizes and runtime)',...
                    'Maximum Figure Plot Size (Size in MB)','Use trimmed data if present'};
                settings = {int2str(obj.interupt),int2str(obj.savePlotFigs),...
                    int2str(obj.plotFileSizeLimit),int2str(obj.useTrim)};
                box = inputdlg(prompt,"Settings",[1,35],settings);
                obj.interupt = str2double(box{1});
                obj.savePlotFigs = str2double(box{2});
                obj.plotFileSizeLimit = str2double(box{3});
                obj.useTrim = str2double(box{3});
            else
                try
                    str = strjoin(["Opening",selection,"settings"]);
                    disp(str);
                    act = obj.activeTestOrder.(selection);
                    prompt = act.prompt;
                    settings = act.settings;
                    box = inputdlg(prompt,"Settings",[1,35],settings);
                    obj.fntOrder.(obj.activeTestname).(selection).settings = box;
                catch
                    str = strjoin(["No setting options for",selection]);
                    disp(str)
                    return
                end
            end
        end

        function multSelectWindow(obj)
            disp("Mult-select button selected")
            prompt = obj.avaliableData;
            list = listdlg("ListString",prompt,"SelectionMode","multiple");
            sz = size(list,2);
            if sz > 0
                obj.hidePlots = 1;
                for i = 1:sz
                    obj.activeTest = obj.avaliableData{list(i)};
                    [validFlag,idx] = max(strcmp(obj.excelData.Experiment(:),obj.activeTest));
                    if validFlag == 0
                        disp("Data isn't in excel alerting user")
                        uialert(obj.figure,"Data isn't present in Excel, add data to excel and try again","Missing Data");
                        return
                    end
                    obj.activeTestInfo = obj.excelData(idx,:);
                    obj.activeTestname = strrep(obj.activeTestInfo.Resin{1}," ","");
                    obj.activeTestOrder = obj.fntOrder.(obj.activeTestname);
                    obj.savefilePath = fullfile(cd,"Results",obj.activeTest);

                    str = strjoin(["Mult-select running",obj.activeTest]);
                    disp(str);
                    obj.runFunctions;
                end
                obj.hidePlots = 0;
            else
                disp("No selection made")
            end
        end

        function plotData(obj)
            cla(obj.UIelements.axes.plotAxes,"reset");
            selection = obj.UIelements.misc.axesDrpDown.Value;
            switch selection
                case 'Kinetics Fit'
                    fitpath = fullfile(obj.savefilePath,'Variables',"Epoxy_*settings.mat");
                    fitpath = dir(fitpath);
                    fitpath = fullfile(fitpath(1).folder,fitpath(1).name);
                    load(fitpath,'fitparams','gof');
                    plotPath = fullfile(obj.savefilePath,'Variables','Kinetics_PlotData.mat');
                    load(plotPath,'plotData');
                    ax = obj.UIelements.axes.plotAxes;
                    %For some reason you can't direct plot cfit data on a
                    %UIplot (no good reason for this). Work around below
                    f = figure("Visible","off");
                    tempPlot = plot(fitparams,plotData.x,plotData.y);
                    copyobj(tempPlot,ax);
                    axis(ax,"padded");
                    xlabel(ax,'Time (s)');
                    ylabel(ax,'Conversion');
                    title(ax,{obj.activeTest, 'Extent of Cure Kinetics'},'interpreter','none');
                    sse = gof.sse;
                    a = fitparams.au;
                    k = fitparams.k;
                    n = fitparams.n;
                    s = {['\alpha_u = ' num2str(a)]...
                        ['k = ' num2str(k)] ...
                        ['n = ' num2str(n)]...
                        ['SSE = ' num2str(sse)]};
                    text(ax,max(plotData.x)*.7,.1,s)
                case 'LA Kinetics Fit'
                    fitpath = fullfile(obj.savefilePath,'Variables',"Epoxy_*LA*settings.mat");
                    fitpath = dir(fitpath);
                    fitpath = fullfile(fitpath(1).folder,fitpath(1).name);
                    load(fitpath,'fitparams','gof');
                    plotPath = fullfile(obj.savefilePath,'Variables','LA_Kinetics_PlotData.mat');
                    load(plotPath,'plotData');
                    ax = obj.UIelements.axes.plotAxes;
                    %For some reason you can't direct plot cfit data on a
                    %UIplot (no good reason for this). Work around below
                    f = figure("Visible","off");
                    tempPlot = plot(fitparams,plotData.x,plotData.y);
                    copyobj(tempPlot,ax);
                    axis(ax,"padded");
                    xlabel(ax,'Time (s)');
                    ylabel(ax,'Conversion');
                    title(ax,{obj.activeTest, 'Extent of Cure Kinetics'},'interpreter','none');
                    sse = gof.sse;
                    a = fitparams.au;
                    k = fitparams.k;
                    n = fitparams.n;
                    s = {['\alpha_u = ' num2str(a)]...
                        ['k = ' num2str(k)] ...
                        ['n = ' num2str(n)]...
                        ['SSE = ' num2str(sse)]};
                    text(ax,max(plotData.x)*.7,.1,s)
            end
        end

        function callTrimWindow(obj)
            disp("Calling Trim Window");
            dataTrimWindow(obj);
        end

        function delete(obj)
            %Handle class destruction when UI closed.
            disp("Calling mainGUI class destructor")
            delete(obj.figure)
            diary off
        end
    end
end

