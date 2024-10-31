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
  Load casdata="Support_vector_machine___Sales_Level_1.sashdat" incaslib="Models" casout="Support_vector_machine___Sales_Level_1" outcaslib="casuser" replace;
Quit;

/* Apply the model */
proc cas;
  fcmpact.runProgram /
  inputData={caslib="&SOURCE_LIB" name="&SOURCE_DATA"}
  outputData={caslib="&DEST_LIB" name="&DEST_DATA" replace=1}
  routineCode = "

   /*------------------------------------------
   Generated SAS Scoring Code
     Date             : 30May2024:08:54:55
     Locale           : en_US
     Model Type       : Support Vector Machine
     Interval variable: Operating Profit
     Interval variable: Price per Unit
     Interval variable: Total Sales
     Interval variable: Units Sold
     Class variable   : _va_d__E_Sales_Level(_E_Sales_Level)
     Response variable: _va_d__E_Sales_Level(_E_Sales_Level)
     ------------------------------------------*/
/* Temporary Computed Columns */
if (('Sales_Level'n = 'Low'))then do;
'_va_d__E_Sales_Level'n= 0.0;
end;
else do;
if (MISSING('Sales_Level'n))then do;
'_va_d__E_Sales_Level'n= .;
end;
else do;
'_va_d__E_Sales_Level'n= 1.0;
end;
end;
;

/*------------------------------------------*/
declare object Support_vector_machine___Sales_Level_1(astore);
call Support_vector_machine___Sales_Level_1.score('CASUSER','Support_vector_machine___Sales_Level_1');
   /*------------------------------------------*/
   /*_VA_DROP*/ drop '_va_d__E_Sales_Level'n 'I__va_d__E_Sales_Level'n 'P__va_d__E_Sales_Level0'n 'P__va_d__E_Sales_Level1'n;
length 'I__va_d__E_Sales_Level_10274'n $32;
      'I__va_d__E_Sales_Level_10274'n='I__va_d__E_Sales_Level'n;
'P__va_d__E_Sales_Level0_10274'n='P__va_d__E_Sales_Level0'n;
'P__va_d__E_Sales_Level1_10274'n='P__va_d__E_Sales_Level1'n;
   /*------------------------------------------*/
";

run;
Quit;

/* Persist the output table */
proc casutil;
  Save casdata="&DEST_DATA" incaslib="&DEST_LIB" casout="&DEST_DATA%str(.)sashdat" outcaslib="&DEST_LIB" replace;
Quit;
