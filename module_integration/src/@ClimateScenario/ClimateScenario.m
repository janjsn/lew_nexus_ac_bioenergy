classdef ClimateScenario
    %CLIMATESCENARIO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        ID
        description
        isRCP = 0;
        isSRES = 0;
        isSSP = 0;
        isHistorical = 0;
        isBaseline_forComparisons = 0;
        
        
        correspondingRCP_ID = -1;
        correspondingSRES_ID = -1;
        correspondingRCP_string = ' ';
        correspondingSRES_string = ' ';
        
        missingValue_IDs = -1;
    end
    
    methods
    end
    
end

