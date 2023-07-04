function main
%{
    Function Name:              main.m
    Date of origination:        7/3/2023
    Programmer:                 Seamus Fullerton
    Organizations:              Rowan University,
                                Advanced Materials and Manufactoring
                                Institute (AMMI)
    
    Description:
        Main point of entrance into the Raman Clinic code. Handles the
        adding of all the appropiate subfolders and the calling of the main
        GUI which handles all subfunctions

    Revisions:

    Rev "-": Initial release of the code            Seamus Fullerton 
%}
    disp("Adding folders to matlab path");
    %Verify if the code is compiled. Avoids issues if the code ever gets
    %compiled into an executable.
    x = isdeployed;
    if x == false
        addpath(genpath("Data\"),...
            genpath("MatLab Functions"),...
            "Plots\");
    end
    disp("Starting main GUI");
    mainGUI;
end

