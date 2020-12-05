function [aggregated_matrix, latitudeVector_centered, longitudeVector_centered, latitudeBounds, longitudeBounds]  = aggregateMatrix2givenDimensions( old_matrix,old_longitudeVector_centered,old_latitudeVector_centered, new_nRows_longitude, new_nCols_latitude )
%Aggregates a matrix (old_matrix) with longitude and latitude dimension
%vectors(old_longitudeVector_centered,old_latitudeVector_centered) to new
%dimensions with n rows and n cols (new_nRows_longitude,
%new_nCols_latitude).

%Assumes equirectangular projections.
%Skips cells that are zero.
%Aggregates based on center of old cell.
%Output is aggregated_matrix, new latitudeVector_centered and
%longitudeVector_centered, latitudeBounds and longitudeBounds.

%Written 13.11.19 by Jan Sandstad Næss

old_mSize = size(old_matrix);

n_lat = new_nCols_latitude;
n_lon = new_nRows_longitude;
new_nLon = n_lon;
new_nLat = n_lat;
%Dimension steps
lat_step  = 180/n_lat;
lon_step = 360/n_lon;

%Dimension vectors
latitudeVector_centered = [90-(lat_step/2):-lat_step:-90+(lat_step/2)];
longitudeVector_centered = [-180+(lon_step/2):lon_step:180-(lon_step/2)];

%Bounds
latitudeBounds = zeros(2,n_lat);
longitudeBounds = zeros(2,n_lon);
latitudeBounds(1,1:end) = [90:-lat_step:-90+lat_step];
latitudeBounds(2,1:end) = [90-lat_step:-lat_step:-90];
longitudeBounds(1,1:end) = [-180:lon_step:180-lon_step];
longitudeBounds(2,1:end) = [-180+lon_step:lon_step:180];

aggregated_matrix = zeros(n_lon, n_lat);
new_latitudeBounds = latitudeBounds;
new_longitudeBounds = longitudeBounds;
 
 
 for old_lon = 1:old_mSize(1)
     for new_lon = 1:new_nLon
         if old_longitudeVector_centered(old_lon) > new_longitudeBounds(1,new_lon) && old_longitudeVector_centered(old_lon) <= new_longitudeBounds(2,new_lon)
             pos_newLon = (new_lon);
             
             for old_lat = 1:old_mSize(2)
                 %Taking only elements different from zero.
                 if old_matrix(old_lon,old_lat) ~=0
                     for new_lat = 1:new_nLat
                         if old_latitudeVector_centered(old_lat) < new_latitudeBounds(1,new_lat) && old_latitudeVector_centered(old_lat) >= new_latitudeBounds(2,new_lat)
                             pos_newLat = (new_lat);

                             aggregated_matrix(pos_newLon, pos_newLat) = aggregated_matrix(pos_newLon, pos_newLat)+ old_matrix(old_lon,old_lat);
                         end
                     end
                 end
                 
             end
         end
         %pos_newLon = 0;
     end
 end
 %toc
 
end

