function [ CropTypeArray ] = makeCropTypeArray(  )
%MAKECROPTYPEARRAY Summary of this function goes here
%   Detailed explanation goes here

nCrops = 4;

CropTypeArray(1:4) = CropType;

%Crop 1: Mischantus
CropTypeArray(1).name = 'Miscanthus';
CropTypeArray(1).ID = 1;
CropTypeArray(1).description = 'Miscanthus, bioenergy crop';
CropTypeArray(1).isBioenergyCrop = 1;
CropTypeArray(1).isFoodCrop = 0;
CropTypeArray(1).carbon_content_of_dry_mass = (0.4963*(1-0.0374)); % 0.49 of dry and ash free mass. Ash is 0.0374 of dry mass.
CropTypeArray(1).reference_carbon_content = 'Phyllis2';
CropTypeArray(1).nitrogen_content_of_dry_mass = 0.003;
CropTypeArray(1).includeInPrimaryEnergyOptimization = 1;
CropTypeArray(1).cropParts_fractions_vectorized = 1;
CropTypeArray(1).cropParts_descriptions_cellArray = {'Whole plant'};
CropTypeArray(1).higherHeatingValue_vectorizedAfterCropPart_MJperKg = 19.77;
CropTypeArray(1).references_calorificValues_hhv = {'Phylis2 database, mean'};

CropTypeArray(1).lowerHeatingValue_vectorizedAfterCropPart_MJperKg = [18.55];
CropTypeArray(1).references_calorificValues_lhv = {'Phylis2 database, mean'};

%Crop 2: Reed Canary Grass
CropTypeArray(2).name = 'Reed Canary Grass';
CropTypeArray(2).ID = 2;
CropTypeArray(2).description = 'Reed Canary Grass, bioenergy crop';
CropTypeArray(2).isBioenergyCrop = 1;
CropTypeArray(2).isFoodCrop = 0;
CropTypeArray(2).carbon_content_of_dry_mass = (0.4903*(1-0.0769));
CropTypeArray(2).nitrogen_content_of_dry_mass = 0.0071;
CropTypeArray(2).reference_carbon_content = 'Phyllis2';
CropTypeArray(2).includeInPrimaryEnergyOptimization = 1;
CropTypeArray(2).cropParts_fractions_vectorized = 1;
CropTypeArray(2).cropParts_descriptions_cellArray = {'Whole plant'};
CropTypeArray(2).higherHeatingValue_vectorizedAfterCropPart_MJperKg = [19.40];
CropTypeArray(2).references_calorificValues_hhv = {'Phylis2 database, mean'};

CropTypeArray(2).lowerHeatingValue_vectorizedAfterCropPart_MJperKg = [18.06];
CropTypeArray(2).references_calorificValues_lhv = {'Phylis2 database, mean'};

%Crop 3: Switchgrass
CropTypeArray(3).name = 'Switchgrass';
CropTypeArray(3).ID = 3;
CropTypeArray(3).description = 'Switchgrass, bioenergy crop';
CropTypeArray(3).isBioenergyCrop = 1;
CropTypeArray(3).isFoodCrop = 0;
CropTypeArray(3).carbon_content_of_dry_mass = (0.4943*(1-0.0630));
CropTypeArray(3).reference_carbon_content = 'Phyllis2';
CropTypeArray(3).nitrogen_content_of_dry_mass = 0.0077;
CropTypeArray(3).includeInPrimaryEnergyOptimization = 1;
CropTypeArray(3).cropParts_fractions_vectorized = 1;
CropTypeArray(3).cropParts_descriptions_cellArray = {'Whole plant'};
CropTypeArray(3).higherHeatingValue_vectorizedAfterCropPart_MJperKg = 19.16;
CropTypeArray(3).references_calorificValues_hhv = {'Phylis2 database, mean'};

CropTypeArray(3).lowerHeatingValue_vectorizedAfterCropPart_MJperKg = [17.82];
CropTypeArray(3).references_calorificValues_lhv = {'Phylis2 database, mean'};

%Crop 4: Sugarcane
CropTypeArray(4).name = 'Sugarcane';
CropTypeArray(4).ID = 4;
CropTypeArray(4).description = 'Sugarcane, bioenergy crop';
CropTypeArray(4).isBioenergyCrop = 1;
CropTypeArray(4).isFoodCrop = 0;
CropTypeArray(4).carbon_content_of_dry_mass = (0.4957*(1-0.0570)); %bagasse
CropTypeArray(4).reference_carbon_content = 'Phyllis2';
CropTypeArray(4).includeInPrimaryEnergyOptimization = 0;
CropTypeArray(4).cropParts_descriptions_cellArray = {'Sugar','Bagasse', 'Straw', 'Stalks', 'Residues'};
CropTypeArray(4).cropParts_fractions_vectorized = [1 0.7143 0 0 0.5]; %NOTE: GAEZ OUTPUT IS ONLY SUGAR. THEREFORE output > 1.
CropTypeArray(4).lowerHeatingValue_vectorizedAfterCropPart_MJperKg = [16.2 17.3 0 0 17.3 ] ;
CropTypeArray(4).references_calorificValues_lhv = {'Camargo (1990)','Camargo (1990)', 'Camargo (1990)', ' ', 'N/A'}; 
CropTypeArray(4).higherHeatingValue_vectorizedAfterCropPart_MJperKg = [19.3 19.3  0 0 20.53];
CropTypeArray(4).references_calorificValues_hhv = {'-','Baxter et al. (2014)','-', '-','Baxter et al. (2014)' };

%% ESTIMATING WEIGHTED CALORIFIC VALUE PER KG OUTPUT
for i  = 1:length(CropTypeArray)
   CropTypeArray(i) = CropTypeArray(i).estimateWeightedCalorificValues; 
end

end

