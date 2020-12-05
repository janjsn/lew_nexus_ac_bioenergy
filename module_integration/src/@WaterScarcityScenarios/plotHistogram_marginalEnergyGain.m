function plotHistogram_marginalEnergyGain( obj, outputFolder )
%PLOTHISTOGRAM_MARGINALENERGYGAIN Summary of this function goes here
%   Detailed explanation goes here
figure1 = figure;

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

data2Plot = obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_ws_inHectare';
mSize_data2Plot = size(data2Plot);
data2Plot = data2Plot*10^-6; %Get million hectares

%% Plot stacked bar chart
bar(data2Plot, 'stacked');

ylim([0 30])

%Title
titleString = obj.scenarioDescription_string;
for i = 1:length(titleString)
   if strcmp(titleString(i),'_')
      titleString(i) = ' '; 
   end
end


labels{1} = '0';
ylabel('Mha')
xlabel('GJ mm-1 ha-1 yr-1')

c=2;

mSize = size(obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_bounds);

labels{1} = 'No gain';
xticks([1:1:mSize(2)]);
for i = 2:mSize(2)
labels{c} = [num2str(obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_bounds(1,i)) '-' num2str(obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_bounds(2,i))];
c=c+1;
end

labels{end} = ['> ' num2str(obj.marginalEnergyGain_histogram_after_GJ_per_mm_ha_bounds(1,end))];

xticklabels(string(labels));
xtickangle(45);

legend({'Low water scarcity', 'Moderate water scarcity', 'High water scarcity'})


if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end
outputFolder = [outputFolder ];

if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end

filename = [outputFolder obj.scenarioDescription_string '_marginal_energy_gain_histogram_' timestamp '.tif'];


saveas(figure1,filename)  % here you save the figure


close all

clear('figure1')

end

