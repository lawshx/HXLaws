 *Saving the file path;
%LET REFILE = "/folders/myfolders/Hive_Tracks/Hive Tracks Before Rollout_April 8, 2018_17.42.csv";

/*AT END OF FILE THE RESULTS ARE SAVED TO A PERMANENT LIBRARY (LINE 889)*/

/* We first need to start by importing the data.
Upon first attempts to importing the data, it became clear that the CSV file would need to be read in as a raw data file instead. */
DATA WORK.HT;
*Length of each variable needs to be established because the defaults will truncate many.;
LENGTH StartDate $20 EndDate $20 Status $10 IPAddress $15 Progress Duration Finished $4 RecordedDate $20
       ResponseId $20 RecipientLastName $30 RecipientFirstName $30 RecipientEmail $50 ExternalReference
       LocationLatitude $16 LocationLongitude $16 DistributionChannel $2 UserLanguage $2 Accessibility_1 $26 
       Accessibility_2 $26 Accessibility_3 $26 Accessibility_4 $26 Improve_Accessibility $200 Usefulness_1 $26 
       Usefulness_2 $26 Usefulness_3 $26 Usefulness_4 $26 Improve_Usefulness $200 Hedonism_1 $26 Hedonism_2 $26 
       Hedonism_3 $26 Hedonism_4 $26 Improve_Hedonism $200 Future_Use_1 $26 Future_Use_2 $26 Future_Use_3 $26 
       Gender $25 Birth_Year $20 Number_of_Hives $80 Education $50 Email $50 Other_Comments $200 Contact $30;

     
/*Q12 - Topics is excluded from the data set. It has no observed entries*/

*Here we needed to call in the file and used a few commands to have it read in correctly
 termstr helps to ignore the return key that is used in some of the comments
 LRECL stores larger amounts of characters when reading " "'s since some of them contained ","'s in them.
 DSD allows for consecutive ,,'s to be read as empty values instead of skipping over them.;
INFILE &REFILE  termstr=CRLF LRECL=10000000 dsd;

INPUT StartDate EndDate Status IPAddress Progress Duration Finished  RecordedDate 
     ResponseId  RecipientLastName  RecipientFirstName  RecipientEmail  ExternalReference
     LocationLatitude  LocationLongitude  DistributionChannel  UserLanguage  Accessibility_1 Accessibility_2
     Accessibility_3 Accessibility_4 Improve_Accessibility Usefulness_1 Usefulness_2 Usefulness_3 Usefulness_4
     Improve_Usefulness Hedonism_1 Hedonism_2 Hedonism_3 Hedonism_4 Improve_Hedonism Future_Use_1 Future_Use_2 
     Future_Use_3 Gender Birth_Year Number_of_Hives Education Email Other_Comments Contact;




*Eliminating first 3 rows since they do not provide observational data.;
PROC SQL;
	DELETE FROM WORK.HT as ht
	WHERE ht.Finished ne 'True';
QUIT;



/*To create accurate Birth Year data, I first use substring to get the last two digits of the entry
read in from the CSV file. Regardless of how the data is read in, the year part of the variable comes
last, so when extracting the last to digits I always get the right year (not the right century). 
I then convert the substring into a numeric variable and add 1900 for values that are higher than
10 (these are presumably in the 20th century. To values that are smaller than 10 I add 200 since these
are presumably in the 21st century.*/
DATA WORK.HT;
	SET WORK.HT;
	LENGTH Birth_Year_prep $3;
	LENGTH Birth_Year_New 5;
	LENGTH Birth_Year_prep_N 4;
	Birth_Year_prep = SUBSTR(Birth_Year,length(Birth_Year)-1, 2);
	/* Converting to numeric Variable */
	Birth_Year_prep_N=input(Birth_Year_prep,4.);
	
	If Birth_Year_prep_N > 10 THEN Birth_Year_New = 1900 + Birth_Year_prep_N;
	ELSE IF Birth_Year_prep_N < 10 THEN Birth_Year_New = 2000 + Birth_Year_prep_N;
	ELSE Birth_Year_New = .;
	DROP Birth_Year_prep Birth_Year_prep_N; 
run;

/*Diagnostics on Birth year - I create a new table that only includes Birth_Year and Birth_Year_New. I then
add an indicator variable that shows 1 for missing values in Birth_Year_New.*/

DATA WORK.HT_BD_Diagn (KEEP = Birth_Year Birth_Year_New BY_Diagnostic);
	SET Work.HT;
	LENGTH BY_Diagnostic 3;
	IF Birth_Year_New = . THEN BY_Diagnostic = 1;
	ELSE BY_Diagnostic = 0;
run;

PROC SQL;
	CREATE TABLE WORK.BY_DIAG
	AS
	SELECT * FROM WORK.HT_BD_Diagn WHERE BY_Diagnostic = 1;	
quit;

/*The missing values in the table show that Birth_year_new only takes on a missing value if the initial value of
Birth_year (the one read in from the CSV-file) has a missing value. There is thus no distortion of the data*/
/*END OF DIAGNOSTIC */

/*From looking at the Output Data, the read in process has turned appostrophes into "â€™". The next 
DATA step uses the transtrn funciton to replace "â€™" with "'". 
At the end of the data step Birth_Year is dropped, since it has been replaced with a new variable in the previous step
but it was necessary to keep birth_year in the data set to perform the diagnostics.*/

DATA WORK.HT;
	SET WORK.HT;
	Education = transtrn(Education, "â€™", "'");
	Improve_Accessibility = transtrn(Improve_Accessibility, "â€™", "'");
	Improve_Usefulness = transtrn(Improve_Usefulness, "â€™", "'");
	Improve_Hedonism = transtrn(Improve_Hedonism, "â€™", "'");
	Other_Comments = transtrn(Other_Comments, "â€™", "'");
	DROP Birth_Year;
run;




*We need to see the frequency of each response to re-assign values efficiently;
PROC FREQ data=WORK.HT ORDER = FREQ;
	TABLES Accessibility_1/ nocum ;
RUN;


*We then assign values for each option in the likert scale and order them in the most effecient way;
DATA WORK.HT;
	SET WORK.HT;
	IF Accessibility_1 = "Agree" THEN Accessibility_1 = "6";
	ELSE IF Accessibility_1 = "Somewhat agree" THEN Accessibility_1 = "5";
	ELSE IF Accessibility_1 = "Strongly agree" THEN Accessibility_1 = "7";
	ELSE IF Accessibility_1 = "Neither agree nor disagree" THEN Accessibility_1 = "4";
	ELSE IF Accessibility_1 = "Somewhat disagree" THEN Accessibility_1 = "3";
	ELSE IF Accessibility_1 = "disagree" THEN Accessibility_1 = "2";
	ELSE IF Accessibility_1 = "Strongly disagree" THEN Accessibility_1 = "1";
	ELSE Accessibility_1 = "";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Accessibility_1_N=input(Accessibility_1,1.);
	DROP Accessibility_1;
run;

*Same thing as previous block of code;
PROC FREQ data=WORK.HT ORDER = FREQ;
	TABLES Accessibility_2/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Accessibility_2 = "Agree" THEN Accessibility_2 = "6";
	ELSE IF Accessibility_2 = "Somewhat agree" THEN Accessibility_2 = "5";
	ELSE IF Accessibility_2 = "Strongly agree" THEN Accessibility_2 = "7";
	ELSE IF Accessibility_2 = "Neither agree nor disagree" THEN Accessibility_2 = "4";
	ELSE IF Accessibility_2 = "Somewhat disagree" THEN Accessibility_2 = "3";
	ELSE IF Accessibility_2 = "disagree" THEN Accessibility_2 = "2";
	ELSE IF Accessibility_2 = "Strongly disagree" THEN Accessibility_2 = "1";
	ELSE Accessibility_2 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Accessibility_2_N=input(Accessibility_2,1.);
	DROP Accessibility_2;
run;

*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Accessibility_3/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Accessibility_3 = "Agree" THEN Accessibility_3 = "6";
	ELSE IF Accessibility_3 = "Somewhat agree" THEN Accessibility_3 = "5";
	ELSE IF Accessibility_3 = "Neither agree nor disagree" THEN Accessibility_3 = "4";
	ELSE IF Accessibility_3 = "Strongly agree" THEN Accessibility_3 = "7";
	ELSE IF Accessibility_3 = "Somewhat disagree" THEN Accessibility_3 = "3";
	ELSE IF Accessibility_3 = "disagree" THEN Accessibility_3 = "2";
	ELSE IF Accessibility_3 = "Strongly disagree" THEN Accessibility_3 = "1";
	ELSE Accessibility_3 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Accessibility_3_N=input(Accessibility_3,1.);
	DROP Accessibility_3;
run;

*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Accessibility_4/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Accessibility_4 = "Agree" THEN Accessibility_4 = "6";
	ELSE IF Accessibility_4 = "Somewhat agree" THEN Accessibility_4 = "5";
	ELSE IF Accessibility_4 = "Strongly agree" THEN Accessibility_4 = "7";
	ELSE IF Accessibility_4 = "Neither agree nor disagree" THEN Accessibility_4 = "4";
	ELSE IF Accessibility_4 = "Somewhat disagree" THEN Accessibility_4 = "3";
	ELSE IF Accessibility_4 = "disagree" THEN Accessibility_4 = "2";
	ELSE IF Accessibility_4 = "Strongly disagree" THEN Accessibility_4 = "1";
	ELSE Accessibility_4 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Accessibility_4_N=input(Accessibility_4,1.);
	DROP Accessibility_4;
run;

*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Usefulness_1/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Usefulness_1 = "Agree" THEN Usefulness_1 = "6";
	ELSE IF Usefulness_1 = "Neither agree nor disagree" THEN Usefulness_1 = "4";
	ELSE IF Usefulness_1 = "Somewhat agree" THEN Usefulness_1 = "5";
	ELSE IF Usefulness_1 = "Strongly agree" THEN Usefulness_1 = "7";
	ELSE IF Usefulness_1 = "Somewhat disagree" THEN Usefulness_1 = "3";
	ELSE IF Usefulness_1 = "disagree" THEN Usefulness_1 = "2";
	ELSE IF Usefulness_1 = "Strongly disagree" THEN Usefulness_1 = "1";
	ELSE Usefulness_1 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Usefulness_1_N=input(Usefulness_1,1.);
	DROP Usefulness_1;
run;

*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Usefulness_2/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Usefulness_2 = "Agree" THEN Usefulness_2 = "6";
	ELSE IF Usefulness_2 = "Neither agree nor disagree" THEN Usefulness_2 = "4";
	ELSE IF Usefulness_2 = "Somewhat agree" THEN Usefulness_2 = "5";
	ELSE IF Usefulness_2 = "Strongly agree" THEN Usefulness_2 = "7";
	ELSE IF Usefulness_2 = "disagree" THEN Usefulness_2 = "2";
	ELSE IF Usefulness_2 = "Somewhat disagree" THEN Usefulness_2 = "3";
	ELSE IF Usefulness_2 = "Strongly disagree" THEN Usefulness_2 = "1";
	ELSE Usefulness_2 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Usefulness_2_N=input(Usefulness_2,1.);
	DROP Usefulness_2;
run;


*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Usefulness_3/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Usefulness_3 = "Agree" THEN Usefulness_3 = "6";
	ELSE IF Usefulness_3 = "Neither agree nor disagree" THEN Usefulness_3 = "4";
	ELSE IF Usefulness_3 = "Somewhat agree" THEN Usefulness_3 = "5";
	ELSE IF Usefulness_3 = "Strongly agree" THEN Usefulness_3 = "7";
	ELSE IF Usefulness_3 = "Somewhat disagree" THEN Usefulness_3 = "3";
	ELSE IF Usefulness_3 = "disagree" THEN Usefulness_3 = "2";
	ELSE IF Usefulness_3 = "Strongly disagree" THEN Usefulness_3 = "1";
	ELSE Usefulness_3 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Usefulness_3_N=input(Usefulness_3,1.);
	DROP Usefulness_3;
run;


*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Usefulness_4/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Usefulness_4 = "Agree" THEN Usefulness_4 = "6";
	ELSE IF Usefulness_4 = "Strongly agree" THEN Usefulness_4 = "7";
	ELSE IF Usefulness_4 = "Somewhat agree" THEN Usefulness_4 = "5";
	ELSE IF Usefulness_4 = "Neither agree nor disagree" THEN Usefulness_4 = "4";
	ELSE IF Usefulness_4 = "disagree" THEN Usefulness_4 = "2";
	ELSE IF Usefulness_4 = "Strongly disagree" THEN Usefulness_4 = "1";
	ELSE IF Usefulness_4 = "Somewhat disagree" THEN Usefulness_4 = "3";
	ELSE Usefulness_4 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Usefulness_4_N=input(Usefulness_4,1.);
	DROP Usefulness_4;
run;


*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Hedonism_1/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Hedonism_1 = "Agree" THEN Hedonism_1 = "6";
	ELSE IF Hedonism_1 = "Neither agree nor disagree" THEN Hedonism_1 = "4";
	ELSE IF Hedonism_1 = "Somewhat agree" THEN Hedonism_1 = "5";
	ELSE IF Hedonism_1 = "Strongly agree" THEN Hedonism_1 = "7";
	ELSE IF Hedonism_1 = "Somewhat disagree" THEN Hedonism_1 = "3";
	ELSE IF Hedonism_1 = "Strongly disagree" THEN Hedonism_1 = "1";
	ELSE IF Hedonism_1 = "disagree" THEN Hedonism_1 = "2";
	ELSE Hedonism_1 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Hedonism_1_N=input(Hedonism_1,1.);
	DROP Hedonism_1;
run;


*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Hedonism_2/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Hedonism_2 = "Agree" THEN Hedonism_2 = "6";
	ELSE IF Hedonism_2 = "Neither agree nor disagree" THEN Hedonism_2 = "4";
	ELSE IF Hedonism_2 = "Somewhat agree" THEN Hedonism_2 = "5";
	ELSE IF Hedonism_2 = "Strongly agree" THEN Hedonism_2 = "7";
	ELSE IF Hedonism_2 = "Somewhat disagree" THEN Hedonism_2 = "3";
	ELSE IF Hedonism_2 = "Strongly disagree" THEN Hedonism_2 = "1";
	ELSE IF Hedonism_2 = "disagree" THEN Hedonism_2 = "2";
	ELSE Hedonism_2 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Hedonism_2_N=input(Hedonism_2,1.);
	DROP Hedonism_2;
run;

*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Hedonism_3/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Hedonism_3 = "Agree" THEN Hedonism_3 = "6";
	ELSE IF Hedonism_3 = "Neither agree nor disagree" THEN Hedonism_3 = "4";
	ELSE IF Hedonism_3 = "Somewhat agree" THEN Hedonism_3 = "5";
	ELSE IF Hedonism_3 = "Strongly agree" THEN Hedonism_3 = "7";
	ELSE IF Hedonism_3 = "Somewhat disagree" THEN Hedonism_3 = "3";
	ELSE IF Hedonism_3 = "disagree" THEN Hedonism_3 = "2";
	ELSE IF Hedonism_3 = "Strongly disagree" THEN Hedonism_3 = "1";
	ELSE Hedonism_3 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Hedonism_3_N=input(Hedonism_3,1.);
	DROP Hedonism_3;
run;


*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Hedonism_4/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Hedonism_4 = "Agree" THEN Hedonism_4 = "6";
	ELSE IF Hedonism_4 = "Neither agree nor disagree" THEN Hedonism_4 = "4";
	ELSE IF Hedonism_4 = "Strongly agree" THEN Hedonism_4 = "7";
	ELSE IF Hedonism_4 = "Somewhat agree" THEN Hedonism_4 = "5";
	ELSE IF Hedonism_4 = "Somewhat disagree" THEN Hedonism_4 = "3";
	ELSE IF Hedonism_4 = "disagree" THEN Hedonism_4 = "2";
	ELSE IF Hedonism_4 = "Strongly disagree" THEN Hedonism_4 = "1";
	ELSE Hedonism_4 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Hedonism_4_N=input(Hedonism_4,1.);
	DROP Hedonism_4;
run;


*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Future_Use_1/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Future_Use_1 = "Agree" THEN Future_Use_1 = "6";
	ELSE IF Future_Use_1 = "Strongly agree" THEN Future_Use_1 = "7";
	ELSE IF Future_Use_1 = "Neither agree nor disagree" THEN Future_Use_1 = "4";
	ELSE IF Future_Use_1 = "Somewhat agree" THEN Future_Use_1 = "5";
	ELSE IF Future_Use_1 = "disagree" THEN Future_Use_1 = "2";
	ELSE IF Future_Use_1 = "Strongly disagree" THEN Future_Use_1 = "1";
	ELSE IF Future_Use_1 = "Somewhat disagree" THEN Future_Use_1 = "3";
	ELSE Future_Use_1 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Future_Use_1_N=input(Future_Use_1,1.);
	DROP Future_Use_1;
run;


*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Future_Use_2/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Future_Use_2 = "Agree" THEN Future_Use_2 = "6";
	ELSE IF Future_Use_2 = "Neither agree nor disagree" THEN Future_Use_2 = "4";
	ELSE IF Future_Use_2 = "Strongly agree" THEN Future_Use_2 = "7";
	ELSE IF Future_Use_2 = "Somewhat agree" THEN Future_Use_2 = "5";
	ELSE IF Future_Use_2 = "disagree" THEN Future_Use_2 = "2";
	ELSE IF Future_Use_2 = "Strongly disagree" THEN Future_Use_2 = "1";
	ELSE IF Future_Use_2 = "Somewhat disagree" THEN Future_Use_2 = "3";
	ELSE Future_Use_2 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Future_Use_2_N=input(Future_Use_2,1.);
	DROP Future_Use_2;
run;

*Same thing as previous block of code;
PROC FREQ DATA=WORK.HT ORDER = FREQ;
	TABLES Future_Use_3/ nocum ;
RUN;

DATA WORK.HT;
	SET WORK.HT;
	IF Future_Use_3 = "Agree" THEN Future_Use_3 = "6";
	ELSE IF Future_Use_3 = "Strongly agree" THEN Future_Use_3 = "7";
	ELSE IF Future_Use_3 = "Neither agree nor disagree" THEN Future_Use_3 = "4";
	ELSE IF Future_Use_3 = "Somewhat agree" THEN Future_Use_3 = "5";
	ELSE IF Future_Use_3 = "disagree" THEN Future_Use_3 = "2";
	ELSE IF Future_Use_3 = "Strongly disagree" THEN Future_Use_3 = "1";
	ELSE IF Future_Use_3 = "Somewhat disagree" THEN Future_Use_3 = "3";
	ELSE Future_Use_3 = " ";
RUN;

/* Converting to numeric Variable */
DATA Work.HT;
	SET WORK.HT;
	Future_Use_3_N=input(Future_Use_3,1.);
	DROP Future_Use_3;
run;


*First convert spellings of numbers into actual number. We're only going up to "two" since there aren't any
spelled out numbers beyond that in the given data.;
DATA WORK.HT;
	SET WORK.HT;
   
 	N = TRANWRD(LOWCASE(Number_of_Hives),"one","1");
 	*You'll need to keep referring to this variable in order to make changes on it and keep previous changes.;
 	N = TRANWRD(N,"two","2");
 	N = TRANWRD(N,"to","-");
 
 	Num = compress(N,"-.","kd"); *keeping all the numbers as well as "-" and ".";
  	Num=scan(Num,1,"-"); *finding the first number;
  	Num1=scan(compress(N,"-.","kd"),2,"-"); *finding the second number;
  	Num2=scan(compress(N,"-.","kd"),3,"-"); *finding the third number in case we are given another range;
  	LENGTH NumHives $4;
  	NumHives = MEAN(Num,MEAN(Num1,Num2));
 	DROP N Num Num1 Num2 Number_of_Hives;
RUN;



*changing NumHives to Number_of_Hives, the original variable name.;
DATA WORK.HT;
	SET WORK.HT;
	LENGTH Number_of_Hives 4;
 	Number_of_Hives = input(NumHives,4.);
 	DROP NumHives;
RUN;

/*Creating new categories for number of hives*/
DATA WORK.HT;
	SET WORK.HT;
	LENGTH Hive_Category $ 15;
	IF Number_of_Hives <= 10 THEN Hive_Category = "10 or Less";
	ELSE IF Number_of_Hives >10 AND Number_of_Hives <= 20 THEN Hive_Category = "10 to 20";
	ELSE IF Number_of_Hives >20 AND Number_of_Hives <= 30 THEN Hive_Category = "20 to 30";
	ELSE IF Number_of_Hives >30 AND Number_of_Hives <= 40 THEN Hive_Category = "30 to 40";
	ELSE IF Number_of_Hives >40 AND Number_of_Hives <= 50 THEN Hive_Category = "40 to 50";
	ELSE Hive_Category = "Over 50";
RUN;



/*BEGIN OF ANALYSIS - USE DIFFERENT DATA SET, since analysis is not part of tidy data set*/

/*SUMMARY STATISTICS

*Histogram and Boxplot on Number_of_Hives
*The code for summary statistics is generated by the GUI
*/
ods noproctitle;
ods graphics / imagemap=on;

proc means data=WORK.HT chartype mean std min max n stderr vardef=df q1 q3 
		qrange qmethod=os;
	var Number_of_Hives;
run;

/* Graph template to construct combination histogram/boxplot */
proc template;
	define statgraph histobox;
		dynamic AVAR ByVarInfo;
		begingraph;
		entrytitle "Distribution of " AVAR ByVarInfo;
		layout lattice / rows=2 columndatarange=union rowgutter=0 rowweights=(0.75 
			0.25);
		layout overlay / yaxisopts=(offsetmax=0.1) xaxisopts=(display=none);
		histogram AVAR /;
		endlayout;
		layout overlay /;
		BoxPlot Y=AVAR / orient=horizontal;
		endlayout;
		endlayout;
		endgraph;
	end;
run;

/* Macro to subset data and create a histobox for every by group */
%macro byGroupHistobox(data=, level=, num_level=, byVars=, num_byvars=, avar=);
	%do j=1 %to &num_byvars;
		%let varName&j=%scan(%str(&byVars), &j);
	%end;

	%do i=1 %to &num_level;

		/* Get group variable values */
		data _null_;
			i=&i;
			set &level point=i;

			%do j=1 %to &num_byvars;
				call symputx("x&j", strip(&&varName&j), 'l');
			%end;
			stop;
		run;

		/* Build proc sql where clause */
        %let dsid=%sysfunc(open(&data));
		%let whereClause=;

		%do j=1 %to %eval(&num_byvars-1);
			%let varnum=%sysfunc(varnum(&dsid, &&varName&j));

			%if(%sysfunc(vartype(&dsid, &varnum))=C) %then
				%let whereClause=&whereClause.&&varName&j.="&&x&j"%str( and );
			%else
				%let whereClause=&whereClause.&&varName&j.=&&x&j.%str( and );
		%end;
		%let varnum=%sysfunc(varnum(&dsid, &&varName&num_byvars));

		%if(%sysfunc(vartype(&dsid, &varnum))=C) %then
			%let whereClause=&whereClause.&&varName&num_byvars.="&&x&num_byvars";
		%else
			%let whereClause=&whereClause.&&varName&num_byvars.=&&x&num_byvars;
		%let rc=%sysfunc(close(&dsid));

		/* Subset the data set */
		proc sql noprint;
			create table WORK.tempData as select * from &data
            where &whereClause;
		quit;

		/* Build plot group info */
        %let groupInfo=;

		%do j=1 %to %eval(&num_byvars-1);
			%let groupInfo=&groupInfo.&&varName&j.=&&x&j%str( );
		%end;
		%let groupInfo=&groupInfo.&&varName&num_byvars.=&&x&num_byvars;

		/* Create histogram/boxplot combo plot */
		proc sgrender data=WORK.tempData template=histobox;
			dynamic AVAR="&avar" ByVarInfo=" (&groupInfo)";
		run;

	%end;
%mend;

proc sgrender data=WORK.HT template=histobox;
	dynamic AVAR="Number_of_Hives" ByVarInfo="";
run;

proc datasets library=WORK noprint;
	delete tempData;
	run;
/*END OF SUMMARY STATISTICS*/

/*Number_of_Hives has a high number of outliers. The median is 5, the interquartile range 11. 
Following the boxplot definition of outliers every value that is above 21.5 (5+1.5*11) is an outlier.
There are a considerable amount of outliers (78) and I will thus run the analysis on a data set without outliers and on one including outliers. It would 
further make sense to group number of hives (although this might skew the analysis). */

PROC SQL;
	CREATE TABLE WORK.HT_Analy_Prep
	AS	
	SELECT * FROM WORK.HT WHERE Number_of_Hives < 21.5;
quit;

/*For Analysis I am creating index variables that summarize the likert-scale variables. 
I assume an equally additive relationship among the variables that measure the same concept
and thus the index is simply the sum of the values for each variable.
I will use age for the analysis, so I am creating an age variable by subtracting birth year
from 2019.*/



DATA WORK.HT_Analysis_no_outliers;
	SET WORK.HT_Analy_Prep;
	LENGTH index_accessibility 4;
	LENGTH index_usefulness 4;
	LENGTH index_hedonism 4;
	LENGTH index_future_use 4;
	LENGTH age 4;
	
	index_accessibility = sum(Accessibility_1_N, Accessibility_2_N, Accessibility_3_N, Accessibility_4_N);
	index_usefulness = sum(Usefulness_1_N, Usefulness_2_N, Usefulness_3_N, Usefulness_4_N);
	index_hedonism = sum(Hedonism_1_N, Hedonism_2_N, Hedonism_3_N, Hedonism_4_N);
	index_future_use = sum(Future_Use_1_N, Future_Use_2_N, Future_Use_3_N);
	age = 2019 - Birth_Year_New;
run;


ods noproctitle;
ods graphics / imagemap=on;

proc reg data=WORK.HT_Analysis_no_outliers alpha=0.05 plots(only)=(diagnostics residuals 
		observedbypredicted);
	model Number_of_Hives=index_accessibility index_usefulness index_hedonism 
		index_future_use age /;
	run;
quit;

/*Very bad model. Small R-Square, no significant coefficients, seems to violate multiple 
assumptions of OLS (heteroscedasticity, residuals no normally distributed)*/

/*Similar data processing to previous analysis but this time with outliers.*/
DATA WORK.HT_Analysis_with_outliers;
	SET WORK.HT;
	LENGTH index_accessibility 4;
	LENGTH index_usefulness 4;
	LENGTH index_hedonism 4;
	LENGTH index_future_use 4;
	LENGTH age 4;
	
	index_accessibility = sum(Accessibility_1_N, Accessibility_2_N, Accessibility_3_N, Accessibility_4_N);
	index_usefulness = sum(Usefulness_1_N, Usefulness_2_N, Usefulness_3_N, Usefulness_4_N);
	index_hedonism = sum(Hedonism_1_N, Hedonism_2_N, Hedonism_3_N, Hedonism_4_N);
	index_future_use = sum(Future_Use_1_N, Future_Use_2_N, Future_Use_3_N);
	age = 2019 - Birth_Year_New;
run;

ods noproctitle;
ods graphics / imagemap=on;

proc reg data=WORK.HT_Analysis_with_outliers alpha=0.05 plots(only)=(diagnostics residuals 
		observedbypredicted);
	model Number_of_Hives=index_accessibility index_usefulness index_hedonism 
		index_future_use age /;
	run;
quit;

/*Similarly bad model.*/

/*One Way Anova, analyzing potential differences in means between categories of hives and the 
usefulness index. Ran on the data set with outliers.*/

ods noproctitle;
ods graphics / imagemap=on;

proc corr data=WORK.HT_ANALYSIS_WITH_OUTLIERS pearson nosimple noprob 
		plots=none;
	var Number_of_Hives;
	with index_accessibility index_usefulness index_hedonism index_future_use;
run;
/*NO SIGNIFICANT DIFFERENCES*/

/*One Way Anova, analyzing potential differences in means between categories of hives and the 
usefulness index. Ran on the data set without outliers.*/
Title;
ods noproctitle;
ods graphics / imagemap=on;

proc glm data=WORK.HT_ANALYSIS_NO_OUTLIERS;
	class Hive_Category;
	model index_usefulness=Hive_Category;
	means Hive_Category / hovtest=levene welch plots=none;
	lsmeans Hive_Category / adjust=tukey pdiff alpha=.05;
	run;
quit;

/*NO SIGNIFICANT DIFFERENCES*/


/*Graphs*/
*More in depth on the frequency of each number of hives listed rather than a histogram.;
ods graphics / reset width=6.4in height=4.8in imagemap;

PROC sgplot DATA=WORK.HT;
	vbar Number_of_Hives /;
	yaxis grid;
RUN;

ods graphics / reset;


*barplot of the education demographic;
ods graphics / reset width=6.4in height=4.8in imagemap;

PROC sgplot data=WORK.HT;
	vbar Education /;
	yaxis grid;
RUN;

ods graphics / reset;


*histogram of age demographic;
ods graphics / reset width=6.4in height=4.8in imagemap;

PROC sgplot data=WORK.HT;
	histogram Birth_Year_New /;
	yaxis grid;
RUN;

ods graphics / reset;


*scatter plot to show distribution of the number of hives amongst different ages;
ods graphics / reset width=6.4in height=4.8in imagemap;

PROC sgplot data=WORK.HT;
	scatter x=Birth_Year_New y=Number_of_Hives /;
	xaxis grid;
	yaxis grid;
RUN;

ods graphics / reset;
title;

DATA WORK.HT;
	SET WORK.HT;
	LENGTH index_accessibility 4;
	LENGTH index_usefulness 4;
	LENGTH index_hedonism 4;
	LENGTH index_future_use 4;
	LENGTH age 4;
	
	index_accessibility = sum(Accessibility_1_N, Accessibility_2_N, Accessibility_3_N, Accessibility_4_N);
	index_usefulness = sum(Usefulness_1_N, Usefulness_2_N, Usefulness_3_N, Usefulness_4_N);
	index_hedonism = sum(Hedonism_1_N, Hedonism_2_N, Hedonism_3_N, Hedonism_4_N);
	index_future_use = sum(Future_Use_1_N, Future_Use_2_N, Future_Use_3_N);
	age = 2019 - Birth_Year_New;
	DROP Birth_Year_New;
run;

/*Creating likert-style groupings for index variable values*/
DATA WORK.HT;
   SET WORK.HT; 
   LENGTH Index_Access_Group $30;
   LENGTH Index_Useful_Group $30;
   LENGTH Index_Joy_Group $30;
   LENGTH Index_Future_Group $40;
   
   IF index_accessibility =< 9 THEN Index_Access_Group = "Not very accessible";
   IF index_accessibility >= 18 THEN Index_Access_Group = "Very accessible";
   IF 9 < index_accessibility < 18 THEN Index_Access_Group = "Somewhat accessible";
   
   IF index_usefulness =< 9 THEN Index_Useful_Group = "Not very useful";
   IF index_usefulness >= 18 THEN Index_Useful_Group = "Very useful";
   IF 9 < index_usefulness < 18 THEN Index_Useful_Group = "Somewhat useful";
   
   IF index_hedonism =< 9 THEN Index_Joy_Group = "Not very enjoyable";
   IF index_hedonism >= 18 THEN Index_Joy_Group = "Very enjoyable";
   IF 9 < index_hedonism < 18 THEN Index_Joy_Group = "Somewhat enjoyable";

   IF index_future_use =< 7 THEN Index_Future_Group = "Not very likely to use in future";
   IF index_future_use >= 14 THEN Index_Future_Group = "Very likely to use in future";
   IF 7 < index_future_use < 14 THEN Index_Future_Group = "Somewhat likely to use in future";
   
run;
/*Generated by GUI - Pie Charts to analyze index variables*/
/* Define Pie template */
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Accessibilty of Hive Tracks" / textattrs=(size=14);
		layout region;
		piechart category=Index_Access_Group / stat=pct;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.HT;
run;

ods graphics / reset;

proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Usefulness of Hive Tracks" / textattrs=(size=14);
		layout region;
		piechart category=Index_Useful_Group / stat=pct;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.HT;
run;

ods graphics / reset;

proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Hedonistic Value of Hive Tracks" / textattrs=(size=14);
		layout region;
		piechart category=Index_Joy_Group / stat=pct;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.HT;
run;

ods graphics / reset;

proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Likelyhood of Future Use of Hive Tracks" / textattrs=(size=14);
		layout region;
		piechart category=Index_Future_Group / stat=pct;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.HT;
run;

ods graphics / reset;

/*SAVING FILE TO PERMANENT LIBRARY Creating necessary variable labels for data dictionary*/
DATA HIVETRAC.HT_Tidy_Complete;
	SET WORK.HT;
	LABEL StartDate = "Date and Time when beginning Survey";
	LABEL EndDate = "Date and Time when finishing Survey";
	LABEL Status = "Response Type (IP Address indicates internet survey)";
	LABEL IPAddress = "IP Address of Survey Taker";
	LABEL Progress = "Percent Finished of Survey";
	LABEL Duration = "Time survey taker took to finish survey (in seconds)";
	LABEL Finished = "Boolean Value. True for finished surveys";
	LABEL RecordedDate = "Date and Time of survey";
    LABEL ResponseId = "Identifier for Survey Taker";
    LABEL RecipientLastName = "Last Name of Survey Taker";
    LABEL RecipientFirstName = "First Name of Survey Taker"; 
    LABEL RecipientEmail = "Email Address of Survey Taker";
    LABEL ExternalReference = "External Data Reference";
    LABEL LocationLatitude = "Latitude Survey Taker";
    LABEL LocationLongitude = "Longitude Survey Taker";
    LABEL DistributionChannel = "Distribution Channel";
    LABEL UserLanguage = "Language of Survey Taker";
    LABEL Accessibility_1_N = "Please tell us how easy it is for you to use Hive Tracks 
    	- Learning to use Hive Tracks is easy for me. Likert-Type Question on numeric 
    	scale from 1 to 7";
    LABEL Accessibility_2_N = "Please tell us how easy it is for you to use Hive Tracks 
    	- My interaction with Hive Tracks is clear and understandable. Likert-Type Question 
    	on numeric scale from 1 to 7";
    LABEL Accessibility_3_N = "Please tell us how easy it is for you to use Hive Tracks 
   		- It is easy to use Hive Tracks to accomplish my beekeeping tasks. Likert-Type Question 
   		on numeric scale from 1 to 7";
    LABEL Accessibility_4_N = "Please tell us how easy it is for you to use Hive Tracks 
    	- Overall, I believe Hive Tracks is easy to use. Likert-Type Question on numeric 
    	scale from 1 to 7";
    LABEL Improve_Accessibility = "What can we do to make Hive Tracks easier for you?"; 
    LABEL Usefulness_1_N = "Please tell us how useful Hive Tracks is for you 
    	- I can accomplish my beekeeping tasks more quickly using Hive Tracks. Likert-Type Question 
    	on numeric scale from 1 to 7";
    LABEL Usefulness_2_N = "Please tell us how useful Hive Tracks is for you 
    	- Hive Tracks enables me to make better decisions in beekeeping. Likert-Type Question 
    	on numeric scale from 1 to 7";
    LABEL Usefulness_3_N = "Please tell us how useful Hive Tracks is for you 
    	- Hive Tracks enhances my efficiency in beekeeping. Likert-Type Question 
    	on numeric scale from 1 to 7"; 
    LABEL Usefulness_4_N = "Please tell us how useful Hive Tracks is for you 
    	- Overall I find Hive Tracks useful. Likert-Type Question 
    	on numeric scale from 1 to 7";
    LABEL Improve_Usefulness ="What can we do to make Hive Tracks more useful for you?";
    LABEL Hedonism_1_N = "Please tell us how you enjoy using Hive Tracks - I find 
    	using Hive Tracks enjoyable. Likert-Type Question on numeric scale from 1 to 7"; 
    LABEL Hedonism_2_N = "Please tell us how you enjoy using Hive Tracks - 
   		Using Hive Tracks is pleasant. Likert-Type Question on numeric scale from 1 to 7";
    LABEL Hedonism_3_N = "Please tell us how you enjoy using Hive Tracks - 
    	I have fun using Hive Tracks. Likert-Type Question on numeric scale from 1 to 7";
    LABEL Hedonism_4_N ="Please tell us how you enjoy using Hive Tracks - 
    	Overall I like using Hive Tracks. Likert-Type Question on numeric scale from 1 to 7";
    LABEL Improve_Hedonism = "What can we do to make Hive Tracks more enjoyable 
    	and pleasant for you to use?";
    LABEL Future_Use_1_N = "Please tell us how often you plan to use Hive Tracks 
    	in the future - I will use Hive Tracks on a regular basis in the future. 
    	Likert-Type Question on numeric scale from 1 to 7";
    LABEL Future_Use_2_N = "Please tell us how often you plan to use Hive Tracks in 
    	the future - I will frequently use Hive Tracks in the future.
    	Likert-Type Question on numeric scale from 1 to 7";
    LABEL Future_Use_3_N = "Please tell us how often you plan to use Hive Tracks in 
    	the future - Overall, I will continue using Hive Tracks in the future.
    	Likert-Type Question on numeric scale from 1 to 7";
    LABEL Gender = "Please select your gender";
    LABEL Number_of_Hives = "Average Number of Bee Hives";
    LABEL Education = "Level of Educational Attainment";
    LABEL Email = "Email address registered with Hive Tracks for potential Free Subscription";
    LABEL Other_Comments ="General Comments";
    LABEL Contact ="Contact for follow up";
    LABEL Index_Access_Group = "Accessibility on Likert-scale. Values derived from 
    	Accessibility-Index";
    LABEL Index_Useful_Group = "Usefulness on Likert-scale. Values derived from 
    	Usefulness-Index"; 
    LABEL Index_Joy_Group = "Hedonistic Value on Likert-scale. Values derived from 
    	Hedonistic-Index"; 
    LABEL Index_Future_Group = "Likelyhood of future use on Likert-scale. Values derived from 
    	Future-Use-Index"; 
    LABEL index_accessibility = "Cumulative Index of accessibility. Derived from Accessibility 
    	Quesitons";
    LABEL index_usefulness = "Cumulative Index of Usefulness. Derived from Usefulness 
    	Quesitons"; 
    LABEL index_hedonism = "Cumulative Index of hedonistic value. Derived from Hedonism 
    	Quesitons";
    LABEL index_future_use = "Cumulative Index of likelyhood of future use. 
    	Derived from future use questions"; 
    LABEL age = "Age of Survey Taker";
    LABEL Hive_Category = "Number of Hives in Tiers";
run;

/*Proc contents for Data Dictionary*/
proc contents data=HIVETRAC.HT_Tidy_Complete;
   title  'The Contents of the Hives Data Set';
run;
