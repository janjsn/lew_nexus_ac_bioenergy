classdef CountrySpecificResults
    %Class to represent country specific results
    
    properties
        countryName
        year
        climate
        Administrative_centers 
        identifiedLandMatrix_hectare
        identifiedLandMatrix_outsideBiodiversityHotspots_hectare
        
        bioenergyYields_rainfed_GJ_perHa
        bioenergyYields_irrigated_GJ_perHa
        
        bioenergyPotentialMatrix_rainfed_high_MJ
        bioenergyPotentialMatrix_irrigated_high_MJ
        bioenergyPotentialMatrix_mixed_high_MJ
        
        bioenergyPotential_rainfed_high_total_EJ  
        bioenergyPotential_irrigated_high_total_EJ
        bioenergyPotential_mixed_high_total_EJ
        
        bioenergyPotentialMatrix_noBH_rainfed_high_MJ
        bioenergyPotentialMatrix_noBH_irrigated_high_MJ
        bioenergyPotentialMatrix_noBH_mixed_high_MJ
        
        bioenergyPotential_noBH_rainfed_high_total_EJ  
        bioenergyPotential_noBH_irrigated_high_total_EJ
        bioenergyPotential_noBH_mixed_high_total_EJ
        
    end
    
    methods
    end
    
end

