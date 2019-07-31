*Connect Orders to transactions;
/*Looking into both tables*/
PROC PRINT DATA = SASUSER.ITEMCLEAN (obs=10);
RUN;

PROC PRINT DATA = SASUSER.TIDYMENU (obs=10);
RUN;


/*Formatting DATE_ITEMS to exclude the time
Reformatting TIME_ITEMS to eliminate blank space
Reformatting CHECK_NUM_ITEMS since one instance has "10000" as "1"*/
DATA WORK.ITEMCLEAN;
	SET SASUSER.ITEMCLEAN;
	/*The below statement for DATE_ITEMS goes as follows: 
		take the date part of DATE_ITEMS and put in date format
		have the DATE_ITEM read as a date value
		reformat that date value as a character string as "ddmmmyyyy" instead of "dd/mm/yyyy"*/
	date = PUT(INPUT(PUT(datepart(DATE_ITEMS),ddmmyy10.),ddmmyy10.), date9.);
	format date date9.;
	time = STRIP(PUT(TIME_ITEMS,$4.));
	checks = STRIP(PUT(CHECK_NUM_ITEMS,$8.));
	IF LENGTH(checks) = 1 THEN checks = CATS(checks,'0000');
/* 	tt = LENGTHN(time); Since this has been checked, it does not need to be created.*/
	RUN;


/*Checking that format is correct
Looking to see that date and time are both character variables.
Also looking to see that blank spaces are eliminated from time variable.*/
PROC PRINT DATA=WORK.ITEMCLEAN(obs=10);
/* 	VAR date time tt checks; */
	VAR date time checks;
RUN;


/*Creating Unqiue ID with date and time
NOTE: that time is formatted as military time, some of the leading "0"s have been lost,
so they are added back in when creating ID variable.
Dropping original variables that needed reformatting.
Also dropping variables with only 1 value.*/
PROC SQL;
	CREATE TABLE WORK.ITEMCLEAN (DROP = DATE_ITEMS TIME_ITEMS CHECK_NUM_ITEMS SEND_TIME) AS 
	SELECT * ,
	CASE
	WHEN LENGTH(time) >= 4 THEN CATS(date,time,checks)
	WHEN LENGTH(time) = 3 THEN CATS(date,'0',time,checks)
	WHEN LENGTH(time) = 2 THEN CATS(date,'00',time,checks)            
	WHEN LENGTH(time) = 1 THEN CATS(date,'000',time,checks)
	END as ID
	FROM WORK.ITEMCLEAN;
QUIT;


/*Reordering variables in ITEMCLEAN*/
DATA WORK.ITEMCLEAN;
	RETAIN Store_Num ID date time checks COMP_APPL COMP_USER COUP_APPL CP_ZERO DELETION DEL_USER DESCR 
	DISC_MNGR_ITEMS DISC_NUM_ITEMS ITEM_NUM MAJOR_ITEMS MEAL_TIME MENU_PRICE MINOR_ITEMS NUM_SOLD 
	OPTION OVERRING_ITEMS PRICE_1 SALES_AMT SALES_CAT SEQ_MAIN SEQ_NUM_ITEMS SHIFT_ITEMS STORE_ITEMS 
	TABLE_ITEMS TAXCODE USER_NUM_ITEMS;
	SET WORK.ITEMCLEAN;
RUN;


/*Reordering the Tidy Menu Variables*/
DATA WORK.TIDYMENU;
	RETAIN INV_NUMBER Size Description Double MAJOR_FCOST MINOR_FCOST 
	CODE PRICE_1 PRICE_2 PRICE_3 FOOD_COST ALT_INVNUM; 
	SET SASUSER.TIDYMENU;
RUN;

/*Taking out "Mini" and "Double" from description*/
DATA WORK.TIDYMENU;
	SET WORK.TIDYMENU;
	Description = TRANWRD(Description,'MINI','');
	Description = TRANWRD(Description,'DOUBLE','');
RUN;




/*Looking to Order_Level_Data
NOTE: Experiencing trouble loading this dataset into SAS
Connected Computer folder into SAS VM, using this file location as file to use.*/
PROC PRINT DATA = TEMP.Order_Level_Data (obs = 10);
RUN;

/*Creating ID*/
/*Formatting DATE_ITEMS to exclude the time
Reformatting TIME_ITEMS to eliminate blank space
Reformatting CHECK_NUM_ITEMS since one instance has "10000" as "1"*/
DATA WORK.Order_Level_Data;
	SET TEMP.Order_Level_Data;
	date = PUT(INPUT(PUT(datepart(DATE_HDR),ddmmyy10.),ddmmyy10.), date9.);
	format date date9.;
	time = STRIP(PUT(TIME_HDR,$4.));
	checks = STRIP(PUT(CHECK_NUM_HDR,$8.));
	IF LENGTH(checks) = 1 THEN checks = CATS(checks,'0000');
RUN;


/*Creating Unqiue ID with date and time
NOTE: that time is formatted as military time, some of the leading "0"s have been lost,
so they are added back in when creating ID variable.
Dropping original variables that needed reformatting.*/
PROC SQL;
	CREATE TABLE WORK.Order_Level_Data (DROP = DATE_HDR TIME_HDR CHECK_NUM_HDR) AS 
	SELECT * ,
	CASE
	WHEN LENGTH(time) >= 4 THEN CATS(date,time,checks)
	WHEN LENGTH(time) = 3 THEN CATS(date,'0',time,checks)
	WHEN LENGTH(time) = 2 THEN CATS(date,'00',time,checks)            
	WHEN LENGTH(time) = 1 THEN CATS(date,'000',time,checks)
	END as ID
	FROM WORK.Order_Level_Data;
QUIT;


/*Getting rid of white space in Store_HDR to convert to numeric
Doing said conversion from character to numeric*/
DATA WORK.ORDER_LEVEL_DATA;
	SET WORK.ORDER_LEVEL_DATA;
	STORE_HDR = COMPRESS(STORE_HDR);
	STORE_HDR1 = INPUT(STORE_HDR,4.);
	DROP STORE_HDR;
	RENAME STORE_HDR1 = STORE_HDR;
RUN;


/*Reordering Variables*/
DATA WORK.ORDER_LEVEL_DATA;
	RETAIN STORE_HDR ID date time checks AMOUNT COST_CENTR_HDR CO_SEQ_HSE CO_SEQ_TRM CO_SEQ_USR DELIV_TIME
	DISC_MNGR_HDR DISC_NUM_HDR DISC_PRINT NUM_PARTY OVERRING_HDR PAY_CASHR PAY_DRAWER
	PAY_TERM PAY_TIME SEQ_NUM_HDR SERV_TIME SHIFT_HDR TABLE_HDR TAX_TOTAL USER_NUM_HDR
	US_SLSWTX;
	SET WORK.ORDER_LEVEL_DATA;
RUN;





