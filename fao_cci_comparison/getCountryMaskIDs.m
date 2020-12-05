function CountryArray = getCountryMaskIDs( filename, sheetname )
%GETCOUNTRYMASKIDS Summary of this function goes here
%   Detailed explanation goes here

[num,txt,raw] = xlsread(filename, sheetname);

mSize = size(raw);

n_countries = mSize(1)-2;

CountryArray(1:n_countries) = Countries;

for i = 1:n_countries
   CountryArray(i).GPW_country_ISO_numeric = raw{i+2,4};
   CountryArray(i).GPW_country_ISO_string = raw{i+2,3};
   CountryArray(i).country_name = raw{i+2,1};  
end

end

