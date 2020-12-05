function country_array = get_FAO_fertilizer_data( filename, country_array )
%GET_FAO_FERTILIZER_DATA Summary of this function goes here
%   Detailed explanation goes here

[~,~,raw] = xlsread(filename);

mSize = size(raw);

first_row = 2;
country_code_col = 3;
country_name_col = 4;
year_col = 9;
item_code_col = 7;
value_col = 12;

N_code = 3102;
P2O5_code = 3103;
K20_code = 3104;

for i = first_row:mSize(1)
   country_name = raw{i,country_name_col};
   found_id = 0;
    for countries = 1:length(country_array)
       if strcmp(country_name, country_array(countries).country_name) 
            country_array(countries).FAO_country_ID = raw{i, country_code_col};
            if raw{i,item_code_col} == N_code
                country_array(countries).FAO_cropland_nitrogen_use_2018_kg_per_ha = raw{i,value_col};
            elseif raw{i,item_code_col} == P2O5_code
                
                country_array(countries).FAO_cropland_phosphate_use_2018_kg_per_ha = raw{i,value_col};
            elseif raw{i,item_code_col} == K20_code
                country_array(countries).FAO_cropland_potash_use_2018_kg_per_ha = raw{i,value_col};
            end
            
           found_id = 1;
       end
    end
end








end

