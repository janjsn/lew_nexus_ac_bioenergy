function plotHistogram_hectaresGroupedAfterWaterUsePerEnergyGain( obj, outputFolder )
%PLOTHISTOGRAMS_HECTARESGROUPEDAFTERPRIMARYENERGYPRODPOTENTIAL Summary of this function goes here
%   Detailed explanation goes here

figure1 = figure;

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

data2Plot = obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_hectare;
mSize_data2Plot = size(data2Plot);
data2Plot = data2Plot*10^-6; %Get million hectares

%% Plot stacked bar chart
bar(data2Plot, 'stacked');

%Title
titleString = obj.scenarioDescription_string;
for i = 1:length(titleString)
   if strcmp(titleString(i),'_')
      titleString(i) = ' '; 
   end
end

%% changing title for specific case
changeTitleManually = 1;
if changeTitleManually == 1
   titleString = '2020, high input'; 
end

title({titleString,'Hectares after water use per energy gain, lhv'});



labels{1} = '0';
ylabel('Million hectares')
xlabel('mm ha GJ-1')

c=2;

mSize = size(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds);

labels{1} = 'No potential';
xticks([1:1:mSize(2)]);
for i = 2:length(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds)
labels{c} = [num2str(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds(1,i)) '-' num2str(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds(2,i))];
c=c+1;
end

labels{end} = ['> ' num2str(obj.waterUsePerEnergyYieldGain_lhv_mm_ha_perGJ_histogram_bounds(1,end))];


%labels{c} = [ num2str(obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv(end)) '<'];

xticklabels(string(labels));
xtickangle(90);
% grid on
% 
% legendLabel_cropNames = cell(1,length(obj.CropType_array)+1);
% 
% legendLabel_cropNames{length(obj.CropType_array)+1} = {'No potential'};
% 
% cropNames = {obj.CropType_array.name};
% for i = 1:length(cropNames)
%     legendLabel_cropNames{i} = cropNames{i};
% end
% 
% legend(string(legendLabel_cropNames), 'Location', 'northwest');

if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end
outputFolder = [outputFolder ];

if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end

filename = [outputFolder obj.scenarioDescription_string 'after_water_use_per_energy_gain_histogram_' timestamp '.tif'];

% if obj.biodiversityHotspotsExcluded == 1
%     filename = [outputFolder obj.scenarioDescription_string '_excludingBiodiversityHotspots_ha_histogram_' timestamp  '.jpg'];
% else
%     filename = [outputFolder obj.scenarioDescription_string '_ha_histogram_' timestamp '.jpg'];
% end



saveas(figure1,filename)  % here you save the figure
filename(end-3:end) = '.svg';
    print('-painters','-dsvg', '-r1000', filename)

close all

clear('figure1')


end





