function [ LandCoverClassArray ] = importLandAreaClasses( xls, sheet )
%Imports land area classes from Excel assuming given template.

[num,txt,raw] = xlsread(xls,sheet);

mSize = size(raw);

%% Defining column indexes
IDcol = 2; 
workIDcol = 3;
nameCol = 4;
isWaterCol = 5;
isUrbanCol = 6;
isCroplandCol = 7;
isForestCol = 8;
isSavannaCol = 9;
isShrublandCol = 10;
isGrasslandCol = 11;
isBareLandCol = 12;
isWetlandCol = 13;
isSnowAndIceCol = 14;
isNoDataCol = 15;
isMixedCroplandCol = 16;
croplandFactorCol = 17;
grasslandFactorCol = 18;
forestFactorCol = 19;
shrublandFactorCol = 20;


firstInputRow = 5;

nInputs = 0;
posArray = NaN;

%% Finding number of inputs correctly given
for i = firstInputRow:mSize(1)
    if isnumeric(raw{i,IDcol}) && mod(raw{i,IDcol},1) == 0
        if ischar(raw{i,nameCol})
            if raw{i,isWaterCol} == 1 || raw{i,isWaterCol} == 0
                if raw{i,isUrbanCol} == 0 || raw{i,isUrbanCol} == 1
                    if raw{i,isCroplandCol} == 0 || raw{i,isCroplandCol} == 1
                        if raw{i,isForestCol} == 0 || raw{i,isForestCol} == 1
                            if raw{i,isSavannaCol} == 0 || raw{i,isSavannaCol} == 1
                                if raw{i,isShrublandCol} == 0 || raw{i,isShrublandCol} == 1
                                    if raw{i,isGrasslandCol} == 0 || raw{i,isGrasslandCol} == 1
                                        if raw{i,isWetlandCol} == 0 || raw{i,isWetlandCol} == 1
                                            if raw{i,isSnowAndIceCol} == 0 || raw{i,isSnowAndIceCol} == 1
                                                if raw{i,isBareLandCol} == 0 || raw{i,isBareLandCol} == 1
                                                    if raw{i,isNoDataCol} == 0 || raw{i,isNoDataCol} == 1
                                                        if raw{i,isMixedCroplandCol} == 0 || raw{i,isMixedCroplandCol} == 1
                                                            %Checking mixed
                                                            %cropland
                                                            %factors
                                                            if raw{i,isMixedCroplandCol} == 1
                                                                totalFactor = raw{i,croplandFactorCol}+raw{i,grasslandFactorCol}+raw{i,forestFactorCol}+raw{i,shrublandFactorCol};
                                                                if totalFactor ~= 1
                                                                error('Mixed cropland factors do not sum to 1 for mixed cropland. Check input.')
                                                                end
                                                            end
                                                            
                                                            nInputs = nInputs+1;
                                                            if isnan(posArray)
                                                                posArray = i;
                                                            else
                                                                posArray(length(posArray)+1) = i;
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end %if
        end %if
    end %if
end %for

if nInputs == 0
    fprintf('No land area classes identified with correct input. No action taken.')
   return %no inputs 
end

%% Getting data
%Preallocation
%LandCoverClassArray(nInputs) = LandCoverClass(0,'noName',0);

for i = 1:length(posArray)
LandCoverClassArray(i) = LandCoverClass(raw{posArray(i),IDcol}, raw{posArray(i),workIDcol}, raw{posArray(i),nameCol},raw{posArray(i),isWaterCol}, raw{posArray(i),isUrbanCol}, raw{posArray(i),isCroplandCol}, raw{posArray(i),isForestCol}, raw{posArray(i),isSavannaCol}, raw{posArray(i),isShrublandCol}, raw{posArray(i),isGrasslandCol}, raw{posArray(i),isBareLandCol},raw{posArray(i),isWetlandCol}, raw{posArray(i),isSnowAndIceCol}, raw{posArray(i),isNoDataCol}, raw{posArray(i),isMixedCroplandCol}, raw{posArray(i),croplandFactorCol},raw{posArray(i),grasslandFactorCol}, raw{posArray(i),forestFactorCol}, raw{posArray(i),shrublandFactorCol}); 
end

fprintf('Identified and imported ');
fprintf(num2str(nInputs));
fprintf(' land cover classes. \n'); 

end

