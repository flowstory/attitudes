# -*- coding: utf-8 -*-
"""
Created on Mon Feb 12 10:50:02 2018

@author: Johannes Liem
"""
import sys, os
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

# === DATA LOADING, CLEANING, MERGING ===

# load qualtrics data
qDF = pd.read_csv("../data_raw/qualtrics_experiment_2.csv")

# remove second header, save csv, load again (for correct type recognition)
qDF.drop(qDF.index[[0,1]], inplace=True)
qDF.to_csv("../data_raw/qualtrics_experiment_2_single_header.csv", index=False)
qDF = pd.read_csv("../data_raw/qualtrics_experiment_2_single_header.csv")
#remove no consent (and so any mobile devices, wrong resolutions, etc., they never reached consent stage)
qDF = qDF[qDF.Consent == 1]

#load prolfic data
pDF = pd.read_csv("../data_raw/prolific_experiment_2.csv")

#remove rejected and timed-out submissions
pDF = pDF[(pDF.status != "Rejected") & (pDF.status != "Timed-Out")]

# merge qualtrics and prolific data
df = qDF.join(pDF.set_index("participant_id"), on="PROLIFIC_PID", how="inner")

# === CORRECTIONS ===

df.rename(index=str, columns={"Duration (in seconds)": "Duration", "condition":"Condition","Religiosity_1":"Religiosity", "Left-Right_1":"LeftRight", "Current UK area of residence":"Region", "Age":"AgeGroup", "age": "Age"}, inplace=True)

df["Group"] = df.Condition.apply(lambda c: "exploration" if c == 1 else "structure" if c==2 else "empathy")

df["Gender"].replace([3],[1], inplace=True) #one participant said PNA, but in there in prolific data sex=Male (ResponseID = R_VUc68u7pp3Lxd3H)
df["Religiosity"].replace([12],[11], inplace=True)
df["Religiosity"].replace(list(range(1,12)), list(range(0,11)),inplace=True)
df["LeftRight"].replace(list(range(1,12)), list(range(0,11)),inplace=True)
df["Income"].replace([2,3,5],[3,2,np.nan], inplace=True)
df["Education"].replace([5,6,9],[3,0,np.nan], inplace=True)
df["Region"] = df["Region"].apply(lambda r: recodeRegion(r))

hvIdx = []
hvIdxPageSubmit = []

for i in range(ord('A'), ord('U')+1):
    hvIdx.append("ESS8-H-{}".format(chr(i)))
    hvIdxPageSubmit.append("ESS8-H-{0}-Timer_Page Submit".format(chr(i)))
    df["ESS8-H-{}".format(chr(i))].replace([1,2,3,4,5,6,7],[6,5,4,3,2,1,np.nan], inplace=True)

df["ESS8-B38"].replace([5],[np.nan],inplace=True)
df["ESS8-B39"].replace([5],[np.nan],inplace=True)
df["ESS8-B40a"].replace([5],[np.nan],inplace=True)
df["ESS8-B40"].replace([5],[np.nan],inplace=True)
df["ESS8-B41_1"].replace(list(range(1,12)), list(reversed(range(0,11))),inplace=True)
df["ESS8-B42_1"].replace(list(range(1,12)), list(reversed(range(0,11))),inplace=True)
df["ESS8-B43_1"].replace(list(range(1,12)), list(reversed(range(0,11))),inplace=True)

df.loc[df.Condition == 2, "C1Timer_First Click"] = df["C2Timer_First Click"]
df.loc[df.Condition == 3, "C1Timer_First Click"] = df["C3Timer_First Click"]

df.loc[df.Condition == 2, "C1Timer_Last Click"] = df["C2Timer_Last Click"]
df.loc[df.Condition == 3, "C1Timer_Last Click"] = df["C3Timer_Last Click"]

df.loc[df.Condition == 2, "C1Timer_Page Submit"] = df["C2Timer_Page Submit"]
df.loc[df.Condition == 3, "C1Timer_Page Submit"] = df["C3Timer_Page Submit"]

df.loc[df.Condition == 2, "C1Timer_Click Count"] = df["C2Timer_Click Count"]
df.loc[df.Condition == 3, "C1Timer_Click Count"] = df["C3Timer_Click Count"]

df.rename(index=str, columns={"C1Timer_First Click":"VisTimer_First Click", "C1Timer_Last Click":"VisTimer_Last Click","C1Timer_Page Submit":"VisTimer_Page Submit","C1Timer_Click Count":"VisTimer_Click Count"}, inplace=True)

# === CALCULATIONS FOR FILTER ===

imIdx = ["ESS8-B38","ESS8-B39","ESS8-B40a","ESS8-B40","ESS8-B41_1","ESS8-B42_1","ESS8-B43_1"]
imIdx2 = ["ESS8-B38","ESS8-B39","ESS8-B40a","ESS8-B40","ESS8-B41","ESS8-B42","ESS8-B43"]
imIdxPageSubmit = ["{}-Timer_Page Submit".format(i) for i in imIdx2]

df["HV_Time_Sum"] = df[hvIdxPageSubmit].sum(axis=1)
df["HV_Time_Mean"] = df[hvIdxPageSubmit].mean(axis=1)
df["HV_Time_Median"] = df[hvIdxPageSubmit].median(axis=1)
df["HV_Time_Min"] = df[hvIdxPageSubmit].min(axis=1)
df["HV_Time_Max"] = df[hvIdxPageSubmit].max(axis=1)
df["HV_Options_Var"] = df[hvIdx].var(axis=1)
df["HV_Option_1"] = df[hvIdx][df[hvIdx] == 1].count(axis=1)
df["HV_Option_2"] = df[hvIdx][df[hvIdx] == 2].count(axis=1)
df["HV_Option_3"] = df[hvIdx][df[hvIdx] == 3].count(axis=1)
df["HV_Option_4"] = df[hvIdx][df[hvIdx] == 4].count(axis=1)
df["HV_Option_5"] = df[hvIdx][df[hvIdx] == 5].count(axis=1)
df["HV_Option_6"] = df[hvIdx][df[hvIdx] == 6].count(axis=1)
df["HV_Option_Selected_NoAnswer_Count"] = df[hvIdx].isnull().sum(axis=1)
df["HV_Option_Selected_Same_Max"] = df[["HV_Option_1", "HV_Option_2", "HV_Option_3", "HV_Option_4", "HV_Option_5", "HV_Option_6"]].max(axis=1)
df["HV_Time_ST_1_Count"] = df[hvIdxPageSubmit][df[hvIdxPageSubmit] < 1].count(axis=1)
df["HV_Time_ST_2_Count"] = df[hvIdxPageSubmit][df[hvIdxPageSubmit] < 2].count(axis=1)
df["HV_Time_ST_3_Count"] = df[hvIdxPageSubmit][df[hvIdxPageSubmit] < 3].count(axis=1)

df["IM_Time_Sum"] = df[imIdxPageSubmit].sum(axis=1)
df["IM_Time_ST_1_Count"] = df[imIdxPageSubmit][df[imIdxPageSubmit] < 1].count(axis=1)
df["IM_Time_ST_2_Count"] = df[imIdxPageSubmit][df[imIdxPageSubmit] < 2].count(axis=1)
df["IM_Time_ST_3_Count"] = df[imIdxPageSubmit][df[imIdxPageSubmit] < 3].count(axis=1)

df['IM_Opposition_NoAnswer_Count'] = df[imIdx[:4]].isnull().sum(axis=1)
df['IM_PerceivedThreat_NoAnswer_Count'] = df[imIdx[4:]].isnull().sum(axis=1)
df['IM_NoAnswer_Count'] = df['IM_Opposition_NoAnswer_Count'] + df['IM_PerceivedThreat_NoAnswer_Count']
      
df["F_CorrectAnswers_Count"] = 0      
df.loc[df["FilterColor"] == 2, "F_CorrectAnswers_Count"] += 1
df.loc[df["FilterCountry"] == 4, "F_CorrectAnswers_Count"] += 1
df.loc[df["FilterReason"] == 1, "F_CorrectAnswers_Count"] += 1

df["VIS_Log_Count"] = df.log.apply(lambda log: interactionCount(log))

df["VIS_Log_Duration"] = df.log.apply(lambda log: getTimeOfAction(log, "H"))
df["VIS_Log_Transition_Time"] = df.log.apply(lambda log: getTimeOfAction(log, "Z"))
df["VIS_Log_OK_Time"] = df.log.apply(lambda log: getTimeOfAction(log, "V"))

df.loc[df.Condition == 2, "VIS_Log_Transition_OK_Delta"] = df["VIS_Log_OK_Time"] - (df["VIS_Log_Transition_Time"] + 2)
df.loc[df.Condition == 3, "VIS_Log_Transition_OK_Delta"] = df["VIS_Log_OK_Time"] - (df["VIS_Log_Transition_Time"] + 30)
df.loc[(df.Condition == 2) | (df.Condition == 3), "VIS_Log_Duration_Exploratory"] = df["VIS_Log_Duration"] - df["VIS_Log_OK_Time"]

# === FILTER ===

df = df[(df["F_CorrectAnswers_Count"] > 0) & 
        (df["HV_Time_ST_2_Count"] <= 7) &
        (df["HV_Time_Sum"] >= 63) &
        (df["HV_Option_Selected_NoAnswer_Count"] <= 5) &
        (df["HV_Option_Selected_Same_Max"] <= 16) &
        (df['IM_Opposition_NoAnswer_Count'] <= 2) &
        (df['IM_PerceivedThreat_NoAnswer_Count'] <= 1) &
        (df["IM_Time_ST_2_Count"] <= 2) &
        (df["IM_Time_Sum"] >= 21)]   

# === HUMAN VALUES ===

# Calculate Human Values
df['HV_Conformity'] = df[[hvIdx[7-1],hvIdx[16-1]]].mean(axis=1)
df['HV_Tradition'] = df[[hvIdx[9-1],hvIdx[20-1]]].mean(axis=1)
df['HV_Benevolence'] = df[[hvIdx[12-1],hvIdx[18-1]]].mean(axis=1)
df['HV_Universalism'] = df[[hvIdx[3-1],hvIdx[8-1],hvIdx[19-1]]].mean(axis=1)
df['HV_Self-Direction'] = df[[hvIdx[1-1],hvIdx[11-1]]].mean(axis=1)
df['HV_Stimulation'] = df[[hvIdx[6-1],hvIdx[15-1]]].mean(axis=1)
df['HV_Hedonism'] = df[[hvIdx[10-1],hvIdx[21-1]]].mean(axis=1)
df['HV_Achievement'] = df[[hvIdx[4-1],hvIdx[13-1]]].mean(axis=1)
df['HV_Power'] = df[[hvIdx[2-1],hvIdx[17-1]]].mean(axis=1)
df['HV_Security'] = df[[hvIdx[5-1],hvIdx[14-1]]].mean(axis=1)

df['HV_Mrat'] = df[hvIdx].mean(axis=1)

# Calculate 4 Dimensions (Higher Oder Values)
df['HV_OpennessToChange'] = df[[hvIdx[1-1],hvIdx[11-1],hvIdx[6-1],hvIdx[15-1],hvIdx[10-1],hvIdx[21-1]]].mean(axis=1)
df['HV_Conservation'] = df[[hvIdx[5-1],hvIdx[14-1],hvIdx[7-1],hvIdx[16-1],hvIdx[9-1],hvIdx[20-1]]].mean(axis=1)
df['HV_SelfEnhancement'] = df[[hvIdx[2-1],hvIdx[17-1],hvIdx[4-1],hvIdx[13-1]]].mean(axis=1)
df['HV_SelfTranscendence'] = df[[hvIdx[3-1],hvIdx[8-1],hvIdx[19-1],hvIdx[12-1],hvIdx[18-1]]].mean(axis=1)

# Calculate 2 Dimensions
df['HV_Dimension_Open'] = df['HV_OpennessToChange'] - df['HV_Conservation']
df['HV_Dimension_Self'] = df['HV_SelfTranscendence'] - df['HV_SelfEnhancement']

# === IMMIGRATION ATTITUDES ===

# Claculate Opposition
df['IM_Opposition_Sum'] = df["ESS8-B38"] + df["ESS8-B39"] + df["ESS8-B40a"] + df["ESS8-B40"]
df['IM_Opposition3_Sum'] = df["ESS8-B38"] + df["ESS8-B39"] + df["ESS8-B40"]
df['IM_Opposition_Mean'] = df[["ESS8-B38", "ESS8-B39", "ESS8-B40a", "ESS8-B40"]].mean(axis=1)
df['IM_Opposition3_Mean'] = df[["ESS8-B38", "ESS8-B39", "ESS8-B40"]].mean(axis=1)
df['IM_Opposition_Median'] = df[["ESS8-B38", "ESS8-B39", "ESS8-B40a", "ESS8-B40"]].median(axis=1)
df['IM_Opposition3_Median'] = df[["ESS8-B38", "ESS8-B39", "ESS8-B40"]].median(axis=1)

# Claculate Perceived Threat
df['IM_PerceivedThreat_Sum'] = df["ESS8-B41_1"] + df["ESS8-B42_1"] + df["ESS8-B43_1"]
df['IM_PerceivedThreat_Mean'] = df[["ESS8-B41_1", "ESS8-B42_1", "ESS8-B43_1"]].mean(axis=1)
df['IM_PerceivedThreat_Median'] = df[["ESS8-B41_1", "ESS8-B42_1", "ESS8-B43_1"]].median(axis=1)

df.rename(index=str, columns={"ESS8-B41_1":"IM_Economic_Threat","ESS8-B42_1":"IM_Cultural_Threat","ESS8-B43_1":"IM_Overall_Threat","ESS8-B38":"IM_Opposition_Same", "ESS8-B39":"IM_Opposition_Different", "ESS8-B40a":"IM_Opposition_PoorerInEurope", "ESS8-B40":"IM_Opposition_PoorerOutEurope"}, inplace=True)

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

df.to_csv("../data_processed/qualtrics_experiment_2_github.csv", index=False)