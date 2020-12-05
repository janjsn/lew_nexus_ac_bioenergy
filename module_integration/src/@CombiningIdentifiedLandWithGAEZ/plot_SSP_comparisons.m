function  plot_SSP_comparisons( obj )
%PLOT_SSP_COMPARISONS Summary of this function goes here
%   Detailed explanation goes here


unique_model_names = unique({obj.SSP_data_array.model})
unique_ssps = unique({obj.SSP_data_array.ssp})
unique_rcps = unique([obj.SSP_data_array.corresponding_rcp])
unique_variables = unique({obj.SSP_data_array.variable})
unique_units = unique({obj.SSP_data_array.unit})

model_name_vector = {obj.SSP_data_array.model};
ssp_vector = {obj.SSP_data_array.ssp};
rcp_vector = {obj.SSP_data_array.corresponding_rcp};

binary_ssp1 = false(

%% Plot SSPs-1.9
figure1 = figure;
hold on
labelSize = 7;
%markerSize = 100;

set(gca,'FontSize',labelSize)

%Low management intensity, 
subplot(3,3,1)



end

