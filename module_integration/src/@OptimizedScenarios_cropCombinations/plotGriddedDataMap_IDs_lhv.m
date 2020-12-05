function plotGriddedDataMap_IDs_lhv(obj, latVector, lonVector, CropType_array, outputFolder)
%PLOTGRIDDEDDATAMAP Summary of this function goes here
%   Plots the IDs of the best crops at given spatial location maximizing
%   primary energy output

if ~strcmp(outputFolder(end),'/')
    outputFolder = [outputFolder '/'];
end

outputFolder = [outputFolder 'Optimal_solution_maps_crop_types/'];

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

filename = [outputFolder 'optimal_solutions_cropIDs_' obj.scenarioDescription_string '_' timestamp '.jpg'];

dataMatrix = obj.spatialOptimizationMatrix_cropIDs_lhv';

%Check if directory exist
% c=0;
% for i = 1:length(filename)
%    if strcmp(filename(i),'/')
%       c=i; 
%    end
% end
%outputFolder = filename(1:c);

if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end


%% PICK A COLORMAP
%colormap jet;

%jet colormap, but 0 set to white.
%cmap = [1 1 1;0 0 0.625000000000000;0 0 0.687500000000000;0 0 0.750000000000000;0 0 0.812500000000000;0 0 0.875000000000000;0 0 0.937500000000000;0 0 1;0 0.0625000000000000 1;0 0.125000000000000 1;0 0.187500000000000 1;0 0.250000000000000 1;0 0.312500000000000 1;0 0.375000000000000 1;0 0.437500000000000 1;0 0.500000000000000 1;0 0.562500000000000 1;0 0.625000000000000 1;0 0.687500000000000 1;0 0.750000000000000 1;0 0.812500000000000 1;0 0.875000000000000 1;0 0.937500000000000 1;0 1 1;0.0625000000000000 1 0.937500000000000;0.125000000000000 1 0.875000000000000;0.187500000000000 1 0.812500000000000;0.250000000000000 1 0.750000000000000;0.312500000000000 1 0.687500000000000;0.375000000000000 1 0.625000000000000;0.437500000000000 1 0.562500000000000;0.500000000000000 1 0.500000000000000;0.562500000000000 1 0.437500000000000;0.625000000000000 1 0.375000000000000;0.687500000000000 1 0.312500000000000;0.750000000000000 1 0.250000000000000;0.812500000000000 1 0.187500000000000;0.875000000000000 1 0.125000000000000;0.937500000000000 1 0.0625000000000000;1 1 0;1 0.937500000000000 0;1 0.875000000000000 0;1 0.812500000000000 0;1 0.750000000000000 0;1 0.687500000000000 0;1 0.625000000000000 0;1 0.562500000000000 0;1 0.500000000000000 0;1 0.437500000000000 0;1 0.375000000000000 0;1 0.312500000000000 0;1 0.250000000000000 0;1 0.187500000000000 0;1 0.125000000000000 0;1 0.0625000000000000 0;1 0 0;0.937500000000000 0 0;0.875000000000000 0 0;0.812500000000000 0 0;0.750000000000000 0 0;0.687500000000000 0 0;0.625000000000000 0 0;0.562500000000000 0 0;0.500000000000000 0 0];

%jet colormap, but shifted towards lower values
cmap = [1 1 1;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 0.9375;0.125 1 0.875;0.1875 1 0.8125;0.25 1 0.75;0.3125 1 0.6875;0.375 1 0.625;0.4375 1 0.5625;0.5 1 0.5;0.5625 1 0.4375;0.625 1 0.375;0.6875 1 0.3125;0.75 1 0.25;0.8125 1 0.1875;0.875 1 0.125;0.9375 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0;0.5 0 0];

%add colormap


%% MAKE FIGURE
figure1 = figure;
hold on;
axes1 = axesm('miller');
surfm(latVector, lonVector, dataMatrix)
load coastlines
plotm(coastlat, coastlon, 'g');

%figure1.Colormap = cmap;
colormap(axes1, cmap);

%add colorbar and colorbar description
names_crops = {CropType_array.name};
colorbar_string = 'IDs';
yticks = [0 [CropType_array.ID]];
ytickLabels = cell(1,length(yticks));
ytickLabels{1} = 'No yield';
for i = 1:length(names_crops)
   ytickLabels{i+1} = names_crops{i}; 
end

colorbar_right = colorbar('ytick', yticks, 'YTickLabel', ytickLabels);
colorbar_right.Label.String = colorbar_string;


%% SAVE TO FILE
if exist(filename) == 2
    delete(filename)
end

saveas(figure1,filename)  % here you save the figure

end

