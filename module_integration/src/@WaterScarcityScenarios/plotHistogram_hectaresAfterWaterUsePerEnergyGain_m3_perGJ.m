function plotHistogram_hectaresAfterWaterUsePerEnergyGain_m3_perGJ( obj, outputFolder )
%PLOTHISTOGRAM_HECTARESAFTERWATERUSEPERENERGYGAIN_M3_PERGJ Summary of this function goes here
%   Detailed explanation goes here
figure1 = figure;

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

data2Plot = obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_ws_ha';
mSize_data2Plot = size(data2Plot);
data2Plot = data2Plot*10^-6; %Get million hectares

%Biodiversity hotspots
data2Plot_bh = (obj.waterUsePerEnergyGain_inBH_lhv_m3_perGJ_histogram_ws_ha')*10^-6;
data2Plot_no_bh = data2Plot-data2Plot_bh;
%% Plot stacked bar chart
set(gca,'FontSize',18)
%Bar width
w1 = 0.75;
w2 = 0.5;
%Transparancy
alpha(1)

%Plot all abandoned cropland
bar_all = barh(data2Plot, w1, 'stacked');
ax = gca;
ax.FontSize = 18;

hold on
set(gca,'ColorOrderIndex',1)
bar_bh = barh(data2Plot_no_bh, w2, 'stacked');
%Set transparancy on wide bars
alpha(bar_all,0.85)

hold off
xlim([0 25])
ax = gca;
ax.FontSize = 18;


%Title
titleString = obj.scenarioDescription_string;
for i = 1:length(titleString)
   if strcmp(titleString(i),'_')
      titleString(i) = ' '; 
   end
end


labels{1} = '0';
xlabel('Mha', 'FontSize', 18)
ylabel('m^3 GJ^{-1}', 'FontSize', 18)

c=2;

mSize = size(obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds);

labels{1} = 'No gain';
yticks([1:1:mSize(2)]);
for i = 2:mSize(2)
labels{c} = [num2str(obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds(1,i)) '-' num2str(obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds(2,i))];
c=c+1;
end

labels{end} = ['> ' num2str(obj.waterUsePerEnergyGain_lhv_m3_perGJ_histogram_bounds(1,end))];

yticklabels(string(labels));
%ytickangle(45);

%legend({'Low water scarcity', 'Moderate water scarcity', 'High water scarcity'})


if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end
outputFolder = [outputFolder ];

if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end

filename = [outputFolder obj.scenarioDescription_string '_blue_water_footprint_histogram_' timestamp '.tif'];


saveas(figure1,filename)  % here you save the figure
filename(end-3:end) = '.svg';
print('-painters','-dsvg', '-r1000', filename)

close all

clear('figure1')

filename_src = filename;
filename_src(end-2:end) = 'mat';
save(filename_src, 'data2Plot', 'data2Plot_no_bh');

end

