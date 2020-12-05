function plotOptimizedScenarios_primaryEnergyOutputLHV_barChart_oneYear( obj, outputFolder, year )
%PLOTOPTIMIZEDSCENARIOS_PRIMARYENERGYOUTPUT_BARCHART_ONEYEAR Summary of this function goes here
%   Detailed explanation goes here

%% ALL IDENTIFIED LAND
binaryVector_givenYear(length(obj.OptimalPrimaryEnergyOutput_scenarioArray)) = 0;
for i = 1:length(binaryVector_givenYear)
   if obj.OptimalPrimaryEnergyOutput_scenarioArray(i).year == year
      binaryVector_givenYear(i) = 1; 
   end
    
end

idx = binaryVector_givenYear == 1;

EJ_perYear_lhv_afterScenario = [obj.OptimalPrimaryEnergyOutput_scenarioArray(idx).spatialOptimization_total_EJ_perYear_lhv];

scenarioDescriptions = {obj.OptimalPrimaryEnergyOutput_scenarioArray(idx).scenarioDescription_string};
%rcpStrings = {obj.OptimalPrimaryEnergyOutput_scenarioArray(idx).ClimateScenario.correspondingRCPstring};


figure1 = figure;
bar(EJ_perYear_lhv_afterScenario);
grid on
title(['Primary energy output, lhv, ' num2str(year)])

for i = 1:length(scenarioDescriptions)
   temp = scenarioDescriptions{i};
   temp = [temp(5:end-16) ' ' temp(end)];
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

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end
%outputFolder = [outputFolder];

if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end

filename = [outputFolder num2str(year) '_barChart_EJ_perYear_lhv_afterScenarios_' timestamp  '.svg'];
%saveas(figure1,filename)  % here you save the figure
print('-painters','-dsvg', '-r1000', filename)
close all

%% EXCLUDING BIODIVERSITY HOTSPOTS
binaryVector_givenYear(length(obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray)) = 0;
for i = 1:length(binaryVector_givenYear)
   if obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(i).year == year
      binaryVector_givenYear(i) = 1; 
   end
    
end

idx = binaryVector_givenYear == 1;

EJ_perYear_lhv_afterScenario = [obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(idx).spatialOptimization_total_EJ_perYear_lhv];

scenarioDescriptions = {obj.OptimalPrimaryEnergyOutput_noBiodiversityHotspots_scenarioArray(idx).scenarioDescription_string};

figure1 = figure;
bar(EJ_perYear_lhv_afterScenario);
grid on


for i = 1:length(scenarioDescriptions)
   temp = scenarioDescriptions{i};
   temp = [temp(5:end-16) ' ' temp(end)];
   for j = 1:length(temp)
       if strcmp(temp(j),'_')
           temp(j) = ' ';
       end
   end
      scenarioDescriptions{i} = temp;     
end


xticklabels(scenarioDescriptions);
xtickangle(90);

timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end
%outputFolder = [outputFolder];

if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end

filename = [outputFolder num2str(year) '_barChart_EJ_perYear_lhv_excludingBiodiversityHotspots_afterScenarios_' timestamp  '.svg'];
%saveas(figure1,filename)  % here you save the figure
print('-painters','-dsvg', '-r1000', filename)

close all

end

