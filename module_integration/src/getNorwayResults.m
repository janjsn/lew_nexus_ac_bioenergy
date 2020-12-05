% %Script to get Norway results.
% %Run main first.
% 
% abandonedCroplandMatrix_Norway_hectare = importAbandonedCropland_Norway();
% abandonedCroplandMatrix_global_hectare = Model(1).identifiedLandMatrix_hectares;
% 
% 
% 
% Norway = CountrySpecificResults;
% Norway.Administrative_centers = importAdministrativeCenters();
% Norway.countryName = 'Norway';
% Norway.year = 2020;
% Norway.climate = 'Present';
% Norway.identifiedLandMatrix_hectare = abandonedCroplandMatrix_Norway_hectare;
% 
% binary_isNorway = (abandonedCroplandMatrix_Norway_hectare > 0);
% 
% Norway.bioenergyPotentialMatrix_rainfed_high_MJ = zeros(4320,2160);
% Norway.bioenergyPotentialMatrix_irrigated_high_MJ = zeros(4320,2160);
% Norway.bioenergyPotentialMatrix_mixed_high_MJ = zeros(4320,2160);
% Norway.bioenergyYields_rainfed_GJ_perHa = zeros(4320,2160);
% Norway.bioenergyYields_irrigated_GJ_perHa = zeros(4320,2160);
% 
% 
% for i = 1:length(Model(1).WaterScarcity_scenarioArray) 
%     
%    if  Model(1).WaterScarcity_scenarioArray(i).identificationVector == idVector
%        Norway.bioenergyPotentialMatrix_rainfed_high_MJ(binary_isNorway) =  (Model(1).WaterScarcity_scenarioArray(i).primaryEnergyProductionMatrix_rainfed(binary_isNorway));
%        Norway.bioenergyPotentialMatrix_irrigated_high_MJ(binary_isNorway) =  (Model(1).WaterScarcity_scenarioArray(i).primaryEnergyProductionMatrix_irrigated(binary_isNorway));
%        Norway.bioenergyPotentialMatrix_mixed_high_MJ(Model(1).WaterScarcity_scenarioArray(i).irrigation_binaryMatrix) =  Norway.bioenergyPotentialMatrix_irrigated_high_MJ(Model(1).WaterScarcity_scenarioArray(i).irrigation_binaryMatrix);
%        Norway.bioenergyPotentialMatrix_mixed_high_MJ(~Model(1).WaterScarcity_scenarioArray(i).irrigation_binaryMatrix) =  Norway.bioenergyPotentialMatrix_rainfed_high_MJ(~Model(1).WaterScarcity_scenarioArray(i).irrigation_binaryMatrix);
%        
%        Norway.bioenergyYields_rainfed_GJ_perHa(binary_isNorway) = 10^-3*Norway.bioenergyPotentialMatrix_rainfed_high_MJ(binary_isNorway)./Norway.identifiedLandMatrix_hectare(binary_isNorway);
%        Norway.bioenergyYields_irrigated_GJ_perHa(binary_isNorway) = 10^-3*Norway.bioenergyPotentialMatrix_irrigated_high_MJ(binary_isNorway)./Norway.identifiedLandMatrix_hectare(binary_isNorway);
%        
%    end
% end
% 
% lat = Model.identifiedLand_latitudeVector_centered;
% lon = Model.identifiedLand_longitudeVector_centered;
% 
% %Distribute land and potentials to adminsitrative centers
% c=0;
% for n_lon = 1:length(lon)
%     for n_lat = 1:length(lat)
%         if binary_isNorway(n_lon,n_lat)
%             
%             
%             %Find closest administrative center
%             distanceFromAdminCenters = zeros(1,length(Norway.Administrative_centers));
%             
%             lat_coordinate = lat(n_lat);
%             lon_coordinate = lon(n_lon);
%             
%             for n_admins = 1:length(distanceFromAdminCenters)
%                distanceFromAdminCenters(n_admins) = sqrt((lat_coordinate-Norway.Administrative_centers(n_admins).latitudeCoordinate)^2+(lon_coordinate-Norway.Administrative_centers(n_admins).longitudeCoordinate)^2);
%             end
%             
%             [val,idx] = min(distanceFromAdminCenters);
%             
%             Norway.Administrative_centers(idx).abandonedCropland_hectare = Norway.Administrative_centers(idx).abandonedCropland_hectare + Norway.identifiedLandMatrix_hectare(n_lon,n_lat);
%             Norway.Administrative_centers(idx).bioenergyPotential_high_rainfed_TJ = Norway.Administrative_centers(idx).bioenergyPotential_high_rainfed_TJ + Norway.bioenergyPotentialMatrix_rainfed_high_MJ(n_lon, n_lat)*10^-6;
%             Norway.Administrative_centers(idx).bioenergyPotential_high_irrigated_TJ = Norway.Administrative_centers(idx).bioenergyPotential_high_irrigated_TJ + Norway.bioenergyPotentialMatrix_irrigated_high_MJ(n_lon,n_lat)*10^-6;
%         end
%     end
% end
% 
% for i = 1:length(Norway.Administrative_centers)
%     if Norway.Administrative_centers(i).abandonedCropland_hectare > 0
%         Norway.Administrative_centers(i).meanBioenergyYield_high_rainfed_GJ_perHa = 10^3*Norway.Administrative_centers(i).bioenergyPotential_high_rainfed_TJ/Norway.Administrative_centers(i).abandonedCropland_hectare;
%         Norway.Administrative_centers(i).meanBioenergyYield_high_irrigated_GJ_perHa = 10^3*Norway.Administrative_centers(i).bioenergyPotential_high_irrigated_TJ/Norway.Administrative_centers(i).abandonedCropland_hectare;
%     end
% end


data_NOR = cell(length(Norway.Administrative_centers)+1,11);
data_NOR(1,:) = {'ID','Name','Region','Country','Longitude','Latitude','Abandoned cropland (Ha)', 'Rainfed bioenergy potential (TJ)', 'Irrigated bioenergy potential (TJ)', 'Mean rainfed bioenergy yield (GJ ha-1)', 'Mean irrigated bioenergy yield (GJ ha-1)'} ;

for i = 1:length(Norway.Administrative_centers)
   data_NOR{i+1,1} = Norway.Administrative_centers(i).ID;
   data_NOR{i+1,2} = Norway.Administrative_centers(i).name;
   data_NOR{i+1,3} = Norway.Administrative_centers(i).region;
   data_NOR{i+1,4} = Norway.Administrative_centers(i).country;
   data_NOR{i+1,5} = Norway.Administrative_centers(i).longitudeCoordinate;
   data_NOR{i+1,6} = Norway.Administrative_centers(i).latitudeCoordinate;
   data_NOR{i+1,7} = Norway.Administrative_centers(i).abandonedCropland_hectare;
   data_NOR{i+1,8} = Norway.Administrative_centers(i).bioenergyPotential_high_rainfed_TJ;
   data_NOR{i+1,9} = Norway.Administrative_centers(i).bioenergyPotential_high_irrigated_TJ;
   data_NOR{i+1,10} = Norway.Administrative_centers(i).meanBioenergyYield_high_rainfed_GJ_perHa;
   data_NOR{i+1,11} = Norway.Administrative_centers(i).meanBioenergyYield_high_irrigated_GJ_perHa;
end

save('Norwegian bioenergy potentials on abandoned cropland after administrative centers.mat', 'data_NOR')

%Export results
exportResults = 0;
if exportResults == 1
timestamp = datestr(now, 'yyyy_mm_dd_HHMM');
filename = ['Bioenergy_potentials_on_abandoned_cropland_Norway_1992_2018_5arcmin_' timestamp '.nc'];

nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename, 'lat', 'long_name', 'latitude');
ncwriteatt(filename, 'lat', 'units', 'degrees_north');
ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
ncwriteatt(filename, 'lat', 'axis', 'Y'); %ADDED 1306

nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees_east');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename, 'lon', 'axis', 'X'); %ADDED 1306

nccreate(filename, 'abandoned_cropland_hectare', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'abandoned_cropland_hectare', 'standard_name', 'abandoned_cropland_hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'long_name', 'abandoned_cropland_1992_2018_hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'units', 'hectare');
ncwriteatt(filename, 'abandoned_cropland_hectare', 'missing_value', '-999');

nccreate(filename, 'bioenergy_potential_rainfed_TJ', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_potential_rainfed_TJ', 'standard_name', 'bioenergy_potential_rainfed_TJ');
ncwriteatt(filename, 'bioenergy_potential_rainfed_TJ', 'long_name', 'bioenergy_potential_rainfed_TJ');
ncwriteatt(filename, 'bioenergy_potential_rainfed_TJ', 'units', 'TJ');
ncwriteatt(filename, 'bioenergy_potential_rainfed_TJ', 'missing_value', '-999');

nccreate(filename, 'bioenergy_potential_irrigated_TJ', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_potential_irrigated_TJ', 'standard_name', 'bioenergy_potential_irrigated_TJ');
ncwriteatt(filename, 'bioenergy_potential_irrigated_TJ', 'long_name', 'bioenergy_potential_irrigated_TJ');
ncwriteatt(filename, 'bioenergy_potential_irrigated_TJ', 'units', 'TJ');
ncwriteatt(filename, 'bioenergy_potential_irrigated_TJ', 'missing_value', '-999');

nccreate(filename, 'bioenergy_potential_mixed_TJ', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_potential_mixed_TJ', 'standard_name', 'bioenergy_potential_mixed_TJ');
ncwriteatt(filename, 'bioenergy_potential_mixed_TJ', 'long_name', 'bioenergy_potential_mixed_TJ');
ncwriteatt(filename, 'bioenergy_potential_mixed_TJ', 'units', 'TJ');
ncwriteatt(filename, 'bioenergy_potential_mixed_TJ', 'missing_value', '-999');

nccreate(filename, 'bioenergy_yields_rainfed', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_yields_rainfed', 'standard_name', 'bioenergy_yields_rainfed');
ncwriteatt(filename, 'bioenergy_yields_rainfed', 'long_name', 'bioenergy_yields_rainfed');
ncwriteatt(filename, 'bioenergy_yields_rainfed', 'units', 'GJ ha-1');
ncwriteatt(filename, 'bioenergy_yields_rainfed', 'missing_value', '-999');

nccreate(filename, 'bioenergy_yields_irrigated', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'bioenergy_yields_irrigated', 'standard_name', 'bioenergy_yields_irrigated');
ncwriteatt(filename, 'bioenergy_yields_irrigated', 'long_name', 'bioenergy_yields_irrigated');
ncwriteatt(filename, 'bioenergy_yields_irrigated', 'units', 'GJ ha-1');
ncwriteatt(filename, 'bioenergy_yields_irrigated', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
abandonedCropland = Norway.identifiedLandMatrix_hectare;
abandonedCropland(abandonedCropland == 0) = -999;
ncwrite(filename, 'abandoned_cropland_hectare', abandonedCropland);
%Bioenergy potentials
bioenergyPotential_rainfed_TJ = Norway.bioenergyPotentialMatrix_rainfed_high_MJ*10^-6;
bioenergyPotential_rainfed_TJ(bioenergyPotential_rainfed_TJ == 0) = -999;
ncwrite(filename, 'bioenergy_potential_rainfed_TJ', bioenergyPotential_rainfed_TJ)
bioenergyPotential_irrigated_TJ = Norway.bioenergyPotentialMatrix_irrigated_high_MJ*10^-6;
bioenergyPotential_irrigated_TJ(bioenergyPotential_irrigated_TJ == 0) = -999;
ncwrite(filename, 'bioenergy_potential_irrigated_TJ', bioenergyPotential_irrigated_TJ)
bioenergyPotential_mixed_TJ = Norway.bioenergyPotentialMatrix_mixed_high_MJ*10^-6;
bioenergyPotential_mixed_TJ(bioenergyPotential_mixed_TJ == 0) = -999;
ncwrite(filename, 'bioenergy_potential_mixed_TJ', bioenergyPotential_mixed_TJ);
%Bioenergy yields
bioenergyYields_rainfed_GJ_perHa = Norway.bioenergyYields_rainfed_GJ_perHa;
bioenergyYields_rainfed_GJ_perHa(bioenergyYields_rainfed_GJ_perHa == 0) = -999;
ncwrite(filename, 'bioenergy_yields_rainfed', bioenergyYields_rainfed_GJ_perHa)
bioenergyYields_irrigated_GJ_perHa = Norway.bioenergyYields_irrigated_GJ_perHa;
bioenergyYields_irrigated_GJ_perHa(bioenergyYields_irrigated_GJ_perHa == 0) = -999;
ncwrite(filename, 'bioenergy_yields_irrigated', bioenergyYields_irrigated_GJ_perHa)
end


