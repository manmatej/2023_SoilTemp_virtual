# Introducing myClim an R package for microclimatic data handling.  
# Developed by Matěj Man, Vojtěch Kalčík, Martin Macek, Jan Wild, Martin Kopecký, Josef Brůna, Lucia Hederová.   
# Department of Geoecology, Institute of Botany of the Czech Academy of Sciences
#   
# * https://github.com/ibot-geoecology/myClim
# * http://labgis.ibot.cas.cz/myclim/index.html
# * http://labgis.ibot.cas.cz



# =================== Install myClim ======================================
# check dependencies and install if necessary
requiered_packages <- c("stringr", "lubridate", "tibble", "dplyr", "purrr",
                        "ggplot2", "ggforce", "viridis", "runner",
                        "rmarkdown", "knitr", "kableExtra", "tidyr", "plotly", "zoo")
missing_packages <- requiered_packages[!(requiered_packages %in% installed.packages()[,"Package"])]
if(length(missing_packages)) install.packages(missing_packages)

install.packages("http://labgis.ibot.cas.cz/myclim/myClim_latest.tar.gz", repos=NULL, build_vignettes=TRUE)


#==============================================================================
#============= The shortest possible demo =====================================
#==============================================================================


## Reading logger data with metadata ==========================================

library(myClim)

tms <- mc_read_files(paths = "./TMS_data/",
                     dataformat_name = "TOMST",
                     silent = T, clean = T)

## Plotting ============================================================

## lines----------------------------------------------------------------
mc_plot_line(tms,sensors = c("TMS_T3","TMS_T1","TMS_TMSmoisture"))

## raster --------------------------------------------------------------
mc_plot_raster(tms,sensors = c("TMS_T3"))

## aggregation in time ==================================================
# aggregate to daily mean, range, coverage, and 95 percentile. 
tms.week <- mc_agg(tms, fun=c("mean","range","coverage","percentile"),
                percentiles = 95, period = "week",min_coverage = 0.8)

mc_plot_raster(tms.week,sensors = c("TMS_T3_mean"))

# reshape data from myClim to flat table
week_wide<-mc_reshape_wide(tms.week,sensors = "TMS_T3_mean")

## Standard myClim variables ============================= 
temp_env <- mc_env_temp(tms,period="all",min_coverage = 0.8)
levels(factor(temp_env$sensor_name))


