function generate_Report(mainFig)
%{
    Function Name:              generate_Report.m
    Date of origination:        7/30/2023
    Programmer:                 Seamus Fullerton
    Organizations:              Rowan University,
                                Advanced Materials and Manufacturing 
                                Institute (AMMI)
    
    Description:
        Function that handles the automatic creation of reports following
        data processing. Makes use of MATLAB's report generator toolbox and
        microsoft word templates to handle the design. The word template
        has "holes" that are predefined by the user and MATLAB accesses
        these by name and populates the data.

    Revisions:

    Rev "-": Initial release of the code            Seamus Fullerton 
%}
    import mlreportgen.dom.*;

    templatePath = fullfile(cd,'Documents','Report Templates','fullReport.dotx');

    rptName = ['Report_',mainFig.activeTest];
    savePath = fullfile(mainFig.savefilePath,'Reports',rptName);
    plotPath = fullfile(mainFig.savefilePath,'Plots');
    doc = Document(savePath,'docx',templatePath);
    holeId = moveToNextHole(doc);
    while ~strcmp(holeId, '#end#')
        switch holeId
            case 'title'
                fprintf('Current hole ID: %s\n', holeId);
                str = ['Raman Results for ',mainFig.activeTest];
                textObj = Text(str,'RptHeader');
                append(doc,textObj);
            case 'date'
                fprintf('Current hole ID: %s\n', holeId);
                textObj = Text(date,'SubHeader');
                append(doc,textObj);
            case 'git'
                fprintf('Current hole ID: %s\n', holeId);
                textObj = Text(strtrim(mainFig.versionCtrl),'SubHeader');
                append(doc,textObj);
            case 'tbl1'
                fprintf('Current hole ID: %s\n', holeId);
                tbl = mainFig.activeTestInfo;
                col1 = tbl.Properties.VariableNames;
                col2 = table2cell(tbl);
                tbl = [col1' col2'];
                table = Table(tbl,'tblDesign');
                append(doc,table);
            case 'ramanPlot'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'Raman_Plot.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
            case 'reducedramanPlot'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'Reduced_Raman.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
            case 'chemPlot'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'Cure_Kinetics.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
            case 'chemFitPlot'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'Cure_Kinetics_Fit.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
            case 'chemPlotTrim'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'Cure_Kinetics_s.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
            case 'chemFitPlotTrim'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'Cure_Kinetics_Fit_s.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
            case 'strucPlot'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'LA_Cure_Kinetics.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
            case 'strucFitPlot'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'LA_Cure_Kinetics_fit.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
            case 'strucPlotTrim'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'LA_Cure_Kinetics_s.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
            case 'strucFitPlotTrim'
                fprintf('Current hole ID: %s\n', holeId);
                imPath = fullfile(plotPath,'LA_Cure_Kinetics_fit_s.png');
                image = Image(imPath);
                image.Width  = '13cm';
                image.Height = '10cm';
                append(doc,image);
        end
        holeId = moveToNextHole(doc);
    end
    close(doc);

    rptview(doc.OutputPath,'pdf');
end

