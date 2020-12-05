function plotEnergyProductionAsShareOfSSP2100Demand( obj, outputFolder, year, climateScenarioID )
%

%Median bioenergy demands in 2050 in SSPs
SSP1_19_bioenergyDemand_EJ = 94.8;
SSP2_19_bioenergyDemand_EJ = 169.2;
SSP4_19_bioenergyDemand_EJ = 83.3;
SSP5_19_bioenergyDemand_EJ = 245;

%% QUICKFIX BELOW FOR OTHER SSP forcings, be careful
use_SSPs_45 = 0;
use_SSPs_baselines = 0;
if use_SSPs_45 == 1
    SSP1_19_bioenergyDemand_EJ = (71.730+50.661)/2;
    SSP2_19_bioenergyDemand_EJ = (86.317+66.514)/2;
    SSP3_bioenergyDemand_EJ = (114.556+106.116)/2;
    SSP4_19_bioenergyDemand_EJ = (105.224+105.899)/2;
    SSP5_19_bioenergyDemand_EJ = 104.945;
    
elseif use_SSPs_baselines == 1
    SSP1_19_bioenergyDemand_EJ = (45.37+51.76)/2;
    SSP2_19_bioenergyDemand_EJ = (59.492+57.220)/2;
    SSP3_bioenergyDemand_EJ = 89.963;
    SSP4_19_bioenergyDemand_EJ = (105.519+97.028)/2;
    SSP5_19_bioenergyDemand_EJ = (51.706);
end

%% Continue
if climateScenarioID == 2
    climateString = 'RCP45';
elseif climateScenarioID == 3
    climateString = 'RCP85';
end

presentYear = year;

%Fix filename
timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
outputFolder = [outputFolder '/Scatter plots/'];

filename = [outputFolder num2str(presentYear) '_' climateString '_scatter_plot_energy_production_vs_ssp_demand' timestamp '.pdf'];
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
    if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).year == year
        if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).ClimateScenario.ID == climateScenarioID
            binaryVector_givenYear(i) = 1;
        end
    end
    
end

n_variants = sum(binaryVector_givenYear);
idx = binaryVector_givenYear == 1;

optimizedScenarios = obj.OptimalPrimaryEnergyOutput_scenarioArray(idx);

primaryEnergyProduction_vector = zeros(1,n_variants+2);
primaryEnergyProduction_outsideBiodiversityHotspots_vector = zeros(1,n_variants+2);
x_axis_vector = [1:1:n_variants+2];

for var = 1:n_variants
    if optimizedScenarios(var).fertilizerLevel == 1
        if optimizedScenarios(var).irrigationLevel == 0
            primaryEnergyProduction_vector(1) = optimizedScenarios(var).spatialOptimization_total_EJ_perYear_lhv;
            primaryEnergyProduction_outsideBiodiversityHotspots_vector(1) = optimizedScenarios(var).excluded_BH_spatialOptimization_total_EJ_perYear_lhv;
        end
    elseif optimizedScenarios(var).fertilizerLevel == 2
        if optimizedScenarios(var).irrigationLevel == 0
            primaryEnergyProduction_vector(2) = optimizedScenarios(var).spatialOptimization_total_EJ_perYear_lhv;
            primaryEnergyProduction_outsideBiodiversityHotspots_vector(2) = optimizedScenarios(var).excluded_BH_spatialOptimization_total_EJ_perYear_lhv;
        elseif optimizedScenarios(var).irrigationLevel == 1
            primaryEnergyProduction_vector(3) = optimizedScenarios(var).spatialOptimization_total_EJ_perYear_lhv;
            primaryEnergyProduction_outsideBiodiversityHotspots_vector(3) = optimizedScenarios(var).excluded_BH_spatialOptimization_total_EJ_perYear_lhv;
        end
    elseif optimizedScenarios(var).fertilizerLevel == 3
        if optimizedScenarios(var).irrigationLevel == 0
            primaryEnergyProduction_vector(5) = optimizedScenarios(var).spatialOptimization_total_EJ_perYear_lhv;
            primaryEnergyProduction_outsideBiodiversityHotspots_vector(5) = optimizedScenarios(var).excluded_BH_spatialOptimization_total_EJ_perYear_lhv;
        elseif optimizedScenarios(var).irrigationLevel == 1
            primaryEnergyProduction_vector(6) = optimizedScenarios(var).spatialOptimization_total_EJ_perYear_lhv;
            primaryEnergyProduction_outsideBiodiversityHotspots_vector(6) = optimizedScenarios(var).excluded_BH_spatialOptimization_total_EJ_perYear_lhv;
        end
        
    end
end

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

for ws = 1:n_ws
    if ws_array(ws).fertilizerLevel == 2
        primaryEnergyProduction_vector(4) = ws_array(ws).primaryEnergy_total_EJ_perYear_lhv;
        primaryEnergyProduction_outsideBiodiversityHotspots_vector(4) = ws_array(ws).exclBH_primaryEnergy_total_EJ_perYear_irrigated_lhv;
    elseif ws_array(ws).fertilizerLevel == 3
        primaryEnergyProduction_vector(7) = ws_array(ws).primaryEnergy_total_EJ_perYear_lhv;
        primaryEnergyProduction_outsideBiodiversityHotspots_vector(7) = ws_array(ws).exclBH_primaryEnergy_total_EJ_perYear_irrigated_lhv;
    end
end

%GET SHARES ACROSS SSPs
producedShareOfSSP1_19_vector = primaryEnergyProduction_vector/SSP1_19_bioenergyDemand_EJ;
producedShareOfSSP2_19_vector = primaryEnergyProduction_vector/SSP2_19_bioenergyDemand_EJ;
producedShareOfSSP4_19_vector = primaryEnergyProduction_vector/SSP4_19_bioenergyDemand_EJ
producedShareOfSSP5_19_vector = primaryEnergyProduction_vector/SSP5_19_bioenergyDemand_EJ;
producedShareOfSSP1_19_noBiodiversityHotspots_vector = primaryEnergyProduction_outsideBiodiversityHotspots_vector/SSP1_19_bioenergyDemand_EJ;
producedShareOfSSP2_19_noBiodiversityHotspots_vector = primaryEnergyProduction_outsideBiodiversityHotspots_vector/SSP2_19_bioenergyDemand_EJ;
producedShareOfSSP4_19_noBiodiversityHotspots_vector = primaryEnergyProduction_outsideBiodiversityHotspots_vector/SSP4_19_bioenergyDemand_EJ;
producedShareOfSSP5_19_noBiodiversityHotspots_vector = primaryEnergyProduction_outsideBiodiversityHotspots_vector/SSP5_19_bioenergyDemand_EJ;

%% MAKE FIGURE
figure1 = figure;
labelSize = 18;
markerSize = 100;

set(gca,'FontSize',labelSize)
scatter_ssp1 = scatter(x_axis_vector, 100*producedShareOfSSP1_19_vector,'o','MarkerEdgeColor',[0 0.5 0],'LineWidth',0.75,'DisplayName', 'SSP1-1.9', 'SizeData', markerSize);
hold on
scatter_ssp2 = scatter(x_axis_vector, 100*producedShareOfSSP2_19_vector,'o','MarkerEdgeColor','blue','LineWidth',0.75,'DisplayName', 'SSP2-1.9', 'SizeData', markerSize);
scatter_ssp4 = scatter(x_axis_vector, 100*producedShareOfSSP4_19_vector,'o','MarkerEdgeColor',[0.9100    0.4100    0.1700],'LineWidth',0.75,'DisplayName', 'SSP4-1.9', 'SizeData', markerSize);
scatter_ssp5 = scatter(x_axis_vector, 100*producedShareOfSSP5_19_vector,'o','MarkerEdgeColor','magenta','LineWidth',0.75,'DisplayName', 'SSP5-1.9', 'SizeData', markerSize);

%Biodiversity hotspots
scatter_bh_ssp1 = scatter(x_axis_vector, 100*producedShareOfSSP1_19_noBiodiversityHotspots_vector,'x','MarkerEdgeColor',[0 0.5 0],'LineWidth',0.75,'DisplayName', 'SSP1-1.9', 'SizeData', markerSize);
scatter_bh_ssp2 = scatter(x_axis_vector, 100*producedShareOfSSP2_19_noBiodiversityHotspots_vector,'x','MarkerEdgeColor','blue','LineWidth',0.75,'DisplayName', 'SSP2-1.9', 'SizeData', markerSize);
scatter_bh_ssp4 = scatter(x_axis_vector, 100*producedShareOfSSP4_19_noBiodiversityHotspots_vector,'x','MarkerEdgeColor',[0.9100    0.4100    0.1700],'LineWidth',0.75,'DisplayName', 'SSP4-1.9', 'SizeData', markerSize);
scatter_bh_ssp5 = scatter(x_axis_vector, 100*producedShareOfSSP5_19_noBiodiversityHotspots_vector,'x','MarkerEdgeColor','magenta','LineWidth',0.75,'DisplayName', 'SSP5-1.9', 'SizeData', markerSize);


if use_SSPs_45 == 1 || use_SSPs_baselines == 1
    producedShareOfSSP3_vector = primaryEnergyProduction_vector/SSP3_bioenergyDemand_EJ
    producedShareOfSSP3_noBiodiversityHotspots_vector = primaryEnergyProduction_outsideBiodiversityHotspots_vector/SSP3_bioenergyDemand_EJ;
    scatter_ssp3 = scatter(x_axis_vector, 100*producedShareOfSSP3_vector,'o','MarkerEdgeColor',[0.102    0.051    0.0],'LineWidth',0.75,'DisplayName', 'SSP3-4.5', 'SizeData', markerSize);
    scatter_bh_ssp3 = scatter(x_axis_vector, 100*producedShareOfSSP3_noBiodiversityHotspots_vector,'x','MarkerEdgeColor',[0.102    0.051    0.0],'LineWidth',0.75,'DisplayName', 'SSP5-1.9', 'SizeData', markerSize);
    
end

%marker sizes
% scatter_ssp1.MarkerSize = 12;
% scatter_ssp2.MarkerSize = 12;
% scatter_ssp5.MarkerSize = 12;
% scatter_bh_ssp1.MarkerSize = 12;
% scatter_bh_ssp2.MarkerSize = 12;
% scatter_bh_ssp5.MarkerSize = 12;

%h = legend('Location','northwest');
%set(h,'FontSize',16);
ylabel({'(%)'});
xlim([0 length(x_axis_vector)+1]);
%ylim([0 70]);
set(gca,'XTick',[0:1:length(x_axis_vector+1)]);
ax = gca;
ax.FontSize = 16;


box on
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

set(gcf, 'renderer', 'Painters')

%saveas(figure1,filename);
print('-painters','-dpdf', '-r1000', filename)

close all
clear('figure1')

fprintf(['Produced bioenergy as SSP 1.5 degrees scenario demand figure saved to: ' filename '\n']);

filename_src = filename;
filename_src(end-2:end) = 'mat';

if use_SSPs_45 == 1 || use_SSPs_baselines == 1
    warning_note = 'THIS IS ACTUALLY SSPx-45';
    if use_SSPs_baselines == 1
        warning_note = 'THIS IS ACTUALLY SSPx-baselines';
    end
    save(filename_src, 'warning_note', 'producedShareOfSSP1_19_vector', 'producedShareOfSSP2_19_vector', 'producedShareOfSSP4_19_vector', 'producedShareOfSSP5_19_vector', 'producedShareOfSSP1_19_noBiodiversityHotspots_vector','producedShareOfSSP2_19_noBiodiversityHotspots_vector', 'producedShareOfSSP4_19_noBiodiversityHotspots_vector', 'producedShareOfSSP5_19_noBiodiversityHotspots_vector', 'producedShareOfSSP3_vector', 'producedShareOfSSP3_noBiodiversityHotspots_vector' );
    
else
    save(filename_src, 'producedShareOfSSP1_19_vector', 'producedShareOfSSP2_19_vector', 'producedShareOfSSP4_19_vector', 'producedShareOfSSP5_19_vector', 'producedShareOfSSP1_19_noBiodiversityHotspots_vector','producedShareOfSSP2_19_noBiodiversityHotspots_vector', 'producedShareOfSSP4_19_noBiodiversityHotspots_vector', 'producedShareOfSSP5_19_noBiodiversityHotspots_vector');
end
end

