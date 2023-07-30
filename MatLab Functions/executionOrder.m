function codeOrder = executionOrder
%{
    Function Name:              executionOrder.m
    Date of origination:        7/3/2023
    Programmer:                 Seamus Fullerton
    Organizations:              Rowan University,
                                Advanced Materials and Manufacturing 
                                Institute (AMMI)
    
    Description:
        A function that builds the structs that the mainGUI will use to
        know the proper order of code execution for different test types.

    Revisions:

    Rev "-": Initial release of the code            Seamus Fullerton 
%}
    %Basic idea is the name of the Resin will determine what tests need to
    %be ran.
    Epon828.name = "Epon 828";
    Epon828.order = ["read_Ondax_files",...
                    "Epoxy_Raman_Cure",...
                    "LA_Raman_Cure",...
                    "generate_Report"];

    %% Epoxy_Raman_Cure
    Epon828.Epoxy_Raman_Cure.settings = {'','','','0','0','1000','.1','1',...
        '.01','0','1','0.01','1','10','.1'}; 
    Epon828.Epoxy_Raman_Cure.prompt = {'Mat-File','Start Time','Stop Time',...
        'Time Lower Limit','Time Upper Limit','Lambda','Alpha Min Value',...
        'Alpha Max Value','Alpha Step Size','k Min Value','k Max Value',...
        'k Step Size','n Min Value','n Max Value','n Step Size'};
    %% LA_Raman_Cure
    Epon828.LA_Raman_Cure.settings = {'','','','0','0','0','.1','1',...
        '.01','0','1','0.01','1','10','.1'}; 
    Epon828.LA_Raman_Cure.prompt = {'Mat-File','Start Time','Stop Time',...
        'Time Lower Limit','Time Upper Limit','Baseline Fit Order','Alpha Min Value',...
        'Alpha Max Value','Alpha Step Size','k Min Value','k Max Value',...
        'k Step Size','n Min Value','n Max Value','n Step Size'};


    
    %Include the different setups into the return (Right now it is only
    %Epon828 need a better understanding of what needs to be ran for the
    %other resins.)
    codeOrder.Epon828 = Epon828;
end

