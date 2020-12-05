function  plotStandardizedEnergyYieldHistogram( obj, outputFolder, addLegend_binary )
%Plotting standardized energy yield histogram
%Standard bounds taken from Model.Settings
%10.01.2020 JSN
timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
outputFolder = [outputFolder '/Water scarcity variants energy yield histograms/'];

filename = [outputFolder obj.scenarioDescription_string '_' timestamp '.tif'];
temp = filename{1};
for cells = 2:length(filename)
   temp = [temp filename{cells}]; 
end
filename = temp;
filename_source_data = filename(1:end-3);
filename_source_data = [filename_source_data 'mat'];

cropTypeNames = {obj.CropType_array.name};
%% Create legend labels if set
if exist('addLegend_binary', 'var') 
    if addLegend_binary == 1
        for i = 1:length(cropTypeNames)
            legendLabels{i} = [cropTypeNames{i}];
            legendLabels{1+i+length(cropTypeNames)} = [cropTypeNames{i} ' BH'];
        end
        legendLabels{length(cropTypeNames)+1} = 'No potential';
        legendLabels{length(legendLabels)+1} = 'No potential  BH';
        legend(string(legendLabels), 'Location', 'northeast');
    end
end

%Get data
histogramMatrix_hectare = obj.EnergyYieldHistogramData_lhv.histogramMatrix_all_Mha;
histogramMatrix_outsideBiodiversityHotspots = obj.EnergyYieldHistogramData_lhv.histogramMatrix_outsideBiodiversityHotspots_Mha;
%histogramMatrix_insideBiodiversityHotspots = obj.EnergyYieldHistogramData_lhv.histogramMatrix_insideBiodiversityHotspots_Mha;
bounds = obj.EnergyYieldHistogramData_lhv.bounds_GJperHa;
n_crops = length(obj.CropType_array);

%% Create x-axis labels
c=2;
labels{1} = '0';
for i = 2:length(bounds)
labels{c} = [num2str(bounds(1,i)) '-' num2str(bounds(2,i))];
c=c+1;
end

%% Make figure
figure1 = figure;
labelSize = 7;

set(gca,'FontSize',labelSize)
set(gca, 'FontName', 'Arial')
%Bar witdth
w1 = 0.75; %Wide bar
w2 = 0.5; %Thin bar

% Transparancy
alpha(1)

%Plot stacked bar chart, all land
bar_all = bar(histogramMatrix_hectare, w1,'stacked', 'FaceColor','flat');

hold on 
%Plot on top, stacked bar chart, land located outside biodiversity hotspots
bar_outside_bh = bar(histogramMatrix_outsideBiodiversityHotspots, w2, 'stacked', 'LineStyle', '-', 'LineWidth', 0.5,'FaceColor','flat');
hold off
%Set transparancy on wide bars
alpha(bar_all,0.85)

%Labeling
xticklabels(labels);
%xticklabels({' '});
xtickangle(45);



a = get(gca,'XTickLabel');  
set(gca,'XTickLabel',a,'fontsize',labelSize)

ylabel('Million hectares','FontSize', labelSize);
xlabel('GJ ha^{-1} yr^{-1}','FontSize', labelSize);

%Axis min/max
ylim([0 50]);
yticks([0:10:50]);

%yticklabels({' '})

%Set colormap
if n_crops == 3
%     bar_all(1).FaceColor = [79/255 110/255 195/255];
%     bar_all(2).FaceColor = [241/255 206/255 118/255];
%     bar_all(3).FaceColor = [159/255 224/255 155/255];
%     bar_all(4).FaceColor = [1 1 0];
%     
%     bar_bh(1).FaceColor = [79/255 110/255 195/255];
%     bar_bh(2).FaceColor = [241/255 206/255 118/255];
%     bar_bh(3).FaceColor = [159/255 224/255 155/255];
%     bar_bh(4).FaceColor = [1 1 0];

    bar_all(1).FaceColor = [0.9290 0.6940 0.1250];
    bar_all(2).FaceColor = [0.4660 0.6740 0.1880];
    bar_all(3).FaceColor = [0 0.4470 0.7410];
    bar_all(4).FaceColor = [1 1 0];
    
    bar_outside_bh(1).FaceColor = [0.9290 0.6940 0.1250];
    bar_outside_bh(2).FaceColor = [0.4660 0.6740 0.1880];
    bar_outside_bh(3).FaceColor = [0 0.4470 0.7410];
    bar_outside_bh(4).FaceColor = [1 1 0];
end

%% EXPORT

    %Checking name of folder
    for chars = length(filename):-1:1
        if strcmp(filename(chars),'/')
           outputFolder = filename(1:chars); 
           break
        end
        if chars == 1
           outputFolder = '/'; 
        end
    end
    
    if exist(outputFolder,'dir') ~= 7
        mkdir(outputFolder);
    end
    
    set(gca,'FontSize',labelSize)
    %set(gca, 'FontName', 'Arial')
    
    saveas(figure1,filename);
    
    filename(end-3:end) = '.svg';
    print('-painters','-dsvg', '-r1000', filename)
    
    close all 
    clear('figure1')
    
    fprintf(['Energy yield histogram figure saved to: ' filename '\n']);
    
    save(filename_source_data, 'histogramMatrix_hectare', 'histogramMatrix_outsideBiodiversityHotspots');
end


