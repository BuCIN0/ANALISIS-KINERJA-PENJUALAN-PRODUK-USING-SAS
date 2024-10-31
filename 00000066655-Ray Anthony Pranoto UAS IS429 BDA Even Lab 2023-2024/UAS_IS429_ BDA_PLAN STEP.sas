session server;

/* Start checking for existence of each input table */
exists0=doesTableExist("CASUSER(ray.anthony@student.umn.ac.id)", "SALES_DATA");
if exists0 == 0 then do;
  print "Table "||"CASUSER(ray.anthony@student.umn.ac.id)"||"."||"SALES_DATA" || " does not exist.";
  print "UserErrorCode: 100";
  exit 1;
end;
print "Input table: "||"CASUSER(ray.anthony@student.umn.ac.id)"||"."||"SALES_DATA"||" found.";
/* End checking for existence of each input table */


  _dp_inputTable="SALES_DATA";
  _dp_inputCaslib="CASUSER(ray.anthony@student.umn.ac.id)";

  _dp_outputTable="01aa3032-d743-49ac-8fe9-f40ab5e975df";
  _dp_outputCaslib="CASUSER(ray.anthony@student.umn.ac.id)";

dataStep.runCode result=r status=rc / code='/* BEGIN data step with the output table                                           data */
data "01aa3032-d743-49ac-8fe9-f40ab5e975df" (caslib="CASUSER(ray.anthony@student.umn.ac.id)" promote="no");

    length
       "InvoiceDate1"n varchar(10)
       "InvoiceDate"n 8
    ;
    format
        "InvoiceDate1"n 10.
        "InvoiceDate"n NLDATE20.
    ;

    /* Set the input                                                                set */
    set "SALES_DATA" (caslib="CASUSER(ray.anthony@student.umn.ac.id)"   rename=("Invoice Date"n = "InvoiceDate1"n) );

    /* BEGIN statement_5b9646b5_bd31_41ab_b009_981ed56daa19              convert_column */
    "InvoiceDate"n= INPUT(strip("InvoiceDate1"n),ANYDTDTE9.);
    /* END statement_5b9646b5_bd31_41ab_b009_981ed56daa19                convert_column */

    /* BEGIN statement 799e68a5_67e9_40f3_85af_5f4b8f2182b3               simple_filter */
    if
        ^missing ("InvoiceDate"n)
        ;
    /* END statement 799e68a5_67e9_40f3_85af_5f4b8f2182b3                 simple_filter */

/* END data step                                                                    run */
run;
';
if rc.statusCode != 0 then do;
  print "Error executing datastep";
  exit 2;
end;
  _dp_inputTable="01aa3032-d743-49ac-8fe9-f40ab5e975df";
  _dp_inputCaslib="CASUSER(ray.anthony@student.umn.ac.id)";

  _dp_outputTable="01aa3032-d743-49ac-8fe9-f40ab5e975df";
  _dp_outputCaslib="CASUSER(ray.anthony@student.umn.ac.id)";

dataStep.runCode result=r status=rc / code='/* BEGIN data step with the output table                                           data */
data "01aa3032-d743-49ac-8fe9-f40ab5e975df" (caslib="CASUSER(ray.anthony@student.umn.ac.id)" promote="no");


    /* Set the input                                                                set */
    set "01aa3032-d743-49ac-8fe9-f40ab5e975df" (caslib="CASUSER(ray.anthony@student.umn.ac.id)"   drop="InvoiceDate1"n  drop="Retailer ID"n );

/* END data step                                                                    run */
run;
';
if rc.statusCode != 0 then do;
  print "Error executing datastep";
  exit 2;
end;
  _dp_inputTable="01aa3032-d743-49ac-8fe9-f40ab5e975df";
  _dp_inputCaslib="CASUSER(ray.anthony@student.umn.ac.id)";

  _dp_outputTable="01aa3032-d743-49ac-8fe9-f40ab5e975df";
  _dp_outputCaslib="CASUSER(ray.anthony@student.umn.ac.id)";

/* BEGIN statement 036623f2_eefe_11e6_bc64_92361f002671          datastep_statement */
dataStep.runCode result=r status=rc / code='/* BEGIN data step with the output table data */
data "01aa3032-d743-49ac-8fe9-f40ab5e975df" (caslib="CASUSER(ray.anthony@student.umn.ac.id)" promote="no");
/* Set the input set */
set "01aa3032-d743-49ac-8fe9-f40ab5e975df" (caslib="CASUSER(ray.anthony@student.umn.ac.id)" );

/* Extract month and year */
month_year = intnx(''year'', InvoiceDate, 0, ''B'');
format month_year monyy7.;

/* END data step run */
run;';
if rc.statusCode != 0 then do;
  print "Error executing datastep statement in CASL";
  exit 3;
end;
/* END statement 036623f2_eefe_11e6_bc64_92361f002671            datastep_statement */

  _dp_inputTable="01aa3032-d743-49ac-8fe9-f40ab5e975df";
  _dp_inputCaslib="CASUSER(ray.anthony@student.umn.ac.id)";

  _dp_outputTable="SALES_DATA_NEW";
  _dp_outputCaslib="CASUSER(ray.anthony@student.umn.ac.id)";

srcCasTable="01aa3032-d743-49ac-8fe9-f40ab5e975df";
srcCasLib="CASUSER(ray.anthony@student.umn.ac.id)";
tgtCasTable="SALES_DATA_NEW";
tgtCasLib="CASUSER(ray.anthony@student.umn.ac.id)";
saveType="sashdat";
tgtCasTableLabel="";
replace=1;
saveToDisk=1;

exists = doesTableExist(tgtCasLib, tgtCasTable);
if (exists !=0) then do;
  if (replace == 0) then do;
    print "Table already exists and replace flag is set to false.";
    exit ({severity=2, reason=5, formatted="Table already exists and replace flag is set to false.", statusCode=9});
  end;
end;

if (saveToDisk == 1) then do;
  /* Save will automatically save as type represented by file ext */
  saveName=tgtCasTable;
  if(saveType != "") then do;
    saveName=tgtCasTable || "." || saveType;
  end;
  table.save result=r status=rc / caslib=tgtCasLib name=saveName replace=replace
    table={
      caslib=srcCasLib
      name=srcCasTable
    };
  if rc.statusCode != 0 then do;
    return rc.statusCode;
  end;
  tgtCasPath=dictionary(r, "name");

  dropTableIfExists(tgtCasLib, tgtCasTable);
  dropTableIfExists(tgtCasLib, tgtCasTable);

  table.loadtable result=r status=rc / caslib=tgtCasLib path=tgtCasPath casout={name=tgtCasTable caslib=tgtCasLib} promote=1;
  if rc.statusCode != 0 then do;
    return rc.statusCode;
  end;
end;

else do;
  dropTableIfExists(tgtCasLib, tgtCasTable);
  dropTableIfExists(tgtCasLib, tgtCasTable);
  table.promote result=r status=rc / caslib=srcCasLib name=srcCasTable target=tgtCasTable targetLib=tgtCasLib;
  if rc.statusCode != 0 then do;
    return rc.statusCode;
  end;
end;


dropTableIfExists("CASUSER(ray.anthony@student.umn.ac.id)", "01aa3032-d743-49ac-8fe9-f40ab5e975df");

function doesTableExist(casLib, casTable);
  table.tableExists result=r status=rc / caslib=casLib table=casTable;
  tableExists = dictionary(r, "exists");
  return tableExists;
end func;

function dropTableIfExists(casLib,casTable);
  tableExists = doesTableExist(casLib, casTable);
  if tableExists != 0 then do;
    print "Dropping table: "||casLib||"."||casTable;
    table.dropTable result=r status=rc/ caslib=casLib table=casTable quiet=0;
    if rc.statusCode != 0 then do;
      exit();
    end;
  end;
end func;

/* Return list of columns in a table */
function columnList(casLib, casTable);
  table.columnInfo result=collist / table={caslib=casLib,name=casTable};
  ndimen=dim(collist['columninfo']);
  featurelist={};
  do i =  1 to ndimen;
    featurelist[i]=upcase(collist['columninfo'][i][1]);
  end;
  return featurelist;
end func;
