/*---------------------------------------------------------
  The options statement below should be placed
  before the data step when submitting this code.
---------------------------------------------------------*/
options VALIDMEMNAME=EXTEND VALIDVARNAME=ANY;


/*---------------------------------------------------------
  Before this code can run you need to fill in all the
  macro variables below.
---------------------------------------------------------*/
/*---------------------------------------------------------
  Start Macro Variables
---------------------------------------------------------*/
%let SOURCE_HOST=<Hostname>; /* The host name of the CAS server */
%let SOURCE_PORT=<Port>; /* The port of the CAS server */
%let SOURCE_LIB=<Library>; /* The CAS library where the source data resides */
%let SOURCE_DATA=<Tablename>; /* The CAS table name of the source data */
%let DEST_LIB=<Library>; /* The CAS library where the destination data should go */
%let DEST_DATA=<Tablename>; /* The CAS table name where the destination data should go */

/* Open a CAS session and make the CAS libraries available */
options cashost="&SOURCE_HOST" casport=&SOURCE_PORT;
cas mysess;
caslib _all_ assign;

/* Load ASTOREs into CAS memory */
proc casutil;
  Load casdata="Gradient_boosting___Sales_Level_1.sashdat" incaslib="Models" casout="Gradient_boosting___Sales_Level_1" outcaslib="casuser" replace;
Quit;

/* Apply the model */
proc cas;
  fcmpact.runProgram /
  inputData={caslib="&SOURCE_LIB" name="&SOURCE_DATA"}
  outputData={caslib="&DEST_LIB" name="&DEST_DATA" replace=1}
  routineCode = "

   /*------------------------------------------
   Generated SAS Scoring Code
     Date             : 30May2024:08:56:56
     Locale           : en_US
     Model Type       : Gradient Boosting
     Interval variable: Operating Profit
     Interval variable: Price per Unit
     Interval variable: Total Sales
     Interval variable: Units Sold
     Class variable   : Sales_Level
     Response variable: Sales_Level
     ------------------------------------------*/
declare object Gradient_boosting___Sales_Level_1(astore);
call Gradient_boosting___Sales_Level_1.score('CASUSER','Gradient_boosting___Sales_Level_1');
   /*------------------------------------------*/
   /*_VA_DROP*/ drop 'I_Sales_Level'n 'P_Sales_LevelHigh'n 'P_Sales_LevelLow'n;
length 'I_Sales_Level_11354'n $4;
      'I_Sales_Level_11354'n='I_Sales_Level'n;
'P_Sales_LevelHigh_11354'n='P_Sales_LevelHigh'n;
'P_Sales_LevelLow_11354'n='P_Sales_LevelLow'n;
   /*------------------------------------------*/
";

run;
Quit;

/* Persist the output table */
proc casutil;
  Save casdata="&DEST_DATA" incaslib="&DEST_LIB" casout="&DEST_DATA%str(.)sashdat" outcaslib="&DEST_LIB" replace;
Quit;
