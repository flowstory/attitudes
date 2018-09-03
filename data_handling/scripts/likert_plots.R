library(ggplot2)
library(scales)
library(tidyr)
library(HH)
library(dplyr)
library(gridExtra) # also loads grid
library(lattice)
library(latticeExtra)

createLikertDataFrame <- function(column=NULL, display=NULL, levels=NULL, labels=NULL){
  df <- data.frame(matrix(ncol = 0, nrow = length(levels)))
  rownames(df) <- labels
  for (d in display) {
    if(d$g != FALSE){
      selection <- subset(data, (Group==d$g) & (RunId==d$r))
    } else {
      selection <- subset(data, RunId==d$r)
    }
    if (is.null(column)) {
      col <- d$c
    } else {
      col <- column
    }
    freqs <- setNames(nm=c(col,'val'),data.frame(table(factor(selection[,col],levels=levels,exclude=NULL))))
    if(d$g != FALSE){
      df[paste(d$g, d$dR, sep=" ")] <- freqs$val
    } else {
      df[d$dR] <- freqs$val
    }
  }
  df
}

likertPlot <- function(ldf, yL=NULL, xL=NULL, myCols=NULL, aK=NULL, scaleAt=seq(0,100,20), vLines=seq(0,100,10), rZ=0) {
  likert(t(ldf)[,1:nrow(ldf)], horizontal = TRUE, col=myCols,
         main = NULL, # or give "title",
         ReferenceZero = rZ,
         positive.order = FALSE,
         xlab = xL,
         ylab=yL,
         ylab.right=NULL,
         as.percent=TRUE,
         rightAxis = TRUE,
         auto.key = aK,#list(cex=0.9, reverse = FALSE)#NULL #list(reverse = FALSE),
         par.settings.in = list(
           layout.heights =
             list(top.padding = -2),
           axis.line = list(col = 0),
           axis.components=list(
             right=list(pad1=0),
             left=list(pad1=-2),
             bottom=list(pad1=0, pad2=2)
           )),
         scales=list(
           x=list(
             at=scaleAt)),
         panel=function(...){
           panel.abline(v=vLines, col = "lightgray")
           panel.barchart(...)
         }
  )
}

# replace with absolute path of script folder
path <- "C:/Users/johannes/ownCloud/FlowstoryPhD/flowstory_3/github/attitudes/data_handling/scripts"
setwd(path)

data <- read.csv(file="../data_processed/merged_ex1_ex2_ess8_selection.csv", header=TRUE, sep=",")

#DATA CLEANING==================================================

#GENDER
levels <- levels(factor(data$Gender))
levels[length(levels) + 1] <- "3"
data$Gender <- factor(data$Gender, levels = levels)
data$Gender[is.na(data$Gender)] <- 3

#AGE
data$AgeBin<-cut(data$Age, c(0,24,34,44,54,64,100), labels=c(1:6))

# Get levels and add Value for NA
levels <- levels(data$AgeBin)
levels[length(levels) + 1] <- "7"

# refactor AgeBin to include "7" as a factor level
# and replace NA with Value
data$AgeBin <- factor(data$AgeBin, levels = levels)
data$AgeBin[is.na(data$AgeBin)] <- 7

#EDUCATION
data$Education[is.na(data$Education)] <- 5

#INCOME
data$Income[is.na(data$Income)] <- 5

#RELIGION
data$Religiosity[is.na(data$Religiosity)] <- 11

#POLITICS
data$LeftRight[is.na(data$LeftRight)] <- 11

#IM Opp Same
data$IM_PRE_Opposition_Same[is.na(data$IM_PRE_Opposition_Same)] <- 5
data$IM_POST_Opposition_Same[is.na(data$IM_POST_Opposition_Same)] <- 5

#IM Opp Different
data$IM_PRE_Opposition_Different[is.na(data$IM_PRE_Opposition_Different)] <- 5
data$IM_POST_Opposition_Different[is.na(data$IM_POST_Opposition_Different)] <- 5

#IM Opp PoorerInEurope
data$IM_PRE_Opposition_PoorerInEurope[is.na(data$IM_PRE_Opposition_PoorerInEurope)] <- 5
data$IM_POST_Opposition_PoorerInEurope[is.na(data$IM_POST_Opposition_PoorerInEurope)] <- 5

#IM Opp PoorerOutEurope
data$IM_PRE_Opposition_PoorerOutEurope[is.na(data$IM_PRE_Opposition_PoorerOutEurope)] <- 5
data$IM_POST_Opposition_PoorerOutEurope[is.na(data$IM_POST_Opposition_PoorerOutEurope)] <- 5

#IM PT Economic
data$IM_PRE_Economic_Threat[is.na(data$IM_PRE_Economic_Threat)] <- 11
data$IM_POST_Economic_Threat[is.na(data$IM_POST_Economic_Threat)] <- 11

#IM PT Cultural
data$IM_PRE_Cultural_Threat[is.na(data$IM_PRE_Cultural_Threat)] <- 11
data$IM_POST_Cultural_Threat[is.na(data$IM_POST_Cultural_Threat)] <- 11

#IM PT OVerall
data$IM_PRE_Overall_Threat[is.na(data$IM_PRE_Overall_Threat)] <- 11
data$IM_POST_Overall_Threat[is.na(data$IM_POST_Overall_Threat)] <- 11


#PLOTTING==================================================
groups <- list(list(g="empathy", r=1, dR="ex1"),
               list(g="structure", r=1, dR="ex1"),
               list(g="exploration", r=1, dR="ex1"),
               list(g="empathy", r=2, dR="ex2"),
               list(g="structure", r=2, dR="ex2"),
               list(g="exploration", r=2, dR="ex2"),
               list(g=FALSE, r=0, dR="ess"))

#GENDER
ldfGender <- createLikertDataFrame(column="Gender", display=groups, levels=c(1,2,3), labels=c("male","female", "Prefer not to say"))
lpGender <- likertPlot(ldfGender, yL="Gender", xL="Percent of Participants", myCols=c("#67a9cf", "#ef8a62", "#cccccc"), aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"))

#AGE
myCols <- brewer.pal.likert(6, "Blues")
myCols[[length(myCols) + 1 ]] <- "#cccccc"
ldfAge <- createLikertDataFrame(column="AgeBin", display=groups, levels=c(1,2,3,4,5,6,7), labels=c("18-24","25-34","35-44", "45-54", "55-64", "65 or older", "Prefer not to say"))
lpAge <- likertPlot(ldfAge, yL="Age", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"))

#EDUCATION
myCols <- brewer.pal.likert(5, "Blues")
myCols[[length(myCols) + 1 ]] <- "#cccccc"
ldfEducation <- createLikertDataFrame(column="Education", display=groups, levels=c(0,1,2,3,4,5), labels=c("Below Standards","GCSE Level Education","A-Level Education", "Vocational, Degree or Graduate Education", "Post-Graduate Education", "Prefer not to say"))
lpEducation <- likertPlot(ldfEducation, yL="Education", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"))

#INCOME
myCols <- brewer.pal.likert(4, "Blues")
myCols[[length(myCols) + 1 ]] <- "#cccccc"
ldfIncome <- createLikertDataFrame(column="Income", display=groups, levels=c(1,2,3,4,5), labels=c("Finding it very difficult on present income","Finding it difficult on present income","Coping on present income", "Living comfortably on present income", "Prefer not to say"))
lpIncome <- likertPlot(ldfIncome, yL="Income", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"))

#RELIGION
myCols <- rev(likertColorBrewer(11, ReferenceZero=NULL, BrewerPaletteName="RdBu", middle.color="gray90"))
myCols[[length(myCols) + 1 ]] <- "#cccccc"
ldfReligiosity <- createLikertDataFrame(column="Religiosity", display=groups, levels=c(0,1,2,3,4,5,6,7,8,9,10,11), labels=c("not at all religious","1","2","3","4","5","6","7","8","9","very religious","Prefer not to say"))
lpReligiosity <- likertPlot(ldfReligiosity, yL="Religiosity", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"), scaleAt=seq(-80,20,20), vLines=seq(-90,30,10), rZ=6)

#POLITICS
myCols <- rev(likertColorBrewer(11, ReferenceZero=NULL, BrewerPaletteName="RdBu", middle.color="gray90"))
myCols[[length(myCols) + 1 ]] <- "#cccccc"
ldfLeftRight <- createLikertDataFrame(column="LeftRight", display=groups, levels=c(0,1,2,3,4,5,6,7,8,9,10,11), labels=c("left","1","2","3","4","5","6","7","8","9","right","Prefer not to say"))
lpLeftRight <- likertPlot(ldfLeftRight, yL="LeftRight", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"), scaleAt=seq(-60,40,20), vLines=seq(-70,50,10), rZ=6)

#IM Opp Same
groups <- list(list(c="IM_PRE_Opposition_Same", g="empathy", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_Same", g="empathy", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_Same", g="empathy", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Opposition_Same", g="structure", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_Same", g="structure", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_Same", g="structure", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Opposition_Same", g="exploration", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_Same", g="exploration", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_Same", g="exploration", r=2, dR="ex2 post"),
               
               list(c="IM_POST_Opposition_Same", g=FALSE, r=0, dR="ess"))
ldfOppostionSame <- createLikertDataFrame(display=groups, levels=c(1,2,3,4,5), labels=c("Allow many","Allow some","Allow a few", "Allow none", "Prefer not to say"))
myCols <- brewer.pal.likert(4, "Reds")
myCols[[length(myCols) + 1 ]] <- "#cccccc"
lpOppostionSame <- likertPlot(ldfOppostionSame, yL="Opposition Same", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"))

#IM Opp Different
groups <- list(list(c="IM_PRE_Opposition_Different", g="empathy", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_Different", g="empathy", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_Different", g="empathy", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Opposition_Different", g="structure", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_Different", g="structure", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_Different", g="structure", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Opposition_Different", g="exploration", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_Different", g="exploration", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_Different", g="exploration", r=2, dR="ex2 post"),
               
               list(c="IM_POST_Opposition_Different", g=FALSE, r=0, dR="ess"))
ldfOppostionDifferent <- createLikertDataFrame(display=groups, levels=c(1,2,3,4,5), labels=c("Allow many","Allow some","Allow a few", "Allow none", "Prefer not to say"))
myCols <- brewer.pal.likert(4, "Reds")
myCols[[length(myCols) + 1 ]] <- "#cccccc"
lpOppostionDifferent <- likertPlot(ldfOppostionDifferent, yL="Opposition Different", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"))

#IM Opp PoorerInEurope
groups <- list(list(c="IM_PRE_Opposition_PoorerInEurope", g="empathy", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_PoorerInEurope", g="empathy", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_PoorerInEurope", g="empathy", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Opposition_PoorerInEurope", g="structure", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_PoorerInEurope", g="structure", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_PoorerInEurope", g="structure", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Opposition_PoorerInEurope", g="exploration", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_PoorerInEurope", g="exploration", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_PoorerInEurope", g="exploration", r=2, dR="ex2 post"),
               
               list(c="IM_POST_Opposition_PoorerInEurope", g=FALSE, r=0, dR="ess*")) #*Was dropped in ess8
ldfOppostionPoorerInEurope <- createLikertDataFrame(display=groups, levels=c(1,2,3,4,5), labels=c("Allow many","Allow some","Allow a few", "Allow none", "Prefer not to say"))
myCols <- brewer.pal.likert(4, "Reds")
myCols[[length(myCols) + 1 ]] <- "#cccccc"
lpOppostionPoorerInEurope <- likertPlot(ldfOppostionPoorerInEurope, yL="Opposition PoorerInEu", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"))


#IM Opp PoorerOutEurope
groups <- list(list(c="IM_PRE_Opposition_PoorerOutEurope", g="empathy", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_PoorerOutEurope", g="empathy", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_PoorerOutEurope", g="empathy", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Opposition_PoorerOutEurope", g="structure", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_PoorerOutEurope", g="structure", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_PoorerOutEurope", g="structure", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Opposition_PoorerOutEurope", g="exploration", r=1, dR="ex1 pre"),
               list(c="IM_POST_Opposition_PoorerOutEurope", g="exploration", r=1, dR="ex1 post"),
               list(c="IM_POST_Opposition_PoorerOutEurope", g="exploration", r=2, dR="ex2 post"),
               
               list(c="IM_POST_Opposition_PoorerOutEurope", g=FALSE, r=0, dR="ess"))
ldfOppostionPoorerOutEurope <- createLikertDataFrame(display=groups, levels=c(1,2,3,4,5), labels=c("Allow many","Allow some","Allow a few", "Allow none", "Prefer not to say"))
myCols <- brewer.pal.likert(4, "Reds")
myCols[[length(myCols) + 1 ]] <- "#cccccc"
lpOppostionPoorerOutEurope <- likertPlot(ldfOppostionPoorerOutEurope, yL="Opposition PoorerOutEu", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"))


#IM PT Economic
groups <- list(list(c="IM_PRE_Economic_Threat", g="empathy", r=1, dR="ex1 pre"),
               list(c="IM_POST_Economic_Threat", g="empathy", r=1, dR="ex1 post"),
               list(c="IM_POST_Economic_Threat", g="empathy", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Economic_Threat", g="structure", r=1, dR="ex1 pre"),
               list(c="IM_POST_Economic_Threat", g="structure", r=1, dR="ex1 post"),
               list(c="IM_POST_Economic_Threat", g="structure", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Economic_Threat", g="exploration", r=1, dR="ex1 pre"),
               list(c="IM_POST_Economic_Threat", g="exploration", r=1, dR="ex1 post"),
               list(c="IM_POST_Economic_Threat", g="exploration", r=2, dR="ex2 post"),
               
               list(c="IM_POST_Economic_Threat", g=FALSE, r=0, dR="ess"))

myCols <- rev(likertColorBrewer(11, ReferenceZero=NULL, BrewerPaletteName="PiYG", middle.color="gray90"))
myCols[[length(myCols) + 1 ]] <- "#cccccc"
ldfEconomicThreat <- createLikertDataFrame(display=groups, levels=c(0,1,2,3,4,5,6,7,8,9,10,11), labels=c("left","1","2","3","4","5","6","7","8","9","right","Prefer not to say"))
lpEconomicThreat <- likertPlot(ldfEconomicThreat , yL="Economic Threat", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"), scaleAt=seq(-80,60,20), vLines=seq(-80,50,10), rZ=6)


#IM PT Cultural
groups <- list(list(c="IM_PRE_Cultural_Threat", g="empathy", r=1, dR="ex1 pre"),
               list(c="IM_POST_Cultural_Threat", g="empathy", r=1, dR="ex1 post"),
               list(c="IM_POST_Cultural_Threat", g="empathy", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Cultural_Threat", g="structure", r=1, dR="ex1 pre"),
               list(c="IM_POST_Cultural_Threat", g="structure", r=1, dR="ex1 post"),
               list(c="IM_POST_Cultural_Threat", g="structure", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Cultural_Threat", g="exploration", r=1, dR="ex1 pre"),
               list(c="IM_POST_Cultural_Threat", g="exploration", r=1, dR="ex1 post"),
               list(c="IM_POST_Cultural_Threat", g="exploration", r=2, dR="ex2 post"),
               
               list(c="IM_POST_Cultural_Threat", g=FALSE, r=0, dR="ess"))

myCols <- rev(likertColorBrewer(11, ReferenceZero=NULL, BrewerPaletteName="PiYG", middle.color="gray90"))
myCols[[length(myCols) + 1 ]] <- "#cccccc"
ldfCulturalThreat <- createLikertDataFrame(display=groups, levels=c(0,1,2,3,4,5,6,7,8,9,10,11), labels=c("left","1","2","3","4","5","6","7","8","9","right","Prefer not to say"))
lpCulturalThreat <- likertPlot(ldfCulturalThreat , yL="Cultural Threat", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"), scaleAt=seq(-80,60,20), vLines=seq(-80,50,10), rZ=6)


#IM PT OVerall
groups <- list(list(c="IM_PRE_Overall_Threat", g="empathy", r=1, dR="ex1 pre"),
               list(c="IM_POST_Overall_Threat", g="empathy", r=1, dR="ex1 post"),
               list(c="IM_POST_Overall_Threat", g="empathy", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Overall_Threat", g="structure", r=1, dR="ex1 pre"),
               list(c="IM_POST_Overall_Threat", g="structure", r=1, dR="ex1 post"),
               list(c="IM_POST_Overall_Threat", g="structure", r=2, dR="ex2 post"),
               
               list(c="IM_PRE_Overall_Threat", g="exploration", r=1, dR="ex1 pre"),
               list(c="IM_POST_Overall_Threat", g="exploration", r=1, dR="ex1 post"),
               list(c="IM_POST_Overall_Threat", g="exploration", r=2, dR="ex2 post"),
               
               list(c="IM_POST_Overall_Threat", g=FALSE, r=0, dR="ess"))

myCols <- rev(likertColorBrewer(11, ReferenceZero=NULL, BrewerPaletteName="PiYG", middle.color="gray90"))
myCols[[length(myCols) + 1 ]] <- "#cccccc"
ldfOverallThreat <- createLikertDataFrame(display=groups, levels=c(0,1,2,3,4,5,6,7,8,9,10,11), labels=c("left","1","2","3","4","5","6","7","8","9","right","Prefer not to say"))
lpOverallThreat <- likertPlot(ldfOverallThreat , yL="Overall Threat", xL="Percent of Participants", myCols=myCols, aK=list(cex=0.9, reverse = FALSE, columns=1, space="bottom"), scaleAt=seq(-80,60,20), vLines=seq(-80,50,10), rZ=6)




#EXPORT==================================================

pdf("../plots/demographics_likert_gender.pdf", width=6, height=4) 
grid.arrange(lpGender, ncol=1)
dev.off()

pdf("../plots/demographics_likert_age.pdf", width=6, height=4) 
grid.arrange(lpAge, ncol=1)
dev.off()

pdf("../plots/demographics_likert_education.pdf", width=6, height=4) 
grid.arrange(lpEducation, ncol=1)
dev.off()

pdf("../plots/demographics_likert_income.pdf", width=6, height=4) 
grid.arrange(lpIncome, ncol=1)
dev.off()

pdf("../plots/demographics_likert_religiosity.pdf", width=6, height=5) 
grid.arrange(lpReligiosity, ncol=1)
dev.off()

pdf("../plots/demographics_likert_leftright.pdf", width=6, height=5) 
grid.arrange(lpLeftRight, ncol=1)
dev.off()

pdf("../plots/immigration_likert_opposition_same.pdf", width=4, height=5) 
grid.arrange(lpOppostionSame, ncol=1)
dev.off()

pdf("../plots/immigration_likert_opposition_different.pdf", width=4, height=5) 
grid.arrange(lpOppostionDifferent, ncol=1)
dev.off()

pdf("../plots/immigration_likert_opposition_poorer_in_europe.pdf", width=4, height=5) 
grid.arrange(lpOppostionPoorerInEurope, ncol=1)
dev.off()

pdf("../plots/immigration_likert_opposition_poorer_out_europe.pdf", width=4, height=5) 
grid.arrange(lpOppostionPoorerOutEurope, ncol=1)
dev.off()

pdf("../plots/immigration_likert_perceived_threat_economic.pdf", width=5, height=5) 
grid.arrange(lpEconomicThreat, ncol=1)
dev.off()

pdf("../plots/immigration_likert_perceived_threat_cultural.pdf", width=5, height=5) 
grid.arrange(lpCulturalThreat, ncol=1)
dev.off()

pdf("../plots/immigration_likert_perceived_threat_overall.pdf", width=5, height=5) 
grid.arrange(lpOverallThreat, ncol=1)
dev.off()