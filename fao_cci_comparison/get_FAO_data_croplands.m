function  Country_array  = get_FAO_data_croplands(filename, Country_array)
%GET_FAO_DATA_CROPLANDS Summary of this function goes here
%   Detailed explanation goes here

[num, txt, raw] = xlsread(filename);

mSize = size(raw);

for i = 1:mSize-1
   this_area_name = raw{i+1,4};
   this_year = raw{i+1,10};
   this_share_of_land_area = raw{i+1,12};
   this_ID = raw{i+1,3};
   
   for j = 1:length(Country_array)
      if strcmp(this_area_name, Country_array(j).country_name)
          Country_array(j).FAO_country_ID = this_ID;
          if this_year == 1992
              Country_array(j).FAO_cropland_1992_share_of_land_area = this_share_of_land_area;
          elseif this_year == 2015
              Country_array(j).FAO_cropland_2015_share_of_land_area = this_share_of_land_area;
          end
      end
   end 
end

end

