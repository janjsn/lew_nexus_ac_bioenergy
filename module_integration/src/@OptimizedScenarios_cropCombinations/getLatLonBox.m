function getLatLonBox(obj, regionName, outputFolder, lat_bounds, lon_bounds, latitudeVector_centered, longitudeVector_centered )
%Function to slice a latitude longitude box from Optimized scenarios
%instances.
%05.03.20 Jan Sandstad Næss

%Fix description
if strcmp(obj.ClimateScenario.correspondingRCP_string,' ')
   rcpString = 'Historical';
else
    rcpString = obj.ClimateScenario.correspondingRCP_string;
end

for i = 1:length(rcpString)
   if strcmp(rcpString(i),' ') 
      rcpString(i) = '_'; 
   end
end

description = [regionName '_' num2str(obj.year) '_' rcpString '_'];
if obj.irrigationLevel == 1
   description = [description 'Ir'];
else
    description = [description 'Rf'];
end
if obj.fertilizerLevel == 1
   description = [description '_Lo'];
elseif obj.fertilizerLevel == 2
    description = [description '_Me'];
elseif obj.fertilizerLevel == 3
    description = [description '_Hi'];
end
%% Error check
if lat_bounds(1) > 90 || lat_bounds(2) < -90
   error('Check lat bounds') 
elseif lat_bounds(2) > 90 || lat_bounds(2) < -90
   error('Check lat bounds') 
elseif lon_bounds(1) > 180 || lon_bounds(1) < -180
   error('Check lat bounds') 
elseif lon_bounds(2) > 180 || lon_bounds(2) < -180
   error('Check lat bounds') 
end

%% Sort bounds if needed
if lat_bounds(1)<lat_bounds(2)
   temp = lat_bounds(1);
   lat_bounds(1) = lat_bounds(2);
   lat_bounds(2) = temp;
end

if lon_bounds(1) > lon_bounds(2)
   temp = lon_bounds(1);
   lon_bounds(1) = lon_bounds(2);
   lon_bounds(2) = temp;
end

%% Find positions in longitude and latitude arrays
[lat1,lat1_pos] = min(abs(latitudeVector_centered-lat_bounds(1)));
[lat2,lat2_pos] = min(abs(latitudeVector_centered-lat_bounds(2)));
[lon1,lon1_pos] = min(abs(longitudeVector_centered-lon_bounds(1)));
[lon2,lon2_pos] = min(abs(longitudeVector_centered-lon_bounds(2)));



%Get box data
box_areaMatrix_hectare = obj.identifiedLandMatrix_hectare(lon1_pos:lon2_pos,lat1_pos:lat2_pos);
box_cropIDs = obj.spatialOptimizationMatrix_cropIDs_lhv(lon1_pos:lon2_pos,lat1_pos:lat2_pos);
box_primaryEnergy_MJ = obj.spatialOptimizationMatrix_MJ_perYear_lhv(lon1_pos:lon2_pos,lat1_pos:lat2_pos);
box_primaryEnergy_outsideBH_MJ = obj.excluded_BH_spatialOptimizationMatrix_MJ_perYear_lhv(lon1_pos:lon2_pos,lat1_pos:lat2_pos);

ids = unique(box_cropIDs);



%Print results
fprintf(['Results obtained for region: ' regionName '\n']);
fprintf(['Description: ' description '\n'])
fprintf(['Latitude bounds: ' num2str(latitudeVector_centered(lat1_pos)) ' to ' num2str(latitudeVector_centered(lat2_pos)) '. Longitude bounds: ' num2str(longitudeVector_centered(lon1_pos)) ' to ' num2str(longitudeVector_centered(lon2_pos)) '. \n']) 
fprintf(['Total area:' num2str(sum(sum(box_areaMatrix_hectare))*10^-6) ' Mha' '\n']);
for i = 1:length(ids)
    fprintf(['Total area allocated to crop with ID ' num2str(ids(i)) ':' num2str(sum(sum((box_cropIDs == ids(i)).*box_areaMatrix_hectare))*10^-6) ' Mha' '\n'])
end
fprintf(['Total primary energy prodcution:' num2str(sum(sum(box_primaryEnergy_MJ))*10^-12) ' EJ' '\n']);
fprintf(['Total primary energy production outside biodiversity hotspots:' num2str(sum(sum(box_primaryEnergy_outsideBH_MJ))*10^-12) ' EJ' '\n']);
fprintf('\n')

%% Export2netcdf
export = 1;
if export == 1

lon = longitudeVector_centered(lon1_pos:lon2_pos);
lat = latitudeVector_centered(lat1_pos:lat2_pos);

%Making sure output folder exist
if exist([outputFolder],'dir') ~= 7
    mkdir([outputFolder]);
end

%get time
timestamp = datestr(now, 'yyyy_mm_dd_HHMM');

%Set filename
if strcmp(outputFolder(end),'/')
    filename = [outputFolder description '_' timestamp '.nc'];
else
    filename = [outputFolder '/' description '_' timestamp '.nc'];
end

if exist(filename)
    delete(filename)
end
    

nccreate(filename, 'region', 'Datatype', 'char', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'region', 'standard_name', 'region')
ncwriteatt(filename, 'region', 'long_name', 'region')

nccreate(filename, 'description', 'Datatype', 'char', 'Dimensions', {'dim1', inf})
ncwriteatt(filename, 'description', 'standard_name', 'scenario_description')
ncwriteatt(filename, 'description', 'long_name', 'scenario_description')

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

nccreate(filename, 'year', 'Datatype', 'double')
ncwriteatt(filename, 'year', 'standard_name', 'year')
ncwriteatt(filename, 'year', 'long_name', 'year of analyses')
ncwriteatt(filename, 'year', 'units', '');

nccreate(filename, 'agricultural_input_level', 'Datatype', 'double')
ncwriteatt(filename, 'agricultural_input_level', 'standard_name', 'agricultural_input_level')
ncwriteatt(filename, 'agricultural_input_level', 'long_name', 'agricultural_input_level')
ncwriteatt(filename, 'agricultural_input_level', 'units', '');

nccreate(filename, 'irrigation_level', 'Datatype', 'double')
ncwriteatt(filename, 'irrigation_level', 'standard_name', 'irrigation_level')
ncwriteatt(filename, 'irrigation_level', 'long_name', 'irrigation_level')
ncwriteatt(filename, 'irrigation_level', 'units', '');

nccreate(filename, 'climate_scenario_ID', 'Datatype', 'double')
ncwriteatt(filename, 'climate_scenario_ID', 'standard_name', 'climate_scenario_ID')
ncwriteatt(filename, 'climate_scenario_ID', 'long_name', 'climate_scenario_ID')
ncwriteatt(filename, 'climate_scenario_ID', 'units', '');

nccreate(filename,'identified_land_hectares','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'identified_land_hectares', 'standard_name', 'identified_land_hectares');
ncwriteatt(filename, 'identified_land_hectares', 'long_name', 'identified_land_hectares');
ncwriteatt(filename, 'identified_land_hectares', 'units', '');
ncwriteatt(filename, 'identified_land_hectares', 'missing_value', '-999');

% nccreate(filename,'identified_land_fractions','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
% ncwriteatt(filename, 'identified_land_fractions', 'standard_name', 'identified_land_fractions');
% ncwriteatt(filename, 'identified_land_fractions', 'long_name', 'identified_land_fractions');
% ncwriteatt(filename, 'identified_land_fractions', 'units', '');
% ncwriteatt(filename, 'identified_land_fractions', 'missing_value', '-999');

nccreate(filename,'optimal_crop_ID_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'optimal_crop_ID_lhv', 'standard_name', 'optimal_crop_ID_lhv');
ncwriteatt(filename, 'optimal_crop_ID_lhv', 'long_name', 'optimal_crop_ID_lhv');
ncwriteatt(filename, 'optimal_crop_ID_lhv', 'units', '');
ncwriteatt(filename, 'optimal_crop_ID_lhv', 'missing_value', '-999');

nccreate(filename,'primary_energy_potential_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_potential_lhv', 'standard_name', 'primary_energy_potential_lhv');
ncwriteatt(filename, 'primary_energy_potential_lhv', 'long_name', 'primary_energy_potential_lhv');
ncwriteatt(filename, 'primary_energy_potential_lhv', 'units', 'MJ/year');
ncwriteatt(filename, 'primary_energy_potential_lhv', 'missing_value', '-999');

nccreate(filename,'primary_energy_potential_outside_biodiversity_hotspots_lhv','Dimensions',{'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'primary_energy_potential_outside_biodiversity_hotspots_lhv', 'standard_name', 'primary_energy_potential_outside_biodiversity_hotspots_lhv');
ncwriteatt(filename, 'primary_energy_potential_outside_biodiversity_hotspots_lhv', 'long_name', 'primary_energy_potential_outside_biodiversity_hotspots_lhv');
ncwriteatt(filename, 'primary_energy_potential_outside_biodiversity_hotspots_lhv', 'units', 'MJ/year');
ncwriteatt(filename, 'primary_energy_potential_outside_biodiversity_hotspots_lhv', 'missing_value', '-999');

nccreate(filename, 'total_primary_energy_potential_lhv', 'Datatype', 'double')
ncwriteatt(filename, 'total_primary_energy_potential_lhv', 'standard_name', 'total_primary_energy_potential_lhv')
ncwriteatt(filename, 'total_primary_energy_potential_lhv', 'long_name', 'total_primary_energy_potential_lhv')
ncwriteatt(filename, 'total_primary_energy_potential_lhv', 'units', 'EJ/year');

nccreate(filename, 'total_primary_energy_potential_outside_biodiversity_hotspots_lhv', 'Datatype', 'double')
ncwriteatt(filename, 'total_primary_energy_potential_outside_biodiversity_hotspots_lhv', 'standard_name', 'total_primary_energy_potential_outside_biodiversity_hotspots_lhv')
ncwriteatt(filename, 'total_primary_energy_potential_outside_biodiversity_hotspots_lhv', 'long_name', 'total_primary_energy_potential_outside_biodiversity_hotspots_lhv')
ncwriteatt(filename, 'total_primary_energy_potential_outside_biodiversity_hotspots_lhv', 'units', 'EJ/year');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);
ncwrite(filename, 'region', char(regionName));
ncwrite(filename, 'description', char(description));
ncwrite(filename, 'year', obj.year);
ncwrite(filename, 'agricultural_input_level', obj.fertilizerLevel);
ncwrite(filename, 'irrigation_level', obj.irrigationLevel);
ncwrite(filename, 'climate_scenario_ID', obj.ClimateScenario.ID)
ncwrite(filename, 'identified_land_hectares', box_areaMatrix_hectare);
ncwrite(filename, 'optimal_crop_ID_lhv', box_cropIDs);
ncwrite(filename, 'primary_energy_potential_lhv', box_primaryEnergy_MJ);
ncwrite(filename, 'total_primary_energy_potential_lhv', sum(sum(box_primaryEnergy_MJ))*10^-12);
ncwrite(filename, 'primary_energy_potential_outside_biodiversity_hotspots_lhv', box_primaryEnergy_outsideBH_MJ);
ncwrite(filename, 'total_primary_energy_potential_lhv', sum(sum(box_primaryEnergy_outsideBH_MJ))*10^-12);

end
%box = OptimizedScenarios_cropCombinations;
end

