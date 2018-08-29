# -*- coding: utf-8 -*-
"""
Created on Tue Feb 20 22:40:07 2018

@author: Johannes Liem
"""

import os, sys
import pandas as pd
import numpy as np

ess8 = pd.read_csv("../data_raw/ESS8GB.csv")

# apply prolific filters: Nationality not UK, Country of Birth not UK, Language (spoken at home) != ENG, Age < 18
ess8.drop(ess8[(ess8.ctzcntr != 1) | (ess8.brncntr != 1) | (ess8.lnghom1 != "ENG") | (ess8.agea < 18)].index, inplace=True)

# just keep selected columns: using the same demographic variables, human values scale variables, and anti-immigration attitudes variables
colsDemo = ["idno", "lrscale","rlgdgr","gndr","agea","edubgb1", "eduagb2","hincfel","region","inwdde","inwmme","inwyye"]
colsIM = ["imsmetn","imdfetn","impcntr","imbgeco","imueclt","imwbcnt"]
colsHV = ["ipcrtiv","imprich","ipeqopt","ipshabt","impsafe","impdiff","ipfrule","ipudrst","ipmodst","ipgdtim","impfree","iphlppl","ipsuces","ipstrgv","ipadvnt","ipbhprp","iprspot","iplylfr","impenv","imptrad","impfun"]
ess8 = ess8[colsDemo + colsIM + colsHV]

ess8["Condition"] = 0
ess8["Group"] = "ess"

ess8["RecordedDate"] = ess8.apply(lambda row: "{0}-{1}-{2} 00:00:00".format(row["inwyye"], row["inwmme"], row["inwdde"]), axis=1)


# recode variables

ess8.lrscale.replace([77,88,99],[np.nan, np.nan, np.nan], inplace=True)
ess8.rlgdgr.replace([77,88,99],[np.nan, np.nan, np.nan], inplace=True)
ess8.agea.replace([999], [np.nan], inplace=True)
ess8.hincfel.replace([1,2,3,4,7,8,9],[4,3,2,1,np.nan, np.nan, np.nan],inplace=True)

ess8.imsmetn.replace([7,8,9],[np.nan, np.nan, np.nan],inplace=True)
ess8.imdfetn.replace([7,8,9],[np.nan, np.nan, np.nan],inplace=True)
ess8.impcntr.replace([7,8,9],[np.nan, np.nan, np.nan],inplace=True)

ess8.imbgeco.replace([77,88,99],[np.nan, np.nan, np.nan],inplace=True)
ess8.imueclt.replace([77,88,99],[np.nan, np.nan, np.nan],inplace=True)
ess8.imwbcnt.replace([77,88,99],[np.nan, np.nan, np.nan],inplace=True)

ess8.imbgeco.replace(list(range(0,11)), list(reversed(range(0,11))),inplace=True)
ess8.imueclt.replace(list(range(0,11)), list(reversed(range(0,11))),inplace=True)
ess8.imwbcnt.replace(list(range(0,11)), list(reversed(range(0,11))),inplace=True)

ess8.edubgb1.replace([1,2,3,4,5,6,7,7777,8888],[2,2,1,1,1,0,0,np.nan,np.nan],inplace=True)
ess8.eduagb2.replace([1,2,3,4,5,6,7,8,9,10,11,5555,7777,8888],[4,4,4,3,3,3,3,2,2,2,0,0,np.nan,np.nan],inplace=True)
ess8["Education"] = ess8[["edubgb1", "eduagb2"]].max(axis=1)
ess8.drop(["edubgb1", "eduagb2"], axis=1, inplace=True)

ess8.rename(index=str, columns={"idno": "ResponseId", "rlgdgr":"Religiosity", "agea":"Age", "gndr":"Gender", "lrscale":"LeftRight", "hincfel":"Income", "region":"Region"}, inplace=True)

for hv in colsHV:
    ess8[hv].replace([1,2,3,4,5,6,7,8,9],[6,5,4,3,2,1, np.nan, np.nan, np.nan],inplace=True)

ess8["HV_Option_1"] = ess8[colsHV][ess8[colsHV] == 1].count(axis=1)
ess8["HV_Option_2"] = ess8[colsHV][ess8[colsHV] == 2].count(axis=1)
ess8["HV_Option_3"] = ess8[colsHV][ess8[colsHV] == 3].count(axis=1)
ess8["HV_Option_4"] = ess8[colsHV][ess8[colsHV] == 4].count(axis=1)
ess8["HV_Option_5"] = ess8[colsHV][ess8[colsHV] == 5].count(axis=1)
ess8["HV_Option_6"] = ess8[colsHV][ess8[colsHV] == 6].count(axis=1)
ess8["HV_Option_Selected_NoAnswer_Count"] = ess8[colsHV].isnull().sum(axis=1)
ess8["HV_Option_Selected_Same_Max"] = ess8[["HV_Option_1", "HV_Option_2", "HV_Option_3", "HV_Option_4", "HV_Option_5", "HV_Option_6"]].max(axis=1)

ess8['IM_Opposition_NoAnswer_Count'] = ess8[colsIM[:3]].isnull().sum(axis=1)
ess8['IM_PerceivedThreat_NoAnswer_Count'] = ess8[colsIM[3:]].isnull().sum(axis=1)

#apply filters regarding no answer (time filters not possible here!)
ess8 = ess8[(ess8["HV_Option_Selected_NoAnswer_Count"] <= 5) &
        (ess8["HV_Option_Selected_Same_Max"] <= 16) &
        (ess8['IM_Opposition_NoAnswer_Count'] <= 1) &
        (ess8['IM_PerceivedThreat_NoAnswer_Count'] <= 1)]   

# calculate scores higher order values and two hv ho dimensions
ess8['HV_Conformity'] = ess8[[colsHV[7-1],colsHV[16-1]]].mean(axis=1)
ess8['HV_Tradition'] = ess8[[colsHV[9-1],colsHV[20-1]]].mean(axis=1)
ess8['HV_Benevolence'] = ess8[[colsHV[12-1],colsHV[18-1]]].mean(axis=1)
ess8['HV_Universalism'] = ess8[[colsHV[3-1],colsHV[8-1],colsHV[19-1]]].mean(axis=1)
ess8['HV_Self-Direction'] = ess8[[colsHV[1-1],colsHV[11-1]]].mean(axis=1)
ess8['HV_Stimulation'] = ess8[[colsHV[6-1],colsHV[15-1]]].mean(axis=1)
ess8['HV_Hedonism'] = ess8[[colsHV[10-1],colsHV[21-1]]].mean(axis=1)
ess8['HV_Achievement'] = ess8[[colsHV[4-1],colsHV[13-1]]].mean(axis=1)
ess8['HV_Power'] = ess8[[colsHV[2-1],colsHV[17-1]]].mean(axis=1)
ess8['HV_Security'] = ess8[[colsHV[5-1],colsHV[14-1]]].mean(axis=1)

ess8['HV_Mrat'] = ess8[colsHV].mean(axis=1)

# Calculate 4 Dimensions
ess8['HV_OpennessToChange'] = ess8[[colsHV[1-1],colsHV[11-1],colsHV[6-1],colsHV[15-1],colsHV[10-1],colsHV[21-1]]].mean(axis=1)
ess8['HV_Conservation'] = ess8[[colsHV[5-1],colsHV[14-1],colsHV[7-1],colsHV[16-1],colsHV[9-1],colsHV[20-1]]].mean(axis=1)
ess8['HV_SelfEnhancement'] = ess8[[colsHV[2-1],colsHV[17-1],colsHV[4-1],colsHV[13-1]]].mean(axis=1)
ess8['HV_SelfTranscendence'] = ess8[[colsHV[3-1],colsHV[8-1],colsHV[19-1],colsHV[12-1],colsHV[18-1]]].mean(axis=1)

# Calculate 2 Dimensions
ess8['HV_Dimension_Open'] = ess8['HV_OpennessToChange'] - ess8['HV_Conservation']
ess8['HV_Dimension_Self'] = ess8['HV_SelfTranscendence'] - ess8['HV_SelfEnhancement']

# calculate anti immigration higher order variables: Reject, PerceivedThreat
ess8["IM_Opposition3_Mean"] = ess8[["imsmetn","imdfetn","impcntr"]].mean(axis=1)
ess8["IM_Opposition3_Sum"] = ess8[["imsmetn","imdfetn","impcntr"]].sum(axis=1)
ess8["IM_Opposition3_Median"] = ess8[["imsmetn","imdfetn","impcntr"]].median(axis=1)
ess8["IM_PerceivedThreat_Mean"] = ess8[["imbgeco","imueclt","imwbcnt"]].mean(axis=1)
ess8["IM_PerceivedThreat_Sum"] = ess8[["imbgeco","imueclt","imwbcnt"]].sum(axis=1)
ess8["IM_PerceivedThreat_Median"] = ess8[["imbgeco","imueclt","imwbcnt"]].median(axis=1)

ess8.rename(index=str, columns={"imbgeco": "IM_Economic_Threat", "imueclt":"IM_Cultural_Threat", "imwbcnt":"IM_Overall_Threat", "imsmetn":"IM_Opposition_Same", "imdfetn":"IM_Opposition_Different", "impcntr":"IM_Opposition_PoorerOutEurope"}, inplace=True)

dropCols = ["inwyye", "inwmme", "inwdde"]
ess8.drop(dropCols, axis=1, inplace=True)

ess8.to_csv("../data_processed/ess8_filtered.csv", index=False)