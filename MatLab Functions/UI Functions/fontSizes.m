function [fntSz] = fontSizes(screenHeight,screenWidth)
%{
    Function Name:              mainGUI.m
    Date of origination:        7/3/2023
    Programmer:                 Seamus Fullerton
    Organizations:              Rowan University,
                                Advanced Materials and Manufactoring
                                Institute (AMMI)
    
    Description:
        Handles the setting of the fontsizes based off the screen size.

    Revisions:

    Rev "-": Initial release of the code            Seamus Fullerton 
%}
if screenWidth <= 800 && screenHeight <= 600
    resolutionCategory = 'Low';
elseif screenWidth <= 1280 && screenHeight <= 800
    resolutionCategory = 'Medium';
elseif screenWidth > 1280 && screenHeight > 800
    resolutionCategory = 'High';
end

% Set font size based on the resolution category
switch resolutionCategory
    case 'Low'
        titleFontSize = 20;
        subheadingFontSize = 16;
        bodyFontSize = 12;
        labelFontSize = 10;
    case 'Medium'
        titleFontSize = 24;
        subheadingFontSize = 18;
        bodyFontSize = 14;
        labelFontSize = 12;
    case 'High'
        titleFontSize = 30;
        subheadingFontSize = 24;
        bodyFontSize = 16;
        labelFontSize = 14;
    otherwise
        % Default font sizes for unknown resolutions
        titleFontSize = 20;
        subheadingFontSize = 16;
        bodyFontSize = 12;
        labelFontSize = 10;
end

%Create stuct containing font sizes.
fntSz.titleFontSize = titleFontSize;
fntSz.subheadingFontSize = subheadingFontSize;
fntSz.bodyFontSize = bodyFontSize;
fntSz.labelFontSize = labelFontSize;

end

