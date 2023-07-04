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
        fontSz
        figure
        UIGrids
        UIelements
    end
    
    methods
        function obj = mainGUI
            %Check what commit number we are working under. This assumes
            %modifications to the code haven't been made since last commit,
            %can be made more robust but good enough for now.
            disp("Getting GIT Version");
            [~,obj.versionCtrl] = system('git rev-parse HEAD');

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
            grids.midGrid.ColumnWidth = {'.75x','1x'};
            uibutton(grids.midGrid);
            uibutton(grids.midGrid);
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
            midgrid = obj.UIGrids.midGrid;
            mgrid = obj.UIGrids.mainGrid;

            %Top Grid
                %School logo top left
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

        end

        function delete(obj)
            %Handle class destruction when UI closed.
            disp("Calling mainGUI class destructor")
            delete(obj.figure)
            diary off
        end
    end
end

