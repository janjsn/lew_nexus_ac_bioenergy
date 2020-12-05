%% CALCULATES GLOBAL AVERAGE YIELDS PER Longitude

GAEZ_array = main_gaez;

myResults(length(GAEZ_array)) = 0;

for i = 1:length(GAEZ_array)
    temp = GAEZ_array(i).dataMatrix_raw;
    temp = temp*GAEZ_array(i).multiplicationFactor;
    
    mSize = size(temp);
    for j = 1:mSize(1)
       temp(j,:) = temp(j,:)*GAEZ_array(i).areaPerLatitudeVector_hectare(j); 
    end
    
    result = sum(sum(temp));
    
    
   myResults_tons(i,:) = result;
end
    