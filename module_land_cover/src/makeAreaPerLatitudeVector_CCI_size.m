

areaPerLatitudeVector_shareOfEarth = 0;
areaPerLatitudeVector_shareOfEarth(length(latitudeVector)) = 0; %prealloc
%Calculating area per quadrangle
for i = 2:length(areaPerLatitudeVector_shareOfEarth)
areaPerLatitudeVector_shareOfEarth(i-1) = areaquad(latitudeVector(i-1)+(90-latitudeVector(1)),longitudeVector(1),latitudeVector(i)+(90-latitudeVector(1)),longitudeVector(2));
end

areaPerLatitudeVector_shareOfEarth(end) = areaPerLatitudeVector_shareOfEarth(1);

earthellipsoid = referenceSphere('earth','km');
earth_surfaceArea_km2 = areaquad(-90,-180,90,180,earthellipsoid);

earth_surfaceArea_hectare = earth_surfaceArea_km2*100;

areaPerLatitudeVector_hectare = areaPerLatitudeVector_shareOfEarth*earth_surfaceArea_hectare;
areaPerLatitudeVector_m2 = areaPerLatitudeVector_shareOfEarth*earth_surfaceArea_km2*10^6;

