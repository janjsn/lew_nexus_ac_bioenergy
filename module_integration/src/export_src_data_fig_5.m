function export_src_data_fig_5( Aggregated_results_medium_intensity, Aggregated_results_high_intensity )
%EXPORT_SRC_DATA_FIG_5 Summary of this function goes here
%   Detailed explanation goes here

filename = 'Output/source_data_figure_5_a_b_c_d.nc';

if exist(filename) == 2
    delete(filename)
end

lat = Aggregated_results_medium_intensity.latitudeVector_centered;
lon = Aggregated_results_medium_intensity.longitudeVector_centered;

nccreate(filename,'lat','Dimensions',{'lat' length(lat)});
ncwriteatt(filename, 'lat', 'standard_name', 'latitude');
ncwriteatt(filename, 'lat', 'long_name', 'latitude');
ncwriteatt(filename, 'lat', 'units', 'degrees_north');
ncwriteatt(filename, 'lat', '_CoordinateAxisType', 'Lat');
ncwriteatt(filename, 'lat', 'axis', 'Y'); 

nccreate(filename,'lon','Dimensions',{'lon' length(lon)});
ncwriteatt(filename, 'lon', 'standard_name', 'longitude');
ncwriteatt(filename, 'lon', 'long_name', 'longitude');
ncwriteatt(filename, 'lon', 'units', 'degrees_east');
ncwriteatt(filename, 'lon', '_CoordinateAxisType', 'Lon');
ncwriteatt(filename, 'lon', 'axis', 'X'); 

%Primary energy gain of full irrigation deployment
nccreate(filename, 'total_energy_gain_medium_management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'total_energy_gain_medium_management_intensity', 'standard_name', 'Primary energy gain of full irrigation deployment at medium management intensity');
ncwriteatt(filename, 'total_energy_gain_medium_management_intensity', 'long_name', 'Primary energy gain of full irrigation deployment at medium management intensity');
ncwriteatt(filename, 'total_energy_gain_medium_management_intensity', 'units', 'PJ yr-1');
ncwriteatt(filename, 'total_energy_gain_medium_management_intensity', 'missing_value', '-999');

nccreate(filename, 'total_energy_gain_high_management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'total_energy_gain_high_management_intensity', 'standard_name', 'Primary energy gain of full irrigation deployment at high management intensity');
ncwriteatt(filename, 'total_energy_gain_high_management_intensity', 'long_name', 'Primary energy gain of full irrigation deployment at high management intensity');
ncwriteatt(filename, 'total_energy_gain_high_management_intensity', 'units', 'PJ yr-1');
ncwriteatt(filename, 'total_energy_gain_high_management_intensity', 'missing_value', '-999');


%energy yield gain per irrigation unit GJ/ha*mm
nccreate(filename, 'marginal_energy_gain_of_irrigation_medium_management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'marginal_energy_gain_of_irrigation_medium_management_intensity', 'standard_name', 'Marginal energy gain of irrigation at medium management intensity');
ncwriteatt(filename, 'marginal_energy_gain_of_irrigation_medium_management_intensity', 'long_name', 'Marginal energy gain of irrigation at medium management intensity');
ncwriteatt(filename, 'marginal_energy_gain_of_irrigation_medium_management_intensity', 'units', 'GJ ha-1 mm-1 yr-1');
ncwriteatt(filename, 'marginal_energy_gain_of_irrigation_medium_management_intensity', 'missing_value', '-999');

nccreate(filename, 'marginal_energy_gain_of_irrigation_high_management_intensity', 'Dimensions', {'lon' length(lon) 'lat' length(lat)}, 'DeflateLevel', 4);
ncwriteatt(filename, 'marginal_energy_gain_of_irrigation_high_management_intensity', 'standard_name', 'Marginal energy gain of irrigation at high management intensity');
ncwriteatt(filename, 'marginal_energy_gain_of_irrigation_high_management_intensity', 'long_name', 'Marginal energy gain of irrigation at high management intensity');
ncwriteatt(filename, 'marginal_energy_gain_of_irrigation_high_management_intensity', 'units', 'GJ ha-1 mm-1 yr-1');
ncwriteatt(filename, 'marginal_energy_gain_of_irrigation_high_management_intensity', 'missing_value', '-999');

ncwrite(filename, 'lat', lat);
ncwrite(filename, 'lon', lon);

medium_tot_energy_gain = Aggregated_results_medium_intensity.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-9;
high_tot_energy_gain = Aggregated_results_high_intensity.deltaPrimaryEnergy_lhv_ir_rf_MJ_perYear*10^-9;

medium_marginal_energy_gain = Aggregated_results_medium_intensity.energyYieldGainPerIrrigation_GJ_perHaMm;
high_marginal_energy_gain = Aggregated_results_high_intensity.energyYieldGainPerIrrigation_GJ_perHaMm;

ncwrite(filename, 'total_energy_gain_medium_management_intensity', medium_tot_energy_gain);
ncwrite(filename, 'total_energy_gain_high_management_intensity', high_tot_energy_gain);
ncwrite(filename, 'marginal_energy_gain_of_irrigation_medium_management_intensity', medium_marginal_energy_gain);
ncwrite(filename, 'marginal_energy_gain_of_irrigation_high_management_intensity', high_marginal_energy_gain);

end

