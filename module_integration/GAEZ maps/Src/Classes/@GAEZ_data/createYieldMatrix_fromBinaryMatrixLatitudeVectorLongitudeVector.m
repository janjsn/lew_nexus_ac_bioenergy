function  yieldMatrix = createYieldMatrix_fromBinaryMatrixLatitudeVectorLongitudeVector(obj, binaryMatrix_longitudeLatitude, latitudeVector, longitudeVector)   
%CREATEYIELDMATRIX_FROMBINARYMATRIXLATITUDEVECTORLONGITUDEVECTOR Summary of this function goes here
%   Detailed explanation goes here

%USES THE GAEZ RAW MATRIX TO GENERATE YIELD MATRIX FOR OTHER RESOLOUTIONS.
%Output matrix is the same size as the binary matrix. 

mSize = size(binaryMatrix_longitudeLatitude);

if mSize(2) ~= length(latitudeVector) || mSize(1) ~= length(longitudeVector)
   error('Wrong size of latitude/longitude vector. Check sizes.') 
end

yieldMatrix = zeros(mSize(1), mSize(2));
c=0;
tic
for i = 1:mSize(1) %longitude
   for j = 1:mSize(2) %latitude
        if binaryMatrix_longitudeLatitude(i,j) == 1
            yieldMatrix(i,j) = obj.getDataFromLatitudeLongitude_rawMatrix(latitudeVector(j),longitudeVector(i));
            c=c+1;
        end
   end
   
   if c > 1000000
       toc
       c=0;
   end
   
end


end

