### https://www.wcrp-climate.org/data-etccdi

### http://etccdi.pacificclimate.org/software.shtml
###
###http://etccdi.pacificclimate.org/index.shtml
###
###

#### https://github.com/pacificclimate/climdex.pcic
### https://cran.r-project.org/web/packages/climdex.pcic/climdex.pcic.pdf

library (climdex.pcic)

## https://rdrr.io/github/pacificclimate/climdex.pcic.ncdf/src/R/ncdf.R
library(devtools)
install_github('pacificclimate/climdex.pcic.ncdf', ref='release')
library (climdex.pcic.ncdf)


create.indices.from.files <- function(input.files, out.dir, output.filename.template, author.data, 
                                      climdex.vars.subset=NULL, 
                                      climdex.time.resolution=c("all", "annual", "monthly"), 
                                      variable.name.map=c(tmax="tasmax", tmin="tasmin", prec="pr", tavg="tas"), 
                                      axis.to.split.on="Y", fclimdex.compatible=TRUE, base.range=c(1961, 1990), 
                                      parallel=4, verbose=FALSE, thresholds.files=NULL, 
                                      thresholds.name.map=c(tx10thresh="tx10thresh", tn10thresh="tn10thresh", 
                                                            tx90thresh="tx90thresh", tn90thresh="tn90thresh",
                                                            r95thresh="r95thresh", r99thresh="r99thresh"),
                                      max.vals.millions=10, cluster.type="SOCK")
  
 

setwd ("C:/Users/gfand/OneDrive/Documentos/museum_hack/BioExtremes/variables_hackaton")
author.data <- c("gf")
input.files <- list.files()
kk<- create.indices.from.files(files, "out_dir2/", input.files[3], author.data,
                                base.range=c(1991, 2000), parallel=FALSE)

                          #' ## Prepare input data and calculate indices for two files
                          #' ## in parallel given thresholds.
                          #' input.files <- c("pr_NAM44_CanRCM4_ERAINT_r1i1p1_1989-2009.nc",
                          #'                  "tasmax_NAM44_CanRCM4_ERAINT_r1i1p1_1989-2009.nc")
                          #' author.data <- list(institution="Looney Bin", institution_id="LBC")
                          #' create.indices.from.files(input.files, "out_dir/", input.files[1], author.data,
                          #'                           base.range=c(1991, 2000), parallel=8, thresholds.files="thresh.nc")
                          #' }
                          #'
                          #' @export
                         

##########################################################3
