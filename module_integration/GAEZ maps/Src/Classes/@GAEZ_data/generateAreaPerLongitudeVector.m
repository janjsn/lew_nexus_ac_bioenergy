function obj = generateAreaPerLongitudeVector( obj )
%GENERATEAREAPERLONGITUDEVECTOR 
%Generates area per longitude vector for GAEZ matrix. Assumes equal longitude steps. 

areaPerLatitudeVector_shareOfEarth(length(obj.latitudeVector_upperCorner)) = 0;

    lon1 = obj.longitudeVector_leftCorner(1);
    lon2 = obj.longitudeVector_leftCorner(2);



for i = 1:length(obj.latitudeVector_upperCorner)-1
    lat1 = obj.latitudeVector_upperCorner(i);
    lat2 = obj.latitudeVector_upperCorner(i+1);
    areaPerLatitudeVector_shareOfEarth(i) = areaquad(lat1,lon1,lat2,lon2);
end

lat1 = obj.latitudeVector_upperCorner(end);
lat2 = lat1+obj.cellExtent_latitude;
if lat2 > 90 
    lat2 = 90;
elseif lat2 < -90
    lat2 = -90;
end

areaPerLatitudeVector_shareOfEarth(end) = areaquad(lat1,lon1,lat2,lon2);


earthellipsoid = referenceSphere('earth','km');
earth_surfaceArea_km2 = areaquad(-90,-180,90,180,earthellipsoid);

earth_surfaceArea_hectare = earth_surfaceArea_km2*100;

areaPerLatitudeVector_hectare = areaPerLatitudeVector_shareOfEarth*earth_surfaceArea_hectare;
areaPerLatitudeVector_km2 = areaPerLatitudeVector_shareOfEarth*earth_surfaceArea_km2;
areaPerLatitudeVector_m2 = areaPerLatitudeVector_shareOfEarth*earth_surfaceArea_km2*10^6;

obj.areaPerLatitudeVector_shareOfEarth = areaPerLatitudeVector_shareOfEarth;
obj.areaPerLatitudeVector_m2 = areaPerLatitudeVector_m2;
obj.areaPerLatitudeVector_hectare = areaPerLatitudeVector_hectare;
obj.areaPerLatitudeVector_km2 = areaPerLatitudeVector_km2;


end

