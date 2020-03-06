library(bootES)
library(scales)

path <- "C:/Users/johannes/ownCloud/FlowstoryPhD/flowstory_3/github/attitudes/data_handling/scripts"
file <- "../data_processed/merged_ex1_ex2_ess8_selection.csv"
setwd(path)

data <- read.csv(file=file, header=TRUE, sep=",")

data$IM_PRE_Opposition_Mean_N <- rescale(data$IM_PRE_Opposition_Mean, to=c(0, 1), from=c(1, 4)) #from=c(1,4))
data$IM_POST_Opposition_Mean_N <- rescale(data$IM_POST_Opposition_Mean, to=c(0,1), from=c(1,4))
data$IM_DELTA_Opposition_Mean_N <- data$IM_POST_Opposition_Mean_N - data$IM_PRE_Opposition_Mean_N

data$IM_PRE_Opposition3_Mean_N <- rescale(data$IM_PRE_Opposition3_Mean, to=c(0,1), from=c(1,4))
data$IM_POST_Opposition3_Mean_N <- rescale(data$IM_POST_Opposition3_Mean, to=c(0,1), from=c(1,4))
data$IM_DELTA_Opposition3_Mean_N <- data$IM_POST_Opposition3_Mean_N - data$IM_PRE_Opposition3_Mean_N

data$IM_PRE_PerceivedThreat_Mean_N <- rescale(data$IM_PRE_PerceivedThreat_Mean, to=c(0,1), from=c(0,10))
data$IM_POST_PerceivedThreat_Mean_N <- rescale(data$IM_POST_PerceivedThreat_Mean, to=c(0,1), from=c(0,10))
data$IM_DELTA_PerceivedThreat_Mean_N <- data$IM_POST_PerceivedThreat_Mean_N - data$IM_PRE_PerceivedThreat_Mean_N

exDisplay = "exploration"
stDisplay = "structure"
emDisplay = "empathy"

data = subset(data, RunId > 0) # exclude ESS data

contrasts <- NULL
contrasts <- append(contrasts, list(c(emDisplay, stDisplay)))
contrasts <- append(contrasts, list(c(emDisplay, exDisplay)))
contrasts <- append(contrasts, list(c(stDisplay, exDisplay)))
for (c in contrasts) {
  print(c)
}


measures <- list(c("IM_PRE_Opposition3_Mean_N", "IM_POST_Opposition3_Mean_N", "IM_PRE_PerceivedThreat_Mean_N", "IM_POST_PerceivedThreat_Mean_N"),
                 c("IM_POST_Opposition_Mean_N", "IM_POST_PerceivedThreat_Mean_N"))


runs = c(1,2)
effect = c("unstandardized", "hedges.g")
es_measure <- NULL
es_contrast1 <- NULL
es_contrast2 <- NULL
es_type <- NULL
es_estimate <- NULL
ci_min <- NULL
ci_max <- NULL
ci_bias <- NULL
ci_se <- NULL
n_g1 <- NULL
n_g2 <- NULL
run <- NULL
for (r in runs) {
  data_run <- subset(data, RunId == r)
  for (m in measures[[r]]) {
    print(paste(r, m, sep = " "))
    for (c in contrasts) {
      ndg1 <- nrow(subset(data_run, Group==c[1]))
      ndg2 <- nrow(subset(data_run, Group==c[2]))
      for (e in effect) {
        ESCI <- bootES(data_run, data.col = m, group.col="Group", contrast=c, R=10000, effect.type=e, ci.conf=0.95)
        res <- summary(ESCI)
        
        es_measure <- append(es_measure, m)
        es_contrast1 <- append(es_contrast1, c[1])
        es_contrast2 <- append(es_contrast2, c[2])
        es_type <- append(es_type, e)
        es_estimate <- append(es_estimate, res[1])
        ci_min <- append(ci_min, res[2])
        ci_max <- append(ci_max, res[3])
        ci_bias <- append(ci_bias, res[4])
        ci_se <- append(ci_se, res[5])
        n_g1 <- append(n_g1, ndg1)
        n_g2 <- append(n_g2, ndg2)
        run <- append(run, r)
      }
    }
  }
}

results <- data.frame(es_measure, es_contrast1, es_contrast2, es_type, es_estimate, ci_min, ci_max, ci_bias, ci_se, n_g1, n_g2, run)
colnames(results) <- c("measure", "group1", "group2", "effect.type", "effect.estimate", "ci.min", "ci.max", "bias", "std.error", "group1.n", "group2.n", "run")
print(results)

write.csv(results, file="../data_processed/immigration_es_ci_numeric.csv", row.names=FALSE)



cons <- c(emDisplay, stDisplay, exDisplay)
ms <- c("IM_DELTA_Opposition3_Mean_N", "IM_DELTA_PerceivedThreat_Mean_N")
condition <- NULL
measure <- NULL
es_type <- NULL
es_estimate <- NULL
ci_min <- NULL
ci_max <- NULL
ci_bias <- NULL 
ci_se <- NULL

for (con in cons) {
  d <- subset(data, (Group==con) & (RunId == 1))
  for (m in ms) {
    for (e in effect) {
      ESCI <- bootES(d, data.col = m, R=10000, effect.type = e)
      res <- summary(ESCI)
      
      condition <- append(condition, con)
      measure <- append(measure, m)
      es_type <- append(es_type, e)
      es_estimate <- append(es_estimate, res[1])
      ci_min <- append(ci_min, res[2])
      ci_max <- append(ci_max, res[3])
      ci_bias <- append(ci_bias, res[4]) 
      ci_se <- append(ci_se, res[5])
      
    }
  }
}

results <- data.frame(condition, measure, es_type, es_estimate, ci_min, ci_max, ci_bias, ci_se)
colnames(results) <- c("condition", "measure", "effect.type", "effect.estimate", "ci.min", "ci.max", "bias", "std.error")
print(results)

write.csv(results, file="../data_processed/immigration_es_ci_post_pre_numeric.csv", row.names=FALSE)


myData <- subset(data, RunId == 1)
myData <- transform(myData, open= ifelse(HV_Dimension_Open_N > 0, "c", (ifelse(HV_Dimension_Open_N < 0, "o", "u"))))
myData$GenderByCond = paste(myData$Gender, myData$Group, sep="-")
bootES(myData, data.col = "IM_DELTA_Opposition3_Mean_N", group.col="GenderByCond", contrast=c("1-structure"=-1, "2-structure"=1), effect.type="hedges.g", R=10000, ci.conf=0.95)

myData$OpenByCond = paste(myData$open, myData$Group, sep="-")
bootES(myData, data.col = "IM_DELTA_Opposition3_Mean_N", group.col="OpenByCond", contrast=c("o-structure"=-1, "c-structure"=1), effect.type="hedges.g", R=10000, ci.conf=0.95)
bootES(myData, data.col = "IM_DELTA_PerceivedThreat_Mean_N", group.col="OpenByCond", contrast=c("o-empathy"=-1, "u-empathy"=1), effect.type="hedges.g", R=10000, ci.conf=0.95)



# HUMAN VALUES

data$HV_OpennessToChange_N <- rescale(data$HV_OpennessToChange, to=c(0,1), from=c(0,6))
data$HV_Conservation_N <- rescale(data$HV_Conservation, to=c(0,1), from=c(0,6))
data$HV_SelfTranscendence_N <- rescale(data$HV_SelfTranscendence, to=c(0,1), from=c(0,6))
data$HV_SelfEnhancement_N <- rescale(data$HV_SelfEnhancement, to=c(0,1), from=c(0,6))

data$HV_Dimension_Open_N <- data$HV_OpennessToChange_N - data$HV_Conservation_N
data$HV_Dimension_Self_N <- data$HV_SelfTranscendence_N - data$HV_SelfEnhancement_N

myData2 <- subset(data, (RunId == 1) & (Group == "exploration"))
myData2 <- transform(myData2, open= ifelse(HV_Dimension_Open_N > 0, "c", (ifelse(HV_Dimension_Open_N < 0, "o", "u"))))
bootES(myData2, data.col = "IM_DELTA_Opposition3_Mean_N", group.col="open", contrast=c("o","c"), effect.type = "hedges.g", R=10000, ci.conf=0.95)
