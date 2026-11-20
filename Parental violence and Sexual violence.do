
*******2018 NDHS
use "NGIR7AFL.DTA", clear
***Generate surveys
gen survey = 2018
*****Generating cluster and strata
egen clusterid=group(survey v001), label
egen stratumid=group(survey v023), label

***Target population (adolescent, never married and domestic module)
gen pop=0
replace pop=1 if (v013==1 & v502==0 & v044==1)
ta pop

****Involuntary performance of sexual acts
fre d125
recode d125(0=0 "No")(1=1 "Yes")(6=2 "Refused"), gen(sex_vio)
ta sex_vio if pop==1

****Parental violence
***Father beat mother
fre d121
clonevar father_vio = d121
recode father_vio (8=0)
fre father_vio if pop==1
***Mother hurt respondent
fre d115b if pop==1
clonevar mother_hurt = d115b
ta mother_hurt if pop==1
***Father hurt respondent
fre d115c
clonevar father_hurt = d115c
ta father_hurt if pop==1
***generate parental violence
gen parental_vio =.
replace parental_vio=1 if (father_vio==1 | mother_hurt==1 | father_hurt==1)
replace parental_vio=1 if (father_vio==1 & mother_hurt==1 & father_hurt==1)
replace parental_vio=0 if (father_vio==0 & mother_hurt==0 & father_hurt==0)
ta parental_vio if pop==1,m

****Risky sexual behaviour
***No sex
fre v525
gen no_sex=.
replace no_sex=1 if v525==0
replace no_sex=0 if inrange(v525,8,45) 
ta no_sex if pop==1

***Early sexual debut
fre v525 if pop==1
gen early_sex =.
replace early_sex=1 if (v525 < 15) & (no_sex == 0)
replace early_sex=0 if (v525 >= 15) & (no_sex == 0)
recode early_sex (97=.)
la def early_sex 0 "Not early" 1 "Early", modify
la val early_sex early_sex
ta early_sex if pop==1

***Pattern of contraceptive use 
fre v361
gen nocondomuse =. if no_sex ==1
replace nocondomuse=0 if (v361 < 4 & no_sex ==0) 
replace nocondomuse=1 if (v361==4 & no_sex ==0) 
ta nocondomuse if pop==1

***Multiple sex partnerships
fre v836 if pop==1
gen multiple_sex =.
fre multiple_sex
replace multiple_sex=. if (multiple_sex==98)
replace multiple_sex=1 if (multiple_sex >= 2) & (no_sex ==0) 
replace multiple_sex=0 if (v836 ==1) & (no_sex ==0) 
ta multiple_sex if pop==1

***Risky sexual behaviors
egen risk_sex = rowtotal(early_sex nocondomuse multiple_sex)
gen riskysex = risk_sex
replace riskysex=. if (risk_sex==0) & (early_sex==. & nocondomuse==. & multiple_sex==.)
replace riskysex=4 if no_sex ==1
recode riskysex (0=1 "Low risk")(1/3=2 "High-risk")(4=0 "Abstained/No risk"), gen(risky_sex)
ta risky_sex if pop==1

****Wealth
fre v190
clonevar wealth = v190
ta wealth if pop==1

***Education
ta v106
clonevar edu = v106
ta edu if pop==1

****Religion
fre v130 if pop==1
gen xtians=v130<=2
ta xtians if pop==1

****Ethnicity
fre v131
recode v131 (2/3 8=1 "Fulani/Hausa/Kanuri")(6=2 "Igbo")(10=3 "Yoruba")(else=4 "Others"), gen(ethnic)
ta ethnic if pop==1

***Residence
fre v025
clonevar residence = v025
ta residence if pop==1

***Region
fre v024
clonevar region = v024
ta region if pop==1

**Keep variables of interest
keep d005 survey clusterid stratumid pop sex_vio parental_vio risky_sex wealth ///
edu xtians ethnic residence region v012

**Save data
save 2018_data, replace

**********2013 NDHS************************
use "NGIR6AFL.DTA", clear
set more off
***Generate surveys
gen survey = 2013
*****Generating cluster and strata
egen clusterid=group(survey v001), label
egen stratumid=group(survey v023), label

***Target population
gen pop=0
replace pop=1 if (v013==1 & v502==0 & v044==1)
ta pop

****Involuntary performance of sexual acts
fre d125
recode d125(0=0 "No")(1=1 "Yes")(6=2 "Refused")(9=.), gen(sex_vio)
ta sex_vio if pop==1

****Parental violence
***Father beat mother
fre d121 if pop==1
clonevar father_vio = d121
recode father_vio (8=0)(9=.)
fre father_vio if pop==1
***Mother hurt respondent
fre d115b if pop==1
clonevar mother_hurt = d115b
recode mother_hurt (9=.)
ta mother_hurt if pop==1
***Father hurt respondent
fre d115c if pop==1
clonevar father_hurt = d115c
recode father_hurt (9=.)
ta father_hurt if pop==1
***generate parental violence
gen parental_vio =.
replace parental_vio=1 if (father_vio==1 | mother_hurt==1 | father_hurt==1)
replace parental_vio=1 if (father_vio==1 & mother_hurt==1 & father_hurt==1)
replace parental_vio=0 if (father_vio==0 & mother_hurt==0 & father_hurt==0)
ta parental_vio if pop==1

****Risky sexual behaviour
***No sex
fre v525 if pop==1 // not of the target sample is has code 96 to 99
gen no_sex=.
replace no_sex=1 if v525==0
replace no_sex=0 if inrange(v525,8,45) 
ta no_sex if pop==1

***Early sexual debut
fre v525 if pop==1
gen early_sex =.
replace early_sex=1 if (v525 < 15) & (no_sex == 0)
replace early_sex=0 if (v525 >= 15) & (no_sex ==0)
recode early_sex (99=.)
la def early_sex 0 "Not early" 1 "Early", modify
la val early_sex early_sex
ta early_sex if pop==1

***Pattern of condom use 
fre v361
gen nocondomuse =. if no_sex ==1
replace nocondomuse=0 if (v361 < 4 & no_sex ==0) 
replace nocondomuse=1 if (v361==4 & no_sex ==0) 
ta nocondomuse if pop==1

***Multiple sex partnerships
fre v836 if pop==1
gen multiple_sex =.
fre multiple_sex
replace multiple_sex=. if (multiple_sex >=98)
replace multiple_sex=1 if (multiple_sex >= 2) & (no_sex ==0) 
replace multiple_sex=0 if (v836 ==1) & (no_sex ==0) 
ta multiple_sex if pop==1

***Risky sexual behaviours
egen risk_sex = rowtotal(early_sex nocondomuse multiple_sex)
gen riskysex = risk_sex
replace riskysex=. if (risk_sex==0) & (early_sex==. & nocondomuse==. & multiple_sex==.)
replace riskysex=4 if no_sex ==1
recode riskysex (0=1 "Low risk")(1/3=2 "High-risk")(4=0 "Abstained/No risk"), gen(risky_sex)
ta risky_sex if pop==1

****Wealth
fre v190
clonevar wealth = v190
ta wealth if pop==1

***Education
ta v106
clonevar edu = v106
ta edu if pop==1

****Religion
fre v130
gen xtians=v130<=2
ta xtians if pop==1

****Ethnicity
fre v131
numlabel, add
ta v131
recode v131 (109 130 179=1 "Fulani/Hausa/Kanuri or Beri beri")(138=2 "Igbo")(298=3 "Yoruba")(else=4 "Others"), gen(ethnic)
ta ethnic if pop==1

***Residence
fre v025
clonevar residence = v025
ta residence if pop==1

***Region
fre v024
clonevar region = v024
ta region if pop==1

***Keep variables of interest
keep d005 survey clusterid stratumid pop sex_vio parental_vio risky_sex wealth ///
edu xtians ethnic residence region v012

**Save data
save 2013_data, replace

***Combine data
use 2018_data, clear
append using 2013_data
ta survey
ta pop

**Weighting
gen wt=d005/1000000
svyset clusterid [pw=wt], strata (stratumid) singleunit(centered)

*****Analysing complete cases
egen nmiss = rowmiss(sex_vio parental_vio risky_sex wealth ///
edu xtians ethnic residence region v012) 
ta nmiss [iw=wt] if pop==1 

****Descriptive statistics
foreach var in sex_vio parental_vio risky_sex wealth v012 ///
edu xtians ethnic residence region survey{
ta `var' [iw=wt] if (pop==1 & nmiss==0)
}

****Univariate regression
svy,subpop(if pop==1 & nmiss==0): mlogit sex_vio i.parental_vio, b(0) rrr

*****Regression
svy,subpop(if pop==1 & nmiss==0): mlogit sex_vio i.parental_vio i.risky_sex i.wealth ///
v012 i.edu i.xtians i.ethnic i.residence i.region i.survey, b(0) rrr replace

