CREATE OR REPLACE PACKAGE pkg_AMI_AccountValidation
IS
--
-- $Revision: \hubu_unix_src\main\16 $
-- $Date: Wed Sep  9 10:21:06 2015 $
--
-- Authors : ZSXN20 and BROOKEP
-- Revised : EwenH
-- Created : 19/11/2008 1:43:47 PM
-- Revised : 29/01/2010
-- Purpose : Retail Billing Account Validation.
--           The main purpose of this package is to speed up bill run process (now that there are many
--           more readings to process). pkg_accum Account Validations have been separated out from the Readings
--           Validations and any errors found are written to ExceptionEvent table.
--
--           This package allows the Account part of the validation to be run less frequently (eg once
--           per day).  Hence,overall accumualation and biling run should be quicker.
--
-- $Log: M:\zsxn20_ERAUS_hubub127852\hubu_unix_src\PVCS\Packages\pkg_AMI_AccountValidation.sql $

-- \hubu_unix_src\main\16  Wed Sep  9 10:21:06 2015  zsxn20 

 

-- \hubu_unix_src\main\hubub127852\1  Tue Sep  8 17:34:10 2015  zsxn20 

--WR127852-Introduce a generic function to obtain RW001 UsageErrorExceptionType

-- \hubu_unix_src\main\15  Thu Aug 27 11:02:31 2015  zsxn20 

-- \hubu_unix_src\main\hubub127118\1  Tue Aug 25 13:02:21 2015  zsxn20 

--WR127118 - 270 days missing Actual Read Quality validation rule change
 
-- \hubu_unix_src\main\14  Fri Jun 26 11:20:01 2015  zsxn20 


-- \hubu_unix_src\main\hubub124405\2  Fri Jun 26 11:18:09 2015  zsxn20 

 

-- \hubu_unix_src\main\hubub124405\1  Fri Jun 26 01:27:59 2015  zsxn20 

 

-- \hubu_unix_src\main\8  Thu Jun 17 16:28:49 2010  zedh01

--Wr 58376  release


-- \hubu_unix_src\main\hubub58376\2  Thu Jun 17 16:25:15 2010  zedh01

--Wr 58376  Enable re-processing of account exceptions that
--were created by the IDE converstion process


-- \hubu_unix_src\main\7  Fri Apr 23 09:56:01 2010  danny

--WR58376 - merge


-- \hubu_unix_src\main\hubub58376\1  Wed Apr 21 17:11:08 2010  danny

--WR58376 - Add function to reprocess account validation exception


-- \hubu_unix_src\main\6  Wed Feb 24 14:21:40 2010  zedh01

--x


-- \hubu_unix_src\main\5  Wed Feb  3 09:16:33 2010  ztxw50

--WR55693


-- \hubu_unix_src\main\eraus\2  Wed Feb 24 11:08:49 2010  zedh01

--Wr 55693  Release


-- \hubu_unix_src\main\eraus\hubub55693\3  Wed Feb 24 11:00:14 2010  zedh01

--Wr 55693  Simply  Improve performance by shifting some account filtering
--from the parent Initialisation process to the child Validation processes


-- \hubu_unix_src\main\eraus\1  Tue Feb  2 18:34:14 2010  zedh01

--Wr 55693  release


-- \hubu_unix_src\main\eraus\hubub55693\2  Tue Feb  2 18:28:34 2010  zedh01

--Wr 55693  Add Validate ALL accounts option


-- \hubu_unix_src\main\4  Thu Feb 19 16:32:05 2009  brookep

--WR47325-merge to main line


-- \hubu_unix_src\main\hubub47325\6  Thu Feb 19 16:27:19 2009  brookep

--WR47325-minor fix


-- \hubu_unix_src\main\hubub47325\5  Fri Jan 30 16:39:35 2009  brookep

--47325 - Extend list of Supplypoints that should be validated  Union list with supply points from new ReadingTOUError records
--        Also change the HMbrID output to LinkedIDRef from the node most relevant to the error to the root HMbrID for each customer
--        This will enable users to open Customer Maintenance screen as well as Customer Care screen
--        Also fix / improve some more


-- \hubu_unix_src\main\hubub47325\4  Thu Jan 15 13:16:57 2009  brookep

--47325 - add version control


--
--  Externally visible Functions
--
FUNCTION Version
    RETURN VARCHAR2;

FUNCTION getUsageErrExpType(iExpType IN Usageerrorexceptiontype.Exceptiontype%TYPE
                           ,iUECode  IN usageerrorexceptiontype.usageerrorcode%TYPE)
    RETURN usageerrorexceptiontype.usageerrorexceptiontypeid%TYPE;
---------------------------------------------------------------------------------------

FUNCTION getReadingsPerDay(iSupplyPointId IN SPPROPERTY.SUPPLYPOINTID%TYPE
                         ,iEndDate       IN DATE
                         ,iStartDate     IN DATE)
    RETURN SPPROPERTY.PROPVALNUMBER%TYPE;
---------------------------------------------------------------------------------------

-- Reprocess
----------------------------------------------------------------------------------------
-- Reprocess a list of Billing ExceptionEvents
-- #usage   Call with one or more existing Billing (AccountValidation) exception event ids.  The current
-- #usage   exception events will be deleted and new ones created if new / the same exceptions are found
-- #usage   Example
-- <code>
--    <br>
--       pkg_AMI_AccountValidation.Reprocess (
--           iaExceptionEventId  INPUT  collection of existing Billing exception event ids
--           oaExceptionEventId  INPUT  collection of new Billing exception event ids
--          );
-- </code>
-- #author  ZEDH01
-- #Created 29/Mar/10
-- #return
-------------------------------------------------------------------------------------------------
PROCEDURE Reprocess (
    iaExceptionEventId             IN  tanum
   ,oaExceptionEventId             OUT tanum
   ,iDBMSOutput                    IN  VARCHAR2 DEFAULT 'N'
   );


----------------------------------------------------------------------------------------
-- ProcessJob
----------------------------------------------------------------------------------------
-- Pre billing account validation for many accounts
-- #usage   This procedure invokes pre billing validation of accounts according to the
-- #usage   values of the report run request properties for the job
-- #usage   Where a single account number is recorded only that account is validated
-- #usage   Where a parent job id is NOT recorded bulk pre billing validation of accounts
-- #usage     is initiated.  This involves the selection of all accounts to be validated
-- #usage     and their recording in the RemotejobAction table along with 1 of n child
-- #usage     job ids. n is the number of child jobs set in the report properties.
-- #usage     This job will wait for all child jobs to complete before it ends.
-- #usage   Where a parent job id is recorded, pre billing validation of the accounts
-- #usage     recorded in the RemotejobAction table for the current jobid is initiated.
-- #usage   Example
-- <code>
--    <br>
--       pkg_AMI_AccountValidation.ProcessJob (
--           iJobId          INPUT  hub remotejob table jobid
--          ,oRc             OUTPUT usually 0 or 4.  indicates if one or more child jobs finised with a non zero exit code
--          );
-- </code>
-- #author  ZEDH01
-- #Created 29/Jan/10 2:53:19 PM
-- #return  PLS_INTEGER
-------------------------------------------------------------------------------------------------
PROCEDURE ProcessJob (
    iJobId                         IN  remotejob.jobid%TYPE
   ,oRc                            OUT remotejob.exitcode%TYPE
   );

PROCEDURE ProcessBRQValJob (
    iJobId                         IN  remotejob.jobid%TYPE
   ,oRc                            OUT remotejob.exitcode%TYPE
   );
----------------------------------------------------------------------------------------
-- Called from shell script to submit job
----------------------------------------------------------------------------------------
-- Submit this job from a shell script to the HUB remote job system
-- #usage   Call with report key and report group key to generate report run
-- #usage   Use ProcessAll = Y to validate all accounts.  The number of child validation jobs will be doubled
-- #usage   and remote job entries to run the job from HUB.
-- #usage   Return the jobid to enable the shell script to wait for the new job to finish.
-- #usage   Example
-- <code>
--    <br>
--       pkg_AMI_AccountValidation.SubmitJob (
--           iReportKey                     IN  report.reportkey%TYPE
--          ,iReportGroup                   IN  report.reportgroupkey%TYPE
--          ,iProcessAll                    IN  VARCHAR2
--          );
-- </code>
-- #author  ZEDH01
-- #Created 29/Jan/10 2:53:19 PM
-- #return  remotejob.jobid%TYPE
-------------------------------------------------------------------------------------------------
FUNCTION SubmitJob (
    iReportKey                     IN report.reportkey%TYPE       DEFAULT 'AccountValidation'
   ,iReportGroup                   IN report.reportgroupkey%TYPE  DEFAULT 'USAGEJOBS'
   ,iProcessAll                    IN VARCHAR2                    DEFAULT 'N'
   ) RETURN remotejob.jobid%TYPE;


/*FUNCTION getBasicRdgQuality (iSPID     IN supplypoint.supplypointid%TYPE
			    ,iDateFrom IN DATE
			    ,IDateTo   IN DATE) RETURN VARCHAR2;*/
END pkg_AMI_AccountValidation;
/
CREATE OR REPLACE PACKAGE BODY pkg_AMI_AccountValidation
IS

-- Private type declarations
TYPE trErrorCode
  IS RECORD (
	 UsageerrorExceptionTypeId      usageerrorexceptiontype.usageerrorexceptiontypeid%TYPE
	,psid                           propertyset.psid%TYPE
	);

TYPE taErrorCode
  IS TABLE OF trErrorCode
  INDEX BY    VARCHAR2(30);

TYPE trAcct IS RECORD (HMBRID pkg_std.taInt
		      ,BUID   pkg_std.taInt);

gAcct trAcct;
-- Private constant declarations
gkMe                           CONSTANT VARCHAR2 (30)         := 'pkg_AMI_AccountValidation';
gkHierarchyMbr                 CONSTANT VARCHAR2 (30)         := 'HIERARCHYMBR';
gkSupplypoint                  CONSTANT VARCHAR2 (30)         := 'SUPPLYPOINT';
gkBillingUET                   CONSTANT VARCHAR2 (30)         := 'BILLING';
gkTAB                          CONSTANT VARCHAR2 (05)         := CHR(09);

-- Private variable declarations
gJobId                         remotejob.jobid%TYPE;
gRc                            remotejob.exitcode%TYPE;
gUserId                        reportrun.userid%TYPE;

gMaxDate                       DATE                           := pkg_k.k_MaxDate;

gaErrorCode                    taErrorCode;
gaTimebandDescr                pkg_std.taDescr;
gaTimesetDescr                 pkg_std.taDescr;

-- variables for 'stacking' exceptions between data base updates
gaEEId                         tanum                          := tanum();
gaEEExceptionMessage           tastring8i                     := tastring8i();
gaEELinkedIdRef                tanum                          := tanum();
gaEELinkedTable                tadescr8i                      := tadescr8i();
gaEEUsageErrorExceptionTypeId  tanum                          := tanum();
gaEEPSId                       tanum                          := tanum();
gaEETimestamp                  tadate8i                       := tadate8i();
gaEEProcessStatus              tadescr8i                      := tadescr8i();
gaEEIdSave                     tanum                          := tanum();

gaEEIdNULL                     tanum                          := tanum();
gaEEExceptionMessageNULL       tastring8i                     := tastring8i();
gaEELinkedIdRefNULL            tanum                          := tanum();
gaEELinkedTableNULL            tadescr8i                      := tadescr8i();
gaEEUsgErrExceptionTypeIdNULL  tanum                          := tanum();
gaEEPSIdNULL                   tanum                          := tanum();
gaEETimestampNULL              tadate8i                       := tadate8i();
gaEEProcessStatusNULL          tadescr8i                      := tadescr8i();
gaEEIdSaveNULL                 tanum                          := tanum();

gExceptionMsgLen               PLS_INTEGER;
gAccSkipCnt                    PLS_INTEGER                    := 0;

gNow                           DATE                           := pkg_calc.Now;
gYesterDay                     DATE                           := pkg_calc.Today - 1;
gRW001                         usageerror.usageerrorcode%TYPE := 'RW001';
gRW001UEET                     UsageErrorExceptionType.UsageErrorExceptionTypeId%TYPE;
gRW001ExpDays                  PLS_INTEGER := NVL(pkg_util.SysPropVal('RDGWARNEXPDAYS','N'),365);

-- Function and procedure implementations
----------------------------------------------------------------------------------------
-- template
----------------------------------------------------------------------------------------
--FUNCTION/PROCEDURE fp (
--    ....*....1....*....2....*....3
--    )
--RETURN
--IS
--    -- exception management
--    lMe                            pkg_OraException.tObjectName         := ;  -- e.g. := 'fp';
--    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
--    lExtraTxt                      pkg_OraException.tAdditionalText;
--    lErrStack                      pkg_OraException.tFormat_error_stack;
--    lCallStack                     pkg_OraException.tFormat_call_stack;
--    laParamList                    pkg_OraException.taParamList;
--    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging
--    -- end exception management
--
--BEGIN  -- fp
--    laParamList(01).Name  := ;                            -- name  of variable 01, 02 etc
--    laParamList(01).Value := anydata.convertvarchar2 ();  -- value of variable 01, 02 etc.  use anydata.convertnumber () or anydata.convertdate () as required
--
--    RETURN
--
--EXCEPTION
--    WHEN OTHERS THEN
--        pkg_OraException.SetStack (
--            iPkgName        => gkMe
--           ,iProcName       => lMe
--           ,iProcCheckPoint => lProcCheckPoint
--           ,iAddtionalText  => lExtraTxt
--           ,iSqlCode        => SQLCODE
--           ,iSqlErrM        => SQLERRM
--           ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
--           ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
--           ,iParamList      => laParamList
--           ,iVariableList   => laVariableList
--           );
--
--        RAISE;
--
--END fp;
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- version
----------------------------------------------------------------------------------------
FUNCTION version
  RETURN VARCHAR2
IS
BEGIN  -- version
    RETURN gKMe || '.sql $Revision: \hubu_unix_src\main\16 $';
END version;

PROCEDURE log (iMsg IN VARCHAR2) IS
BEGIN
    dbms_output.put_line(substr(iMsg,1,250));
END log;

FUNCTION getUsageErrExpType(iExpType IN Usageerrorexceptiontype.Exceptiontype%TYPE
                           ,iUECode  IN usageerrorexceptiontype.usageerrorcode%TYPE)
    RETURN usageerrorexceptiontype.usageerrorexceptiontypeid%TYPE IS
    lUEET usageerrorexceptiontype.usageerrorexceptiontypeid%TYPE := NULL;
BEGIN 
    SELECT UsageErrorExceptionTypeId
    INTO   lUEET
    FROM   UsageErrorExceptionType
    WHERE  ExceptionType = iExpType
    AND    usageerrorcode = iUECode;
    
    RETURN lUEET;
EXCEPTION 
    WHEN OTHERS THEN
         RETURN NULL;
END getUsageErrExpType;

----------------------------------------------------------------------------------------
FUNCTION getReadingsPerDay(iSupplyPointId IN SPPROPERTY.SUPPLYPOINTID%TYPE
                         ,iEndDate       IN DATE
                         ,iStartDate     IN DATE)
    RETURN SPPROPERTY.PROPVALNUMBER%TYPE IS
    lResult SPPROPERTY.PROPVALNUMBER%TYPE := NULL;
BEGIN 
    SELECT propvalnumber
    INTO lResult
    FROM  spproperty
    WHERE propertykey = 'RDPDAY'
    AND   supplypointid = iSupplyPointId
    AND   datestart <= iEndDate AND (dateend is null or dateend >= iStartDate);
    RETURN lResult;
EXCEPTION 
    WHEN TOO_MANY_ROWS THEN
        BEGIN
            SELECT propvalnumber
            INTO lResult
            FROM  spproperty
            WHERE propertykey = 'RDPDAY'
            AND   supplypointid = iSupplyPointId
            AND   datestart <= iStartDate AND (dateend is null or dateend + 1 >= iEndDate);
            RETURN lResult;
        EXCEPTION
            WHEN OTHERS THEN
                RETURN NULL;
        END;
    WHEN OTHERS THEN
         RETURN NULL;
END getReadingsPerDay;

----------------------------------------------------------------------------------------
-- Initialise
----------------------------------------------------------------------------------------
PROCEDURE Initialise
IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'Initialise';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    CURSOR cErrorCode
    IS
	SELECT usageerrorexceptiontypeid
	      ,usageerrorcode
	      ,p.psid
	FROM   usageerrorexceptiontype ut
	JOIN   propertyset p              ON p.pskey = ueetpskey
	WHERE  exceptiontype = gkBillingUET;

    CURSOR cTimeband
    IS
	SELECT timebandid
	      ,descr || ' [' || timebandid || ']' AS descr
	FROM   timeband;

    CURSOR cTimeset
    IS
	SELECT timesetid
	      ,descr || ' [' || timesetid || ']'  AS descr
	FROM   timeset;

    laUsageerrorExceptionTypeid    tanum;
    laErrorCode                    tadescr8i;
    laPSId                         tanum;

    laTimebandId                   tanum;
    laTimebandDescr                tadescr8i;

    laTimesetId                    tanum;
    laTimesetDescr                 tadescr8i;

BEGIN  -- Initialise
    --laParamList(01).Name  := ;                            -- name  of variable 01, 02 etc
    --laParamList(01).Value := anydata.convertvarchar2 ();  -- value of variable 01, 02 etc.  use anydata.convertnumber () or anydata.convertdate () as required

    -- populate a collection of error code info indexed by error code
    lProcCheckPoint := 'OPEN cErrorCode';
    OPEN cErrorCode;
    FETCH cErrorCode
      BULK COLLECT
      INTO laUsageerrorExceptionTypeid
	  ,laErrorCode
	  ,laPSId;
    CLOSE cErrorCode;

    FOR i IN 1 .. laErrorCode.COUNT LOOP
	gaErrorCode(laErrorCode(i)).UsageerrorExceptionTypeid := laUsageerrorExceptionTypeid(i);
	gaErrorCode(laErrorCode(i)).PSId                      := laPSId(i);
    END LOOP;

    -- populate a collection of timeband descriptions indexed by timebandid
    lProcCheckPoint := 'OPEN cTimeband';
    OPEN cTimeband;
    FETCH cTimeband
      BULK COLLECT
      INTO laTimebandId
	  ,laTimebandDescr;
    CLOSE cTimeband;

    FOR i IN 1 .. laTimebandId.COUNT LOOP
	gaTimebandDescr(laTimebandId(i)) := laTimebandDescr(i);
    END LOOP;

    -- populate a collection of timeset descriptions indexed by timesetid
    lProcCheckPoint := 'OPEN cTimeset';
    OPEN cTimeset;
    FETCH cTimeset
      BULK COLLECT
      INTO laTimesetId
	  ,laTimesetDescr;
    CLOSE cTimeset;

    FOR i IN 1 .. laTimesetId.COUNT LOOP
	gaTimesetDescr(laTimesetId(i)) := laTimesetDescr(i);
    END LOOP;

    lProcCheckPoint := 'SELECT utc.data_length';
    SELECT utc.data_length
    INTO   gExceptionMsgLen
    FROM   user_tab_columns utc
    WHERE  utc.table_name  = 'EXCEPTIONEVENT'
    AND    utc.column_name = 'EXCEPTIONMESSAGE';

EXCEPTION
    WHEN OTHERS THEN
	pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	RAISE;

END Initialise;
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- SaveException   -- Bulk insert exceptions to the database
----------------------------------------------------------------------------------------
PROCEDURE SaveException
IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'SaveException';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    lcnt                           PLS_INTEGER;

BEGIN  -- SaveException
    --laParamList(01).Name  := ;                            -- name  of variable 01, 02 etc
    --laParamList(01).Value := anydata.convertvarchar2 ();  -- value of variable 01, 02 etc.  use anydata.convertnumber () or anydata.convertdate () as required

    IF gaEEExceptionMessage.count < 1 THEN
	RETURN;
    END IF;

    lProcCheckPoint := 'INSERT ExceptionEvent';
    FORALL i IN 1 .. gaEEExceptionMessage.count
	INSERT INTO exceptionevent
	  (
	   ExceptionEventId
	  ,usageerrorexceptiontypeid
	  ,timestamp
	  ,psid
	  ,exceptionmessage
	  ,linkedtable
	  ,linkedidref
	  ,processstatus
	  )
	VALUES
	  (
	   gaEEId(i)
	  ,gaEEUsageErrorExceptionTypeId(i)
	  ,gaEETimestamp(i)
	  ,gaEEPSId(i)
	  ,gaEEExceptionMessage(i)
	  ,gaEELinkedTable(i)
	  ,gaEELinkedIdRef(i)
	  ,gaEEProcessstatus(i)
	  );

    lCnt     := SQL%ROWCOUNT;
    IF lCnt <> gaEEExceptionMessage.count THEN
	raise_application_error (
	    -20100
	   ,'Number of exceptions saved does not equal the expected number.  Saved [' || lCnt || ']  Expected [' || gaEEExceptionMessage.count || ']'
	   );
    END IF;

    -- reset the global error collections
    lProcCheckPoint := 'initialise collections';
    gaEEId                        := gaEEIdNULL;
    gaEEExceptionMessage          := gaEEExceptionMessageNULL;
    gaEELinkedTable               := gaEELinkedTableNULL;
    gaEELinkedIdRef               := gaEELinkedIdRefNULL;
    gaEEUsageErrorExceptionTypeId := gaEEUsgErrExceptionTypeIdNULL;
    gaEEPSId                      := gaEEPSIdNULL;
    gaEETimestamp                 := gaEETimestampNULL;
    gaEEProcessStatus             := gaEEProcessStatusNULL;

EXCEPTION
    WHEN OTHERS THEN
	pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	RAISE;

END SaveException;
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- StackException  -- save exception details to collections for later bulk insertion to the database
----------------------------------------------------------------------------------------
PROCEDURE StackException (
    iUsageErrorCode                IN  usageerrorexceptiontype.usageerrorcode%TYPE
   ,iExceptionMessage              IN  exceptionevent.exceptionmessage%TYPE
   ,iLinkedTable                   IN  exceptionevent.linkedtable%TYPE
   ,iLinkedIdRef                   IN  exceptionevent.linkedidref%TYPE
   ,iAsAtDate                      IN  exceptionevent.timestamp%TYPE
   ,oExceptionEventId              OUT exceptionevent.exceptioneventid%TYPE
   )
IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'StackException';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    lIdx                           PLS_INTEGER;

BEGIN  -- StackException
    laParamList(01).Name  := 'iUsageErrorCode';
    laParamList(01).Value := anydata.ConvertVarchar2 (iUsageErrorCode);
    laParamList(02).Name  := 'iExceptionMessage';
    laParamList(02).Value := anydata.ConvertVarchar2 (iExceptionMessage);
    laParamList(03).Name  := 'iLinkedTable';
    laParamList(03).Value := anydata.ConvertVarchar2 (iLinkedTable);
    laParamList(04).Name  := 'iLinkedIdRef';
    laParamList(04).Value := anydata.ConvertNumber (iLinkedIdRef);
    laParamList(05).Name  := 'iAsAtDate';
    laParamList(05).Value := anydata.ConvertDate (iAsAtDate);

    -- extend the collections
    gaEEId.EXTEND;
    gaEEIdSave.EXTEND;
    gaEEExceptionMessage.EXTEND;
    gaEELinkedTable.EXTEND;
    gaEELinkedIdRef.EXTEND;
    gaEEUsageErrorExceptionTypeId.EXTEND;
    gaEEPSId.EXTEND;
    gaEETimestamp.EXTEND;
    gaEEProcessStatus.EXTEND;

    -- save the new values
    lIdx                                := gaEEExceptionMessage.COUNT;

    gaEEId(lIdx)                        := ExceptionEventId.NextVal;
    gaEEIdSave(gaEEIdSave.COUNT)        := gaEEId(lIdx);
    gaEEExceptionMessage(lIdx)          := CASE
					                                       WHEN length (iExceptionMessage) > gExceptionMsgLen THEN
						                                          substr (iExceptionMessage, 1, gExceptionMsgLen-4) || ' ...'
					                                       ELSE
						                                          iExceptionMessage
					                                       END;
    gaEELinkedTable(lIdx)               := iLinkedTable;
    gaEELinkedIdRef(lIdx)               := iLinkedIdRef;
    gaEEUsageErrorExceptionTypeId(lIdx) := gaErrorCode(iUsageErrorCode).UsageerrorExceptionTypeId;
    gaEEPSId(lIdx)                      := gaErrorCode(iUsageErrorCode).PSId;
    gaEETimestamp(lIdx)                 := iAsAtDate;
    gaEEProcessStatus(lIdx)             := 'E';

    -- return the new ExceptionEventId  (proc SaveException resets the gaEE... tables)
    oExceptionEventId                   := gaEEId(lIdx);
    
    IF  lIdx >= 100 THEN
	      SaveException;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
	  pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	RAISE;

END StackException;
----------------------------------------------------------------------------------------
PROCEDURE ValidateReadQlty (
    iHmbrId                        IN  hierarchymbr.hmbrid%TYPE
   ,iBuid                          IN  businessunit.buid%TYPE
   ,oExceptionMessage              OUT exceptionevent.exceptionmessage%TYPE
   ,oLinkedTable                   OUT exceptionevent.linkedtable%TYPE
   ,oLinkedIdRef                   OUT exceptionevent.linkedidref%TYPE
   ,oUsageErrorCode                OUT usageerrorexceptiontype.usageerrorcode%TYPE
   ,oAsAtDate                      OUT exceptionevent.timestamp%TYPE
   )
IS
    lMe                            pkg_OraException.tObjectName         := 'ValidateReadQlty[1]';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;
    lReadQualAlertDays             PLS_INTEGER := pkg_util.SysPropVal('RDGWARNDAYS','N');
    lBillQuality                   VARCHAR2(1) := 'S';
    lDateTo                        DATE;
    lInvCnt                        PLS_INTEGER := 0;
    kRdgQualWarning                CONSTANT VARCHAR2(5) := 'RW001';
    
    
    CURSOR cInvoice (iHmbrID IN HierarchyMbr.HMBRID%TYPE) IS
	         SELECT i.invoiceid, i.hmbrid, i.datefrom, i.dateto, t.BillTo, i.readingtype
	         FROM   hierarchymbr hm,
		              invoice i,
		             (SELECT MIN(datefrom) BillFrom,
			                   MAX(DateTo) BillTo,
			                   (gYesterDay - lReadQualAlertDays) BillAt
		              FROM   invoice
		              WHERE  hmbrid = ihmbrid
		              AND    invoicestatus <> 'W') t
	         WHERE  hm.hmbrid = ihmbrid
	         AND    hm.hmbrtype = 'BP'
	         AND    i.hmbrid = hm.hmbrid
	         AND    i.invoicestatus <> 'W'                       -- Don't consider Withdrawn Invoices
	         AND    i.dateto > t.BillAt                          -- Only consider invoices created within 270 days period since last bill end date.
	         AND    i.datefrom >= hm.datestart                   -- Only consider invoices created after Account start date
	         AND    DECODE(t.billat, GREATEST(t.billat,t.billfrom,hm.datestart),'Y','N') = 'Y'  -- Ignore if we don't have 270 days invoice data
	         ORDER  BY i.dateto DESC;
           
BEGIN
    laParamList(01).Name  := 'iHmbrId';
    laParamList(01).Value := anydata.ConvertNumber (iHmbrId);
    laParamList(02).Name  := 'iBuid';
    laParamList(02).Value := anydata.ConvertNumber (iBuid);
    
    -- Retrieve Invoices involved with Invoice range
    FOR i IN cInvoice(iHmbrID) LOOP
	      lDateTo := i.BillTo;
	      lInvCnt := lInvCnt + 1;
        
          lBillQuality := pkg_AMI.GetBRQ(i.HMBRID,i.InvoiceID,i.DateFrom,i.DateTo,'AMIAV');
          
          IF  i.ReadingType IS NULL OR
              i.ReadingType <> lBillQuality THEN
              -- Update Invoice with newly derived ReadingType value
              BEGIN
                  UPDATE INVOICE
                  SET    readingtype = lBillQuality
                  WHERE  INVOICEID = i.InvoiceID;
                  
              EXCEPTION
                  WHEN OTHERS THEN
                       log ('Error updating the Lastest Overall Invoice Read Quality for Invoice '||
                            i.InvoiceID||' ReadingType = '||lBillQuality||' Error '||SQLERRM);
              END;
          END IF;
	
        IF  lBillQuality = 'A' THEN
	          EXIT;
	      END IF;
    END LOOP;
    
    IF  lInvCnt > 0 AND lBillQuality <> 'A' THEN
	      oUsageErrorCode   := kRdgQualWarning;
	      oExceptionMessage := pkg_msg.GetMsg('V_SYS_106','',lReadQualAlertDays,to_char(gYesterDay,'dd/mm/yyyy'),iBuId).MsgText;
			  --Make message user configurable.
			  /*'No Actual Read received within last '||lReadQualAlertDays||' Days prior to  '||to_char(gYesterDay,'dd/mm/yyyy')||
			     ' Account: ' || iBuId;*/
	      oLinkedIdRef      := iHMbrId;
	      oLinkedTable      := gkHierarchyMbr;
	      oAsAtDate         := gNow;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
	       pkg_OraException.SetStack (
	       iPkgName        => gkMe
	      ,iProcName       => lMe
	      ,iProcCheckPoint => lProcCheckPoint
	      ,iAddtionalText  => lExtraTxt
	      ,iSqlCode        => SQLCODE
	      ,iSqlErrM        => SQLERRM
	      ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	      ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	      ,iParamList      => laParamList
	      ,iVariableList   => laVariableList);
	      
        RAISE;
END ValidateReadQlty;


----------------------------------------------------------------------------------------
-- ValidateHMbr
----------------------------------------------------------------------------------------
PROCEDURE ValidateHMbr (
    iHmbrId                        IN  hierarchymbr.hmbrid%TYPE
   ,iBuid                          IN  businessunit.buid%TYPE
   ,iDateStart                     IN  DATE
   ,iDateEnd                       IN  DATE
   ,iCompleteFlg                   IN  hierarchymbr.completeflg%TYPE
   ,iHMbrPsId                      IN  hierarchymbr.psid%TYPE
   ,iDateBilledTo                  IN  invoice.dateto%TYPE
   ,iDateValFrom                   IN  DATE
   ,iDateValTo                     IN  DATE
   ,oExceptionMessage              OUT exceptionevent.exceptionmessage%TYPE
   ,oLinkedTable                   OUT exceptionevent.linkedtable%TYPE
   ,oLinkedIdRef                   OUT exceptionevent.linkedidref%TYPE
   ,oUsageErrorCode                OUT usageerrorexceptiontype.usageerrorcode%TYPE
   ,oAsAtDate                      OUT exceptionevent.timestamp%TYPE
   )
IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'ValidateHMbr[1]';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    -- site associated with the billing point via 'usage' inventory
    -- in Simply Energy a change of address is causing metering points to be attached
    --   to two (functionally equivalent) sites at the same time
    CURSOR cSite (
	iHmbrId                        hierarchymbr.hmbrid%TYPE
       ,iDateFrom                      DATE
       ,iDateTo                        DATE
       ) IS
	WITH inventorysp
	    AS (
		-- inventory supplypoints
		SELECT DISTINCT spid.propvalnumber AS inventoryspid
		FROM   hmbrinventory hi    -- hmbrinventory dates are not checked as they don't seem to be correct
		JOIN   inventory i        ON  i.InventoryId      = hi.InventoryId
		JOIN   product p          ON  p.productid        = i.productid
		JOIN   invproperty incrtl ON  incrtl.Inventoryid = i.inventoryid
					  AND incrtl.Propertykey = 'INCRTL'
		JOIN   invproperty spid   ON  spid.Inventoryid   = i.Inventoryid
					  AND spid.propertykey   = 'SPID'
		WHERE  hi.hmbrid
		  IN (
		      -- billing point and associated non billing points
		      SELECT hmbrid
		      FROM   hierarchymbr hm
		      START WITH hm.hmbrid     =  iHMbrId
		      AND        hm.hmbrtype   =  'BP'
		      AND        hm.datestart  <= iDateTo
		      AND        (   hm.dateend IS NULL
				  OR hm.dateend >= iDateFrom)
		      CONNECT BY hm.parentbuid =  PRIOR hm.buid
		      AND        hm.hmbrtype   =  'NBP'
		      AND        hm.datestart  <= iDateTo
		      AND        (   hm.dateend IS NULL
				  OR hm.dateend >= iDateFrom)
		     )
		AND    i.dateactive       <= iDateTo
		AND    (   i.datedeactive IS NULL
			OR (    i.datedeactive >= iDateFrom
			    AND i.datedeactive >  i.dateactive)
		       )
		AND    p.chargetype       IN ('UE', 'UG')
		AND    incrtl.propvalchar =  'N'           -- only inventory that is NOT included in another charge is considered
		AND    spid.propvalnumber IS NOT NULL
	       )
	SELECT MAX (supplypointid) AS sitespid
	      ,COUNT(1)            AS ccount
	FROM   supplypoint s
	WHERE  s.metertype     LIKE 'SITE%'
	AND    s.supplypointid
	  IN (
	      -- parent supplypoints of inventory supplypoints
	      SELECT DISTINCT sp.parentsupplypointid AS inventoryspid
	      FROM   supplypointparent sp
	      START WITH sp.supplypointid
		IN (
		    SELECT inventoryspid
		    FROM   inventorysp
		   )
	      AND        sp.datestart           <= iDateTo
	      AND        (   sp.dateend IS NULL
			  OR sp.dateend >= iDateFrom)
	      CONNECT BY sp.supplypointid =  PRIOR sp.parentsupplypointid
	      AND        sp.datestart     <= iDateTo
	      AND        (   sp.dateend IS NULL
			  OR sp.dateend >= iDateFrom)
	      UNION ALL
	      -- inventory supplypoints
	      SELECT inventoryspid
	      FROM   inventorysp
	     );

    -- billing point 'usage' and 'demand' inventory that is NOT included in another charge
    -- NOTE the NOT Included In Retail Inventory test seems to work for Simply who have only one retail charge
    --      but would not work for SPOW who pass through must charges to the customer.  SPOW would need to ensure
    --      that all consumption was being rated by the 'Retail Inventory Item', the same concept as used for CCL
    --      charge calculation.
    CURSOR cInventory (
	iHmbrId                        hierarchymbr.hmbrid%TYPE
       ,iDateFrom                      DATE
       ,iDateTo                        DATE
       ) IS
	SELECT i.inventoryid
	      ,i.overridedescrdictid
	      ,i.dateactive
	      ,i.datedeactive
	      ,i.parentinventoryid
	      ,i.productrelid
	      ,i.completeflg         AS invcompleteflg
	      ,p.productid
	      ,p.productcode
	      ,p.descrdictid
	      ,p.chargetype
	      ,p.completeflg         AS prodcompleteflg
	      ,d.phrase
	FROM   hmbrinventory hi    -- hmbrinventory dates are not checked as they don't seem to be correct
	JOIN   inventory i        ON  i.InventoryId      = hi.InventoryId
	JOIN   invproperty incrtl ON  incrtl.Inventoryid = i.inventoryid
				  AND incrtl.Propertykey = 'INCRTL'
	JOIN   product p          ON  p.productid        = i.productid
	JOIN   dictionary d       ON  d.dictid           = p.descrdictid
	WHERE  hi.hmbrid
	  IN (
	      -- billing point and associated non billing points
	      SELECT hmbrid
	      FROM   hierarchymbr hm
	      START WITH hm.hmbrid     =  iHMbrId
	      AND        hm.hmbrtype   =  'BP'
	      AND        hm.datestart  <= iDateTo
	      AND        (   hm.dateend IS NULL
			  OR hm.dateend >= iDateFrom)
	      CONNECT BY hm.parentbuid =  PRIOR hm.buid
	      AND        hm.hmbrtype   =  'NBP'
	      AND        hm.datestart  <= iDateTo
	      AND        (   hm.dateend IS NULL
			  OR hm.dateend >= iDateFrom)
	     )
	AND    i.dateactive       <=   iDateTo
	AND    (   i.datedeactive IS NULL
		OR (    i.datedeactive >= iDateFrom
		    AND i.datedeactive >  i.dateactive)
	       )
	AND    incrtl.propvalchar =    'N'  -- only inventory that is NOT included in another charge is considered
	AND    p.chargetype       LIKE 'U%';

    TYPE taInventory
      IS TABLE OF cInventory%ROWTYPE
      INDEX BY    BINARY_INTEGER;

    laInventory                    taInventory;
    laInventoryNULL                taInventory;

    -- billing point currency at date
    CURSOR cBillCurrency (
	iHMbrId                        hierarchymbr.hmbrid%TYPE
       ,iDateActive                    DATE
       ,iDateDeactive                  DATE
       ) IS
	SELECT propvalchar
	FROM   hmbrproperty
	WHERE  propertykey =  'BILCUR'
	AND    hmbrid      =  iHMbrId
	AND    datestart   <= NVL (iDateDeactive, gMaxdate)
	AND    (   dateend IS NULL
		OR dateend >= iDateActive)
	ORDER BY datestart DESC;

    -- rating plan properties
    CURSOR cRPlan (
	iRatingPlanId                  rpproperty.ratingplanid%TYPE
       ,iDateFrom                      DATE
       ,iDateTo                        DATE
       ) IS
	SELECT DISTINCT                         -- try and avoid multiple occurences of the same property value
	       rp.completeflg                   -- this is a common occurrence when date effective properties are involved
	      ,rp.descr
	      ,propertykey
	      ,propvalchar
	      ,propvalnumber
	FROM   ratingplan rp
	JOIN   rpproperty rpp ON  rpp.ratingplanid =  rp.RatingPlanId
			      AND rpp.propertykey  IN ('CONSU', 'DEMDU', 'TISET')
			      AND (   rpp.datestart IS NULL
				   OR rpp.datestart <= iDateTo)
			      AND (   rpp.dateend IS NULL
				   OR rpp.dateend >= iDateFrom)
	WHERE  rp.ratingplanid = iRatingPlanId;

    TYPE taRPlan
      IS TABLE OF cRPlan%ROWTYPE
      INDEX BY    BINARY_INTEGER;

/*    CURSOR cRate (
	iId                            etimecharge.ratingplanid%TYPE
       ,iDateFrom                      DATE
       ,iDateTo                        DATE
       ) IS
	SELECT e.etimechargeid
	      ,e.timebandid
	      --,NVL (
	      --     (SELECT 'Y'
	      --      FROM   dual
	      --      WHERE EXISTS (
	      --          SELECT 1
	      --          FROM   etimechargestep es
	      --          WHERE  es.etimechargeid = e.etimechargeid)
	      --     )
	      --    ,'N'
	      --    ) AS HasRateStep
	FROM   etimecharge e
	WHERE  e.ratingplanid =  iId
	AND    e.datestart    <= iDateTo
	AND    (   e.dateend IS NULL
		OR e.dateend >= iDateFrom);

    TYPE taRate
      IS TABLE OF cRate%ROWTYPE
      INDEX BY BINARY_INTEGER;

    CURSOR cRPSpTimeband (
	iId                            etimecharge.ratingplanid%TYPE
       ,iDateFrom                      DATE
       ,iDateTo                        DATE
       ) IS
	SELECT tix.sptimebandid
	FROM   etimecharge e
	JOIN   rptibandsptiband tix ON  tix.ratingplanid = e.ratingplanid
				    AND tix.rptimebandid = e.timebandid
	WHERE  e.ratingplanid =  iId
	AND    e.datestart    <= iDateTo
	AND    (   e.dateend IS NULL
		OR e.dateend >= iDateFrom);

    TYPE taRPSpTimeband
      IS TABLE OF cRPSpTimeband%ROWTYPE
      INDEX BY BINARY_INTEGER;
*/
    -- rating plan rate data
    CURSOR cRate (
	iId                            etimecharge.ratingplanid%TYPE
       ,iDateFrom                      DATE
       ,iDateTo                        DATE
       ) IS
	SELECT e.etimechargeid
	      ,e.timebandid
	      ,tix.sptimebandid
	FROM   etimecharge e
	LEFT JOIN rptibandsptiband tix ON  tix.ratingplanid = e.ratingplanid
				       AND tix.rptimebandid = e.timebandid
	WHERE  e.ratingplanid =  iId
	AND    e.datestart    <= iDateTo
	AND    (   e.dateend IS NULL
		OR e.dateend >= iDateFrom);

    TYPE taRate
      IS TABLE OF cRate%ROWTYPE
      INDEX BY    BINARY_INTEGER;

/*    -- timeset data
    CURSOR cTimeset (
	iTimesetId                     Timeset.TimesetId%TYPE
       ,iDateFrom                      DATE
       ,iDateTo                        DATE
       ) IS
	SELECT DISTINCT
	       tr.TimebandId
	FROM   timeset ts
	JOIN   timesetversion tsv ON tsv.timesetid       = ts.timesetid
	JOIN   timerange tr       ON tr.timesetversionid = tsv.timesetversionid
	WHERE  ts.timesetid   =  iTimesetId
	AND    tsv.dateactive <= iDateTo
	AND    (   tsv.datedeactive IS NULL
		OR tsv.datedeactive >= iDateFrom);

    TYPE taTimeset
      IS TABLE OF cTimeset%ROWTYPE
      INDEX BY    BINARY_INTEGER;

    -- collection of timeset information for error reporting
    TYPE trTimesetInventory
      IS RECORD (
	     lInvenDescr                    VARCHAR2(999)
	    ,lRPDescr                       VARCHAR2(999)
	    ,lTSDescr                       VARCHAR2(999)
	    );

    TYPE taTimesetInventory
      IS TABLE OF trTimesetInventory
      INDEX BY    BINARY_INTEGER;
*/
    -- reading supplypoints
    CURSOR cSPRegister (
	iTopSpId                       supplypoint.supplypointid%TYPE
       ,iDateFrom                      DATE
       ,iDateTo                        DATE
       ) IS
	SELECT SupplyPointId
	      ,TimebandId
	      ,RPDay
	FROM   (
		SELECT DISTINCT              -- try and avoid multiple occurences of the same property value
		       s.SupplyPointId       -- this is a common occurrence when date effective properties are involved
		      ,tiband.propvalnumber AS TimebandId
		      ,nbreg.propvalchar    AS NBReg
		      ,rdpday.propvalnumber AS RPDay
		FROM   (
			SELECT SupplyPointId
			FROM   SupplyPointParent
			START WITH ParentSupplyPointID =  iTopSpId
			AND        datestart           <= iDateTo
			AND        (   dateend IS NULL
				    OR dateend >= iDateFrom)
			CONNECT BY ParentSupplyPointID =  PRIOR SupplyPointID
			AND        datestart           <= iDateTo
			AND        (   dateend IS NULL
				    OR dateend >= iDateFrom)
		       ) sp
		JOIN   Supplypoint s        ON  s.SupplyPointID      =  sp.SupplyPointID
		JOIN   MeterType m          ON  m.MeterType          =  s.MeterType
		LEFT JOIN spproperty tiband ON  tiband.SupplyPointID =  s.SupplyPointID
					    AND tiband.propertykey   =  'TIBAND'
		LEFT JOIN spproperty rdpday ON  rdpday.SupplyPointID =  s.SupplyPointID
					    AND rdpday.propertykey   =  'RDPDAY'
					    AND rdpday.datestart     <= iDateTo
					    AND (   rdpday.dateend IS NULL
						 OR rdpday.dateend >= iDateFrom)
		LEFT JOIN spproperty nbreg  ON  nbreg.SupplyPointID  =  s.SupplyPointID
					    AND nbreg.propertykey    =  'NBREG'
		WHERE m.readingpsid IS NOT NULL
	       )
	WHERE  NBReg IS NULL
	OR     NBReg = 'N';

    TYPE taSPRegister
      IS TABLE OF cSPRegister%ROWTYPE
      INDEX BY    BINARY_INTEGER;

    -- supplypoint description for error reporting
    CURSOR cSPKeyData (
	iSpId                          supplypoint.supplypointid%TYPE
       ,iDateFrom                      DATE
       ,iDateTo                        DATE
       ) IS
	SELECT    m.abrvdescr
	       || ' '
	       || pkg_supplypoint.PropVal (
		      s.supplypointid
		     ,iDateFrom
		     ,m.idfmkey
		     ,99
		     ,'N'
		     ,', '
		     ) AS keydata
	FROM   (
		SELECT ParentSupplypointId AS SupplypointId
		      ,LEVEL               AS llevel
		FROM   SupplypointParent
		START WITH SupplypointId =  iSpId
		AND        DateStart     <= iDateTo
		AND        (   DateEnd IS NULL
			    OR DateEnd >= iDateFrom)
		CONNECT BY SupplypointId =  PRIOR ParentSupplypointId
		AND        DateStart     <= iDateTo
		AND        (   DateEnd IS NULL
			    OR DateEnd >= iDateFrom)
		UNION ALL
		SELECT SupplypointId
		      ,to_number (0)
		FROM   Supplypoint
		WHERE  SupplypointId = iSpId
	       ) sp
	JOIN   Supplypoint s ON s.SupplypointId = sp.SupplypointId
	JOIN   MeterType m   ON m.MeterType     = s.MeterType
	WHERE  m.metertypegroup <> 'S'  -- exclude the site address as it makes the meter / register description very long
	ORDER BY llevel DESC;

    TYPE taSPKeyData
      IS TABLE OF cSPKeyData%ROWTYPE
      INDEX BY    BINARY_INTEGER;

    CURSOR cContractStatus (
	iHMbrId                        hierarchymbr.hmbrid%TYPE
       ) IS
	SELECT propvalchar
	FROM   hmbrproperty
	WHERE  hmbrid      =  iHMbrId
	AND    propertykey =  'CONST'
	ORDER BY datestart DESC
		,hmbrpropertyid DESC;

    lCMMessage                     VARCHAR2(1000);
    lFlag                          PLS_INTEGER;
    lSiteSpId                      supplypoint.supplypointid%TYPE;
    lSiteCnt                       PLS_INTEGER;
    lRc                            PLS_INTEGER;
    lBillCurr                      currency.currencycode%TYPE;

    -- vars used by pkg_inv.PriceHistArr
    AnR                            pkg_inv.taPriceRec;
    BnR                            pkg_inv.taPriceRec;
    nAnR                           NUMBER;
    nBnR                           NUMBER;
    loMsg                          VARCHAR2(999);

    laRPlan                        taRPlan;
    lrRPlan_descr                  ratingplan.descr%TYPE;
    lrRPlan_consu                  rpproperty.propvalchar%TYPE;
    lrRPlan_demdu                  rpproperty.propvalchar%TYPE;
    lrRPlan_tisetid                rpproperty.propvalnumber%TYPE;
    laRate                         taRate;
    lRPTimesetId                   timeset.timesetid%TYPE;
    laTimebandId                   pkg_std.taTimeBandID;
    --laSpTimebandId                 pkg_std.taTimeBandID;
    lNULLRPTimeband                BOOLEAN                             := FALSE;
    laSPRegister                   taSPRegister;
    --lNULLSpTimeband                BOOLEAN                             := FALSE;
    laSPKeyData                    taSpKeyData;
    lInventoryDescr                VARCHAR2(999);
    lRatingPlanDescr               VARCHAR2(999);
    lSPDescr                       VARCHAR2(999);
    lContractStatus                contractstatus.contractstatus%TYPE;
    lDateFrom                      DATE;
    lDateTo                        DATE;
    lAccSkipCnt                    PLS_INTEGER                         := 0;


    FUNCTION GetAccName (
	iBUId                          IN businessunit.buid%TYPE
       )
      RETURN businessunit.name%TYPE
    IS
	-- exception management
	lMe                            pkg_OraException.tObjectName         := 'GetAccName';
	lProcCheckPoint                pkg_OraException.tProcCheckPoint;
	lExtraTxt                      pkg_OraException.tAdditionalText;
	lErrStack                      pkg_OraException.tFormat_error_stack;
	lCallStack                     pkg_OraException.tFormat_call_stack;
	laParamList                    pkg_OraException.taParamList;
	laVariableList                 pkg_OraException.taParamList;
	-- end exception management

	lAccName                       businessunit.name%TYPE;

    BEGIN  -- GetAccName
	laParamList(01).Name  := 'iBUId';
	laParamList(01).Value := anydata.convertnumber (iBUId);

	SELECT NAME
	INTO   lAccName
	FROM   businessunit
	WHERE  buid = iBUId;

	RETURN lAccName;

    EXCEPTION
	WHEN OTHERS THEN
	    pkg_OraException.SetStack (
		iPkgName        => gkMe
	       ,iProcName       => lMe
	       ,iProcCheckPoint => lProcCheckPoint
	       ,iAddtionalText  => lExtraTxt
	       ,iSqlCode        => SQLCODE
	       ,iSqlErrM        => SQLERRM
	       ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	       ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	       ,iParamList      => laParamList
	       ,iVariableList   => laVariableList
	       );

	    RAISE;

    END GetAccName;


BEGIN  -- ValidateHMbr
    laParamList(01).Name  := 'iHmbrId';
    laParamList(01).Value := anydata.ConvertNumber (iHmbrId);
    laParamList(02).Name  := 'iBuid';
    laParamList(02).Value := anydata.ConvertNumber (iBuid);
    laParamList(03).Name  := 'iDateStart';
    laParamList(03).Value := anydata.ConvertDate (iDateStart);
    laParamList(04).Name  := 'iDateEnd';
    laParamList(04).Value := anydata.ConvertDate (iDateEnd);
    laParamList(05).Name  := 'iDateBilledTo';
    laParamList(05).Value := anydata.ConvertDate (iDateBilledTo);
    laParamList(06).Name  := 'iCompleteFlg';
    laParamList(06).Value := anydata.ConvertVarchar2 (iCompleteFlg);
    laParamList(07).Name  := 'iDateValFrom';
    laParamList(07).Value := anydata.ConvertDate (iDateValFrom);
    laParamList(08).Name  := 'iDateValTo';
    laParamList(08).Value := anydata.ConvertDate (iDateValTo);

    -- find the site that the BP is invoicing.  there may not be one because the account is no longer 'active'
    -- the lack of values for end dates on the businessunit and BP hierarchymbr records make it difficult
    --   to determine if an account has been invoiced for the last time or it should continue to be invoiced
    OPEN cSite (
	     iHMbrId
	    ,iDateValFrom
	    ,iDateValTo
	    );
    FETCH cSite
      INTO lSiteSpId
	  ,lSiteCnt;
    CLOSE cSite;

    -- report an error if the BP is not linked to a site and has never been billed
    IF lSiteSpId IS NULL THEN

	-- get the most recent contract status for the account.  this seems to
	-- be the best way to prevent the generation of unnecessary Exception Events
	OPEN cContractStatus (iHMbrId);
	FETCH cContractStatus
	  INTO lContractStatus;
	CLOSE cContractStatus;

	IF  lContractStatus =  'BILL'       -- is billable
	AND iDateBilledTo   IS NULL   THEN
	    oUsageErrorCode   := 'RE176';
	    oExceptionMessage :=    'Contract status is Billable but the account hasn''t been billed and doesn''t have any consumption inventory that links it to a site.'
				 || ' Account: ' || iBuId || ' - ' || GetAccName (iBuId)
				 || ', Date: '   || iDateValFrom;
	    oLinkedIdRef      := iHMbrId;
	    oLinkedTable      := gkHierarchyMbr;
	    oAsAtDate         := iDateValFrom;
	ELSE
	    lAccSkipCnt := lAccSkipCnt + 1;
	END IF;

	GOTO eexit;  -- presume that the account is inactive

    END IF;

    -- check billing point for 'completeness'
    IF iCompleteFlg <> 'Y' THEN
	oUsageErrorCode   := 'RE178';

	-- get reason for account being incomplete
	lCMMessage := pkg_complete.DoCheck (
			  iHMbrId
			 ,iHMbrPsId
			 ,NULL
			 ,NULL
			 ,NULL
			 ,NULL
			 ,FALSE
			 );
	oExceptionMessage :=    'Account attribute(s) are incomplete.'
			     || ' Account: '  || iBuId || ' - ' || GetAccName (iBuId)
			     || ', Details: ' || REPLACE (translate (lCMMessage, CHR(13)||CHR(10), '  '), '  ')  -- remove any embedded CR & LF and any subsequent double spacing
			     ;
	oLinkedIdRef      := iHMbrId;
	oLinkedTable      := gkHierarchyMbr;
	oAsAtDate         := iDateValFrom;
	GOTO eexit;

    END IF;

    -- ensure that the BP bill currency covers the validation period
    BEGIN
	SELECT 1
	INTO   lFlag
	FROM   (
		SELECT MIN (datestart)                AS datestart
		      ,MAX (NVL (dateend, gMaxDate))  AS dateend
		FROM   hmbrproperty
		WHERE  hmbrid      =  iHMbrId
		AND    propertykey =  'BILCUR'
		AND    propvalchar IS NOT NULL
		AND    datestart   <= iDateValTo
		AND    (   dateend IS NULL
			OR dateend >= iDateValFrom)
	       )
	WHERE  datestart <= iDateValFrom
	AND    dateend   >= iDateValTo;

    EXCEPTION
	WHEN no_data_found THEN
	    oUsageErrorCode   := 'RE026';
	    oExceptionMessage :=    'Account Bill Currency is missing.'
				 || ' Account: ' || iBuId || ' - ' || GetAccName (iBuId)
				 || ', Date: '   || iDateValFrom;
	    oLinkedIdRef      := iHMbrId;
	    oLinkedTable      := gkHierarchyMbr;
	    oAsAtDate         := iDateValFrom;
	    GOTO eexit;
    END;

    -- review inventory configuration
    laInventory := laInventoryNULL;
    OPEN cInventory (
	     ihmbrid
	    ,iDateValFrom
	    ,iDateValTo
	    );
    FETCH cInventory
      BULK COLLECT
      INTO laInventory;
    CLOSE cInventory;

    FOR i IN 1 .. laInventory.count LOOP

	-- exception management
	laVariableList(1).Name  := 'laInventory(i).InventoryId';
	laVariableList(1).Value := anydata.ConvertNumber (laInventory(i).InventoryId);
	laVariableList(2).Name  := 'laInventory(i).ProductCode';
	laVariableList(2).Value := anydata.ConvertVarchar2 (laInventory(i).ProductCode);
	laVariableList(3).Name  := 'laInventory(i).Phrase';
	laVariableList(3).Value := anydata.ConvertVarchar2 (laInventory(i).phrase);

	lInventoryDescr         := laInventory(i).ProductCode || ' - ' || laInventory(i).phrase || ' [' || laInventory(i).InventoryId || ']';

	IF laInventory(i).invcompleteflg <> 'Y' THEN
	    oUsageErrorCode   := 'RE027';
	    oExceptionMessage :=    'Inventory attribute(s) are incomplete.'
				 || ' Account: '    || iBuId || ' - ' || GetAccName (iBuId)
				 || ', Inventory: ' || lInventoryDescr
				 || CASE
					WHEN iDateValTo = iDateValFrom THEN
				    ', Date: '      || iDateValFrom
					ELSE
				    ', Date from: ' || iDateValFrom
				 || ' to: '         || iDateValTo
				    END;
	    oLinkedIdRef      := iHMbrId;
	    oLinkedTable      := gkHierarchyMbr;
	    oAsAtDate         := iDateValFrom;
	    GOTO eexit;

	END IF;

	-- get the bill currency
	FOR r
	  IN cBillCurrency (
	      iHMbrId
	     ,iDateValFrom
	     ,iDateValTo
	     ) LOOP
	    lBillCurr := r.propvalchar;
	    EXIT;
	END LOOP;

	-- get productrate data
	lDateFrom := GREATEST (laInventory(i).dateActive, iDateValFrom);
	lDateTo   := LEAST (NVL (laInventory(i).dateDeActive, gMaxDate), iDateValTo);

	lrc :=
	    pkg_inv.PriceHistArr
		(laInventory(i).inventoryid
		,lDateFrom
		,lDateTo
		,lBillCurr
		,AnR
		,nAnR
		,BnR
		,nBnR
		,loMsg);

	-- deal with an error returned by pkg_inv.PriceHistArr
	IF lrc != pkg_k.RC_OK THEN
	    oUsageErrorCode   := 'RE027';
	    oExceptionMessage :=    'An error occured while retrieving price data.'
				 || ' Account: '    || iBuId || ' - ' || GetAccName (iBuId)
				 || ', Inventory: ' || lInventoryDescr
				 || CASE
					WHEN lDateTo = lDateFrom THEN
				    ', Date: '      || lDateFrom
					ELSE
				    ', Date from: ' || lDateFrom
				 || ' to: '         || lDateTo
				    END
				 || ', Detail: '    || loMsg;
	    oLinkedIdRef      := iHMbrId;
	    oLinkedTable      := gkHierarchyMbr;
	    oAsAtDate         := lDateFrom;
	    GOTO eexit;

	END IF;

	-- ensure that the inventory has a rate
	IF nBnR < 1 THEN
	    oUsageErrorCode   := 'RE027';
	    oExceptionMessage :=    'Inventory item does not have a price.'
				 || ' Account: '    || iBuId || ' - ' || GetAccName (iBuId)
				 || ', Inventory: ' || lInventoryDescr
				 || CASE
					WHEN lDateTo = lDateFrom THEN
				    ', Date: '      || lDateFrom
					ELSE
				    ', Date from: ' || lDateFrom
				 || ' to: '         || lDateTo
				    END;
	    oLinkedIdRef      := iHMbrId;
	    oLinkedTable      := gkHierarchyMbr;
	    oAsAtDate         := lDateFrom;
	    GOTO eexit;

	END IF;

	-- process productrate data according to price type i.e. rating plan or unit price
	FOR j IN 1 .. nBnR LOOP

	    -- debug
	    --dbms_output.put      (laInven(i).hmbrid      || '|');
	    --dbms_output.put      (laInven(i).inventoryid || '|');
	    --dbms_output.put      (bnR(j).ProductRateID   || '|');
	    --dbms_output.put      (bnR(j).ActiveDate      || '|');
	    --dbms_output.put      (bnR(j).DeActiveDate    || '|');
	    --dbms_output.put      (bnR(j).UnitPrice       || '|');
	    --dbms_output.put      (bnR(j).RatingPeriodID  || '|');
	    --dbms_output.put      (bnR(j).RatingPlanID    || '|');
	    --dbms_output.put      (bnR(j).Charge          || '|');
	    --dbms_output.put      (bnR(j).ChargeBase      || '|');
	    --dbms_output.put_line (bnR(j).LEVEL           || '|');
	    -- bnR(i).Used   not initialised
	    -- end debug

	    -- inventory item has a unit price.  this is not expected for usage and demand inventory
	    IF bnR(j).RatingPlanID IS NULL THEN
		oUsageErrorCode   := 'RE027';
		oExceptionMessage :=    'Inventory has a unit price when a rating plan is expected.'
				     || ' Account: '    || iBuId || ' - ' || GetAccName (iBuId)
				     || ', Inventory: ' || lInventoryDescr
				     || CASE
					    WHEN lDateTo = lDateFrom THEN
					', Date: '      || lDateFrom
					    ELSE
					', Date from: ' || lDateFrom
				     || ' to: '         || lDateTo
					END;
		oLinkedIdRef      := iHMbrId;
		oLinkedTable      := gkHierarchyMbr;
		oAsAtDate         := lDateFrom;
		GOTO eexit;

	    -- inventory item uses a rating plan
	    ELSE
		-- get some rating plan attributes
		--lrRPlan := NULL;
		lrRPlan_descr   := NULL;
		lrRPlan_consu   := NULL;
		lrRPlan_demdu   := NULL;
		lrRPlan_tisetid := NULL;

		lDateFrom := GREATEST (laInventory(i).dateActive, iDateValFrom);
		lDateTo   := LEAST (NVL (laInventory(i).dateDeActive, gMaxDate), iDateValTo);

		OPEN cRPlan (
		    bnR(j).RatingPlanID
		   ,lDateFrom
		   ,lDateTo
		   );
		FETCH cRPlan
		  BULK COLLECT
		  INTO laRPlan;
		CLOSE cRPlan;

		FOR k IN 1 .. laRPlan.count LOOP
		    lrRPlan_descr := laRPlan(k).descr;
		    CASE laRPlan(k).propertykey
			WHEN 'CONSU' THEN
			    lrRPlan_Consu   := laRPlan(k).propvalchar;
			WHEN 'DEMDU' THEN
			    lrRPlan_Demdu   := laRPlan(k).propvalchar;
			WHEN 'TISET' THEN
			    lrRPlan_TisetId := laRPlan(k).propvalnumber;
			ELSE
			    raise_application_error (-20100, 'Unexpected rating plan property key [' || laRPlan(k).propertykey || ']');
		    END CASE;
		END LOOP;

		-- exception management
		laVariableList(4).Name  := 'bnR(j).RatingPlanID';
		laVariableList(4).Value := anydata.ConvertNumber (bnR(j).RatingPlanID);
		laVariableList(5).Name  := 'lrRPlan_descr';
		laVariableList(5).Value := anydata.ConvertVarchar2 (lrRPlan_descr);

		lRatingPlanDescr        := lrRPlan_descr || ' [' || bnR(j).RatingPlanID || ']';
		IF lrRPlan_tisetid IS NOT NULL THEN
		    lRPTimesetId := lrRPlan_TisetId;
		END IF;

		IF laInventory(i).ChargeType LIKE 'U%' THEN

		    IF laInventory(i).ChargeType LIKE '%D' THEN
		    -- demand rating plan

			--IF lrRPlan.demdu IS NULL THEN
			IF lrRPlan_demdu IS NULL THEN
			    oUsageErrorCode   := 'RE177';
			    oExceptionMessage :=    'Cannot determine Rating Plan Demand Units.'
						 || ' Account: '      || iBuId || ' - ' || GetAccName (iBuId)
						 || ', Inventory: '   || lInventoryDescr
						 || CASE
							WHEN lDateTo = lDateFrom THEN
						    ', Date: '        || lDateFrom
							ELSE
						    ', Date from: '   || lDateFrom
						 || ' to: '           || lDateTo
						    END
						 || ', Rating Plan: ' || lRatingPlanDescr;
			    oLinkedIdRef      := iHMbrId;
			    oLinkedTable      := gkHierarchyMbr;
			    oAsAtDate         := lDateFrom;
			    GOTO eexit;

			END IF;  -- lrRPlan.demdu IS NULL

		    ELSE
		    -- usage rating plan

			--IF lrRPlan.consu IS NULL THEN
			IF lrRPlan_consu IS NULL THEN
			    oUsageErrorCode   := 'RE037';
			    oExceptionMessage :=    'Cannot determine Rating Plan Consumption Units.'
						 || ' Account: '      || iBuId || ' - ' || GetAccName (iBuId)
						 || ', Inventory: '   || lInventoryDescr
						 || CASE
							WHEN lDateTo = lDateFrom THEN
						    ', Date: '        || lDateFrom
							ELSE
						    ', Date from: '   || lDateFrom
						 || ' to: '           || lDateTo
						    END
						 || ', Rating Plan: ' || lRatingPlanDescr;
			    oLinkedIdRef      := iHMbrId;
			    oLinkedTable      := gkHierarchyMbr;
			    oAsAtDate         := lDateFrom;
			    GOTO eexit;

			END IF;  -- lrRPlan.consu IS NULL

		    END IF;  -- LIKE '%D'

		END IF;  -- LIKE 'U%'

		lDateFrom := GREATEST (laInventory(i).dateActive, iDateValFrom);
		lDateTo   := LEAST (NVL (laInventory(i).dateDeActive, gMaxDate), iDateValTo);

		-- get rate timebands
		OPEN cRate (
		    bnR(j).RatingPlanID
		   ,lDateFrom
		   ,lDateTo
		   );
		FETCH cRate
		  BULK COLLECT
		  INTO laRate;
		CLOSE cRate;

		IF laRate.count < 1 THEN
		    oUsageErrorCode   := 'RE031';
		    oExceptionMessage :=    'Rating plan does not have a rate.'
					 || ' Account: '      || iBuId || ' - ' || GetAccName (iBuId)
					 || ', Inventory: '   || lInventoryDescr
					 || CASE
						WHEN lDateTo = lDateFrom THEN
					    ', Date: '        || lDateFrom
						ELSE
					    ', Date from: '   || lDateFrom
					 || ' to: '           || lDateTo
					    END
					 || ', Rating Plan: ' || lRatingPlanDescr;
		    oLinkedIdRef      := iHMbrId;
		    oLinkedTable      := gkHierarchyMbr;
		    oAsAtDate         := lDateFrom;
		    GOTO eexit;

		END IF;

		-- create a list of time bands that are available for billing consumption / demand
		FOR k IN 1 .. laRate.COUNT LOOP

		    -- exception management
		    laVariableList(6).Name  := 'ETimeChargeId';
		    laVariableList(6).Value := anydata.ConvertNumber (laRate(k).etimechargeid);

		    IF    laRate(k).TimeBandId IS NULL THEN
			lNULLRPTimeband                      := TRUE;
		    ELSIF NOT laTimebandId.EXISTS(laRate(k).TimebandId) THEN
			laTimebandId(laRate(k).TimebandId)   := 0;
		    END IF;

		    -- allow for time band mapping
		    IF  laRate(k).SpTimeBandId                          IS NOT NULL
		    AND NOT laTimebandId.EXISTS(laRate(k).SpTimeBandId)             THEN
			laTimebandId(laRate(k).SpTimebandId) := 0;
		    END IF;

		END LOOP;  -- Rate

		-- exception management
		IF laVariableList.EXISTS(6) THEN
		    laVariableList.DELETE(6);
		END IF;

	    END IF;  -- IF bnR(j).RatingPlanID IS NULL

	    -- exception management
	    laVariableList.DELETE(4);
	    laVariableList.DELETE(5);

	END LOOP;  -- FOR j IN 1 .. nBnR

	-- exception management
	laVariableList.DELETE(1);
	laVariableList.DELETE(2);
	laVariableList.DELETE(3);

    END LOOP;  -- FOR i IN 1 .. laInventory.count

    -- get supplypoint information for reading registers that are used for billing
    OPEN cSPRegister (
	lSiteSpId
       ,iDateValFrom
       ,iDateValTo
       );
    FETCH cSPRegister
      BULK COLLECT
      INTO laSPRegister;
    CLOSE cSPRegister;

    -- check that the meters / registers can be mapped to the 'retail' rating plan
    FOR i IN 1 .. laSPRegister.COUNT LOOP

	IF  lRPTimesetId          IS NOT NULL
	AND laSPRegister(i).RPDay IS NOT NULL THEN  -- timeset should provide 24 * 7 coverage for an interval meter / register
	    EXIT;
	END IF;

	IF laSPRegister(i).TimebandId IS NULL THEN
	    IF lNULLRPTimeband THEN
		--lNULLSpTimeband := TRUE;
		EXIT;
	    END IF;

	ELSIF laTimebandId.EXISTS(laSPRegister(i).TimebandId) THEN
	    --laSpTimebandId(laSPRegister(i).TimebandId) := 0;
	    EXIT;

	END IF;

	-- report exception
	oUsageErrorCode   := 'RE031';

	OPEN cSpKeyData (
		 laSPRegister(i).supplypointid
		,iDateValFrom
		,iDateValTo
		);
	FETCH cSpKeyData
	  BULK COLLECT
	  INTO laSpKeyData;
	CLOSE cSpKeyData;

	FOR j IN 1 .. laSpKeyData.COUNT LOOP  -- cursor is ordered by site to register
	    CASE j
		WHEN 1 THEN
		    lSPDescr := laSpKeyData(j).KeyData;
		ELSE
		    lSPDescr := lSPDescr || ', ' || laSpKeyData(j).KeyData;
	    END CASE;
	END LOOP;
	oExceptionMessage :=    'Failed to find rate for meter / register.'
			     || ' Account: '    || iBuId || ' - ' || GetAccName (iBuId)
			     || ', '            || lSPDescr
			     || CASE
				    WHEN iDateValTo = iDateValFrom THEN
				', Date: '      || iDateValFrom
				    ELSE
				', Date from: ' || iDateValFrom
			     || ' to: '         || iDateValTo
				END;

	oLinkedIdRef      := laSPRegister(i).supplypointid;
	oLinkedTable      := gkSupplypoint;
	oAsAtDate         := iDateValFrom;
	GOTO eexit;

    END LOOP;  -- FOR i IN 1 .. laTimeband.count

/*
    -- report any error that was found
    IF oUsageErrorCode IS NOT NULL THEN
	OPEN cSpKeyData (
		 oLinkedIdRef
		,iDateValFrom
		,iDateValTo
		);
	FETCH cSpKeyData
	  BULK COLLECT
	  INTO laSpKeyData;
	CLOSE cSpKeyData;

	FOR i IN 1 .. laSpKeyData.COUNT LOOP  -- cursor is ordered by site to register
	    CASE i
		WHEN 1 THEN
		    lSPDescr := laSpKeyData(i).KeyData;
		ELSE
		    lSPDescr := lSPDescr || ', ' || laSpKeyData(i).KeyData;
	    END CASE;
	END LOOP;

	oExceptionMessage :=    'Failed to find rate for meter / register.'
			     || ' Account: '        || iBuId || ' - ' || GetAccName (iBuId)
			     || ', '                   || lSPDescr
			     || CASE
				    WHEN iDateValTo = iDateValFrom THEN
				', Date: '             || iDateValFrom
				    ELSE
				', Date from: '        || iDateValFrom
			     || ' to: '                || iDateValTo
				END;
	oLinkedTable      := gkSupplypoint;
	oAsAtDate         := iDateValFrom;
	GOTO eexit;

    END IF;

    -- check that the timesets are supported by the registers
    IF lNULLSpTimeband THEN  -- all rp timebands are supported by the meter / register
	NULL;

    ELSE
	lTimebandId := laTimebandId.FIRST;  -- the index is the TimebandId

	FOR i IN 1 .. laTimebandId.COUNT LOOP

	    IF  laTimebandId(lTimebandId)              > 0      -- greater than indicates a 'required' timeband i.e. it is part of a timeset
	    AND NOT laSpTimebandId.EXISTS(lTimebandId)     THEN

		lTimeSetId        := laTimebandId(lTimebandId);

		oUsageErrorCode := 'RE031';
		oLinkedIdRef      := iHmbrId;
		oExceptionMessage :=    'Failed to find meter/register for timeset.'
				     || ' Account: '   || iBuId || ' - ' || GetAccName (iBuId)
				     || ', Inventory: '   || laTimesetInventory(lTimeSetId).lInvenDescr
				     || CASE
					    WHEN iDateValTo = iDateValFrom THEN
					', Date: '        || iDateValFrom
					    ELSE
					', Date from: '   || iDateValFrom
				     || ' to: '           || iDateValTo
					END
				     || ', Rating Plan: ' || laTimesetInventory(lTimeSetId).lRPDescr
				     || ', Timeset: '     || gaTimesetDescr(lTimeSetId)
				     || ', Timeband: '    || gaTimebandDescr(lTimebandId);
		oLinkedTable      := gkHierarchyMbr;
		oAsAtDate         := iDateValFrom;
		GOTO eexit;

	    END IF;

	    lTimebandId := laTimebandId.NEXT(lTimebandId);

	END LOOP;  -- FOR i IN 1 .. laTimeband.count

    END IF;  -- lNULLSpTimeband
*/
<<eexit>>
    NULL;

EXCEPTION
    WHEN OTHERS THEN
	pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	RAISE;

END ValidateHMbr;
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- ValidateHMbr
----------------------------------------------------------------------------------------
-- Pre billing account validation for a single account
-- #usage   Call with billing point hmbrid and a flag to indicate if the
-- #usage   current exception for the account should be updated / deleted
-- #usage   Example
-- <code>
--    <br>
--       pkg_AMI_AccountValidation.ValidateHMbr (
--           iHmbrId             INPUT  billing point hmbrid
--           iSaveException      INPUT  flag to indicate that a new exception should be saved
--                                      ** NOTE ** This proc does not delete existing exception(s)
--                                                 This proc should be wrapped in a driving proc like Reprocess or DoWork
--                                                 and existing exceptions deleted first in that proc if required
--           iDBMSOutput         INPUT  VARCHAR2
--          ,oExceptionMessage   OUT    details of any exception found
--          ,oLinkedTable        OUT    table considered as root reference for the error
--          ,oLinkedIdRef        OUT    id of row in table that is considered as root reference for the error
--          ,oUsageErrorCode     OUT    usage error code for the error
--          );
-- </code>
-- #author  ZEDH01
-- #Created 29/Jan/10 2:53:19 PM
-- #return  varchar2
-------------------------------------------------------------------------------------------------
PROCEDURE ValidateHMbr (
    iHmbrId                        IN  hierarchymbr.hmbrid%TYPE
   ,iSaveException                 IN  VARCHAR2
   ,iDBMSOutput                    IN  VARCHAR2
   ,oExceptionMessage              OUT exceptionevent.exceptionmessage%TYPE
   ,oLinkedTable                   OUT exceptionevent.linkedtable%TYPE
   ,oLinkedIdRef                   OUT exceptionevent.linkedidref%TYPE
   ,oUsageErrorCode                OUT usageerrorexceptiontype.usageerrorcode%TYPE
   ,oAsAtDate                      OUT exceptionevent.timestamp%TYPE
   )
IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'ValidateHMbr[2]';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    CURSOR cBP (
	iToday                         DATE
       ,iHmbrId                        hierarchymbr.hmbrid%TYPE
       ) IS
	SELECT hm2.hmbrid
	      ,buid
	      ,datestart
	      ,dateend
	      ,hid
	      ,completeflg
	      ,dateto
	      ,asatdate
	      ,psid
	FROM   (
		SELECT hm.hmbrid
		      ,hm.buid
		      ,hm.datestart
		      ,hm.dateend
		      ,hm.hid
		      ,hm.completeflg
		      ,hm.psid
		      ,bgrp.propvalnumber AS billinggroupid
		      ,MIN (brc.rundate)  AS rundate
		      ,MAX (i.dateto)     AS dateto
		FROM   hierarchymbr hm
		JOIN   hmbrproperty bgrp      ON  bgrp.hmbrid        =  hm.hmbrid
					      AND bgrp.propertykey   =  'BGRP'
		LEFT JOIN billruncalendar brc ON  brc.billinggroupid =  bgrp.propvalnumber
					      AND brc.rundate        >  iToday
					      AND brc.brcaltype      =  'R'
		LEFT JOIN invoice i           ON  i.hmbrid           =  hm.hmbrid
					      AND i.invoicestatus    <> 'W'    -- IN ('D', 'H', 'C', 'F', 'WO')
		WHERE  hm.hmbrid = iHmbrId
		GROUP BY hm.hmbrid
			,hm.buid
			,hm.datestart
			,hm.dateend
			,hm.hid
			,hm.completeflg
			,hm.psid
			,bgrp.propvalnumber
	       ) hm2
	LEFT JOIN billruncalendar brc2 ON  brc2.billinggroupid = hm2.billinggroupid
				       AND brc2.rundate        = hm2.rundate
				       AND brc2.brcaltype      = 'R';

    lrBP                           cBP%ROWTYPE;

    lDateFrom                      DATE;
    lDateTo                        DATE;

    lSaveException                 VARCHAR2(05) := UPPER (SUBSTR (iSaveException, 1, 1));
    lDBMSOutput                    VARCHAR2(05) := UPPER (SUBSTR (iDBMSOutput,    1, 1));

    lExceptionEventId              exceptionevent.exceptioneventid%TYPE;

BEGIN  -- ValidateHMbr
    laParamList(01).Name  := 'iHmbrId';
    laParamList(01).Value := anydata.ConvertVarchar2 (iHmbrId);

    -- get some billing point data
    OPEN cBP (
	pkg_calc.Today
       ,iHMbrId
       );
    FETCH cBP
      INTO lrBP;
    CLOSE cBP;

    -- set the validation date range
    lDateFrom := NVL (lrBP.dateto + 1, lrBP.datestart);
    lDateTo   := NVL (lrBP.dateto + 1, NVL (lrBP.asatdate, lDateFrom));

    -- invoke validation
    ValidateHmbr (
	iHmbrId           => iHmbrId
       ,iBuid             => lrBP.buid
       ,iDateStart        => lrBP.datestart
       ,iDateEnd          => lrBP.dateend
       ,iCompleteFlg      => lrBP.Completeflg
       ,iHMbrPsId         => lrBP.psid
       ,iDateBilledTo     => lrBP.dateto
       ,iDateValFrom      => lDateFrom
       ,iDateValTo        => lDateTo
       ,oUsageErrorCode   => oUsageErrorCode
       ,oExceptionMessage => oExceptionMessage
       ,oLinkedTable      => oLinkedTable
       ,oLinkedIdRef      => oLinkedIdRef
       ,oAsAtDate         => oAsAtDate
       );

    IF  oUsageErrorCode IS NOT NULL
    AND lSaveException  =  'Y'      THEN
	StackException  (-- note:  this calls SaveException for every n rows stacked
	    oUsageErrorCode
	   ,oExceptionMessage
	   ,oLinkedTable
	   ,oLinkedIdRef
	   ,oAsAtDate
	   ,lExceptionEventId
	   );
    END IF;

    IF lDBMSOutput = 'Y' THEN
	dbms_output.put_line (gkTAB);  -- create a blank line
	dbms_output.put_line ('==  Summary  ================================================');
	dbms_output.put_line ('Account:            ' || lrBP.buid);
	dbms_output.put_line ('Date Billed To:     ' || lrBP.dateto);
	dbms_output.put_line ('Date Validate From: ' || lDateFrom);
	dbms_output.put_line ('Date Validate To:   ' || lDateTo);
	dbms_output.put_line ('Error Code:         ' || oUsageErrorCode);
	dbms_output.put_line ('Exception Message:  ' || oExceptionMessage);
	dbms_output.put_line ('Linked Table:       ' || oLinkedTable);
	dbms_output.put_line ('Linked Id Ref:      ' || oLinkedIdRef);
	dbms_output.put_line ('=============================================================');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
	pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	RAISE;

END ValidateHMbr;
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- Reprocess  - validate the accounts associated with a list of existing exception events
----------------------------------------------------------------------------------------
PROCEDURE Reprocess (
    iaExceptionEventId             IN  tanum
   ,oaExceptionEventId             OUT tanum
   ,iDBMSOutput                    IN  VARCHAR2 DEFAULT 'N'
   )
IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'Reprocess';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    CURSOR cEE (
	iaEEId                         tanum
       )
    IS
	SELECT ee.exceptioneventid
	      ,ee.timestamp
	      ,ee.linkedtable
	      ,ee.linkedidref
	      ,uet.exceptiontype
	      ,uet.usageerrorcode
	      ,CASE ee.linkedtable
		   WHEN gkHierarchyMbr THEN
		       ee.linkedidref
		   WHEN gkSupplypoint THEN
		       (
			SELECT HMbrId
			FROM   hierarchymbr
			WHERE  buid = pkg_bu.Spbuid (
					  iSupplyPointId  => ee.LinkedIdRef
					 ,iAsAtDate       => ee.Timestamp
					 ,iMostRecentFlag => 'N'
					 ,iEarliestFlag   => 'Y'
					 )
		       )
		   ELSE
		       NULL
	       END  AS hmbrid
	FROM   ExceptionEvent ee
	JOIN   UsageerrorExceptionType uet ON uet.UsageErrorExceptiontypeId = ee.UsageErrorExceptiontypeId
	WHERE  ee.ExceptionEventId
	  IN (
	      SELECT column_value
	      FROM   TABLE (iaEEId)
	     );

    TYPE taEE
      IS TABLE OF cEE%ROWTYPE
      INDEX BY    BINARY_INTEGER;

    laEE                           taEE;

    laHMbrId                       pkg_std.taNum;
    laEEUEC                        pkg_std.taPValC;
    lHMbrId                        hierarchymbr.hmbrid%TYPE;
    lExcludeExcpEvnt               VARCHAR2(100) := NVL(pkg_util.SysPropVal('EXEVNTUECD','N'),'XXXXX');

    loExceptionMessage             exceptionevent.exceptionmessage%TYPE;
    loLinkedTable                  exceptionevent.linkedtable%TYPE;
    loLinkedIdRef                  exceptionevent.linkedidref%TYPE;
    loUsageErrorCode               usageerrorexceptiontype.usageerrorcode%TYPE;
    loAsAtDate                     exceptionevent.timestamp%TYPE;

BEGIN  -- Reprocess

    IF iaExceptionEventId.Count < 1 THEN
	RETURN;
    END IF;

    -- exception management
    lExtraTxt := 'iaExceptionEventId.count=' || iaExceptionEventId.Count;
    FOR i IN 1 .. iaExceptionEventId.Count LOOP
	laParamList(01).Name  := 'iaExceptionEventId(i)';
	laParamList(01).Value := anydata.ConvertNumber(iaExceptionEventId(i));
    END LOOP;
    -- end exception management


    -- initialise global collection of all exception event ids created
    gaEEIdSave := gaEEIdSaveNULL;

    -- get details of exceptions that are to be re-processed
    OPEN cEE (iaExceptionEventId);
    FETCH cEE
      BULK COLLECT
      INTO laEE;
    CLOSE cEE;


    -- do some validation
    FOR i IN 1 .. laEE.count LOOP

	-- ensure that this is an exception that can be processed by this program
	IF laEE(i).ExceptionType <> gkBillingUET THEN
	    raise_application_error (
		-20100
	       ,   'Exception '
		|| laEE(i).ExceptionEventId
		|| ' is of type '
		|| laEE(i).ExceptionType
		|| ' and hence cannot be re-processed by Account Validation'
		);
	END IF;

	-- check the billing point hierarchy member id
	IF laEE(i).HMbrId IS NULL THEN
	    raise_application_error (
		-20100
	       ,   'Exception '
		|| laEE(i).ExceptionEventId
		|| ' can''t be linked to an account'
		);

	END IF;

	-- build list of distinct HMbrId's for processing
	laHMbrId(laEE(i).HMbrId) := NULL;
	laEEUEC(laEE(i).HMbrId) := laEE(i).UsageErrorCode;
    END LOOP;


    -- remove orginal exceptions
    FORALL i IN 1 .. iaExceptionEventId.Count
	DELETE FROM ReadingTOUError  -- cater for exceptions created by the IDE implementation converstion process
	WHERE  ExceptionEventId = iaExceptionEventId(i);

    FORALL i IN 1 .. iaExceptionEventId.Count
	DELETE FROM ExceptionEvent ee
	WHERE  ee.ExceptionEventId = iaExceptionEventId(i)
	AND    NOT EXISTS (
	       SELECT 1
	       FROM   UsageerrorExceptionType uet
	       WHERE  uet.usageerrorexceptiontypeid = ee.usageerrorexceptiontypeid
	       AND    uet.ExceptionType = 'BILLING'
	       AND    uet.usageerrorcode IN (lExcludeExcpEvnt)) ;


    -- perform account validation
    lHMbrId := laHMbrId.FIRST;
    FOR i IN 1 .. laHMbrId.COUNT LOOP

	-- invoke validation
	IF  laEEUEC(lHMbrId) NOT IN (lExcludeExcpEvnt) THEN
	ValidateHMbr (
	    iHmbrId                        => lHMbrId
	   ,iSaveException                 => 'Y'
	   ,iDBMSOutput                    => iDBMSOutput
	   ,oExceptionMessage              => loExceptionMessage
	   ,oLinkedTable                   => loLinkedTable
	   ,oLinkedIdRef                   => loLinkedIdRef
	   ,oUsageErrorCode                => loUsageErrorCode
	   ,oAsAtDate                      => loAsAtDate
	   );
	END IF;

	lHMbrId := laHMbrId.NEXT(lHMbrId);
    END LOOP;


    -- save new exceptions to the database
    SaveException;

    -- copy the exception event id's to the output collection
    oaExceptionEventId := gaEEIdSave;

EXCEPTION
    WHEN OTHERS THEN
	pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	RAISE;

END Reprocess;


----------------------------------------------------------------------------------------

-- DoWork  -- validate a list of hierachymbrs
----------------------------------------------------------------------------------------
PROCEDURE DoWork
IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'DoWork';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;              -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    -- billing points (hierchymbrs) to validated by this job
    -- include billed to date and asat date of the next billrun
    CURSOR cBP (
	iJobId                         remotejob.jobid%TYPE
       ,iToday                         DATE
       ) IS
	SELECT hm2.hmbrid
	      ,buid
	      ,datestart
	      ,dateend
	      ,hid
	      ,completeflg
	      ,psid
	      ,dateto
	      ,asatdate
	FROM   (
		SELECT hm.hmbrid
		      ,hm.buid
		      ,hm.datestart
		      ,hm.dateend
		      ,hm.hid
		      ,hm.completeflg
		      ,hm.psid
		      ,bgrp.propvalnumber AS billinggroupid
		      ,MIN (brc.rundate)  AS rundate
		      ,MAX (i.dateto)     AS dateto
		FROM   RemotejobAction ra
		JOIN   hierarchymbr hm        ON  hm.hmbrid          =  ra.PrimarykeyRef
		JOIN   hmbrproperty bgrp      ON  bgrp.hmbrid        =  hm.hmbrid
					      AND bgrp.propertykey   =  'BGRP'
		LEFT JOIN billruncalendar brc ON  brc.billinggroupid =  bgrp.propvalnumber
					      AND brc.rundate        >  iToday
					      AND brc.brcaltype      =  'R'
		LEFT JOIN invoice i           ON  i.hmbrid           =  hm.hmbrid
					      AND i.invoicestatus    <> 'W'    -- IN ('D', 'H', 'C', 'F', 'WO')
		WHERE  ra.JobId = iJobId
		GROUP BY hm.hmbrid
			,hm.buid
			,hm.datestart
			,hm.dateend
			,hm.hid
			,hm.completeflg
			,hm.psid
			,bgrp.propvalnumber
	       ) hm2
	LEFT JOIN billruncalendar brc2 ON  brc2.billinggroupid = hm2.billinggroupid
				       AND brc2.rundate        = hm2.rundate
				       AND brc2.brcaltype      = 'R';

    TYPE taBP
       IS TABLE OF cBP%ROWTYPE
       INDEX BY    BINARY_INTEGER;

    laBP                           taBP;
    laBPNULL                       taBP;

    lActionCnt                     PLS_INTEGER;
    lCnt                           PLS_INTEGER                                   := 0;
    lDateFrom                      DATE;
    lDateTo                        DATE;

    loUsageErrorCode               usageerrorexceptiontype.usageerrorcode%TYPE;
    loExceptionMessage             exceptionevent.exceptionmessage%TYPE;
    loLinkedTable                  exceptionevent.linkedtable%TYPE;
    loLinkedIdRef                  exceptionevent.linkedidref%TYPE;
    loAsAtDate                     exceptionevent.timestamp%TYPE;
    lEEId                          exceptionevent.exceptioneventid%TYPE;


BEGIN  -- DoWork
    --laParamList(01).Name  := 'iJobId';
    --laParamList(01).Value := anydata.ConvertNumber (iJobId);

    SELECT COUNT(1)
    INTO   lActionCnt
    FROM   Remotejobaction
    WHERE  jobid = gJobId;

    -- get billing points for this job
    OPEN cBP (
	gJobId
       ,pkg_calc.today
       );

    LOOP
	-- initialise cursor result structure
	laBP := laBPNULL;

	-- get billing points (hmbrid's)
	FETCH cBP
	  BULK COLLECT
	  INTO laBP
	  LIMIT 100;

	EXIT WHEN laBP.count < 1;

	-- process a block of billing points
	FOR i IN 1 .. laBP.count LOOP
	    lCnt            := lCnt + 1;
	    lProcCheckPoint := 'About to process HMbrId: ' || laBP(i).hmbrid || ' with DateStart: ' || laBP(i).datestart;

	    -- get the site supplypoint for the billto date + 1 day
	    -- where the billing point has never been billed, look for any site
	    --   between the start date and the billing calendar asat date
	    lDateFrom       := NVL (laBP(i).dateto + 1, laBP(i).datestart);
	    lDateTo         := NVL (laBP(i).dateto + 1, laBP(i).asatdate);

	    ValidateHmbr (
		iHmbrId           => laBP(i).hmbrid
	       ,iBuid             => laBP(i).buid
	       ,iDateStart        => laBP(i).datestart
	       ,iDateEnd          => laBP(i).dateend
	       ,iCompleteFlg      => laBP(i).completeflg
	       ,iHMbrPsId         => laBP(i).psid
	       ,iDateBilledTo     => laBP(i).dateto
	       ,iDateValFrom      => lDateFrom
	       ,iDateValTo        => lDateTo
	       ,oUsageErrorCode   => loUsageErrorCode
	       ,oExceptionMessage => loExceptionMessage
	       ,oLinkedTable      => loLinkedTable
	       ,oLinkedIdRef      => loLinkedIdRef
	       ,oAsAtDate         => loAsAtDate
	       );

	    IF loUsageErrorCode IS NOT NULL THEN
		StackException (
		    loUsageErrorCode
		   ,loExceptionMessage
		   ,loLinkedTable
		   ,loLinkedIdRef
		   ,loAsAtDate
		   ,lEEId
		   );
	    END IF;

	END LOOP;

    END LOOP;

    CLOSE cBP;

    -- Save the last block of exceptions to the database
    SaveException;

    dbms_output.put_line (gkTAB);
    dbms_output.put_line ('RemoteJobAction HMbrId Count: '  || lActionCnt);
    dbms_output.put_line ('HMbrId''s Selected:            ' || to_char (lCnt - gAccSkipCnt));
    dbms_output.put_line ('HMBrId''s Skipped:             ' || gAccSkipCnt);
    dbms_output.put_line ('Exceptions Created:           '  || gaEEIdSave.COUNT);

EXCEPTION
    WHEN OTHERS THEN
	pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	RAISE;

END DoWork;
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- LoadToDo  -- build lists of hierarchy mbrs for bulk validation
----------------------------------------------------------------------------------------
PROCEDURE LoadWork (
    iProcAll                       VARCHAR2
   )
IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'LoadWork';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;              -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    kActionCode                    CONSTANT remotejobaction.actioncode%TYPE := 'ACVAL';

    laJobId                        tanum                                    := tanum();
    lToday                         DATE                                     := pkg_calc.today;
    lEventBillLeadDays             reportproperty.propvalnumber%TYPE;
    lCalBillLeadDays               reportproperty.propvalnumber%TYPE;
    lNumChildProcs                 reportproperty.propvalnumber%TYPE;
    lReportId                      reportrun.reportid%TYPE;
    lRRPSId                        reportrun.psid%TYPE;
    laExitCode                     pkg_std.taFloat;
    laCmdStatus                    pkg_std.taCode;
    lExitCode                      remotejob.exitcode%TYPE;
    lRRIdChild                     Reportrun.Reportrunid%TYPE;

    lEventDateMax                  DATE;
    lCalDateMax                    DATE;
    lRowCnt                        PLS_INTEGER;

BEGIN  -- LoadWork
    laParamList(01).Name  := 'iProcAll';
    laParamList(01).Value := anydata.ConvertVarchar2 (iProcAll);

    -- get the number of validation slaves to be used and create an array of jobids
    -- get the lead days for event billing checking and calendar checking
    FOR r IN (
	SELECT propertykey
	      ,propvalnumber
	      ,rp.reportid
	      ,psid
	FROM   reportrun rr
	JOIN   reportproperty rp ON rp.reportid = rr.reportid
	WHERE  jobid = gJobId
       ) LOOP

	CASE r.propertykey
	    WHEN 'EVBLLD'  THEN lEventBillLeadDays := r.propvalnumber;
	    WHEN 'CALBLLD' THEN lCalBillLeadDays   := r.propvalnumber;
	    WHEN 'NUMPROC' THEN lNumChildProcs     := r.propvalnumber;
	    ELSE NULL;
	END CASE;

	lReportId := r.reportid;
	lRRPsid   := r.psid;

    END LOOP;

    -- get the billing points to be processed and insert into remotejobaction table
    --   remove existing BILLING exception events
    DELETE FROM ExceptionEvent ev
    WHERE  UsageErrorExceptionTypeId
      IN (
	  SELECT UsageErrorExceptionTypeId
	  FROM   UsageErrorExceptionType
	  WHERE  ExceptionType = 'BILLING'
	  AND    usageerrorcode NOT IN (NVL(pkg_util.SysPropVal('EXEVNTUECD','N'),'XXXXX'))
	 )
    AND NOT EXISTS (-- this was added because the IDE (AMI) conversion process created some 'billing' exception
	SELECT 1    -- events with links to the readingtouerror.  this package doesnt create such entries
	FROM   readingtouerror rte
	WHERE  rte.exceptioneventid = ev.exceptioneventid
       );

    --   remove old Account Validation entries
    DELETE FROM RemoteJobAction
    WHERE  ActionCode = 'ACVAL';


    --   generate the child Remotejob and ReportRun entries that will do the validation
    lajobid.extend(lNumChildProcs);
    FOR i IN 1 .. lNumChildProcs LOOP
	INSERT INTO remotejob
	  (submitby
	  ,jobcmdline
	  ,jobdescr
	  ,parentjobid
	  ,jobtype
	  )
	VALUES
	  (gUserId
	  ,'AccountValidation.sh -e $HUB_SID'
	  ,'Pre Billing Account Validation - Child Job ' || i || ' of ' || lNumChildProcs
	  ,gJobId
	  ,'B'
	  )
	RETURNING jobid
	INTO      lajobid(i);

	INSERT INTO ReportRun
	  (UserId
	  ,JobId
	  ,ReportId
	  ,PSId
	  )
	VALUES
	  (gUserId
	  ,lajobid(i)
	  ,lReportId
	  ,lRRPSId
	  )
	RETURNING ReportRunId
	INTO      lRRIdChild;

	-- add the parent job id to the child report run parameter values
	-- to make this package do child processing
	UPDATE RRProperty
	SET    propvalnumber = gJobId
	WHERE  ReportRunId = lRRIdChild
	AND    PropertyKey = 'PJOBID';

    END LOOP;

    --  select and insert into the action table, the accounts to be validated
    IF NVL (iProcAll, 'N') = 'Y' THEN
	INSERT INTO remotejobaction
	    (jobid
	    ,primarykeyref
	    ,linkedtable
	    ,actioncode
	    )
	WITH valjob
	  AS (
	      SELECT rownum       AS JobIndex
		    ,column_value AS JobId
	      FROM   TABLE (lajobid)
	     )
	SELECT v.jobid
	      ,h.hmbrid
	      ,gkHierarchyMbr
	      ,kActionCode
	FROM   (-- select all accounts that have a scheduled billrun somewhere in the future
		SELECT hm.hmbrid
		      ,MOD (rownum, lNumChildProcs) + 1 AS JobIndex
		FROM   hierarchymbr hm
		JOIN   hmbrproperty bgrp ON  bgrp.hmbrid       = hm.hmbrid
					 AND bgrp.propertykey  = 'BGRP'
		JOIN   billinggroup bg   ON  bg.billinggroupid = bgrp.propvalnumber
		WHERE  hm.hmbrtype   =  'BP'
		AND    hm.parentbuid IS NOT NULL
		AND    bg.bgtype     =  'BILL'
		AND    bg.bgstatus   =  'A'
		AND EXISTS (
		    SELECT 1
		    FROM   billruncalendar brc
		    WHERE  brc.billinggroupid = bg.billinggroupid
		    AND    brc.rundate        > lToday
		    AND    brc.brcaltype      = 'R'
		   )
	       ) h
	JOIN   valjob v ON v.JobIndex = h.JobIndex;

	lRowCnt := SQL%ROWCOUNT;

    ELSE
	lEventDateMax := lToday + lEventBillLeadDays;  -- event billed
	lCalDateMax   := lToday + lCalBillLeadDays;    -- calendar billed

	INSERT INTO remotejobaction
	    (jobid
	    ,primarykeyref
	    ,linkedtable
	    ,actioncode
	    )
	WITH valjob
	  AS (-- distribute accounts across child validation jobs
	      SELECT rownum       AS JobIndex
		    ,column_value AS JobId
	      FROM   TABLE (lajobid)
	     )
	SELECT v.jobid
	      ,h.hmbrid
	      ,gkHierarchyMbr
	      ,kActionCode
	FROM   (-- select only accounts that are due to be billed in the 'near' future
		SELECT bgrp.hmbrid
		      ,MOD (rownum, lNumChildProcs) + 1 AS jobindex
		FROM   billruncalendar brc
		JOIN   billinggroup bg     ON  bg.billinggroupid    = brc.billinggroupid
		JOIN   bgproperty ewday    ON  ewday.billinggroupid = brc.billinggroupid
					   AND ewday.propertykey    = 'EWDAY'
		JOIN   hmbrproperty bgrp   ON  bgrp.propvalnumber   = bg.billinggroupid
					   AND bgrp.propertykey     = 'BGRP'
		JOIN   hierarchymbr hm     ON  hm.hmbrid            = bgrp.hmbrid
		WHERE  (   brc.asatdate - NVL (ewday.propvalnumber, 0) <= lEventDateMax  -- event billed
			OR brc.rundate                                 <= lCalDateMax    -- calendar billed
		       )
		AND    brc.rundate   >  lToday
		AND    brc.brcaltype =  'R'
		AND    bg.bgtype     =  'BILL'
		AND    bg.bgstatus   =  'A'
		AND    hm.parentbuid IS NOT NULL  -- ignore default billing point
	       ) h
	JOIN   valjob v ON v.jobindex = h.jobindex;

	lRowCnt := SQL%ROWCOUNT;

    END IF;

    dbms_output.put_line (gkTAB);
    dbms_output.put_line ('Billing Points selected for validation: ' || lRowCnt);

    -- report account split count
    FOR r IN (
	SELECT jobid
	      ,COUNT(1) AS cnt
	FROM   remotejobaction
	WHERE  jobid
	  IN (
	      SELECT column_value
	      FROM   TABLE (lajobid)
	     )
	GROUP BY jobid
	ORDER BY jobid
       ) LOOP
	dbms_output.put_line ('JobId: ' || r.jobid || ', Count: ' || r.cnt);
    END LOOP;

    -- amend the child job start time to reflect when the remotejob
    -- row inserts are commited and hence available to jexec
    UPDATE remotejob rj
    SET    rj.execattimestamp = pkg_calc.now
    WHERE  jobid
	IN (
	    SELECT column_value
	    FROM   TABLE (lajobid)
	   );


    -- make RemoteJob and RemoteJobAction entries visible to other jmon and other sessions
    COMMIT;


    -- wait for jobs to finish
    lExitCode := pkg_job.WaitOnJob (
	iaJobId                        => laJobId
       ,oaExitCode                     => laExitCode
       ,oaCmdStatus                    => laCmdStatus
       ,iMinCompleted                  => NULL
       ,iSleepTime                     => NULL
       );

    -- exit this job (the parent) with a warning if any of the child jobs have a non zero exit code
    -- this should bubble all the way up to the schedular (CRON, Control-M etc)
    IF lExitCode <> pkg_k.RC_OK THEN
	gRc := pkg_k.RC_Warning;
	dbms_output.put_line (gkTAB);
	dbms_output.put_line ('One or more child validation jobs ended with a non zero exit code');
	dbms_output.put_line (gkTAB);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
	pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	RAISE;

END LoadWork;
----------------------------------------------------------------------------------------
-- ProcessBRQValJob  -- process a remotejob request for Bill Read Quality Validation
PROCEDURE ProcessBRQValJob (
    iJobId                         IN  remotejob.jobid%TYPE
   ,oRc                            OUT remotejob.exitcode%TYPE) IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'ProcessBRQValJob';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging

    lRc                            remotejob.exitcode%TYPE;
    lAccNbr                        hierarchymbr.buid%TYPE;
    lSaveException                 rrproperty.propvalchar%TYPE;
    lPJobId                        remotejob.parentjobid%TYPE;
    lHmbrId                        hierarchymbr.hmbrid%TYPE;
    lProcAll                       rrproperty.propvalchar%TYPE;
    loExceptionMessage             exceptionevent.exceptionmessage%TYPE;
    loLinkedTable                  exceptionevent.linkedtable%TYPE;
    loLinkedIdRef                  exceptionevent.linkedidref%TYPE;
    loUsageErrorCode               usageerrorexceptiontype.usageerrorcode%TYPE;
    loAsAtDate                     exceptionevent.timestamp%TYPE;
    lEEId                          exceptionevent.exceptioneventid%TYPE;
    lCnt                           PLS_INTEGER := 0;
    lErrCnt                        PLS_INTEGER := 0;
    lRRPSId                        reportrun.psid%TYPE;
    lReportId                      reportrun.reportid%TYPE;
    lToday                         DATE                                     := pkg_calc.today;
    lNow                           DATE                                     := pkg_calc.now;
    lEventBillLeadDays             reportproperty.propvalnumber%TYPE;
    lCalBillLeadDays               reportproperty.propvalnumber%TYPE;
    --lMsg                           VARCHAR2(1000);
    
    CURSOR cGetAcct IS
           SELECT bgrp.hmbrid, hm.buid
                FROM   billruncalendar brc
                JOIN   billinggroup bg     ON  bg.billinggroupid    = brc.billinggroupid
                JOIN   bgproperty ewday    ON  ewday.billinggroupid = brc.billinggroupid
                                           AND ewday.propertykey    = 'EWDAY'
                JOIN   hmbrproperty bgrp   ON  bgrp.propvalnumber   = bg.billinggroupid   
                                           AND bgrp.propertykey     = 'BGRP'
                JOIN   hierarchymbr hm     ON  hm.hmbrid            = bgrp.hmbrid
		       JOIN   hmbrproperty hpcontr ON hpcontr.hmbrid  = hm.hmbrid
					                             AND   hpcontr.propertykey  = 'CONST'
					                             AND   hpcontr.propvalchar = 'BILL'                 -- Billable Account Only
                                       AND   hpcontr.datestart < lNow
                                       AND  (hpcontr.dateend IS NULL OR hpcontr.dateend > lNow)
		       JOIN   hmbrproperty trtgrp  ON  trtgrp.hmbrid  = hm.hmbrid
					                             AND   trtgrp.propertykey  = 'TRTGRP'
					                             AND   trtgrp.propvalchar = 'E'
                WHERE  (   brc.asatdate - NVL (ewday.propvalnumber, 0) <= (lToday + lEventBillLeadDays)  -- event billed
                        OR brc.rundate                                 <= (lToday + lCalBillLeadDays)    -- calendar billed
                       )
                AND    brc.rundate   >  lToday
                AND    brc.brcaltype =  'R'
                AND    bg.bgtype     =  'BILL'
                AND    bg.bgstatus   =  'A'
                AND    hm.parentbuid IS NOT NULL
		       AND    NOT EXISTS (
		              SELECT 1
		              FROM   ExceptionEvent ee
		              WHERE  ee.usageerrorexceptiontypeid = gRW001UEET
		              AND    ee.linkedtable = 'HIERARCHYMBR'
		              AND    ee.linkedidref =  hm.hmbrid
		              AND    ee.processstatus = 'E');
                
BEGIN
    laParamList(01).Name  := 'iJobId';
    laParamList(01).Value := anydata.ConvertNumber (iJobId);
    
    -- set session info for remote job
    gUserId  := NVL (pkg_audit.GetUserId,pkg_util.syspropval ('BATCH_USERID', 'N'));
    pkg_util.Void (pkg_audit.SetInfo (substr ('iMe' ,30),gUserId));
    
    gJobId  := iJobId;
    
    IF  gJobId IS NULL THEN
	      raise_application_error (
	      -20100
	      ,'The Job Id is NULL.  A Job Id with associated Report Run entry is required.  Use SubmitJob to create a Remote Job.');
    END IF;
    
	  -- get report run property values
    FOR r IN (
	      SELECT propertykey
	            ,propvalnumber
	            ,propvalchar
	      FROM   reportrun rr
	      JOIN   rrproperty rrp ON rrp.reportrunid = rr.reportrunid
	      WHERE  jobid = gJobId) LOOP
        
	      CASE r.propertykey
	          WHEN 'ACCNBR'  THEN lAccNbr        := r.propvalnumber;
	          WHEN 'UPDEXCP' THEN lSaveException := r.propvalchar;
	          WHEN 'PJOBID'  THEN lPJobId        := r.propvalnumber;
	          WHEN 'PROCALL' THEN lProcAll       := r.propvalchar;
	          ELSE NULL;
	      END CASE;
    END LOOP;
    
    FOR r IN (
        SELECT propertykey
              ,propvalnumber
              ,rp.reportid
              ,psid
        FROM   reportrun rr
        JOIN   reportproperty rp ON rp.reportid = rr.reportid
        WHERE  jobid = gJobId
       ) LOOP

        CASE r.propertykey
            WHEN 'EVBLLD'  THEN lEventBillLeadDays := r.propvalnumber;
            WHEN 'CALBLLD' THEN lCalBillLeadDays   := r.propvalnumber;
            --WHEN 'NUMPROC' THEN lNumChildProcs     := r.propvalnumber;
            ELSE NULL;
        END CASE;
        
        lReportId := r.reportid;
        lRRPsid   := r.psid;

    END LOOP;
    
    lProcCheckPoint := 'SELECT RW001 UsageErrorExceptionType';

    gRW001UEET := getUsageErrExpType('BILLING', gRW001);
    
    
    gAcct.HMBRID.delete;
    gAcct.BUID.delete;
    lErrCnt := 0;
    
    IF  lAccNbr IS NOT NULL THEN
	      BEGIN
	         SELECT hmbrid
	         INTO   lHmbrid
	         FROM   hierarchymbr
	         WHERE  buid     = lAccNbr
	         AND    hmbrtype = 'BP';
           
	         gAcct.HMBRID(0) := lHmbrid;
	         lCnt := 1;
	      EXCEPTION
	         WHEN no_data_found THEN
		            raise_application_error (-20100, 'Requested account does not exist [' || lAccNbr || ']');
	      END;
    ELSE
	      OPEN cGetAcct;
	      FETCH cGetAcct BULK COLLECT INTO gAcct.HMBRID,gAcct.BUID;
	      lCnt := cGetAcct%ROWCOUNT;
	      CLOSE cGetAcct;
    END IF;
    
    IF  lCnt > 0 THEN
	      FOR i IN gAcct.HMBRID.FIRST .. gAcct.HMBRID.LAST LOOP
	          -- invoke validation of Bill Read type Quality

	          ValidateReadQlty (
			      iHmbrId           => gAcct.HMBRID(i)
			     ,iBuid             => gAcct.BUID(i)
			     ,oUsageErrorCode   => loUsageErrorCode
			     ,oExceptionMessage => loExceptionMessage
			     ,oLinkedTable      => loLinkedTable
			     ,oLinkedIdRef      => loLinkedIdRef
			     ,oAsAtDate         => loAsAtDate);
           
	          IF  loUsageErrorCode IS NOT NULL THEN
		            lErrCnt := lErrCnt + 1;
              
		            StackException (loUsageErrorCode
		                           ,loExceptionMessage
		                           ,loLinkedTable
		                           ,loLinkedIdRef
		                           ,loAsAtDate
		                           ,lEEId);
	          END IF;
	      END LOOP;
	
        -- Save the last block of exceptions to the database
	      SaveException;
    END IF;
    
    log ('');
    log ('Total Accounts selected for Bill Read Quality Validation       : '||lCnt);
    log ('Total Accounts with the missing Actual Bill Read Quality Alert : '||lErrCnt);
    
    -- Clean up the expired RW001 Warning ExceptionEvent records.
    BEGIN
        DELETE ExceptionEvent ee
        WHERE  ee.usageerrorexceptiontypeid = gRW001UEET
        AND    ee.processstatus = 'E'
        AND    ee.timestamp < gNow - gRW001ExpDays;
        
        IF  SQL%ROWCOUNT > 0 THEN
            log ('Total Expired Actual Bill Read Quality Alert deleted   : '||SQL%ROWCOUNT);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
             log ('Expired Actual Bill Read Quality Alert deletion failed : '||SQLERRM);
    END;
    -- set job exit code
    lRc := gRc;
    
    IF  gRc IS NULL THEN
	      lRc := pkg_k.RC_OK;
    END IF;
    
    oRc := lRc;
EXCEPTION
    WHEN OTHERS THEN
	       pkg_OraException.SetStack (
	       iPkgName        => gkMe
	      ,iProcName       => lMe
	      ,iProcCheckPoint => lProcCheckPoint
	      ,iAddtionalText  => lExtraTxt
	      ,iSqlCode        => SQLCODE
	      ,iSqlErrM        => SQLERRM
	      ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	      ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	      ,iParamList      => laParamList
	      ,iVariableList   => laVariableList
	      );
	
        RAISE;
END ProcessBRQValJob;

----------------------------------------------------------------------------------------
-- ProcessJob  -- process a remotejob request
----------------------------------------------------------------------------------------
PROCEDURE ProcessJob (
    iJobId                         IN  remotejob.jobid%TYPE
   ,oRc                            OUT remotejob.exitcode%TYPE
   )
IS
    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'ProcessJob';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    lRc                            remotejob.exitcode%TYPE;
    lAccNbr                        hierarchymbr.buid%TYPE;
    lSaveException                 rrproperty.propvalchar%TYPE;
    lPJobId                        remotejob.parentjobid%TYPE;
    lHmbrId                        hierarchymbr.hmbrid%TYPE;
    lProcAll                       rrproperty.propvalchar%TYPE;

    loExceptionMessage             exceptionevent.exceptionmessage%TYPE;
    loLinkedTable                  exceptionevent.linkedtable%TYPE;
    loLinkedIdRef                  exceptionevent.linkedidref%TYPE;
    loUsageErrorCode               usageerrorexceptiontype.usageerrorcode%TYPE;
    loAsAtDate                     exceptionevent.timestamp%TYPE;

BEGIN  -- ProcessJob
    laParamList(01).Name  := 'iJobId';
    laParamList(01).Value := anydata.ConvertNumber (iJobId);

    -- set session info for remote job
    gUserId  := NVL (
		    pkg_audit.GetUserId
		   ,pkg_util.syspropval ('BATCH_USERID', 'N')
		   );

    pkg_util.Void (
	pkg_audit.SetInfo (
	    substr ('iMe' ,30)
	   ,gUserId
	   )
       );

    gJobId  := iJobId;
    IF gJobId IS NULL THEN
	raise_application_error (
	    -20100
	   ,'The Job Id is NULL.  A Job Id with associated Report Run entry is required.  Use SubmitJob to create a Remote Job.'
	   );
    END IF;

    -- get report run property values
    FOR r IN (
	SELECT propertykey
	      ,propvalnumber
	      ,propvalchar
	FROM   reportrun rr
	JOIN   rrproperty rrp ON rrp.reportrunid = rr.reportrunid
	WHERE  jobid = gJobId
       ) LOOP

	CASE r.propertykey
	    WHEN 'ACCNBR'  THEN lAccNbr        := r.propvalnumber;
	    WHEN 'UPDEXCP' THEN lSaveException := r.propvalchar;
	    WHEN 'PJOBID'  THEN lPJobId        := r.propvalnumber;
	    WHEN 'PROCALL' THEN lProcAll       := r.propvalchar;
	    ELSE NULL;
	END CASE;

    END LOOP;


    -- initiate appropriate procedure
    CASE
	-- validation of a specific account has been requested
	WHEN lAccNbr IS NOT NULL THEN
	    BEGIN
		SELECT hmbrid
		INTO   lHMbrId
		FROM   hierarchymbr
		WHERE  buid     = lAccNbr
		AND    hmbrtype = 'BP';
	    EXCEPTION
		WHEN no_data_found THEN
		    raise_application_error (-20100, 'Requested account does not exist [' || lAccNbr || ']');
	    END;

	    ValidateHMbr (
		iHmbrId           => lHMbrId
	       ,iSaveException    => lSaveException
	       ,iDBMSOutput       => 'Y'
	       ,oExceptionMessage => loExceptionMessage
	       ,oLinkedTable      => loLinkedTable
	       ,oLinkedIdRef      => loLinkedIdRef
	       ,oUsageErrorCode   => loUsageErrorCode
	       ,oAsAtDate         => loAsAtDate
	       );

	    -- Save the last block of exceptions to the database
	    SaveException;

	-- this is a child validation job.  get work from the RemoteJobAction table
	WHEN lPJobId IS NOT NULL THEN
	    DoWork;

	-- this is the parent job.  populate the RemoteJobAction table, initiate child validation jobs and wait for them to complete
	ELSE
	    LoadWork (lProcAll);

    END CASE;


    -- set job exit code
    lRc := gRc;
    IF gRc IS NULL THEN
	lRc := pkg_k.RC_OK;
    END IF;
    oRc := lRc;

EXCEPTION
    WHEN OTHERS THEN
	pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	RAISE;

END ProcessJob;
----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
-- SubmitJob  -- Called from shell script to submit job
----------------------------------------------------------------------------------------
FUNCTION SubmitJob (
    iReportKey                     IN report.reportkey%TYPE       DEFAULT 'AccountValidation'
   ,iReportGroup                   IN report.reportgroupkey%TYPE  DEFAULT 'USAGEJOBS'
   ,iProcessAll                    IN VARCHAR2                    DEFAULT 'N'
   ) RETURN remotejob.jobid%TYPE
IS

    -- endable DML within a SELECT statement (the sqlplus session submitting the job)
    PRAGMA AUTONOMOUS_TRANSACTION;

    -- exception management
    lMe                            pkg_OraException.tObjectName         := 'SubmitJob';
    lProcCheckPoint                pkg_OraException.tProcCheckPoint;
    lExtraTxt                      pkg_OraException.tAdditionalText;
    lErrStack                      pkg_OraException.tFormat_error_stack;
    lCallStack                     pkg_OraException.tFormat_call_stack;
    laParamList                    pkg_OraException.taParamList;
    laVariableList                 pkg_OraException.taParamList;        -- The developer can choose to stack simple variable names and values to aid debugging
    -- end exception management

    lJobId                         remotejob.jobid%TYPE;
    lProcessAll                    VARCHAR2(05)                := UPPER (SUBSTR (iProcessAll, 1, 1));
    lRRId                          reportrun.reportrunid%TYPE;
    lJobDescr                      report.descr%TYPE;

BEGIN  -- SubmitJob
    laParamList(01).Name  := 'iReportKey';
    laParamList(01).Value := anydata.ConvertVarchar2 (iReportKey);
    laParamList(02).Name  := 'iReportGroup';
    laParamList(02).Value := anydata.ConvertVarchar2 (iReportGroup);

    -- set session info for remote job
    gUserId  := NVL (
		    pkg_audit.GetUserId
		   ,pkg_util.syspropval ('BATCH_USERID', 'N')
		   );

    pkg_util.Void (
	pkg_audit.SetInfo (
	    substr ('iMe' ,30)
	   ,gUserId
	   )
       );

    -- set up remote job and report run entries
    CASE  iReportKey
       WHEN  'AccountValidation' THEN
	           lJobDescr := 'Pre Billing Account Validation - Parent Job';
       WHEN  'BillReadQualityValidation' THEN
	           lJobDescr := 'Bill Read Quality Validation Job';
       ELSE
	           SELECT descr
	           INTO   lJobDescr
	           FROM   report
	           WHERE  reportkey = iReportKey;
    END CASE;
    
    INSERT INTO RemoteJob
      (JobId
      ,SubmitBy
      ,JobCmdLine
      ,JobType
      ,JobDescr)
    VALUES     (lJobId
      ,gUserId
      ,iReportKey || '.sh -e $HUB_SID'
      ,'B'
      ,lJobDescr)
    RETURNING JobId INTO lJobId;


    lRRId := reportrunid.nextval;
    INSERT INTO ReportRun
      (ReportRunId
      ,UserId
      ,JobId
      ,ReportId
      ,PSId
      )
    SELECT lRRId
	  ,gUserId
	  ,lJobId
	  ,ReportId
	  ,RRPSId
    FROM   Report
    WHERE  ReportKey      = iReportKey
    AND    ReportGroupKey = iReportGroup;

    IF lProcessAll = 'Y' THEN
	UPDATE RRProperty
	SET    propvalchar = 'Y'
	WHERE  ReportRunId = lRRId
	AND    PropertyKey = 'PROCALL';

    END IF;

    COMMIT;

    RETURN lJobId;

EXCEPTION
    WHEN OTHERS THEN
	pkg_OraException.SetStack (
	    iPkgName        => gkMe
	   ,iProcName       => lMe
	   ,iProcCheckPoint => lProcCheckPoint
	   ,iAddtionalText  => lExtraTxt
	   ,iSqlCode        => SQLCODE
	   ,iSqlErrM        => SQLERRM
	   ,iCallStack      => NVL (lCallStack, pkg_OraException.GetCallStack)
	   ,iErrStack       => NVL (lErrStack,  pkg_OraException.GetErrorStack)
	   ,iParamList      => laParamList
	   ,iVariableList   => laVariableList
	   );

	pkg_OraException.DumpStack;

	RAISE;

END SubmitJob;
----------------------------------------------------------------------------------------


BEGIN
    Initialise;

END pkg_AMI_AccountValidation;
/
