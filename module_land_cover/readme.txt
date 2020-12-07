-- Code to process land cover data (ESA CCI-LC). --

CCI land cover data files are obtainable at the ESA database website.

Land cover processing is done at 10 arcsec. Outputs are produced at 10 arcsec, 30 arcsec, 5 arcmin and 1 degree.

CCI data must be mapped in 'CCI/Input/Import nc files.xlsx'.

Run for abandoned cropland:
getAbandonedCropland.m.

Run for cropland:
getCroplandExtent.m

Integration module uses processed land availability data from here.

