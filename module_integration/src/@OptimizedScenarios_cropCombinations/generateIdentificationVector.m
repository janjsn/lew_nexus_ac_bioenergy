function obj = generateIdentificationVector(obj)
%Generates an identification vector based on case specific characteristics
%Climate scenario, irrigation level, fertilizer level, year
obj.identificationVector = [obj.ClimateScenario.ID obj.irrigationLevel obj.fertilizerLevel obj.year];

end

