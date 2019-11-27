## Required packages
library(ggplot2)
library(dplyr)

## Load data
## This data frame is a filtered query from the ED that includes
## WQ data from two stations at the Lake Apopka Marsh Flow Way, the
## system inflow (WQAIN) and the system outflow (WQPNA)
## Only 6 analytes (NH4-D, NOx-D, PO4-D, TKN-T, TP-D, and TP-T) are
## included in this dataset
## One additional field has been added, YEAR, so we can filter by 
## year if we want to
load("./DataFiles/MFWdat.RData")

## View the data frame
head(MFWdat)

## data
ggplot(MFWdat,
       
       ## aesthetic mapping elements
       aes(x=SMPL_COLL_DT,y=MEAS_VAL)) + 
    
    ## color scheme for figure
    theme_bw() +
    
    ## x label
    xlab("") +
    
    ## y label
    ylab("Measured Value (mg/L)") +
    
    ## geometric object(s)
    geom_point(size=1.5) +
    # geom_hline(yintercept = 0.055,color = "red") +
    
    ## colors (scales)
    scale_colour_manual(values=c("springgreen3","blue")) +
    
    ## axes (scales)
    # scale_y_continuous(limits=c(0,.2)) +
    
    ## facets
    facet_wrap(~WTR_QUAL_PARAM_NM,scales="free_y") +
    
    ## title
    ggtitle("Marsh Flow-Way Water Quality")
    

## data
ggplot(MFWdat,
       
       ## aesthetic mapping elements
       aes(DILUT_FACTR_VAL)) +
    
    ## color scheme for figure
    theme_bw() +
    
    ## geometric object(s)
    geom_histogram(bins = 60)

## data
ggplot(MFWdat,
       
       ## aesthetic mapping elements
       aes(x=STN_NAME,y=MEAS_VAL)) +
    
    ## color scheme for figure
    theme_bw() +
    
    ## x label
    xlab("") +
    
    ## y label
    ylab("Measured Value (mg/L)") +
    
    ## geometric object(s)
    geom_boxplot() +
    
    ## facets
    facet_wrap(~ WTR_QUAL_PARAM_NM,scales="free_y")

## Parts and pieces
MFWdat[MFWdat$WTR_QUAL_PARAM_NM == "TP-T" & MFWdat$YEAR == "2006",]
MFWdat[MFWdat$WTR_QUAL_PARAM_NM == "TP-T",]
color = STN_NAME
geom_hline(yintercept = 0.055,color = "red")
