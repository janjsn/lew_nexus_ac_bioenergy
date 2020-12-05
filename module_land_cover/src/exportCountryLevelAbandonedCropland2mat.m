function exportCountryLevelAbandonedCropland2mat( CountryArray, filename )
%Export country cropland abandonment to mat file

n_countries = length(CountryArray);

country_cropland_abandonment = cell(n_countries+1, 4);

country_cropland_abandonment{1,1} = 'Country';
country_cropland_abandonment{1,2} = 'ISO numeric';
country_cropland_abandonment{1,3} = 'ISO string';
country_cropland_abandonment{1,4} = 'Abandoned cropland (hectare)';

for i = 1:n_countries
   country_cropland_abandonment{i+1,1} = CountryArray(i).country_name;
   country_cropland_abandonment{i+1,2} = CountryArray(i).GPW_country_ISO_numeric;
   country_cropland_abandonment{i+1,3} = CountryArray(i).GPW_country_ISO_string;
   country_cropland_abandonment{i+1,4} = CountryArray(i).abandonedCropland_total_hectares;
end

save(filename, 'country_cropland_abandonment');

end

