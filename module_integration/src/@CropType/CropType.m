classdef CropType
    %CROPTYPE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        ID
        description
        isBioenergyCrop = 0;
        isFoodCrop = 0;
        includeInPrimaryEnergyOptimization = 0;
        carbon_content_of_dry_mass = 0.5;
        reference_carbon_content
        nitrogen_content_of_dry_mass
        
        %IF THERE ARE DIFFERENT CALORIFIC VALUES FOR DIFFERENT PARTS OF THE
        %CROP THESE VALUES NEEDS TO BE VECTORIZED.
        cropParts_fractions_vectorized  
        cropParts_descriptions_cellArray
        
        lowerHeatingValue_vectorizedAfterCropPart_MJperKg 
        references_calorificValues_lhv
        higherHeatingValue_vectorizedAfterCropPart_MJperKg 
        references_calorificValues_hhv
        
        actualOutput_allCropParts_kgPerKgYieldModelOutput %Sometimes GAEZ gives
        
        calorificValue_weighted_MJperKgYieldModelOutput_lhv
        calorificValue_weighted_MJperKgYieldModelOutput_hhv
        
        
        missing_value = 'N/A';
        
    end
    
    methods
        function obj = estimateWeightedCalorificValues(obj)
           if length(obj.lowerHeatingValue_vectorizedAfterCropPart_MJperKg) ~= length(obj.cropParts_fractions_vectorized)
               error('Heating values (lhv) not given for all crop parts or number of crop parts is wrong. Fix.')
           elseif length(obj.higherHeatingValue_vectorizedAfterCropPart_MJperKg) ~= length(obj.cropParts_fractions_vectorized)
               error('Heating values (hhv) not given for all crop parts or number of crop parts is wrong. Fix.')
           end
            
           %Prealloc
           obj.calorificValue_weighted_MJperKgYieldModelOutput_hhv = 0;
           obj.calorificValue_weighted_MJperKgYieldModelOutput_lhv = 0;
           %Estimating weighted calorific value.
           for i = 1:length(obj.cropParts_fractions_vectorized)
               obj.calorificValue_weighted_MJperKgYieldModelOutput_hhv = obj.calorificValue_weighted_MJperKgYieldModelOutput_hhv+(obj.cropParts_fractions_vectorized(i)*obj.higherHeatingValue_vectorizedAfterCropPart_MJperKg(i));
               obj.calorificValue_weighted_MJperKgYieldModelOutput_lhv = obj.calorificValue_weighted_MJperKgYieldModelOutput_lhv+(obj.cropParts_fractions_vectorized(i)*obj.lowerHeatingValue_vectorizedAfterCropPart_MJperKg(i));
           end
           
            
        end
    end
    
end

