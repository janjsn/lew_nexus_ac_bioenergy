Code to integrate datasets and methods for LWE nexus study.

Quantifies bioenergy potentials, and associated land, energy, and water use nexus indicators on recently abandoned cropland.

Relies on:
- Land availability input data produced through module_land_cover (processed data at 5 arcmin provided here).
- Spatial crop yields (ton dry mass) from the agro-ecological crop model GAEZ for different crops, management intensities, water supply, and climatic conditions.
- Crop water deficit data produced by GAEZ (i.e. mm/year that needs to be covered by irrigation). Water deficit data is as a convention mapped here together with the corresponding irrigated GAEZ crop yields.
- Lower heating values (GJ/ton).
- Datasets of biodiversity hotspots (processed data provided here at 5 armcin). 
  History: biodiversity hotspots data have been gridded from shapefiles to 10 arcseconds by ArcGIS, then used to filter land availability at 10 arcsec.
- Yield gap data from GAEZ website.
- Physical water scarcity data (https://data.apps.fao.org/aquamaps/).
- Future projected bioenergy demand from SSP database (https://tntcat.iiasa.ac.at/SspDb/dsd?Action=htmlpage&page=welcome).
- National identifier grid (https://doi.org/10.7927/H4TD9VDP)
- Gridded fertilizer data (https://doi.org/10.7927/H4FQ9TJR, https://doi.org/10.7927/H4Q81B0R). 

For GAEZ model description and data access, check: http://www.gaez.iiasa.ac.at/.

Settings, input filenames and input variable names are defined in: 
 - Main namelist file: InputData/namelist_Input.m --> netcdf filenames, variables ++
 - Input excel file describing GAEZ crop data filenames, 'GAEZ maps/Input/Import GAEZ files.xlsx' --> GAEZ data

 Further description is provided in namelist comments.

Run main_integration.m after correctly mapping input files. Custom code spatially quantifies bioenergy potentials, water use, productivity distributions, and nexus indicators across all potential variants.

Produces mainly results to memory in variant specific arrays. A switch exist in namelist to activate some output functions when main_integration.m code is run. Array data is searchable through IDs and identification vectors.

Other targeted output export and plot functions are located in /src/.. or as methods for individual classes (check @XXX folders).



