classdef GAEZ_data_aggregated
    %GAEZ_DATA_AGGREGATED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        description
        latitudeVector_centered
        longitudeVector_centered
        latitudeBounds
        longitudeBounds
        
        biodiversityHotspots_fractions
        
        identifiedLandMatrix_hectare
        identifiedLandMatrix_fractions
        identifiedLand_productionMatrix_tonPerYear
        identifiedLand_energyProductionMatrix_lhv_MJ_perYear
        identifiedLand_energyProductionMatrix_lhv_PJ_perYear
        
        identifiedLandMatrix_excludedBH_hectare
        identifiedLandMatrix_excludedBH_fractions
        identifiedLand_productionMatrix_excludedBH_tonPerYear
        identifiedLand_energyProductionMatrix_lhv_excludedBH_MJ_perYear
        identifiedLand_energyProductionMatrix_lhv_excludedBH_PJ_perYear
        
        
    end
    
    methods
        
        function obj = GAEZ_data_aggregated(GAEZ_data_instance, n_lon, n_lat)
           %Aggregates data based on center of grid cell.
           %Assumes equirectangular projection
            
            
            %% AGGREGATING
           
           
           lat_step  = 180/n_lat;
           lon_step = 360/n_lon;
           obj.latitudeVector_centered = [90-(lat_step/2):-lat_step:-90+(lat_step/2)];
           obj.longitudeVector_centered = [-180+(lon_step/2):lon_step:180-(lon_step/2)];
           
           %Bounds
           obj.latitudeBounds = zeros(2,n_lat);
           obj.longitudeBounds = zeros(2,n_lon);
           obj.latitudeBounds(1,1:end) = [90:-lat_step:-90+lat_step];
           obj.latitudeBounds(2,1:end) = [90-lat_step:-lat_step:-90];
           obj.longitudeBounds(1,1:end) = [-180:lon_step:180-lon_step];
           obj.longitudeBounds(2,1:end) = [-180+lon_step:lon_step:180];
           
           %Aggregating values
           obj.identifiedLandMatrix_hectare = obj.aggregateMatrixToGivenDimensions(GAEZ_data_instance.areaMatrix_identifiedLand_ha, GAEZ_data_instance.longitudeVector_centered, GAEZ_data_instance.latitudeVector_centered);
           obj.identifiedLand_productionMatrix_tonPerYear = obj.aggregateMatrixToGivenDimensions(GAEZ_data_instance.cropYield_identifiedLands_tonsPerYear, GAEZ_data_instance.longitudeVector_centered, GAEZ_data_instance.latitudeVector_centered);
           obj.identifiedLand_energyProductionMatrix_lhv_MJ_perYear = obj.aggregateMatrixToGivenDimensions(GAEZ_data_instance.primaryEnergyOutput_spatial_lhv_MJ_perYear, GAEZ_data_instance.longitudeVector_centered, GAEZ_data_instance.latitudeVector_centered);
           obj.identifiedLand_energyProductionMatrix_lhv_PJ_perYear = (10^-9)*obj.identifiedLand_energyProductionMatrix_lhv_MJ_perYear;
           
           obj.identifiedLandMatrix_excludedBH_hectare = obj.aggregateMatrixToGivenDimensions(GAEZ_data_instance.areaMatrix_excludingBiodiversityHotspots_identifiedLand_ha, GAEZ_data_instance.longitudeVector_centered, GAEZ_data_instance.latitudeVector_centered);
           obj.identifiedLand_productionMatrix_excludedBH_tonPerYear = obj.aggregateMatrixToGivenDimensions(GAEZ_data_instance.cropYield_identifiedLands_tonsPerYear, GAEZ_data_instance.longitudeVector_centered, GAEZ_data_instance.latitudeVector_centered);
           obj.identifiedLand_energyProductionMatrix_lhv_excludedBH_MJ_perYear = obj.aggregateMatrixToGivenDimensions(GAEZ_data_instance.primaryEnergyOutput_spatial_lhv_MJ_perYear, GAEZ_data_instance.longitudeVector_centered, GAEZ_data_instance.latitudeVector_centered);
           obj.identifiedLand_energyProductionMatrix_lhv_excludedBH_PJ_perYear = (10^-9)*obj.identifiedLand_energyProductionMatrix_lhv_excludedBH_MJ_perYear;
            
           
           
           %obj.biodiversityHotspots_fractions = obj.aggregateMatrixToGivenDimensions(GAEZ_data_instance.fractionsMatrix_biodiversityHotspots_oneIsAllHotspot_zeroIsNone.*, GAEZ_data_instance.longitudeVector_centered, GAEZ_data_instance.latitudeVector_centered);
           
           %Finding fractions of total area per cell 
           %Calculating area per lat
           earthEllipsoid = referenceSphere('earth','km');
           areaPerLatitudeVector_km2 = zeros(1,n_lat);
           for i = 1:n_lat
               areaPerLatitudeVector_km2(i) = areaquad(obj.latitudeBounds(1,i),obj.longitudeBounds(1,1),obj.latitudeBounds(2,i),obj.longitudeBounds(2,1), earthEllipsoid);
           end
           
           areaPerLatitudeVector_hectare = areaPerLatitudeVector_km2.*100;
           
           %Calculating fractions
           identifiedLandMatrix_fractions = zeros(n_lon, n_lat);
           identifiedLandMatrix_excludedBH_fractions = identifiedLandMatrix_fractions;
           for i = 1:n_lat
               identifiedLandMatrix_fractions(:,i) = obj.identifiedLandMatrix_hectare(:,i)./areaPerLatitudeVector_hectare(i);
               identifiedLandMatrix_excludedBH_fractions(:,i) = obj.identifiedLandMatrix_excludedBH_hectare(:,i)./areaPerLatitudeVector_hectare(i);
           end
           
           obj.identifiedLandMatrix_fractions = identifiedLandMatrix_fractions;
           obj.identifiedLandMatrix_excludedBH_fractions = identifiedLandMatrix_excludedBH_fractions;
           
           %Getting total biodiversity hotspots area
           areaPerLatitude_diagMatrix = diag(GAEZ_data_instance.areaPerLatitudeVector_hectare);
           
           %areaMatrix_hotspots_hectare = GAEZ_data_instance.fractionsMatrix_biodiversityHotspots_oneIsAllHotspot_zeroIsNone*areaPerLatitude_diagMatrix;
           
           mSize_old = size(GAEZ_data_instance.fractionsMatrix_biodiversityHotspots_oneIsAllHotspot_zeroIsNone);
           old_areaMatrix_hotspots_hectare = zeros(mSize_old(1),mSize_old(2));
           
           %size(GAEZ_data_instance.areaPerLatitudeVector_hectare)
           
           for i = 1:mSize_old(2)
              old_areaMatrix_hotspots_hectare(:,i) =  GAEZ_data_instance.fractionsMatrix_biodiversityHotspots_oneIsAllHotspot_zeroIsNone(:,i).*GAEZ_data_instance.areaPerLatitudeVector_hectare(i);
           end
           
           %sum(sum(old_areaMatrix_hotspots_hectare))
           aggregated_hotpots_hectare = obj.aggregateMatrixToGivenDimensions(old_areaMatrix_hotspots_hectare, GAEZ_data_instance.longitudeVector_centered, GAEZ_data_instance.latitudeVector_centered);
           obj.biodiversityHotspots_fractions = zeros(n_lon,n_lat);
           for i = 1:n_lat
               obj.biodiversityHotspots_fractions(:,i) = aggregated_hotpots_hectare(:,i)./areaPerLatitudeVector_hectare(i);
           end
           
        end
        
        function aggregated_matrix = aggregateMatrixToGivenDimensions(obj, old_matrix, old_longitudeVector_centered, old_latitudeVector_centered)
            %tic
            old_mSize = size(old_matrix);
           
            if old_mSize(1) ~= length(old_longitudeVector_centered) || old_mSize(2) ~=length(old_latitudeVector_centered)
               error('Dimensions of old matrix and old lat/lon vector not matching. Check input.') 
            end
            
            new_nLat = length(obj.latitudeVector_centered);
            new_nLon = length(obj.longitudeVector_centered);
            aggregated_matrix = zeros(new_nLon, new_nLat);
            new_latitudeBounds = obj.latitudeBounds;
            new_longitudeBounds = obj.longitudeBounds;
            pos_newLon = 0;
            
            %old_binaryMatrix_differentFromZero = old_matrix ~= 0;
            
            for old_lon = 1:old_mSize(1)
                for new_lon = 1:new_nLon
                    if old_longitudeVector_centered(old_lon) > new_longitudeBounds(1,new_lon) && old_longitudeVector_centered(old_lon) <= new_longitudeBounds(2,new_lon)
                        pos_newLon = (new_lon);
                        
                        for old_lat = 1:old_mSize(2)
                            %Taking only elements different from zero.
                            if old_matrix(old_lon,old_lat) ~=0
                                for new_lat = 1:new_nLat
                                    if old_latitudeVector_centered(old_lat) < new_latitudeBounds(1,new_lat) && old_latitudeVector_centered(old_lat) >= new_latitudeBounds(2,new_lat)
                                        pos_newLat = (new_lat);
                                        
                                        
                                        
                                        aggregated_matrix(pos_newLon, pos_newLat) = aggregated_matrix(pos_newLon, pos_newLat)+ old_matrix(old_lon,old_lat);
                                    end
                                end
                            end
                            
                        end
                    end
                    pos_newLon = 0;
                end
            end
            %toc
            
        end %function aggregateMatrixToGivenDimensions
        
        function aggregated_matrix = aggregateMatrixToGivenDimensions_v2(obj, old_matrix, old_longitudeVector_centered, old_latitudeVector_centered)
            old_mSize = size(old_matrix);
           
            if old_mSize(1) ~= length(old_longitudeVector_centered) || old_mSize(2) ~=length(old_latitudeVector_centered)
               error('Dimensions of old matrix and old lat/lon vector not matching. Check input.') 
            end
            
            new_nLat = length(obj.latitudeVector_centered);
            new_nLon = length(obj.longitudeVector_centered);
            aggregated_matrix = zeros(new_nLon, new_nLat);
            new_latitudeBounds = obj.latitudeBounds;
            new_longitudeBounds = obj.longitudeBounds;
            
            
            longitudePositionsInOldMatrixForGivenCell_firstAndNew = zeros(new_nLon,2);
            
            for new_lon = 1:new_nLon
                currentPos = 0;
               for old_lon = 1:old_mSize(1)
                   if old_longitudeVector_centered(old_lon) > new_longitudeBounds(1,new_lon) && old_longitudeVector_centered(old_lon) <= new_longitudeBounds(2,new_lon)
                       currentPos = 0;
                   end
               end
            end
            
            
            
        end
    end
    
end

