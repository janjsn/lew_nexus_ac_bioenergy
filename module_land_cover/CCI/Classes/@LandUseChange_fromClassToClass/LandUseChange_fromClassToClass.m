classdef LandUseChange_fromClassToClass
    %LANDUSECHANGE_FROMCLASSTOCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fromClass_ID
        toClass_ID
        description %string
        fromClass_croplandFactor
        toClass_croplandFactor
        areaVector_m2_indexed_CCI_dimensions_01
        areaVector_m2_indexed_CCI_dimensions_areaGained_01 % or lost (+-)
        indexVector_CCI_dimensions_01
        sizeOfMatrix_CCI_matrix_latitude_nRows
        sizeOfMatrix_CCI_matrix_longitude_nCols
        indexVector_landUseChangesBetweenYears_all
        
        areaTotal_m2
        
        areaTotal_m2_Europe
        areaTotal_m2_NorthAmerica
        areaTotal_m2_SouthAmerica
        areaTotal_m2_Asia
        areaTotal_m2_Africa
        areaTotal_m2_Oseania
        
        
    end
    
    methods
        function obj = LandUseChange_fromClassToClass(fromClass_ID, toClass_ID, fromClass_croplandFactor, toClass_croplandFactor, areaVector_m2_indexed_CCI_dimensions_01, indexVector_CCI_dimensions_01, sizeOfMatrix_CCI_matrix__latitude_nCols, sizeOfMatrix_CCI_matrix_longitude_nRows, indexVector_landUseChangesBetweenYears_all)
            obj.fromClass_ID = fromClass_ID;
            obj.toClass_ID = toClass_ID;
            obj.fromClass_croplandFactor = fromClass_croplandFactor;
            obj.toClass_croplandFactor = toClass_croplandFactor;
            obj.areaVector_m2_indexed_CCI_dimensions_01 = areaVector_m2_indexed_CCI_dimensions_01;
            obj.indexVector_CCI_dimensions_01 = indexVector_CCI_dimensions_01;
            obj.sizeOfMatrix_CCI_matrix_latitude_nRows = sizeOfMatrix_CCI_matrix__latitude_nCols;
            obj.sizeOfMatrix_CCI_matrix_longitude_nCols = sizeOfMatrix_CCI_matrix_longitude_nRows;
            obj.indexVector_landUseChangesBetweenYears_all = indexVector_landUseChangesBetweenYears_all;
            obj.areaTotal_m2 = sum(areaVector_m2_indexed_CCI_dimensions_01);
        end
        
        function save2Mat(filename)
            
        end
        
        
        
    end
    
end

