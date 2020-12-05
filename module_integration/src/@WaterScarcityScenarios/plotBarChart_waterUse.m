function plotBarChart_waterUse( obj, outputFolder )
%PLOTBARCHART_WATERUSE Summary of this function goes here
%   Detailed explanation goes here
      
 
figure1 = figure;

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

data2Plot = [obj.waterUse_lowWaterScarcity_total_m3 0 0
    0 obj.waterUse_moderateWaterScarcity_total_m3 0
    0 0 obj.waterUse_highWaterScarcity_total_m3];
mSize_data2Plot = size(data2Plot);       


data2Plot_bh = [obj.waterUse_inBiodiversityHotspots_lowWaterScarcity_total_m3 0 0
    0 obj.waterUse_inBiodiversityHotspots_moderateWaterScarcity_total_m3 0
    0 0 obj.waterUse_inBiodiversityHotspots_highWaterScarcity_total_m3];

data2Plot_no_bh = data2Plot-data2Plot_bh; %Change to outside biodiversity hotspots

%% Plot stacked bar chart
%set(gca,'FontSize',18)
labelSize = 18;



set(gca,'FontSize',labelSize)
%Bar witdth
w1 = 0.75; %Wide bar
w2 = 0.5; %Thin bar
% Transparancy
alpha(1)

ax = gca;
ax.FontSize = 18;

bar_all = barh(data2Plot*10^-9, w1,'stacked');
hold on
set(gca,'ColorOrderIndex',1)
bar_bh =  barh(data2Plot_no_bh*10^-9,w2, 'stacked');
hold off
%Set transparancy on wide bars
alpha(bar_all,0.85)

ax = gca;
ax.FontSize = 18;

xlim([0 400]);
xlabel('Billion m^3 yr^{-1}')
ylabel('Water scarcity level')
%ytickangle(90);
yticklabels({'Low', 'Moderate', 'High'})
%yticklabels({' ', ' ', ' '})
%xlim([0 25])

%Checking name of folder
if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end
outputFolder = [outputFolder ];

if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end
filename = [outputFolder obj.scenarioDescription_string '_water_use_' timestamp '.tif'];
filename_src = filename;
filename_src(end-2:end) = 'mat';
    
    saveas(figure1,filename);
    
    filename(end-3:end) = '.svg';
    print('-painters','-dsvg', '-r1000', filename)
    
    close all 
    clear('figure1')
    
    fprintf(['Water use figure saved to: ' filename '\n']);
    
    % Export source data
    save(filename_src, 'data2Plot_no_bh', 'data2Plot');
end

