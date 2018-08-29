# -*- coding: utf-8 -*-
"""
Created on Mon Jun 25 14:59:41 2018

@author: Johannes Liem
"""
import pandas as pd
import numpy as np
import json

def recodeRegion(r):
    regions = {
            "North West, England (Cumbria, Greater Manchester, Lancashire, Merseyside)":"UKD",
            "London, England":"UKI",
            "South East, England (Berkshire, Buckinghamshire, and Oxfordshire, Surrey, Sussex, Kent, Hampshire and Isle of Wight)":"UKJ",
            "East of England (East Anglia, Bedfordshire and Hertfordshire, Essex)":"UKH",
            "South West, England (Gloucestershire, Wiltshire and Bristol/Bath area, Dorset and Somerset, Cornwall and Isles of Scilly, Devon)":"UKK",
            "Scotland":"UKM",
            "West Midlands, England (Herefordshire, Worcestershire and Warwickshire, Shropshire and Staffordshire, West Midlands)":"UKG",
            "East Midlands, England (Derbyshire and Nottinghamshire, Leicestershire, Rutland and Northamptonshire, Lincolnshire)":"UKF",
            "Yorkshire and the Humber, England (East Riding, North Lincolnshire and Yorkshire)":"UKE",
            "Wales":"UKL",
            "North East, England    (Tees Valley, Durham, Northumberland and Tyne and Wear)":"UKC",
            "Northern Ireland":"UKN"
            }
    return regions[r.strip()]

def getTimeOfAction(log, actionQuery):
    j = json.loads(log)
    ks = list(map(int, list(j.keys())))
    start = min(ks)
    for key, event in j.items():
        time = int(key) - start
        action = event[:1]
        if actionQuery == action:
            return int(time/1000)
    return np.nan         

def interactionCount(log):
    j = json.loads(log)
    return len(j)

"""
- set the working directory
"""
baseFolder = "C:\\Users\\johannes\\ownCloud\\FlowstoryPhD\\flowstory_3\\repetition\\data_handling\\{0}"

### DATA LOADING ###

"""
- load Qualtrics data (both runs)
- remove/drop the first two rows (which are extended headers, but not required); header ("first" row) remains
- save to a new csv file
- load new csv file to existing dataframe (to associate correct data types)
"""

q2DF = pd.read_csv(baseFolder.format("results\\qualtrics_r2.csv"))
q2DF.drop(q2DF.index[[0,1]], inplace=True)
q2DF.to_csv(baseFolder.format("qualtrics_r2_single_header.csv"), index=False)
q2DF = pd.read_csv(baseFolder.format("qualtrics_r2_single_header.csv"))

"""
- load Prolific data (both runs)
"""
p2DF = pd.read_csv(baseFolder.format("results\\prolific_r2.csv"))


### DATA FILTERING: REJECTED, TIMED-OUT, BROWSER, DEVICES ###

"""
- remove Qualtrics: no consent, mobile devices, wrong browsers (they all have an empty Consent column; Thus, just keep where Consent is 1)
"""
q2DF = q2DF[q2DF.Consent == 1]

"""
- remove Prolific: rejected and timed-out submissions
"""
p2DF = p2DF[(p2DF.status != "Rejected") & (p2DF.status != "Timed-Out")]


### JOIN QUALTRICS and PROLIFC ###

"""
- Join both Dataframes on the prolific ID > all in there received payment
"""
df2 = q2DF.join(p2DF.set_index("participant_id"), on="PROLIFIC_PID", how="inner")

"""
- renaming columns
"""

df2.rename(index=str, columns={"condition":"Condition","Religiosity_1":"Religiosity", "Left-Right_1":"LeftRight", "Current UK area of residence":"Region", "Age":"AgeGroup", "age": "Age"}, inplace=True)


### DEMOGRAPHICS ###

"""
- get Gender from Prolific if PNA
- correct Religiosity for R1
- correct LeftRight for R1
- correct Income for R1/R2
- correct Education for R1/R2
"""
#df1["Gender"].replace([3],[1], inplace=True) #one participant said PNA, but in there in prolific data sex=Male (ResponseID = R_VUc68u7pp3Lxd3H)
#TODO: Handle Gender for df2 (! all provided gender)

# Religiosity now correct for R2!
# LeftRight now correct for R2!

df2["Income"].replace([5],[np.nan], inplace=True) #R2: 2,3/3,2 mix up corrected

df2["Education"].replace([5,6,9],[3,0,np.nan], inplace=True)



df2["Region"] = df2["Region"].apply(lambda r: recodeRegion(r))


### MERGE VIS COLUMNS, RENAME and REMOVE ###

df2.loc[df2.Condition == 2, "C1Timer_First Click"] = df2["C2Timer_First Click"]
df2.loc[df2.Condition == 3, "C1Timer_First Click"] = df2["C3Timer_First Click"]

df2.loc[df2.Condition == 2, "C1Timer_Last Click"] = df2["C2Timer_Last Click"]
df2.loc[df2.Condition == 3, "C1Timer_Last Click"] = df2["C3Timer_Last Click"]

df2.loc[df2.Condition == 2, "C1Timer_Page Submit"] = df2["C2Timer_Page Submit"]
df2.loc[df2.Condition == 3, "C1Timer_Page Submit"] = df2["C3Timer_Page Submit"]

df2.loc[df2.Condition == 2, "C1Timer_Click Count"] = df2["C2Timer_Click Count"]
df2.loc[df2.Condition == 3, "C1Timer_Click Count"] = df2["C3Timer_Click Count"]

df2.rename(index=str, columns={"C1Timer_First Click":"VisTimer_First Click", "C1Timer_Last Click":"VisTimer_Last Click","C1Timer_Page Submit":"VisTimer_Page Submit","C1Timer_Click Count":"VisTimer_Click Count"}, inplace=True)
df2.drop(["C2Timer_First Click","C3Timer_First Click","C2Timer_Last Click","C3Timer_Last Click","C2Timer_Page Submit","C3Timer_Page Submit","C2Timer_Click Count","C3Timer_Click Count"], axis=1, inplace=True)



### HUMAN VALUES ###

"""
- recoding of human values (flip)
"""
hvIdx = []
hvIdxPageSubmit = []

for i in range(ord('A'), ord('U')+1):
    val = "ESS8-H-{}".format(chr(i))
    hvIdx.append(val)
    hvIdxPageSubmit.append("ESS8-H-{0}-Timer_Page Submit".format(chr(i)))
    
    df2[val].replace([1,2,3,4,5,6,7],[6,5,4,3,2,1,np.nan], inplace=True)


df2["HV_Time_Sum"] = df2[hvIdxPageSubmit].sum(axis=1)
df2["HV_Time_Mean"] = df2[hvIdxPageSubmit].mean(axis=1)
df2["HV_Time_Median"] = df2[hvIdxPageSubmit].median(axis=1)
df2["HV_Time_Min"] = df2[hvIdxPageSubmit].min(axis=1)
df2["HV_Time_Max"] = df2[hvIdxPageSubmit].max(axis=1)
df2["HV_Options_Var"] = df2[hvIdx].var(axis=1)
df2["HV_Option_1"] = df2[hvIdx][df2[hvIdx] == 1].count(axis=1)
df2["HV_Option_2"] = df2[hvIdx][df2[hvIdx] == 2].count(axis=1)
df2["HV_Option_3"] = df2[hvIdx][df2[hvIdx] == 3].count(axis=1)
df2["HV_Option_4"] = df2[hvIdx][df2[hvIdx] == 4].count(axis=1)
df2["HV_Option_5"] = df2[hvIdx][df2[hvIdx] == 5].count(axis=1)
df2["HV_Option_6"] = df2[hvIdx][df2[hvIdx] == 6].count(axis=1)
df2["HV_Option_Selected_NoAnswer_Count"] = df2[hvIdx].isnull().sum(axis=1)
df2["HV_Option_Selected_Same_Max"] = df2[["HV_Option_1", "HV_Option_2", "HV_Option_3", "HV_Option_4", "HV_Option_5", "HV_Option_6"]].max(axis=1)
df2["HV_Time_ST_1_Count"] = df2[hvIdxPageSubmit][df2[hvIdxPageSubmit] < 1].count(axis=1)
df2["HV_Time_ST_2_Count"] = df2[hvIdxPageSubmit][df2[hvIdxPageSubmit] < 2].count(axis=1)
df2["HV_Time_ST_3_Count"] = df2[hvIdxPageSubmit][df2[hvIdxPageSubmit] < 3].count(axis=1)


### IMMIGRATION ATTITUDES ###

df2["ESS8-B38-PRE"].replace([5],[np.nan],inplace=True)
df2["ESS8-B39-PRE"].replace([5],[np.nan],inplace=True)
df2["ESS8-B40a-PRE"].replace([5],[np.nan],inplace=True)
df2["ESS8-B40-PRE"].replace([5],[np.nan],inplace=True)
df2["ESS8-B41-PRE_1"].replace(list(range(1,12)), list(reversed(range(0,11))),inplace=True)
df2["ESS8-B42-PRE_1"].replace(list(range(1,12)), list(reversed(range(0,11))),inplace=True)
df2["ESS8-B43-PRE_1"].replace(list(range(1,12)), list(reversed(range(0,11))),inplace=True)

df2["ESS8-B38-POST"].replace([5],[np.nan],inplace=True)
df2["ESS8-B39-POST"].replace([5],[np.nan],inplace=True)
df2["ESS8-B40a-POST"].replace([5],[np.nan],inplace=True)
df2["ESS8-B40-POST"].replace([5],[np.nan],inplace=True)
df2["ESS8-B41-POST_1"].replace(list(range(1,12)), list(reversed(range(0,11))),inplace=True)
df2["ESS8-B42-POST_1"].replace(list(range(1,12)), list(reversed(range(0,11))),inplace=True)
df2["ESS8-B43-POST_1"].replace(list(range(1,12)), list(reversed(range(0,11))),inplace=True)


imIdxPre = ["ESS8-B38-PRE","ESS8-B39-PRE","ESS8-B40a-PRE","ESS8-B40-PRE","ESS8-B41-PRE_1","ESS8-B42-PRE_1","ESS8-B43-PRE_1"]
imIdx2Pre = ["ESS8-B38-PRE","ESS8-B39-PRE","ESS8-B40a-PRE","ESS8-B40-PRE","ESS8-B41-PRE","ESS8-B42-PRE","ESS8-B43-PRE"]
imIdxPageSubmitPre = ["{}-Timer_Page Submit".format(i) for i in imIdx2Pre]

imIdxPost = ["ESS8-B38-POST","ESS8-B39-POST","ESS8-B40a-POST","ESS8-B40-POST","ESS8-B41-POST_1","ESS8-B42-POST_1","ESS8-B43-POST_1"]
imIdx2Post = ["ESS8-B38-POST","ESS8-B39-POST","ESS8-B40a-POST","ESS8-B40-POST","ESS8-B41-POST","ESS8-B42-POST","ESS8-B43-POST"]
imIdxPageSubmitPost = ["{}-Timer_Page Submit".format(i) for i in imIdx2Post]

df2["IM_PRE_Time_Sum"] = df2[imIdxPageSubmitPre].sum(axis=1)
df2["IM_PRE_Time_ST_1_Count"] = df2[imIdxPageSubmitPre][df2[imIdxPageSubmitPre] < 1].count(axis=1)
df2["IM_PRE_Time_ST_2_Count"] = df2[imIdxPageSubmitPre][df2[imIdxPageSubmitPre] < 2].count(axis=1)
df2["IM_PRE_Time_ST_3_Count"] = df2[imIdxPageSubmitPre][df2[imIdxPageSubmitPre] < 3].count(axis=1)

df2['IM_PRE_Reject_NoAnswer_Count'] = df2[imIdxPre[:4]].isnull().sum(axis=1)
df2['IM_PRE_PerceivedThreat_NoAnswer_Count'] = df2[imIdxPre[4:]].isnull().sum(axis=1)
df2['IM_PRE_NoAnswer_Count'] = df2['IM_PRE_Reject_NoAnswer_Count'] + df2['IM_PRE_PerceivedThreat_NoAnswer_Count']
      
df2["IM_POST_Time_Sum"] = df2[imIdxPageSubmitPost].sum(axis=1)
df2["IM_POST_Time_ST_1_Count"] = df2[imIdxPageSubmitPost][df2[imIdxPageSubmitPost] < 1].count(axis=1)
df2["IM_POST_Time_ST_2_Count"] = df2[imIdxPageSubmitPost][df2[imIdxPageSubmitPost] < 2].count(axis=1)
df2["IM_POST_Time_ST_3_Count"] = df2[imIdxPageSubmitPost][df2[imIdxPageSubmitPost] < 3].count(axis=1)

df2['IM_POST_Reject_NoAnswer_Count'] = df2[imIdxPost[:4]].isnull().sum(axis=1)
df2['IM_POST_PerceivedThreat_NoAnswer_Count'] = df2[imIdxPost[4:]].isnull().sum(axis=1)
df2['IM_POST_NoAnswer_Count'] = df2['IM_POST_Reject_NoAnswer_Count'] + df2['IM_POST_PerceivedThreat_NoAnswer_Count']
 


### FILTER QUESTIONS ###

df2["F_CorrectAnswers_Count"] = 0      
df2.loc[df2["FilterColor"] == 2, "F_CorrectAnswers_Count"] += 1
df2.loc[df2["FilterCountry"] == 4, "F_CorrectAnswers_Count"] += 1
df2.loc[df2["FilterReason"] == 1, "F_CorrectAnswers_Count"] += 1

### group name ####

df2["Group"] = df2.Condition.apply(lambda c: "exploration" if c == 1 else "structure" if c==2 else "empathy")


### LOGGING ###

df2["VIS_Log_Count"] = df2.log.apply(lambda log: interactionCount(log))

df2["VIS_Log_Duration"] = df2.log.apply(lambda log: getTimeOfAction(log, "H"))
df2["VIS_Log_Transition_Time"] = df2.log.apply(lambda log: getTimeOfAction(log, "Z"))
df2["VIS_Log_OK_Time"] = df2.log.apply(lambda log: getTimeOfAction(log, "V"))

df2.loc[df2.Condition == 2, "VIS_Log_Transition_OK_Delta"] = df2["VIS_Log_OK_Time"] - (df2["VIS_Log_Transition_Time"] + 2)
df2.loc[df2.Condition == 3, "VIS_Log_Transition_OK_Delta"] = df2["VIS_Log_OK_Time"] - (df2["VIS_Log_Transition_Time"] + 30)
df2.loc[(df2.Condition == 2) | (df2.Condition == 3), "VIS_Log_Duration_Exploratory"] = df2["VIS_Log_Duration"] - df2["VIS_Log_OK_Time"]

# === FILTER ===

df2 = df2[(df2["F_CorrectAnswers_Count"] > 0) & 
        (df2["HV_Time_ST_2_Count"] <= 7) &
        (df2["HV_Time_Sum"] >= 63) &
        (df2["HV_Option_Selected_NoAnswer_Count"] <= 5) &
        (df2["HV_Option_Selected_Same_Max"] <= 16) &
        (df2['IM_PRE_Reject_NoAnswer_Count'] <= 2) &
        (df2['IM_PRE_PerceivedThreat_NoAnswer_Count'] <= 1) &
        (df2["IM_PRE_Time_ST_2_Count"] <= 2) &
        (df2["IM_PRE_Time_Sum"] >= 21) &
        (df2['IM_POST_Reject_NoAnswer_Count'] <= 2) &
        (df2['IM_POST_PerceivedThreat_NoAnswer_Count'] <= 1) &
        (df2["IM_POST_Time_ST_2_Count"] <= 2) &
        (df2["IM_POST_Time_Sum"] >= 21)]   

# === HUMAN VALUES ===

# Calculate Human Values
df2['HV_Conformity'] = df2[[hvIdx[7-1],hvIdx[16-1]]].mean(axis=1)
df2['HV_Tradition'] = df2[[hvIdx[9-1],hvIdx[20-1]]].mean(axis=1)
df2['HV_Benevolence'] = df2[[hvIdx[12-1],hvIdx[18-1]]].mean(axis=1)
df2['HV_Universalism'] = df2[[hvIdx[3-1],hvIdx[8-1],hvIdx[19-1]]].mean(axis=1)
df2['HV_Self-Direction'] = df2[[hvIdx[1-1],hvIdx[11-1]]].mean(axis=1)
df2['HV_Stimulation'] = df2[[hvIdx[6-1],hvIdx[15-1]]].mean(axis=1)
df2['HV_Hedonism'] = df2[[hvIdx[10-1],hvIdx[21-1]]].mean(axis=1)
df2['HV_Achievement'] = df2[[hvIdx[4-1],hvIdx[13-1]]].mean(axis=1)
df2['HV_Power'] = df2[[hvIdx[2-1],hvIdx[17-1]]].mean(axis=1)
df2['HV_Security'] = df2[[hvIdx[5-1],hvIdx[14-1]]].mean(axis=1)

df2['HV_Mrat'] = df2[hvIdx].mean(axis=1)

# Calculate 4 Dimensions
df2['HV_OpennessToChange'] = df2[[hvIdx[1-1],hvIdx[11-1],hvIdx[6-1],hvIdx[15-1],hvIdx[10-1],hvIdx[21-1]]].mean(axis=1)
df2['HV_Conservation'] = df2[[hvIdx[5-1],hvIdx[14-1],hvIdx[7-1],hvIdx[16-1],hvIdx[9-1],hvIdx[20-1]]].mean(axis=1)
df2['HV_SelfEnhancement'] = df2[[hvIdx[2-1],hvIdx[17-1],hvIdx[4-1],hvIdx[13-1]]].mean(axis=1)
df2['HV_SelfTranscendence'] = df2[[hvIdx[3-1],hvIdx[8-1],hvIdx[19-1],hvIdx[12-1],hvIdx[18-1]]].mean(axis=1)

# Calculate 2 Dimensions
df2['HV_Dimension_Open'] = df2['HV_OpennessToChange'] - df2['HV_Conservation']
df2['HV_Dimension_Self'] = df2['HV_SelfTranscendence'] - df2['HV_SelfEnhancement']

# === IMMIGRATION ATTITUDES ===

# Claculate Opposition
df2['IM_PRE_Opposition_Sum'] = df2["ESS8-B38-PRE"] + df2["ESS8-B39-PRE"] + df2["ESS8-B40a-PRE"] + df2["ESS8-B40-PRE"]
df2['IM_PRE_Opposition3_Sum'] = df2["ESS8-B38-PRE"] + df2["ESS8-B39-PRE"] + df2["ESS8-B40-PRE"]
df2['IM_PRE_Opposition_Mean'] = df2[["ESS8-B38-PRE", "ESS8-B39-PRE", "ESS8-B40a-PRE", "ESS8-B40-PRE"]].mean(axis=1)
df2['IM_PRE_Opposition3_Mean'] = df2[["ESS8-B38-PRE", "ESS8-B39-PRE", "ESS8-B40-PRE"]].mean(axis=1)
df2['IM_PRE_Opposition_Median'] = df2[["ESS8-B38-PRE", "ESS8-B39-PRE", "ESS8-B40a-PRE", "ESS8-B40-PRE"]].median(axis=1)
df2['IM_PRE_Opposition3_Median'] = df2[["ESS8-B38-PRE", "ESS8-B39-PRE", "ESS8-B40-PRE"]].median(axis=1)

df2['IM_POST_Opposition_Sum'] = df2["ESS8-B38-POST"] + df2["ESS8-B39-POST"] + df2["ESS8-B40a-POST"] + df2["ESS8-B40-POST"]
df2['IM_POST_Opposition3_Sum'] = df2["ESS8-B38-POST"] + df2["ESS8-B39-POST"] + df2["ESS8-B40-POST"]
df2['IM_POST_Opposition_Mean'] = df2[["ESS8-B38-POST", "ESS8-B39-POST", "ESS8-B40a-POST", "ESS8-B40-POST"]].mean(axis=1)
df2['IM_POST_Opposition3_Mean'] = df2[["ESS8-B38-POST", "ESS8-B39-POST", "ESS8-B40-POST"]].mean(axis=1)
df2['IM_POST_Opposition_Median'] = df2[["ESS8-B38-POST", "ESS8-B39-POST", "ESS8-B40a-POST", "ESS8-B40-POST"]].median(axis=1)
df2['IM_POST_Opposition3_Median'] = df2[["ESS8-B38-POST", "ESS8-B39-POST", "ESS8-B40-POST"]].median(axis=1)

# Claculate Perceived Threat
df2['IM_PRE_PerceivedThreat_Sum'] = df2["ESS8-B41-PRE_1"] + df2["ESS8-B42-PRE_1"] + df2["ESS8-B43-PRE_1"]
df2['IM_PRE_PerceivedThreat_Mean'] = df2[["ESS8-B41-PRE_1", "ESS8-B42-PRE_1", "ESS8-B43-PRE_1"]].mean(axis=1)
df2['IM_PRE_PerceivedThreat_Median'] = df2[["ESS8-B41-PRE_1", "ESS8-B42-PRE_1", "ESS8-B43-PRE_1"]].median(axis=1)

df2['IM_POST_PerceivedThreat_Sum'] = df2["ESS8-B41-POST_1"] + df2["ESS8-B42-POST_1"] + df2["ESS8-B43-POST_1"]
df2['IM_POST_PerceivedThreat_Mean'] = df2[["ESS8-B41-POST_1", "ESS8-B42-POST_1", "ESS8-B43-POST_1"]].mean(axis=1)
df2['IM_POST_PerceivedThreat_Median'] = df2[["ESS8-B41-POST_1", "ESS8-B42-POST_1", "ESS8-B43-POST_1"]].median(axis=1)

rename_cols = {"ESS8-B41-PRE_1":"IM_PRE_Economic_Threat",
               "ESS8-B42-PRE_1":"IM_PRE_Cultural_Threat",
               "ESS8-B43-PRE_1":"IM_PRE_Overall_Threat",
               "ESS8-B38-PRE":"IM_PRE_Opposition_Same",
               "ESS8-B39-PRE":"IM_PRE_Opposition_Different",
               "ESS8-B40a-PRE":"IM_PRE_Opposition_PoorerInEurope",
               "ESS8-B40-PRE":"IM_PRE_Opposition_PoorerOutEurope",
               "ESS8-B41-POST_1":"IM_POST_Economic_Threat",
               "ESS8-B42-POST_1":"IM_POST_Cultural_Threat",
               "ESS8-B43-POST_1":"IM_POST_Overall_Threat",
               "ESS8-B38-POST":"IM_POST_Opposition_Same",
               "ESS8-B39-POST":"IM_POST_Opposition_Different",
               "ESS8-B40a-POST":"IM_POST_Opposition_PoorerInEurope",
               "ESS8-B40-POST":"IM_POST_Opposition_PoorerOutEurope"}
df2.rename(index=str, columns=rename_cols, inplace=True)

dropCols = ["C2Timer_First Click","C3Timer_First Click","C2Timer_Last Click","C3Timer_Last Click","C2Timer_Page Submit","C3Timer_Page Submit","C2Timer_Click Count","C3Timer_Click Count"]
dropCols += ["StartDate","EndDate","Status","IPAddress","Progress","Finished","RecipientLastName","RecipientFirstName","RecipientEmail","ExternalReference","LocationLatitude","LocationLongitude","DistributionChannel","UserLanguage"]
dropCols += ["PROLIFIC_PID","SESSION_ID","session_id","status","started_datetime","completed_date_time","time_taken","sex","language","current_country_of_residence","nationality","country_of_birth","ethnicity","student_status","employment_status","reviewed_at_datetime","entered_code","Nationality","Country of Birth","Date Of Birth", "First Language"]
dropCols += [col for col in df.columns if "MetaInfo" in col]
dropCols += [col for col in df.columns if "First Click" in col]
dropCols += [col for col in df.columns if "Last Click" in col]
dropCols += [col for col in df.columns if "Page Submit" in col]
dropCols += [col for col in df.columns if "Click Count" in col]
dropCols += [col for col in df.columns if "-PNA" in col]

df.drop(dropCols, axis=1, inplace=True)

df.to_csv("../data_processed/qualtrics_experiment_1_github.csv", index=False)