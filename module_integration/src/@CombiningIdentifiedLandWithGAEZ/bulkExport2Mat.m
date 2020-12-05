function bulkExport2Mat( obj)
%Exports most important information from the different arrays to cell array
%matrices in .mat files.
%JSN 24.01.2020

outputFolder = [obj.Settings.outputFolders{1} '/Bulk_export'];
if ~strcmp(outputFolder(end), '/')
    outputFolder(end+1) = '/';
end
if exist(outputFolder,'dir') ~= 7
    mkdir(outputFolder);
end


timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
filename = [outputFolder 'bulk_export_' timestamp '.mat'];

GAEZ_output = {'Description','Variable', 'Value', 'Unit'}; 



c=2; %row counter
for i = 1:length(obj.GAEZ_array)
    currentObject = obj.GAEZ_array(i);
    %Find climate projection
    if currentObject.climateScenarioID == 1
        climateProjection = 'Historical';
    elseif currentObject.climateScenarioID == 2
        climateProjection = 'RCP 4.5';
    elseif currentObject.climateScenarioID == 3
        climateProjection = 'RCP 8.5';
    end
    %Find water supply
    if currentObject.isIrrigated == 1
        waterSupply = 'Irrigated';
    elseif currentObject.isRainfed == 1
        waterSupply = 'Rain-fed';
    end
    %Find agricultural input level
    if currentObject.inputRate == 3
        inputLevel = 'High agricultural input';
    elseif currentObject.inputRate == 2
        inputLevel = 'Medium agricultural input';
    elseif currentObject.inputRate == 1
        inputLevel = 'Low agricultural input';
    end
    
    %Print descriptions
    description = [num2str(currentObject.year) '|' climateProjection '|' waterSupply '|' inputLevel];
    
    
   GAEZ_output(c,:) = {description, 'Land Cover|Abandoned cropland', sum(sum(obj.identifiedLandMatrix_hectares)), 'Mha'};
   c=c+1;
   GAEZ_output(c,:) = {description, 'Land Cover|Abandoned cropland|Outside biodiversity hotspots', sum(sum(obj.identifiedLandMatrix_excludingBiodiversityHotspots_hectares)), 'Mha'};
   c=c+1;
   GAEZ_output(c,:) = {description, 'Biomass extraction|Abandoned cropland', currentObject.cropYield_identifiedLands_tonsPerYear_sum, 'ton/yr'};
   c=c+1;
   GAEZ_output(c,:) = {description, 'Biomass extraction|Abandoned cropland|Outside biodiversity hotspots', currentObject.cropYield_identifiedLands_excludingBioDHotspots_tonsPerYear_sum, 'ton/yr'};
   c=c+1;
   GAEZ_output(c,:) = {description, 'Primary energy|Biomass|Abandoned cropland', currentObject.primaryEnergyOutput_total_lhv_EJ_perYear, 'EJ/yr'};
   c=c+1;
   GAEZ_output(c,:) = {description, 'Primary energy|Biomass|Abandoned cropland|Outside biodiversity hotspots', currentObject.primaryEnergyOutput_total_lhv_EJ_perYear, 'EJ/yr'};
   c=c+1;
   GAEZ_output(c,:) = {description, 'Primary energy|Biomass|Abandoned cropland|Outside biodiversity hotspots', currentObject.primaryEnergyOutput_total_lhv_EJ_perYear, 'EJ/yr'};
   c=c+1;
   
end

end

