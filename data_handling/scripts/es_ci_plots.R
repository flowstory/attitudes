# Charles Perin, Johannes Liem

path <- "C:/Users/johannes/ownCloud/FlowstoryPhD/flowstory_3/github/attitudes/data_handling/scripts"

dependencies <- c("bootstrap_macros.R","plotting.R")

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

data$Group <- as.factor(data$Group)
data$ResponseId = as.factor(data$ResponseId)
data$condition = as.factor(data$Group)

print(nrow(data))

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
			condition_data <- subset(data_run , condition == tP$condition)
			values <- condition_data[[tP$measure]]
			#filer NA values
			values <- values[!is.na(values)]
			
			
			dataN = length(values)
			#print(dataN)
			
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

# age
m1 <- list(order = "G", run = 1, condition = 'empathy', measure = 'Age')
m2 <- list(order = "F", run = 1, condition = 'structure', measure = 'Age')	
m3 <- list(order = "E", run = 1, condition = 'exploration', measure = 'Age')

m4 <- list(order = "D", run = 2, condition = 'empathy', measure = 'Age')
m5 <- list(order = "C", run = 2, condition = 'structure', measure = 'Age')
m6 <- list(order = "B", run = 2, condition = 'exploration', measure = 'Age')

m7 <- list(order = "A", run = 0, condition = 'ess', measure = 'Age')

m <- list(m1, m2, m3, m4, m5, m6, m7)
mycolors <- c('#6D6E70', "#009344", "#009344", "#009344", "#652C90", "#652C90", "#652C90")
plotMeasure(m,"demog_age",100,FALSE,30,60,integer_formatter,mycolors,1.5,2, dstFile="../plots/demographics_esci_age")

# education
m1 <- list(order = "G", run = 1, condition = 'empathy', measure = 'Education_N')
m2 <- list(order = "F", run = 1, condition = 'structure', measure = 'Education_N')	
m3 <- list(order = "E", run = 1, condition = 'exploration', measure = 'Education_N')

m4 <- list(order = "D", run = 2, condition = 'empathy', measure = 'Education_N')
m5 <- list(order = "C", run = 2, condition = 'structure', measure = 'Education_N')
m6 <- list(order = "B", run = 2, condition = 'exploration', measure = 'Education_N')

m7 <- list(order = "A", run = 0, condition = 'ess', measure = 'Education_N')

m <- list(m1, m2, m3, m4, m5, m6, m7)
mycolors <- c('#6D6E70', "#009344", "#009344", "#009344", "#652C90", "#652C90", "#652C90")
plotMeasure(m,"demog_education",100,FALSE,0.45,0.75,score_formatter_1f,mycolors,1.5,2, dstFile="../plots/demographics_esci_education")

# income
m1 <- list(order = "G", run = 1, condition = 'empathy', measure = 'Income_N')
m2 <- list(order = "F", run = 1, condition = 'structure', measure = 'Income_N')	
m3 <- list(order = "E", run = 1, condition = 'exploration', measure = 'Income_N')

m4 <- list(order = "D", run = 2, condition = 'empathy', measure = 'Income_N')
m5 <- list(order = "C", run = 2, condition = 'structure', measure = 'Income_N')
m6 <- list(order = "B", run = 2, condition = 'exploration', measure = 'Income_N')

m7 <- list(order = "A", run = 0, condition = 'ess', measure = 'Income_N')

m <- list(m1, m2, m3, m4, m5, m6, m7)
mycolors <- c('#6D6E70', "#009344", "#009344", "#009344", "#652C90", "#652C90", "#652C90")
plotMeasure(m,"demog_income",100,FALSE,0.55,0.85,score_formatter_1f,mycolors,1.5,2, dstFile="../plots/demographics_esci_income")

# Religiosity_N
m1 <- list(order = "G", run = 1, condition = 'empathy', measure = 'Religiosity_N')
m2 <- list(order = "F", run = 1, condition = 'structure', measure = 'Religiosity_N')	
m3 <- list(order = "E", run = 1, condition = 'exploration', measure = 'Religiosity_N')

m4 <- list(order = "D", run = 2, condition = 'empathy', measure = 'Religiosity_N')
m5 <- list(order = "C", run = 2, condition = 'structure', measure = 'Religiosity_N')
m6 <- list(order = "B", run = 2, condition = 'exploration', measure = 'Religiosity_N')

m7 <- list(order = "A", run = 0, condition = 'ess', measure = 'Religiosity_N')

m <- list(m1, m2, m3, m4, m5, m6, m7)
mycolors <- c('#6D6E70', "#009344", "#009344", "#009344", "#652C90", "#652C90", "#652C90")
plotMeasure(m,"demog_religion",100,FALSE,0.05,0.37,score_formatter_1f,mycolors,1.5,2, dstFile="../plots/demographics_esci_religiosity")

# LeftRight_N
m1 <- list(order = "G", run = 1, condition = 'empathy', measure = 'LeftRight_N')
m2 <- list(order = "F", run = 1, condition = 'structure', measure = 'LeftRight_N')	
m3 <- list(order = "E", run = 1, condition = 'exploration', measure = 'LeftRight_N')

m4 <- list(order = "D", run = 2, condition = 'empathy', measure = 'LeftRight_N')
m5 <- list(order = "C", run = 2, condition = 'structure', measure = 'LeftRight_N')
m6 <- list(order = "B", run = 2, condition = 'exploration', measure = 'LeftRight_N')

m7 <- list(order = "A", run = 0, condition = 'ess', measure = 'LeftRight_N')

m <- list(m1, m2, m3, m4, m5, m6, m7)
mycolors <- c('#6D6E70', "#009344", "#009344", "#009344", "#652C90", "#652C90", "#652C90")
plotMeasure(m,"demog_leftright",100,FALSE,0.25,0.55,score_formatter_1f,mycolors,1.5,2, dstFile="../plots/demographics_esci_leftright")

# HV_OpennessToChange_N
m1 <- list(order = "G", run = 1, condition = 'empathy', measure = 'HV_OpennessToChange_N')
m2 <- list(order = "F", run = 1, condition = 'structure', measure = 'HV_OpennessToChange_N')	
m3 <- list(order = "E", run = 1, condition = 'exploration', measure = 'HV_OpennessToChange_N')

m4 <- list(order = "D", run = 2, condition = 'empathy', measure = 'HV_OpennessToChange_N')
m5 <- list(order = "C", run = 2, condition = 'structure', measure = 'HV_OpennessToChange_N')
m6 <- list(order = "B", run = 2, condition = 'exploration', measure = 'HV_OpennessToChange_N')

m7 <- list(order = "A", run = 0, condition = 'ess', measure = 'HV_OpennessToChange_N')

m <- list(m1, m2, m3, m4, m5, m6, m7)
mycolors <- c('#6D6E70', "#009344", "#009344", "#009344", "#652C90", "#652C90", "#652C90")
plotMeasure(m,"hv_otc",100,FALSE,0.45,0.75,score_formatter_1f,mycolors,1.5,2, dstFile="../plots/human_values_esci_openness_to_change")

# HV_Conservation_N
m1 <- list(order = "G", run = 1, condition = 'empathy', measure = 'HV_Conservation_N')
m2 <- list(order = "F", run = 1, condition = 'structure', measure = 'HV_Conservation_N')	
m3 <- list(order = "E", run = 1, condition = 'exploration', measure = 'HV_Conservation_N')

m4 <- list(order = "D", run = 2, condition = 'empathy', measure = 'HV_Conservation_N')
m5 <- list(order = "C", run = 2, condition = 'structure', measure = 'HV_Conservation_N')
m6 <- list(order = "B", run = 2, condition = 'exploration', measure = 'HV_Conservation_N')

m7 <- list(order = "A", run = 0, condition = 'ess', measure = 'HV_Conservation_N')

m <- list(m1, m2, m3, m4, m5, m6, m7)
mycolors <- c('#6D6E70', "#009344", "#009344", "#009344", "#652C90", "#652C90", "#652C90")
plotMeasure(m,"hv_con",100,FALSE,0.55,0.85,score_formatter_1f,mycolors,1.5,2, dstFile="../plots/human_values_esci_conservation")


# HV_SelfTranscendence_N
m1 <- list(order = "G", run = 1, condition = 'empathy', measure = 'HV_SelfTranscendence_N')
m2 <- list(order = "F", run = 1, condition = 'structure', measure = 'HV_SelfTranscendence_N')	
m3 <- list(order = "E", run = 1, condition = 'exploration', measure = 'HV_SelfTranscendence_N')

m4 <- list(order = "D", run = 2, condition = 'empathy', measure = 'HV_SelfTranscendence_N')
m5 <- list(order = "C", run = 2, condition = 'structure', measure = 'HV_SelfTranscendence_N')
m6 <- list(order = "B", run = 2, condition = 'exploration', measure = 'HV_SelfTranscendence_N')

m7 <- list(order = "A", run = 0, condition = 'ess', measure = 'HV_SelfTranscendence_N')

m <- list(m1, m2, m3, m4, m5, m6, m7)
mycolors <- c('#6D6E70', "#009344", "#009344", "#009344", "#652C90", "#652C90", "#652C90")
plotMeasure(m,"hv_st",100,FALSE,0.65,0.95,score_formatter_1f,mycolors,1.5,2, dstFile="../plots/human_values_esci_self_transcendence")

# HV_SelfEnhancement_N
m1 <- list(order = "G", run = 1, condition = 'empathy', measure = 'HV_SelfEnhancement_N')
m2 <- list(order = "F", run = 1, condition = 'structure', measure = 'HV_SelfEnhancement_N')	
m3 <- list(order = "E", run = 1, condition = 'exploration', measure = 'HV_SelfEnhancement_N')

m4 <- list(order = "D", run = 2, condition = 'empathy', measure = 'HV_SelfEnhancement_N')
m5 <- list(order = "C", run = 2, condition = 'structure', measure = 'HV_SelfEnhancement_N')
m6 <- list(order = "B", run = 2, condition = 'exploration', measure = 'HV_SelfEnhancement_N')

m7 <- list(order = "A", run = 0, condition = 'ess', measure = 'HV_SelfEnhancement_N')

m <- list(m1, m2, m3, m4, m5, m6, m7)
mycolors <- c('#6D6E70', "#009344", "#009344", "#009344", "#652C90", "#652C90", "#652C90")
plotMeasure(m,"hv_se",100,FALSE,0.35,0.65,score_formatter_1f,mycolors,1.5,2, dstFile="../plots/human_values_esci_self_enhancement")

#opposition post 1 2 Opposition
m1 <- list(order = "J", run = 2, condition = 'empathy', measure = 'IM_PRE_Opposition3_Mean_N', color="red")
m2 <- list(order = "I", run = 2, condition = 'empathy', measure = 'IM_POST_Opposition3_Mean_N', color="red")
m3 <- list(order = "H", run = 1, condition = 'empathy', measure = 'IM_POST_Opposition3_Mean_N', color="green")

m4 <- list(order = "G", run = 2, condition = 'structure', measure = 'IM_PRE_Opposition3_Mean_N', color="red")	
m5 <- list(order = "F", run = 2, condition = 'structure', measure = 'IM_POST_Opposition3_Mean_N', color="red")
m6 <- list(order = "E", run = 1, condition = 'structure', measure = 'IM_POST_Opposition3_Mean_N', color="green")

m7 <- list(order = "D", run = 2, condition = 'exploration', measure = 'IM_PRE_Opposition3_Mean_N', color="red")
m8 <- list(order = "C", run = 2, condition = 'exploration', measure = 'IM_POST_Opposition3_Mean_N', color="red")
m9 <- list(order = "B", run = 1, condition = 'exploration', measure = 'IM_POST_Opposition3_Mean_N', color="green")

m10 <- list(order = "A", run = 0, condition = 'ess', measure = 'IM_POST_Reject3_Mean_N', color="gray")

m <- list(m1, m2, m3, m4, m5, m6, m7, m8, m9, m10)
mycolors <- c('#6D6E70', "#009344", "#652C90", "#A07AB6", "#009344", "#652C90", "#A07AB6", "#009344", "#652C90", "#A07AB6")
plotMeasure(m,"opposition",100,FALSE,0.3,0.5,score_formatter_1f,mycolors,2,3)	



#perceived threat
m1 <- list(order = "J", run = 1, condition = 'empathy', measure = 'IM_PRE_PerceivedThreat_Mean_N', color="red")
m2 <- list(order = "I", run = 1, condition = 'empathy', measure = 'IM_POST_PerceivedThreat_Mean_N', color="red")
m3 <- list(order = "H", run = 2, condition = 'empathy', measure = 'IM_POST_PerceivedThreat_Mean_N', color="green")

m4 <- list(order = "G", run = 1, condition = 'structure', measure = 'IM_PRE_PerceivedThreat_Mean_N', color="red")	
m5 <- list(order = "F", run = 1, condition = 'structure', measure = 'IM_POST_PerceivedThreat_Mean_N', color="red")
m6 <- list(order = "E", run = 2, condition = 'structure', measure = 'IM_POST_PerceivedThreat_Mean_N', color="green")

m7 <- list(order = "D", run = 1, condition = 'exploration', measure = 'IM_PRE_PerceivedThreat_Mean_N', color="red")
m8 <- list(order = "C", run = 1, condition = 'exploration', measure = 'IM_POST_PerceivedThreat_Mean_N', color="red")
m9 <- list(order = "B", run = 2, condition = 'exploration', measure = 'IM_POST_PerceivedThreat_Mean_N', color="green")

m10 <- list(order = "A", run = 0, condition = 'ess', measure = 'IM_POST_PerceivedThreat_Mean_N', color="gray")

m <- list(m1, m2, m3, m4, m5, m6, m7, m8, m9, m10)
mycolors <- c('#6D6E70', "#009344", "#652C90", "#A07AB6", "#009344", "#652C90", "#A07AB6", "#009344", "#652C90", "#A07AB6")
plotMeasure(m,"perceived threat",100,FALSE,0.3,0.5,score_formatter_1f,mycolors,2,3)	

m1 <- list(order = "C",run = 2, condition = 'empathy', measure = 'IM_DELTA_Reject3_Mean_N', color="red")
m2 <- list(order = "B",run = 2, condition = 'structure', measure = 'IM_DELTA_Reject3_Mean_N', color="red")
m3 <- list(order = "A",run = 2, condition = 'exploration', measure = 'IM_DELTA_Reject3_Mean_N', color="red")
m <- list(m1, m2, m3)
mycolors <- c('#939597', "#939597", "#939597")
plotMeasure(m, "opposition delta", 100,FALSE,-0.04,0.025,score_formatter_2f, mycolors, 1.3, 3)	

m1 <- list(order = "C",run = 2, condition = 'empathy', measure = 'IM_DELTA_PerceivedThreat_Mean_N', color="red")
m2 <- list(order = "B",run = 2, condition = 'structure', measure = 'IM_DELTA_PerceivedThreat_Mean_N', color="red")
m3 <- list(order = "A",run = 2, condition = 'exploration', measure = 'IM_DELTA_PerceivedThreat_Mean_N', color="red")
m <- list(m1, m2, m3)
mycolors <- c('#939597', "#939597", "#939597")
plotMeasure(m, "perceived threat delta", 100,FALSE,-0.04,0.025,score_formatter_2f, mycolors, 1.3, 3)	
