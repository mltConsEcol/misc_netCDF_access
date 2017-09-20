Contact Info: 
Michael Treglia
The Nature Conservancy, NYC Program
Urban Spatial Planner
michael.treglia@tnc.org

Date: 20 Sept 2017

The files named topowx_extract*.R were  used to facilitate extraction, download, reprojection, and exporting of daily temps from May-Sept of 1996-2016. Because of the large number of files to go through, topowx_extract1 - topowx_extract4 were run in separate instances of R for functional parallelization. (built-in tools for R to parallelize were problematic, so done manually at this point). 'topowx_extract.R' was developed for testing and troubleshooting, and still has some useful examples.

At the current time, extract1 and extract2 failed, though error checking needs to be done to investigate the cause of failure - i.e., was it a problem on the server side, or with R code. extract3 and extract4 were successful.

As of writing, the code needs to be run on MacOS or Linux, as the ncdf4 dependency does not get compiled with capability to access OpenDAP data sources for Windows. This was run within an Ubuntu virtual machine, requiring libgdal1-dev, netcdf-bin, libnetcdf-dev, which allowed for R packages rgdal, raster, and ncdf4

