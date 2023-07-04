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
        activeTest
        activeTestInfo
        activeTestname
        activeTestOrder
        progUI
        filePath
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
            grids.midGrid = uigridlayout(grids.mainGrid,[1,2]);
            grids.midGrid.Layout.Row = 2;
            grids.midGrid.ColumnWidth = {'.5x','1x'};
                %Grid that will hold the plots
                grids.midR = uigridlayout(grids.midGrid,[2,1]);
                grids.midR.Layout.Column = 2;
                grids.midR.Layout.Row = 1;
                grids.midR.RowHeight = {'1x','.15x'};

                %Grid that will hold test selection
                    %Size will change depending on test selected
                grids.midL = uigridlayout(grids.midGrid,[1,3]);
                grids.midL.RowHeight = {'fit'};
                grids.midL.Layout.Column = 1;
                grids.midL.Layout.Row = 1;

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
                    "ValueChangedFcn",@(h,e)updateTable(obj));
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
                    "FontSize",obj.fontSz.subheadingFontSize);
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

            %Right side
                axes.plotAxes = uiaxes(mRgrid);
                axes.plotAxes.Layout.Row = 1;
                axes.plotAxes.Layout.Column = 1;

                misc.axesDrpDown = uidropdown(mRgrid,"FontSize",...
                    obj.fontSz.subheadingFontSize);
                misc.axesDrpDown.Layout.Row = 2;
                misc.axesDrpDown.Layout.Column = 1;


            %Collect UI elements
            elements.misc = misc;
            elements.labels = labels;
            elements.buttons = buttons;
            elements.axes = axes;

            %Write UI elements to class property
            obj.UIelements = elements;

            selectedTest(obj);

        end

        function updateTable(obj)
            disp("Updating excel table")
            index = strmatch(obj.UIelements.misc.excelDrpDwn.Value,...
                obj.UIelements.misc.excelDrpDwn.Items);
            sheets = sheetnames(obj.excelName);
            obj.excelData = readtable(obj.excelName,"Sheet",sheets(index),"VariableNamingRule","preserve");
            obj.UIelements.misc.excelTable.Data = obj.excelData;
        end

        function selectedTest(obj)
            obj.activeTest = obj.UIelements.misc.dataDrpDwn.Value;
            str = strjoin(["Updating selected test to",obj.activeTest]);
            disp(str);
            [~,idx] = max(strcmp(obj.excelData.Experiment(:),"RK-01-91-1"));
            obj.activeTestInfo = obj.excelData(idx,:);
            obj.activeTestname = strrep(obj.activeTestInfo.Resin{1}," ","");
            obj.activeTestOrder = obj.fntOrder.(obj.activeTestname);

            %Loop to create the updating test selection
            for i=1:size(obj.activeTestOrder.order,2)
                UI.ckbox(i) = uicheckbox(obj.UIGrids.midL,"Value",1,"Text",...
                    "");
                UI.ckbox(i).Layout.Row = i+1;
                UI.ckbox(i).Layout.Column = 1;

                UI.lbl(i) = uilabel(obj.UIGrids.midL,"Text",...
                    obj.activeTestOrder.order(i),"FontSize",...
                    obj.fontSz.bodyFontSize,"FontWeight","bold",...
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
        end

        function runFunctions(obj)
            disp("Checking selected functions")
            
        end

        function delete(obj)
            %Handle class destruction when UI closed.
            disp("Calling mainGUI class destructor")
            delete(obj.figure)
            diary off
        end
    end
end

