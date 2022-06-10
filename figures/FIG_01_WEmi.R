#  2022 - FIGURE 01
# ---------------------------------------------------- #
# Model regions geographical representation
# ---------------------------------------------------- #
# Paolo Gazzotti 
# @gappix
# 


#  .rs.restartR()     # use if you want to restart R
rm(list = ls())       # to clean environment

# library("rice50xplots")
# library("witchtools")
# library("gdxtools")

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
library("viridis")
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


# RICE50x CBA data ---------
load(build_data_folder%&%"RICE50x_CBA_data.Rdata")


# World Historical -----
FIGdata$W_EMI_Hist_y = RICE50x_CBA_data$W_EmiFFI_Hist_PRIMAP_ty



# EMISSIONS robustness ---------

TEMPdata$World_EIND_y <- read.csv(data_folder%&%"EIND_TATM_robustness.csv")  %>% 
  select(-c(X, TATM)) %>%
  rename(value = EIND, year = YEAR) %>% 
  filter(year <= 2150) %>% 
  mutate(cat="robustness") %>% 
  mutate(bubba = fct_relevel(orig_sol, "Inequality","Welfare", "Compromise", "Temperature"))


# Give order to cat factors
TEMPdata$World_EIND_y$orig_sol <- factor(TEMPdata$World_EIND_y$orig_sol,  
                                    levels = c("Inequality","Welfare", "Compromise", "Temperature") )




# TEMPERATURE robustness  -----------

TEMPdata$World_TATM_y <-  read.csv(data_folder%&%"EIND_TATM_robustness.csv") %>% 
  select(-c(X, EIND)) %>%
  rename( value = TATM, year = YEAR) %>% 
  filter(year <= 2150) %>% 
  mutate(cat="robustness")





# 2. -------------------------------------------
## __________ DATA PROCESS  ___________ ####


## Helper functions -------------------------------

#' Function to extract max and min range from a bunch of experiments 
#' related to the 1same world (ty) measure.
#'
add_confidence_from_data_ty <- function(main_exp, all_other_exp){
  
  conf_df =
    rbind(main_exp,all_other_exp) %>%
    group_by_at(c("year")) %>%
    summarize(conf_max = max(value), 
              conf_min = min(value),
              p66_min = quantile(x = value, probs = 0.17),
              p66_max = quantile(x=value, probs =0.73),
              p90_min = quantile(x = value, probs = 0.05),
              p90_max = quantile(x=value, probs =0.95)
              ) %>%
    as.data.frame()
  
  final_df = merge(main_exp, conf_df, by=c("year"))
  
  return(final_df)
} 






# World emissions data  ------------------


TEMPdata$W_EmiFFI_CBA_ty <- RICE50x_CBA_data$W_EmiFFI_ty %>%
  filter(year <= 2150) %>%
  # add category label
  mutate( cat =  ifelse(policy=="BAU", "BAU impacts", 
                        ifelse(policy=="BASE", "BAU no-impacts",
                               ifelse(cooperation=="noncoop-pop", "Non-coop", "Coop")))) 



TEMPdata$W_EmiFFI_Hist_PRIMAP_ty   = RICE50x_CBA_data$W_EmiFFI_Hist_PRIMAP_ty






# Temperature data ------------


TEMPdata$W_TATM_CBA_ty <- RICE50x_CBA_data$W_TATM_ty %>%
  filter(year <= 2150) %>%
  # add category label
  mutate( cat =  ifelse(policy=="BAU", "BAU impacts", 
                        ifelse(policy=="BASE", "BAU no-impacts",
                               ifelse(cooperation=="noncoop-pop", "Non-coop", "Coop")))) 




# FIG data: emissions   ---------------------------


# RICE50x range

FIGdata$WEMI_CBACoop_range_ty <- add_confidence_from_data_ty(
  # Main line
  main_exp = TEMPdata$W_EmiFFI_CBA_ty %>%
    filter( policy == "CBA"
            , cooperation == "coop-pop"
            , disnt == 0.5
            , baseline == "ssp2"
            , prstp == 0.015
            , impacts == "BHM-SR") %>%
    select( t, year, value, unit ) ,
  
  # Uncertainty
  all_other_exp = TEMPdata$W_EmiFFI_CBA_ty  %>% 
    filter( policy == "CBA"
            , cooperation == "coop-pop") %>%
    select( t, year, value, unit )
  
) %>% 
  mutate(cat="Coop")





# Robustness data

####FIGdata$WEMI_robust_y = TEMPdata$World_EIND_y %>% filter(year <= 2110) 

FIGdata$WEMI_robust_y = rbind(
  
  TEMPdata$World_EIND_y %>% 
        filter(year <= 2110) %>% 
        select(year,value,orig_sol, cat, iter),
      
  TEMPdata$W_EmiFFI_Hist_PRIMAP_ty %>%
        rename(cat = variable_name) %>% 
        mutate(orig_sol = "Historical", iter=0)) %>%
  
  mutate(orig_sol = fct_relevel(orig_sol, "Historical","Inequality","Welfare", "Compromise", "Temperature"))





# FIG data: temperature uncertainty  ---------------------------



FIGdata$TATM_CBACoop_range_ty <- add_confidence_from_data_ty(
  # Main line
  main_exp = TEMPdata$W_TATM_CBA_ty %>%
    filter( policy == "CBA"
            , cooperation == "coop-pop"
            , disnt == 0.5
            , baseline == "ssp2"
            , prstp == 0.015
            , impacts == "BHM-SR") %>%
    select( t, year, value, unit ) ,
  
  # Uncertainty
  all_other_exp = TEMPdata$W_TATM_CBA_ty  %>% 
    filter( policy == "CBA"
            , cooperation == "coop-pop") %>%
    select( t, year, value, unit )
  
) %>% 
  mutate(cat="Coop")




# Robustness data
FIGdata$TATM_robust_y = TEMPdata$World_TATM_y %>% filter(year <= 2110) %>%
  mutate(orig_sol = fct_relevel(orig_sol, "Inequality","Welfare", "Compromise", "Temperature"))



# 3. -----------------------------------------
#### _________ SINGLE PLOTS  ___________  ####


# Color palettes --------------
# c(   "#6b43e0", "#000000",   "#ef4d00",  "#167d6a", "#063980" )) +
# c(   "#000000", "#6b43e0","#6b43e0",    "#eb4e04",  "#1da98f", "#ffffff" )) +


# Palettes
my_sci_palette <- pal_d3()
my_sci_palette <- pal_futurama()

my_fills <-  viridis(6)
my_colors <- my_sci_palette(4)




# → PLOT - World EmiFFI  -------




pworld_emi = ggplot() +
  
 
  # Annotations .........................
  
  # evidence of negative emissions
  annotate("rect", xmin = c(-Inf), xmax = c(Inf),
           ymin = -Inf, ymax = 0,
           alpha = 0.1, fill = c("Black")) +
  
  annotate("text", x = 2005, y = -3
           , hjust = -0.05
           , label = "Negative emissions") + 
  
  geom_hline(aes(yintercept=0)
             , linetype="dashed") +
  
   # vertical references 
  geom_vline(aes(xintercept=2100)
             #, linetype="dashed" 
             , alpha = 0.2) + 
  
  
  # Main data ...........................
    
  
  # RICE50x emissions
  geom_line( data = RICE50x_CBA_data$W_EmiFFI_ty  %>% 
               filter( policy == "CBA"
                       , cooperation == "coop-pop") %>%
               mutate( cat2 = baseline%&%impacts%&%disnt%&%prstp )
             , mapping = aes(x=year, y=value, group=cat2 ), size=0.1, alpha = 0.6, color="Grey") +  
  
  
  # Emi ranges
  geom_ribbon( data = FIGdata$WEMI_CBACoop_range_ty
               , mapping = aes(x=year, ymin=conf_min, ymax=conf_max, fill = "Full range" ), alpha=0.2) +

  geom_ribbon( data = FIGdata$WEMI_CBACoop_range_ty
               , mapping = aes(x=year, ymin=p90_min, ymax=p90_max, fill = "Conf. 90%" ), alpha=0.2) +
  
  geom_ribbon( data = FIGdata$WEMI_CBACoop_range_ty
               , mapping = aes(x=year, ymin=p66_min, ymax=p66_max, fill = "Conf. 66%" ), alpha=0.2) +
  
  
  # main emissions lines
  geom_line( data = FIGdata$WEMI_robust_y
             , mapping = aes(x=year, y=value, colour=orig_sol, group = iter, alpha=0.35)
             , size = 0.7) +
  
  
  # historical emissions
  geom_line( data = FIGdata$W_EMI_Hist_y
               , mapping = aes(x=year, y=value), color ="#000000", size=1.2) +
  

  
  
  
  # Appearance ..........................

  # Color
  scale_color_manual( values= c("#000000", my_colors)) +
  scale_fill_manual(  values= my_fills)  + 
  
  theme_bw() + 
  
  
  # Axes ................................
  
  
  # axes labels
  labs (color = "Robustness Scenarios", 
        fill = "RICE50+ Solutions") +
  
  scale_alpha(guide = 'none') + 
  
  xlab("Year") +
  
  ylab("[GtCO2/year]") +
  
  xlim(2000,2120) +
  
  # Title ...............................
  
  ggtitle(label = "a",
          subtitle = "World industrial emissions")


pworld_emi





 



# → PLOT - World TATM  -------




pworld_tatm = ggplot() +
  
  
  # Annotations .........................
  
  # evidence of negative emissions
  annotate("rect", xmin = c(-Inf), xmax = c(Inf),
           ymin = 2, ymax = Inf,
           alpha = 0.1, fill = c("Black")) +
  
  #annotate("text", x = 2010, y = 1.95
  #         , hjust = -0.05
  #         , label = "Paris Target") + 
  
  geom_hline(aes(yintercept=2)
             , linetype="dashed") +
  
  # vertical references 
  geom_vline(aes(xintercept=2100)
             #, linetype="dashed" 
             , alpha = 0.2) + 
  
  
  # Main data ...........................
  
  # RICE50x emissions
  geom_line( data = RICE50x_CBA_data$W_TATM_ty  %>% 
               filter( policy == "CBA"
                       , cooperation == "coop-pop") %>%
               mutate( cat2 = baseline%&%impacts%&%disnt%&%prstp )
             , mapping = aes(x=year, y=value, group=cat2 ), size=0.1, alpha = 0.6, color="Grey") +  
  
  
  # emi ranges
  geom_ribbon( data = FIGdata$TATM_CBACoop_range_ty
               , mapping = aes(x=year, ymin=conf_min, ymax=conf_max, fill = "Range" ), alpha=0.2) +
  
  geom_ribbon( data = FIGdata$TATM_CBACoop_range_ty
               , mapping = aes(x=year, ymin=p90_min, ymax=p90_max, fill = "Conf. 90%" ), alpha=0.2) +
  
  geom_ribbon( data = FIGdata$TATM_CBACoop_range_ty
               , mapping = aes(x=year, ymin=p66_min, ymax=p66_max, fill = "Conf. 66%" ), alpha=0.2) +
  
  
  # main lines
  geom_line( data = FIGdata$TATM_robust_y %>% filter(sim_ecs==3.0) 
             , mapping = aes(x=year, y=value, colour=orig_sol, group = iter, alpha=0.35)
             , size = 0.7) +
  

  
  
  # Appearance ..........................
  
  # Color
  scale_color_manual( values= my_colors) +
  scale_fill_manual(  values= my_fills ) +
  
  theme_bw() + 
  
  
  # Axes ................................
  
  
  # axes labels
  labs (color = "Robustness Scenarios", 
        fill = "RICE50+ Solutions") +
  
  scale_alpha(guide = 'none') + 
  
  xlab("Year") +
  
  ylab("GMT Increase [°C]") +
  
  scale_y_continuous(labels = function(x) "+"%&%x%&%" °C") +
  
  xlim(2010,2120) +
  
  # Title ...............................
  
  ggtitle(label = "b",
          subtitle = "GMT Increase")


pworld_tatm









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


mylegend<-get_legend(pworld_emi)

plottigat= grid.arrange( 
  
  # Plots ..............
  
  pworld_emi       + theme(legend.position="none"),
  pworld_tatm      + theme(legend.position="none"),
  
  # Legends ...........
  
  mylegend, 
  
  
  # Layout ...........
  
  layout_matrix = rbind(
    
    c(1,1,1,2,2,2,3)
    
  ))


# *** ---------------
### 1150 x 750  ####


