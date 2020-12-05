function plotHistograms_hectaresGroupedPerPrimaryEnergyProdPotential_lhv( obj, outputFolder )
%Plots primary energy production potential distribution of available land
%in hectare
%   Detailed explanation goes here

figure1 = figure;

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

data2Plot = obj.spatialOptimization_prEnPotentialHistogramMatrix_cropEnergy_lhv';
mSize_data2Plot = size(data2Plot);
data2Plot_withNoYield = zeros(mSize_data2Plot(1)+1,mSize_data2Plot(2)+1);
data2Plot_withNoYield(1,end) = obj.spatialOptimization_zeroPrimaryEnergyPotential_lhv_hectares;
data2Plot_withNoYield(2:end,1:end-1) = data2Plot(:,:);
data2Plot_withNoYield = data2Plot_withNoYield*10^-6; %Get million hectares
%data2Plot_withNoYield(mSize_data2Plot+2,:) = 0;

%Plot stacked bar chart
bar(data2Plot_withNoYield, 'stacked');
%data2Plot_withNoYield
%Title
titleString = obj.scenarioDescription_string;
for i = 1:length(titleString)
   if strcmp(titleString(i),'_')
      titleString(i) = ' '; 
   end
end

manuallyOverwriteTitleString = 1;
if manuallyOverwriteTitleString == 1
   titleString = '2020, high input, rainfed'; 
end

title({titleString,'Hectares after primary energy production potential, lhv'});

labels{1} = '0';
ylabel('Million hectares')
xlabel('GJ/hectare')
xticks([1:1:mSize_data2Plot+1]);
c=2;
for i = 2:length(obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv)
labels{c} = [num2str(obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv(i-1)) '-' num2str(obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv(i))];
c=c+1;
end
%labels{c} = '650-700';
%labels{c+1} = '700-750';
%labels{c} = [ num2str(obj.spatialOptimization_prEnergyPotentialHistogram_bandsLimits_lhv(end)) '<'];

xticklabels(labels);
xtickangle(90);
grid on

legendLabel_cropNames = cell(1,length(obj.CropType_array)+1);

legendLabel_cropNames{length(obj.CropType_array)+1} = {'No potential'};

cropNames = {obj.CropType_array.name};
for i = 1:length(cropNames)
    legendLabel_cropNames{i} = cropNames{i};
end

legend(string(legendLabel_cropNames), 'Location', 'northeast');

if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end
outputFolder = [outputFolder 'Hectares_after_primary_energy_potential_stacked_histograms/LHV/'];

if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end

if obj.biodiversityHotspotsExcluded == 1
    filename = [outputFolder obj.scenarioDescription_string '_excludingBiodiversityHotspots_ha_histogram_' timestamp  '.jpg'];
else
    filename = [outputFolder obj.scenarioDescription_string '_ha_histogram_' timestamp '.jpg'];
end



saveas(figure1,filename)  % here you save the figure


close all

clear('figure1')
end





