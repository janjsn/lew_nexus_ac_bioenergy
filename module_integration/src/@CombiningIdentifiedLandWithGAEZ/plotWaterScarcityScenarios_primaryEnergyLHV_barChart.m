function  plotWaterScarcityScenarios_primaryEnergyLHV_barChart( obj, outputFolder )
%PLOTWATERSCARCITYSCENARIOS_PRIMARYENERGYLHV_BARCHART Summary of this function goes here
%   Detailed explanation goes here
EJ_perYear_lhv_afterScenario = [obj.WaterScarcity_scenarioArray.primaryEnergy_total_EJ_perYear_lhv];
EJ_perYear_rainfed_lhv_afterScenario = [obj.WaterScarcity_scenarioArray.primaryEnergy_total_EJ_perYear_rainfed_lhv];
EJ_perYear_irrigated_lhv_afterScenario = [obj.WaterScarcity_scenarioArray.primaryEnergy_total_EJ_perYear_irrigated_lhv];

scenarioDescriptions = {obj.WaterScarcity_scenarioArray.scenarioDescription_string};

%matrix2Bar = [EJ_perYear_rainfed_lhv_afterScenario;EJ_perYear_irrigated_lhv_afterScenario];

matrix2Bar = zeros(length(EJ_perYear_irrigated_lhv_afterScenario),2);
for i = 1:length(EJ_perYear_irrigated_lhv_afterScenario)
   matrix2Bar(i,1) = EJ_perYear_rainfed_lhv_afterScenario(i); 
   matrix2Bar(i,2) = EJ_perYear_irrigated_lhv_afterScenario(i); 
end

figure1 = figure;
bar(matrix2Bar, 'stacked')
grid on;
title('Primary energy output after water use, lhv');

for i = 1:length(scenarioDescriptions)
   temp = scenarioDescriptions{i};
   temp = [temp(1:end-16) ' ' temp(end)];
   for j = 1:length(temp)
       if strcmp(temp(j),'_')
           temp(j) = ' ';
       end
   end
      scenarioDescriptions{i} = temp;     
end

ylabel('EJ')
xticklabels(scenarioDescriptions);
xtickangle(90);
legend('Rainfed','Irrigated');


timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end


if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end

filename = [outputFolder '_barChart_EJ_perYear_lhv_afterScenariosAndWaterUse_' timestamp  '.jpg'];
saveas(figure1,filename)  % here you save the figure

close all

end

