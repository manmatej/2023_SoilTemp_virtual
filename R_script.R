

# =================== working directory ======================================
## set working directory to unzip source files

setwd("C:/pathto/directory") # !!!! EDIT HERE !!!!
# path<-paste0(Sys.getenv("userprofile"),"\\downloads\\")
# setwd(paste0(path,"2022_MEB_myClim_workshop-main"))


# =================== Install packages ======================================
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

ft<-read.table("files_table.csv",sep=",",header = T)
lt<-read.table("localities_table.csv",sep=",",header = T)

tms <- mc_read_data(files_table = "files_table.csv",
                      localities_table =lt,
                      silent = T,clean = T)



## Plotting ============================================================

## lines----------------------------------------------------------------
mc_plot_line(tms,sensors = c("TMS_T3","TMS_T1","TMS_TMSmoisture"))

## raster --------------------------------------------------------------
mc_plot_raster(tms,sensors = c("TMS_T3"))

## aggregation in time ==================================================
# aggregate to daily mean, range, coverage, and 95 percentile. 
tms.day <- mc_agg(tms, fun=c("mean","range","coverage","percentile"),
                percentiles = 95, period = "day",min_coverage = 0.8)

mc_plot_raster(tms.day,sensors = c("TMS_T3_mean"))
mc_plot_raster(tms.day,sensors = c("TMS_T3_range"))

# aggregate all time-series, return one value per sensor.
tms.all <- mc_agg(tms, fun=c("mean","range","coverage","percentile"),
                percentiles = 95, period = "all",min_coverage = 0.8)
r<-mc_reshape_long(tms.all)

## AUTOPILOT: calculate standard myClim envi ============================= 
temp_env <- mc_env_temp(tms,period="all",min_coverage = 0.8)
