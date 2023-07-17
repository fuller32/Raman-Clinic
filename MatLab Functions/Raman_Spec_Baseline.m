function [corrected_Spec,base] = Raman_Spec_Baseline(spectrum,order)
%{
    Function Name:              Raman_Spec_Baseline.m
    Date of origination:        7/13/2023
    Programmer:                 Seamus Fullerton
    Organizations:              Rowan University,
                                Advanced Materials and Manufacturing 
                                Institute (AMMI)

    Citation:
    Schulze HG, Foist RB, Okuda K, Ivanov A, Turner RFB. 
    A Small-Window Moving Average-Based Fully Automated Baseline Estimation Method for Raman Spectra.
    Applied spectroscopy. 2012;66(7):757-764. doi:10.1366/11-06550

    
    Description:
        Code based on the paper "A Small-Window Moving Average-Based Fully 
        Automated Baseline Estimation Method for Raman Spectra." Purpose is
        to provide a baseline correction for Raman spectra data. Code will
        follow the flow chart found in above citation (Figure 2d). Figure 
        will also be added to documents tab for ease of access.

    Revisions:

    Rev "-": Initial release of the code            Seamus Fullerton 
%}
    %Initial Window Size
    initWindow = 1; %Window will have 2 added inside loop clean up later

    %Extrapolate Data
        %For now just going to take first and last value will find a
        %efficent way to do proper extrapolation later if this method shows
        %promise.
    leng = size(spectrum,1);
    onesArray = ones([ceil(leng/4),1]);
    fullSpec = [spectrum(1)*onesArray;spectrum;spectrum(end)*onesArray];

    %% Main Loop
    %Create Flag to exit loop
    stopFlag = 0;
    %Initiate counter
    counter = 0;
    %Create window variable
    window = initWindow;
    %Get Full length of extrapolated data
    fullLen = size(fullSpec,1);
    %Create Spectrum that will change during runtime
    S = fullSpec;
    %Preallocate
    baseline = zeros(fullLen,1);
    area = zeros(fullLen,1);
    corrBaseline = cell(fullLen,1);

    while stopFlag == 0
        counter = counter+1;
        %Increment Window by 2
        window = window + 2;
        %Estimate Baseline using Savitzky-Golay filter
            %Matlab has a built in filter
            %Paper makes use of 0 order
        estBase = sgolayfilt(S,order,window);
        %Check if estimated base is greater then spectrum
        for i = 1:fullLen
            if S(i)>estBase(i)
                baseline(i) = estBase(i);
            else
                baseline(i) = S(i);
            end
        end
        %Find the area
        area(counter) = trapz(S-baseline);

        %Store corrected baseline
        corrBaseline{counter} = baseline;

        %Store baseline as new spectrum
        S = baseline;

        %Check if 4 iterations have occured
        if counter > 3
            %See if we have a local minimum
            if area(counter-2) > area(counter-1) && area(counter) > area(counter-1)
                %If true store counter to later index correct baseline
                idx = counter;
                %Set stopFlag to exit loop
                stopFlag = 1;
            end
        end
    end

    %% Formating output
    %Get base
    base = corrBaseline{idx};

    %Solve for corrected spectrum
    corrected_Spec = fullSpec - base;

    %Trim off the extrapolated data
    base = base(ceil(leng/4)+1:ceil(leng/4)+leng);
    corrected_Spec = corrected_Spec(ceil(leng/4)+1:ceil(leng/4)+leng);
end

