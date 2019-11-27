## Required packages
library(tidyr)

library(reshape2)    ## melt()
library(ggplot2)     ## ggplot()
library(scales)      ## date_format()
library(lubridate)   ## month()


## Load data
## This is a data frame called Ap_Rain with the following structure:
## date:        in Date format
## MFWRain:     Rain in inches at the Lake Apopka Marsh Flow-Way,
##              Hydron ID 18483113, Lake Apopka MFW B2 In at Astatula (RN)
##              Lat:28.67143722 Long:-81.67500639
## Ph2Rain:     Rain in inches at the Lake Apopka North Shore Restoration Area, Phase 2
##              Hydron ID 32614059, NSRA Phase 2 S (RN)
##              Lat:28.64873611 Long:81.57536111 
## ET:          Evapotranspiration in inches from the Apopka IFAS FAWN station
##              Hydron ID 32564045, Apopka - IFAS Fawn (WS) 
##              Lat:28.63771 Long:81.54675 Elev:32.61
load("./DataFiles/Apopka_Rain.RData")

## View data
View(Ap_Rain)

## Transpose the data to single record per line (wide to long format)
df.long <- melt(Ap_Rain,id.vars = "date")

## View newly formatted data
View(df.long)

## Designate the order for the variables
df.long$variable <- factor(df.long$variable,
                           levels=c("ET","MFWRain","Ph2Rain"))

## Create a field that holds the rainfall if it exceeds 2 inches
df.long$High <- sapply(df.long$value,
                       function(x) ifelse(x > 2,x,NA))

## Define a vector that defines the date breaks for the x axis
break.vec <- c(min(df.long$date),
               seq(from=min(df.long$date)+2,
                   to=max(df.long$date)-1,
                   by="2 days"))

## Define variables related to the time period this dataset is covering
start <- min(df.long$date)
end <- max(df.long$date)
lastmonth <- ifelse(month(Sys.Date())==1,
                    12,
                    month(Sys.Date())-1)
monthname <- format(Sys.Date()-28,"%B")
thisyear <- ifelse(lastmonth == 12,
                   format(Sys.Date()-15, "%Y"),
                   format(Sys.Date(),"%Y"))

## Data and aesthetic mapping
p <- ggplot(df.long,aes(x=date,
                        y=value,
                        group=variable,
                        color=variable)) ; p
    
## Geometric object: stairstep plot
p <- p + geom_step(aes(size=variable)) ; p

## Change to a black and white theme
p <- p + theme_bw() ; p

## Change other sizing and design components
p <- p + theme(axis.text=element_text(face="bold",size=11),
               axis.title=element_text(face="bold",size=17),
               legend.title=element_blank(),
               legend.text=element_text(face="bold",size=14),
               legend.position="top",
               title=element_text(face="bold",size=20),
               axis.text.x=element_text(hjust=.1)) ; p

## Set the x-axis labels for every other day starting on the first
## day of the month
p <- p + scale_x_date(breaks=break.vec,
                      limits=c(start,end),
                      expand=c(0,0),
                      labels=date_format("%b %d")) ; p

## Set the y limits to range from 0 to 2 (with a little buffer)
## Note that coord_cartesian is required here if you want to show data
## that goes outside the limits
p <- p + coord_cartesian(ylim = c(-0.1,2.1)) ; p

## Remove the x label
p <- p + xlab("") ; p

## Add a more informative y label
p <- p + ylab("Rainfall or Evapotranspiration (in)") ; p

## Change the colors and the labels for each line
p <- p + scale_colour_manual(values=c("black","blue","red"),
                             labels=c("Evapotranspiration",
                                      "Rain at Marsh Flow-Way B2",
                                      "Rain at NSRA Phase 2")) ; p

## Change the size of the lines on the plot
p <- p + scale_size_manual(values=c(1.6,1.4,1.4),guide="none") ; p

## Change the size of the lines in the legend
p <- p + guides(colour=guide_legend(override.aes=list(size=1.4))) ; p

## Add text when the rainfall exceeds 2 inches
p <- p + geom_text(aes(x=date+.5,
                       y=2.0,
                       label=ifelse(is.na(High),"",High),
                       group=variable,
                       colour=variable,
                       fontface="bold"),
                   size=3.5) ; p

## Add a title
p <- p + ggtitle(paste(monthname,
                       thisyear,
                       "Rainfall at Lake Apopka")) ; p





p <- ggplot(df.long,aes(x=date,y=value,group=variable,colour=variable,size=variable)) +
    geom_step(aes(x=date,y=value,group=variable,colour=variable)) +
    theme_bw() +
    theme(axis.text=element_text(face="bold",size=11),
          axis.title=element_text(face="bold",size=17),
          legend.title=element_blank(),
          legend.text=element_text(face="bold",size=14),
          legend.position="top",
          title=element_text(face="bold",size=20),
          axis.text.x=element_text(hjust=.1)) +
    scale_x_date(breaks=break.vec,
                 limits=c(min(df.long$date),max(df.long$date)),expand=c(0,0),
                 labels=date_format("%b %d")) +
    coord_cartesian(ylim = c(-0.1,2.1)) +
    xlab("") +
    ylab("Rainfall or Evapotranspiration (in)") +
    scale_colour_manual(values=c("black","blue","red"),
                        labels=c("Evapotranspiration",
                                 "Rain at Marsh Flow-Way B2",
                                 "Rain at NSRA Phase 2")) +
    scale_size_manual(values=c(1.6,1.4,1.4),guide="none") +
    #ggtitle(paste(monthname,thisyear,"Rainfall at Lake Apopka")) +
    guides(colour=guide_legend(override.aes=list(size=1.4))) +
    geom_text(aes(x=date+.5,y=2.0,label=ifelse(is.na(High),"",High),
                  group=variable,colour=variable,fontface="bold"),size=3.5)
p

## Remove created objects (housekeeping)
rm(break.vec,end,lastmonth,monthname,start,thisyear,Ap_Rain,df.long,p)