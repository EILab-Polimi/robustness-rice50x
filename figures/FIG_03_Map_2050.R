#  2022 - FIGURE 03
# ---------------------------------------------------- #
# Mitigation differences between compromise and other 
# solutions in 2050.
# ---------------------------------------------------- #
# Paolo Gazzotti 
# @gappix
# 


#  .rs.restartR()     # use if you want to restart R
rm(list = ls())       # to clean environment



# Packages --------

library("dplyr")
library("latex2exp")
library("ggplot2")
library("tibble")
library("ggpubr")
library("tidyr")
library("forcats")
library("ggrepel")
library("grid")
library("gridExtra")
# Color palettes 
library("pals")
library("RColorBrewer")
library("ggsci")
library("scico")

# Support functions --------


'%&%' <- function(x,y) paste0(x,y)



#1. --------------------------------------------
## ___________ LOAD DATA  _____________ ####


data_folder <- "./figures-data/"
build_data_folder <- "./build-data/"



TEMPdata = list() # container for temporary data 
FIGdata = list()  # container for cleaned figure data


## Shape data ---------
load(build_data_folder%&%"ed57_geo_shp.Rdata") # shape map ed57 regions


# MIU data import ---------

TEMPdata$MIU_compromise <- read.csv(data_folder%&%"miu_compromise.csv", check.names=FALSE)   
#TEMPdata$MIU_welfare <- read.csv(data_folder%&%"miu_welfare.csv", check.names=FALSE)  
TEMPdata$MIU_compDELTAwelfare <- read.csv(data_folder%&%"Delta_miu_welfare_compromise.csv", check.names=FALSE) 
TEMPdata$MIU_compDELTAtemperature <- read.csv(data_folder%&%"Delta_miu_temperature_compromise.csv", check.names=FALSE) 
TEMPdata$MIU_compDELTAinequality <- read.csv(data_folder%&%"Delta_miu_inequality_compromise.csv", check.names=FALSE) 




# 2. -----------------------------------------
#### _________ SINGLE PLOTS  ___________  ####


# Main plot logic ----

plotter_map  <- function(data
                         , palette
                         , min_data = NULL 
                         , max_data = NULL 
                         , legend_symmetric = TRUE
                         , legend_centre    = 0
                         , legend = "Value"
                         , extra_legend = ""
                         , label = ""
                         , TeX_title ){
  
  
  # Evaluate manually legend breaks 
  min_measure = min(data$value)
  max_measure = max(data$value)
  
  
  
  
  
  # Evaluate minimum data if not provided
  if(is.null(min_data)){ 
    if(legend_symmetric){ min_data = min(c(min_measure, legend_centre-max_measure))
    }else{  min_data = min_measure   }
  }
  
  # Evaluate maximum data if not provided
  if(is.null(max_data)){ 
    if(legend_symmetric){ max_data = max(c(max_measure+legend_centre, -min_measure))
    }else{ max_data = max_measure  }   
  }  
  
  if(!legend_symmetric){ legend_centre = (abs(max_measure)-abs(min_measure))/2 }
  
  
  centre_data = legend_centre
  
  
  plottigat = ggplot() +
    
    # data
    geom_sf(data =  merge(  ed57_geo_shp, #ed57 shape
                            data,
                            by =c("n"))) +
    aes(fill = value) +
    
    # appearance
    scale_fill_gradientn(colors = palette
                         
                         ,breaks=c( min_data
                                    ,(centre_data - 0.75 * abs(min_data-centre_data))
                                    ,(centre_data - 0.5  * abs(min_data-centre_data))
                                    ,(centre_data - 0.25 * abs(min_data-centre_data))
                                    ,centre_data
                                    ,(centre_data + 0.25 * abs(centre_data-max_data))
                                    ,(centre_data + 0.5  * abs(centre_data-max_data))
                                    ,(centre_data + 0.75 * abs(centre_data-max_data))
                                    ,max_data
                         )
                         ,labels=c( paste0(round(min_data,digits = 2)%&%extra_legend)
                                    ,paste0(round((centre_data - 0.75 * abs(min_data-centre_data)),digits = 2)%&%extra_legend)
                                    ,paste0(round((centre_data - 0.5  * abs(min_data-centre_data)),digits = 2)%&%extra_legend)
                                    ,paste0(round((centre_data - 0.25 * abs(min_data-centre_data)),digits = 2)%&%extra_legend)
                                    
                                    ,paste0(round(centre_data,digits = 2)%&%extra_legend)
                                    
                                    ,paste0(round((centre_data + 0.25 *  abs(centre_data-max_data)),digits = 2)%&%extra_legend)
                                    ,paste0(round((centre_data + 0.5  *  abs(centre_data-max_data)),digits = 2)%&%extra_legend)
                                    ,paste0(round((centre_data + 0.75 *  abs(centre_data-max_data)),digits = 2)%&%extra_legend)
                                    ,paste0(round(max_data,digits = 2)%&%extra_legend)
                         )
                         ,limits=c(min_data, max_data) #linear scale
    ) +
    
    labs (fill = legend) + 
    
    theme_bw()+
    
    ggtitle(label= label, subtitle = TeX(TeX_title)) 
  
  
  
  # Return final result
  return(plottigat)
  
}







## → PLOT - Compromise  --------------------------------------


mypalette <- rev(scico(100, palette = 'lapaz'))
# mypalette <- rev(ocean.dense(20))

plt_miu_compr <- plotter_map( data =  TEMPdata$MIU_compromise  %>% 
                                   rename(n=Region, 
                                          value='2050') # set as value the desired year
                                 
                                 , min_data = 0
                                 , max_data = 120
                                 , legend_symmetric = TRUE
                                 
                                 
                                 , palette = mypalette
                                 , legend = "Mitigation \n[%BAU] \n"
                                 , label = "b"
                                 , extra_legend = " %"
                                 , TeX_title = "Mitigation in 2050 - Compromise solution")
plt_miu_compr 




## → PLOT - Delta Welfare  --------------------------------------


mypalette <- (scico(100, palette = 'roma'))

# mypalette <- rev(brewer.pal(11,"BrBG"))

plt_delta_welf <- plotter_map( data =  TEMPdata$MIU_compDELTAwelfare  %>% 
                                rename(n=Region, 
                                       value='2050') %>% # set as value the desired year
                                mutate(value = value)
                               
                              , min_data = -35
                              , max_data = 35
                              , legend_symmetric = TRUE
                              
                              
                              , palette = mypalette
                              , legend = "Mitigation \ndifference \n[%BAU] \n"
                              , label = "a"
                              , extra_legend = " %"
                              , TeX_title = "Compromise-Welfare solutions difference in 2050 mitigation")

plt_delta_welf



## → PLOT - Delta Temperature  --------------------------------------


#mypalette <- rev(scico(100, palette = 'roma'))


plt_delta_temp <- plotter_map( data =  TEMPdata$MIU_compDELTAtemperature  %>% 
                                 rename(n=Region, 
                                        value='2050') %>% # set as value the desired year
                                 mutate(value = value )
                               
                               , min_data = -35
                               , max_data = 35
                               , legend_symmetric = TRUE
                               
                               
                               , palette = mypalette
                               , legend = "Mitigation \ndifference \n[%BAU] \n"
                               , label = "c"
                               , extra_legend = " %"
                               , TeX_title = "Compromise-Temperature solutions difference in 2050 mitigation")
plt_delta_temp




## → PLOT - Delta Inequality  --------------------------------------


#mypalette <- rev(scico(100, palette = 'roma'))


plt_delta_ineq <- plotter_map( data =  TEMPdata$MIU_compDELTAinequality  %>% 
                                 rename(n=Region, 
                                        value='2050') %>%  # set as value the desired year
                                 mutate(value = value)
                               
                               , min_data = -35
                               , max_data = 35
                               , legend_symmetric = TRUE
                               
                               
                               , palette = mypalette
                               , legend = "Mitigation \ndifference \n[%BAU] \n"
                               , label = "d"
                               , extra_legend = " %"
                               , TeX_title = "Compromise-Inequality solutions difference in 2050 mitigation")
plt_delta_ineq



# 4. ------------------------------------------
#### __________ FINAL PLOT  _____________  ####


#' Function helper to extract legend
#' https://github.com/hadley/ggplot2/wiki/Share-a-legend-between-two-ggplot2-graphs
get_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)}




## Dummy plot to create (X) legend  -------

dummy = data.frame(x=rep(0,4), y=rep(0,4), type ="Default \nspecification      ")

dummyplot = ggplot(data=dummy, aes(x,y, shape = type)) + 
  geom_point(size = 2.7) +
  theme(legend.title=element_blank()) +
  scale_colour_manual(values=rep("#00000000", 4)) + 
  scale_shape_manual( values = 4)





## Blank plot to create space -----------------

# White space
blank <- grid.rect(gp=gpar(col="white"))







## → ASSEMBLED FIGURE  -----------------------------------------


mylegend1<-get_legend(plt_miu_compr)
mylegend2<-get_legend(plt_delta_ineq)

plottigat= grid.arrange( 
  
  # Plots ..............
  plt_delta_welf      + theme(legend.position="none"),
  plt_miu_compr       + theme(legend.position="none"),
  plt_delta_temp      + theme(legend.position="none"),
  plt_delta_ineq      + theme(legend.position="none"),
  
  
  # Legends ...........
  
  mylegend1,
  mylegend2,
  
  
  # Layout ...........
  
  layout_matrix = rbind(
    
    c(1,1,1,2,2,2,5),
    c(3,3,3,4,4,4,6)
    
  ))


# *** ---------------
### Export: 1150 x 600  ####



