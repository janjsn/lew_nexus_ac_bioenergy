function [ output_args ] = plot_potentials_all_scenarios( obj, outputFolder  )
%PLOT_POTENTIALS_ALL_SCENARIOS Summary of this function goes here
%   Detailed explanation goes here


%Set present year
presentYear = 2050;
%Set climate scenario ID
climateScenarioID = 3;

%Export source data?
export_source_data = 1;

if climateScenarioID == 2
    climateString = 'RCP45';
elseif climateScenarioID == 3
    climateString = 'RCP85';
end

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
outputFolder = [outputFolder '/Bar charts/'];

filename = [outputFolder num2str(presentYear) '_' climateString '_stacked_bar_chart_energy_production_' timestamp '.svg'];
if export_source_data == 1
    filename_mat = [outputFolder num2str(presentYear) '_' climateString '_stacked_bar_chart_energy_production_source_data_' timestamp '.mat'];
end
if iscell(filename)
    temp = filename{1};
    for cells = 2:length(filename)
        temp = [temp filename{cells}];
    end
    filename = temp;
end




%Finding given year
binaryVector_givenYear(length(obj.OptimalPrimaryEnergyOutput_scenarioArray)) = 0;
for i = 1:length(binaryVector_givenYear)
    if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).year == presentYear
        if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).ClimateScenario.ID == climateScenarioID
            binaryVector_givenYear(i) = 1;
        end
    end
    
end

n_variants = sum(binaryVector_givenYear);
idx = binaryVector_givenYear == 1;

optimizedScenarios = obj.OptimalPrimaryEnergyOutput_scenarioArray(idx);
%get crops
n_crops = length(optimizedScenarios(1).spatialOptimizationMatrix_cropID_vector);
cropLabels = {optimizedScenarios(1).CropType_array.name};
cropIDs = [optimizedScenarios(1).CropType_array.ID];

barChartMatrix_4allLand_EJ = zeros(n_variants,n_crops);
barChartMatrix_outsideBiodiversityHotspots_EJ = zeros(n_variants,n_crops);
varLabels = {' '};

os_ir_vec(n_variants) = 0;
os_input_vec(n_variants) = 0;

for var = 1:n_variants
    for crop = 1:n_crops
        
        %find crop pos in given variant
        pos = 0;
        for c = 1:length(optimizedScenarios(var).spatialOptimizationMatrix_cropID_vector)
            if optimizedScenarios(var).spatialOptimizationMatrix_cropID_vector(c) == cropIDs(crop)
                pos = c;
                break
            end
        end
        
        if pos == 0
            optimizedScenarios(var)
            optimizedScenarios(var).spatialOptimizationMatrix_cropID_vector
            error('Could not find crop ID.')
        end
        
        barChartMatrix_4allLand_EJ(var,crop) = optimizedScenarios(var).spatialOptimization_primaryEnergy_vector_EJ_perCropPerYear_lhv(pos);
        barChartMatrix_outsideBiodiversityHotspots_EJ(var,crop) = optimizedScenarios(var).excluded_BH_primaryEnergy_vector_EJ_perCropPerYear_lhv(pos);
        
        
    end %for crop
    
    os_ir_vec(var) = optimizedScenarios(var).irrigationLevel;
    os_input_vec(var) = optimizedScenarios(var).fertilizerLevel;
    
    %    if optimizedScenarios(var).irrigationLevel == 0 && optimizedScenarios(var).fertilizerLevel == 1
    %        varLabels{var} = 'Low input, rain-fed';
    %        varLabels_WS{var} = 'rain-fed';
    %    elseif optimizedScenarios(var).irrigationLevel == 0 && optimizedScenarios(var).fertilizerLevel == 2
    %        varLabels{var} = 'Medium input, rain-fed';
    %        varLabels_WS{var} = 'rain-fed';
    %    elseif optimizedScenarios(var).irrigationLevel == 0 && optimizedScenarios(var).fertilizerLevel == 3
    %        varLabels{var} = 'High input, rain-fed';
    %        varLabels_WS{var} = 'rain-fed';
    %    elseif optimizedScenarios(var).irrigationLevel == 1 && optimizedScenarios(var).fertilizerLevel == 2
    %        varLabels{var} = 'Medium input, irrigated';
    %        varLabels_WS{var} = 'irrigated';
    %    elseif optimizedScenarios(var).irrigationLevel == 1 && optimizedScenarios(var).fertilizerLevel == 3
    %        varLabels{var} = 'High input, irrigated';
    %        varLabels_WS{var} = 'irrigated';
    %    end %if
    
end %for var

%% Find water scarcity scenarios results
binaryVector_ws_givenYear(length(obj.WaterScarcity_scenarioArray)) = 0;

for ws = 1:length(obj.WaterScarcity_scenarioArray)
    if obj.WaterScarcity_scenarioArray(ws).year == presentYear && obj.WaterScarcity_scenarioArray(ws).fertilizerLevel > 1 && obj.WaterScarcity_scenarioArray(ws).ClimateScenario.ID == climateScenarioID
        binaryVector_ws_givenYear(ws) = 1;
    end
end

idx_ws = binaryVector_ws_givenYear == 1;
ws_array = obj.WaterScarcity_scenarioArray(idx_ws);
n_ws = length(ws_array);
n_management_mix = 2;

inputLevels = [ws_array.fertilizerLevel];

if presentYear == 2020
    barChartMatrix_combineWSnOpt = zeros(n_variants+n_ws+n_management_mix,n_crops);
    barChartMatrix_outsideBH_combineWSnOpt = zeros(n_variants+n_ws+n_management_mix,n_crops);
else
    barChartMatrix_combineWSnOpt = zeros(n_variants+n_ws,n_crops);
    barChartMatrix_outsideBH_combineWSnOpt = zeros(n_variants+n_ws,n_crops);
end
c=1; %counter


%get optimals
for var = 1:n_variants
    if os_ir_vec(var) == 0 && os_input_vec(var) == 1
        barChartMatrix_combineWSnOpt(1,:) = barChartMatrix_4allLand_EJ(var,:);
        barChartMatrix_outsideBH_combineWSnOpt(1,:) = barChartMatrix_outsideBiodiversityHotspots_EJ(var,:);
        varLabels{1} = 'Rain-fed';
        %         irContribution_EJ(1,c) = 1;
        %         irContribution_EJ(2,c) = 0;
        %         irContribution_BH_EJ(1,c) = 1;
        %         irContribution_BH_EJ(2,c) = 0;
        
        % c=c+1; %counter
    elseif os_ir_vec(var) == 0 && os_input_vec(var) == 2
        barChartMatrix_combineWSnOpt(2,:) = barChartMatrix_4allLand_EJ(var,:);
        barChartMatrix_outsideBH_combineWSnOpt(2,:) = barChartMatrix_outsideBiodiversityHotspots_EJ(var,:);
        varLabels{2} = 'Rain-fed';
        %         irContribution_EJ(1,c) = 2;
        %         irContribution_EJ(2,c) = 0;
        %         irContribution_BH_EJ(1,c) = 2;
        %         irContribution_BH_EJ(2,c) = 0;
        
        %c=c+1; %counter
    elseif os_ir_vec(var) == 0 && os_input_vec(var) == 3
        barChartMatrix_combineWSnOpt(5,:) = barChartMatrix_4allLand_EJ(var,:);
        barChartMatrix_outsideBH_combineWSnOpt(5,:) = barChartMatrix_outsideBiodiversityHotspots_EJ(var,:);
        varLabels{5} = 'Rain-fed';
        %         irContribution_EJ(1,c) = 5;
        %         irContribution_EJ(2,c) = 0;
        %         irContribution_BH_EJ(1,c) = 5;
        %         irContribution_BH_EJ(2,c) = 0;
        
        % c=c+1; %counter
    elseif os_ir_vec(var) == 1 && os_input_vec(var) == 2
        barChartMatrix_combineWSnOpt(3,:) = barChartMatrix_4allLand_EJ(var,:);
        barChartMatrix_outsideBH_combineWSnOpt(3,:) = barChartMatrix_outsideBiodiversityHotspots_EJ(var,:);
        varLabels{3} = 'Irrigated';
        irContribution_EJ(1,c) = 3;
        irContribution_EJ(2,c) = sum(barChartMatrix_4allLand_EJ(var,:));
        irContribution_BH_EJ(1,c) = 3;
        irContribution_BH_EJ(2,c) = sum(barChartMatrix_outsideBiodiversityHotspots_EJ(var,:));
        c=c+1; %counter
    elseif os_ir_vec(var) == 1 && os_input_vec(var) == 3
        barChartMatrix_combineWSnOpt(6,:) = barChartMatrix_4allLand_EJ(var,:);
        barChartMatrix_outsideBH_combineWSnOpt(6,:) = barChartMatrix_outsideBiodiversityHotspots_EJ(var,:);
        varLabels{6} = 'Irrigated';
        irContribution_EJ(1,c) = 6;
        irContribution_EJ(2,c) = sum(barChartMatrix_4allLand_EJ(var,:));
        irContribution_BH_EJ(1,c) = 6;
        irContribution_BH_EJ(2,c) = sum(barChartMatrix_outsideBiodiversityHotspots_EJ(var,:));
        c=c+1; %counter
    end
end



for ws = 1:n_ws
    if ws_array(ws).fertilizerLevel == 2
        barChartMatrix_combineWSnOpt(4,:) = ws_array(ws).primaryEnergy_perCrop_EJ;
        barChartMatrix_outsideBH_combineWSnOpt(4,:) = ws_array(ws).exclBH_primaryEnergy_perCrop_EJ;
        irContribution_EJ(1,c) = 4;
        irContribution_EJ(2,c) = ws_array(ws).primaryEnergy_total_EJ_perYear_irrigated_lhv;
        irContribution_BH_EJ(1,c) = 4 ;
        irContribution_BH_EJ(2,c) = ws_array(ws).exclBH_primaryEnergy_total_EJ_perYear_irrigated_lhv;
        c=c+1; %counter
        varLabels{4} = 'Mixed';
    elseif ws_array(ws).fertilizerLevel == 3
        barChartMatrix_combineWSnOpt(7,:) = ws_array(ws).primaryEnergy_perCrop_EJ;
        barChartMatrix_outsideBH_combineWSnOpt(7,:) = ws_array(ws).exclBH_primaryEnergy_perCrop_EJ;
        irContribution_EJ(1,c) = 7;
        irContribution_EJ(2,c) = ws_array(ws).primaryEnergy_total_EJ_perYear_irrigated_lhv;
        irContribution_BH_EJ(1,c) = 7;
        irContribution_BH_EJ(2,c) = ws_array(ws).exclBH_primaryEnergy_total_EJ_perYear_irrigated_lhv;
        c=c+1; %counter
        varLabels{7} = 'Mixed';
    end
end

% Add mixed management if present year is 2020
if presentYear == 2020
    
    for i = 1:length(cropIDs)
        barChartMatrix_combineWSnOpt(8,i) = 10^-12*sum(sum(obj.Mixed_management.pe_eo_rf.*(obj.Mixed_management.eo_rf_crop_allocation == cropIDs(i))));
        barChartMatrix_outsideBH_combineWSnOpt(8,i) = 10^-12*sum(sum(obj.Mixed_management.pe_eo_nc_rf.*(obj.Mixed_management.eo_rf_crop_allocation == cropIDs(i))));
        
        barChartMatrix_combineWSnOpt(9,i) = 10^-12*sum(sum(obj.Mixed_management.pe_eo_mixed.*(obj.Mixed_management.eo_mixed_crop_allocation == cropIDs(i))));
        barChartMatrix_outsideBH_combineWSnOpt(9,i) = 10^-12*sum(sum(obj.Mixed_management.pe_eo_nc_mixed.*(obj.Mixed_management.eo_mixed_crop_allocation == cropIDs(i))));
        
    end
    
    
    irContribution_EJ(1,c) = 9;
    irContribution_EJ(2,c) = obj.Mixed_management.pe_eo_mixed_ir_contribution_tot;
    irContribution_BH_EJ(1,c) = 9;
    irContribution_BH_EJ(2,c) = obj.Mixed_management.pe_eo_nc_mixed_ir_contribution_tot;
    c=c+1;
    
    varLabels{8} = 'Rain-fed';
    varLabels{9} = 'Mixed';
end

legendLabels = cropLabels;


%% Make figure
figure1 = figure;
labelSize = 7;

set(gca,'FontSize',labelSize)
%Bar witdth
w1 = 0.75; %Wide bar
w2 = 0.5; %Thin bar

% Transparancy
alpha(1)

%Plot stacked bar chart, all land
bar_all = bar(barChartMatrix_combineWSnOpt, w1,'stacked', 'FaceColor','flat');

hold on

%Plot on top, stacked bar chart, land/potential located outside biodiversity hotspots
bar_outside_bh = bar(barChartMatrix_outsideBH_combineWSnOpt, w2, 'stacked', 'LineStyle', '-', 'LineWidth', 0.5,'FaceColor','flat');
hold off
%Set transparancy on wide bars
alpha(bar_all,0.85)

%Xlabels
xticklabels(varLabels);
xtickangle(45);

%Ylabels
ylabel('EJ yr^{-1}');

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',labelSize)

%Legend

%legend(string(legendLabels), 'Location', 'northwest');

%Axis min/max
%ylim([0 40]);


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
    %bar_all(4).FaceColor = [1 1 0];
    
    bar_outside_bh(1).FaceColor = [0.9290 0.6940 0.1250];
    bar_outside_bh(2).FaceColor = [0.4660 0.6740 0.1880];
    bar_outside_bh(3).FaceColor = [0 0.4470 0.7410];
    %bar_outside_bh(4).FaceColor = [1 1 0];
end
hold on

%Plot Irrigation contributions to mixed graphs
for n_mixed = length(irContribution_EJ)
    
    scatter(irContribution_EJ(1,:),irContribution_EJ(2,:),'o','MarkerEdgeColor','black','LineWidth',0.75,'DisplayName', 'Irrigated');
    
    scatter(irContribution_BH_EJ(1,:),irContribution_BH_EJ(2,:),'*','MarkerEdgeColor','black','LineWidth',0.75,'DisplayName', 'Irrigated BH');
    
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


%saveas(figure1,filename);
print('-painters','-dsvg', '-r1000', filename)

close all
clear('figure1')

fprintf(['Energy potential bar figure saved to: ' filename '\n']);

if export_source_data == 1
    save(filename_mat, 'presentYear', 'climateScenarioID', 'climateString', 'barChartMatrix_combineWSnOpt', 'barChartMatrix_outsideBH_combineWSnOpt', 'irContribution_EJ', 'irContribution_BH_EJ')
end


end

