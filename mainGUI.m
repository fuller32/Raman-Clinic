classdef mainGUI < handle
%{
    Function Name:              mainGUI.m
    Date of origination:        7/3/2023
    Programmer:                 Seamus Fullerton
    Organizations:              Rowan University,
                                Advanced Materials and Manufactoring
                                Institute (AMMI)
    
    Description:
        GUI that will handle the calling of all the necessary functions to
        fully process test data. Also will read in the excel file we
        maintain of test data and appropriately update it.

        GUI will make use of uigrids to handle layout. Run the following
        from the command window to read more uigridlayout. Allows for much
        easier maitance of UI's through code.

        Also will allow features like batch processing based of desired
        user settings with minimum input.

    Revisions:

    Rev "-": Initial release of the code            Seamus Fullerton 
%}
    properties
        versionCtrl
        fontSz
        figure
    end
    
    methods
        function obj = mainGUI
            %Check what commit number we are working under. This assumes
            %modifications to the code haven't been made since last commit,
            %can be made more robust but good enough for now.
            [~,obj.versionCtrl] = system('git rev-parse HEAD');

            %Call the method to generate the form
            createForm(obj);
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
                [0,0,.75*width,.75*height]);
            %Center form
            movegui(obj.figure,"center");
        end
    end
end

