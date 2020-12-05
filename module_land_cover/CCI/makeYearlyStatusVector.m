function YearlyStatusVector = makeYearlyStatusVector( )
%MAKEYEARLYSTATUSVECTOR Summary of this function goes here
%   Detailed explanation goes here
YearlyStatusVector(10) = YearlyStatus;
for i = 1:10
   YearlyStatusVector(i).LandAreaGrid = makeLandAreaGrid_dummy; 
   YearlyStatusVector(i).year = 2000+i;
end


end

