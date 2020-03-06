# Charles Perin, Johannes Liem

path <- "C:/data/cumulus/phd/flowstory_3_attitudes/github/attitudes/data_handling/scripts"

dependencies <- c("bootstrap_macros.r","plotting.r")

file <- "../data_processed/merged_ex1_ex2_ess8_selection.csv"

setwd(path)

#dependencies
for(dep in dependencies){
	source(dep)
}

# Make the code deterministic
set.seed(0)

# Define the median/mean as the statistic of interest
sampleStat <- samplemean

# Use many replicates
replicates <- 10000

#--------------------------------RAW DATA--------------------------------

#--------------------------------PARSE DATA AND FORMAT CLEAN TABLE-----------------------------------
conditions_ordered <- c("ess", "exploration", "empathy", "structure")

rawdata <- read.table(file, header=TRUE, sep=",", na.strings=c("NA"))
data <- data.frame(rawdata)

# SCALING 0..1 + CALC DELTA

# DEMOGRAPHICS

# Education
data$Education_N <- rescale(data$Education, to=c(0,1), from=c(0,4))
  
# Income
data$Income_N <- rescale(data$Income, to=c(0,1), from=c(1,4))
  
# Religiosity
data$Religiosity_N <- rescale(data$Religiosity, to=c(0,1), from=c(0,10))

# Politics (LeftRight)
data$LeftRight_N <- rescale(data$LeftRight, to=c(0,1), from=c(0,10))
  
# HUMAN VALUES

data$HV_OpennessToChange_N <- rescale(data$HV_OpennessToChange, to=c(0,1), from=c(0,6))
data$HV_Conservation_N <- rescale(data$HV_Conservation, to=c(0,1), from=c(0,6))
data$HV_SelfTranscendence_N <- rescale(data$HV_SelfTranscendence, to=c(0,1), from=c(0,6))
data$HV_SelfEnhancement_N <- rescale(data$HV_SelfEnhancement, to=c(0,1), from=c(0,6))

data$HV_Dimension_Open_N <- data$HV_OpennessToChange_N - data$HV_Conservation_N
data$HV_Dimension_Self_N <- data$HV_SelfTranscendence_N - data$HV_SelfEnhancement_N


# IMMIGRATION

# Opposition Mean
data$IM_PRE_Opposition_Mean_N <- rescale(data$IM_PRE_Opposition_Mean, to=c(0,1), from=c(1,4))
data$IM_POST_Opposition_Mean_N <- rescale(data$IM_POST_Opposition_Mean, to=c(0,1), from=c(1,4))
data$IM_DELTA_Opposition_Mean_N <- data$IM_POST_Opposition_Mean_N - data$IM_PRE_Opposition_Mean_N

data$IM_PRE_Opposition3_Mean_N <- rescale(data$IM_PRE_Opposition3_Mean, to=c(0,1), from=c(1,4))
data$IM_POST_Opposition3_Mean_N <- rescale(data$IM_POST_Opposition3_Mean, to=c(0,1), from=c(1,4))
data$IM_DELTA_Opposition3_Mean_N <- data$IM_POST_Opposition3_Mean_N - data$IM_PRE_Opposition3_Mean_N

# Perceived Threat Mean
data$IM_PRE_PerceivedThreat_Mean_N <- rescale(data$IM_PRE_PerceivedThreat_Mean, to=c(0,1), from=c(0,10))
data$IM_POST_PerceivedThreat_Mean_N <- rescale(data$IM_POST_PerceivedThreat_Mean, to=c(0,1), from=c(0,10))
data$IM_DELTA_PerceivedThreat_Mean_N <- data$IM_POST_PerceivedThreat_Mean_N - data$IM_PRE_PerceivedThreat_Mean_N

# Groups for Exploratory
# Gender 1, 2
# Age min-34, 35-54, 55-max (Thirds)
#data <- transform(data, AgeGroup = ifelse(Age <= 34, 1, (ifelse(Age >= 55, 3, 2))))
data <- transform(data, AgeGroup = ifelse(Age <= 30, 1, (ifelse(Age >= 45, 3, 2))))

#Education (lo = 1 (from 0-2); hi = 2 (from 3-4))
data <- transform(data, EducationGroup = ifelse(Education <= 2, 1, 2))

# Income (difficult = 1, coping = 2, comfortably = 3)
data <- transform(data, IncomeGroup = ifelse(Income <= 2, 1, ifelse(Income == 3, 2, 3)))

# Religion
data <- transform(data, ReligiosityGroup = ifelse(Religiosity_N < 0.5, -1, ifelse(Religiosity_N > 0.5, 1, 0)))
#data <- transform(data, ReligiosityGroup = ifelse(Religiosity == 0, -1, ifelse(Religiosity >= 2, 1, 0)))
data <- transform(data, ReligiosityGroup = ifelse((RunId == 1) & (Religiosity_N <= 0.0), -1,
                                              ifelse((RunId == 1) & (Religiosity_N >= 0.3), 1,
                                                     ifelse((RunId == 2) & (Religiosity_N <= 0.0), -1,
                                                            ifelse((RunId == 2) & (Religiosity_N >= 0.2), 1,
                                                                   ifelse((RunId == 0) & (Religiosity_N <= 0.1), -1,
                                                                          ifelse((RunId == 0) & (Religiosity_N >= 0.5), 1, 0)))))))

# Politics
data <- transform(data, LeftRightGroup = ifelse(LeftRight_N < 0.5, -1, ifelse(LeftRight_N > 0.5, 1, 0)))

# Dim Open
data <- transform(data, DimOpenGroup = ifelse(HV_Dimension_Open_N < 0, -1, ifelse(HV_Dimension_Open_N > 0, 1, 0)))

# Dim Self
data <- transform(data, DimSelfGroup = ifelse(HV_Dimension_Self_N < 0, -1, ifelse(HV_Dimension_Self_N > 0, 1, 0)))
data <- transform(data, DimSelfGroup = ifelse((RunId == 1) & (HV_Dimension_Self_N <= 0.1896667), -1,
                                       ifelse((RunId == 1) & (HV_Dimension_Self_N >= 0.3250000), 1,
                                       ifelse((RunId == 2) & (HV_Dimension_Self_N <= 0.1333333), -1,
                                       ifelse((RunId == 2) & (HV_Dimension_Self_N >= 0.3288333), 1,
                                       ifelse((RunId == 0) & (HV_Dimension_Self_N <= 0.1916667), -1,
                                       ifelse((RunId == 0) & (HV_Dimension_Self_N >= 0.3416667), 1, 0)))))))


data <- transform(data, OTCGroup = ifelse((RunId == 1) & (HV_OpennessToChange_N <= 0.5833333), -1,
                                              ifelse((RunId == 1) & (HV_OpennessToChange_N >= 0.6944444), 1,
                                                     ifelse((RunId == 2) & (HV_OpennessToChange_N <= 0.5555556), -1,
                                                            ifelse((RunId == 2) & (HV_OpennessToChange_N >= 0.7500000), 1,
                                                                   ifelse((RunId == 0) & (HV_OpennessToChange_N <= 0.6111111), -1,
                                                                          ifelse((RunId == 0) & (HV_OpennessToChange_N >= 0.7222222), 1, 0)))))))

data <- transform(data, CONGroup = ifelse((RunId == 1) & (HV_Conservation_N <= 0.6111111), -1,
                                          ifelse((RunId == 1) & (HV_Conservation_N >= 0.7500000), 1,
                                                 ifelse((RunId == 2) & (HV_Conservation_N <= 0.5992500), -1,
                                                        ifelse((RunId == 2) & (HV_Conservation_N >= 0.6666667), 1,
                                                               ifelse((RunId == 0) & (HV_Conservation_N <= 0.6388889), -1,
                                                                      ifelse((RunId == 0) & (HV_Conservation_N >= 0.7777778), 1, 0)))))))

data <- transform(data, STRGroup = ifelse((RunId == 1) & (HV_SelfTranscendence_N <= 0.7333333), -1,
                                          ifelse((RunId == 1) & (HV_SelfTranscendence_N >= 0.8666667), 1,
                                                 ifelse((RunId == 2) & (HV_SelfTranscendence_N <= 0.7333333), -1,
                                                        ifelse((RunId == 2) & (HV_SelfTranscendence_N >= 0.8333333), 1,
                                                               ifelse((RunId == 0) & (HV_SelfTranscendence_N <= 0.7666667), -1,
                                                                      ifelse((RunId == 0) & (HV_SelfTranscendence_N >= 0.8666667), 1, 0)))))))

data <- transform(data, SENGroup = ifelse((RunId == 1) & (HV_SelfEnhancement_N <= 0.4583333), -1,
                                          ifelse((RunId == 1) & (HV_SelfEnhancement_N >= 0.5833333), 1,
                                                 ifelse((RunId == 2) & (HV_SelfEnhancement_N <= 0.4583333), -1,
                                                        ifelse((RunId == 2) & (HV_SelfEnhancement_N >= 0.6250000), 1,
                                                               ifelse((RunId == 0) & (HV_SelfEnhancement_N <= 0.4583333), -1,
                                                                      ifelse((RunId == 0) & (HV_SelfEnhancement_N >= 0.6250000), 1, 0)))))))

# time
data <- transform(data, endtime =  as.numeric(substr(EndDate, 12, 13)) + (as.numeric(substr(EndDate, 15, 16))/60))

#MEDIAN
#data <- transform(data, TimeGroup = ifelse((RunId == 1) & (endtime < 15.17), -1, ifelse((RunId == 1) & (endtime >= 15.17), 1, ifelse((RunId == 2) & (endtime < 17), -1, 1))))
#Lower vs Upper Quartile
#data <- transform(data, TimeGroup = ifelse((RunId == 1) & (endtime <= 14.75), -1, ifelse((RunId == 1) & (endtime >= 15.52), 1, ifelse((RunId == 2) & (endtime <= 16.60), -1, ifelse((RunId == 2) & (endtime > 17.20), 1, 0)))))
# Lower vs Upper Third
data <- transform(data, TimeGroup = ifelse((RunId == 1) & (endtime <= 14.90000), -1, ifelse((RunId == 1) & (endtime >= 15.43333), 1, ifelse((RunId == 2) & (endtime <= 16.76667), -1, ifelse((RunId == 2) & (endtime >= 17.13333), 1, 0)))))




data$Group <- as.factor(data$Group)
data$ResponseId = as.factor(data$ResponseId)
data$condition = as.factor(data$Group)

print(nrow(data))

dataEx <- subset(data, (RunId > 0) )
dataEx1 <- subset(data, (RunId == 1) )
dataEx2 <- subset(data, (RunId == 2) )
dataEss <- subset(data, (RunId == 0) )
#--------------------------------END DATA PREP--------------------------------

plotMeasure <- function(toPlot, title, measurefactor,isLog,minplot,maxplot,formatter, myColors=NULL, w=8, h=2, dstFile="plot") {
		ci_mean <- NULL
		ci_min <- NULL
		ci_max <- NULL
		c_condition <- NULL
		c_measure <- NULL
		c_conditionXmeasure <- NULL
		c_label <- NULL
		c_run <- NULL
		c_color <- NULL
		conditions_ordered_Delta <- NULL
		
		for (tP in toPlot) {
		  data_run <- subset(data, RunId == tP$run)
			condition_data <- subset(data_run, condition == tP$condition)
			if ("filter" %in% names(tP)) {
			  if (tP$filter == "gender") {
			    filter_data <- subset(condition_data, Gender == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "age"){
			    filter_data <- subset(condition_data, AgeGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "education"){
			    filter_data <- subset(condition_data, EducationGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "income"){
			    filter_data <- subset(condition_data, IncomeGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "religiosity"){
			    filter_data <- subset(condition_data, ReligiosityGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "leftright"){
			    filter_data <- subset(condition_data, LeftRightGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "open"){
			    filter_data <- subset(condition_data, DimOpenGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "self"){
			    filter_data <- subset(condition_data, DimSelfGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "region"){
			    filter_data <- subset(condition_data, Region == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "time"){
			    filter_data <- subset(condition_data, TimeGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "otc"){
			    filter_data <- subset(condition_data, OTCGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "con"){
			    filter_data <- subset(condition_data, CONGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "str"){
			    filter_data <- subset(condition_data, STRGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else if(tP$filter == "sen"){
			    filter_data <- subset(condition_data, SENGroup == tP$fValue)
			    values <- filter_data[[tP$measure]]
			  } else {
			    values <- condition_data[[tP$measure]]
			  }
			} else {
			  values <- condition_data[[tP$measure]]
			}
			
			#filer NA values
			values <- values[!is.na(values)]
			
			
			dataN = length(values)
			print(dataN)
			
			bootstraped_mean <- bootstrapCI(sampleStat,values)
			
			if(isLog){#Go back to seconds 
				bootstraped_mean <- exp(bootstraped_mean)
			}
			
			ci_mean <- append(ci_mean, bootstraped_mean[1])
			ci_min <- append(ci_min, bootstraped_mean[2])
			ci_max <- append(ci_max, bootstraped_mean[3])
			c_condition <- append(c_condition, tP$condition)
			c_measure <- append(c_measure, tP$measure)
			c_run <- append(c_run, tP$run)
			c_label <- append(	c_label, tP$order)
		 
		}
		
		analysis <- data.frame(
		  c_run,
			factor(c_condition, levels = conditions_ordered), # reorder factors
			c_measure, ci_mean, ci_min, ci_max, c_label)
		
		colnames(analysis) <- c("run", "condition", "measure","pointEstimate", "ci.min", "ci.max", "label")
		print(analysis)
		#hplot(analysis, title, "", "label", minplot, maxplot, formatter, png=paste(title,".png",sep=""), pdf=paste(title,".pdf",sep=""))
		hplotNoLabels(analysis, title, "", "label", minplot, maxplot, formatter, pdf=paste(dstFile,"NoLabels.pdf",sep="_"), width=w, height=h, cbbPalette = myColors)
  cat(paste("\n-----DONE-----\n"))
}




# By Gender
# original: male = 1 female = 2

# opposition
# experiment 1
# empathy
m1_male <- list(order = "T", run = 1, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_male <- list(order = "S", run = 1, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m1_female <- list(order = "R", run = 1, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m2_female <- list(order = "Q", run = 1, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

# structure
m4_male <- list(order = "P", run = 1, condition = 'structure', filter="gender", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m5_male  <- list(order = "O", run = 1, condition = 'structure', filter="gender", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m4_female <- list(order = "N", run = 1, condition = 'structure', filter="gender", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')	
m5_female  <- list(order = "M", run = 1, condition = 'structure', filter="gender", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

# exploration
m7_male <- list(order = "L", run = 1, condition = 'exploration', filter="gender", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_male <- list(order = "K", run = 1, condition = 'exploration', filter="gender", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m7_female <- list(order = "J", run = 1, condition = 'exploration', filter="gender", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m8_female <- list(order = "I", run = 1, condition = 'exploration', filter="gender", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

# experiment 2
# empathy
m3_male <- list(order = "H", run = 2, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m3_female <- list(order = "G", run = 2, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

# structure
m6_male  <- list(order = "F", run = 2, condition = 'structure', filter="gender", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m6_female  <- list(order = "E", run = 2, condition = 'structure', filter="gender", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

# exploration
m9_male <- list(order = "D", run = 2, condition = 'exploration', filter="gender", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m9_female <- list(order = "C", run = 2, condition = 'exploration', filter="gender", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

#ess
m10_male <- list(order = "B", run = 0, condition = 'ess', filter="gender", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m10_female <- list(order = "A", run = 0, condition = 'ess', filter="gender", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

fc <- "#ef8960"
mc <- "#67a8ce"
m <- list(m1_male, m2_male, m1_female, m2_female, m4_male, m5_male, m4_female, m5_female, m7_male, m8_male, m7_female, m8_female, m3_male, m3_female, m6_male, m6_female, m9_male, m9_female, m10_male, m10_female)
mycolors <- c(fc, mc, fc, mc, fc, mc, fc, mc, fc, fc, mc, mc, fc, fc, mc, mc, fc, fc, mc, mc)
plotMeasure(m,"opposition by gender",100,FALSE,0.2,0.6,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_opposition_by_gender")


# perceivt threat
# experiment 1
# empathy
m1_male <- list(order = "T", run = 1, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_male <- list(order = "S", run = 1, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m1_female <- list(order = "R", run = 1, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_female <- list(order = "Q", run = 1, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

# sturcture
m4_male <- list(order = "P", run = 1, condition = 'structure', filter="gender", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_male  <- list(order = "O", run = 1, condition = 'structure', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m4_female <- list(order = "N", run = 1, condition = 'structure', filter="gender", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')	
m5_female  <- list(order = "M", run = 1, condition = 'structure', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

# exploration
m7_male <- list(order = "L", run = 1, condition = 'exploration', filter="gender", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_male <- list(order = "K", run = 1, condition = 'exploration', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m7_female <- list(order = "J", run = 1, condition = 'exploration', filter="gender", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_female <- list(order = "I", run = 1, condition = 'exploration', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

# experiment 2
# empathy
m3_male <- list(order = "H", run = 2, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_female <- list(order = "G", run = 2, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

# sturcture
m6_male  <- list(order = "F", run = 2, condition = 'structure', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_female  <- list(order = "E", run = 2, condition = 'structure', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

# exploration
m9_male <- list(order = "D", run = 2, condition = 'exploration', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_female <- list(order = "C", run = 2, condition = 'exploration', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

# ess
m10_male <- list(order = "B", run = 0, condition = 'ess', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_female <- list(order = "A", run = 0, condition = 'ess', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

fc <- "#ef8960"
mc <- "#67a8ce"
m <- list(m1_male, m2_male, m1_female, m2_female, m4_male, m5_male, m4_female, m5_female, m7_male, m8_male, m7_female, m8_female, m3_male, m3_female, m6_male, m6_female, m9_male, m9_female, m10_male, m10_female)
mycolors <- c(fc, mc, fc, mc, fc, mc, fc, mc, fc, fc, mc, mc, fc, fc, mc, mc, fc, fc, mc, mc)
plotMeasure(m,"opposition by gender",100,FALSE,0.2,0.6,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_by_gender")


# opposition pre post
m1_male <- list(order = "F",run = 1, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_female <- list(order = "E",run = 1, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_male <- list(order = "D",run = 1, condition = 'structure', filter="gender", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_female <- list(order = "C",run = 1, condition = 'structure', filter="gender", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_male <- list(order = "B",run = 1, condition = 'exploration', filter="gender", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_female <- list(order = "A",run = 1, condition = 'exploration', filter="gender", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m <- list(m1_male, m1_female, m2_male, m2_female, m3_male, m3_female)
mycolors <- c('#f0bca8', "#a5bfcf", '#f0bca8', "#a5bfcf", '#f0bca8', '#a5bfcf')
plotMeasure(m, "opposition by gender delta", 100,FALSE,-0.04,0.04,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_gender")


# perceived threat pre post
m1_male <- list(order = "F",run = 1, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_female <- list(order = "E",run = 1, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_male <- list(order = "D",run = 1, condition = 'structure', filter="gender", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_female <- list(order = "C",run = 1, condition = 'structure', filter="gender", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_male <- list(order = "B",run = 1, condition = 'exploration', filter="gender", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_female <- list(order = "A",run = 1, condition = 'exploration', filter="gender", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m <- list(m1_male, m1_female, m2_male, m2_female, m3_male, m3_female)
mycolors <- c('#f0bca8', "#a5bfcf", '#f0bca8', "#a5bfcf", '#f0bca8', '#a5bfcf')
plotMeasure(m, "perceived threat by gender delta", 100,FALSE,-0.04,0.04,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_gender")

# By Age
# original 1: age in years
# original 2: age groups (min-34, 35-54, 55-max)
# opposition
# empathy
m1_young <- list(order = "ZD", run = 1, condition = 'empathy', filter="age", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_young <- list(order = "ZC", run = 1, condition = 'empathy', filter="age", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m1_middle <- list(order = "ZB", run = 1, condition = 'empathy', filter="age", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m2_middle <- list(order = "ZA", run = 1, condition = 'empathy', filter="age", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m1_old <- list(order = "Z", run = 1, condition = 'empathy', filter="age", fValue=3, measure = 'IM_PRE_Opposition3_Mean_N')
m2_old <- list(order = "Y", run = 1, condition = 'empathy', filter="age", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

# structure
m4_young <- list(order = "X", run = 1, condition = 'structure', filter="age", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m5_young <- list(order = "W", run = 1, condition = 'structure', filter="age", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m4_middle <- list(order = "V", run = 1, condition = 'structure', filter="age", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m5_middle  <- list(order = "U", run = 1, condition = 'structure', filter="age", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m4_old <- list(order = "T", run = 1, condition = 'structure', filter="age", fValue=3, measure = 'IM_PRE_Opposition3_Mean_N')
m5_old  <- list(order = "S", run = 1, condition = 'structure', filter="age", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

# exploration
m7_young <- list(order = "R", run = 1, condition = 'exploration', filter="age", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_young <- list(order = "Q", run = 1, condition = 'exploration', filter="age", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m7_middle <- list(order = "P", run = 1, condition = 'exploration', filter="age", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m8_middle <- list(order = "O", run = 1, condition = 'exploration', filter="age", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m7_old <- list(order = "N", run = 1, condition = 'exploration', filter="age", fValue=3, measure = 'IM_PRE_Opposition3_Mean_N')
m8_old <- list(order = "M", run = 1, condition = 'exploration', filter="age", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

m3_young <- list(order = "L", run = 2, condition = 'empathy', filter="age", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m3_middle <- list(order = "K", run = 2, condition = 'empathy', filter="age", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')
m3_old <- list(order = "J", run = 2, condition = 'empathy', filter="age", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

m6_young  <- list(order = "I", run = 2, condition = 'structure', filter="age", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m6_middle  <- list(order = "H", run = 2, condition = 'structure', filter="age", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')
m6_old  <- list(order = "G", run = 2, condition = 'structure', filter="age", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

m9_young <- list(order = "F", run = 2, condition = 'exploration', filter="age", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m9_middle <- list(order = "E", run = 2, condition = 'exploration', filter="age", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')
m9_old <- list(order = "D", run = 2, condition = 'exploration', filter="age", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

# ess
m10_young <- list(order = "C", run = 0, condition = 'ess', filter="age", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m10_middle <- list(order = "B", run = 0, condition = 'ess', filter="age", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')
m10_old <- list(order = "A", run = 0, condition = 'ess', filter="age", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

m <- list(
  m1_young, m2_young, m1_middle, m2_middle, m1_old, m2_old,
  m4_young, m5_young, m4_middle, m5_middle, m4_old, m5_old,
  m7_young, m8_young, m7_middle, m8_middle, m7_old, m8_old,
  m3_young, m3_middle, m3_old,
  m6_young, m6_middle, m6_old,
  m9_young, m9_middle, m9_old,
  m10_young, m10_middle, m10_old
)
yc <- "#c6dbed"
mc <- "#6aadd5"
oc <- "#06529c"
mycolors <- c(
  oc, mc, yc,
  oc, mc, yc,
  oc, mc, yc,
  oc, mc, yc,
  oc, oc, mc, mc, yc, yc,
  oc, oc, mc, mc, yc, yc,
  oc, oc, mc, mc, yc, yc
)
plotMeasure(m,"opposition by age",100,FALSE,0.16,0.6,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_opposition_by_age")

# perceived threat
# empathy
m1_young <- list(order = "ZD", run = 1, condition = 'empathy', filter="age", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_young <- list(order = "ZC", run = 1, condition = 'empathy', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_middle <- list(order = "ZB", run = 1, condition = 'empathy', filter="age", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_middle <- list(order = "ZA", run = 1, condition = 'empathy', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_old <- list(order = "Z", run = 1, condition = 'empathy', filter="age", fValue=3, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_old <- list(order = "Y", run = 1, condition = 'empathy', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

# structure
m4_young <- list(order = "X", run = 1, condition = 'structure', filter="age", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_young <- list(order = "W", run = 1, condition = 'structure', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_middle <- list(order = "V", run = 1, condition = 'structure', filter="age", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_middle  <- list(order = "U", run = 1, condition = 'structure', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_old <- list(order = "T", run = 1, condition = 'structure', filter="age", fValue=3, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_old  <- list(order = "S", run = 1, condition = 'structure', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

# exploration
m7_young <- list(order = "R", run = 1, condition = 'exploration', filter="age", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_young <- list(order = "Q", run = 1, condition = 'exploration', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_middle <- list(order = "P", run = 1, condition = 'exploration', filter="age", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_middle <- list(order = "O", run = 1, condition = 'exploration', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_old <- list(order = "N", run = 1, condition = 'exploration', filter="age", fValue=3, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_old <- list(order = "M", run = 1, condition = 'exploration', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m3_young <- list(order = "L", run = 2, condition = 'empathy', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_middle <- list(order = "K", run = 2, condition = 'empathy', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_old <- list(order = "J", run = 2, condition = 'empathy', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_young  <- list(order = "I", run = 2, condition = 'structure', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_middle  <- list(order = "H", run = 2, condition = 'structure', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_old  <- list(order = "G", run = 2, condition = 'structure', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_young <- list(order = "F", run = 2, condition = 'exploration', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_middle <- list(order = "E", run = 2, condition = 'exploration', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_old <- list(order = "D", run = 2, condition = 'exploration', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

# ess
m10_young <- list(order = "C", run = 0, condition = 'ess', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_middle <- list(order = "B", run = 0, condition = 'ess', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_old <- list(order = "A", run = 0, condition = 'ess', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m1_young, m2_young, m1_middle, m2_middle, m1_old, m2_old,
  m4_young, m5_young, m4_middle, m5_middle, m4_old, m5_old,
  m7_young, m8_young, m7_middle, m8_middle, m7_old, m8_old,
  m3_young, m3_middle, m3_old,
  m6_young, m6_middle, m6_old,
  m9_young, m9_middle, m9_old,
  m10_young, m10_middle, m10_old
)
yc <- "#c6dbed"
mc <- "#6aadd5"
oc <- "#06529c"
mycolors <- c(
  oc, mc, yc,
  oc, mc, yc,
  oc, mc, yc,
  oc, mc, yc,
  oc, oc, mc, mc, yc, yc,
  oc, oc, mc, mc, yc, yc,
  oc, oc, mc, mc, yc, yc
)
plotMeasure(m,"perceived threat by age",100,FALSE,0.16,0.6,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_by_age")

# opposition pre post
m1_young <- list(order = "I",run = 1, condition = 'empathy', filter="age", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_middle <- list(order = "H",run = 1, condition = 'empathy', filter="age", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_old <- list(order = "G",run = 1, condition = 'empathy', filter="age", fValue=3, measure = 'IM_DELTA_Opposition3_Mean_N')

m2_young <- list(order = "F",run = 1, condition = 'structure', filter="age", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_middle <- list(order = "E",run = 1, condition = 'structure', filter="age", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_old <- list(order = "D",run = 1, condition = 'structure', filter="age", fValue=3, measure = 'IM_DELTA_Opposition3_Mean_N')

m3_young <- list(order = "C",run = 1, condition = 'exploration', filter="age", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_middle <- list(order = "B",run = 1, condition = 'exploration', filter="age", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_old <- list(order = "A",run = 1, condition = 'exploration', filter="age", fValue=3, measure = 'IM_DELTA_Opposition3_Mean_N')

m <- list(
  m1_young, m1_middle, m1_old,
  m2_young, m2_middle, m2_old,
  m3_young, m3_middle, m3_old
)
mycolors <- c(
  "#06529c", "#6aadd5", "#c6dbed",
  "#06529c", "#6aadd5", "#c6dbed",
  "#06529c", "#6aadd5", "#c6dbed"
)
plotMeasure(m, "opposition by age delta", 100,FALSE,-0.06,0.08,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_age")


# perceived threat pre post
m1_young <- list(order = "I",run = 1, condition = 'empathy', filter="age", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_middle <- list(order = "H",run = 1, condition = 'empathy', filter="age", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_old <- list(order = "G",run = 1, condition = 'empathy', filter="age", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_young <- list(order = "F",run = 1, condition = 'structure', filter="age", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_middle <- list(order = "E",run = 1, condition = 'structure', filter="age", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_old <- list(order = "D",run = 1, condition = 'structure', filter="age", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m3_young <- list(order = "C",run = 1, condition = 'exploration', filter="age", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_middle <- list(order = "B",run = 1, condition = 'exploration', filter="age", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_old <- list(order = "A",run = 1, condition = 'exploration', filter="age", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_young, m1_middle, m1_old,
  m2_young, m2_middle, m2_old,
  m3_young, m3_middle, m3_old
)
mycolors <- c(
  "#06529c", "#6aadd5", "#c6dbed",
  "#06529c", "#6aadd5", "#c6dbed",
  "#06529c", "#6aadd5", "#c6dbed"
)
plotMeasure(m, "perceived threat by age delta", 100,FALSE,-0.06,0.08,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_age")


#By Education
# opposition
m1_lo <- list(order = "T", run = 1, condition = 'empathy', filter="education", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_lo <- list(order = "S", run = 1, condition = 'empathy', filter="education", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m1_hi <- list(order = "R", run = 1, condition = 'empathy', filter="education", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m2_hi <- list(order = "Q", run = 1, condition = 'empathy', filter="education", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m4_lo <- list(order = "P", run = 1, condition = 'structure', filter="education", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m5_lo  <- list(order = "O", run = 1, condition = 'structure', filter="education", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m4_hi <- list(order = "N", run = 1, condition = 'structure', filter="education", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')	
m5_hi  <- list(order = "M", run = 1, condition = 'structure', filter="education", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m7_lo <- list(order = "L", run = 1, condition = 'exploration', filter="education", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_lo <- list(order = "K", run = 1, condition = 'exploration', filter="education", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m7_hi <- list(order = "J", run = 1, condition = 'exploration', filter="education", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m8_hi <- list(order = "I", run = 1, condition = 'exploration', filter="education", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m3_lo <- list(order = "H", run = 2, condition = 'empathy', filter="education", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m3_hi <- list(order = "G", run = 2, condition = 'empathy', filter="education", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m6_lo  <- list(order = "F", run = 2, condition = 'structure', filter="education", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m6_hi  <- list(order = "E", run = 2, condition = 'structure', filter="education", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m9_lo <- list(order = "D", run = 2, condition = 'exploration', filter="education", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m9_hi <- list(order = "C", run = 2, condition = 'exploration', filter="education", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m10_lo <- list(order = "B", run = 0, condition = 'ess', filter="education", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m10_hi <- list(order = "A", run = 0, condition = 'ess', filter="education", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m <- list(
  m1_lo, m2_lo, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_hi, m5_hi,
  m7_lo, m8_lo, m7_hi, m8_hi,
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi,
  m10_lo, m10_hi
)
lc <- '#e08214'
mc <- '#cccccc'
hc <- '#8073ac'
mycolors <- c(
  hc, lc,
  hc, lc,
  hc, lc,
  hc, lc,
  hc, hc, lc, lc,
  hc, hc, lc, lc,
  hc, hc, lc, lc
)
plotMeasure(m,"opposition by education",100,FALSE,0.24,0.64,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_opposition_by_education")

# perceived threat
m1_lo <- list(order = "T", run = 1, condition = 'empathy', filter="education", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_lo <- list(order = "S", run = 1, condition = 'empathy', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_hi <- list(order = "R", run = 1, condition = 'empathy', filter="education", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_hi <- list(order = "Q", run = 1, condition = 'empathy', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_lo <- list(order = "P", run = 1, condition = 'structure', filter="education", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_lo  <- list(order = "O", run = 1, condition = 'structure', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_hi <- list(order = "N", run = 1, condition = 'structure', filter="education", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')	
m5_hi  <- list(order = "M", run = 1, condition = 'structure', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_lo <- list(order = "L", run = 1, condition = 'exploration', filter="education", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_lo <- list(order = "K", run = 1, condition = 'exploration', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_hi <- list(order = "J", run = 1, condition = 'exploration', filter="education", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_hi <- list(order = "I", run = 1, condition = 'exploration', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m3_lo <- list(order = "H", run = 2, condition = 'empathy', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_hi <- list(order = "G", run = 2, condition = 'empathy', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_lo  <- list(order = "F", run = 2, condition = 'structure', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_hi  <- list(order = "E", run = 2, condition = 'structure', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_lo <- list(order = "D", run = 2, condition = 'exploration', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_hi <- list(order = "C", run = 2, condition = 'exploration', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m10_lo <- list(order = "B", run = 0, condition = 'ess', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_hi <- list(order = "A", run = 0, condition = 'ess', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m2_lo, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_hi, m5_hi,
  m7_lo, m8_lo, m7_hi, m8_hi,
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi,
  m10_lo, m10_hi
)
lc <- '#e08214'
mc <- '#cccccc'
hc <- '#8073ac'
mycolors <- c(
  hc, lc,
  hc, lc,
  hc, lc,
  hc, lc,
  hc, hc, lc, lc,
  hc, hc, lc, lc,
  hc, hc, lc, lc
)
plotMeasure(m,"perceived threat by education",100,FALSE,0.24,0.64,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_by_education")

# opposition pre post
m1_lo <- list(order = "F",run = 1, condition = 'empathy', filter="education", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_hi <- list(order = "E",run = 1, condition = 'empathy', filter="education", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_lo <- list(order = "D",run = 1, condition = 'structure', filter="education", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_hi <- list(order = "C",run = 1, condition = 'structure', filter="education", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_lo <- list(order = "B",run = 1, condition = 'exploration', filter="education", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="education", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi,
  m3_lo, m3_hi
)
mycolors <- c('#d8daeb', "#fee0b6", '#d8daeb', "#fee0b6", '#d8daeb', '#fee0b6')
plotMeasure(m, "opposition by education delta", 100,FALSE,-0.054,0.044,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_educartion")

# perceived threat pre post
m1_lo <- list(order = "F",run = 1, condition = 'empathy', filter="education", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "E",run = 1, condition = 'empathy', filter="education", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_lo <- list(order = "D",run = 1, condition = 'structure', filter="education", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "C",run = 1, condition = 'structure', filter="education", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_lo <- list(order = "B",run = 1, condition = 'exploration', filter="education", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="education", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi,
  m3_lo, m3_hi
)
mycolors <- c('#d8daeb', "#fee0b6", '#d8daeb', "#fee0b6", '#d8daeb', '#fee0b6')
plotMeasure(m, "perceived threat by education delta", 100,FALSE,-0.054,0.044,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_educationr")

#By Income
# opposition
# empathy
m1_difficult <- list(order = "ZD", run = 1, condition = 'empathy', filter="income", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_difficult <- list(order = "ZC", run = 1, condition = 'empathy', filter="income", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m1_coping <- list(order = "ZB", run = 1, condition = 'empathy', filter="income", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m2_coping <- list(order = "ZA", run = 1, condition = 'empathy', filter="income", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m1_comfortably <- list(order = "Z", run = 1, condition = 'empathy', filter="income", fValue=3, measure = 'IM_PRE_Opposition3_Mean_N')
m2_comfortably <- list(order = "Y", run = 1, condition = 'empathy', filter="income", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

# structure
m4_difficult <- list(order = "X", run = 1, condition = 'structure', filter="income", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')	
m5_difficult <- list(order = "W", run = 1, condition = 'structure', filter="income", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m4_coping <- list(order = "V", run = 1, condition = 'structure', filter="income", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m5_coping  <- list(order = "U", run = 1, condition = 'structure', filter="income", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m4_comfortably <- list(order = "T", run = 1, condition = 'structure', filter="income", fValue=3, measure = 'IM_PRE_Opposition3_Mean_N')
m5_comfortably <- list(order = "S", run = 1, condition = 'structure', filter="income", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

# exploration
m7_difficult <- list(order = "R", run = 1, condition = 'exploration', filter="income", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_difficult <- list(order = "Q", run = 1, condition = 'exploration', filter="income", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m7_coping <- list(order = "P", run = 1, condition = 'exploration', filter="income", fValue=2, measure = 'IM_PRE_Opposition3_Mean_N')
m8_coping <- list(order = "O", run = 1, condition = 'exploration', filter="income", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')

m7_comfortably <- list(order = "N", run = 1, condition = 'exploration', filter="income", fValue=3, measure = 'IM_PRE_Opposition3_Mean_N')
m8_comfortably <- list(order = "M", run = 1, condition = 'exploration', filter="income", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

m3_difficult <- list(order = "L", run = 2, condition = 'empathy', filter="income", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m3_coping <- list(order = "K", run = 2, condition = 'empathy', filter="income", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')
m3_comfortably <- list(order = "J", run = 2, condition = 'empathy', filter="income", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

m6_difficult  <- list(order = "I", run = 2, condition = 'structure', filter="income", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m6_coping  <- list(order = "H", run = 2, condition = 'structure', filter="income", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')
m6_comfortably  <- list(order = "G", run = 2, condition = 'structure', filter="income", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

m9_difficult <- list(order = "F", run = 2, condition = 'exploration', filter="income", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m9_coping <- list(order = "E", run = 2, condition = 'exploration', filter="income", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')
m9_comfortably <- list(order = "D", run = 2, condition = 'exploration', filter="income", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

# ess
m10_difficult <- list(order = "C", run = 0, condition = 'ess', filter="income", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')
m10_coping <- list(order = "B", run = 0, condition = 'ess', filter="income", fValue=2, measure = 'IM_POST_Opposition3_Mean_N')
m10_comfortably <- list(order = "A", run = 0, condition = 'ess', filter="income", fValue=3, measure = 'IM_POST_Opposition3_Mean_N')

m <- list(
  m1_difficult, m2_difficult, m1_coping, m2_coping, m1_comfortably, m2_comfortably,
  m4_difficult, m5_difficult, m4_coping, m5_coping, m4_comfortably, m5_comfortably,
  m7_difficult, m8_difficult, m7_coping,  m8_coping, m7_comfortably, m8_comfortably,
  m3_difficult, m3_coping, m3_comfortably,
  m6_difficult, m6_coping, m6_comfortably,
  m9_difficult, m9_coping, m9_comfortably,
  m10_difficult, m10_coping, m10_comfortably
)
dc <- '#e08214'
cc <- '#cccccc'
oc <- '#8073ac'

mycolors <- c(
  oc, cc, dc,
  oc, cc, dc,
  oc, cc, dc,
  oc, cc, dc,
  oc, oc, cc, cc, dc, dc,
  oc, oc, cc, cc, dc, dc,
  oc, oc, cc, cc, dc, dc
)
plotMeasure(m,"opposition by income",100,FALSE,0.2,0.64,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_opposition_by_income")

# perceived threat
# empathy
m1_difficult <- list(order = "ZD", run = 1, condition = 'empathy', filter="income", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_difficult <- list(order = "ZC", run = 1, condition = 'empathy', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_coping <- list(order = "ZB", run = 1, condition = 'empathy', filter="income", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_coping <- list(order = "ZA", run = 1, condition = 'empathy', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_comfortably <- list(order = "Z", run = 1, condition = 'empathy', filter="income", fValue=3, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_comfortably <- list(order = "Y", run = 1, condition = 'empathy', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

# structure
m4_difficult <- list(order = "X", run = 1, condition = 'structure', filter="income", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')	
m5_difficult <- list(order = "W", run = 1, condition = 'structure', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_coping <- list(order = "V", run = 1, condition = 'structure', filter="income", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_coping  <- list(order = "U", run = 1, condition = 'structure', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_comfortably <- list(order = "T", run = 1, condition = 'structure', filter="income", fValue=3, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_comfortably <- list(order = "S", run = 1, condition = 'structure', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

# exploration
m7_difficult <- list(order = "R", run = 1, condition = 'exploration', filter="income", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_difficult <- list(order = "Q", run = 1, condition = 'exploration', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_coping <- list(order = "P", run = 1, condition = 'exploration', filter="income", fValue=2, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_coping <- list(order = "O", run = 1, condition = 'exploration', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_comfortably <- list(order = "N", run = 1, condition = 'exploration', filter="income", fValue=3, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_comfortably <- list(order = "M", run = 1, condition = 'exploration', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m3_difficult <- list(order = "L", run = 2, condition = 'empathy', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_coping <- list(order = "K", run = 2, condition = 'empathy', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_comfortably <- list(order = "J", run = 2, condition = 'empathy', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_difficult  <- list(order = "I", run = 2, condition = 'structure', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_coping  <- list(order = "H", run = 2, condition = 'structure', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_comfortably  <- list(order = "G", run = 2, condition = 'structure', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_difficult <- list(order = "F", run = 2, condition = 'exploration', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_coping <- list(order = "E", run = 2, condition = 'exploration', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_comfortably <- list(order = "D", run = 2, condition = 'exploration', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

# ess
m10_difficult <- list(order = "C", run = 0, condition = 'ess', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_coping <- list(order = "B", run = 0, condition = 'ess', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_comfortably <- list(order = "A", run = 0, condition = 'ess', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m1_difficult, m2_difficult, m1_coping, m2_coping, m1_comfortably, m2_comfortably,
  m4_difficult, m5_difficult, m4_coping, m5_coping, m4_comfortably, m5_comfortably,
  m7_difficult, m8_difficult, m7_coping,  m8_coping, m7_comfortably, m8_comfortably,
  m3_difficult, m3_coping, m3_comfortably,
  m6_difficult, m6_coping, m6_comfortably,
  m9_difficult, m9_coping, m9_comfortably,
  m10_difficult, m10_coping, m10_comfortably
)
dc <- '#e08214'
cc <- '#cccccc'
oc <- '#8073ac'

mycolors <- c(
  oc, cc, dc,
  oc, cc, dc,
  oc, cc, dc,
  oc, cc, dc,
  oc, oc, cc, cc, dc, dc,
  oc, oc, cc, cc, dc, dc,
  oc, oc, cc, cc, dc, dc
)
plotMeasure(m,"perceived threat by income",100,FALSE,0.2,0.64,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_by_income")

# opposition pre post
m1_difficult <- list(order = "I",run = 1, condition = 'empathy', filter="income", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_coping <- list(order = "H",run = 1, condition = 'empathy', filter="income", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_comfortably <- list(order = "G",run = 1, condition = 'empathy', filter="income", fValue=3, measure = 'IM_DELTA_Opposition3_Mean_N')

m2_difficult <- list(order = "F",run = 1, condition = 'structure', filter="income", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_coping <- list(order = "E",run = 1, condition = 'structure', filter="income", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_comfortably <- list(order = "D",run = 1, condition = 'structure', filter="income", fValue=3, measure = 'IM_DELTA_Opposition3_Mean_N')

m3_difficult <- list(order = "C",run = 1, condition = 'exploration', filter="income", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_coping <- list(order = "B",run = 1, condition = 'exploration', filter="income", fValue=2, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_comfortably <- list(order = "A",run = 1, condition = 'exploration', filter="income", fValue=3, measure = 'IM_DELTA_Opposition3_Mean_N')

m <- list(
  m1_difficult, m1_coping, m1_comfortably,
  m2_difficult, m2_coping, m2_comfortably,
  m3_difficult, m3_coping, m3_comfortably
)
mycolors <- c(
  "#d8daeb", "#dddddd", "#fee0b6",
  "#d8daeb", "#dddddd", "#fee0b6",
  "#d8daeb", "#dddddd", "#fee0b6"
)
plotMeasure(m, "opposition by income delta", 100,FALSE,-0.06,0.08,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_income")

# perceived threat pre post
m1_difficult <- list(order = "I",run = 1, condition = 'empathy', filter="income", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_coping <- list(order = "H",run = 1, condition = 'empathy', filter="income", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_comfortably <- list(order = "G",run = 1, condition = 'empathy', filter="income", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_difficult <- list(order = "F",run = 1, condition = 'structure', filter="income", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_coping <- list(order = "E",run = 1, condition = 'structure', filter="income", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_comfortably <- list(order = "D",run = 1, condition = 'structure', filter="income", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m3_difficult <- list(order = "C",run = 1, condition = 'exploration', filter="income", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_coping <- list(order = "B",run = 1, condition = 'exploration', filter="income", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_comfortably <- list(order = "A",run = 1, condition = 'exploration', filter="income", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_difficult, m1_coping, m1_comfortably,
  m2_difficult, m2_coping, m2_comfortably,
  m3_difficult, m3_coping, m3_comfortably
)
mycolors <- c(
  "#d8daeb", "#dddddd", "#fee0b6",
  "#d8daeb", "#dddddd", "#fee0b6",
  "#d8daeb", "#dddddd", "#fee0b6"
)
plotMeasure(m, "perceived threat by income delta", 100,FALSE,-0.06,0.08,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_income")





#By Religion
# opposition
m1_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m1_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
m2_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

m1_hi <- list(order = "Z", run = 1, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_hi <- list(order = "Y", run = 1, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m4_lo <- list(order = "X", run = 1, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')	
m5_lo  <- list(order = "W", run = 1, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m4_mi <- list(order = "V", run = 1, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')	
m5_mi  <- list(order = "U", run = 1, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

m4_hi <- list(order = "T", run = 1, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')	
m5_hi  <- list(order = "S", run = 1, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m7_lo <- list(order = "R", run = 1, condition = 'exploration', filter="religiosity", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_lo <- list(order = "Q", run = 1, condition = 'exploration', filter="religiosity", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m7_mi <- list(order = "P", run = 1, condition = 'exploration', filter="religiosity", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
m8_mi <- list(order = "O", run = 1, condition = 'exploration', filter="religiosity", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

m7_hi <- list(order = "N", run = 1, condition = 'exploration', filter="religiosity", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_hi <- list(order = "M", run = 1, condition = 'exploration', filter="religiosity", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m3_lo <- list(order = "L", run = 2, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m3_mi <- list(order = "K", run = 2, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m3_hi <- list(order = "J", run = 2, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m6_lo  <- list(order = "I", run = 2, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m6_mi  <- list(order = "H", run = 2, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m6_hi  <- list(order = "G", run = 2, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m9_lo <- list(order = "F", run = 2, condition = 'exploration', filter="religiosity", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m9_mi <- list(order = "E", run = 2, condition = 'exploration', filter="religiosity", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m9_hi <- list(order = "D", run = 2, condition = 'exploration', filter="religiosity", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m10_lo <- list(order = "C", run = 0, condition = 'ess', filter="religiosity", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m10_mi <- list(order = "B", run = 0, condition = 'ess', filter="religiosity", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m10_hi <- list(order = "A", run = 0, condition = 'ess', filter="religiosity", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m <- list(
  m1_lo, m2_lo, m1_mi, m2_mi, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_mi, m5_mi, m4_hi, m5_hi,
  m7_lo, m8_lo, m7_mi, m8_mi, m7_hi, m8_hi,
  m3_lo, m3_mi, m3_hi,
  m6_lo, m6_mi, m6_hi,
  m9_lo, m9_mi, m9_hi,
  m10_lo, m10_mi, m10_hi
)
lc <- '#b2182b'
nc <- '#cccccc'
rc <- '#2166ac'
mycolors <- c(
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc,
  rc, rc, nc, nc, lc, lc,
  rc, rc, nc, nc, lc, lc,
  rc, rc, nc, nc, lc, lc
)

m <- list(
  m1_lo, m2_lo, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_hi, m5_hi,
  m7_lo, m8_lo, m7_hi, m8_hi,
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi,
  m10_lo, m10_hi
)
uc <- '#b2182b'
rc <- '#2166ac'
mycolors <- c(
  rc, uc,
  rc, uc,
  rc, uc,
  rc, uc,
  rc, rc, uc, uc,
  rc, rc, uc, uc,
  rc, rc, uc, uc
)  
plotMeasure(m,"opposition by religiosity",100,FALSE,0.15,0.7,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_opposition_by_religiosity")


# perceived threat
m1_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_hi <- list(order = "Z", run = 1, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_hi <- list(order = "Y", run = 1, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_lo <- list(order = "X", run = 1, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')	
m5_lo  <- list(order = "W", run = 1, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_mi <- list(order = "V", run = 1, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_mi <- list(order = "U", run = 1, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_hi <- list(order = "T", run = 1, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')	
m5_hi  <- list(order = "S", run = 1, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_lo <- list(order = "R", run = 1, condition = 'exploration', filter="religiosity", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_lo <- list(order = "Q", run = 1, condition = 'exploration', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_mi <- list(order = "P", run = 1, condition = 'exploration', filter="religiosity", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_mi <- list(order = "O", run = 1, condition = 'exploration', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_hi <- list(order = "N", run = 1, condition = 'exploration', filter="religiosity", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_hi <- list(order = "M", run = 1, condition = 'exploration', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m3_lo <- list(order = "L", run = 2, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_mi <- list(order = "K", run = 2, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_hi <- list(order = "J", run = 2, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_lo  <- list(order = "I", run = 2, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_mi  <- list(order = "H", run = 2, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_hi  <- list(order = "G", run = 2, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_lo <- list(order = "F", run = 2, condition = 'exploration', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_mi <- list(order = "E", run = 2, condition = 'exploration', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_hi <- list(order = "D", run = 2, condition = 'exploration', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m10_lo <- list(order = "C", run = 0, condition = 'ess', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_mi <- list(order = "B", run = 0, condition = 'ess', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_hi <- list(order = "A", run = 0, condition = 'ess', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m2_lo, m1_mi, m2_mi, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_mi, m5_mi, m4_hi, m5_hi,
  m7_lo, m8_lo, m7_mi, m8_mi, m7_hi, m8_hi,
  m3_lo, m3_mi, m3_hi,
  m6_lo, m6_mi, m6_hi,
  m9_lo, m9_mi, m9_hi,
  m10_lo, m10_mi, m10_hi
)
lc <- '#b2182b'
nc <- '#cccccc'
rc <- '#2166ac'
mycolors <- c(
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc,
  rc, rc, nc, nc, lc, lc,
  rc, rc, nc, nc, lc, lc,
  rc, rc, nc, nc, lc, lc
)

m <- list(
  m1_lo, m2_lo, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_hi, m5_hi,
  m7_lo, m8_lo, m7_hi, m8_hi,
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi#,
  #m10_lo, m10_hi
)
uc <- '#b2182b'
rc <- '#2166ac'
mycolors <- c(
  #rc, uc,
  rc, uc,
  rc, uc,
  rc, uc,
  rc, rc, uc, uc,
  rc, rc, uc, uc,
  rc, rc, uc, uc
)  

plotMeasure(m,"perceived threat by religiosity",100,FALSE,0.15,0.7,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_by_religiosity")

# opposition pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter="religiosity", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter="religiosity", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="religiosity", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#92c5de', "#dddddd", '#f4a582', "#92c5de", '#dddddd', '#f4a582', '#92c5de', '#dddddd', '#f4a582')

m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi,
  m3_lo, m3_hi
)
mycolors <- c('#92c5de', '#f4a582', "#92c5de", '#f4a582', '#92c5de', '#f4a582')
plotMeasure(m, "opposition by religiosity delta", 100,FALSE,-0.16,0.12,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_religiosity")


# perceived threat pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter="religiosity", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter="religiosity", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="religiosity", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')


m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#92c5de', "#dddddd", '#f4a582', "#92c5de", '#dddddd', '#f4a582', '#92c5de', '#dddddd', '#f4a582')


m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi,
  m3_lo, m3_hi
)
mycolors <- c('#92c5de', '#f4a582', "#92c5de", '#f4a582', '#92c5de', '#f4a582')
plotMeasure(m, "perceived threat by religiosity delta", 100,FALSE,-0.16,0.12,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_religiosity")

# By Politics
# opposition
m1_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m1_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
m2_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

m1_hi <- list(order = "Z", run = 1, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_hi <- list(order = "Y", run = 1, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m4_lo <- list(order = "X", run = 1, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m5_lo  <- list(order = "W", run = 1, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m4_mi <- list(order = "V", run = 1, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
m5_mi  <- list(order = "U", run = 1, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

m4_hi <- list(order = "T", run = 1, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m5_hi  <- list(order = "S", run = 1, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m7_lo <- list(order = "R", run = 1, condition = 'exploration', filter="leftright", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_lo <- list(order = "Q", run = 1, condition = 'exploration', filter="leftright", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m7_mi <- list(order = "P", run = 1, condition = 'exploration', filter="leftright", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
m8_mi <- list(order = "O", run = 1, condition = 'exploration', filter="leftright", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

m7_hi <- list(order = "N", run = 1, condition = 'exploration', filter="leftright", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_hi <- list(order = "M", run = 1, condition = 'exploration', filter="leftright", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m3_lo <- list(order = "L", run = 2, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m3_mi <- list(order = "K", run = 2, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m3_hi <- list(order = "J", run = 2, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m6_lo  <- list(order = "I", run = 2, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m6_mi  <- list(order = "H", run = 2, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m6_hi  <- list(order = "G", run = 2, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m9_lo <- list(order = "F", run = 2, condition = 'exploration', filter="leftright", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m9_mi <- list(order = "E", run = 2, condition = 'exploration', filter="leftright", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m9_hi <- list(order = "D", run = 2, condition = 'exploration', filter="leftright", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m10_lo <- list(order = "C", run = 0, condition = 'ess', filter="leftright", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m10_mi <- list(order = "B", run = 0, condition = 'ess', filter="leftright", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m10_hi <- list(order = "A", run = 0, condition = 'ess', filter="leftright", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m <- list(
  m1_lo, m2_lo, m1_mi, m2_mi, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_mi, m5_mi, m4_hi, m5_hi,
  m7_lo, m8_lo, m7_mi, m8_mi, m7_hi, m8_hi,
  m3_lo, m3_mi, m3_hi,
  m6_lo, m6_mi, m6_hi,
  m9_lo, m9_mi, m9_hi,
  m10_lo, m10_mi, m10_hi
)
lc <- '#b2182b'
nc <- '#cccccc'
rc <- '#2166ac'
mycolors <- c(
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc,
  rc, rc, nc, nc, lc, lc,
  rc, rc, nc, nc, lc, lc,
  rc, rc, nc, nc, lc, lc
)
plotMeasure(m,"opposition by leftright",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_opposition_by_leftright")

# perceived threat
m1_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_hi <- list(order = "Z", run = 1, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_hi <- list(order = "Y", run = 1, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_lo <- list(order = "X", run = 1, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_lo  <- list(order = "W", run = 1, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_mi <- list(order = "V", run = 1, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_mi  <- list(order = "U", run = 1, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_hi <- list(order = "T", run = 1, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_hi  <- list(order = "S", run = 1, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_lo <- list(order = "R", run = 1, condition = 'exploration', filter="leftright", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_lo <- list(order = "Q", run = 1, condition = 'exploration', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_mi <- list(order = "P", run = 1, condition = 'exploration', filter="leftright", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_mi <- list(order = "O", run = 1, condition = 'exploration', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_hi <- list(order = "N", run = 1, condition = 'exploration', filter="leftright", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_hi <- list(order = "M", run = 1, condition = 'exploration', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m3_lo <- list(order = "L", run = 2, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_mi <- list(order = "K", run = 2, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_hi <- list(order = "J", run = 2, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_lo  <- list(order = "I", run = 2, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_mi  <- list(order = "H", run = 2, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_hi  <- list(order = "G", run = 2, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_lo <- list(order = "F", run = 2, condition = 'exploration', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_mi <- list(order = "E", run = 2, condition = 'exploration', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_hi <- list(order = "D", run = 2, condition = 'exploration', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m10_lo <- list(order = "C", run = 0, condition = 'ess', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_mi <- list(order = "B", run = 0, condition = 'ess', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_hi <- list(order = "A", run = 0, condition = 'ess', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m2_lo, m1_mi, m2_mi, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_mi, m5_mi, m4_hi, m5_hi,
  m7_lo, m8_lo, m7_mi, m8_mi, m7_hi, m8_hi,
  m3_lo, m3_mi, m3_hi,
  m6_lo, m6_mi, m6_hi,
  m9_lo, m9_mi, m9_hi,
  m10_lo, m10_mi, m10_hi
)
lc <- '#b2182b'
nc <- '#cccccc'
rc <- '#2166ac'
mycolors <- c(
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc,
  rc, rc, nc, nc, lc, lc,
  rc, rc, nc, nc, lc, lc,
  rc, rc, nc, nc, lc, lc
)
plotMeasure(m,"perceived threat by leftright",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_by_leftright")

# opposition pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter="leftright", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter="leftright", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="leftright", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#92c5de', "#dddddd", '#f4a582', "#92c5de", '#dddddd', '#f4a582', '#92c5de', '#dddddd', '#f4a582')
plotMeasure(m, "opposition by leftright delta", 100,FALSE,-0.08,0.07,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_leftright")

# perceived threat pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter="leftright", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter="leftright", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="leftright", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#92c5de', "#dddddd", '#f4a582', "#92c5de", '#dddddd', '#f4a582', '#92c5de', '#dddddd', '#f4a582')
plotMeasure(m, "perceived threat by leftright delta", 100,FALSE,-0.08,0.07,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_leftright")




# HUMAN VALUES !!!
# DIM OPEN
# opposition
m1_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m1_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter="open", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
m2_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter="open", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

m1_hi <- list(order = "Z", run = 1, condition = 'empathy', filter="open", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_hi <- list(order = "Y", run = 1, condition = 'empathy', filter="open", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m4_lo <- list(order = "X", run = 1, condition = 'structure', filter="open", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m5_lo  <- list(order = "W", run = 1, condition = 'structure', filter="open", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m4_mi <- list(order = "V", run = 1, condition = 'structure', filter="open", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
m5_mi  <- list(order = "U", run = 1, condition = 'structure', filter="open", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

m4_hi <- list(order = "T", run = 1, condition = 'structure', filter="open", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m5_hi  <- list(order = "S", run = 1, condition = 'structure', filter="open", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m7_lo <- list(order = "R", run = 1, condition = 'exploration', filter="open", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_lo <- list(order = "Q", run = 1, condition = 'exploration', filter="open", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m7_mi <- list(order = "P", run = 1, condition = 'exploration', filter="open", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
m8_mi <- list(order = "O", run = 1, condition = 'exploration', filter="open", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

m7_hi <- list(order = "N", run = 1, condition = 'exploration', filter="open", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_hi <- list(order = "M", run = 1, condition = 'exploration', filter="open", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m3_lo <- list(order = "L", run = 2, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m3_mi <- list(order = "K", run = 2, condition = 'empathy', filter="open", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m3_hi <- list(order = "J", run = 2, condition = 'empathy', filter="open", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m6_lo  <- list(order = "I", run = 2, condition = 'structure', filter="open", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m6_mi  <- list(order = "H", run = 2, condition = 'structure', filter="open", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m6_hi  <- list(order = "G", run = 2, condition = 'structure', filter="open", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m9_lo <- list(order = "F", run = 2, condition = 'exploration', filter="open", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m9_mi <- list(order = "E", run = 2, condition = 'exploration', filter="open", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m9_hi <- list(order = "D", run = 2, condition = 'exploration', filter="open", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m10_lo <- list(order = "C", run = 0, condition = 'ess', filter="open", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m10_mi <- list(order = "B", run = 0, condition = 'ess', filter="open", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
m10_hi <- list(order = "A", run = 0, condition = 'ess', filter="open", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi,
  m4_lo, m4_mi, m4_hi,
  m5_lo, m5_mi, m5_hi,
  m6_lo, m6_mi, m6_hi,
  m7_lo, m7_mi, m7_hi,
  m8_lo, m8_mi, m8_hi,
  m9_lo, m9_mi, m9_hi,
  m10_lo, m10_mi, m10_hi
)
mycolors <- c(
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f"
)
m <- list(
  m1_lo, m2_lo,
  m1_hi, m2_hi,
  m4_lo, m5_lo,
  m4_hi, m5_hi,
  m7_lo, m8_lo,
  m7_hi, m8_hi,
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi,
  m10_lo, m10_hi
)
lc <- "#c51b7d"
hc <- "#4d9221"
mycolors <- c(
  hc, lc,
  hc, lc,
  hc, lc,
  hc, lc,
  hc, hc,
  lc, lc,
  hc, hc,
  lc, lc,
  hc, hc,
  lc, lc
)
plotMeasure(m,"opposition by hv dim open",100,FALSE,0.2,0.6,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_opposition_by_hv_dim_open")

# perceived threat
m1_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter="open", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_hi <- list(order = "Z", run = 1, condition = 'empathy', filter="open", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_hi <- list(order = "Y", run = 1, condition = 'empathy', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_lo <- list(order = "X", run = 1, condition = 'structure', filter="open", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')	
m5_lo  <- list(order = "W", run = 1, condition = 'structure', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_mi <- list(order = "V", run = 1, condition = 'structure', filter="open", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_mi  <- list(order = "U", run = 1, condition = 'structure', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_hi <- list(order = "T", run = 1, condition = 'structure', filter="open", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')	
m5_hi  <- list(order = "S", run = 1, condition = 'structure', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_lo <- list(order = "R", run = 1, condition = 'exploration', filter="open", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_lo <- list(order = "Q", run = 1, condition = 'exploration', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_mi <- list(order = "P", run = 1, condition = 'exploration', filter="open", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_mi <- list(order = "O", run = 1, condition = 'exploration', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_hi <- list(order = "N", run = 1, condition = 'exploration', filter="open", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_hi <- list(order = "M", run = 1, condition = 'exploration', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m3_lo <- list(order = "L", run = 2, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_mi <- list(order = "K", run = 2, condition = 'empathy', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_hi <- list(order = "J", run = 2, condition = 'empathy', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_lo  <- list(order = "I", run = 2, condition = 'structure', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_mi  <- list(order = "H", run = 2, condition = 'structure', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_hi  <- list(order = "G", run = 2, condition = 'structure', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_lo <- list(order = "F", run = 2, condition = 'exploration', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_mi <- list(order = "E", run = 2, condition = 'exploration', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_hi <- list(order = "D", run = 2, condition = 'exploration', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m10_lo <- list(order = "C", run = 0, condition = 'ess', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_mi <- list(order = "B", run = 0, condition = 'ess', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m10_hi <- list(order = "A", run = 0, condition = 'ess', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi,
  m4_lo, m4_mi, m4_hi,
  m5_lo, m5_mi, m5_hi,
  m6_lo, m6_mi, m6_hi,
  m7_lo, m7_mi, m7_hi,
  m8_lo, m8_mi, m8_hi,
  m9_lo, m9_mi, m9_hi,
  m10_lo, m10_mi, m10_hi
)
mycolors <- c(
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f",
  "#650721", "#cccbcb", "#1b325f"
)
m <- list(
  m1_lo, m2_lo,
  m1_hi, m2_hi,
  m4_lo, m5_lo,
  m4_hi, m5_hi,
  m7_lo, m8_lo,
  m7_hi, m8_hi,
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi,
  m10_lo, m10_hi
)
lc <- "#c51b7d"
hc <- "#4d9221"
mycolors <- c(
  hc, lc,
  hc, lc,
  hc, lc,
  hc, lc,
  hc, hc,
  lc, lc,
  hc, hc,
  lc, lc,
  hc, hc,
  lc, lc
)
plotMeasure(m,"perceived threat by hv dim open",100,FALSE,0.2,0.6,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_by_hv_dim_open")

# opposition pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="open", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="open", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="open", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="open", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="open", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter="open", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter="open", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="open", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#f3a582', "#e5e5e4", '#92c5dd', "#f3a582", '#e5e5e4', '#92c5dd', '#f3a582', '#e5e5e4', '#92c5dd')
m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi,
  m3_lo, m3_hi
)
mycolors <- c('#b8e186', '#f1b6da', "#b8e186", '#f1b6da', '#b8e186', '#f1b6da')
plotMeasure(m, "opposition by hv dim open delta", 100,FALSE,-0.06,0.04,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_hv_dim_open")


# perceived threat pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="open", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="open", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="open", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="open", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="open", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter="open", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter="open", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="open", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#f3a582', "#e5e5e4", '#92c5dd', "#f3a582", '#e5e5e4', '#92c5dd', '#f3a582', '#e5e5e4', '#92c5dd')
m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi,
  m3_lo, m3_hi
)
mycolors <- c('#b8e186', '#f1b6da', "#b8e186", '#f1b6da', '#b8e186', '#f1b6da')
plotMeasure(m, "perceived threat by hv dim open delta", 100,FALSE,-0.06,0.04,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_hv_dim_open")


# DIM SELF
# opposition
ex1em_pr_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1em_po_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

ex1em_pr_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter="self", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
ex1em_po_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter="self", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

ex1em_pr_hi <- list(order = "Z", run = 1, condition = 'empathy', filter="self", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1em_po_hi <- list(order = "Y", run = 1, condition = 'empathy', filter="self", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex1st_pr_lo <- list(order = "X", run = 1, condition = 'structure', filter="self", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1st_po_lo  <- list(order = "W", run = 1, condition = 'structure', filter="self", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

ex1st_pr_mi <- list(order = "V", run = 1, condition = 'structure', filter="self", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
ex1st_po_mi  <- list(order = "U", run = 1, condition = 'structure', filter="self", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

ex1st_pr_hi <- list(order = "T", run = 1, condition = 'structure', filter="self", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1st_po_hi  <- list(order = "S", run = 1, condition = 'structure', filter="self", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex1ex_pr_lo <- list(order = "R", run = 1, condition = 'exploration', filter="self", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1ex_po_lo <- list(order = "Q", run = 1, condition = 'exploration', filter="self", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

ex1ex_pr_mi <- list(order = "P", run = 1, condition = 'exploration', filter="self", fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
ex1ex_po_mi <- list(order = "O", run = 1, condition = 'exploration', filter="self", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

ex1ex_pr_hi <- list(order = "N", run = 1, condition = 'exploration', filter="self", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1ex_po_hi <- list(order = "M", run = 1, condition = 'exploration', filter="self", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex2em_lo <- list(order = "L", run = 2, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
ex2em_mi <- list(order = "K", run = 2, condition = 'empathy', filter="self", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
ex2em_hi <- list(order = "J", run = 2, condition = 'empathy', filter="self", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex2st_lo  <- list(order = "I", run = 2, condition = 'structure', filter="self", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
ex2st_mi  <- list(order = "H", run = 2, condition = 'structure', filter="self", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
ex2st_hi  <- list(order = "G", run = 2, condition = 'structure', filter="self", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex2ex_lo <- list(order = "F", run = 2, condition = 'exploration', filter="self", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
ex2ex_mi <- list(order = "E", run = 2, condition = 'exploration', filter="self", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
ex2ex_hi <- list(order = "D", run = 2, condition = 'exploration', filter="self", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ess_lo <- list(order = "C", run = 0, condition = 'ess', filter="self", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
ess_mi <- list(order = "B", run = 0, condition = 'ess', filter="self", fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
ess_hi <- list(order = "A", run = 0, condition = 'ess', filter="self", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m <- list(
  ex1em_pr_lo, ex1em_po_lo, ex1em_pr_mi, ex1em_po_mi, ex1em_pr_hi, ex1em_po_hi,
  ex1st_pr_lo, ex1st_po_lo, ex1st_pr_mi, ex1st_po_mi, ex1st_pr_hi, ex1st_po_hi,
  ex1ex_pr_lo, ex1ex_po_lo, ex1ex_pr_mi, ex1ex_po_mi, ex1ex_pr_hi, ex1ex_po_hi,
  ex2em_lo, ex2em_mi, ex2em_hi,
  ex2st_lo, ex2st_mi, ex2st_hi,
  ex2ex_lo, ex2ex_mi, ex2ex_hi,
  ess_lo, ess_mi, ess_hi
)
lc <- "#c51b7d"
mc <- "#cccccc"
hc <- "#4d9221"
mycolors <- c(
  hc, mc, lc,
  hc, mc, lc,
  hc, mc, lc,
  hc, mc, lc,
  hc, hc, mc, mc, lc, lc,
  hc, hc, mc, mc, lc, lc,
  hc, hc, mc, mc, lc, lc
)

plotMeasure(m,"opposition by hv dim self",100,FALSE,0.2,0.65,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_opposition_by_hv_dim_self")

# perceived threat
ex1em_pr_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1em_po_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1em_pr_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter="self", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1em_po_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1em_pr_hi <- list(order = "Z", run = 1, condition = 'empathy', filter="self", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1em_po_hi <- list(order = "Y", run = 1, condition = 'empathy', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1st_pr_lo <- list(order = "X", run = 1, condition = 'structure', filter="self", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1st_po_lo  <- list(order = "W", run = 1, condition = 'structure', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1st_pr_mi <- list(order = "V", run = 1, condition = 'structure', filter="self", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1st_po_mi  <- list(order = "U", run = 1, condition = 'structure', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1st_pr_hi <- list(order = "T", run = 1, condition = 'structure', filter="self", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1st_po_hi  <- list(order = "S", run = 1, condition = 'structure', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1ex_pr_lo <- list(order = "R", run = 1, condition = 'exploration', filter="self", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1ex_po_lo <- list(order = "Q", run = 1, condition = 'exploration', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1ex_pr_mi <- list(order = "P", run = 1, condition = 'exploration', filter="self", fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1ex_po_mi <- list(order = "O", run = 1, condition = 'exploration', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1ex_pr_hi <- list(order = "N", run = 1, condition = 'exploration', filter="self", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1ex_po_hi <- list(order = "M", run = 1, condition = 'exploration', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex2em_lo <- list(order = "L", run = 2, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2em_mi <- list(order = "K", run = 2, condition = 'empathy', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2em_hi <- list(order = "J", run = 2, condition = 'empathy', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex2st_lo  <- list(order = "I", run = 2, condition = 'structure', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2st_mi  <- list(order = "H", run = 2, condition = 'structure', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2st_hi  <- list(order = "G", run = 2, condition = 'structure', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex2ex_lo <- list(order = "F", run = 2, condition = 'exploration', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2ex_mi <- list(order = "E", run = 2, condition = 'exploration', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2ex_hi <- list(order = "D", run = 2, condition = 'exploration', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ess_lo <- list(order = "C", run = 0, condition = 'ess', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ess_mi <- list(order = "B", run = 0, condition = 'ess', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ess_hi <- list(order = "A", run = 0, condition = 'ess', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  ex1em_pr_lo, ex1em_po_lo, ex1em_pr_mi, ex1em_po_mi, ex1em_pr_hi, ex1em_po_hi,
  ex1st_pr_lo, ex1st_po_lo, ex1st_pr_mi, ex1st_po_mi, ex1st_pr_hi, ex1st_po_hi,
  ex1ex_pr_lo, ex1ex_po_lo, ex1ex_pr_mi, ex1ex_po_mi, ex1ex_pr_hi, ex1ex_po_hi,
  ex2em_lo, ex2em_mi, ex2em_hi,
  ex2st_lo, ex2st_mi, ex2st_hi,
  ex2ex_lo, ex2ex_mi, ex2ex_hi,
  ess_lo, ess_mi, ess_hi
)
lc <- "#c51b7d"
mc <- "#cccccc"
hc <- "#4d9221"
mycolors <- c(
  hc, mc, lc,
  hc, mc, lc,
  hc, mc, lc,
  hc, mc, lc,
  hc, hc, mc, mc, lc, lc,
  hc, hc, mc, mc, lc, lc,
  hc, hc, mc, mc, lc, lc
)


plotMeasure(m,"perceived threat by hv dim self",100,FALSE,0.2,0.65,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_by_hv_dim_self")

# opposition pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="self", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="self", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="self", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="self", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="self", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter="self", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter="self", fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="self", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#b8e186', "#bbbbbb", '#f1b6da', "#b8e186", '#bbbbbb', '#f1b6da', '#b8e186', '#bbbbbb', '#f1b6da')

plotMeasure(m, "opposition by hv dim self delta", 100,FALSE,-0.065,0.05,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_hv_dim_self")


# perceived threat pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="self", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="self", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="self", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="self", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="self", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter="self", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter="self", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="self", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#b8e186', "#bbbbbb", '#f1b6da', "#b8e186", '#bbbbbb', '#f1b6da', '#b8e186', '#bbbbbb', '#f1b6da')

plotMeasure(m, "perceived threat by hv dim self delta", 100,FALSE,-0.065,0.05,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_hv_dim_self")



#By Time


# opposition
m1_lo <- list(order = "R", run = 1, condition = 'empathy', filter="time", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_lo <- list(order = "Q", run = 1, condition = 'empathy', filter="time", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m1_hi <- list(order = "P", run = 1, condition = 'empathy', filter="time", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m2_hi <- list(order = "O", run = 1, condition = 'empathy', filter="time", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m4_lo <- list(order = "N", run = 1, condition = 'structure', filter="time", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')	
m5_lo  <- list(order = "M", run = 1, condition = 'structure', filter="time", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m4_hi <- list(order = "L", run = 1, condition = 'structure', filter="time", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m5_hi  <- list(order = "K", run = 1, condition = 'structure', filter="time", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m7_lo <- list(order = "J", run = 1, condition = 'exploration', filter="time", fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_lo <- list(order = "I", run = 1, condition = 'exploration', filter="time", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

m7_hi <- list(order = "H", run = 1, condition = 'exploration', filter="time", fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
m8_hi <- list(order = "G", run = 1, condition = 'exploration', filter="time", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m3_lo <- list(order = "F", run = 2, condition = 'empathy', filter="time", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m3_hi <- list(order = "E", run = 2, condition = 'empathy', filter="time", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m6_lo  <- list(order = "D", run = 2, condition = 'structure', filter="time", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m6_hi  <- list(order = "C", run = 2, condition = 'structure', filter="time", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m9_lo <- list(order = "B", run = 2, condition = 'exploration', filter="time", fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
m9_hi <- list(order = "A", run = 2, condition = 'exploration', filter="time", fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m <- list(
  m1_lo, m2_lo, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_hi, m5_hi,
  m7_lo,  m8_lo, m7_hi, m8_hi,
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi
)
ec <- "#4292c6"
lc <- "#08519c"
mycolors <- c(
  lc, ec,
  lc, ec,
  lc, ec,
  lc, lc, ec, ec,
  lc, lc, ec, ec,
  lc, lc, ec, ec
)
plotMeasure(m,"opposition by time",100,FALSE,0.2,0.6,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_opposition_by_time")


# perceived threat
m1_lo <- list(order = "R", run = 1, condition = 'empathy', filter="time", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_lo <- list(order = "Q", run = 1, condition = 'empathy', filter="time", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m1_hi <- list(order = "P", run = 1, condition = 'empathy', filter="time", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m2_hi <- list(order = "O", run = 1, condition = 'empathy', filter="time", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_lo <- list(order = "N", run = 1, condition = 'structure', filter="time", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')	
m5_lo  <- list(order = "M", run = 1, condition = 'structure', filter="time", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m4_hi <- list(order = "L", run = 1, condition = 'structure', filter="time", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m5_hi  <- list(order = "K", run = 1, condition = 'structure', filter="time", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_lo <- list(order = "J", run = 1, condition = 'exploration', filter="time", fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_lo <- list(order = "I", run = 1, condition = 'exploration', filter="time", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m7_hi <- list(order = "H", run = 1, condition = 'exploration', filter="time", fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
m8_hi <- list(order = "G", run = 1, condition = 'exploration', filter="time", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m3_lo <- list(order = "F", run = 2, condition = 'empathy', filter="time", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_hi <- list(order = "E", run = 2, condition = 'empathy', filter="time", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_lo  <- list(order = "D", run = 2, condition = 'structure', filter="time", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_hi  <- list(order = "C", run = 2, condition = 'structure', filter="time", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_lo <- list(order = "B", run = 2, condition = 'exploration', filter="time", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_hi <- list(order = "A", run = 2, condition = 'exploration', filter="time", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m2_lo, m1_hi, m2_hi,
  m4_lo, m5_lo, m4_hi, m5_hi,
  m7_lo,  m8_lo, m7_hi, m8_hi,
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi
)
ec <- "#4292c6"
lc <- "#08519c"
mycolors <- c(
  lc, ec,
  lc, ec,
  lc, ec,
  lc, lc, ec, ec,
  lc, lc, ec, ec,
  lc, lc, ec, ec
)
plotMeasure(m,"perceived threat by time",100,FALSE,0.2,0.6,score_formatter_1f,mycolors,2,3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_by_time")


# opposition pre post
m1_lo <- list(order = "F",run = 1, condition = 'empathy', filter="time", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_hi <- list(order = "E",run = 1, condition = 'empathy', filter="time", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_lo <- list(order = "D",run = 1, condition = 'structure', filter="time", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_hi <- list(order = "C",run = 1, condition = 'structure', filter="time", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_lo <- list(order = "B",run = 1, condition = 'exploration', filter="time", fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="time", fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')
m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi,
  m3_lo, m3_hi
)
mycolors <- c('#6d849c', "#9fb7c7", '#6d849c', "#9fb7c7", '#6d849c', '#9fb7c7')
plotMeasure(m, "opposition by time delta", 100,FALSE,-0.06,0.06,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_time")


# perceived threat pre post
m1_lo <- list(order = "F",run = 1, condition = 'empathy', filter="time", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "E",run = 1, condition = 'empathy', filter="time", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_lo <- list(order = "D",run = 1, condition = 'structure', filter="time", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "C",run = 1, condition = 'structure', filter="time", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_lo <- list(order = "B",run = 1, condition = 'exploration', filter="time", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter="time", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi,
  m3_lo, m3_hi
)
mycolors <- c('#6d849c', "#9fb7c7", '#6d849c', "#9fb7c7", '#6d849c', '#9fb7c7')
plotMeasure(m, "perceived threat by time delta", 100,FALSE,-0.06,0.06,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_time")






#====================================================




# perceived threat pre post
m1_uki <- list(order = "C",run = 1, condition = 'empathy', filter="region", fValue="UKK", measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_uki <- list(order = "B",run = 1, condition = 'structure', filter="region", fValue="UKK", measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m3_uki <- list(order = "A",run = 1, condition = 'exploration', filter="region", fValue="UKK", measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_uki, m2_uki, m3_uki
)
mycolors <- c('#f3a582', "#f3a582", '#f3a582')

plotMeasure(m, "perceived threat by region delta", 100,FALSE,-0.1,0.1,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_region")

########



# OTC
myFilter = "otc"
# opposition
ex1em_pr_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter=myFilter, fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1em_po_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter=myFilter, fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

ex1em_pr_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter=myFilter, fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
ex1em_po_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter=myFilter, fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

ex1em_pr_hi <- list(order = "Z", run = 1, condition = 'empathy', filter=myFilter, fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1em_po_hi <- list(order = "Y", run = 1, condition = 'empathy', filter=myFilter, fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex1st_pr_lo <- list(order = "X", run = 1, condition = 'structure', filter=myFilter, fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1st_po_lo  <- list(order = "W", run = 1, condition = 'structure', filter=myFilter, fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

ex1st_pr_mi <- list(order = "V", run = 1, condition = 'structure', filter=myFilter, fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
ex1st_po_mi  <- list(order = "U", run = 1, condition = 'structure', filter=myFilter, fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

ex1st_pr_hi <- list(order = "T", run = 1, condition = 'structure', filter=myFilter, fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1st_po_hi  <- list(order = "S", run = 1, condition = 'structure', filter=myFilter, fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex1ex_pr_lo <- list(order = "R", run = 1, condition = 'exploration', filter=myFilter, fValue=-1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1ex_po_lo <- list(order = "Q", run = 1, condition = 'exploration', filter=myFilter, fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')

ex1ex_pr_mi <- list(order = "P", run = 1, condition = 'exploration', filter=myFilter, fValue=0, measure = 'IM_PRE_Opposition3_Mean_N')
ex1ex_po_mi <- list(order = "O", run = 1, condition = 'exploration', filter=myFilter, fValue=0, measure = 'IM_POST_Opposition3_Mean_N')

ex1ex_pr_hi <- list(order = "N", run = 1, condition = 'exploration', filter=myFilter, fValue=1, measure = 'IM_PRE_Opposition3_Mean_N')
ex1ex_po_hi <- list(order = "M", run = 1, condition = 'exploration', filter=myFilter, fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex2em_lo <- list(order = "L", run = 2, condition = 'empathy', filter=myFilter, fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
ex2em_mi <- list(order = "K", run = 2, condition = 'empathy', filter=myFilter, fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
ex2em_hi <- list(order = "J", run = 2, condition = 'empathy', filter=myFilter, fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex2st_lo  <- list(order = "I", run = 2, condition = 'structure', filter=myFilter, fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
ex2st_mi  <- list(order = "H", run = 2, condition = 'structure', filter=myFilter, fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
ex2st_hi  <- list(order = "G", run = 2, condition = 'structure', filter=myFilter, fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ex2ex_lo <- list(order = "F", run = 2, condition = 'exploration', filter=myFilter, fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
ex2ex_mi <- list(order = "E", run = 2, condition = 'exploration', filter=myFilter, fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
ex2ex_hi <- list(order = "D", run = 2, condition = 'exploration', filter=myFilter, fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

ess_lo <- list(order = "C", run = 0, condition = 'ess', filter=myFilter, fValue=-1, measure = 'IM_POST_Opposition3_Mean_N')
ess_mi <- list(order = "B", run = 0, condition = 'ess', filter=myFilter, fValue=0, measure = 'IM_POST_Opposition3_Mean_N')
ess_hi <- list(order = "A", run = 0, condition = 'ess', filter=myFilter, fValue=1, measure = 'IM_POST_Opposition3_Mean_N')

m <- list(
  ex1em_pr_lo, ex1em_po_lo, ex1em_pr_mi, ex1em_po_mi, ex1em_pr_hi, ex1em_po_hi,
  ex1st_pr_lo, ex1st_po_lo, ex1st_pr_mi, ex1st_po_mi, ex1st_pr_hi, ex1st_po_hi,
  ex1ex_pr_lo, ex1ex_po_lo, ex1ex_pr_mi, ex1ex_po_mi, ex1ex_pr_hi, ex1ex_po_hi,
  ex2em_lo, ex2em_mi, ex2em_hi,
  ex2st_lo, ex2st_mi, ex2st_hi,
  ex2ex_lo, ex2ex_mi, ex2ex_hi,
  ess_lo, ess_mi, ess_hi
)
lc <- "#c51b7d"
mc <- "#cccccc"
hc <- "#4d9221"
mycolors <- c(
  hc, mc, lc,
  hc, mc, lc,
  hc, mc, lc,
  hc, mc, lc,
  hc, hc, mc, mc, lc, lc,
  hc, hc, mc, mc, lc, lc,
  hc, hc, mc, mc, lc, lc
)

m <- list(
  ex1em_pr_lo, ex1em_po_lo, ex1em_pr_hi, ex1em_po_hi,
  ex1st_pr_lo, ex1st_po_lo, ex1st_pr_hi, ex1st_po_hi,
  ex1ex_pr_lo, ex1ex_po_lo, ex1ex_pr_hi, ex1ex_po_hi,
  ex2em_lo, ex2em_hi,
  ex2st_lo, ex2st_hi,
  ex2ex_lo, ex2ex_hi,
  ess_lo, ess_hi
)
lc <- "#c51b7d"
mc <- "#cccccc"
hc <- "#4d9221"
mycolors <- c(
  hc, lc,
  hc, lc,
  hc, lc,
  hc, lc,
  hc, hc, lc, lc,
  hc, hc, lc, lc,
  hc, hc, lc, lc
)

plotMeasure(m,paste("opposition by hv", myFilter, sep = " "),100,FALSE,0.2,0.7,score_formatter_1f,mycolors,2,3, dstFile=paste("../plots/exploratory/immigration_esci_opposition_by_hv_", myFilter, sep = ""))

# perceived threat
# perceived threat
myFilter = "sen"
ex1em_pr_lo <- list(order = "ZD", run = 1, condition = 'empathy', filter=myFilter, fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1em_po_lo <- list(order = "ZC", run = 1, condition = 'empathy', filter=myFilter, fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1em_pr_mi <- list(order = "ZB", run = 1, condition = 'empathy', filter=myFilter, fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1em_po_mi <- list(order = "ZA", run = 1, condition = 'empathy', filter=myFilter, fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1em_pr_hi <- list(order = "Z", run = 1, condition = 'empathy', filter=myFilter, fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1em_po_hi <- list(order = "Y", run = 1, condition = 'empathy', filter=myFilter, fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1st_pr_lo <- list(order = "X", run = 1, condition = 'structure', filter=myFilter, fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1st_po_lo  <- list(order = "W", run = 1, condition = 'structure', filter=myFilter, fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1st_pr_mi <- list(order = "V", run = 1, condition = 'structure', filter=myFilter, fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1st_po_mi  <- list(order = "U", run = 1, condition = 'structure', filter=myFilter, fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1st_pr_hi <- list(order = "T", run = 1, condition = 'structure', filter=myFilter, fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1st_po_hi  <- list(order = "S", run = 1, condition = 'structure', filter=myFilter, fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1ex_pr_lo <- list(order = "R", run = 1, condition = 'exploration', filter=myFilter, fValue=-1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1ex_po_lo <- list(order = "Q", run = 1, condition = 'exploration', filter=myFilter, fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1ex_pr_mi <- list(order = "P", run = 1, condition = 'exploration', filter=myFilter, fValue=0, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1ex_po_mi <- list(order = "O", run = 1, condition = 'exploration', filter=myFilter, fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex1ex_pr_hi <- list(order = "N", run = 1, condition = 'exploration', filter=myFilter, fValue=1, measure = 'IM_PRE_PerceivedThreat_Mean_N')
ex1ex_po_hi <- list(order = "M", run = 1, condition = 'exploration', filter=myFilter, fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex2em_lo <- list(order = "L", run = 2, condition = 'empathy', filter=myFilter, fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2em_mi <- list(order = "K", run = 2, condition = 'empathy', filter=myFilter, fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2em_hi <- list(order = "J", run = 2, condition = 'empathy', filter=myFilter, fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex2st_lo  <- list(order = "I", run = 2, condition = 'structure', filter=myFilter, fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2st_mi  <- list(order = "H", run = 2, condition = 'structure', filter=myFilter, fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2st_hi  <- list(order = "G", run = 2, condition = 'structure', filter=myFilter, fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex2ex_lo <- list(order = "F", run = 2, condition = 'exploration', filter=myFilter, fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2ex_mi <- list(order = "E", run = 2, condition = 'exploration', filter=myFilter, fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2ex_hi <- list(order = "D", run = 2, condition = 'exploration', filter=myFilter, fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ess_lo <- list(order = "C", run = 0, condition = 'ess', filter=myFilter, fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ess_mi <- list(order = "B", run = 0, condition = 'ess', filter=myFilter, fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ess_hi <- list(order = "A", run = 0, condition = 'ess', filter=myFilter, fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')


m <- list(
  ex1em_pr_lo, ex1em_po_lo, ex1em_pr_mi, ex1em_po_mi, ex1em_pr_hi, ex1em_po_hi,
  ex1st_pr_lo, ex1st_po_lo, ex1st_pr_mi, ex1st_po_mi, ex1st_pr_hi, ex1st_po_hi,
  ex1ex_pr_lo, ex1ex_po_lo, ex1ex_pr_mi, ex1ex_po_mi, ex1ex_pr_hi, ex1ex_po_hi,
  ex2em_lo, ex2em_mi, ex2em_hi,
  ex2st_lo, ex2st_mi, ex2st_hi,
  ex2ex_lo, ex2ex_mi, ex2ex_hi#,
  #ess_lo, ess_mi, ess_hi
)
lc <- "#c51b7d"
mc <- "#cccccc"
hc <- "#4d9221"
mycolors <- c(
  #hc, mc, lc,
  hc, mc, lc,
  hc, mc, lc,
  hc, mc, lc,
  hc, hc, mc, mc, lc, lc,
  hc, hc, mc, mc, lc, lc,
  hc, hc, mc, mc, lc, lc
)

plotMeasure(m,paste("perceived threat by hv", myFilter, sep = " "),100,FALSE,0.2,0.7,score_formatter_1f,mycolors,2,3, dstFile=paste("../plots/exploratory/immigration_esci_perceived_threat_by_hv_", myFilter, sep = ""))


m <- list(
  ex1em_pr_lo, ex1em_po_lo, ex1em_pr_hi, ex1em_po_hi,
  ex1st_pr_lo, ex1st_po_lo, ex1st_pr_hi, ex1st_po_hi,
  ex1ex_pr_lo, ex1ex_po_lo, ex1ex_pr_hi, ex1ex_po_hi,
  ex2em_lo, ex2em_hi,
  ex2st_lo, ex2st_hi,
  ex2ex_lo, ex2ex_hi#,
  #ess_lo, ess_hi
)
lc <- "#c51b7d"
mc <- "#cccccc"
hc <- "#4d9221"
mycolors <- c(
  hc, lc,
  hc, lc,
  hc, lc,
  hc, lc,
  hc, hc, lc, lc,
  hc, hc, lc, lc,
  hc, hc, lc, lc
)

plotMeasure(m,paste("perceived threat by hv", myFilter, sep = " "),100,FALSE,0.2,0.7,score_formatter_1f,mycolors,2,3, dstFile=paste("../plots/exploratory/immigration_esci_perceived_threat_by_hv_", myFilter, sep = ""))

# opposition pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter=myFilter, fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter=myFilter, fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter=myFilter, fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter=myFilter, fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter=myFilter, fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter=myFilter, fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter=myFilter, fValue=-1, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter=myFilter, fValue=0, measure = 'IM_DELTA_Opposition3_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter=myFilter, fValue=1, measure = 'IM_DELTA_Opposition3_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#b8e186', "#bbbbbb", '#f1b6da', "#b8e186", '#bbbbbb', '#f1b6da', '#b8e186', '#bbbbbb', '#f1b6da')

m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi,
  m3_lo, m3_hi
)
mycolors <- c('#b8e186', '#f1b6da', "#b8e186", '#f1b6da', '#b8e186', '#f1b6da')
plotMeasure(m, "opposition by hv otc delta", 100,FALSE,-0.15,0.1,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_opposition_delta_by_hv_otc")

myFilter = "sen"
# perceived threat pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter=myFilter, fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter=myFilter, fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter=myFilter, fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter=myFilter, fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter=myFilter, fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter=myFilter, fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m3_lo <- list(order = "C",run = 1, condition = 'exploration', filter=myFilter, fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_mi <- list(order = "B",run = 1, condition = 'exploration', filter=myFilter, fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m3_hi <- list(order = "A",run = 1, condition = 'exploration', filter=myFilter, fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi,
  m3_lo, m3_mi, m3_hi
)
mycolors <- c('#b8e186', "#bbbbbb", '#f1b6da', "#b8e186", '#bbbbbb', '#f1b6da', '#b8e186', '#bbbbbb', '#f1b6da')
#m <- list(
#  m1_lo, m1_hi,
#  m2_lo, m2_hi,
#  m3_lo, m3_hi
#)
#mycolors <- c('#b8e186', '#f1b6da', "#b8e186", '#f1b6da', '#b8e186', '#f1b6da')
#plotMeasure(m, "perceived threat by hv dim self delta", 100,FALSE,-0.15,0.1,score_formatter_2f, mycolors, 1.3, 3, dstFile="../plots/exploratory/immigration_esci_perceived_threat_delta_by_hv_dim_self")
plotMeasure(m,paste("perceived threat by hv", myFilter, "delta", sep = " "),100,FALSE,-0.15,0.1,score_formatter_2f, mycolors, 1.3, 3, dstFile=paste("../plots/exploratory/immigration_esci_perceived_threat_delta_by_hv_", myFilter, sep = ""))


#===================

# perceived threat pre post
m1_male <- list(order = "F",run = 1, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_female <- list(order = "E",run = 1, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_male <- list(order = "D",run = 1, condition = 'structure', filter="gender", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_female <- list(order = "C",run = 1, condition = 'structure', filter="gender", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m <- list(m1_male, m1_female, m2_male, m2_female)
mycolors <- c('#f0bca8', "#a5bfcf", '#f0bca8', "#a5bfcf", '#f0bca8', '#a5bfcf')
plotMeasure(m, "perceived threat by gender delta", 100,FALSE,-0.08,0.06,score_formatter_2f, mycolors, 2, 1, dstFile="../plots/exploratory/fig/immigration_esci_perceived_threat_delta_by_gender")


# perceived threat pre post
m1_young <- list(order = "I",run = 1, condition = 'empathy', filter="age", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_middle <- list(order = "H",run = 1, condition = 'empathy', filter="age", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_old <- list(order = "G",run = 1, condition = 'empathy', filter="age", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_young <- list(order = "F",run = 1, condition = 'structure', filter="age", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_middle <- list(order = "E",run = 1, condition = 'structure', filter="age", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_old <- list(order = "D",run = 1, condition = 'structure', filter="age", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_young, m1_middle, m1_old,
  m2_young, m2_middle, m2_old
)
mycolors <- c(
  "#06529c", "#6aadd5", "#c6dbed",
  "#06529c", "#6aadd5", "#c6dbed",
  "#06529c", "#6aadd5", "#c6dbed"
)
plotMeasure(m, "perceived threat by age delta", 100,FALSE,-0.08,0.06,score_formatter_2f, mycolors, 2, 1,dstFile="../plots/exploratory/fig/immigration_esci_perceived_threat_delta_by_age")


# perceived threat pre post
m1_lo <- list(order = "F",run = 1, condition = 'empathy', filter="education", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "E",run = 1, condition = 'empathy', filter="education", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_lo <- list(order = "D",run = 1, condition = 'structure', filter="education", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "C",run = 1, condition = 'structure', filter="education", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi
)
mycolors <- c('#d8daeb', "#fee0b6", '#d8daeb', "#fee0b6", '#d8daeb', '#fee0b6')
plotMeasure(m, "perceived threat by education delta", 100,FALSE,-0.08,0.06,score_formatter_2f, mycolors, 2, 1, dstFile="../plots/exploratory/fig/immigration_esci_perceived_threat_delta_by_educationr")

# perceived threat pre post
m1_difficult <- list(order = "I",run = 1, condition = 'empathy', filter="income", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_coping <- list(order = "H",run = 1, condition = 'empathy', filter="income", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_comfortably <- list(order = "G",run = 1, condition = 'empathy', filter="income", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_difficult <- list(order = "F",run = 1, condition = 'structure', filter="income", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_coping <- list(order = "E",run = 1, condition = 'structure', filter="income", fValue=2, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_comfortably <- list(order = "D",run = 1, condition = 'structure', filter="income", fValue=3, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_difficult, m1_coping, m1_comfortably,
  m2_difficult, m2_coping, m2_comfortably
)
mycolors <- c(
  "#d8daeb", "#dddddd", "#fee0b6",
  "#d8daeb", "#dddddd", "#fee0b6",
  "#d8daeb", "#dddddd", "#fee0b6"
)
plotMeasure(m, "perceived threat by income delta", 100,FALSE,-0.08,0.06,score_formatter_2f, mycolors, 2, 1, dstFile="../plots/exploratory/fig/immigration_esci_perceived_threat_delta_by_income")

# perceived threat pre post
m1_lo <- list(order = "F",run = 1, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_mi <- list(order = "E",run = 1, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "D",run = 1, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_lo <- list(order = "C",run = 1, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_mi <- list(order = "B",run = 1, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "A",run = 1, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi
)
#mycolors <- c('#92c5de', "#dddddd", '#f4a582', "#92c5de", '#dddddd', '#f4a582', '#92c5de', '#dddddd', '#f4a582')
mycolors <- c('#2167AC', '#AAAAAA', '#B21F2C', '#2167AC', '#AAAAAA', '#B21F2C', '#2167AC', '#AAAAAA', '#B21F2C')

plotMeasure(m, "perceived threat by religiosity delta", 100,FALSE,-0.08,0.06,score_formatter_2f, mycolors, 2, 1, dstFile="../plots/exploratory/fig/immigration_esci_perceived_threat_delta_by_religiosity")


# perceived threat pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')


m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi
)
#mycolors <- c('#92c5de', "#dddddd", '#f4a582', "#92c5de", '#dddddd', '#f4a582', '#92c5de', '#dddddd', '#f4a582')
mycolors <- c('#2167AC', '#AAAAAA', '#B21F2C', '#2167AC', '#AAAAAA', '#B21F2C', '#2167AC', '#AAAAAA', '#B21F2C')
plotMeasure(m, "perceived threat by leftright delta", 100,FALSE,-0.08,0.06,score_formatter_2f, mycolors, 2, 1, dstFile="../plots/exploratory/fig/immigration_esci_perceived_threat_delta_by_leftright")

# perceived threat pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="open", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="open", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="open", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="open", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="open", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi
)
mycolors <- c('#f3a582', "#e5e5e4", '#92c5dd', "#f3a582", '#e5e5e4', '#92c5dd', '#f3a582', '#e5e5e4', '#92c5dd')
m <- list(
  m1_lo, m1_hi,
  m2_lo, m2_hi
)
mycolors <- c('#b8e186', '#f1b6da', "#b8e186", '#f1b6da', '#b8e186', '#f1b6da')
plotMeasure(m, "perceived threat by hv dim open delta", 100,FALSE,-0.08,0.06,score_formatter_2f, mycolors, 2, 1, dstFile="../plots/exploratory/fig/immigration_esci_perceived_threat_delta_by_hv_dim_open")

# perceived threat pre post
m1_lo <- list(order = "I",run = 1, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_mi <- list(order = "H",run = 1, condition = 'empathy', filter="self", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m1_hi <- list(order = "G",run = 1, condition = 'empathy', filter="self", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')

m2_lo <- list(order = "F",run = 1, condition = 'structure', filter="self", fValue=-1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_mi <- list(order = "E",run = 1, condition = 'structure', filter="self", fValue=0, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m2_hi <- list(order = "D",run = 1, condition = 'structure', filter="self", fValue=1, measure = 'IM_DELTA_PerceivedThreat_Mean_N')
m <- list(
  m1_lo, m1_mi, m1_hi,
  m2_lo, m2_mi, m2_hi
)
mycolors <- c('#b8e186', "#bbbbbb", '#f1b6da', "#b8e186", '#bbbbbb', '#f1b6da', '#b8e186', '#bbbbbb', '#f1b6da')
plotMeasure(m, "perceived threat by hv dim self delta", 100,FALSE,-0.08,0.06,score_formatter_2f, mycolors, 2, 1, dstFile="../plots/exploratory/fig/immigration_esci_perceived_threat_delta_by_hv_dim_self")

#=========================================================


# perceivt threat
# experiment 1

# experiment 2
# empathy
m3_male <- list(order = "H", run = 2, condition = 'empathy', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_female <- list(order = "G", run = 2, condition = 'empathy', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

# sturcture
m6_male  <- list(order = "F", run = 2, condition = 'structure', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_female  <- list(order = "E", run = 2, condition = 'structure', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

# exploration
m9_male <- list(order = "D", run = 2, condition = 'exploration', filter="gender", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_female <- list(order = "C", run = 2, condition = 'exploration', filter="gender", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

fc <- "#ef8960"
mc <- "#67a8ce"
m <- list(m3_male, m3_female, m6_male, m6_female, m9_male, m9_female)
mycolors <- c(fc, mc, fc, mc, fc, mc)
plotMeasure(m,"perceivt threat by gender",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,1.3, dstFile="../plots/exploratory/fig2/immigration_esci_perceived_threat_by_gender")

# perceived threat
# empathy
m3_young <- list(order = "L", run = 2, condition = 'empathy', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_middle <- list(order = "K", run = 2, condition = 'empathy', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_old <- list(order = "J", run = 2, condition = 'empathy', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_young  <- list(order = "I", run = 2, condition = 'structure', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_middle  <- list(order = "H", run = 2, condition = 'structure', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_old  <- list(order = "G", run = 2, condition = 'structure', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_young <- list(order = "F", run = 2, condition = 'exploration', filter="age", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_middle <- list(order = "E", run = 2, condition = 'exploration', filter="age", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_old <- list(order = "D", run = 2, condition = 'exploration', filter="age", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(m3_young, m3_middle, m3_old,m6_young, m6_middle, m6_old,m9_young, m9_middle, m9_old)
yc <- "#c6dbed"
mc <- "#6aadd5"
oc <- "#06529c"
mycolors <- c(
  oc, mc, yc,
  oc, mc, yc,
  oc, mc, yc
)
plotMeasure(m,"perceived threat by age",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,1.3, dstFile="../plots/exploratory/fig2/immigration_esci_perceived_threat_by_age")



# perceived threat
m3_lo <- list(order = "H", run = 2, condition = 'empathy', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_hi <- list(order = "G", run = 2, condition = 'empathy', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_lo  <- list(order = "F", run = 2, condition = 'structure', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_hi  <- list(order = "E", run = 2, condition = 'structure', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_lo <- list(order = "D", run = 2, condition = 'exploration', filter="education", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_hi <- list(order = "C", run = 2, condition = 'exploration', filter="education", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi
)
lc <- '#e08214'
mc <- '#cccccc'
hc <- '#8073ac'
mycolors <- c(
  hc, lc,
  hc, lc,
  hc, lc

)
plotMeasure(m,"perceived threat by education",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,1.3, dstFile="../plots/exploratory/fig2/immigration_esci_perceived_threat_by_education")



# perceived threat
# empathy

m3_difficult <- list(order = "L", run = 2, condition = 'empathy', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_coping <- list(order = "K", run = 2, condition = 'empathy', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_comfortably <- list(order = "J", run = 2, condition = 'empathy', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_difficult  <- list(order = "I", run = 2, condition = 'structure', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_coping  <- list(order = "H", run = 2, condition = 'structure', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_comfortably  <- list(order = "G", run = 2, condition = 'structure', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_difficult <- list(order = "F", run = 2, condition = 'exploration', filter="income", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_coping <- list(order = "E", run = 2, condition = 'exploration', filter="income", fValue=2, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_comfortably <- list(order = "D", run = 2, condition = 'exploration', filter="income", fValue=3, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m3_difficult, m3_coping, m3_comfortably,
  m6_difficult, m6_coping, m6_comfortably,
  m9_difficult, m9_coping, m9_comfortably
)
dc <- '#e08214'
cc <- '#cccccc'
oc <- '#8073ac'

mycolors <- c(
  oc, cc, dc,
  oc, cc, dc,
  oc, cc, dc
)
plotMeasure(m,"perceived threat by income",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,1.3, dstFile="../plots/exploratory/fig2/immigration_esci_perceived_threat_by_income")




# perceived threat

m3_lo <- list(order = "I", run = 2, condition = 'empathy', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_mi <- list(order = "H", run = 2, condition = 'empathy', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_hi <- list(order = "G", run = 2, condition = 'empathy', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_lo  <- list(order = "F", run = 2, condition = 'structure', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_mi  <- list(order = "E", run = 2, condition = 'structure', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_hi  <- list(order = "D", run = 2, condition = 'structure', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_lo <- list(order = "C", run = 2, condition = 'exploration', filter="religiosity", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_mi <- list(order = "B", run = 2, condition = 'exploration', filter="religiosity", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_hi <- list(order = "A", run = 2, condition = 'exploration', filter="religiosity", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')


m <- list(
  m3_lo, m3_mi, m3_hi,
  m6_lo, m6_mi, m6_hi,
  m9_lo, m9_mi, m9_hi
)
lc <- '#b2182b'
nc <- '#cccccc'
rc <- '#2166ac'
mycolors <- c(
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc
)

plotMeasure(m,"perceived threat by religiosity",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,1.3, dstFile="../plots/exploratory/fig2/immigration_esci_perceived_threat_by_religiosity")



# perceived threat
m3_lo <- list(order = "L", run = 2, condition = 'empathy', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_mi <- list(order = "K", run = 2, condition = 'empathy', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_hi <- list(order = "J", run = 2, condition = 'empathy', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_lo  <- list(order = "I", run = 2, condition = 'structure', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_mi  <- list(order = "H", run = 2, condition = 'structure', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_hi  <- list(order = "G", run = 2, condition = 'structure', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_lo <- list(order = "F", run = 2, condition = 'exploration', filter="leftright", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_mi <- list(order = "E", run = 2, condition = 'exploration', filter="leftright", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_hi <- list(order = "D", run = 2, condition = 'exploration', filter="leftright", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')


m <- list(
  m3_lo, m3_mi, m3_hi,
  m6_lo, m6_mi, m6_hi,
  m9_lo, m9_mi, m9_hi
)
lc <- '#B21F2C'
nc <- '#AAAAAA'
rc <- '#2167AC'
mycolors <- c(
  rc, nc, lc,
  rc, nc, lc,
  rc, nc, lc
)
plotMeasure(m,"perceived threat by leftright",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,1.3, dstFile="../plots/exploratory/fig2/immigration_esci_perceived_threat_by_leftright")



# perceived threat
m3_lo <- list(order = "L", run = 2, condition = 'empathy', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_mi <- list(order = "K", run = 2, condition = 'empathy', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m3_hi <- list(order = "J", run = 2, condition = 'empathy', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m6_lo  <- list(order = "I", run = 2, condition = 'structure', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_mi  <- list(order = "H", run = 2, condition = 'structure', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m6_hi  <- list(order = "G", run = 2, condition = 'structure', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m9_lo <- list(order = "F", run = 2, condition = 'exploration', filter="open", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_mi <- list(order = "E", run = 2, condition = 'exploration', filter="open", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
m9_hi <- list(order = "D", run = 2, condition = 'exploration', filter="open", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  m3_lo, m3_hi,
  m6_lo, m6_hi,
  m9_lo, m9_hi
)
lc <- "#c51b7d"
hc <- "#4d9221"
mycolors <- c(
  hc, lc,
  hc, lc,
  hc, lc
)
plotMeasure(m,"perceived threat by hv dim open",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,1.3, dstFile="../plots/exploratory/fig2/immigration_esci_perceived_threat_by_hv_dim_open")

# perceived threat
ex2em_lo <- list(order = "L", run = 2, condition = 'empathy', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2em_mi <- list(order = "K", run = 2, condition = 'empathy', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2em_hi <- list(order = "J", run = 2, condition = 'empathy', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex2st_lo  <- list(order = "I", run = 2, condition = 'structure', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2st_mi  <- list(order = "H", run = 2, condition = 'structure', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2st_hi  <- list(order = "G", run = 2, condition = 'structure', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

ex2ex_lo <- list(order = "F", run = 2, condition = 'exploration', filter="self", fValue=-1, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2ex_mi <- list(order = "E", run = 2, condition = 'exploration', filter="self", fValue=0, measure = 'IM_POST_PerceivedThreat_Mean_N')
ex2ex_hi <- list(order = "D", run = 2, condition = 'exploration', filter="self", fValue=1, measure = 'IM_POST_PerceivedThreat_Mean_N')

m <- list(
  ex2em_lo, ex2em_mi, ex2em_hi,
  ex2st_lo, ex2st_mi, ex2st_hi,
  ex2ex_lo, ex2ex_mi, ex2ex_hi
)
lc <- "#c51b7d"
mc <- "#cccccc"
hc <- "#4d9221"
mycolors <- c(
  hc, mc, lc,
  hc, mc, lc,
  hc, mc, lc
)


plotMeasure(m,"perceived threat by hv dim self",100,FALSE,0.2,0.8,score_formatter_1f,mycolors,2,1.3, dstFile="../plots/exploratory/fig2/immigration_esci_perceived_threat_by_hv_dim_self")
