%% CODE TO COMPARE COUNTRY LEVEL CROPLAND EXTENT WITH FAO INVENTORY 
%Run this script only, with all classes/functions as attached.

%Relies on: 
% 1. custom produced code and gridded CCI cropland extent netcdfs (hectares) 
% 2. GPW-v4 national identifier grid 
% 3. FAO inventories providing country land use as %, Excels
% 4. Equal country names from GPW and FAO. 

% Note that a few countries are not catched by the code (< 10%).
% Produces results to memory and graphs to ".gif" for all countries with 
% similar name in both sources. Results includes linear regressions.

%20.08.2020 - Jan Sandstad Næss


%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Add paths
addpath(genpath(pwd()))


%Import country masks
[countryMasks_30arcsec, GeoInfo_countryMask] = getCountryMasks_gpw('Data/gpw-v4-national-identifier-grid-rev11_30_sec_tif/gpw_v4_national_identifier_grid_rev11_30_sec.tif');
fprintf('got')
countryMasks_30arcsec = countryMasks_30arcsec';

%Get country masks IDs from XLS
CountryArray = getCountryMaskIDs( 'Data/gpw-v4-national-identifier-grid-rev11_30_sec_tif/gpw-v4-country-level-summary-rev11.xlsx', 'GPWv4 Rev11 Summary' );
%Get FAO data
CountryArray = get_FAO_data('Data/FAOSTAT_data_6-30-2020.xlsx', CountryArray);
CountryArray = get_FAO_data_croplands('Data/FAOSTAT_data_croplands_7-1-2020.xlsx', CountryArray);
%Open CCI cropland data
ncid_1992 = netcdf.open('Data/Croplands_Global_1992_30arcsec_timestamp_2020_06_30_1636.nc');
ncid_2015 = netcdf.open('Data/Croplands_Global_2015_30arcsec_timestamp_2020_07_01_0040.nc');
%Get hectares gridded
cci_croplands_1992_hectare = netcdf.getVar(ncid_1992, 3);
cci_croplands_2015_hectare = netcdf.getVar(ncid_2015, 3);
%Get area per latitude, hectares
areaPerLatitude_hectare = netcdf.getVar(ncid_1992,2);

%Close netcdf
netcdf.close(ncid_1992);
netcdf.close(ncid_2015);

%% Get country values
fprintf('Getting country values');
%loop through countries
for countries = 1:length(CountryArray)
    %print current country name
    fprintf(CountryArray(countries).country_name)
    fprintf(': \n');
    %Get 1992 country cropland extent
    CountryArray(countries).CCI_cropland_1992_hectare = sum(sum(cci_croplands_1992_hectare(countryMasks_30arcsec == CountryArray(countries).GPW_country_ISO_numeric)));
    fprintf(['1992 cropland hectare: ' num2str(CountryArray(countries).CCI_cropland_1992_hectare) '\n']) %print
    %Get 2015 country cropland extent
    CountryArray(countries).CCI_cropland_2015_hectare = sum(sum(cci_croplands_2015_hectare(countryMasks_30arcsec == CountryArray(countries).GPW_country_ISO_numeric)));
    fprintf(['2015 cropland hectare: ' num2str(CountryArray(countries).CCI_cropland_2015_hectare) '\n']) %print
    %Calculate total land area of country
    CountryArray(countries).CCI_total_land_area = 0;
    %Sum by latitude
    for n_lat = 1:length(areaPerLatitude_hectare)
        CountryArray(countries).CCI_total_land_area = CountryArray(countries).CCI_total_land_area + sum((countryMasks_30arcsec(:,n_lat) == CountryArray(countries).GPW_country_ISO_numeric)*areaPerLatitude_hectare(n_lat));
    end
    fprintf(['Total area of country: ' num2str(CountryArray(countries).CCI_total_land_area) '\n']) %print
    
end
%FAO loop through countries
for countries = 1:length(CountryArray)
    if CountryArray(countries).FAO_country_ID ~= -999 %Check if FAO had data for same name
        %If data available, calculate FAO cropland based on share of land
        %area
        if ~isempty(CountryArray(countries).FAO_cropland_1992_share_of_land_area)
            CountryArray(countries).FAO_cropland_1992_hectare = CountryArray(countries).CCI_total_land_area*CountryArray(countries).FAO_cropland_1992_share_of_land_area/100;
        end
        if ~isempty(CountryArray(countries).FAO_cropland_2015_share_of_land_area)
            CountryArray(countries).FAO_cropland_2015_hectare = CountryArray(countries).CCI_total_land_area*CountryArray(countries).FAO_cropland_2015_share_of_land_area/100;
        end
        if ~isempty(CountryArray(countries).FAO_agriculture_1992_share_of_land_area)
            CountryArray(countries).FAO_agriculture_1992_hectare = CountryArray(countries).CCI_total_land_area*CountryArray(countries).FAO_agriculture_1992_share_of_land_area/100;
        end
        if ~isempty(CountryArray(countries).FAO_agriculture_2015_share_of_land_area)
            CountryArray(countries).FAO_agriculture_2015_hectare = CountryArray(countries).CCI_total_land_area*CountryArray(countries).FAO_agriculture_2015_share_of_land_area/100;
        end
    end
end

%% Find which countries had data and create binary vectors
binary_vec_1992 = zeros(1,length(CountryArray));
binary_vec_2015 = zeros(1,length(CountryArray));
binary_vec__agr_1992 = zeros(1,length(CountryArray));
binary_vec_agr_2015 = zeros(1,length(CountryArray));

for i = 1:length(CountryArray)

    
    if ~isempty(CountryArray(i).FAO_cropland_1992_share_of_land_area)
        binary_vec_1992(i) = 1;
        if CountryArray(i).FAO_cropland_1992_share_of_land_area == 0 || CountryArray(i).CCI_cropland_1992_hectare == 0
            binary_vec_1992(i) = 0;
        end
    end
    if ~isempty(CountryArray(i).FAO_cropland_2015_share_of_land_area)
        binary_vec_2015(i) = 1;
        if CountryArray(i).FAO_cropland_2015_share_of_land_area == 0 || CountryArray(i).CCI_cropland_2015_hectare == 0
         binary_vec_2015(i) = 0;
        end
    end
    
    if ~isempty(CountryArray(i).FAO_agriculture_2015_share_of_land_area)
        binary_vec_agr_2015(i) = 1;
        if CountryArray(i).FAO_agriculture_2015_share_of_land_area == 0 || CountryArray(i).CCI_cropland_2015_hectare == 0
            binary_vec_agr_2015(i) = 0;
        end
    end
    
    if ~isempty(CountryArray(i).FAO_agriculture_1992_share_of_land_area)
        binary_vec_agr_1992(i) = 1;
        if CountryArray(i).FAO_agriculture_1992_share_of_land_area == 0 || CountryArray(i).CCI_cropland_1992_hectare == 0
            binary_vec_agr_1992(i) = 0;
        end
    end
end

%% Get vectors of cropland extent for 1992 and 2015 for CCI and FAO
hectare_cci_1992  = [CountryArray(binary_vec_1992 == 1).CCI_cropland_1992_hectare];
hectare_cci_2015  = [CountryArray(binary_vec_2015== 1).CCI_cropland_2015_hectare];
hectare_fao_1992 =  [CountryArray(binary_vec_1992== 1).FAO_cropland_1992_hectare];
hectare_fao_2015 =  [CountryArray(binary_vec_2015== 1).FAO_cropland_2015_hectare];
hectare_fao_agr_1992 =  [CountryArray(binary_vec_1992== 1).FAO_agriculture_1992_hectare];
hectare_fao_agr_2015 =  [CountryArray(binary_vec_2015== 1).FAO_agriculture_2015_hectare];

%% PLOT FIGURES

%%%%%% 1992, FAO cropland
fig1 = figure;
mdl = fitlm(log10(hectare_fao_1992),log10(hectare_cci_1992));
mdl.Rsquared.Ordinary
mdl.Rsquared.Adjusted
mdl
scatter(log10(hectare_fao_1992),log10(hectare_cci_1992), 'o');
hold on
plot([0 10], [0 10])

min_x = min(log10(hectare_fao_1992));
max_x = max(log10(hectare_fao_1992));

y_predict = mdl.predict([min_x 
    max_x]);
plot([min_x max_x], y_predict,'LineStyle', '--', 'Color', 'k', 'LineWidth',1.2)

xlabel('FAO log10([hectare])')
ylabel('CCI log10([hectare])')
xlim([0 10])
ylim([0 10])
set(gca,'XTick',[0:1:10]);
set(gca,'YTick',[0:1:10]);
%legend('Cropland extent', '1:1 line', 'Linear regression', 'Location', 'NorthWest')
hold off
saveas(fig1, 'Output/1992 cropland FAO vs CCI.tif')

%%%%% 2015 FAO cropland
fig2 = figure;
mdl2 = fitlm(log10(hectare_fao_2015),log10(hectare_cci_2015));
mdl2.Rsquared.Ordinary
mdl2.Rsquared.Adjusted
mdl2
scatter(log10(hectare_fao_2015),log10(hectare_cci_2015));
xlabel('FAO log10([hectare])')
ylabel('CCI log10([hectare])')
hold on 
%1:1
plot([0 10], [0 10])
%Regression
min_x = min(log10(hectare_fao_2015));
max_x = max(log10(hectare_fao_2015));
y_predict = mdl2.predict([min_x 
    max_x]);
plot([min_x max_x], y_predict,'LineStyle', '--', 'Color', 'k', 'LineWidth',1.2)

xlim([0 10])
ylim([0 10])
set(gca,'XTick',[0:1:10]);
set(gca,'YTick',[0:1:10]);
%legend('Cropland extent', '1:1 line', 'Linear regression', 'Location', 'NorthWest')
hold off
saveas(fig2, 'Output/2015 cropland FAO vs CCI.tif')

%%%% AGRICULTURE FAO 1992
fig3 = figure;
mdl = fitlm(log10(hectare_fao_agr_1992),log10(hectare_cci_1992));
mdl.Rsquared.Ordinary
mdl.Rsquared.Adjusted
mdl
scatter(log10(hectare_fao_agr_1992),log10(hectare_cci_1992));
hold on
%1:1
plot([0 10], [0 10])
%Regression
min_x = min(log10(hectare_fao_agr_1992));
max_x = max(log10(hectare_fao_agr_2015));
y_predict = mdl.predict([min_x 
    max_x]);
plot([min_x max_x], y_predict,'LineStyle', '--', 'Color', 'k', 'LineWidth',1.2)

xlabel('FAO log10([hectare])')
ylabel('CCI log10([hectare])')
xlim([0 10])
ylim([0 10])
set(gca,'XTick',[0:1:10]);
set(gca,'YTick',[0:1:10]);
%legend('Cropland extent', '1:1 line', 'Linear regression', 'Location', 'NorthWest')
hold off
saveas(fig3, 'Output/1992 agriculture FAO vs CCI.tif')

%%%%% Agriculture FAO 2015
fig4 = figure;
mdl2 = fitlm(log10(hectare_fao_agr_2015),log10(hectare_cci_2015));
mdl2.Rsquared.Ordinary
mdl2.Rsquared.Adjusted
mdl2
scatter(log10(hectare_fao_agr_2015),log10(hectare_cci_2015));
xlabel('FAO log10([hectare])')
ylabel('CCI log10([hectare])')

hold on 
%1:1
plot([0 10], [0 10])
%Regression
min_x = min(log10(hectare_fao_agr_2015));
max_x = max(log10(hectare_fao_agr_2015));

y_predict = mdl2.predict([min_x 
    max_x]);
plot([min_x max_x], y_predict,'LineStyle', '--', 'Color', 'k', 'LineWidth',1.2)
%legend('Cropland extent', '1:1 line', 'Linear regression', 'Location', 'NorthWest')
xlim([0 10])
ylim([0 10])
set(gca,'XTick',[0:1:10]);
set(gca,'YTick',[0:1:10]);
hold off
saveas(fig2, 'Output/2015 agriculture FAO vs CCI.tif')



