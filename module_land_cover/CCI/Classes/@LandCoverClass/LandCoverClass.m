classdef LandCoverClass
    %LANDCOVERCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ID
        workID
        name
        isWater
        isUrban
        isCropland
        isForest
        isSavanna
        isShrubland
        isGrassland
        isBareLand
        isWetland
        isSnowAndIce
        isNoData
        isMixedCropland
        mixedCropland_croplandFactor %mixed cropland
        mixedCropland_grasslandFactor %mixed cropland
        mixedCropland_forestFactor %mixed cropland
        mixedCropland_shrublandFactor %mixed cropland
        
    end
    
    methods
        
        function obj = LandCoverClass(ID,workID, name, isWater, isUrban, isCropland, isForest, isSavanna, isShrubland, isGrassland, isBareLand, isWetland, isSnowAndIce, isNoData, isMixedCropland, croplandFactor, grasslandFactor, forestFactor, shrublandFactor)
            if isnumeric(ID) && mod(ID,1) == 0
            obj.ID = ID;
            end
            if ischar(name)
            obj.name = name;
            end
            if isWater == 1 || isWater == 0
            obj.isWater = isWater;
            end
            if isUrban == 1 || isUrban == 0
                obj.isUrban = isUrban;
            end
            if isCropland == 1 || isCropland == 0
                obj.isCropland = isCropland;
                if isCropland == 1
                   obj.mixedCropland_croplandFactor = 1; 
                end
            end
            if isSavanna == 1 || isSavanna == 0
                obj.isSavanna = isSavanna;
            end
            if isShrubland == 1 || isShrubland == 0
                obj.isShrubland = isShrubland;
            end
            if isGrassland == 1 || isGrassland == 0
                obj.isGrassland = isGrassland;
            end
            if isBareLand == 1 || isBareLand == 0
                obj.isBareLand = isBareLand;
            end
            if isForest == 1 || isForest == 0
                obj.isForest = isForest;
            end
            if isWetland == 1 || isWetland == 0
                obj.isWetland = isWetland;
            end
            if isSnowAndIce == 1 || isSnowAndIce == 0
                obj.isSnowAndIce = isSnowAndIce;
            end
            if isNoData == 0 || isNoData == 1
               obj.isNoData = isNoData; 
            end
            
            obj.workID = workID;
            
            if isMixedCropland == 1 || isMixedCropland == 0
                obj.isMixedCropland = isMixedCropland;
                obj.mixedCropland_croplandFactor = croplandFactor;
                obj.mixedCropland_grasslandFactor = grasslandFactor;
                obj.mixedCropland_forestFactor = forestFactor;
                obj.mixedCropland_shrublandFactor = shrublandFactor;
            end
           
           
           
            
        end
        
    end
    
end

