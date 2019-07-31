*Creating age variable using December 31, 2016 as the reference date;
DATA WORK.DATA1; 
	SET PWH.DATA1;
	ref_date=mdy(12,31,2016);
	AGE = FLOOR((INTCK('month',DOB,ref_date) - (day(ref_date) < day(DOB)))/12);
RUN;


*Making table with just the variables to make simple logistic model;
PROC SQL;
	CREATE TABLE WORK.USABLE AS
	SELECT month(DOB) as MOB, AGE, GENDER, FLAG_INST, RACE, FLAG_GPA, TRANSFER_CAT, Home_Distance_NC,
	Target_Six_Year_Grad
	FROM WORK.DATA1;
QUIT;



/*DUMMY VARIABLES*/
*Finding the most frequent birth month;
PROC FREQ DATA = WORK.usable ORDER = FREQ;
	tables MOB;
RUN;


*Making dummy variables for birth month excluding the most frequent birth month (July);
DATA WORK.TEST;
	SET WORK.usable;
	ARRAY mnth {11} _TEMPORARY_ (1 2 3 4 5 6 8 9 10 11 12);
	ARRAY BM {11} MOB1 MOB2 MOB3 MOB4 MOB5 MOB6 MOB8 MOB9 MOB10 MOB11 MOB12;
	DO i = 1 to 11;
		IF MOB = mnth{i} THEN BM{i} = 1; ELSE BM{i} = 0;
	END;
RUN;
	
	
*Finding the most frequent institution;
PROC FREQ DATA = WORK.USABLE ORDER = FREQ;
	tables FLAG_INST;
RUN;


*finding all the institutions in the dataset;
PROC SQL;
	SELECT distinct(FLAG_INST) FROM WORK.USABLE;
QUIT;
 

*Creating dummy variables for the institutions in a do loop instead of writing repetative code;
DATA WORK.TEST1;
	SET WORK.test;
	ARRAY inst {15} _temporary_ (2905 2906 2907 2923 2926 2928 2950 2954 2972 2974 2976 2981 2984 2986 3981);
	ARRAY dummy {15} INST1 INST2 INST3 INST4 INST5 INST6 INST7 INST8 INST9 INST10 INST11 INST12 INST13 INST14 INST15;
	DO i = 1 to 15;
		IF FLAG_INST = inst{i} THEN dummy{i} = 1; ELSE dummy{i} = 0;
	END;
RUN;


*Finding all race categories in the dataset;
PROC SQL;
	SELECT distinct(RACE) FROM WORK.USABLE;
QUIT;


*Creating dummy variables to distinguish race categories;
*NOTE: Was not able to use a DO loop because of the spaces in the RACE categories;
*Also creating dummy variable for gender;
DATA WORK.TEST1;
	SET WORK.TEST1;
	IF GENDER = 'F' THEN female = 1; ELSE female = 0;
	IF RACE = 'American Indian or Alaskan Native' THEN r_amer_ind = 1; ELSE r_amer_ind = 0;
	IF RACE = 'Asian' THEN r_asian = 1; ELSE r_asian = 0;
	IF RACE = 'Black or African American' THEN r_black = 1; ELSE r_black = 0;
	IF RACE = 'Hispanic of any race' THEN r_hispan = 1; ELSE r_hispan = 0;
	IF RACE = 'Native Hawaiian or Other Pacific Islander' THEN r_hawaii = 1; ELSE r_hawaii = 0;
	IF RACE = 'Non-Resident Alien' THEN r_nonres = 1; ELSE r_nonres = 0;
	IF RACE = 'Race and Ethnicity Unknown' THEN r_unknown = 1; ELSE r_unknown = 0;
	IF RACE = 'Two or more races' THEN r_two_or_more = 1; ELSE r_two_or_more = 0;
	IF RACE = 'White' THEN r_white = 1; ELSE r_white = 0;
RUN;


*Creating squared terms;
DATA WORK.TEST1;
	SET WORK.TEST1;
	AGE_2 = AGE**2;
	Home_Distance_NC_2 = Home_Distance_NC**2;
RUN;



*MODELING;
*Logistic regression WITH squared terms;
PROC LOGISTIC DATA = WORK.TEST1 DESC;
	MODEL Target_Six_Year_Grad = AGE AGE_2 Home_Distance_NC Home_Distance_NC_2
		FLAG_GPA TRANSFER_CAT female MOB1 MOB2 MOB3 MOB4 
		MOB5 MOB6 MOB8 MOB9 MOB10 MOB11 MOB12 r_amer_ind r_asian r_black 
		r_hispan r_hawaii r_nonres r_unknown r_two_or_more r_white INST1 
		INST2 INST3 INST4 INST5 INST6 INST7 INST8 INST9 INST10 INST11 INST12 
		INST13 INST14 INST15;
RUN;

	
*Creating logistic regression model with dummy variables ONLY;
PROC LOGISTIC DATA=WORK.TEST1;
	MODEL Target_Six_Year_Grad = AGE Home_Distance_NC
		FLAG_GPA TRANSFER_CAT female MOB1 MOB2 MOB3 MOB4 
		MOB5 MOB6 MOB8 MOB9 MOB10 MOB11 MOB12 r_amer_ind r_asian r_black 
		r_hispan r_hawaii r_nonres r_unknown r_two_or_more r_white INST1 
		INST2 INST3 INST4 INST5 INST6 INST7 INST8 INST9 INST10 INST11 INST12 
		INST13 INST14 INST15;
RUN;

	


