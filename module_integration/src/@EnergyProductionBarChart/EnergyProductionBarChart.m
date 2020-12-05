classdef EnergyProductionBarChart
    %Class to create matrices for stacked bar charts of energy production
    %across variants and crops
    
    
    properties
        variantNames
        cropNames
        
        %Dimensions mXn (m = variants, n = crops)
        energyProductionMatrix_all
        energyProductionMatrix_outsideBiodiversityHotspots
        energyProductionMatrix_all_irrigated
        energyProductionMatrix_all_rainfed
    end
    
    methods
    end
    
end

