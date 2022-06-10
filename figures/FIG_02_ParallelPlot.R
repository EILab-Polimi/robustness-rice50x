#  2022 - FIGURE 02
# ---------------------------------------------------- #
# Parallel plot of selected solutions over objectives 
# and robustness measures
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
library("GGally")
library("stringr")
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
# Load original RICE50x experiments data
load(build_data_folder%&%"RICE50x_CBA_data.Rdata")


TEMPdata = list() # container for temporary data 
FIGdata = list()  # container for cleaned figure data




#Raw_Robustness_DF <- read.csv(data_folder%&%"Robustness_selected_sol.csv", header = TRUE, sep = ' ')  
#Raw_Robustness_DF <- cbind(Raw_Robustness_DF, "cat"=c('Temperature', 'Inequality', 'Compromise', 'Welfare'))


Raw_Robustness_Rank_DF <- read.csv(data_folder%&%"Robustness_ranking_selected_solutions.csv", header = TRUE, sep = ' ')  
Raw_Robustness_Rank_DF <- cbind(Raw_Robustness_Rank_DF, "cat"=c('Temperature', 'Inequality', 'Compromise', 'Welfare'))





# 2. -------------------------------------------
## __________ DATA PROCESS  ___________ ####



#TEMPdata$Robustness_measures =  Raw_Robustness_DF 
TEMPdata$Robustness_rankings = Raw_Robustness_Rank_DF



ranking_clean_1 <- TEMPdata$Robustness_rankings %>% 
  select("cat",
         "Welfare_Maximin",
         "Welfare_Maximan",
         "Welfare_Mean_Variance",
         "Welfare_LDC_0.5",
         "Temperature_Maximin",
         "Temperature_Maximan",
         "Temperature_Mean_Variance",
         "Temperature_LDC_0.5",
         "R80_20_Maximin",
         "R80_20_Maximan",
         "R80_20_Mean_Variance",
         "R80_20_LDC_0.5",
         "R90_10_Maximin",
         "R90_10_Maximan",
         "R90_10_Mean_Variance",
         "R90_10_LDC_0.5") %>% 
  rename("Solution" = "cat",
         "Welfare Maximin" = "Welfare_Maximin",
         "Welfare Maximax" = "Welfare_Maximan",
         "Welfare Mean_Variance" = "Welfare_Mean_Variance",
         "Welfare LDC_0.5" = "Welfare_LDC_0.5",
         "GMT Maximin" =  "Temperature_Maximin",
         "GMT Maximax" =  "Temperature_Maximan",
         "GMT Mean_Variance" = "Temperature_Mean_Variance",
         "GMT LDC_0.5" =  "Temperature_LDC_0.5",
         "Inequality_80:20 Maximin" =  "R80_20_Maximin",
         "Inequality_80:20 Maximax" = "R80_20_Maximan",
         "Inequality_80:20 Mean_Variance" = "R80_20_Mean_Variance",
         "Inequality_80:20 LDC_0.5" = "R80_20_LDC_0.5",
         "Inequality_90:10 Maximin" =  "R90_10_Maximin",
         "Inequality_90:10 Maximax" = "R90_10_Maximan",
         "Inequality_90:10 Mean_Variance" = "R90_10_Mean_Variance",
         "Inequality_90:10 LDC_0.5" = "R90_10_LDC_0.5")  



ranking_clean_2 = ranking_clean_1 %>%
  gather("cat", "value", 2:17) %>% 
  # Extracting objectives and measures from cat column
  separate("cat", c("Objective", "Measure"), sep=" ")  %>%
  mutate(Measure = str_replace_all(Measure, "_", " ")) %>%
  mutate(Objective = str_replace_all(Objective, "_", " ")) %>%
  # Add mixed dimension
  mutate("Solution_Measure" = Solution%&%" "%&%Measure)


FIGdata$Robustness_Ranking = ranking_clean_2 %>% 
  spread(Objective, value) %>% 
  mutate("Solution desc" = Solution) %>%
  # Add a fake ranking -> different starting point in a parallel chart 
  mutate(Solution = ifelse(Solution=="Inequality", 150,
                           ifelse(Solution=="Temperature", 200,
                                  ifelse(Solution == "Welfare", 100, 50)))) %>%
  mutate(`Solution desc` = fct_relevel(`Solution desc`, "Inequality","Welfare", "Compromise", "Temperature")) %>% 
  rename(" "=Solution)








# 3. ------------------------------------------
#### __________ FINAL PLOT  _____________  ####





## Color choice ------------


# Palettes
my_sci_fill_palette <- pal_d3()
my_sci_color_palette <- pal_futurama()

my_fills <-  my_sci_fill_palette(4)
my_colors <- my_sci_color_palette(4)




# → PLOT - Parallel Lines  -------





ggparcoord(data = FIGdata$Robustness_Ranking, 
           columns =  c(4:7),  
           scale = 'globalminmax', 
           shadeBox = "#dee2e6",
           showPoints = TRUE,
           mapping=aes(color=as_factor(`Solution desc`), 
                       fill=as_factor(Measure),
                       shape= as_factor(Measure))) +
  
  
  geom_point(size=2.5 ) +
  
  
  
  # Appearance ..........................
  
  scale_color_manual("Solution", 
                     values = my_colors,
                     
                     labels=c("Inequality","Welfare","Compromise","Temperature" )) + 
  
  scale_fill_manual("Measure",
                    values = my_fills,
                    labels=c("Maximax","Maximin","Mean Variance", "LDC 0.5")) +
  
  scale_shape_manual("Measure",
                     labels=c("Maximax","Maximin","Mean Variance", "LDC 0.5"),
                     values=c(21,22,23, 24)) +
  
  theme_bw()  +
  
  
  # Axes ................................
  
  xlab("Objective") +
  
  ylab("Ranking (the lower the better)") +
  
  #ylim(0, 1) +
  
  
  # Title ...............................
  
  ggtitle(label = "",
          subtitle = "Solutions ranking across objectives")









# *** ---------------
### Export: 1000 x 600  ####






# EXTRA: plot with category labels  -------



ggparcoord(data = FIGdata$Robustness_Ranking, 
           columns =  c(4:6,1),  
           scale = 'globalminmax', 
           showPoints = TRUE,
           mapping=aes(color=as_factor(`Solution desc`), 
                       fill=as_factor(Measure),
                       shape= as_factor(Measure))) +
  
  geom_point(size=2.5 ) +
  
  # Vertical bar 
  #geom_segment(aes(x=" ", y=25, xend=" ", yend=225), color="black") + 
  
  # Starting points 
  geom_point(data = FIGdata$Robustness_Ranking %>% 
               mutate(factor_solution = as.numeric(as.factor(`Solution desc`))),  
             mapping = aes(x=" ",
                           y=` `, 
                           color=as_factor(factor_solution)),
             size = 4,
             inherit.aes = FALSE)    + 
  
  # Starting labels
  geom_label_repel(data = FIGdata$Robustness_Ranking %>% 
                     select(" ", "Solution desc") %>%
                     distinct(), 
                   mapping = aes(x=" ",y=` `, label = `Solution desc`), 
                   color = 'black',  
                   inherit.aes = FALSE)     + 
  
  
  # Appearance ..........................
  
  scale_color_manual("Solution", 
                     values = my_colors,
                     
                     labels=c("Inequality","Welfare","Compromise","Temperature" )) + 
  
  scale_fill_manual("Measure",
                    values = my_fills,
                    labels=c("Maximax","Maximin","Mean Variance", "LDC 0.5")) +
  
  scale_shape_manual("Measure",
                     labels=c("Maximax","Maximin","Mean Variance", "LDC 0.5"),
                     values=c(21,22,23, 24)) +
  
  theme_bw()  +
  
  
  # Axes ................................
  
  xlab("Objective") +
  
  ylab("Ranking (the lower the better)") +
  
  #ylim(0, 1) +
  
  
  # Title ...............................
  
  ggtitle(label = "",
          subtitle = "Solutions ranking across objectives")





