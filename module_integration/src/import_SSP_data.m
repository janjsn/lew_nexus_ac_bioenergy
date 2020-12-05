function [ SSP_data_array ] = import_SSP_data( filename )
%IMPORT_SSP_DATA Summary of this function goes here
%   Detailed explanation goes here

[num,txt,raw] = xlsread(filename);

mSize = size(raw);

SSP_data_array(1:mSize(1)-1) = SSP_data;

for i = 1:length(SSP_data_array)
   SSP_data_array(i).region = raw{i+1,1};
   SSP_data_array(i).model_scenario_description = raw{i+1,2};
   SSP_data_array(i).model = raw{i+1,3};
   SSP_data_array(i).scenario = raw{i+1,4};
   SSP_data_array(i).ssp = raw{i+1,5};
   SSP_data_array(i).corresponding_rcp = raw{i+1,6};
   SSP_data_array(i).variable = raw{i+1,7};
   SSP_data_array(i).unit = raw{i+1,8};
   SSP_data_array(i).year_vector = [raw{1,9:end}];
   SSP_data_array(i).data_vector = [raw{i+1,9:end}];
end


end

