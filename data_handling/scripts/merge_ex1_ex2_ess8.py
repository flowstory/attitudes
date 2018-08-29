# -*- coding: utf-8 -*-
"""
Created on Mon Jul 16 14:32:20 2018

@author: johannes
"""

import pandas as pd

ess8 = pd.read_csv("../data_processed/ess8_filtered_github.csv")
ex1 = pd.read_csv("../data_processed/qualtrics_experiment_1_github.csv")
ex2 = pd.read_csv("../data_processed/qualtrics_experiment_2_github.csv")

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
               "IM_Economic_Threat": "IM_POST_Economic_Threat",
               "IM_Cultural_Threat":"IM_POST_Cultural_Threat",
               "IM_Overall_Threat":"IM_POST_Overall_Threat",
               "IM_Opposition_Same":"IM_POST_Opposition_Same",
               "IM_Opposition_Different":"IM_POST_Opposition_Different",
               "IM_Opposition_PoorerInEurope":"IM_POST_Opposition_PoorerInEurope",
               "IM_Opposition_PoorerOutEurope":"IM_POST_Opposition_PoorerOutEurope",
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

merged.to_csv("../data_processed/ex1_ex2_ess8_merged.csv", index=False)