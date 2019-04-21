/*Girl Scouts SAS Mini Assignment
by Hayden Laws and Jeannez Dylan
*/

*First store the file path in a variable for flexability then import the data as girlscouts.;
FILENAME REFFILE '/folders/myfolders/Anonymous Girls in Cub Scouts Data.xlsx';
PROC IMPORT DATAFILE= REFFILE
	DBMS = XLSX
	OUT = WORK.GIRLSCOUTS;
	GETNAMES=YES;
RUN;

*Here we see that SAS has mis-formatted some of the data
Where there is missing data, that should actually be 0.;
PROC PRINT DATA=WORK.GIRLSCOUTS;
RUN;


*Changing the names to an easier to read names.
We can also see that there are missing values and misinterpreted values.
We will also utilize the yaynay format to convert missing values to 0
We are also ignoring the first two rows because these are summary statistics.;
PROC PRINT DATA = WORK.GIRLSCOUTS (FIRSTOBS = 3 OBS = max) noobs;
var ID _1a_Boys_Only _1b___Ingerate_Girls _1c___New_Girl_Pack Not_My_Pack _2a___All_In _2b___Stair_Step Comments Volunteer;
label _1a_Boys_Only = 'BoysOnly' 
	_1b___Ingerate_Girls = 'GirlsDen'
	_1c___New_Girl_Pack = 'NewGirlPack'
	Not_My_Pack = 'NotMyPack'
	_2a___All_In = 'AllIn'
	_2b___Stair_Step = 'StairStep';
RUN;





*We will change the format from percentage to numeric.;
DATA TEST;
	SET WORK.GIRLSCOUTS
	(RENAME = (_1a_Boys_Only = BoysOnly 
		_1b___Ingerate_Girls = GirlsDen
		_1c___New_Girl_Pack = NewGirlPack
		Not_My_Pack = NotMyPack
		_2a___All_In = AllIn
		_2b___Stair_Step = StairStep));
	format BoysOnly 1.
		GirlsDen 1.
		NewGirlPack 1.
		NotMyPack 1.
		AllIn 1.
		StairStep 1.;
RUN;


*Translating missing values into 0 because that's what it's suppose to be.
We also needed to recalculate NotMyPack since it is a combination of BoysOnly and NewGirlPack;
DATA WORK.TEST;
SET WORK.TEST;
IF BoysOnly = . THEN BoysOnly = 0;
IF GirlsDen = . THEN GirlsDen = 0;
IF NewGirlPack = . THEN NewGirlPack = 0;
IF NotMyPack = . THEN NotMyPack = 0;
IF AllIn = . THEN AllIn = 0;
IF StairStep = . THEN StairStep = 0;
IF (BoysOnly = 1 OR NewGirlPack = 1) THEN NotMyPack = 1;
RUN;


*Since the first two rows are merely summary statistics, we will go ahead and delete them;
PROC SQL;
	DELETE FROM WORK.TEST
	WHERE ID = .;
QUIT;


*Observation about "girls & brownies" phrase;
PROC SQL;
	SELECT *
	FROM WORK.TEST as t
	WHERE t.Comments like '%brow%';
QUIT;
	


*Manually changing observations 7 and 22's AllIn Variable to 0 since they actually answered Integrate;
PROC SQL;
	UPDATE WORK.TEST
	SET AllIn=0
	WHERE ID = 7;
QUIT;

PROC SQL;
	UPDATE WORK.TEST
	SET AllIn=0
	WHERE ID = 22;
QUIT;


*We want to create a new variable called "PositiveMind" to assess the attitude towards integrating girls into cub scouts
It should also be noted that the volunteer column provides no additional information and will be deleted;
PROC SQL;
	ALTER TABLE WORK.TEST
	DROP Volunteer
	ADD PositiveMind num label = "PositiveMind" format = 1.;
	QUIT;


*Assigning values to the PositiveMind variable will proceed as following:
0 - boys only
1 - agrees to integrate girls but gives no reason why
2 - focuses on soley including girls into scouts
3 - expands their opinion into the opinion that children are the future/ let the kids decide;
DATA WORK.TEST;
	SET WORK.TEST;
	IF find(lowcase(Comments), 'brow') ge 1 THEN PositiveMind = 0;
	ELSE IF find(lowcase(Comments),'keep it') ge 1 THEN PositiveMind = 0;
	ELSE IF find(lowcase(Comments), 'why not') ge 1 THEN PositiveMind = 1;
	ELSE IF find(lowcase(Comments), "don't think") ge 1 THEN PositiveMind = 1;
	ELSE IF find(lowcase(Comments), 'young') ge 1 THEN PositiveMind = 3;
	ELSE IF find(lowcase(Comments), 'child') ge 1 THEN PositiveMind = 3;
	ELSE PositiveMind = 2;
	RUN;



*In order to create a pie chart, we need to create a frequency table first;
proc freq data=WORK.TEST;
   tables BoysOnly GirlsDen NewGirlPack NotMyPack AllIn StairStep;
run;

*Create the frequency table manually so that we can create a pie chart;
PROC SQL;
	CREATE TABLE WORK.frequ (Option char(12),Frequency num);
	
	INSERT INTO WORK.frequ 
	values('BoysOnly', 13)
	values('GirlsDen', 18)
	values('NewGirlPack', 4)
	values('NotMyPack', 17)
	values('AllIn', 15)
	values('StairStep', 4);
	
QUIT;


*We then create the pie chart;
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		layout region;
		piechart category=Option response=Frequency / datalabellocation=outside;
		endlayout;
		endgraph;
	end;
run;

*And then display it;
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.FREQU;
run;

ods graphics / reset;



*Just to see how the cleaned data looks.;
PROC PRINT DATA = WORK.TEST;
RUN;






*This is a n-way anova test to see if there's a relationship between the positive mindset variable and the choices each pack makes.;
ods noproctitle;
ods graphics / imagemap=on;

proc glm data=WORK.TEST;
	class BoysOnly GirlsDen NewGirlPack NotMyPack AllIn StairStep;
	model PositiveMind=BoysOnly GirlsDen NewGirlPack NotMyPack AllIn StairStep / 
		ss1 ss3;
	lsmeans BoysOnly GirlsDen NewGirlPack NotMyPack AllIn StairStep / adjust=tukey 
		pdiff=all alpha=0.05 cl;
quit;

*Findnig and replacing spelling and grammar mistakes in the comments;
data WORK.TEST;
	length Comments_Corrected $ 210;
	set WORK.TEST;

	select (Comments);
		when ('I feel every young man and woman deserve the opportunity to learn an searve as scouts but superate boys & girls.') Comments_Corrected='I feel every young man and woman deserve the opportunity to learn and serve as scouts but separate boys and girls.';
		when ('Somwehere between a and be, need to add leaders and space') 
			Comments_Corrected='Somewhere between a and b.  Need to add leaders and space.';
		when ('Boy Scouts should be wehre boys can be together, comfortably with other boys there age. I see zero reasons why the girls should not remain with the other girls.') Comments_Corrected='Boy Scouts should be where boys can be together, comfortably with other boys their age. I see zero reasons why the girls should not remain with the other girls.';
		when ('Integrate dens if BSA allows or just colloboraet w girl scout troup') Comments_Corrected='Integrate dens if BSA allows it or just collaborate with girl scout troop';
		when ('It is boy scouts & cub scouts. Girls have brownies and girl scouts') Comments_Corrected='It is boy scouts and cub scouts. Girls have brownies and girl scouts.';
		when ('*Also marked new girl pack, just took that one.') 
			Comments_Corrected='Also marked new girl pack, just took that one.';
		when ('Why not') Comments_Corrected='Why not?';
		when ('I''m not sure on question 2. I don''t know how feasible it is to recruit new den leaders, or if youll need to. That’s a question left for seasonded scout leaders. 1st for me as a scout parent tiger') Comments_Corrected='I''m not sure about question 2. I don''t know how feasible it is to recruit new den leaders, or if you’ll need to. That’s a question left for seasoned scout leaders. First time for me as a scout parent tiger.';
		when ('Brownies & Girl Scouts should satisfy the needs of grils. If the girls needs change, change he mandate of the browunies or Girl Scouts. Cub Scouts & Boy Scouts are for Boys') Comments_Corrected='Brownies & Girl Scouts should satisfy the needs of girls. If the girls needs change, change the mandate of the brownies or Girl Scouts. Cub Scouts & Boy Scouts are for Boys.';
		when ('I am a sister to a boy scout and I think if you shoose to make an all new den for the girls, let the firls give suggestions.') Comments_Corrected='I am a sister to a boy scout and I think if you choose to make an all new den for the girls, let the girls give suggestions.';
		when ('Inclusivity is rarely a detriment to societal health and growth & usually easier to adjust to than its biggest detractors realize. Let the kids lead the way') Comments_Corrected='Inclusivity is rarely a detriment to societal health and growth & usually easier to adjust to than its biggest detractors realize. Let the kids lead the way.';
		when ('I thought Girls Scouts offered similar activities for girls. May end up being a deal breaker for us.') Comments_Corrected='I thought Girls Scouts offered similar activities for girls. May end up being a deal breaker for us.';
		when ('I don''t think this would be that big of a change') 
			Comments_Corrected='I don''t think this would be that big of a change.';
		when ('"Boy" Scouts "Girl Scouts" I need cookies. Keep it "Girl" Scouts.') Comments_Corrected='"Boy" Scouts "Girl” Scouts… I need cookies. Keep it "Girl" Scouts.';
		when ('Yes, just do it, all in') 
			Comments_Corrected='Yes, just do it. All in.';
		when ('More would mean more parents potentially to help out! Girls need to learn many of the skills taught also!') Comments_Corrected='More would mean more parents potentially to help out! Girls need to learn many of the skills taught also!';
		otherwise Comments_Corrected=Comments;
	end;
run;

*Correcting the order of the columns;
data work.test_final;
retain ID BoysOnly GirlsDen NewGirlPack NotMyPack AllIn StairStep Comments Comments_Corrected PositiveMind;
set work.test;
run;
