function plotHistogram_areaAfterYield( obj, outputFolder )
%PLOTHISTOGRAM_AREAAFTERYIELD Summary of this function goes here
%   Detailed explanation goes here


figure1 = figure;

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

data2Plot = obj.cropYield_identifiedLands_histogram_ha;

bar(data2Plot);

labels{1} = '0';
ylabel('Hectares')
xlabel('Ton/Hectare')
c=2;
for i = 2:length(obj.cropYield_identifiedLands_histogram_ha)-1
labels{c} = [num2str(obj.cropYield_identifiedLands_histDescription_tonsPerYear_lessEqual(i-1)) '-' num2str(obj.cropYield_identifiedLands_histDescription_tonsPerYear_lessEqual(i))];
c=c+1;
end
labels{c} = [ num2str(obj.cropYield_identifiedLands_histDescription_tonsPerYear_lessEqual(end-1)) '<'];

xticklabels(labels);
xtickangle(90);

if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end
outputFolder = [outputFolder 'Hectare after yield histograms/'];

if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end

if obj.biodiversityHotspotsExcludedFromIdentifiedLand_binary == 1
    filename = [outputFolder obj.cropname '_excludingBiodiversityHotspots_ha_histogram_' timestamp  '.jpg'];
else
    filename = [outputFolder obj.cropname '_ha_histogram_' timestamp '.jpg'];
end

saveas(figure1,filename)  % here you save the figure


close all

clear('figure1')
end

