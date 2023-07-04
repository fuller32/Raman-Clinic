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
                    "LA_Raman_Cure"];

    %Include the different setups into the return (Right now it is only
    %Epon828 need a better understanding of what needs to be ran for the
    %other resins.)
    codeOrder.Epon828 = Epon828;
end

