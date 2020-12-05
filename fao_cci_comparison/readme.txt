CODE TO COMPARE COUNTRY LEVEL CROPLAND EXTENT WITH FAO INVENTORY 
Run main.m script only, with all classes/functions as attached.

Relies on: 
 1. custom produced code and gridded CCI cropland extent netcdfs (hectares). Resolution used is 30 arcsec. These files are too big to store in git. Either re-run land cover module, or ask corresponding author for data. 
 2. GPW-v4 national identifier grid 
 3. FAO inventories providing country land use as %, Excels
 4. Equal country names from GPW and FAO. 

GPW-v4 and FAO inventories must be downloaded from respective websites due to copyrights, then correctly mapped in "main.m".

Note that a few countries are not catched by the code (< 10%).
Produces results to memory and graphs to ".gif" for all countries with 
similar name in both sources. Results includes linear regressions.

20.08.2020 - Jan Sandstad Næss


