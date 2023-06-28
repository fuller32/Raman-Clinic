function [vt, vt_slope_loci_data] = calculate_vt(vg_id_data, vd, num_of_vg_steps)
% num_of_vg_steps is a scalar value (currently only 24 or 116 are supported)
% indicating the number of vg-steps swept
% through in a data collection sweep - this is used
% to preallocate the calculated vt matrix size (for code speed) and
% includes the 0V datapoint
% vd is a scalar indicating the drain voltage bias used in the
% datacollection circuit -- this will affect the Vt calculation
% vg_id is the num_of_vg_steps-by-2 matrix containing the sweep data to be
% used for vt extraction in the format [vg|id] with vg data in volts and id
% data in amps.

% We decided upon using a 4-point slope locus while using the 24 vg-step
% system -> this equates to a vg span of ~0.1953125[V] for the slope locus
% while calculating the final vt-shift (as the 24-point sweep uses a 5LSB
% stepsize in the DAC).


% preallocate vt vector and separate the vg_id_data matrix:
% output vt as a 1-by-4 row vector of vt values
vt = zeros(1, 4);
vg = vg_id_data(:,1);
id = vg_id_data(:,2);


% output the slope points as a 1-by-4 cell array of datamatrices
vt_slope_loci_data = cell(1,4);

switch num_of_vg_steps
    case 24 % Then system uses 5LSB step -- use 2:1:5 for slope loci
        num_slope_locus_points_start = 2;
        slope_locus_points_stepsize = 1;
        num_slope_locus_points_end = 5;
        
        % Preallocate slope loci matrices within cell array:
        vt_slope_loci_data{1} = zeros(2,2);
        vt_slope_loci_data{2} = zeros(3,2);
        vt_slope_loci_data{3} = zeros(4,2);
        vt_slope_loci_data{4} = zeros(5,2);
    case 116 % Then system uses 1LSB step -- use 6:5:21 for slope loci
        num_slope_locus_points_start = 6;
        slope_locus_points_stepsize = 5;
        num_slope_locus_points_end = 21;
        
        % Preallocate slope loci matrices within cell array:
        vt_slope_loci_data{1} = zeros(6,2);
        vt_slope_loci_data{2} = zeros(11,2);
        vt_slope_loci_data{3} = zeros(16,2);
        vt_slope_loci_data{4} = zeros(21,2);
    otherwise
        fprintf('Error in "calculate_vt.m"\n\n');
        return
end




vt_loop_counter = 1; % initialize a loop counter for data-indexing of each slope locus and vt point:
for num_slope_locus_points = num_slope_locus_points_start:slope_locus_points_stepsize:num_slope_locus_points_end
    
    num_of_slope_loci = num_of_vg_steps - (num_slope_locus_points - 1);
    slope_locus_extend_length = num_slope_locus_points - 1;
    
    slope = zeros(num_of_slope_loci,1); % preallocate slope vector
    for slope_locus_counter = 1:num_of_slope_loci
        % loop to calculate all instantaneous slopes over the set
        % slope-locus span of parent loop:
        x_locus = vg(slope_locus_counter:(slope_locus_counter+slope_locus_extend_length));
        y_locus = id(slope_locus_counter:(slope_locus_counter+slope_locus_extend_length));
        
        FO = fit(x_locus, y_locus, 'poly1');
        slope(slope_locus_counter) = FO.p1;
    end
    
    % find location of the minimum slope within the dataset over the parent
    % loop's slope-locus-span:
    max_slope_index = find(slope == min(slope));
    
    % flip the x and y data and linearly fit to obtain the x-intercept
    % using fit() function (for vt calculation) at the minimum slope:
    x_locus = id(max_slope_index:(max_slope_index+slope_locus_extend_length));
    y_locus = vg(max_slope_index:(max_slope_index+slope_locus_extend_length));
    FO = fit(x_locus, y_locus, 'poly1');
    
    
    vt(vt_loop_counter) = (FO.p2)+(vd/2); % calculate vt and store it for the corresponding number of slope points
    
    % store the Vg and Id datapoints for each slope locus for potential
    % plotting in parent program:
    vt_slope_loci_data{vt_loop_counter}(:,1) = y_locus;
    vt_slope_loci_data{vt_loop_counter}(:,2) = x_locus;
    
    vt_loop_counter = vt_loop_counter + 1; % increment loop counter for slope-locus indexing
end

end