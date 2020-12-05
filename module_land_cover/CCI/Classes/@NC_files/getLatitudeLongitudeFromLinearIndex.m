function [latitude, longitude] = getLatitudeLongitudeFromLinearIndex(obj, linearIndex)
%GETLATITUDELONGITUDEFROMLINEARINDEX Summary of this function goes here
%   Detailed explanation goes here
mSize = size(obj.landCoverMatrix_lucc);

%Error checking
if linearIndex > mSize(1)*mSize(2) || linearIndex < 1 || mod(linearIndex,1) ~= 0
   error('Error: Attempt was made to get latitude longitude from a linear index outside matrix boundaries. Check input to function') 
end

temp = mod(linearIndex, mSize(1));

if temp == 0
    temp = mSize(1);
    longitudePos = temp;
    latitudePos = (linearIndex/mSize(1));
else

longitudePos = temp;
latitudePos = floor(linearIndex/mSize(1))+1;
end

%latitudePos

latitude = obj.latitudeVector(latitudePos);
longitude = obj.longitudeVector(longitudePos);





end

