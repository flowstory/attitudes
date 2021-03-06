# -*- coding: utf-8 -*-
"""
Created on Mon Jul 16 14:32:20 2018

@author: johannes
"""

import pandas as pd

ess8 = pd.read_csv("../data_processed/ess8_filtered.csv")
ex1 = pd.read_csv("../data_processed/experiment_1_filtered.csv")
ex2 = pd.read_csv("../data_processed/experiment_2_filtered.csv")

#Add RunId 0...ess, 1...run1, 2...run2
ess8['RunId'] = 0
ex1['RunId'] = 1
ex2['RunId'] = 2

# rename HV in ESS
targetMap = ["ipcrtiv","imprich","ipeqopt","ipshabt","impsafe","impdiff","ipfrule","ipudrst","ipmodst","ipgdtim","impfree","iphlppl","ipsuces","ipstrgv","ipadvnt","ipbhprp","iprspot","iplylfr","impenv","imptrad","impfun"]
colRenameHvDict = {}
c = 0
for i in range(ord('A'), ord('U')+1):
    colRenameHvDict[targetMap[c]] = "ESS8-H-{}".format(chr(i))
    c +=1

ess8.rename(index=str, columns=colRenameHvDict, inplace=True)

#rename cols: add POST to ESS and ex2 where required!
rename_cols = {'IM_Opposition_Mean': 'IM_POST_Opposition_Mean',
               'IM_Opposition3_Mean': 'IM_POST_Opposition3_Mean',
               "IM_PerceivedThreat_Mean": "IM_POST_PerceivedThreat_Mean",
               'IM_Opposition_Sum': 'IM_POST_Opposition_Sum',
               'IM_Opposition3_Sum': 'IM_POST_Opposition3_Sum',
               "IM_PerceivedThreat_Sum": "IM_POST_PerceivedThreat_Sum",
               "IM_Economic_Threat": "IM_POST_Economic_Threat",
               "IM_Cultural_Threat": "IM_POST_Cultural_Threat",
               "IM_Overall_Threat": "IM_POST_Overall_Threat",
               "IM_Opposition_Same": "IM_POST_Opposition_Same",
               "IM_Opposition_Different": "IM_POST_Opposition_Different",
               "IM_Opposition_PoorerInEurope": "IM_POST_Opposition_PoorerInEurope",
               "IM_Opposition_PoorerOutEurope": "IM_POST_Opposition_PoorerOutEurope",
               'IM_Opposition_Median': 'IM_POST_Opposition_Median',
               'IM_Opposition3_Median': 'IM_POST_Opposition3_Median',
               'IM_PerceivedThreat_Median': 'IM_POST_PerceivedThreat_Median',
               "IM_Opposition_NoAnswer_Count":"IM_POST_Opposition_NoAnswer_Count",
               "IM_NoAnswer_Count": "IM_POST_NoAnswer_Count",
               "IM_PerceivedThreat_NoAnswer_Count": "IM_POST_PerceivedThreat_NoAnswer_Count",
               "IM_Time_Sum":"IM_POST_Time_Sum",
               "IM_Time_ST_1_Count":"IM_POST_Time_ST_1_Count",
               "IM_Time_ST_2_Count":"IM_POST_Time_ST_2_Count",
               "IM_Time_ST_3_Count":"IM_POST_Time_ST_3_Count"}

ex2.rename(index=str, columns=rename_cols, inplace=True)
ess8.rename(index=str, columns=rename_cols, inplace=True)
      
merged = pd.concat([ex1, ex2, ess8], join="outer")

merged.to_csv("../data_processed/merged_ex1_ex2_ess8.csv", index=False)

#Selected Columns for R
user = ["ResponseId", "RunId", "Group", "Condition", "StartDate", "EndDate", "F_CorrectAnswers_Count"]
demogs = ["Gender", "Age", "Education", "Income", "Religiosity", "LeftRight", "Region"]
hv = ["HV_OpennessToChange", "HV_Conservation", "HV_SelfTranscendence", "HV_SelfEnhancement", "HV_Dimension_Open", "HV_Dimension_Self"]
im = ["IM_PRE_Opposition_Mean","IM_POST_Opposition_Mean","IM_PRE_Opposition3_Mean", "IM_POST_Opposition3_Mean", "IM_PRE_PerceivedThreat_Mean", "IM_POST_PerceivedThreat_Mean", "IM_PRE_Opposition_Same", "IM_POST_Opposition_Same", "IM_PRE_Opposition_Different", "IM_POST_Opposition_Different", "IM_PRE_Opposition_PoorerInEurope", "IM_POST_Opposition_PoorerInEurope", "IM_PRE_Opposition_PoorerOutEurope", "IM_POST_Opposition_PoorerOutEurope", "IM_PRE_Economic_Threat", "IM_POST_Economic_Threat", "IM_PRE_Cultural_Threat", "IM_POST_Cultural_Threat", "IM_PRE_Overall_Threat", "IM_POST_Overall_Threat"]
selection = user + demogs + hv + im
merged[selection].to_csv("../data_processed/merged_ex1_ex2_ess8_selection.csv", index=False)