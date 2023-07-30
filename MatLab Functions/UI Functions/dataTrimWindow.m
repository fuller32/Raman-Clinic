classdef dataTrimWindow < handle
 %{
        Function Name:              dataTrimWindow.m
        Date of origination:        7/29/2023
        Programmer:                 Seamus Fullerton
        Organizations:              Rowan University,
                                    Advanced Materials and Manufacturing 
                                    Institute (AMMI)
        
        Description:
            GUI that will handle the trimming of data. Will create new
            shortened data that can be used by other functions. Allows the user
            to view both plots and select using data tips the left and right
            bounds.
    
        Revisions:
    
        Rev "-": Initial release of the code            Seamus Fullerton 
    %}

    properties
        mainGUIFig
        activeData
        fontSz
        figure
        UIGrids
        UIelements
        savefilePath
        Lbrush
        Rbrush
        Ldata
        Rdata
        xData
        yData
    end

    methods
        function obj = dataTrimWindow(mainGUI)
            disp("Creating Trim Window");
            obj.mainGUIFig = mainGUI;
            obj.savefilePath = mainGUI.savefilePath;
            obj.activeData = mainGUI.activeTest;

            height = obj.mainGUIFig.screenHeight;
            width = obj.mainGUIFig.screenWidth;

            %Set fontsizes based off screensize
            obj.fontSz = obj.mainGUIFig.fontSz;

            %Create form
            obj.figure = uifigure("Name","Ramen Clinic Data Trim","Position",...
                [0,0,.75*width,.75*height],"CloseRequestFcn",...
                @(h,e)delete(obj));
            %Center form
            movegui(obj.figure,"center");

            obj.createGrids;
            obj.createUI;

            obj.plotData;
        
        end

        function createGrids(obj)
            disp("Creating Trim Grids")
            grids.mainGrid = uigridlayout(obj.figure,[2,2]);
            grids.mainGrid.RowHeight = {'.5x','.1x'};
            obj.UIGrids = grids;
        end

        function createUI(obj)
            disp("Creating Trim UI")

            %Create Plots
            axes.plotAxesL = uiaxes(obj.UIGrids.mainGrid);
            axes.plotAxesL.Layout.Row = 1;
            axes.plotAxesL.Layout.Column = 1;
            obj.Lbrush = brush(axes.plotAxesL);
            obj.Lbrush.Enable = 'on';
            set(obj.Rbrush,"ActionPostCallback",@(h,e)brushedData(obj));

            axes.plotAxesR = uiaxes(obj.UIGrids.mainGrid);
            axes.plotAxesR.Layout.Row = 1;
            axes.plotAxesR.Layout.Column = 2;
            obj.Rbrush = brush(axes.plotAxesR);
            obj.Rbrush.Enable = 'on';
            set(obj.Rbrush,"ActionPostCallback",@(h,e)brushedData(obj));

            %Create Okay button
            buttons.okBtn = uibutton(obj.UIGrids.mainGrid,"Text","Accept",...
                "FontSize",obj.fontSz.subheadingFontSize,"FontWeight","Bold",...
                "ButtonPushedFcn",@(h,e)acceptBtn(obj));
            buttons.okBtn.Layout.Row = 2;
            buttons.okBtn.Layout.Column = 1;

            %Create close button
            buttons.closeBtn = uibutton(obj.UIGrids.mainGrid,"Text","Close",...
                "FontSize",obj.fontSz.subheadingFontSize,"FontWeight","Bold",...
                "ButtonPushedFcn",@(h,e)cancelBtn(obj));
            buttons.closeBtn.Layout.Row = 2;
            buttons.closeBtn.Layout.Column = 2;

            obj.UIelements.axes = axes;
            obj.UIelements.buttons = buttons;

        end
        function plotData(obj)

            disp("Plotting data")
            %Kinetics Fit
            fitpath = fullfile(obj.savefilePath,'Variables',"Epoxy_*settings.mat");
            fitpath = dir(fitpath);
            fitpath = fullfile(fitpath(1).folder,fitpath(1).name);
            load(fitpath,'fitparams','gof');
            plotPath = fullfile(obj.savefilePath,'Variables','Kinetics_PlotData.mat');
            load(plotPath,'plotData');
            ax = obj.UIelements.axes.plotAxesL;
            %For some reason you can't direct plot cfit data on a
            %UIplot (no good reason for this). Work around below
            f = figure("Visible","off");
            obj.Ldata = plotData;
            tempPlot = plot(plotData.x,plotData.y,'b.');
            copyobj(tempPlot,ax);
            close(f);
            axis(ax,"padded");
            xlabel(ax,'Time (s)');
            ylabel(ax,'Conversion');
            title(ax,{obj.activeData, 'Extent of Cure Kinetics'},'interpreter','none');

            %LA Kinetics Fit
            fitpath = fullfile(obj.savefilePath,'Variables',"Epoxy_*LA*settings.mat");
            fitpath = dir(fitpath);
            fitpath = fullfile(fitpath(1).folder,fitpath(1).name);
            load(fitpath,'fitparams','gof');
            plotPath = fullfile(obj.savefilePath,'Variables','LA_Kinetics_PlotData.mat');
            load(plotPath,'plotData');
            ax = obj.UIelements.axes.plotAxesR;
            %For some reason you can't direct plot cfit data on a
            %UIplot (no good reason for this). Work around below
            f = figure("Visible","off");
            obj.Rdata = plotData;
            tempPlot = plot(plotData.x,plotData.y,'b.');
            copyobj(tempPlot,ax);
            axis(ax,"padded");
            xlabel(ax,'Time (s)');
            ylabel(ax,'Conversion');
            title(ax,{obj.activeData, 'Extent of Cure Kinetics'},'interpreter','none');
        end

        function brushedData(obj)
            disp("Getting brushed data")
            ax = obj.UIelements.axes.plotAxesR;
            selectionHandle = ax.Children(1).BrushHandles;
            selectedData=selectionHandle.Children(1).VertexData;
            obj.xData = selectedData(1,:);
            obj.yData = selectedData(2,:);
        end

        function cancelBtn(obj)
            disp("Closing Trim Window");
            obj.delete;
        end

        function acceptBtn(obj)
            disp("Trimmed data selected");
            tempLdata = obj.Ldata;
            tempRdata = obj.Rdata;
            fullsz = size(tempLdata.x,2);
            leftIdx = 1;
            rightIdx = fullsz;

            while abs(tempLdata.x(leftIdx) - obj.xData(1)) > .5 
                leftIdx = leftIdx + 1;
            end

            while abs(tempLdata.x(rightIdx) - obj.xData(end)) > .5
                rightIdx = rightIdx - 1;
            end
            disp("Found indexes");
            try
                T = tempLdata.x(leftIdx:rightIdx)-tempLdata.x(leftIdx-1);
            catch
                T = tempLdata.x(leftIdx:rightIdx);
            end

            path = fullfile(obj.savefilePath,"Variables",[obj.activeData,'_s.mat']);
            save(path,"leftIdx","rightIdx","T");
            obj.delete;
        end

        function delete(obj)
            %Handle class destruction when UI closed.
            disp("Calling Data Trim class destructor")
            delete(obj.figure)
        end
    end
end
