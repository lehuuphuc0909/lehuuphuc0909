CREATE OR REPLACE PACKAGE pkg_AMI IS
    -------------------------------------------------------------------------------------------------
    -- Readings processing for Interval Meters
    -- #usage Readings processing for Interval Meters
    -- #author ZJKN01

    -- Template: GENERIC
    --  Revision History
    -- Log (update these two when you make a change to the log)
currentRelease CONSTANT VARCHAR2(30) := '12.0';
devVersion     CONSTANT VARCHAR2(30) := '0001';
-- DevVer     Date         Author   Story       Description
-- ---------  ------------ -------- ----------- ----------------------------------------------------------------
-- 12.0.0001  04-Jun-2020  Danny Y  SEPI-19827  SEPI-24142 check to sure the billed consumption correct for WA Gas
-- 11.2.0001  21-jan-2020  EwenH    MHA-85      Daily billing (unbilled calc) - use array index instead of NEXTVAL when SaveToDB is false
-- 10.0.0001  2019-02-27   Danny Y  SEPI-15791  SEPI-16932 - Rate reduction changes to split the consumption
--
    --  When        Ref           Who           What
    --  ----------- ------------- ------------- -----------------------------------------------------------------------------
    --  09-Jul-18   SEPI-13338    EwenH         Allow for a single day echargeaccum record.
    --                                          This is required by demand calculations when inventory starts on the end of the month.
    --

-- \hubu_unix_src\main\eraus\41  Fri May 20 15:04:57 2016  zsxn20



-- \hubu_unix_src\main\eraus\hubub135067\1  Thu Apr 14 11:27:12 2016  zsxn20

--WR135067 - Accommodate the introduction of Hot Water meter type SRDH


-- \hubu_unix_src\main\eraus\40  Thu May 19 13:35:40 2016  ztxj10

--Merge


-- \hubu_unix_src\main\eraus\hubub136279\1  Mon May  9 12:46:49 2016  ztxj10

--WR136279 Removed reading count checking since it is already performed in pkg_readcomp


-- \hubu_unix_src\main\eraus\38  Thu Nov 19 09:26:35 2015  danny

--WR119768 - merge


-- \hubu_unix_src\main\eraus\hubub119768\1  Mon Mar 23 15:00:44 2015  danny

--WR119768 - Changes to Cons_Basic to handle the first usage consumptions



-- \hubu_unix_src\main\eraus\37  Thu Aug 27 10:59:00 2015  zsxn20



-- \hubu_unix_src\main\eraus\hubub127118\1  Tue Aug 25 13:08:59 2015  zsxn20

--WR127118 - Get BillReadQuality for the 270 Days missing Actual Alert


-- \hubu_unix_src\main\eraus\36  Mon Aug 24 09:45:35 2015  zsxn20



-- \hubu_unix_src\main\eraus\hubub127056\1  Fri Aug 21 13:40:38 2015  zsxn20

--WR127056 - Changes to Overall Bill Read Quality rule of the Basic Registers


-- \hubu_unix_src\main\eraus\35  Tue Aug  4 16:24:08 2015  zsxn20



-- \hubu_unix_src\main\eraus\hubub124822\5  Wed Jul 29 20:40:35 2015  zsxn20



-- \hubu_unix_src\main\eraus\hubub124822\4  Tue Jul 14 15:20:15 2015  zsxn20



-- \hubu_unix_src\main\eraus\hubub124822\3  Tue Jul 14 12:42:15 2015  zsxn20



-- \hubu_unix_src\main\eraus\hubub124822\2  Mon Jul 13 15:51:43 2015  zsxn20



-- \hubu_unix_src\main\eraus\hubub124822\1  Mon Jul 13 15:33:02 2015  zsxn20

--WR124822 - Derive Invoice Read Quality related changes


-- \hubu_unix_src\main\eraus\34  Mon Sep  8 11:20:07 2014  danny

--WR93446 - fixed merge


-- \hubu_unix_src\main\eraus\34  Mon Sep  8 09:15:07 2014  danny

--WR93446 - fixed merge


-- \hubu_unix_src\main\eraus\33  Fri Sep  5 13:01:05 2014  danny

--WR93446 - merge


-- \hubu_unix_src\main\eraus\hubub93446\2  Tue Apr  1 11:57:18 2014  danny



-- \hubu_unix_src\main\eraus\hubub93446\1  Wed Apr  3 16:43:42 2013  danny

--WR93446 - over charging issue


-- \hubu_unix_src\main\eraus\32  Mon Jul 28 10:09:23 2014  nicolac

--Merge


-- \hubu_unix_src\main\eraus\hubub112694\1  Fri Jul 25 15:21:15 2014  nicolac

--WR112694 - Accumulated Issues
--Creation of ECA Demand records will skip the consumption calculation
--Do not apply seasonality for demand


-- \hubu_unix_src\main\eraus\31  Tue Jul  8 12:28:22 2014  nicolac

--Merge


-- \hubu_unix_src\main\eraus\hubub110367\1  Thu Jul  3 16:27:32 2014  nicolac

--WR110367 - Enhancements to Billing to calculate Demand Charge

-- \hubu_unix_src\main\eraus\30  Tue Jul  1 16:42:23 2014  danny

--WR97143 - merge


-- \hubu_unix_src\main\eraus\hubub97143\2  Fri Aug 23 14:51:15 2013  danny



-- \hubu_unix_src\main\eraus\hubub97143\1  Fri Jul 12 14:26:54 2013  danny

--WR97143 - changed to split on Season boundaries


-- \hubu_unix_src\main\eraus\29  Mon Nov  4 11:44:33 2013  danny

--WR99428 - Merge


-- \hubu_unix_src\main\eraus\hubub99428\1  Fri Sep 27 11:49:55 2013  danny

--WR99428 - Monthly graphing on bills enhancement


-- \hubu_unix_src\main\eraus\28  Fri Jul  6 10:11:01 2012  ztxj10

--Merge


-- \hubu_unix_src\main\eraus\hubub80414\5  Fri Jul  6 10:09:23 2012  ztxj10

--WR80414 Fix continuous holiday issue


-- \hubu_unix_src\main\eraus\hubub80414\5  Fri Jul  6 10:08:45 2012  ztxj10

--WR80414 Fix continuous holiday issue


-- \hubu_unix_src\main\eraus\27  Tue Jun 12 08:35:59 2012  ztxj10

--Merge


-- \hubu_unix_src\main\eraus\hubub80414\4  Fri Mar 30 11:15:38 2012  ztxj10

--WR80414 SMR 75025- NSW QLD Elec - Rating plan The actual holiday timeset change


-- \hubu_unix_src\main\eraus\26  Wed Dec 21 11:45:24 2011  zixg23

--merge


-- \hubu_unix_src\main\eraus\hubub78716\1  Tue Dec 20 08:56:44 2011  zixg23

--WR78716 - put truncate around date test to ensure message: There exists no accumulated readings to aggregate


-- \hubu_unix_src\main\eraus\25  Thu Apr  7 16:23:15 2011  zixn35

--merge to ERAUS main


-- \hubu_unix_src\main\eraus\hubub71287\3  Wed Mar 30 16:12:52 2011  zixn35

--Round the end date to just before the next midnight, in case the date it is comparing to isn't the previous midnight


-- \hubu_unix_src\main\eraus\hubub71287\2  Wed Mar 30 15:48:55 2011  zixn35

--Repair a fault with the first day of an invoice period coinciding with a change of tariff  Change a couple of less/greater than to less/greater equals


-- \hubu_unix_src\main\eraus\hubub71287\1  Wed Mar 30 14:44:54 2011  zixn35

--Merge from WR71013 before making changes


-- \hubu_unix_src\main\eraus\24  Thu Apr  7 16:19:57 2011  zixn35

--merge to ERAUS main


-- \hubu_unix_src\main\eraus\hubub71013\2  Tue Mar 22 16:34:12 2011  zixn35

--Round up the latest dumb reading to just before the next midnight, to match the usual latest TOU reading  This allows us to find dumb rating plans that change or start on this final day


-- \hubu_unix_src\main\eraus\hubub71013\1  Tue Mar 22 15:33:48 2011  zixn35

--Merge from latest before making changes


-- \hubu_unix_src\main\eraus\23  Tue Mar 29 17:17:42 2011  brookep

--wr69667-merge to main SE line


-- \hubu_unix_src\main\eraus\hubub69667\5  Tue Mar 29 17:15:22 2011  brookep

--WR69667-minor improvements which will hopefully speed up performance too


-- \hubu_unix_src\main\eraus\hubub69667\4  Tue Mar 29 15:23:29 2011  brookep

--WR69667-need to also cater for customer with multiple sites


-- \hubu_unix_src\main\eraus\hubub69667\3  Mon Mar 28 16:07:53 2011  brookep

--WR69667 No, finally decided that really need to look for latest "previous reading" from the start of the current SE FRMP period - not the start of the current contract or just from the start of current bill


-- \hubu_unix_src\main\eraus\hubub69667\2  Wed Mar 16 16:13:28 2011  brookep

--WR69667-oops  need to look for latest "previous reading" from the start of the current contract, not just from the start of current bill


-- \hubu_unix_src\main\eraus\hubub69667\1  Fri Mar  4 10:38:54 2011  brookep

--WR69667-Ensure dumbAccum records created correctly when customer first returns to SE after period of absence


-- \hubu_unix_src\main\eraus\19  Wed Aug  4 12:26:52 2010  ztxn25

--merged to the main line


-- \hubu_unix_src\main\eraus\hubub61535\2  Wed Aug  4 12:25:44 2010  ztxn25

--change to prevent skipping of inventories with rating that has no timeset


-- \hubu_unix_src\main\eraus\hubub61535\1  Fri Jul  9 17:16:30 2010  ztxn25

--checkout for fix of defect that causes missing consumption on timebands


-- \hubu_unix_src\main\eraus\17  Mon Apr 19 14:14:57 2010  ztxj10

--Merge


-- \hubu_unix_src\main\eraus\hubub58023\1  Mon Apr 19 14:14:32 2010  ztxj10

--WR58023 Fix rate and step issue


-- \hubu_unix_src\main\eraus\16  Thu Apr 15 18:28:13 2010  zedh01

--Wr 58668  release


-- \hubu_unix_src\main\eraus\hubub58668\1  Thu Apr 15 18:22:39 2010  zedh01

--Wr 58668  Simply  Performance improvement for 'all' consumption summation


-- \hubu_unix_src\main\eraus\15  Fri Mar 26 16:15:18 2010  zhouj

--WR58161 Merge


-- \hubu_unix_src\main\hubub58161\4  Fri Mar 26 16:12:15 2010  zhouj

--WR58161 No unit conversion if consumption is 0 or null


-- \hubu_unix_src\main\eraus\13  Thu Mar 18 14:28:57 2010  zhouj

--WR57931 Merge


-- \hubu_unix_src\main\hubub57931\3  Thu Mar 18 09:52:59 2010  zhouj

---- WR57931 Use ReadingDumbConsumptionBase instead of ReadingDumbConsumption


-- \hubu_unix_src\main\eraus\12  Mon Mar 15 10:02:55 2010  zhouj

--WR57786 Merge


-- \hubu_unix_src\main\hubub57786\2  Mon Mar 15 10:01:16 2010  zhouj

--WR57786 Minor changes


-- \hubu_unix_src\main\eraus\11  Wed Mar 10 15:47:07 2010  zhouj

--WR57726 Merge


-- \hubu_unix_src\main\hubub57726\1  Wed Mar 10 15:46:11 2010  zhouj

--WR57726 Disable locking to avoid implicit commit


-- \hubu_unix_src\main\eraus\10  Thu Mar  4 18:34:14 2010  zedh01

--Wr 57365  release


-- \hubu_unix_src\main\eraus\9  Thu Mar  4 15:56:05 2010  zedh01

--Wr 57365  release


-- \hubu_unix_src\main\eraus\hubub57365\3  Thu Mar  4 18:32:52 2010  zedh01

--Wr 57365  Populate meter dumbaccum consumption to appear on invoice
--reading details usage


-- \hubu_unix_src\main\eraus\hubub57365\2  Thu Mar  4 15:51:09 2010  zedh01

--Wr 57365  merge other changes


-- \hubu_unix_src\main\eraus\hubub57365\1  Thu Mar  4 15:45:09 2010  zedh01

--Wr 57365  Add period start reading to DumbAccum table to enable billing
--readings to appear on the bill


-- \hubu_unix_src\main\eraus\hubub57522\1  Wed Mar  3 16:43:00 2010  zedh01

--Wr 57522  SimplyEnergy  Improve the performance of basic reading selection


-- \hubu_unix_src\main\eraus\8  Thu Mar  4 10:19:52 2010  zhouj

--WR57408 Merge


-- \hubu_unix_src\main\hubub57408\1  Thu Mar  4 10:18:35 2010  zhouj

--WR57408 Disable rebill scetion to avoid potential issue


-- \hubu_unix_src\main\eraus\7  Wed Mar  3 16:46:11 2010  zedh01

--Wr 57522  release


-- \hubu_unix_src\main\eraus\hubub57522\1  Wed Mar  3 16:43:00 2010  zedh01

--Wr 57522  SimplyEnergy  Improve the performance of basic reading selection


-- \hubu_unix_src\main\eraus\6  Tue Feb 23 17:25:54 2010  zhouj

--WR57260 Merge


-- \hubu_unix_src\main\hubub57260\1  Tue Feb 23 14:07:52 2010  zhouj

--WR57260 Reject when no rate for entire billing period


-- \hubu_unix_src\main\eraus\5  Mon Feb 15 09:40:05 2010  zhouj

--WR56993 Merge


-- \hubu_unix_src\main\hubub56993\2  Fri Feb 12 17:56:13 2010  zhouj

--WR56993 Comment out unnecessary timeband mapping


-- \hubu_unix_src\main\eraus\4  Thu Feb  4 14:24:22 2010  zhouj

--WR55825 Merge


-- \hubu_unix_src\main\hubub55825\4  Thu Feb  4 14:20:56 2010  zhouj

--WR55825 Minor change

-- \hubu_unix_src\main\eraus\3  Wed Feb  3 11:57:22 2010  zhouj

--WR55825 Merge

-- \hubu_unix_src\main\hubub55825\3  Wed Feb  3 09:56:34 2010  zhouj

--WR55825 Modify the cursor cRP to avoid performance issue

-- \hubu_unix_src\main\eraus\2  Fri Jan  8 10:54:41 2010  zhouj

--WR55825 Merge

-- \hubu_unix_src\main\hubub55825\2  Wed Jan  6 10:49:02 2010  zhouj

--WR55825 More changes

-- \hubu_unix_src\main\eraus\1  Thu Dec 17 13:49:00 2009  leer

--WR47589 Merge to eraus


-- \hubu_unix_src\main\eraus\hubub47589\3  Tue Mar 31 10:30:49 2009  zjkn01

--WR 47589 - Add unit conversion  performance changes


-- \hubu_unix_src\main\eraus\hubub47589\2  Tue Mar 17 18:02:16 2009  zjkn01

--WR 47589 - Updates and changes for performance and functionality



    -- ****************************************************************
    --exposed function/procedures for OUNIT testing only please comment out after tesing complete

    TYPE EChargeAccum_plus IS RECORD(EChargeAccumID   NUMBER(9)
                                    ,inventoryid      NUMBER(9)
                                    ,supplypointid    NUMBER(9)
                                    ,timebandid       NUMBER(9)
                                    ,etimechargeid    NUMBER(9)
                                    ,datefrom         DATE
                                    ,dateto           DATE
                                    ,consumption      NUMBER
                                    ,factor1          NUMBER
                                    ,factor2          NUMBER
                                    ,chargeamtbill    NUMBER
                                    ,chargeamtbase    NUMBER
                                    ,invoicechargeid  NUMBER(9)
                                    ,rowversion       CHAR(1)
                                    ,consbilled       NUMBER(15, 6)
                                    ,consbilledfactor NUMBER(6, 4)
                                    ,demandid         NUMBER(9)
                                    ,consadjusted     NUMBER
                                    ,seasonid         NUMBER(9)
                                    ,ratingplanid     NUMBER(9)
                                    ,timesetid        NUMBER(9)
                                    ,unit             VARCHAR2(30)
                                    ,timestampupd     DATE
                                    ,processstatus    VARCHAR2(5)
                                    ,MeterType        VARCHAR2(5)
                                    ,UDST             VARCHAR2(1)
                                    ,rType            Varchar2(1)   -- WR99428
                                    ,productsubclass  varchar2(5)
                                    ,Match_TimeBand   BOOLEAN
                                    ,CountNonZeroRate NUMBER(9));

    TYPE taECA IS TABLE OF EChargeAccum_plus INDEX BY BINARY_INTEGER;

    TYPE TRPECA IS RECORD(ratingplanid  Ratingplan.ratingplanid%TYPE
                         ,TimeSetID     Timeset.timesetid%TYPE
                         ,Seasonid      season.seasonid%TYPE
                         ,UseDST        VARCHAR2(1)
                         ,SupplyPointID echargeaccum.supplypointid%TYPE
                         ,TimeBandID    echargeaccum.timebandid%TYPE
                         ,Datefrom      echargeaccum.datefrom%TYPE
                         ,Dateto        echargeaccum.dateto%TYPE
                         ,Consumption   echargeaccum.consumption%TYPE);

    TYPE taPECA IS TABLE OF trPECA INDEX BY BINARY_INTEGER;

    TYPE tasavecons IS TABLE OF NUMBER INDEX BY VARCHAR2(100);
    TYPE taInt      IS TABLE OF INTEGER INDEX BY VARCHAR2(100);
    TYPE taDate     IS TABLE OF DATE    INDEX BY VARCHAR2(100);
    TYPE taVC30     IS TABLE OF varchar2(30) INDEX BY VARCHAR2(100);
    TYPE taBoolean  IS TABLE OF BOOLEAN INDEX BY VARCHAR2(100);

    TYPE trCons IS RECORD(SupplyPointID  taInt
                         ,InvSPID        taInt
                         ,TimeSetID      taInt
                         ,TimeBandID     taInt
                         ,DateFrom       taDate
                         ,DateTo         taDate
                         ,UDST           taVC30
                         ,SeasonID       taInt
                         ,Consu          taVC30
                         ,Consumption    taSaveCons
                         ,ConsA          taSaveCons
                         ,Found_Match    taBoolean
                         ,ConsSource     taVC30   -- WR99428
                         ,RpTimeBandID   taInt
                         ,ECAKeyGroup    taInt
                         ,InvMeterType   taVC30);

    -- WR55825 Capacity for processing basic readings
    TYPE taRAGKey    IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(100);
    TYPE taRAGID     IS TABLE OF PLS_INTEGER INDEX BY BINARY_INTEGER;
    TYPE t2daRAGID   IS TABLE OF taRAGID     INDEX BY BINARY_INTEGER;
    TYPE taRAGCons   IS TABLE OF NUMBER      INDEX BY BINARY_INTEGER;
    TYPE t2daRAGCons IS TABLE OF taRAGCons   INDEX BY BINARY_INTEGER;

    -- WR57931 Implement creation of DumbAccum
    TYPE trDumbCons IS RECORD
        (RdgDumbID   taRAGID
        ,Consumption taRAGCons);

    TYPE t2dDumbCons IS TABLE OF trDumbCons INDEX BY VARCHAR2(100);

    TYPE taConsKey     IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
    TYPE t2daDumbAccum IS TABLE OF taConsKey INDEX BY BINARY_INTEGER;

    -- WR99428 - Monthly graphing on bills enhancement
    Type taId       Is Table of pls_integer Index by Binary_Integer;
    Type taCS       Is Table of varchar2(5) Index by Binary_integer;
    Type taTibandid Is Table of pls_integer index by binary_integer;
    TYPE taDate1    IS TABLE OF DATE INDEX BY BINARY_INTEGER;
    Type taCons     Is table of number index by binary_integer;
    Type taConsUnit is table of varchar2(30) index by binary_integer;
    Type taEngyType is Table of varchar2(250) index by binary_integer;
    Type taRenewP   is Table of number index by binary_integer;
    Type taGHC      is Table of number index by binary_integer;
    Type trInvCons is Record (InvoiceConsumptionId taId
                             ,ConsSource    taCS
                             ,Timebandid    taTibandid
                             ,DateFrom      tadate1
                             ,DateTo        tadate1
                             ,Consumption   taCons
                             ,ConsUnit      taConsUnit
                             ,EnergyType    taEngyType
                             ,RenewPercent  taRenewP
                             ,GHCoefficient taGHC
                             );

    FUNCTION getBRQ(iHmbrid    NUMBER
		           ,iInvoiceId NUMBER
		           ,iDateFrom  Date
		           ,iDateTo    DATE
                   ,iSource    VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

    FUNCTION Get_RootBPAccount(iCurrentHmbrID IN Hierarchymbr.Hmbrid%TYPE)
                                              RETURN PLS_INTEGER;

    PROCEDURE NewECA(iHMbrID IN  HierarchyMbr.HMbrID%TYPE
                    ,iDateTo IN  DATE
                    ,orc     OUT PLS_INTEGER
                    ,oretc   IN OUT NOCOPY pkg_std.taInt
                    ,oMsg    IN OUT NOCOPY pkg_std.taDescr
                    ,idatefrom in date default null
                    ,iDoDemand   IN VARCHAR2 DEFAULT 'N'    --WR110367
                    ,otaOECA  OUT NOCOPY pkg_accum.trRAG
                    ,iSaveToDB IN BOOLEAN DEFAULT TRUE  -- WR99428
                    ,otaCTB  OUT NOCOpy trInvCons);
    -- WR99428
    Procedure CreateInvoiceConsumption(iHmbrid    number
                                 ,iInvoiceId number
                                 ,iDateFrom  Date
                                 ,iDateTo    Date
                                 );


    PROCEDURE TestNewECA(iInvoiceID IN Invoice.InvoiceID%TYPE
                        ,iDocumentNbr IN Invoice.Documentnbr%TYPE
                        ,iDetailed    IN VARCHAR2
                        );
    PROCEDURE Cons_By_TimeSet_UDST_Season(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                                         ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                                         ,iSeasonID      IN Season.SeasonID%TYPE
                                         ,iDateFrom      IN DATE
                                         ,iDateTo        IN DATE
                                         ,ioCons         IN OUT NOCOPY trCons);

    PROCEDURE Cons_By_TimeSet_Season(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                                    ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                                    ,iSeasonID      IN Season.SeasonID%TYPE
                                    ,iDateFrom      IN DATE
                                    ,iDateTo        IN DATE
                                    ,ioCons         IN OUT NOCOPY trCons);

    PROCEDURE Cons_By_TimeSet(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                             ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                             ,iDateFrom      IN DATE
                             ,iDateTo        IN DATE
                             ,iMeterType     IN MeterType.MeterType%TYPE
                             ,ioCons         IN OUT NOCOPY trCons);

    PROCEDURE Cons_By_UDST_Season(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                                 ,iSeasonID      IN Season.SeasonID%TYPE
                                 ,iDateFrom      IN DATE
                                 ,iDateTo        IN DATE
                                 ,ioCons         IN OUT NOCOPY trCons);

    PROCEDURE Cons_By_UDST (iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                           ,iDateFrom      IN DATE
                           ,iDateTo        IN DATE
                           ,ioCons         IN OUT NOCOPY trCons);

    PROCEDURE Cons_By_Season(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                            ,iSeasonID      IN Season.SeasonID%TYPE
                            ,iDateFrom      IN DATE
                            ,iDateTo        IN DATE
                            ,ioCons         IN OUT NOCOPY trCons);

    PROCEDURE Cons_All(iSupplyPointID       IN SupplyPoint.SupplyPointID%TYPE
                      ,iDateFrom  IN DATE
                      ,iDateTo    IN DATE
                      ,ioCons     IN OUT NOCOPY trCons);

    -- WR55825 Capacity for processing basic readings
    PROCEDURE Cons_Basic(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                        ,iDateFrom      IN DATE
                        ,iDateTo        IN DATE
                        ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                        ,iUDST          IN VARCHAR2
                        ,iSeasonID      IN Season.SeasonID%TYPE
                        ,iSEFRMPStart   IN DATE                       -- WR69667
                        -- WR57931 Implement creation of DumbAccum
                        ,oDumbCons      IN OUT t2dDumbCons
                        ,ioCons         IN OUT NOCOPY trCons);

    PROCEDURE Clear_Arrays;

    TYPE rListOfDates IS RECORD(AsAtDate DATE
                               ,DOW      VARCHAR2(3)
                               ,MMDD     NUMBER(4));
    TYPE taListOfDates IS TABLE OF rListOfDates;

    FUNCTION List_Of_Dates(iDateFrom IN DATE
                          ,iDateTo   IN DATE)
                                     RETURN taListOfDates
                                     DETERMINISTIC PIPELINED;

    TYPE rTimeSetDetails IS RECORD(FromTS     DATE
                                  ,ToTS       DATE
                                  ,TimeBandID TimeBand.TimeBandID%TYPE);

    TYPE taTimeSetDetails IS TABLE OF rTimeSetDetails;

    FUNCTION TimeSetDetails(iTimeSetID IN TimeSet.TimeSetID%TYPE
                           ,iDateFrom  IN DATE
                           ,iDateTo    IN DATE)
                                       RETURN taTimeSetDetails
                                       DETERMINISTIC
                                       PIPELINED;

    -- ****************************************************************


    -------------------------------------------------------------------------------------------------
    -- Returns the package version and date mainly used for debugging wrapped code
    -- #usage   call as needed
    -- #usage   Example
    -- <code>
    --    <br>
    --      SELECT pkg_AMI.version FROM dual;
    -- </code>
    -- #author  ZJKN01
    -- #return  VARCHAR2 the PVS revision and date string
    -------------------------------------------------------------------------------------------------
    FUNCTION version RETURN VARCHAR2;

    g_debug BOOLEAN;

    -- WR57726 Turn on/off locking mechanism
    -- Note, turn on locking mechanism will cause implicit commit when releasing the lock
    g_lock  BOOLEAN;
    --
    -- SEPI-16932
    g_BillTotalCons    number;
    g_BillConsUnit     varchar2(30);
    --

END pkg_AMI;
/
CREATE OR REPLACE PACKAGE BODY pkg_AMI IS

    k_MinDate DATE := pkg_k.k_MinDate;
    k_MaxDate DATE := pkg_k.k_MaxDate;

    l_TimeBand pkg_std.taDescr;
    l_TimeSet  pkg_std.taDescr;
    l_FeedinTB pkg_std.taDescr; --
    g_BillFrom date; --

    TYPE tatimernge IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(30);

    l_timerange      tatimernge;
    g_brcaltype      Feature.FeatureVal%TYPE;
    g_AccumRndStyle1 Feature.Featureval%TYPE;
    g_Rnd2Dec        SystemProperty.Propvalnumber%TYPE;

    -- WR55825 Capacity for processing basic readings
    g_RdgCloseBP     Feature.Featureval%TYPE;

    l_ErrorMessage   USAGEERROR.Descr%TYPE := NULL;
    l_UsageErrorCode UsageError.UsageErrorCode%TYPE;

    -- WR55825 Modify the cursor to find the right rating details
    CURSOR cRP(iRatingPlanID IN RatingPlan.RatingPlanID%TYPE) IS
        SELECT ts.PropValNumber TimeSetID
              ,etc.etimechargeid
              ,etc.ratingperiodid
              ,etc.ratingplanid
              ,etc.timebandid
              ,etc.datestart
              ,etc.dateend
              ,etc.dailydataareaid
              ,rp.CurrencyCode
              ,etc.datestart dateactive
              ,etc.dateend datedeactive
              ,uom.PropValChar Unit
              ,SUBSTR(NVL(udst.PropValChar,'N'),1,1) udst
              ,sson.PropValNumber seasonid
              ,(SELECT count(1)
                FROM ETimeChargeStep etcs
                WHERE etcs.ETimeChargeID = etc.ETimeChargeID
                AND   etcs.rate <> 0) CountNonZeroRate
        FROM   RPProperty  ts
              ,ETImeCharge etc
              ,RatingPlan  rp
              ,RPProperty  uom
              ,RPProperty  sson
              ,RPProperty  udst
        WHERE  ts.RatingPlanID = etc.RatingPlanID
        AND    ts.PropertyKey(+) = 'TISET'
        AND    rp.RatingPlanID = etc.RatingPlanID
        AND    rp.RatingPlanID = iRatingPlaniD
        AND    uom.RatingPlanID = rp.RatingPlanID
        AND    uom.PropertyKey IN ('CONSU', 'DEMDU', 'READU')
        AND   (uom.DateStart IS NULL OR
               uom.DateStart <= NVL(etc.DateEnd, k_MaxDate))
        AND   (uom.DateEnd IS NULL OR
               uom.DateEnd <= etc.DateStart)
        AND    sson.RatingPlanID(+) = rp.RatingPlanID
        AND    sson.PropertyKey(+) = 'SESON'
        AND   (sson.DateStart IS NULL OR
               sson.DateStart <= NVL(etc.DateEnd, k_MaxDate))
        AND   (sson.DateEnd IS NULL OR
               sson.DateEnd <= etc.DateStart)
        AND    udst.RatingPlanID = rp.RatingPlanID
        AND    udst.PropertyKey = 'UDST'
        AND    udst.DateStart <= NVL(etc.DateEnd, k_MaxDate)
        AND   (udst.DateEnd IS NULL OR
               udst.DateEnd <= etc.DateStart)
        ORDER  BY etc.datestart
                 ,etc.dateend
                 ,etc.TimeBandID; --wr61535

    TYPE tarpl IS TABLE OF cRP%ROWTYPE INDEX BY BINARY_INTEGER;
    TYPE recratpl IS RECORD(rpdet tarpl
                           ,idx   PLS_INTEGER);

    TYPE tarprec IS TABLE OF recratpl INDEX BY BINARY_INTEGER;
    rparr tarprec;

    TYPE tarpsptb IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(30);
    rpspmaptb tarpsptb;
    TYPE tarptiband IS TABLE OF PLS_INTEGER INDEX BY BINARY_INTEGER;
    g_spid_arr tarptiband;

    g_loc_country PLS_INTEGER;
    g_loc_state   PLS_INTEGER;

    -- WR97143
    -- TimeSet season boundaries details
    Type trTSSB Is record (TimeBandid    number
                        ,Dateactive    date
                        ,Datedeactive  date
                        ,startmmdd     number
                        ,endmmdd       number
                        );
    --
    Type taTSSB  is table of trTSSB index by BINARY_INTEGER;
    Type taTBand is table of taTSSB index by Varchar2(10);
    Type trTS    is record (TimeSetid   number
                           ,TBand       taTBand
                            );
    Type taTS    is table of trTS index by Varchar2(10);

    lr_TSSB      trTSSB;-- timeband details
    lr_Ts        trTS;  -- one timeset
    la_TS        taTS;  -- all timesets
    --
    X_OOPS      EXCEPTION;
    xSkipDemand EXCEPTION;
    -------------------------------------------------------------------------------
--
function lp(ichar varchar2, ilen number)
   return varchar2 Is
Begin
   Return rpad(nvl(iChar,' '),ilen,' ')||',';
End lp;
--
function Rpd(ichar varchar2, ilen number)
   return varchar2 Is
Begin
   Return lpad(nvl(iChar,' '),ilen,' ')||',';
End Rpd;
--

    -------------------------------------------------------------------------------
    FUNCTION List_Of_Dates(iDateFrom IN DATE
                          ,iDateTo   IN DATE)
                                     RETURN taListOfDates
                                     DETERMINISTIC
                                     PIPELINED AS
        l_ret rListOfDates := NULL;
    BEGIN
        FOR rec IN (SELECT (iDateto - LEVEL + 1) AsAtDate
                  FROM   dual
                  CONNECT BY LEVEL <= (iDateto - iDatefrom + 1)) LOOP
            l_Ret.AsAtDate := rec.AsAtDate;
            l_Ret.DOW      := to_char(rec.AsAtDate,'DY');
            l_Ret.MMDD     := to_number(to_char(rec.AsAtDate,'MMDD'));
            PIPE ROW(l_Ret);
        END LOOP;
    END;

    -------------------------------------------------------------------------------
    FUNCTION TimeSetDetails(iTimeSetID IN TimeSet.TimeSetID%TYPE
                           ,iDateFrom  IN DATE
                           ,iDateTo    IN DATE)
                                       RETURN taTimeSetDetails
                                       DETERMINISTIC
                                       PIPELINED AS
        l_Ret rTimeSetDetails;
    BEGIN
        FOR rec IN (SELECT (dates.AsAtDate + (tr.timestartsecs + 1) / 86400) FromTS
                          ,(dates.AsAtDate + tr.timeendsecs / 86400) ToTS
                          ,tr.TimeBandID
                    FROM   TimeSetVersion tsv
                          ,TimeRange tr
                          ,(SELECT jd.AsAtDate
                                  ,to_char(jd.AsAtDate, 'DY') dow
                                  ,to_char(jd.AsAtDate, 'MMDD') mmdd
                            FROM  (SELECT (iDateto - LEVEL + 1) AsAtDate
                                   FROM   dual
                                   CONNECT BY LEVEL <= (iDateto - iDatefrom + 1)) jd) dates
                    WHERE  dates.AsAtDate >= tsv.dateactive
                    AND   (tsv.Datedeactive IS NULL OR tsv.Datedeactive > dates.AsAtDate)
                    AND    tsv.TimeSetID = iTimesetid
                    AND    tsv.timesetversionid = tr.timesetversionid
                    AND   ((tr.monflg = 'Y' AND dates.dow = 'MON') OR (tr.tueflg = 'Y' AND dates.dow = 'TUE') OR
                          (tr.wedflg = 'Y' AND dates.dow = 'WED') OR (tr.thuflg = 'Y' AND dates.dow = 'THU') OR
                          (tr.friflg = 'Y' AND dates.dow = 'FRI') OR (tr.satflg = 'Y' AND dates.dow = 'SAT') OR
                          (tr.sunflg = 'Y' AND dates.dow = 'SUN'))
                    AND    dates.mmdd BETWEEN tr.startmmdd AND tr.endmmdd) LOOP
            l_Ret.FromTS     := rec.FromTS;
            l_Ret.ToTS       := rec.ToTS;
            l_Ret.TimeBandID := rec.TimeBandID;
            --
            PIPE ROW(l_Ret);
        END LOOP;
    END;

    -------------------------------------------------------------------------------
    FUNCTION Get_RootBPAccount(iCurrentHmbrID IN Hierarchymbr.Hmbrid%TYPE)
                                              RETURN PLS_INTEGER IS
        l_HMBRID Hierarchymbr.Hmbrid%TYPE := NULL;
    BEGIN
        BEGIN
            SELECT HMBRID
            INTO   l_HmbrID
            FROM   HIERARCHYMBR h
            WHERE  H.HMBRTYPE = 'BP'
            AND    ROWNUM < 2
            CONNECT BY PRIOR h.ParentBuid = h.buid
            START  WITH H.HMBRID = iCurrentHmbrID;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        RETURN l_HMBRID;
    END;

    --------------------------------------------------------------------------
    FUNCTION BuildKey(iInvSPID       IN SupplyPoint.SupplyPointID%TYPE
                     ,iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                     ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                     ,iTimeBandID    IN TimeBand.TimeBandID%TYPE
                     ,iDateFrom      IN DATE
                     ,iDateTo        IN DATE
                     ,iDST           IN VARCHAR2
                     ,iSeasonID      IN Season.SeasonID%TYPE
                     ,iConsu         IN Unit.Unit%TYPE)
                                     RETURN VARCHAR2 IS
        l_Key VARCHAR2(100);
    BEGIN
        l_Key := iInvSPID                              || '_' ||
                 iTimeSetID                            || '_' ||
                 to_char(iDateFrom,'yyyymmddhh24miss') || '_' ||
                 to_char(iDateTo,'yyyymmddhh24miss')   || '_' ||
                 iDST                                  || '_' ||
                 iSeasonID                             || '_' ||
                 iTimeBandID                           || '_' ||
                 iSupplyPointID                        || '_' ||
                 iConsu;
        RETURN l_Key;
    END;

    --------------------------------------------------------------------------

    FUNCTION getBRQ(iHmbrid    NUMBER
		           ,iInvoiceId NUMBER
		           ,iDateFrom  Date
		           ,iDateTo    DATE
                   ,iSource    VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 IS

    l_RET          VARCHAR2(5) := NULL;
    l_HMBRID       hierarchymbr.hmbrid%TYPE;
    l_InvID        invoice.invoiceid%TYPE;
    l_RDGType      invoice.readingtype%TYPE;
    l_DFrm         DATE;
    l_DTo          DATE;
    l_SRC          VARCHAR2(5) := NULL;
    l_BRQHrs       systemproperty.propvalnumber%TYPE := pkg_util.SysPropVal('BRQHRSCHK','N')/24;

    CURSOR getInv (iInvID IN Invoice.Invoiceid%TYPE) IS
	   SELECT i.hmbrid,
		      i.datefrom,
		      i.dateto,
              i.Readingtype
	   FROM   invoice i
	   WHERE  i.invoiceid = iInvID;

    CURSOR getBRQ (iHmbrid    IN HierarchyMbr.Hmbrid%TYPE
                  ,iDateFrom  IN DATE
                  ,iDateTo    IN DATE) IS
    WITH MTR AS (
         SELECT T.HMBRID,
                SLK.SUPPLYPOINTID,
                SLK.DATESTART,
                SLK.METERTYPE,
                SLK.SITESPID,
                SLK.MPSPID,
                SLK.MTRSPID,
                SLK.DATEEND,
                SLK.PARTKEY,
                RDPDAY.PROPVALNUMBER RDPDAY
         FROM  (SELECT DISTINCT SPID.PROPVALNUMBER SPID,
                       BP.HMBRID,
                       I.DATEACTIVE,
                       I.DATEDEACTIVE
                FROM   HIERARCHYMBR  BP,
                       HIERARCHYMBR  NBP,
                       HMBRINVENTORY HMI,
                       INVENTORY     I,
                       INVPROPERTY   SPID,
                       PRODUCT       P
                WHERE  BP.HMBRID = iHmbrid
                AND    BP.BUID = NBP.PARENTBUID
                AND    NBP.HMBRID = HMI.HMBRID
                AND    HMI.INVENTORYID = I.INVENTORYID
                AND    I.DATEACTIVE <= iDateTo
                AND   (I.DATEDEACTIVE IS NULL
                 OR    I.DATEDEACTIVE >= iDateFrom)
                AND    I.INVENTORYID = SPID.INVENTORYID
                AND    SPID.PROPERTYKEY = 'SPID'
                AND    I.PRODUCTID = P.PRODUCTID
                AND    P.CHARGETYPE LIKE 'U%'
                ORDER BY I.DATEACTIVE DESC, I.DATEDEACTIVE) T,
                SUPPLYPOINTLOOKUP SLK,
                SPPROPERTY RDPDAY,
                SPPROPERTY CONSU,
                SPPROPERTY NBREG
         WHERE  SLK.MPSPID = T.SPID
         AND    SLK.METERTYPE IN ('MRDR', 'TOUR')
         AND    SLK.DATESTART <= iDateTo
         AND   (SLK.DATEEND IS NULL OR SLK.DATEEND >= iDateFrom)
         AND    RDPDAY.SUPPLYPOINTID(+) = SLK.SUPPLYPOINTID
         AND    RDPDAY.PROPERTYKEY(+) = 'RDPDAY'
         AND    RDPDAY.DATESTART(+) <= iDateTo
         AND   (NVL(RDPDAY.DATEEND(+), k_MaxDate) > iDateFrom)
         AND    CONSU.SUPPLYPOINTID = SLK.SUPPLYPOINTID
         AND    CONSU.PROPERTYKEY IN ('CONSU', 'READU')
         AND    UPPER(CONSU.PROPVALCHAR) IN ('KWH', 'WH', 'MWH')
         AND    NBREG.SUPPLYPOINTID = SLK.SUPPLYPOINTID
         AND    NBREG.PROPERTYKEY = 'NBREG'
         AND    NVL(NBREG.PROPVALCHAR, 'N') = 'N')
    SELECT *
    FROM  (SELECT T1.*,
                  DECODE(T1.RDGCNT, T1.RDGA, 'A', T1.RDGS, 'S', T1.RDGF, 'F',
                         DECODE(T1.METERTYPE,
                                'TOUR',
                                DECODE(GREATEST(GREATEST(T1.RDGS,T1.RDGF), (T1.RDPDAY * l_BRQHrs)+1),
                                       T1.RDGS, 'S', T1.RDGF,
                                       DECODE(T1.RDGS, T1.RDGF, 'S', 'F'),
                                              DECODE(GREATEST((T1.RDGS + T1.RDGF),(T1.RDPDAY * l_BRQHrs)+1),
                                                    (T1.RDGS + T1.RDGF),
                                                     DECODE(T1.RDGS, T1.RDGF, 'S',
                                                            DECODE(GREATEST(T1.RDGS,T1.RDGF), T1.RDGS, 'S', 'F')),
                                                                   DECODE(T1.RDGA, 0,
                                                                          DECODE(T1.RDGS, 0,
                                                                                 DECODE(T1.RDGF, 0, NULL, 'F'), 'S'), 'A'))),
                                'MRDR',
                                DECODE(T1.RDGA, 0,
                                       DECODE(T1.RDGS, 0,
                                              DECODE(T1.RDGF, 0, NULL, 'F'), 'S'),'A'))) BRQ
           FROM  (SELECT T.HMBRID,
                         T.SUPPLYPOINTID,
                         T.METERTYPE,
                         T.SITESPID,
                         T.MPSPID,
                         T.MTRSPID,
                         T.RDPDAY,
                         SUM(T.TYPA) + SUM(T.TYPF) + SUM(T.TYPS) RDGCNT,
                         SUM(T.TYPA) RDGA,
                         SUM(T.TYPF) RDGF,
                         SUM(T.TYPS) RDGS
                  FROM  (SELECT M.*,
                                RT.TIMESTAMP RDGDT,
                                DECODE(RT.READINGTYPE, 'A', 1, 0) TYPA,
                                DECODE(RT.READINGTYPE, 'F', 1, 0) TYPF,
                                DECODE(RT.READINGTYPE, 'A', 0, 'F', 0, 1) TYPS
                         FROM   MTR M, READINGTOU RT
                         WHERE  M.METERTYPE = 'TOUR'
                         AND    RT.SUPPLYPOINTID = M.SUPPLYPOINTID
                         AND    RT.PROCESSSTATUS = 'A'
                         AND    RT.PARTKEY = M.PARTKEY
                         AND    RT.TIMESTAMP > iDateFrom
                         AND    RT.TIMESTAMP <= iDateTo + 1
                         UNION
                         SELECT HMBRID,
                                SUPPLYPOINTID,
                                DATESTART,
                                METERTYPE,
                                SITESPID,
                                MPSPID,
                                MTRSPID,
                                DATEEND,
                                PARTKEY,
                                RDPDAY,
                                RDGDT,
                                TYPA,
                                TYPF,
                                TYPS
                         FROM  (SELECT rdg.*,
                                       ROW_NUMBER() OVER (ORDER BY rdg.RDGDT DESC, rdg.QualSeq ASC) AS seq
                                FROM  (SELECT M.*,
                                              TRUNC(RD.TIMESTAMP) RDGDT,
                                              DECODE(DECODE(RD.READINGTYPE, CD.CODEFROM, CD.CODETO, RD.READINGTYPE), 'A', 1, 0) TYPA,
                                              DECODE(DECODE(RD.READINGTYPE, CD.CODEFROM, CD.CODETO, RD.READINGTYPE), 'F', 1, 0) TYPF,
                                              DECODE(DECODE(RD.READINGTYPE, CD.CODEFROM, CD.CODETO, RD.READINGTYPE), 'A', 0, 'F', 0, 1) TYPS,
                                              DECODE(RD.READINGTYPE,'A',1,'S',1,'F',1,2) Priority,
                                              DECODE(RD.ReadingType,'S', 1, 'F', 2, 'A',3,4) QualSeq
                                       FROM   MTR M, READINGDUMB RD, CODEXLATE CD
                                       WHERE  M.METERTYPE = 'MRDR'
                                       AND    RD.SUPPLYPOINTID = M.SUPPLYPOINTID
                                       AND    RD.PROCESSSTATUS = 'A'
                                       AND    TRUNC(RD.TIMESTAMP) BETWEEN iDateFrom AND iDateTo
                                       AND    CD.DOMAINKEYFROM = 'RDTYPE'
                                       AND    CD.DOMAINKEYTO = 'RDTYPEI'
                                       ORDER BY TRUNC(RD.TIMESTAMP) DESC,
                                              DECODE(RD.ReadingType,'S', 1, 'F', 2, 'A',3,4) ASC) rdg
                                ORDER BY priority ASC, seq ASC)
                         WHERE ROWNUM < 2) T
                  GROUP BY T.HMBRID,
                           T.SUPPLYPOINTID,
                           T.METERTYPE,
                           T.SITESPID,
                           T.MPSPID,
                           T.MTRSPID,
                           T.RDPDAY) T1)
    ORDER BY decode(BRQ,'S', 1, 'F', 2, 3) ASC;

    cBRQ getBRQ%ROWTYPE;

    BEGIN
	-- Validate for input values
	l_HMBRID  := iHmbrid;
	l_InvID   := iInvoiceId;
	l_DFrm    := iDateFrom;
	l_DTo     := iDateTo;
    l_SRC     := iSource;

	IF  l_HMBRID IS NULL AND
	    l_InvID IS NULL THEN
	    l_RET := NULL;
	    GOTO EOF;
	END IF;

	IF  l_InvID IS NULL AND
	   (l_DFrm  IS NULL OR
	    l_DTo    IS NULL) THEN
	    l_RET := NULL;
	    GOTO EOF;
	END IF;

    IF  l_SRC IS NOT NULL AND
        l_InvID IS NULL THEN
	    l_RET := NULL;
	    GOTO EOF;
	END IF;

	-- If InvoiceID is given, obtain BPHMBRID and BillFrom/BillTo Dates
	OPEN  getInv(l_InvID);
	FETCH getInv INTO l_HMBRID, l_DFrm, l_DTo, l_RDGType;
	CLOSE getInv;

	IF  l_HMBRID IS NULL AND
	    l_DFrm IS NULL AND
	    l_DTo IS NULL THEN
	    l_RET := NULL;
	    GOTO EOF;
	END IF;

    IF  l_SRC = 'AMIAV' AND
        l_RDGType IS NOT NULL THEN
        l_RET := l_RDGType;
        GOTO EOF;
    END IF;

	OPEN getBRQ (l_HMBRID, l_DFrm, l_DTo);
	FETCH getBRQ INTO cBRQ;

	IF  getBRQ%FOUND THEN
	    l_RET := cBRQ.BRQ;
	ELSE
	    l_RET := NULL;
	END IF;
	CLOSE getBRQ;

	<<EOF>>

	RETURN l_RET;
    EXCEPTION
	WHEN OTHERS THEN
	     RETURN l_RET;
    END getBRQ;
    --------------------------------------------------------------------------
    --------------------------------------------------------------------------
    FUNCTION GetCons(iInvSPID        IN SupplyPoint.SupplyPointID%TYPE
                     ,iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                     ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                     ,iTimeBandID    IN TimeBand.TimeBandID%TYPE
                     ,iDateFrom      IN DATE
                     ,iDateTo        IN DATE
                     ,iDST           IN VARCHAR2
                     ,iSeasonID      IN Season.SeasonID%TYPE
                     ,iConsu         IN Unit.Unit%TYPE
                     ,ioCons         IN OUT NOCOPY trCons)
                                     RETURN NUMBER IS
        l_key VARCHAR2(100);
    BEGIN
        l_Key := BuildKey(iInvSPID       => iInvSPID
                         ,iSupplyPointID => iSupplyPointID
                         ,iTimeSetID     => iTimeSetID
                         ,iTimeBandID    => iTimeBandID
                         ,iDateFrom      => iDateFrom
                         ,iDateTo        => iDateTo
                         ,iDST           => iDST
                         ,iSeasonID      => iSeasonID
                         ,iConsu         => iConsu);
        RETURN ioCons.Consumption(l_Key);
    END;

    --------------------------------------------------------------------------
    FUNCTION SaveCons(iInvSPID       IN SupplyPoint.SupplyPointID%TYPE
                     ,iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                     ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                     ,iTimeBandID    IN TimeBand.TimeBandID%TYPE
                     ,iDateFrom      IN DATE
                     ,iDateTo        IN DATE
                     ,iDST           IN VARCHAR2
                     ,iSeasonID      IN Season.SeasonID%TYPE
                     ,iConsu         IN Unit.Unit%TYPE
                     ,iConsumption   IN NUMBER
                     ,isource        IN varchar2 default null  -- WR99428
                     ,ioCons         IN OUT NOCOPY trCons)
                                     RETURN VARCHAR2 IS
        l_Key VARCHAR2(100);
    BEGIN
        l_Key := BuildKey(iInvSPID       => iInvSPID
                         ,iSupplyPointID => iSupplyPointID
                         ,iTimeSetID     => iTimeSetID
                         ,iTimeBandID    => iTimeBandID
                         ,iDateFrom      => iDateFrom
                         ,iDateTo        => iDateTo
                         ,iDST           => iDST
                         ,iSeasonID      => iSeasonID
                         ,iConsu         => iConsu);
        IF iConsumption IS NOT NULL THEN
            ioCons.SupplyPointID(l_Key) := iSupplyPointID;
            ioCons.InvSPID(l_Key)       := iInvSPID;
            ioCons.TimeSetID(l_Key)     := iTimeSetID;
            ioCons.TimeBandID(l_Key)    := iTimeBandID;
            ioCons.DateFrom(l_Key)      := iDateFrom;
            ioCons.DateTo(l_Key)        := iDateTo;
            ioCons.UDST(l_Key)          := iDST;
            ioCons.SeasonID(l_Key)      := iSeasonID;
            ioCons.Consu(l_Key)         := iConsu;
            ioCons.ConsA(l_Key)         := NULL;
            ioCons.Found_Match(l_Key)   := FALSE;
            ioCons.ConsSource(l_Key)    := iSource;         -- WR99428
            ioCons.ECAKeyGroup(l_Key)   := NULL;
            --
            IF ioCons.Consumption.EXISTS(l_Key) THEN
                ioCons.Consumption(l_Key) := ioCons.Consumption(l_Key) + iConsumption;
            ELSE
                ioCons.Consumption(l_Key) := iConsumption;
            END IF;
        END IF;
        --
        RETURN l_Key;
    END;

    --------------------------------------------------------------------------
    PROCEDURE Cons_By_TimeSet_UDST_Season(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                                         ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                                         ,iSeasonID      IN Season.SeasonID%TYPE
                                         ,iDateFrom      IN DATE
                                         ,iDateTo        IN DATE
                                         ,ioCons         IN OUT NOCOPY trCons) IS
        CURSOR cCons IS
            WITH FullDates AS (
                SELECT dates.*,tr.*
                FROM   TimeSetVersion tsv
                      ,TimeRange tr
                      ,(SELECT jd.AsAtDate
                               ,to_char(jd.AsAtDate, 'DY') dow
                               ,to_char(jd.AsAtDate, 'MMDD') mmdd
                         FROM  (SELECT (iDateto - LEVEL + 1) AsAtDate
                                FROM   dual
                                CONNECT BY LEVEL <= (iDateto - iDatefrom + 1)) jd) dates
                WHERE  dates.AsAtDate >= tsv.dateactive
                AND   (tsv.Datedeactive IS NULL OR tsv.Datedeactive > dates.AsAtDate)
                AND    tsv.TimeSetID = iTimesetid
                AND    tsv.timesetversionid = tr.timesetversionid
                AND    dates.mmdd BETWEEN tr.startmmdd AND tr.endmmdd),
            Holidays AS (
                SELECT dates.*
                FROM   FullDates dates
                      ,CalendarEvent ce
                WHERE  ce.locationid IN (g_loc_country,g_loc_state)
                AND    dates.AsAtDate BETWEEN ce.datestart AND ce.dateend
                AND    ce.ceventtype = dates.ceventtype),
            NonHolidays AS (
                SELECT dates.*
                FROM   FullDates dates
                WHERE  dates.AsAtDate NOT IN (SELECT AsAtDate FROM Holidays)
                AND   ((dates.monflg = 'Y' AND dates.dow = 'MON')
                    OR (dates.tueflg = 'Y' AND dates.dow = 'TUE')
                    OR (dates.wedflg = 'Y' AND dates.dow = 'WED')
                    OR (dates.thuflg = 'Y' AND dates.dow = 'THU')
                    OR (dates.friflg = 'Y' AND dates.dow = 'FRI')
                    OR (dates.satflg = 'Y' AND dates.dow = 'SAT')
                    OR (dates.sunflg = 'Y' AND dates.dow = 'SUN'))),
            Flat_TimeSet AS (
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   NonHolidays
                UNION
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   Holidays)
            SELECT SUM(NVL(consumption, 0)) consumption
                  ,sp.propvalchar Consu
                  ,lu.SupplyPointID
                  ,NVL(tb.PropValNumber, dt.TimeBandID) TimeBandID
            FROM   ReadingTOU t
                  ,SupplyPointLookup lu
                  ,SupplyPointLookup lu2
                  ,spproperty sp
                  ,SPProperty tb
                  ,Flat_TimeSet dt
            WHERE  NVL(t.timestampds, t.timestamp) BETWEEN dt.FromTS AND dt.ToTS
            AND    t.SupplyPointID = lu.SupplyPointID
            AND    t.ProcessStatus = 'A'
            AND    t.PartKey = lu.PartKey
            AND    lu2.SupplyPointID = iSupplypointid
            AND    lu2.sitespid = lu.sitespid
            -- WR57786 Handle multiple MP under the same SITE
            --         With assumption of all register/meter under MP are for billing
            --         SE billing stays on MP level
            AND    lu2.mpspid = lu.mpspid
            AND    lu.DateStart < NVL(t.timestampds, t.timestamp)
            AND    (lu.DateEnd IS NULL OR lu.DateEnd >= NVL(t.timestampds, t.timestamp))
            AND    EXISTS (SELECT 0
                           FROM   spproperty
                           WHERE  supplypointid = lu.SupplyPointID
                           AND    propertykey = 'NBREG'
                           AND    propvalchar = 'N')
            AND    sp.supplypointid = lu.SupplyPointID
            AND    sp.propertykey = 'CONSU'
            -- Note not "<=" because the timestamp is the end of the period
            AND    NVL(t.timestampds, t.timestamp) > sp.datestart
            AND   (sp.DateEnd IS NULL OR sp.DateEnd >= NVL(t.timestampds, t.timestamp))
            AND    tb.SupplyPointID = lu.SupplyPointID
            AND    tb.PropertyKey = 'TIBAND'
            GROUP  BY lu.SupplyPointID
                     ,sp.propvalchar
                     ,NVL(tb.PropValNumber, dt.TimeBandID);
        l_Key VARCHAR2(100);
    BEGIN
        FOR rec IN cCons LOOP
            l_Key := SaveCons(iInvSPID       => iSupplyPointID
                             ,iSupplyPointID => rec.SupplyPointID
                             ,iTimeSetID     => iTimeSetID
                             ,iTimeBandID    => rec.TimeBandID
                             ,iDateFrom      => iDateFrom
                             ,iDateTo        => iDateTo
                             ,iDST           => 'Y'
                             ,iSeasonID      => iSeasonID
                             ,iConsu         => rec.Consu
                             ,iConsumption   => rec.Consumption
                             ,iSource        => 'I'                      -- WR99428
                             ,ioCons         => ioCons);
        END LOOP;
    END;
    --------------------------------------------------------------------------
    PROCEDURE Cons_By_TimeSet_Season(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                                    ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                                    ,iSeasonID      IN Season.SeasonID%TYPE
                                    ,iDateFrom      IN DATE
                                    ,iDateTo        IN DATE
                                    ,ioCons         IN OUT NOCOPY trCons) IS
        CURSOR cCons IS
            WITH FullDates AS (
                SELECT dates.*,tr.*
                FROM   TimeSetVersion tsv
                      ,TimeRange tr
                      ,(SELECT jd.AsAtDate
                               ,to_char(jd.AsAtDate, 'DY') dow
                               ,to_char(jd.AsAtDate, 'MMDD') mmdd
                         FROM  (SELECT (iDateto - LEVEL + 1) AsAtDate
                                FROM   dual
                                CONNECT BY LEVEL <= (iDateto - iDatefrom + 1)) jd) dates
                WHERE  dates.AsAtDate >= tsv.dateactive
                AND   (tsv.Datedeactive IS NULL OR tsv.Datedeactive > dates.AsAtDate)
                AND    tsv.TimeSetID = iTimesetid
                AND    tsv.timesetversionid = tr.timesetversionid
                AND    dates.mmdd BETWEEN tr.startmmdd AND tr.endmmdd),
            Holidays AS (
                SELECT dates.*
                FROM   FullDates dates
                      ,CalendarEvent ce
                WHERE  ce.locationid IN (g_loc_country,g_loc_state)
                AND    dates.AsAtDate BETWEEN ce.datestart AND ce.dateend
                AND    ce.ceventtype = dates.ceventtype),
            NonHolidays AS (
                SELECT dates.*
                FROM   FullDates dates
                WHERE  dates.AsAtDate NOT IN (SELECT AsAtDate FROM Holidays)
                AND   ((dates.monflg = 'Y' AND dates.dow = 'MON')
                    OR (dates.tueflg = 'Y' AND dates.dow = 'TUE')
                    OR (dates.wedflg = 'Y' AND dates.dow = 'WED')
                    OR (dates.thuflg = 'Y' AND dates.dow = 'THU')
                    OR (dates.friflg = 'Y' AND dates.dow = 'FRI')
                    OR (dates.satflg = 'Y' AND dates.dow = 'SAT')
                    OR (dates.sunflg = 'Y' AND dates.dow = 'SUN'))),
            Flat_TimeSet AS (
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   NonHolidays
                UNION
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   Holidays)
            SELECT SUM(NVL(consumption, 0)) consumption
                  ,sp.propvalchar Consu
                  ,lu.SupplyPointID
                  ,NVL(tb.PropValNumber, Dt.TimeBandID) TimeBandID
            FROM   ReadingTOU t
                  ,SupplyPointLookup lu
                  ,SupplyPointLookup lu2
                  ,spproperty sp
                  ,SPProperty tb
                  ,Flat_TimeSet dt
            WHERE  t.timestamp BETWEEN dt.FromTS AND dt.ToTS
            AND    t.SupplyPointID = lu.SupplyPointID
            AND    t.ProcessStatus = 'A'
            AND    t.PartKey = lu.PartKey
            AND    lu2.SupplyPointID = iSupplypointid
            AND    lu2.sitespid = lu.sitespid
            -- WR57786 Handle multiple MP under the same SITE
            --         With assumption of all register/meter under MP are for billing
            --         SE billing stays on MP level
            AND    lu2.mpspid = lu.mpspid
            AND    lu.DateStart < t.timestamp
            AND    (lu.DateEnd IS NULL OR lu.DateEnd >= t.timestamp)
            AND    EXISTS (SELECT 0
                           FROM   spproperty
                           WHERE  supplypointid = lu.SupplyPointID
                           AND    propertykey = 'NBREG'
                           AND    propvalchar = 'N')
            AND    sp.supplypointid = lu.SupplyPointID
            AND    sp.propertykey = 'CONSU'
            -- Note not "<=" because the timestamp is the end of the period
            AND    t.timestamp > sp.datestart
            AND   (sp.DateEnd IS NULL OR sp.DateEnd >= t.timestamp)
            AND    tb.SupplyPointID = lu.SupplyPointID
            AND    tb.PropertyKey = 'TIBAND'
            GROUP  BY lu.SupplyPointID
                     ,sp.propvalchar
                     ,NVL(tb.PropValNumber, Dt.TimeBandID);
        l_Key VARCHAR2(100);
    BEGIN
        FOR rec IN cCons LOOP
            l_Key := SaveCons(iInvSPID       => iSupplyPointID
                             ,iSupplyPointID => rec.SupplyPointID
                             ,iTimeSetID     => iTimeSetID
                             ,iTimeBandID    => rec.TimeBandID
                             ,iDateFrom      => iDateFrom
                             ,iDateTo        => iDateTo
                             ,iDST           => 'N'
                             ,iSeasonID      => iSeasonID
                             ,iConsu         => rec.Consu
                             ,iConsumption   => rec.Consumption
                             ,iSource        => 'I'             -- WR99428
                             ,ioCons         => ioCons);
        END LOOP;
    END;

    --------------------------------------------------------------------------
    PROCEDURE Cons_By_TimeSet(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                             ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                             ,iDateFrom      IN DATE
                             ,iDateTo        IN DATE
                             ,iMeterType     IN MeterType.MeterType%TYPE
                             ,ioCons         IN OUT NOCOPY trCons) IS
        CURSOR cConsSite(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                        ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                        ,iDateFrom      IN DATE
                        ,iDateTo        IN DATE) IS
            WITH FullDates AS (
                SELECT dates.*,tr.*
                FROM   TimeSetVersion tsv
                      ,TimeRange tr
                      ,(SELECT jd.AsAtDate
                               ,to_char(jd.AsAtDate, 'DY') dow
                               ,to_char(jd.AsAtDate, 'MMDD') mmdd
                         FROM  (SELECT (iDateto - LEVEL + 1) AsAtDate
                                FROM   dual
                                CONNECT BY LEVEL <= (iDateto - iDatefrom + 1)) jd) dates
                WHERE  dates.AsAtDate >= tsv.dateactive
                AND   (tsv.Datedeactive IS NULL OR tsv.Datedeactive > dates.AsAtDate)
                AND    tsv.TimeSetID = iTimesetid
                AND    tsv.timesetversionid = tr.timesetversionid
                AND    dates.mmdd BETWEEN tr.startmmdd AND tr.endmmdd),
            Holidays AS (
                SELECT dates.*
                FROM   FullDates dates
                      ,CalendarEvent ce
                WHERE  ce.locationid IN (g_loc_country,g_loc_state)
                AND    dates.AsAtDate BETWEEN ce.datestart AND ce.dateend
                AND    ce.ceventtype = dates.ceventtype),
            NonHolidays AS (
                SELECT dates.*
                FROM   FullDates dates
                WHERE  dates.AsAtDate NOT IN (SELECT AsAtDate FROM Holidays)
                AND   ((dates.monflg = 'Y' AND dates.dow = 'MON')
                    OR (dates.tueflg = 'Y' AND dates.dow = 'TUE')
                    OR (dates.wedflg = 'Y' AND dates.dow = 'WED')
                    OR (dates.thuflg = 'Y' AND dates.dow = 'THU')
                    OR (dates.friflg = 'Y' AND dates.dow = 'FRI')
                    OR (dates.satflg = 'Y' AND dates.dow = 'SAT')
                    OR (dates.sunflg = 'Y' AND dates.dow = 'SUN'))),
            Flat_TimeSet AS (
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   NonHolidays
                UNION
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   Holidays)
            SELECT SUM(NVL(consumption, 0)) consumption
                  ,sp.propvalchar Consu
                  ,lu.SupplyPointID
                  ,NVL(tb.PropValNumber, Dt.TimeBandID) TimeBandID
            FROM   Flat_TimeSet dt
                  ,SupplyPointLookup lu
                  ,SPProperty tb
                  ,spproperty sp
                  ,ReadingTOU t
            WHERE  lu.SiteSPID = iSupplypointid
            AND    lu.DateStart <= iDateTo --dt.ToTS
            AND   (lu.DateEnd IS NULL OR lu.DateEnd >= iDateFrom) --dt.FromTs)
            AND    sp.supplypointid = lu.SupplyPointID
            AND    sp.propertykey = 'CONSU'
            -- Note not "<=" because the timestamp is the end of the period
            AND    sp.datestart <= iDateTo
            AND   (sp.DateEnd IS NULL OR sp.DateEnd >= iDateFrom)
            AND    tb.SupplyPointID = lu.SupplyPointID
            AND    tb.PropertyKey = 'TIBAND'
            AND    t.timestamp BETWEEN dt.FromTS AND dt.ToTS
            AND    t.SupplyPointID = lu.SupplyPointID
            AND    t.ProcessStatus = 'A'
            AND    t.PartKey = lu.PartKey
            AND    EXISTS (SELECT 0
                           FROM   spproperty
                           WHERE  supplypointid = lu.SupplyPointID
                           AND    propertykey = 'NBREG'
                           AND    propvalchar = 'N')
            GROUP  BY lu.SupplyPointID
                     ,sp.propvalchar
                     ,NVL(tb.PropValNumber, Dt.TimeBandID);

        CURSOR cConsMP(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                      ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                      ,iDateFrom      IN DATE
                      ,iDateTo        IN DATE) IS
            WITH FullDates AS (
                SELECT dates.*,tr.*
                FROM   TimeSetVersion tsv
                      ,TimeRange tr
                      ,(SELECT jd.AsAtDate
                               ,to_char(jd.AsAtDate, 'DY') dow
                               ,to_char(jd.AsAtDate, 'MMDD') mmdd
                         FROM  (SELECT (iDateto - LEVEL + 1) AsAtDate
                                FROM   dual
                                CONNECT BY LEVEL <= (iDateto - iDatefrom + 1)) jd) dates
                WHERE  dates.AsAtDate >= tsv.dateactive
                AND   (tsv.Datedeactive IS NULL OR tsv.Datedeactive > dates.AsAtDate)
                AND    tsv.TimeSetID = iTimesetid
                AND    tsv.timesetversionid = tr.timesetversionid
                AND    dates.mmdd BETWEEN tr.startmmdd AND tr.endmmdd),
            Holidays AS (
                SELECT dates.*
                FROM   FullDates dates
                      ,CalendarEvent ce
                WHERE  ce.locationid IN (g_loc_country,g_loc_state)
                AND    dates.AsAtDate BETWEEN ce.datestart AND ce.dateend
                AND    ce.ceventtype = dates.ceventtype),
            NonHolidays AS (
                SELECT dates.*
                FROM   FullDates dates
                WHERE  dates.AsAtDate NOT IN (SELECT AsAtDate FROM Holidays)
                AND   ((dates.monflg = 'Y' AND dates.dow = 'MON')
                    OR (dates.tueflg = 'Y' AND dates.dow = 'TUE')
                    OR (dates.wedflg = 'Y' AND dates.dow = 'WED')
                    OR (dates.thuflg = 'Y' AND dates.dow = 'THU')
                    OR (dates.friflg = 'Y' AND dates.dow = 'FRI')
                    OR (dates.satflg = 'Y' AND dates.dow = 'SAT')
                    OR (dates.sunflg = 'Y' AND dates.dow = 'SUN'))),
            Flat_TimeSet AS (
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   NonHolidays
                UNION
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   Holidays)
            SELECT SUM(NVL(consumption, 0)) consumption
                  ,sp.propvalchar Consu
                  ,lu.SupplyPointID
                  ,NVL(tb.PropValNumber, Dt.TimeBandID) TimeBandID
            FROM   Flat_Timeset dt
                  ,SupplyPointLookup lu
                  ,SPProperty tb
                  ,spproperty sp
                  ,ReadingTOU t
            WHERE  lu.MPSPID = iSupplypointid
            AND    lu.DateStart < dt.ToTS
            AND    (lu.DateEnd IS NULL OR lu.DateEnd >= dt.FromTs)
            AND    sp.supplypointid = lu.SupplyPointID
            AND    sp.propertykey = 'CONSU'
            AND    sp.datestart <= iDateTo-- Note not "<=" because the timestamp is the end of the period
            AND   (sp.DateEnd IS NULL OR sp.DateEnd >= iDateFrom)
            AND    tb.SupplyPointID = lu.SupplyPointID
            AND    tb.PropertyKey = 'TIBAND'
            AND    t.timestamp BETWEEN dt.FromTS AND dt.ToTS
            AND    t.timestamp > sp.datestart                         ---
            AND   (sp.DateEnd IS NULL OR (sp.DateEnd+1/86400) >= t.timestamp)   ---
            AND    lu.DateStart < t.timestamp                         ---
            AND    (lu.DateEnd IS NULL OR (lu.DateEnd+1/86400) >= t.timestamp)  ---
            AND    t.SupplyPointID = lu.SupplyPointID
            AND    t.ProcessStatus = 'A'
            AND    t.PartKey = lu.PartKey
            AND    EXISTS (SELECT 0
                           FROM   spproperty
                           WHERE  supplypointid = lu.SupplyPointID
                           AND    propertykey = 'NBREG'
                           AND    propvalchar = 'N')
            GROUP  BY lu.SupplyPointID
                     ,sp.propvalchar
                     ,NVL(tb.PropValNumber, Dt.TimeBandID);

        CURSOR cConsMtr(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                       ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                       ,iDateFrom      IN DATE
                       ,iDateTo        IN DATE) IS
            WITH FullDates AS (
                SELECT dates.*,tr.*
                FROM   TimeSetVersion tsv
                      ,TimeRange tr
                      ,(SELECT jd.AsAtDate
                               ,to_char(jd.AsAtDate, 'DY') dow
                               ,to_char(jd.AsAtDate, 'MMDD') mmdd
                         FROM  (SELECT (iDateto - LEVEL + 1) AsAtDate
                                FROM   dual
                                CONNECT BY LEVEL <= (iDateto - iDatefrom + 1)) jd) dates
                WHERE  dates.AsAtDate >= tsv.dateactive
                AND   (tsv.Datedeactive IS NULL OR tsv.Datedeactive > dates.AsAtDate)
                AND    tsv.TimeSetID = iTimesetid
                AND    tsv.timesetversionid = tr.timesetversionid
                AND    dates.mmdd BETWEEN tr.startmmdd AND tr.endmmdd),
            Holidays AS (
                SELECT dates.*
                FROM   FullDates dates
                      ,CalendarEvent ce
                WHERE  ce.locationid IN (g_loc_country,g_loc_state)
                AND    dates.AsAtDate BETWEEN ce.datestart AND ce.dateend
                AND    ce.ceventtype = dates.ceventtype),
            NonHolidays AS (
                SELECT dates.*
                FROM   FullDates dates
                WHERE  dates.AsAtDate NOT IN (SELECT AsAtDate FROM Holidays)
                AND   ((dates.monflg = 'Y' AND dates.dow = 'MON')
                    OR (dates.tueflg = 'Y' AND dates.dow = 'TUE')
                    OR (dates.wedflg = 'Y' AND dates.dow = 'WED')
                    OR (dates.thuflg = 'Y' AND dates.dow = 'THU')
                    OR (dates.friflg = 'Y' AND dates.dow = 'FRI')
                    OR (dates.satflg = 'Y' AND dates.dow = 'SAT')
                    OR (dates.sunflg = 'Y' AND dates.dow = 'SUN'))),
            Flat_TimeSet AS (
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   NonHolidays
                UNION
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   Holidays)
            SELECT SUM(NVL(consumption, 0)) consumption
                  ,sp.propvalchar Consu
                  ,lu.SupplyPointID
                  ,NVL(tb.PropValNumber, Dt.TimeBandID) TimeBandID
            FROM  --TABLE (pkg_ami.TimeSetDetails(iTimeSetID,iDateFrom,iDateTo)) dt
                   Flat_TimeSet dt
                  ,SupplyPointLookup lu
                  ,SupplyPointLookup lu2
                  ,SPProperty tb
                  ,spproperty sp
                  ,ReadingTOU t
            WHERE  lu2.SupplyPointID = iSupplypointid
            AND   lu2.DateStart < dt.ToTS
            AND   (lu2.DateEnd IS NULL OR lu2.DateEnd >= dt.FromTs)
            AND    lu.SiteSPID = lu2.SiteSPID
            -- WR57786 Handle multiple MP under the same SITE
            --         With assumption of all register/meter under MP are for billing
            --         SE billing stays on MP level
            AND    lu.mpspid = lu2.mpspid
            AND    lu.DateStart <= dt.ToTS
            AND   (lu.DateEnd IS NULL OR lu.DateEnd >= dt.FromTs)
            AND    sp.supplypointid = lu.SupplyPointID
            AND    sp.propertykey = 'CONSU'
            -- Note not "<=" because the timestamp is the end of the period
            AND    sp.datestart <= iDateTo
            AND   (sp.DateEnd IS NULL OR sp.DateEnd >= iDateFrom)
            AND    tb.SupplyPointID = lu.SupplyPointID
            AND    tb.PropertyKey = 'TIBAND'
            AND    t.timestamp BETWEEN dt.FromTS AND dt.ToTS
            AND    t.timestamp > sp.datestart                         ---
            AND   (sp.DateEnd IS NULL OR (sp.DateEnd+1/86400) >= t.timestamp)   ---
            AND    lu.DateStart < t.timestamp                         ---
            AND    (lu.DateEnd IS NULL OR (lu.DateEnd+1/86400) >= t.timestamp)  ---
            AND    t.SupplyPointID = lu.SupplyPointID
            AND    t.ProcessStatus = 'A'
            AND    t.PartKey = lu.PartKey
            AND    EXISTS (SELECT 0
                           FROM   spproperty
                           WHERE  supplypointid = lu.SupplyPointID
                           AND    propertykey = 'NBREG'
                           AND    propvalchar = 'N')
            GROUP  BY lu.SupplyPointID
                     ,sp.propvalchar
                     ,NVL(tb.PropValNumber, Dt.TimeBandID);

        CURSOR cConsReg(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                     ,iTimeSetID       IN TimeSet.TimeSetID%TYPE
                     ,iDateFrom        IN DATE
                     ,iDateTo          IN DATE) IS
            WITH FullDates AS (
                SELECT dates.*,tr.*
                FROM   TimeSetVersion tsv
                      ,TimeRange tr
                      ,(SELECT jd.AsAtDate
                               ,to_char(jd.AsAtDate, 'DY') dow
                               ,to_char(jd.AsAtDate, 'MMDD') mmdd
                         FROM  (SELECT (iDateto - LEVEL + 1) AsAtDate
                                FROM   dual
                                CONNECT BY LEVEL <= (iDateto - iDatefrom + 1)) jd) dates
                WHERE  dates.AsAtDate >= tsv.dateactive
                AND   (tsv.Datedeactive IS NULL OR tsv.Datedeactive > dates.AsAtDate)
                AND    tsv.TimeSetID = iTimesetid
                AND    tsv.timesetversionid = tr.timesetversionid
                AND    dates.mmdd BETWEEN tr.startmmdd AND tr.endmmdd),
            Holidays AS (
                SELECT dates.*
                FROM   FullDates dates
                      ,CalendarEvent ce
                WHERE  ce.locationid IN (g_loc_country,g_loc_state)
                AND    dates.AsAtDate BETWEEN ce.datestart AND ce.dateend
                AND    ce.ceventtype = dates.ceventtype),
            NonHolidays AS (
                SELECT dates.*
                FROM   FullDates dates
                WHERE  dates.AsAtDate NOT IN (SELECT AsAtDate FROM Holidays)
                AND   ((dates.monflg = 'Y' AND dates.dow = 'MON')
                    OR (dates.tueflg = 'Y' AND dates.dow = 'TUE')
                    OR (dates.wedflg = 'Y' AND dates.dow = 'WED')
                    OR (dates.thuflg = 'Y' AND dates.dow = 'THU')
                    OR (dates.friflg = 'Y' AND dates.dow = 'FRI')
                    OR (dates.satflg = 'Y' AND dates.dow = 'SAT')
                    OR (dates.sunflg = 'Y' AND dates.dow = 'SUN'))),
            Flat_TimeSet AS (
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   NonHolidays
                UNION
                SELECT (AsAtDate + (timestartsecs + 1) / 86400) FromTS
                      ,(AsAtDate + timeendsecs / 86400) ToTS
                      ,TimeBandID
                FROM   Holidays)
            SELECT SUM(NVL(consumption, 0)) consumption
                  ,sp.propvalchar Consu
                  ,lu.SupplyPointID
                  ,NVL(tb.PropValNumber, Dt.TimeBandID) TimeBandID
            FROM  --TABLE (pkg_ami.TimeSetDetails(iTimeSetID,iDateFrom,iDateTo)) dt
                   Flat_TimeSet dt
                  ,SupplyPointLookup lu
                  ,SPProperty tb
                  ,spproperty sp
                  ,ReadingTOU t
            WHERE  lu.SupplyPointID = iSupplypointid
            AND    lu.DateStart < dt.ToTS
            AND   (lu.DateEnd IS NULL OR lu.DateEnd >= dt.FromTs)
            AND    sp.supplypointid = lu.SupplyPointID
            AND    sp.propertykey = 'CONSU'
            -- Note not "<=" because the timestamp is the end of the period
            AND    sp.datestart <= iDateTo
            AND   (sp.DateEnd IS NULL OR sp.DateEnd >= iDateFrom)
            AND    tb.SupplyPointID = lu.SupplyPointID
            AND    tb.PropertyKey = 'TIBAND'
            AND    t.timestamp BETWEEN dt.FromTS AND dt.ToTS
            AND    t.timestamp > sp.datestart                         ---
            AND   (sp.DateEnd IS NULL OR (sp.DateEnd+1/86400) >= t.timestamp)   ---
            AND    lu.DateStart < t.timestamp                         ---
            AND    (lu.DateEnd IS NULL OR (lu.DateEnd+1/86400) >= t.timestamp)  ---
            AND    t.SupplyPointID = lu.SupplyPointID
            AND    t.ProcessStatus = 'A'
            AND    t.PartKey = lu.PartKey
            AND    EXISTS (SELECT 0
                           FROM   spproperty
                           WHERE  supplypointid = lu.SupplyPointID
                           AND    propertykey = 'NBREG'
                           AND    propvalchar = 'N')
            GROUP  BY lu.SupplyPointID
                     ,sp.propvalchar
                     ,NVL(tb.PropValNumber, Dt.TimeBandID);
        l_Key VARCHAR2(100);
    BEGIN
        IF iMeterType LIKE 'SITE%' THEN
            FOR rec IN cConsSite(iSupplyPointID => iSupplyPointID
                                ,iTimeSetID     => iTimeSetID
                                ,iDateFrom      => iDateFrom
                                ,iDateTo        => iDateTo) LOOP
                l_Key := SaveCons(iInvSPID       => iSupplyPointID
                                 ,iSupplyPointID => rec.SupplyPointID
                                 ,iTimeSetID     => iTimeSetID
                                 ,iTimeBandID    => rec.TimeBandID
                                 ,iDateFrom      => iDateFrom
                                 ,iDateTo        => iDateTo
                                 ,iDST           => 'N'
                                 ,iSeasonID      => NULL
                                 ,iConsu         => rec.Consu
                                 ,iConsumption   => rec.Consumption
                                 ,iSource        => 'I'             -- WR99428
                                 ,ioCons         => ioCons);
            END LOOP;
        ELSIF iMeterType LIKE 'MP%' THEN
            FOR rec IN cConsMP(iSupplyPointID => iSupplyPointID
                              ,iTimeSetID     => iTimeSetID
                              ,iDateFrom      => iDateFrom
                              ,iDateTo        => iDateTo) LOOP
                l_Key := SaveCons(iInvSPID       => iSupplyPointID
                                 ,iSupplyPointID => rec.SupplyPointID
                                 ,iTimeSetID     => iTimeSetID
                                 ,iTimeBandID    => rec.TimeBandID
                                 ,iDateFrom      => iDateFrom
                                 ,iDateTo        => iDateTo
                                 ,iDST           => 'N'
                                 ,iSeasonID      => NULL
                                 ,iConsu         => rec.Consu
                                 ,iConsumption   => rec.Consumption
                                 ,iSource        => 'I'             -- WR99428
                                 ,ioCons         => ioCons);
            END LOOP;
        ELSIF iMeterType IN ('TOUR','TOU') THEN
            FOR rec IN cConsReg(iSupplyPointID => iSupplyPointID
                               ,iTimeSetID     => iTimeSetID
                               ,iDateFrom      => iDateFrom
                               ,iDateTo        => iDateTo) LOOP
                l_Key := SaveCons(iInvSPID       => iSupplyPointID
                                 ,iSupplyPointID => rec.SupplyPointID
                                 ,iTimeSetID     => iTimeSetID
                                 ,iTimeBandID    => rec.TimeBandID
                                 ,iDateFrom      => iDateFrom
                                 ,iDateTo        => iDateTo
                                 ,iDST           => 'N'
                                 ,iSeasonID      => NULL
                                 ,iConsu         => rec.Consu
                                 ,iConsumption   => rec.Consumption
                                 ,iSource        => 'I'             -- WR99428
                                 ,ioCons         => ioCons);
            END LOOP;
        ELSE
            FOR rec IN cConsMtr(iSupplyPointID => iSupplyPointID
                               ,iTimeSetID     => iTimeSetID
                               ,iDateFrom      => iDateFrom
                               ,iDateTo        => iDateTo) LOOP
                l_Key := SaveCons(iInvSPID       => iSupplyPointID
                                 ,iSupplyPointID => rec.SupplyPointID
                                 ,iTimeSetID     => iTimeSetID
                                 ,iTimeBandID    => rec.TimeBandID
                                 ,iDateFrom      => iDateFrom
                                 ,iDateTo        => iDateTo
                                 ,iDST           => 'N'
                                 ,iSeasonID      => NULL
                                 ,iConsu         => rec.Consu
                                 ,iConsumption   => rec.Consumption
                                 ,iSource        => 'I'             -- WR99428
                                 ,ioCons         => ioCons);
            END LOOP;
        END IF;
    END;

    --------------------------------------------------------------------------
    PROCEDURE Cons_By_UDST_Season(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                                 ,iSeasonID      IN Season.SeasonID%TYPE
                                 ,iDateFrom      IN DATE
                                 ,iDateTo        IN DATE
                                 ,ioCons         IN OUT NOCOPY trCons) IS
        CURSOR cCons IS
            SELECT SUM(consumption) Consumption
                  ,sp.PropValChar   consu
                  ,lu.SupplyPointID
                  ,tb.PropValNumber TimeBandID
            FROM   ReadingTOU        t
                  ,SupplyPointLookup lu
                  ,SupplyPointLookup lu2
                  ,SPProperty sp
                  ,SPProperty tb
            WHERE  t.SupplyPointID = lu.SupplyPointID
            AND    t.processstatus = 'A'
            AND    t.PartKey = lu.PartKey
            AND    t.timestamp > lu.datestart -- Note not "<=" because the timestamp is the end of the period
            AND   (lu.DateEnd IS NULL OR lu.DateEnd >= t.timestamp)
            AND    lu2.sitespid = lu.sitespid
            -- WR57786 Handle multiple MP under the same SITE
            --         With assumption of all register/meter under MP are for billing
            --         SE billing stays on MP level
            AND    lu2.mpspid = lu.mpspid
            AND    lu2.Supplypointid = iSupplypointid
            AND    NVL(t.timestampds, t.timestamp) > iDatefrom
            AND    NVL(t.timestampds, t.timestamp) <= iDateto + 1
            AND    sp.supplypointid = lu.SupplyPointID
            AND    sp.propertykey = 'CONSU'
            -- Note not "<=" because the timestamp is the end of the period
            AND    NVL(t.timestampds, t.timestamp) > sp.datestart
            AND   (sp.DateEnd IS NULL OR sp.DateEnd >= NVL(t.timestampds, t.timestamp))
            AND    EXISTS (SELECT 1
                           FROM   SEASONDETAIL SD
                           WHERE  SUBSTR(SD.MONFLG || SD.TUEFLG || SD.WEDFLG || SD.THUFLG || SD.FRIFLG || SD.SATFLG || SD.SUNFLG
                                        ,TO_CHAR(NVL(t.TimestampDS, t.timestamp) - 86400,'D') + 0,1) = 'Y'
                           AND    TO_CHAR(NVL(t.TimestampDS, t.timestamp) - 1 / 86400,'MMDD') BETWEEN SD.STARTMMDD AND SD.ENDMMDD
                           AND    SD.SEASONID = iSeasonid)
            AND    tb.SupplyPointID = lu.SupplyPointID
            AND    tb.PropertyKey = 'TIBAND'
            GROUP  BY lu.SupplyPointID
                     ,sp.propvalchar
                     ,tb.PropValNumber;
        l_Key VARCHAR2(100);
    BEGIN
        FOR rec IN cCons LOOP
            l_Key := SaveCons(iInvSPID       => iSupplyPointID
                             ,iSupplyPointID => rec.SupplyPointID
                             ,iTimeSetID     => NULL
                             ,iTimeBandID    => rec.TimeBandID
                             ,iDateFrom      => iDateFrom
                             ,iDateTo        => iDateTo
                             ,iDST           => 'Y'
                             ,iSeasonID      => iSeasonID
                             ,iConsu         => rec.Consu
                             ,iConsumption   => rec.Consumption
                             ,iSource        => 'I'             -- WR99428
                             ,ioCons         => ioCons);
        END LOOP;
    END;

    --------------------------------------------------------------------------
    -- WR80414. Merge the performance enhancement code from proceudre Cons_All (released in WR58668)
    -- The only difference between these two cursors should be timestampds vs timestamp
    PROCEDURE Cons_By_UDST(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                          ,iDateFrom      IN DATE
                          ,iDateTo        IN DATE
                          ,ioCons         IN OUT NOCOPY trCons) IS
        CURSOR cCons IS
            SELECT SUM (NVL (t.consumption, 0))  AS consumption  -- Wr 58668 Alternative form of query to improve performance
                  ,ref.consu
                  ,ref.supplypointid
                  ,ref.tiband                    AS timebandid
            FROM   (-- get the register standing data first.  only expect a few rows
                    SELECT lu.supplypointid
                          ,lu.metertype
                          ,GREATEST(iDateFrom,lu.datestart,consu.datestart) AS datefrom
                          ,LEAST(iDateTo,NVL(lu.dateend,iDateTo),NVL (consu.dateend,iDateTo)) AS dateto
                          ,lu.partkey
                          ,consu.propvalchar  AS consu
                          ,tiband.propvalnumber AS tiband -- wr61535
                    FROM   supplypointlookup lu2
                    JOIN   supplypointlookup lu  ON  lu.sitespid          = lu2.sitespid
                                                 AND lu.mpspid            = lu2.mpspid
                    JOIN   spproperty consu      ON  consu.supplypointid  = lu.supplypointid
                    JOIN   spproperty tiband     ON  tiband.supplypointid = lu.supplypointid
                    WHERE  lu2.supplypointid    =  iSupplyPointID
                    AND    consu.propertykey    =  'CONSU'
                    AND    consu.datestart      <= LEAST (NVL(lu.dateend, iDateTo),iDateTo)
                    AND    (consu.dateend IS NULL OR consu.dateend >= GREATEST(lu.datestart,iDateFrom))
                    AND    tiband.propertykey   =  'TIBAND'
                    AND    EXISTS (SELECT 0
                                   FROM   spproperty nbreg
                                   WHERE  nbreg.supplypointid = lu.supplypointid
                                   AND    propertykey         = 'NBREG'
                                   AND    propvalchar         = 'N')
                   ) REF
            JOIN   readingtou t ON  t.supplypointid = ref.supplypointid
                                AND t.partkey       = ref.partkey
            WHERE  t.processstatus =  'A'
            AND    NVL(t.timestampds, t.timestamp) >  ref.datefrom            -- date from should not have a time part
            AND    NVL(t.timestampds, t.timestamp) <= TRUNC (ref.dateto) + 1  -- date to from date effective properties will have a time part when nont null
            GROUP BY ref.supplypointid
                    ,ref.consu
                    ,ref.tiband;
        l_Key VARCHAR2(100);
    BEGIN
        FOR rec IN cCons LOOP
            l_Key := SaveCons(iInvSPID       => iSupplyPointID
                             ,iSupplyPointID => rec.SupplyPointID
                             ,iTimeSetID     => NULL
                             ,iTimeBandID    => rec.TimeBandID
                             ,iDateFrom      => iDateFrom
                             ,iDateTo        => iDateTo
                             ,iDST           => 'Y'
                             ,iSeasonID      => NULL
                             ,iConsu         => rec.Consu
                             ,iConsumption   => rec.Consumption
                             ,iSource        => 'I'             -- WR99428
                             ,ioCons         => ioCons);
        END LOOP;
    END;

    --------------------------------------------------------------------------
    PROCEDURE Cons_By_Season(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                            ,iSeasonID      IN Season.SeasonID%TYPE
                            ,iDateFrom      IN DATE
                            ,iDateTo        IN DATE
                            ,ioCons         IN OUT NOCOPY trCons) IS
        CURSOR cCons IS
            SELECT SUM(consumption) Consumption
                  ,sp.PropValChar consu
                  ,lu.SupplyPointID
                  ,tb.PropValNumber TimeBandID
            FROM   ReadingTOU        t
                  ,SupplyPointLookup lu
                  ,SupplyPointLookup lu2
                  ,SPProperty sp
                  ,SPProperty tb
            WHERE  t.SupplyPointID = lu.SupplyPointID
            AND    t.processstatus = 'A'
            AND    t.PartKey = lu.PartKey
            AND    t.timestamp > lu.datestart -- Note not "<=" because the timestamp is the end of the period
            AND   (lu.DateEnd IS NULL OR lu.DateEnd >= t.timestamp)
            AND    lu2.sitespid = lu.sitespid
            -- WR57786 Handle multiple MP under the same SITE
            --         With assumption of all register/meter under MP are for billing
            --         SE billing stays on MP level
            AND    lu2.mpspid = lu.mpspid
            AND    lu2.Supplypointid = iSupplypointid
            AND    t.timestamp > iDatefrom
            AND    t.timestamp <= iDateto + 1
            AND    sp.supplypointid = lu.SupplyPointID
            AND    sp.propertykey = 'CONSU'
            AND    t.timestamp > sp.datestart -- Note not "<=" because the timestamp is the end of the period
            AND   (sp.DateEnd IS NULL OR sp.DateEnd >= t.timestamp)
            AND    EXISTS (SELECT 1
                           FROM   SEASONDETAIL SD
                           WHERE  SUBSTR(SD.MONFLG || SD.TUEFLG || SD.WEDFLG || SD.THUFLG || SD.FRIFLG || SD.SATFLG || SD.SUNFLG
                                        ,TO_CHAR(t.timestamp - 86400, 'D') + 0,1) = 'Y'
                           AND    TO_CHAR(t.timestamp - 1 / 86400, 'MMDD') BETWEEN SD.STARTMMDD AND SD.ENDMMDD
                           AND    SD.SEASONID = iSeasonid)
            AND    tb.SupplyPointID = lu.SupplyPointID
            AND    tb.PropertyKey = 'TIBAND'
            GROUP  BY lu.SupplyPointID
                     ,sp.propvalchar
                     ,tb.PropValNumber;
        l_Key VARCHAR2(100);
    BEGIN
        FOR rec IN cCons LOOP
            l_Key := SaveCons(iInvSPID       => iSupplyPointID
                             ,iSupplyPointID => rec.SupplyPointID
                             ,iTimeSetID     => NULL
                             ,iTimeBandID    => rec.TimeBandID
                             ,iDateFrom      => iDateFrom
                             ,iDateTo        => iDateTo
                             ,iDST           => 'N'
                             ,iSeasonID      => iSeasonID
                             ,iConsu         => rec.Consu
                             ,iConsumption   => rec.Consumption
                             ,iSource        => 'I'             -- WR99428
                             ,ioCons         => ioCons);
        END LOOP;
    END;

    --------------------------------------------------------------------------
    PROCEDURE Cons_All(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                      ,iDateFrom      IN DATE
                      ,iDateTo        IN DATE
                      ,ioCons         IN OUT NOCOPY trCons) IS
        CURSOR cCons IS
            SELECT SUM (NVL (t.consumption, 0))  AS consumption  -- Wr 58668 Alternative form of query to improve performance
                  ,ref.consu
                  ,ref.supplypointid
                  ,ref.tiband                    AS timebandid
            FROM   (-- get the register standing data first.  only expect a few rows
                    SELECT lu.supplypointid
                          ,lu.metertype
                          ,GREATEST(iDateFrom,lu.datestart,consu.datestart) AS datefrom
                          ,LEAST(iDateTo,NVL(lu.dateend,iDateTo),NVL (consu.dateend,iDateTo)) AS dateto
                          ,lu.partkey
                          ,consu.propvalchar  AS consu
                          ,tiband.propvalnumber AS tiband -- wr61535
                    FROM   supplypointlookup lu2
                    JOIN   supplypointlookup lu  ON  lu.sitespid          = lu2.sitespid
                                                 AND lu.mpspid            = lu2.mpspid
                    JOIN   spproperty consu      ON  consu.supplypointid  = lu.supplypointid
                    JOIN   spproperty tiband     ON  tiband.supplypointid = lu.supplypointid
                    WHERE  lu2.supplypointid    =  iSupplyPointID
                    AND    consu.propertykey    =  'CONSU'
                    AND    consu.datestart      <= LEAST (NVL(lu.dateend, iDateTo),iDateTo)
                    AND    (consu.dateend IS NULL OR consu.dateend >= GREATEST(lu.datestart,iDateFrom))
                    AND    tiband.propertykey   =  'TIBAND'
                    AND    EXISTS (SELECT 0
                                   FROM   spproperty nbreg
                                   WHERE  nbreg.supplypointid = lu.supplypointid
                                   AND    propertykey         = 'NBREG'
                                   AND    propvalchar         = 'N')
                   ) REF
            JOIN   readingtou t ON  t.supplypointid = ref.supplypointid
                                AND t.partkey       = ref.partkey
            WHERE  t.processstatus =  'A'
            AND    t.timestamp     >  ref.datefrom            -- date from should not have a time part
            AND    t.timestamp     <= TRUNC (ref.dateto) + 1  -- date to from date effective properties will have a time part when nont null
            GROUP BY ref.supplypointid
                    ,ref.consu
                    ,ref.tiband;
        l_Key VARCHAR2(100);
    BEGIN
        FOR rec IN cCons LOOP
            l_Key := SaveCons(iInvSPID       => iSupplyPointID
                             ,iSupplyPointID => rec.SupplyPointID
                             ,iTimeSetID     => NULL
                             ,iTimeBandID    => rec.TimeBandID
                             ,iDateFrom      => iDateFrom
                             ,iDateTo        => iDateTo
                             ,iDST           => 'N'
                             ,iSeasonID      => NULL
                             ,iConsu         => rec.Consu
                             ,iConsumption   => rec.Consumption
                             ,iSource        => 'I'             -- WR99428
                             ,ioCons         => ioCons);
        END LOOP;
    END;

    --------------------------------------------------------------------------
    --
    -- WR55825 Capacity for processing basic readings
    --         Aggregate ECA consumption for basic readings
    --
    PROCEDURE Cons_Basic(iSupplyPointID IN SupplyPoint.SupplyPointID%TYPE
                        ,iDateFrom      IN DATE
                        ,iDateTo        IN DATE
                        ,iTimeSetID     IN TimeSet.TimeSetID%TYPE
                        ,iUDST          IN VARCHAR2
                        ,iSeasonID      IN Season.SeasonID%TYPE
                        ,iSEFRMPStart   IN DATE                       -- WR69667
                        -- WR57931 Implement creation of DumbAccum
                        ,oDumbCons      IN OUT t2dDumbCons
                        ,ioCons         IN OUT NOCOPY trCons) IS

        CURSOR cRdgdumbCons(iSpId       supplypoint.supplypointid%TYPE
                           ,iSDate      readingdumb.timestamp%TYPE
                           ,iEDate      readingdumb.timestamp%TYPE
                           ,iEDatePlus1 readingdumb.timestamp%TYPE
                           ,iRdgCloseBP VARCHAR2) IS
            -- WR57954 Pick up basic readings with timestamp earlier than billing end date
            WITH ALLSPID AS (-- all supplypoints on site
                             SELECT lu2.supplypointid
                             FROM   supplypointlookup lu
                             JOIN   supplypointlookup lu2 ON  lu2.sitespid = lu.sitespid
                                                          -- WR57786 Handle multiple MP under the same SITE
                                                          --         With assumption of all register/meter under MP are for billing
                                                          --         SE billing stays on MP level
                                                          AND lu2.mpspid = lu.mpspid
                             WHERE  lu.supplypointid = iSpId
                             AND    lu2.datestart < iEDatePlus1
                             AND   (lu2.dateend IS NULL OR lu2.dateend >= g_BillFrom /*iSDate*/))
            SELECT SpId
                  ,RdgdumbId
                  ,CASE iRdgCloseBP
                       WHEN 'Y' THEN --StartDate + 1 -- WR119768
                           Case when trunc(StartDate) = g_BillFrom
                                     and (prvCons is null or trunc(StartDate) = iSEFRMPStart) Then g_BillFrom
                                Else StartDate + 1
                                End
                       ELSE StartDate
                   END  AS StartDate
                  ,EndDate
                  ,tb.propvalnumber  AS TimebandId
                  ,Consumption
                  ,ConsumptionBase
                  ,ru.propvalchar AS SPUnit
                  ,mt.baseunit    AS BaseUnit
            FROM  (SELECT r.supplypointid  AS SpId
                         ,r.readingdumbid  AS RdgdumbId
                         ,(SELECT TRUNC(MAX(rs.timestamp))
                           FROM   readingdumb rs
                           WHERE  rs.supplypointid = r.supplypointid
                           AND    rs.timestamp < r.timestamp
                           AND    rs.processstatus = 'A')  AS StartDate
                         ,CASE iRdgCloseBP
                              WHEN 'Y' THEN TRUNC(r.timestamp)
                              ELSE TRUNC(r.timestamp) - 1
                          END  AS EndDate
                         -- WR57931 Use ReadingDumb.ConsumptionBase instead of ReadingDumb.Consumption
                         ,r.consumptionbase  AS ConsumptionBase
                         ,r.consumption  AS Consumption
                         ,lag(r.consumption) over(partition by r.supplypointid order by r.timestamp asc nulls first) prvCons -- WR119768
                   FROM  (-- WR57954 Pick up basic readings with timestamp earlier than billing end date
                          SELECT supplypointid
                                ,MAX(endtimestamp) AS EndTS
                          FROM  (SELECT re.supplypointid
                                       ,MIN(re.timestamp) AS endtimestamp
                                 FROM   ALLSPID sp
                                 JOIN   readingdumb re ON  re.supplypointid = sp.supplypointid
                                                       AND re.timestamp >= iEDate
                                                       AND re.processstatus = 'A'
                                 GROUP BY re.supplypointid
                                 UNION
                                 SELECT re.supplypointid
                                       ,MAX(re.timestamp) AS endtimestamp
                                 FROM   ALLSPID sp
                                 JOIN   readingdumb re ON  re.supplypointid = sp.supplypointid
                                                       AND re.timestamp < iEDate
                                                       AND re.timestamp >= iSDate
                                                       AND re.processstatus = 'A'
                                 GROUP BY re.supplypointid)
                          GROUP BY supplypointid) sr
                   JOIN  readingdumb r ON  r.supplypointid = sr.supplypointid
                                       AND r.timestamp >= iSDate
                                       AND r.timestamp <= sr.EndTS
                                       AND r.processstatus = 'A') sr2
            -- WR57931 Use MeterType.BaseUnit instead of SPProperty READU
            JOIN supplypoint spt    ON  spt.supplypointid = sr2.SpId
            JOIN metertype mt       ON  mt.metertype = spt.metertype
            LEFT JOIN spproperty tb ON  tb.supplypointid = sr2.SpId
                                    AND tb.propertykey = 'TIBAND'
            LEFT JOIN spproperty ru ON  ru.supplypointid = sr2.SpId
                                    AND ru.propertykey = 'READU'
            ORDER  BY SpId
                     ,EndDate;

        l_Key  VARCHAR2(100);
        l_SPID SupplyPoint.SupplyPointID%TYPE;

        -- WR57931 Implement creation of DumbAccum
        l_ProRateDumbCons NUMBER;
        l_RdgConsKey      VARCHAR2(100);
        --l_FoundIdx        PLS_INTEGER;
        l_PrevDumbRdg     ReadingDumb.ReadingDumbID%TYPE;
        l_NextSeq         PLS_INTEGER;

        -- WR58161
        l_DumbCons        NUMBER;
        l_DumbConsUnit    VARCHAR2(30);
        l_StartDate       DATE;
        l_EndDate         DATE;
        l_ConvHVF         NUMBER;
        l_ConvPCF         NUMBER;

        TYPE taConsIdxByInt IS TABLE OF NUMBER       INDEX BY BINARY_INTEGER;
        TYPE taIntIdxByInt  IS TABLE OF PLS_INTEGER  INDEX BY BINARY_INTEGER;
        TYPE taDateIdxByInt IS TABLE OF DATE         INDEX BY BINARY_INTEGER;
        TYPE taVC30IdxByInt IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;

        TYPE trConsIdxByInt IS RECORD
            (StartDate   taDateIdxByInt
            ,EndDate     taDateIdxByInt
            ,TimeBandID  taIntIdxByInt
            ,ConsUnit    taVC30IdxByInt
            ,Consumption taConsIdxByInt);

        lr_RdgDumbCons trConsIdxByInt;

        PROCEDURE EmptyArrray IS
        BEGIN
            lr_RdgDumbCons.StartDate.DELETE;
            lr_RdgDumbCons.EndDate.DELETE;
            lr_RdgDumbCons.TimeBandID.DELETE;
            lr_RdgDumbCons.ConsUnit.DELETE;
            lr_RdgDumbCons.Consumption.DELETE;
        END EmptyArrray;

        -- WR57931 Find previous readingdumbid
        FUNCTION PrevDumbRdg(iRdgID IN ReadingDumb.ReadingDumbID%TYPE, iSE_FRMP_Start IN DATE)
                                    RETURN ReadingDumb.ReadingDumbID%TYPE IS
            l_return  ReadingDumb.ReadingDumbID%TYPE;
        BEGIN
            BEGIN
                SELECT rd.readingdumbid
                INTO   l_return
                FROM   (SELECT rd2.supplypointid
                              ,MAX(rd2.timestamp) AS prevrdgdate
                        FROM   ReadingDumb rd1
                        JOIN   ReadingDumb rd2 ON  rd2.supplypointid = rd1.supplypointid
                                               AND rd1. readingdumbid = iRdgID
                                               AND rd2.timestamp < rd1.timestamp
                                               AND rd2.timestamp >= TRUNC(iSE_FRMP_Start)   -- WR69667
                                               AND rd2.processstatus = 'A'
                        GROUP  BY rd2.supplypointid) rdp
                JOIN   ReadingDumb rd ON  rd.supplypointid = rdp.supplypointid
                                      AND rd.TIMESTAMP = rdp.prevrdgdate
                                      AND rd.processstatus = 'A';
            EXCEPTION
                WHEN OTHERS THEN
                    l_return := NULL;
            END;
            --
            RETURN l_return;
        END PrevDumbRdg;

        -- This function is used to find the register start date to replace the missing reading start date
        -- The most possible reading with missing start date should be the first reading when SP is created
        FUNCTION GetSPStartDate(iSPID IN SupplyPointLookUp.Supplypointid%TYPE)
                                      RETURN DATE IS
            l_return DATE;
        BEGIN
            l_return := NULL;
            --
            BEGIN
                -- Find the earliest start date
                SELECT MIN(lu.datestart)
                INTO   l_return
                FROM   SupplyPointLookUp lu
                WHERE  lu.supplypointid = iSPID;
            EXCEPTION
                WHEN OTHERS THEN
                   l_return := NULL;
            END;
            --
            RETURN l_return;
        END GetSPStartDate;

        FUNCTION ProRateDumbCons(iECASDate IN DATE
                                ,iECAEDate IN DATE
                                ,iRdgSDate IN DATE
                                ,iRdgEDate IN DATE
                                ,iRdgCons  IN NUMBER)
                                           RETURN NUMBER IS
            l_return          NUMBER;
            Period_of_Overlap NUMBER;
            Period_of_Reading NUMBER;
        BEGIN
            l_return := 0;
            --
            IF iECASDate IS NOT NULL AND
               iECAEDate IS NOT NULL AND
               iRdgSDate IS NOT NULL AND
               iRdgEDate IS NOT NULL AND
               iRdgCons IS NOT NULL
            THEN
                --
                Period_of_Overlap := LEAST(TRUNC(iECAEDate)
                                          ,TRUNC(iRdgEDate)) - GREATEST(TRUNC(iECASDate)
                                                                       ,TRUNC(iRdgSDate)) + 1;  -- +1 is needed because all dates are inclusive
                Period_of_Reading := TRUNC(iRdgEDate) - TRUNC(iRdgSDate) + 1;  -- +1 is needed because all dates are inclusive
                -- WR58161 Negative overlap indicates no overlap
                IF Period_of_Overlap > 0 THEN
                    l_return := iRdgCons * Period_of_Overlap / Period_of_Reading;
                END IF;
            END IF;
            --
            RETURN l_return;
        END ProRateDumbCons;
    BEGIN
        --
        EmptyArrray;
        --
        -- Wr 57522  Performance Improvement
        --dbms_output.put_line ('ConsBasic iSupplyPointID=' || iSupplyPointID ||', iDateFrom=' || iDateFrom ||', iDateTo=' || iDateTo);
        --FOR rec IN cRdgDumbCons(iSupplyPointID, iDateFrom, iDateTo) LOOP
        FOR rec IN cRdgDumbCons(iSupplyPointID
                               ,TRUNC(iDateFrom)
                               ,TRUNC(iDateTo)
                               ,TRUNC(iDateTo) + 1
                               ,g_RdgCloseBP) LOOP
            -- WR58161
            l_StartDate := NVL(rec.StartDate, GetSPStartDate(rec.SPID));
            l_EndDate   := rec.EndDate;
            --
            -- WR58161 Always convert consumption to basic unit
            --         If consumptionbase available, use consumptionbase and baseunit
            --         If not, convert it using base unit
            --
            l_DumbConsUnit := rec.BaseUnit;
            --
            IF rec.ConsumptionBase IS NOT NULL THEN
                l_DumbCons := rec.ConsumptionBase;
            ELSE
                IF rec.BaseUnit = rec.SPUnit THEN
                    l_DumbCons := NVL(rec.Consumption, 0);
                ELSE
                    l_DumbCons := 0;
                    --
                    IF rec.Consumption <> 0 THEN
                        pkg_accum.convert_consumption3(iconsumption   => rec.Consumption
                                                      ,ilossadjcons   => NULL
                                                      ,irp_units      => rec.BaseUnit
                                                      ,isp_units      => rec.SPUnit
                                                      ,idatefrom      => l_StartDate
                                                      ,idateto        => l_EndDate
                                                      ,oconsumption   => l_DumbCons
                                                      ,oerrorcode     => l_UsageErrorCode
                                                      ,oerrordescr    => l_ErrorMessage
                                                      ,ohvf           => l_ConvHVF
                                                      ,opcf           => l_ConvPCF
                                                      ,ihvarea        => NULL
                                                      ,ihvunit        => NULL
                                                      ,irdpday        => 1
                                                      ,ipcf           => NULL
                                                      ,ipwrf          => NULL
                                                      ,isupplypointid => rec.SPID);
                        IF l_UsageErrorCode IS NOT NULL THEN
                            Raise_Application_Error(-20012
                                                   ,'Basic Consumption Coversion Failed, SPID = ' || rec.SPID ||
                                                    ', RPUnit = ' || rec.BaseUnit || ', SPUnit = ' || rec.SPUnit);
                        END IF;
                    END IF;
                END IF;
            END IF;
            --
            IF NOT lr_RdgDumbCons.EndDate.EXISTS(rec.SPID) THEN
                -- New entry
                -- StartDate may be NULL when this is the first reading
                -- Replace with the start date of register
                lr_RdgDumbCons.StartDate(rec.SPID)  := l_StartDate;
                lr_RdgDumbCons.EndDate(rec.SPID)    := l_EndDate;
                lr_RdgDumbCons.TimeBandID(rec.SPID) := rec.TimeBandID;
                lr_RdgDumbCons.ConsUnit(rec.SPID)   := l_DumbConsUnit;
                --
                l_ProRateDumbCons := ProRateDumbCons(iECASDate => iDateFrom
                                                    ,iECAEDate => iDateTo
                                                    ,iRdgSDate => l_StartDate
                                                    ,iRdgEDate => l_EndDate
                                                    ,iRdgCons  => l_DumbCons);
                lr_RdgDumbCons.Consumption(rec.SPID) := l_ProRateDumbCons;
            ELSE
                -- Existing entry
                -- Update consumption
                l_ProRateDumbCons := ProRateDumbCons(iECASDate => iDateFrom
                                                    ,iECAEDate => iDateTo
                                                    ,iRdgSDate => l_StartDate
                                                    ,iRdgEDate => l_EndDate
                                                    ,iRdgCons  => l_DumbCons);
                lr_RdgDumbCons.Consumption(rec.SPID) := lr_RdgDumbCons.Consumption(rec.SPID) + l_ProRateDumbCons;
            END IF;
            --
            -- WR57931 Implement creation of DumbAccum
            --         For each cons entry, create a list of readingdumbid and how much cons contributed
            -- e.g. oDumbCons(2641460_21_20080903000000_20081002000000_N__1_2698067_KWH).RdgDumbID(1) = 2324421
            --      oDumbCons(2641460_21_20080903000000_20081002000000_N__1_2698067_KWH).Consumption(1) = 88.5
            --
            l_RdgConsKey := BuildKey(iInvSPID       => iSupplyPointID
                                    ,iSupplyPointID => rec.SPID
                                    ,iTimeSetID     => iTimeSetID
                                    ,iTimeBandID    => rec.TimeBandID
                                    ,iDateFrom      => iDateFrom
                                    ,iDateTo        => iDateTo
                                    ,iDST           => iUDST
                                    ,iSeasonID      => iSeasonID
                                    ,iConsu         => l_DumbConsUnit);
            IF oDumbCons.EXISTS(l_RdgConsKey) THEN
                -- Existing entry
                l_NextSeq := oDumbCons(l_RdgConsKey).RdgDumbID.COUNT + 1;
                oDumbCons(l_RdgConsKey).RdgDumbID(l_NextSeq)   := rec.rdgdumbid;
                oDumbCons(l_RdgConsKey).Consumption(l_NextSeq) := l_ProRateDumbCons;
            ELSE
                -- New entry
                -- We need to insert the previous reading of first reading as first linkage
                l_PrevDumbRdg := PrevDumbRdg(rec.rdgdumbid
                                            ,iSEFRMPStart);   -- WR69667
                --
                IF l_PrevDumbRdg IS NOT NULL THEN
                    oDumbCons(l_RdgConsKey).RdgDumbID(1)   := l_PrevDumbRdg;
                    oDumbCons(l_RdgConsKey).Consumption(1) := NULL;  -- previous reading contribute NULL/0 cons
                END IF;
                --
                IF oDumbCons.EXISTS(l_RdgConsKey) THEN
                    l_NextSeq := oDumbCons(l_RdgConsKey).RdgDumbID.COUNT + 1;
                ELSE
                    l_NextSeq := 1;
                END IF;
                --
                oDumbCons(l_RdgConsKey).RdgDumbID(l_NextSeq)   := rec.rdgdumbid;
                oDumbCons(l_RdgConsKey).Consumption(l_NextSeq) := l_ProRateDumbCons;
            END IF;
        END LOOP;
        --
        IF lr_RdgDumbCons.EndDate.COUNT > 0 THEN
            l_SPID := lr_RdgDumbCons.EndDate.FIRST;
            FOR i IN 1 .. lr_RdgDumbCons.EndDate.COUNT LOOP
                /*IF g_debug THEN
                    Pkg_Util.putbuf('Cons_Basic -> SaveCons - iInvSPID = ' || iSupplyPointID    ||
                                    ', iSupplyPointID = ' || l_SPID                             ||
                                    ', iTimeSetID = '     || iTimeSetID                         ||
                                    ', TimeBandID = '     || lr_RdgDumbCons.TimeBandID(l_SPID)  ||
                                    ', iDateFrom = '      || iDateFrom                          ||
                                    ', iDateTo = '        || iDateTo                            ||
                                    ', iDST = '           || iUDST                              ||
                                    ', iSeasonID = '      || iSeasonID                          ||
                                    ', iConsu = '         || lr_RdgDumbCons.ConsUnit(l_SPID)    ||
                                    ', iConsumption = '   || lr_RdgDumbCons.Consumption(l_SPID)
                                   ,255
                                   ,NULL);
                END IF;*/
                l_Key := SaveCons(iInvSPID       => iSupplyPointID
                                 ,iSupplyPointID => l_SPID
                                 ,iTimeSetID     => iTimeSetID
                                 ,iTimeBandID    => lr_RdgDumbCons.TimeBandID(l_SPID)
                                 ,iDateFrom      => iDateFrom
                                 ,iDateTo        => iDateTo
                                 ,iDST           => iUDST
                                 ,iSeasonID      => iSeasonID
                                 ,iConsu         => lr_RdgDumbCons.ConsUnit(l_SPID)
                                 ,iConsumption   => lr_RdgDumbCons.Consumption(l_SPID)
                                 ,iSource        => 'B'             -- WR99428
                                 ,ioCons         => ioCons);
                l_SPID := lr_RdgDumbCons.EndDate.NEXT(l_SPID);
                EXIT WHEN l_SPID IS NULL;
            END LOOP;
        END IF;
    END Cons_Basic;

    --------------------------------------------------------------------------
    --
    -- WR55825 Capacity for processing basic readings
    --         Get utility type for supplypointid
    --
    FUNCTION GetUtilityType(iSPID IN PLS_INTEGER)
                                  RETURN VARCHAR2 IS
        l_return VARCHAR2(2);
    BEGIN
        l_return := NULL;
        -- Find Meter Point utility type
        BEGIN
            SELECT DISTINCT t.utilitytype
            INTO   l_return
            FROM   supplypoint       s
                  ,SupplyPointLookup lu
                  ,SupplyPointLookup lu2
                  ,metertype         t
            WHERE  s.supplypointid = lu.SupplyPointID
            AND    s.metertype LIKE 'MP%'
            AND    lu2.sitespid = lu.sitespid
            -- WR57786 Handle multiple MP under the same SITE
            AND    lu2.mpspid = lu.mpspid
            AND    lu2.Supplypointid = iSPID
            AND    s.metertype = t.metertype;
        EXCEPTION
            WHEN OTHERS THEN
                l_return := NULL;
        END;
        --
        RETURN l_return;
    END GetUtilityType;

    --------------------------------------------------------------------------
    --
    -- WR55825 Enhancement of splitting on a loss factor change
    --         For both basic and interval readings, Electricity only
    --
    --      Populate Factor1 and Factor2 for ECA records:
    --      1. Gas - only for basic
    --         Factor1 = Heating Value from the ReadingDumb row and
    --         Factor2 = PCF from the readingdumb row.
    --         If multiple readings covered by one EChargeAccum entry, and the readings have a different value for PCF or HV, then the EChargeAccum entry is to remain NULL.
    --      2. Electricity - for both basic and interval
    --         Factor 1 = TLF (Transmission Loss Factor)
    --         Factor 2 = DLF (Distribution Loss Factor)
    --      Note: We have splitted the EChargeAccum entries on a change in Loss Factor during a billing period
    --
    PROCEDURE Factor_ECA(ioRAG IN OUT NOCOPY pkg_accum.trRAG) IS
        l_key      VARCHAR2(100);
        l_idx      PLS_INTEGER;
        l_spid     PLS_INTEGER;
        l_sdate    DATE;
        l_edate    DATE;
        l_utype    VARCHAR2(2);
        l_factor1  NUMBER;
        l_factor2  NUMBER;
        --
        la_Key     taRAGKey;
        la_RAGID   t2daRAGID;

        FUNCTION GetNMIFactor(iSPID   IN PLS_INTEGER
                             ,iDate   IN DATE
                             ,iPKey   IN VARCHAR2
                             ,iLfType IN lossfactorarea.lftype%TYPE)
                                      RETURN NUMBER IS
            l_return NUMBER;
        BEGIN
            l_return := NULL;
            --
            BEGIN
                SELECT lp.propvalnumber
                INTO   l_return
                FROM   spproperty        spp
                      ,SupplyPointLookup lu
                      ,SupplyPointLookup lu2
                      ,lossfactorarea    lfa
                      ,lfaproperty       lp
                WHERE  lu2.Supplypointid = iSPID
                AND    lu2.sitespid = lu.sitespid
                -- WR57786 Handle multiple MP under the same SITE
                AND    lu2.mpspid = lu.mpspid
                AND    lu.metertype LIKE 'MP%'
                AND    spp.SupplyPointID = lu.SupplyPointID
                AND    spp.propertykey = iPKey
                AND    iDate BETWEEN NVL(spp.datestart
                                        ,k_MinDate) AND NVL(spp.dateend
                                                           ,k_MaxDate)
                AND    lfa.key1 || lfa.key2 || lfa.key3 = spp.propvalchar
                AND    lfa.lftype = iLfType
                AND    lfa.lfareaid = lp.lfareaid
                AND    lp.propertykey = 'LF'
                AND    iDate BETWEEN NVL(lp.datestart
                                        ,k_MinDate) AND NVL(lp.dateend
                                                           ,k_MaxDate);
            EXCEPTION
                WHEN OTHERS THEN
                    l_return := NULL;
            END;
            --
            RETURN l_return;
        END GetNMIFactor;

        PROCEDURE EmptyArray IS
        BEGIN
            la_Key.DELETE;
            la_RAGID.DELETE;
        END EmptyArray;
    BEGIN
        EmptyArray;
        --
        IF ioRAG.RAGID.COUNT > 0 THEN
            --
            -- To improve the performance, generate a list of RAGIDs for the same SPID date range
            --
            FOR i IN ioRAG.RAGID.FIRST .. ioRAG.RAGID.LAST LOOP
                l_key := TO_CHAR(ioRAG.SupplyPointID(i))        || '_' ||
                         TO_CHAR(ioRAG.DateFrom(i), 'YYYYMMDD') || '_' ||
                         TO_CHAR(ioRAG.DateTo(i), 'YYYYMMDD');
                --
                IF NOT la_Key.EXISTS(l_key) THEN
                    la_Key(l_key) := la_Key.COUNT + 1;
                    la_RAGID(la_Key(l_key))(1)   := ioRAG.RAGID(i);
                ELSE
                    la_RAGID(la_Key(l_key))(la_RAGID(la_Key(l_key)).COUNT + 1)     := ioRAG.RAGID(i);
                END IF;
            END LOOP;
        END IF;
        --
        IF la_Key.COUNT > 0 THEN
            l_key := la_Key.FIRST;
            FOR i IN 1 .. la_Key.COUNT LOOP
                l_idx := la_Key(l_key);
                --pkg_util.putbuf('la_Key(' || l_key || ') = ' || l_idx, 255, NULL);
                -- Analyze the key
                l_spid  := TO_NUMBER(SUBSTR(l_key, 1, INSTR(l_key, '_', 1) - 1));
                l_sdate := TO_DATE(SUBSTR(l_key
                                         ,INSTR(l_key, '_', 1) + 1
                                         ,(INSTR(l_key, '_', -1) - INSTR(l_key, '_', 1) - 1))
                                  ,'YYYYMMDD');
                l_edate := TO_DATE(SUBSTR(l_key
                                         ,INSTR(l_key, '_', -1) + 1)
                                  ,'YYYYMMDD');
                --
                l_utype   := GetUtilityType(l_spid);
                l_factor1 := NULL;
                l_factor2 := NULL;
                --
                IF l_utype = 'G' THEN
                    -- Get factor1 and factor2 from readingdumb(only for basic)
                    -- If multiple readings covered by one EChargeAccum entry, and the readings have a different value for PCF or HV,
                    -- then the EChargeAccum entry is to remain NULL.
                    BEGIN
                        --dbms_output.put_line ('FactorECA l_spid=' || l_spid ||', l_sdate=' || l_sdate ||', l_edate=' || l_edate || ',g_RdgCloseBP=' || g_RdgCloseBP);
                        -- Wr 57522  Performance Improvement
                        --WITH RdgDumbRange AS(
                        --    SELECT readingdumbid
                        --          ,supplypointid
                        --          ,factor1
                        --          ,factor2
                        --          -- g_RdgCloseBP = 'Y'  -> First day of reading period is day after previous reading date,
                        --          --                        and last day is day of current reading date.
                        --          -- g_RdgCloseBP = ELSE -> First day of reading period is the previous reading date,
                        --          --                        and Last day is the day before the current reading date
                        --          ,DECODE(g_RdgCloseBP
                        --                 ,'Y', LAG(timestamp
                        --                          ,1) OVER (PARTITION BY SupplyPointID ORDER BY timestamp) + 1
                        --                 ,LAG(timestamp
                        --                     ,1) OVER (PARTITION BY SupplyPointID ORDER BY timestamp)) AS startdate
                        --          ,DECODE(g_RdgCloseBP
                        --                 ,'Y', timestamp
                        --                 ,timestamp - 1) AS enddate
                        --    FROM   readingdumb
                        --    WHERE  processstatus = 'A'
                        --    ORDER  BY supplypointid
                        --             ,timestamp)
                        --SELECT DISTINCT d.factor1 Factor1
                        --               ,d.factor2 Factor2
                        --INTO   l_factor1
                        --      ,l_factor2
                        --FROM   RdgDumbRange      d
                        --      ,SupplyPointLookup lu
                        --      ,SupplyPointLookup lu2
                        --WHERE  d.SupplyPointID = lu.SupplyPointID
                        --AND    lu2.sitespid = lu.sitespid
                        --AND    lu2.mpspid = lu.mpspid
                        --AND    lu2.Supplypointid = l_spid
                        ---- EndDate can be timestamp or timestamp - 1
                        --AND    d.enddate >= lu.datestart
                        --AND   (lu.DateEnd IS NULL OR lu.DateEnd >= d.enddate)
                        --AND    NOT (d.enddate < l_sdate OR d.startdate > l_edate);
                        --
                        SELECT DISTINCT
                               rf.factor1  AS Factor1
                              ,rf.factor2  AS Factor2
                        INTO   l_factor1
                              ,l_factor2
                        FROM   (-- reading that encompasses the period being billed
                                SELECT re.supplypointid
                                      ,MIN(re.timestamp) AS EndTS
                                FROM  (-- all supplypoints on site
                                       SELECT lu2.supplypointid
                                       FROM   supplypointlookup lu
                                       JOIN   supplypointlookup lu2 ON  lu2.sitespid = lu.sitespid
                                                                    -- WR57786 Handle multiple MP under the same SITE
                                                                    --         With assumption of all register/meter under MP are for billing
                                                                    --         SE billing stays on MP level
                                                                    AND lu2.mpspid = lu.mpspid
                                       WHERE  lu.supplypointid = l_spid
                                       AND    lu2.datestart < TRUNC(l_EDate) + 1
                                       AND   (lu2.dateend IS NULL OR lu2.dateend >= TRUNC(l_SDate))) sp
                                JOIN   readingdumb re ON  re.supplypointid = sp.supplypointid
                                                      AND re.timestamp >= TRUNC(l_EDate)
                                                      AND re.processstatus = 'A'
                                GROUP BY re.supplypointid) sr
                         JOIN  readingdumb rf ON  rf.supplypointid = sr.supplypointid
                                              -- WR57786 Return at least one row without ever including the initial reading
                                              --AND rf.timestamp >= TRUNC(l_SDate) + 1  -- dont want initial reading included here
                                              AND ((TRUNC(l_EDate) > TRUNC(l_SDate) AND rf.timestamp >= TRUNC(l_SDate) + 1) OR
                                                   (TRUNC(l_EDate) <= TRUNC(l_SDate) AND rf.timestamp >= TRUNC(l_SDate)))
                                              AND rf.timestamp <= sr.EndTS
                                              AND rf.processstatus = 'A';
                         -- end Wr 57522  Performance Improvement
                    EXCEPTION
                        WHEN too_many_rows THEN
                            l_factor1 := NULL;
                            l_factor2 := NULL;
                    END;
                ELSIF l_utype = 'E' THEN
                    -- Get factor1 and factor2 from NMI properties
                    l_factor1 := GetNMIFactor(iSPID   => l_spid
                                             ,iDate   => l_sdate
                                             ,iPKey   => 'ZONE'
                                             ,iLfType => 'TLF');
                    l_factor2 := GetNMIFactor(iSPID   => l_spid
                                             ,iDate   => l_sdate
                                             ,iPKey   => 'MPLLCI'
                                             ,iLfType => 'DLF');
                END IF;
                --
                IF g_debug THEN
                    pkg_util.putbuf('Factor_ECA - l_spid = ' || l_spid    ||
                                    ', l_sdate = '           || l_sdate   ||
                                    ', l_edate = '           || l_edate   ||
                                    ', utilitytype = '       || l_utype   ||
                                    ', l_factor1 = '         || l_factor1 ||
                                    ', l_factor2 = '         || l_factor2
                                   ,255
                                   ,NULL);
                END IF;
                --
                IF l_factor1 IS NOT NULL OR l_factor2 IS NOT NULL THEN
                    -- Populate factor1 and factor2
                    FOR j IN 1 .. la_RAGID(l_idx).COUNT LOOP
                        --
                        FOR k IN ioRAG.RAGID.FIRST .. ioRAG.RAGID.LAST LOOP
                            --
                            IF ioRAG.RAGID(k) = la_RAGID(l_idx)(j) THEN
                                ioRAG.Factor1(k) := l_factor1;
                                ioRAG.Factor2(k) := l_factor2;
                                EXIT;
                            END IF;
                        END LOOP;
                    END LOOP;
                END IF;
                --
                l_key := la_Key.NEXT(l_key);
                EXIT WHEN l_key IS NULL;
            END LOOP;
        END IF;
    END Factor_ECA;

    --------------------------------------------------------------------------
    PROCEDURE Display_TCA(l_taECA IN taECA
                         ,j       IN PLS_INTEGER DEFAULT NULL
                         ,iMsg    IN VARCHAR2) IS
        i PLS_INTEGER := 0;
        l_x VARCHAR2(30);
    BEGIN
        IF j IS NULL THEN
            Pkg_Util.putbuf('l_taECACount = ' || l_taECA.COUNT
                           ,255
                           ,NULL);
            Pkg_Util.putbuf( 'l_taECA>. n .'
                                 || 'EChargeAcc.'
                                 || 'Inventory .'
                                 || 'InvSPID   .'
                                 || 'Unit .'
                                 || 'Cons   .'
                                 || 'ConsBilled.'
                                 || 'TSetID.'
                                 || 'TBandID.'
                                 || 'ETimeChgID.'
                                 || 'RatingPlan.'
                                 || 'DateFrom .'
                                 || 'DateTo   .'
                                 || 'Season.'
                                 || 'Factor1 .'
                                 || 'Factor2 .'
                                 || 'CBFactor.'
                                 || 'Cnt0 .'
                                 || 'Match.'
                                 || imsg
                           ,255
                           ,NULL);

            FOR k IN 1 .. l_taECA.COUNT LOOP
                i := l_taECA.NEXT(i);
                IF l_taECA(i).datefrom > l_taECA(i).dateto THEN
                    pkg_util.putbuf('DateFrom = ' || to_char(l_taECA(i).datefrom, 'ddmmyyyy hh24:mi:ss') ||
                                    ' DateTo = '  || to_char(l_taECA(i).dateto, 'ddmmyyyy hh24:mi:ss')
                                   ,255
                                   ,NULL);
                    pkg_util.putbuf('Error in processing for this one'
                                   ,255
                                   ,NULL);
                END IF;
                IF l_taECA(i).Match_TimeBand THEN
                    l_x := 'TRUE';
                ELSE
                    l_x := 'FALSE';
                END IF;

/*              Pkg_Util.putbuf(imsg || ' EChargeAccumID(' || i || ')= ' || l_taECA(i).EChargeAccumID  --||chr(10)||chr(13)
                                     || ' InventoryID = '                || l_taECA(i).inventoryid     --||chr(10)||chr(13)
                                     || ' SupplyPointID = '              || l_taECA(i).supplypointid   --||chr(10)||chr(13)
                                     || ' Unit = '                       || l_taECA(i).unit            --||chr(10)||chr(13)
                                     || ' Cons = '                       || l_taECA(i).Consumption     --||chr(10)||chr(13)
                                     || ' TimeSetID = '                  || l_taECA(i).timesetid       --||chr(10)||chr(13)
                                     || ' TimeBandID = '                 || l_taECA(i).timebandid      --||chr(10)||chr(13)
                                     || ' ETimeChargeID = '              || l_taECA(i).etimechargeid   --||chr(10)||chr(13)
                                     || ' RatingPlanID = '               || l_taECA(i).RatingPlanID    --||chr(10)||chr(13)
                                     || ' DateFrom = '                   || l_taECA(i).datefrom        --||chr(10)||chr(13)
                                     || ' DateTo = '                     || l_taECA(i).dateto          --||chr(10)||chr(13)
                                     || ' SeasonID = '                   || l_taECA(i).SeasonID
                                     || ' Factor1 = '                    || l_taECA(i).Factor1  -- WR55825 Display Factor1 and Factor2 for both Interval and Basic
                                     || ' Factor2 = '                    || l_taECA(i).Factor2  -- WR55825 Display Factor1 and Factor2 for both Interval and Basic
                               ,255
                               ,NULL);*/
                Pkg_Util.putbuf( lp('l_taECA>',8)|| rpd(i, 3)
                                     || rpd( l_taECA(i).EChargeAccumID,10)  --||chr(10)||chr(13)
                                     || rpd(l_taECA(i).inventoryid,10)     --||chr(10)||chr(13)
                                     || rpd(l_taECA(i).supplypointid,10)   --||chr(10)||chr(13)
                                     || lp(l_taECA(i).unit,5)            --||chr(10)||chr(13)
                                     || rpd(l_taECA(i).Consumption,7)     --||chr(10)||chr(13)
                                     || rpd(l_taECA(i).ConsBilled,7)     --||chr(10)||chr(13)
                                     || rpd(l_taECA(i).timesetid,6)       --||chr(10)||chr(13)
                                     || rpd(l_taECA(i).timebandid,7)      --||chr(10)||chr(13)
                                     || rpd(l_taECA(i).etimechargeid,10)   --||chr(10)||chr(13)
                                     || rpd(l_taECA(i).RatingPlanID,10)    --||chr(10)||chr(13)
                                     || lp(l_taECA(i).datefrom,9)         --||chr(10)||chr(13)
                                     || lp(l_taECA(i).dateto,9)          --||chr(10)||chr(13)
                                     || rpd(l_taECA(i).SeasonID,6)
                                     || lp(l_taECA(i).Factor1,8)  -- WR55825 Display Factor1 and Factor2 for both Interval and Basic
                                     || lp(l_taECA(i).Factor2,8)  -- WR55825 Display Factor1 and Factor2 for both Interval and Basic
                                     || lp(l_taECA(i).ConsBilledFactor,8)
                                     || rpd(l_taECA(i).CountNonZeroRate,5)
                                     || lp(l_x,5)
                                     || rpd(l_taECA(i).meterType,10)
                                     || rpd(l_taECA(i).rType,2)
                                     || imsg
                               ,255
                               ,NULL);
            END LOOP;
        ELSE
            IF l_taECA(j).Match_TimeBand THEN
                l_x := 'TRUE';
            ELSE
                l_x := 'FALSE';
            END IF;

/*          Pkg_Util.putbuf(imsg || ' EChargeAccumID(' || j || ')= ' || l_taECA(j).EChargeAccumID  --||chr(10)||chr(13)
                                 || ' InventoryID = '                || l_taECA(j).inventoryid     --||chr(10)||chr(13)
                                 || ' SupplyPointID = '              || l_taECA(j).supplypointid   --||chr(10)||chr(13)
                                 || ' Unit = '                       || l_taECA(j).unit            --||chr(10)||chr(13)
                                 || ' Cons = '                       || l_taECA(j).Consumption     --||chr(10)||chr(13)
                                 || ' TimeSetID = '                  || l_taECA(j).timesetid       --||chr(10)||chr(13)
                                 || ' TimeBandID = '                 || l_taECA(j).timebandid      --||chr(10)||chr(13)
                                 || ' ETimeChargeID = '              || l_taECA(j).etimechargeid   --||chr(10)||chr(13)
                                 || ' RatingPlanID = '               || l_taECA(j).RatingPlanID    --||chr(10)||chr(13)
                                 || ' DateFrom = '                   || l_taECA(j).datefrom        --||chr(10)||chr(13)
                                 || ' DateTo = '                     || l_taECA(j).dateto          --||chr(10)||chr(13)
                                 || ' SeasonID = '                   || l_taECA(j).SeasonID
                                 || ' Factor1 = '                    || l_taECA(j).Factor1  -- WR55825 Display Factor1 and Factor2 for both Interval and Basic
                                 || ' Factor2 = '                    || l_taECA(j).Factor2  -- WR55825 Display Factor1 and Factor2 for both Interval and Basic
                                 || ' CntNonZeroPrice = '            || l_taECA(j).CountNonZeroRate
                                 || ' Match Found = '                || l_x
                                 || ' Match Found = '                || l_x
                          ,255
                           ,NULL);*/
                Pkg_Util.putbuf( lp('l_taECA>',8)|| rpd(j, 3)
                                     || rpd( l_taECA(j).EChargeAccumID,10)  --||chr(10)||chr(13)
                                     || rpd(l_taECA(j).inventoryid,10)     --||chr(10)||chr(13)
                                     || rpd(l_taECA(j).supplypointid,10)   --||chr(10)||chr(13)
                                     || lp(l_taECA(j).unit,5)            --||chr(10)||chr(13)
                                     || rpd(l_taECA(j).Consumption,7)     --||chr(10)||chr(13)
                                     || rpd(l_taECA(j).ConsBilled,7)     --||chr(10)||chr(13)
                                     || rpd(l_taECA(j).timesetid,6)       --||chr(10)||chr(13)
                                     || rpd(l_taECA(j).timebandid,7)      --||chr(10)||chr(13)
                                     || rpd(l_taECA(j).etimechargeid,10)   --||chr(10)||chr(13)
                                     || rpd(l_taECA(j).RatingPlanID,10)    --||chr(10)||chr(13)
                                     || lp(l_taECA(j).datefrom,9)         --||chr(10)||chr(13)
                                     || lp(l_taECA(j).dateto,9)          --||chr(10)||chr(13)
                                     || rpd(l_taECA(j).SeasonID,6)
                                     || lp(l_taECA(j).Factor1,8)  -- WR55825 Display Factor1 and Factor2 for both Interval and Basic
                                     || lp(l_taECA(j).Factor2,8)  -- WR55825 Display Factor1 and Factor2 for both Interval and Basic
                                     || lp(l_taECA(j).ConsBilledFactor,8)
                                     || rpd(l_taECA(j).CountNonZeroRate,5)
                                     || lp(l_x,5)
                                     || rpd(l_taECA(j).rType,2)
                                     || imsg
                           ,255
                           ,NULL);
        END IF;
    END;
    ---------------------------------------------------------------- GetEnergyType
    -- This function is a clone of pkg_InvoiceGraphXML.EnergySourceType
    FUNCTION  GetEnergyType(iHmbrid number
                            ,iDate   Date
                              )
      RETURN VARCHAR2 IS

    l_EnergyType   VARCHAR2(1);
    -- return the energy type according to the initial offer for the account
    BEGIN
        SELECT DISTINCT nvl(cp.propvalchar
                           ,'N')
        INTO   l_EnergyType
        FROM   HMBRPROPERTY    hmp
              ,CAMPAIGNUTILITY cu
              ,CUPROPERTY      cp
        WHERE  cu.offernbr = hmp.propvalchar
        AND    hmp.hmbrid = iHmbrid
        AND    hmp.propertykey = 'OFFERNBR'
        And    hmp.datestart <= iDate
        And   (hmp.dateend is null or hmp.dateend >= iDate )
        AND    cu.CAMPAIGNUTILITYID = cp.CAMPAIGNUTILITYID
        AND    cp.PROPERTYKEY = 'ENERGYTYPE'
        AND    (cp.datestart <= iDate OR cp.datestart IS NULL)
        AND    (cp.dateend >= iDate OR cp.dateend IS NULL);

        RETURN l_EnergyType;

    EXCEPTION
         WHEN OTHERS THEN
              RETURN l_EnergyType;
    END GetEnergyType;
    --
    ------------------------------------------------------------------ GetRenewPercent
    -- This function is from pkg_InvoiceGraphXML
    Function GetRenewPercent (iHmbrid      number
                             ,iEnergyType  VARCHAR2
                             ,iDate        Date
                              )
       RETURN NUMBER IS
       l_RenewPercent NUMBER;
    BEGIN
        l_RenewPercent := 0;
        --
        IF iEnergyType = 'N' THEN
            l_RenewPercent := 0;
        ELSIF iEnergyType = 'E' THEN
            l_RenewPercent := 100;
        ELSIF iEnergyType = 'P' THEN

            BEGIN
                SELECT DISTINCT nvl(CP.PROPVALNUMBER
                                   ,decode(iEnergyType
                                          ,'E'
                                          ,1
                                          ,0))
                INTO   l_RenewPercent
                FROM   HMBRPROPERTY    hmp
                      ,CAMPAIGNUTILITY cu
                      ,CUPROPERTY      cp
                WHERE  cu.offernbr = hmp.propvalchar
                AND    hmp.hmbrid = iHmbrid
                AND    hmp.propertykey = 'OFFERNBR'
                And    hmp.datestart <= iDate
                And   (hmp.dateend is null or hmp.dateend >= iDate )
                AND    cu.CAMPAIGNUTILITYID = cp.CAMPAIGNUTILITYID
                AND    cp.PROPERTYKEY = 'RENEWPERCENT'
                AND    (cp.datestart <= iDate OR cp.datestart IS NULL)
                AND    (cp.dateend >= iDate OR cp.dateend IS NULL);

            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;
        END IF;
        --
        Return l_RenewPercent;
        --
    END GetRenewPercent;
    --
    ---------------------------------------------------------------- GetConsumpCoEff
    FUNCTION  GetConsumpCoEff(iLocationId number
                             ,iUtil       Varchar2
                             ,iStDate     Date
                             ,iEnDate     Date
                              )
      RETURN number IS

    CURSOR cGetCoefficient(iLocId  number
                          ,iPKey   varchar2
                          ,iStDate Date
                          ,iEnDate Date
                          ) IS
        SELECT propvalnumber
        FROM   locationproperty
        WHERE  locationid = iLocId
        AND    propertykey = iPKey
        AND    iStDate >= trunc(datestart)
        AND    iEnDate <= trunc(nvl(dateend
                                       ,pkg_k.k_MaxDate));
    l_CoEfficient  NUMBER;
    l_COEFFTYPE    VARCHAR2(10);
    --
    BEGIN

        --
        If iUtil = 'E' Then
           l_COEFFTYPE := 'GHCOEFF';
        Else
           l_COEFFTYPE := 'GHCOEFFGAS';
        End If;
        --
        OPEN cGetCoefficient(iLocationId,l_COEFFTYPE,iStDate, iEnDate);
        FETCH cGetCoefficient into l_Coefficient;
        IF cGetCoefficient%NOTFOUND THEN
          -- try next routine
           l_Coefficient := pkg_InvoiceGraphXML.GetCoEffWithDateRange(iStDate
                                                                     ,iEnDate
                                                                     ,l_COEFFTYPE
                                                                     ,iLocationID);
        END IF;

        CLOSE cGetCoefficient;

        RETURN l_CoEfficient;

    EXCEPTION
         WHEN OTHERS THEN
              RETURN l_CoEfficient;
    END GetConsumpCoEff;
    --
    ---------------------------------------------------------------------SaveInvCons
    Procedure SaveInvCons(iHmbrid     In  number
                         ,iInvoiceid  In  number
					     ,iotaCTB     In out nocopy trinvcons
					      ) Is


    Begin
        --
        --  Clean up existing or unbilled invoiceconsumption records

        Delete Invoiceconsumption
         Where hmbrid = iHmbrid
           and invoiceid ||'x' = iInvoiceid || 'x';

    FORALL i IN 1 .. iotaCTB.ConsSource.count
      INSERT INTO InvoiceConsumption
        (InvoiceConsumptionID
        ,Hmbrid
        ,Invoiceid
        ,ConsSource
        ,DateFrom
        ,Dateto
        ,TimeBandId
        ,Consumption
        ,ConsUnit
        ,EnergyType
        ,RenewPercent
        ,GHCoefficient)
      VALUES
        (iotaCTB.invoiceConsumptionid(i)
        ,iHmbrid
        ,iInvoiceid
        ,iotaCTB.ConsSource(i)
        ,iotaCTB.DateFrom(i)
        ,iotaCTB.DateTo(i)
        ,iotaCTB.TimeBandID(i)
        ,iotaCTB.Consumption(i)
        ,iotaCTB.ConsUnit(i)
        ,iotaCTB.EnergyType(i)
        ,iotaCTB.RenewPercent(i)
        ,iotaCTB.GHCoefficient(i)
             );
        --
    IF  SQL%ROWCOUNT <> iotaCTB.ConsSource.COUNT THEN
            Raise_Application_Error(-20012, 'Bulk Insert failed on InvoiceConsumption');
        END IF;
        --
/*        For i in 1 .. iotaCTB.ConsSource.count
        loop
            Pkg_Util.putbuf(lp(i||' ',3) ||
                            rpd(iotaCTB.ConsSource(i),2) ||
                            rpd(iotaCTB.TimeBandid(i),7) ||
                            lp(iotaCTB.DateFrom(i),9) ||
                            lp(iotaCTB.DateTo(i),9) ||
                            rpd(iotaCTB.Consumption(i),10)  ||
                            lp(iotaCTB.ConsUnit(i),6) ||
                            lp(iotaCTB.EnergyType(i),3) ||
                            rpd(iotaCTB.RenewPercent(i),4) ||
                            rpd(iotaCTB.GHCoefficient(i),7) ||
                            rpd(iInvoiceid,9) ||
                            rpd(iHmbrid,9)
                           ,255
                           ,NULL
                           ,NULL);
        End loop;*/
        --
    End SaveInvCons;
    --
    ------------------------------------------------------------------Get_TS_SeasonBoundaries
    Procedure Get_TS_SeasonBoundaries(iTimeSetId  In  number
                                     ,iTimeBandId In  number
                                     ,iDateStart  In  Date
                                     ,iDateEnd    In  Date
                                     ,oDateFrom   out pkg_std.taDate
                                     ,oDateTo     Out pkg_std.taDate
                                     ) AS
    l_tempdate1        Date;
    l_tempdate2        Date;

    l_TimeSet_c        varchar2(10);
    l_TimeBand_c       varchar2(10);


    l_string           varchar2(200);
    la_TSSB            taTSSB;-- timebands set
    lrec               trTSSB;-- timeband season boundary row
    l_indx             pls_integer;

    cursor cSB (vTimeSetid number) is
     select distinct ts.timesetid
          , tr.timebandid
          , tsv.dateactive
          , nvl(tsv.datedeactive,pkg_k.k_maxdate) datedeactive
          , tr.startmmdd
          , tr.endmmdd
       from timeset ts
       join timesetversion tsv on (tsv.timesetid = ts.timesetid)
       join timerange tr on (tr.timesetversionid = tsv.timesetversionid)
      where ts.timesetid = vTimeSetid
      order by timebandid, dateactive, datedeactive, startmmdd, endmmdd
      ;
    --
    begin
      --
      If  iTimeSetid is null or iTimeBandId is null Then
          -- not enough information, return default date
          oDateFrom(1) := iDateStart;
          oDateTo(1)   := iDateEnd;
          Return;
      End If;
      --
      l_timeset_c := to_char(iTimeSetId);
      --
      If not la_ts.exists(l_timeset_c) Then
          --
          la_ts(l_timeset_c).TimeSetid := iTimesetid;
          --
          For rec in cSB(iTimeSetId)
          loop
              --
              l_timeband_c := to_char(rec.timebandid);
              --
              lr_TSSB.dateactive   := rec.dateactive;
              lr_TSSB.datedeactive := rec.datedeactive;
              lr_TSSB.startmmdd    := rec.startmmdd;
              lr_TSSB.endmmdd      := rec.endmmdd;
              lr_TSSB.TimeBandid   := rec.timebandid;
              --
              If not la_ts(l_timeset_c).TBand.exists(l_timeband_c) Then
                  --
                  l_indx := 1;
              Else
                  l_indx := la_ts(l_timeset_c).TBand(l_timeband_c).count+1;
              End If;
              --
              la_ts(l_timeset_c).TBand(l_timeband_c)(l_indx) := lr_TSSB;
              --
          End loop;
      End If;
      --
      l_TimeBand_c := to_char(iTimeBandId);
      --
      If not la_ts(l_timeset_c).TBand.exists(l_TimeBand_c) Then
          -- no TimeSet information return default date
          oDateFrom(1) := iDateStart;
          oDateTo(1)   := iDateEnd;
          Return;
      End If;
      --
      la_TSSB := la_Ts(l_timeSet_c).TBand(l_TimeBand_c);
      l_indx := 0;

      For yy in to_number(to_char(iDateStart,'yyyy')) .. to_number(to_Char(iDateEnd,'yyyy'))
      loop
          --
          For i in 1 .. la_TSSB.count
          loop
             --
             lrec := la_TSSB(i);
             --
             l_string := lpad(lrec.timebandid,5,' ') ||
                         lpad(lrec.dateactive,10,' ') ||
                         lpad(lrec.datedeactive,10,' ') ||
                         lpad(lrec.startmmdd,5,' ')  ||
                         lpad(lrec.endmmdd,5,' ') ||
                         lpad(yy, 5,' ')
                         ;
             --
             l_tempdate1 := to_date(to_char(yy, 'FM0000')||lpad(lrec.startmmdd,4,0),'yyyymmdd');

             If  lrec.endmmdd = 229 Then
                 l_tempdate2 := to_date((to_char(yy,'FM0000')||'0301'),'yyyymmdd')-1;
             Else
                 l_tempdate2 := to_date(to_char(yy, 'FM0000')||lpad(lrec.endmmdd,4,0),'yyyymmdd');
             End If;
             -- end date >= date active
             -- start date <= date deactive
             If  l_tempdate2 >= lrec.dateactive
                 and l_tempdate1 <= lrec.datedeactive then

                 l_tempdate1 := greatest(l_tempdate1,lrec.dateActive);
                 l_tempdate2 := least(l_tempdate2,lrec.dateDeactive);
             Else
                 l_tempdate1 := null;
                 l_tempdate2 := null;
             End If;
             --
             -- end date >= st date
             -- start date <= en date
             If  l_tempdate2 >= iDateStart
                 and l_tempdate1 <= iDateEnd  Then
                 --
                 l_tempdate1 := greatest(l_tempdate1,iDateStart);
                 l_tempdate2 := least(l_tempdate2,iDateEnd);
             Else
                 l_tempdate1 := null;
                 l_tempdate2 := null;
             End If;
             --
             l_string := l_string ||
                         lpad(l_tempdate1,10,' ') ||
                         lpad(l_tempdate2,10,' ')
                             ;
             --
             If  l_tempdate1 is not null
                 and ( lrec.startmmdd = 101 and lrec.endmmdd = 1231 ) Then
                 -- no season boundary
                 --
                 l_tempdate1 := greatest(lrec.dateActive,iDateStart);
                 l_tempdate2 := least(lrec.dateDeactive,iDateEnd);
                 --
             End If;
             --
             If  l_tempdate1 is not null then
                 --
                 IF g_Debug THEN
                     Pkg_Util.putbuf(l_string
                                     ,255
                                     ,null
                                     ,null
                                     );
                     --
                 End If;
                 --
                 l_indx := l_indx + 1;
                 --
                 oDateFrom(l_Indx) := trunc(l_tempdate1);
                 oDateTo(l_Indx)   := trunc(l_tempdate2);
                 --
             End If;
             --

          End loop;
          --
       End loop;
       --
       --
       If  oDateFrom.count = 0 then
          --
          oDateFrom(1) := iDateStart;
          oDateTo(1)   := iDateEnd;
       End If;
       --
    End Get_TS_SeasonBoundaries;
    --
    --------------------------------------------------------------------------
    PROCEDURE NewECA(iHMbrID IN  HierarchyMbr.HMbrID%TYPE
                    ,iDateTo IN  DATE
                    ,orc     OUT PLS_INTEGER
                    ,oretc   IN OUT NOCOPY pkg_std.taInt
                    ,oMsg    IN OUT NOCOPY pkg_std.taDescr
                    ,idatefrom in date default null
                    ,iDoDemand   IN VARCHAR2 DEFAULT 'N'
                    ,otaOECA  OUT NOCOPY pkg_accum.trRAG
                    ,iSaveToDB IN BOOLEAN DEFAULT TRUE  -- WR99428
                    ,otaCTB  OUT NOCOpy trInvCons) IS

        CURSOR cInv(iHMbrID   IN HierarchyMbr.HMbrID%TYPE
                   ,iBillFrom IN DATE
                   ,iBillTo     IN DATE
                   ,iDoDemand   IN VARCHAR2) IS

            SELECT DISTINCT i.InventoryID
                           ,i.ProductRelID
                           ,GREATEST(i.dateactive
                                    ,spid.Datestart
                                    ,cur.datestart) DateActive
                           ,LEAST(i.datedeactive
                                 ,NVL(spid.DateEnd
                                     ,iBillTo)
                                 ,NVL(cur.DateEnd
                                     ,iBillTo)) DateDeActive
                           ,cur.PropValChar CurrencyCode
                           ,spid.PropValNumber SPID
                           ,p.ChargeType
                           ,sp.MeterType
                           ,( select substr(pmp.propvalchar,1,5)
                              from productmetaproperty pmp
                              where pmp.productid = p.productid
                                and pmp.propertykey = 'PRODUCTSUBCLASS') productsubclass

            FROM   HMbrInventory hmi
                  ,Inventory     i
                  ,HierarchyMbr  nbp
                  ,BusinessUnit  bu
                  ,HierarchyMbr  bp
                  ,HMbrProperty  cur
                  ,InvProperty   spid
                  ,Product       p
                  ,SupplyPoint   sp
            WHERE  bp.HMbrID = iHMbrID
            AND    hmi.InventoryID = i.InventoryID
            AND    nbp.hmbrid = hmi.hmbrid
            AND    bu.buid = nbp.Parentbuid
            AND    bp.buid = bu.buid
            AND    cur.HMbrID = bp.HmbrID
            AND    cur.propertyKey = 'BILCUR'
            AND    cur.DateStart <= i.dateactive
            AND   (cur.DateEnd IS NULL OR cur.DateEnd > i.DateActive)
            AND    spid.InventoryID = i.InventoryID
            AND    spid.PropertyKey LIKE 'SPID%'
            AND    p.ProductID = i.productID
            AND    (iDoDemand = 'Y' AND p.Chargetype IN ('UD', 'UGD') OR iDoDemand = 'N' AND p.Chargetype IN ( 'UE', 'UG'))
            AND    i.dateactive <= iBillTo -- MHA-1357 interested on the inventory that is on or before the bill to date
            AND   (i.Datedeactive IS NULL OR  (i.DateDeActive > iBillFrom AND i.dateactive < i.DateDeActive))-- MHA-1357 add bracket for readability
            AND    sp.SupplyPointID = spid.PropValNumber
           order by 3, 4;
        -- WR55825 Avoid duplicate split date
        CURSOR cAsAt(iHMbrID    IN HierarchyMbr.Hmbrid%TYPE
                    ,iBillFrom  IN DATE
                    ,iBillTo    IN DATE
                    ,iBRCalType IN VARCHAR2
                    ,iDoDemand  IN VARCHAR2) IS         --WR110367 - Do Not Split for Demand record
            SELECT DISTINCT AsAtDate
            FROM  (SELECT i.dateto AsAtDate
                         ,'INV_' || i.InvoiceStatus
                   FROM   HierarchyMbr nbp
                         ,--BusinessUnit bu,
                          HierarchyMbr bp
                         ,Invoice      i
                   WHERE  bp.Hmbrid = iHMbrID
                   --AND nbp.parentbuid = bu.buid
                   AND    i.Hmbrid = bp.hmbrid
                   AND    bp.buid = nbp.Parentbuid
                   AND    bp.hid = nbp.hid
                   AND    i.DateFrom < iBillTo
                   AND    i.DateTo > iBillFrom
                   AND    i.InvoiceStatus IN ('D'     --Draft
                                             ,'C'     --Confirmed
                                             ,'X'     --Direct Debit Refused
                                             ,'P'     --Direct Debit Request Pending
                                             --,'WO'  --Written Off
                                             --,'DWP' --Deletion Pending
                                             --,'CWP' --Withdrawal Pending
                                             ,'H'     --Held
                                             ,'F'     --Fully Paid
                                             --,'W'   --Withdrawn
                                             ,'S'     --Sample
                                             )
                   AND    iDoDemand = 'N'
                   UNION
                   SELECT brr.AsAtDate AsAtDate
                         ,'BRE'
                   FROM   HierarchyMbr   nbp
                         ,BusinessUnit   bu
                         ,HierarchyMbr   bp
                         ,BillRunRequest brr
                   WHERE  bp.Hmbrid = iHMbrID
                   AND    nbp.parentbuid = bu.buid
                   AND    brr.Hmbrid = bp.hmbrid
                   AND    bp.buid = nbp.Parentbuid
                   AND    bp.hid = nbp.hid
                   AND    brr.InvoiceID IS NULL
                   AND    brr.asatdate BETWEEN iBillFrom AND iBillTo
                   AND    brr.BRCalType = 'R'
                   AND    (brr.Processstatus <> 'D' OR brr.Processstatus IS NULL)
                   AND    iDoDemand     = 'N'
                   UNION
                   SELECT BR.AsAtDate
                         ,'BRR'
                   FROM   BILLRUNCALENDAR BR
                         ,HMBRPROPERTY    HM1
                   WHERE  HM1.HMbrID = iHMbrID
                   AND    HM1.PropertyKey = 'BGRP'
                   AND    BR.BillingGroupID = HM1.PropValNumber
                   AND    br.brcaltype = iBRCalType  -- WR55825
                   AND    BR.AsAtDate BETWEEN iBillFrom AND iBillTo
                   AND    iDoDemand = 'N')
            ORDER  BY 1;
        --
        -- WR55825 Enhancement of splitting on a loss factor change
        --         For both basic and interval readings, Electricity only
        --
        CURSOR cAsAt_LFC(iHMbrID    IN HierarchyMbr.Hmbrid%TYPE
                        ,iSPID      IN supplypoint.supplypointid%TYPE
                        ,iBillFrom  IN DATE
                        ,iBillTo    IN DATE
                        ,iBRCalType IN VARCHAR2
                        ,iDoDemand   IN VARCHAR2) IS      --WR110367 - Demand split only on loss factor and calendar month
            SELECT DISTINCT AsAtDate
            FROM  (SELECT i.dateto AsAtDate
                         ,'INV_' || i.InvoiceStatus
                   FROM   HierarchyMbr nbp
                         ,--BusinessUnit bu,
                          HierarchyMbr bp
                         ,Invoice      i
                   WHERE  bp.Hmbrid = iHMbrID
                   --AND nbp.parentbuid = bu.buid
                   AND    i.Hmbrid = bp.hmbrid
                   AND    bp.buid = nbp.Parentbuid
                   AND    bp.hid = nbp.hid
                   AND    i.DateFrom < iBillTo
                   AND    i.DateTo > iBillFrom
                   AND    i.InvoiceStatus IN ('D'     --Draft
                                             ,'C'     --Confirmed
                                             ,'X'     --Direct Debit Refused
                                             ,'P'     --Direct Debit Request Pending
                                             --,'WO'  --Written Off
                                             --,'DWP' --Deletion Pending
                                             --,'CWP' --Withdrawal Pending
                                             ,'H'     --Held
                                             ,'F'     --Fully Paid
                                             --,'W'   --Withdrawn
                                             ,'S'     --Sample
                                             )
                   AND    iDoDemand = 'N'
                   UNION
                   SELECT brr.AsAtDate AsAtDate
                         ,'BRE'
                   FROM   HierarchyMbr   nbp
                         ,BusinessUnit   bu
                         ,HierarchyMbr   bp
                         ,BillRunRequest brr
                   WHERE  bp.Hmbrid = iHMbrID
                   AND    nbp.parentbuid = bu.buid
                   AND    brr.Hmbrid = bp.hmbrid
                   AND    bp.buid = nbp.Parentbuid
                   AND    bp.hid = nbp.hid
                   AND    brr.InvoiceID IS NULL
                   AND    brr.asatdate BETWEEN iBillFrom AND iBillTo
                   AND    brr.BRCalType = 'R'
                   AND    (brr.Processstatus <> 'D' OR brr.Processstatus IS NULL)
                   AND    iDoDemand = 'N'
                   UNION
                   SELECT BR.AsAtDate
                         ,'BRR'
                   FROM   BILLRUNCALENDAR BR
                         ,HMBRPROPERTY    HM1
                   WHERE  HM1.HMbrID = iHMbrID
                   AND    HM1.PropertyKey = 'BGRP'
                   AND    BR.BillingGroupID = HM1.PropValNumber
                   AND    br.brcaltype = iBRCalType
                   AND    BR.AsAtDate BETWEEN iBillFrom AND iBillTo
                   AND    iDoDemand = 'N'
                   UNION
                   SELECT spp.datestart - 1 AsAtDate
                         ,'LFC'  -- Loss Factor Change
                   FROM   spproperty spp
                         ,SupplyPointLookup lu
                         ,SupplyPointLookup lu2
                   WHERE  spp.SupplyPointID = lu.SupplyPointID
                   AND    lu2.sitespid = lu.sitespid
                   -- WR57786 Handle multiple MP under the same SITE
                   AND    lu2.mpspid = lu.mpspid
                   AND    lu2.Supplypointid = iSPID
                   AND    lu.metertype LIKE 'MP%'
                   AND    spp.propertykey IN ('MPLLCI', 'ZONE')
                   AND    spp.propvalchar IS NOT NULL
                   AND    spp.datestart BETWEEN iBillFrom AND iBillTo
                   -- WR110367 - Split on calendar month - Only for Demand Inventory
                   UNION
                   SELECT LEAST (LAST_DAY(ADD_MONTHS(sdate, LEVEL - 1)), edate) AsAtDate, 'CAL'
                     FROM (SELECT iBillFrom  sdate
                                 ,iBillTo    edate
                     FROM dual)
                    WHERE iDoDemand = 'Y'
                   CONNECT BY LEVEL <= MONTHS_BETWEEN(TRUNC(edate, 'mm'), TRUNC(sdate, 'mm')) + 1)
            ORDER  BY 1;

    -- SEPI-16932
    Cursor cAsAT_RateReduction(vHmbrid number) Is
        SELECT  D.DISCOUNTPLANID DPlanID
               ,HPD.PropValDate-1 DS
               ,hm.dateend DE
               ,hi.inventoryid
          FROM  HMBRINVENTORY HI
          join  HIERARCHYMBR HM on (HM.HMBRID = HI.HMBRID
                                And HM.HMBRTYPE <> 'U'
                                   )
          Join  HIERARCHY H on ( H.hid = hm.Hid
                            and H.HTYPE = 'D'
                                )
          Join  HMBRPROPERTY HP on (HP.Hmbrid = HM.Hmbrid
                                and hp.propertykey = 'DPLAN'
                                )
          Join  DiscountPlan d on (d.discountplanid = hp.propvalnumber
                               And d.DiscountMethod = 'RATE'
                                  )
          Join  HMBRPROPERTY HPD  on (hpd.hmbrid = hm.hmbrid
                                  AND HPD.PropertyKey = 'DSDT'
                                     )
          WHERE HI.INVENTORYID in (select hmi.inventoryid
                                     from HierarchyMbr  bp
                                     join HierarchyMbr  nbp on (nbp.parentbuid = bp.buid)
                                     join HMbrInventory HmI  on (HmI.hmbrid = nbp.hmbrid)
                                    where bp.HMbrID = vHmbrid
                                   )
           order by 2,3
                 ;

        -- SEPI-17994 Check if there is any tax rate change for bill period --
        --            If there is, split echargeaccum on the new tax rate
        --            effective date.
        --            Assume that there is only one non-zero tax code       --
        --            so it doesn't need to check per inventory             --
        CURSOR cTaxRate (iBillFrom  IN DATE
                        ,iBillTo    IN DATE) IS
        SELECT DISTINCT tr.dateactive - 1 AsAtDate
        FROM   taxrate tr
        WHERE  tr.dateactive <= iBillTo
        AND    tr.dateactive >= iBillFrom
        AND    tr.taxratepct > 0;

        l_Now                 DATE := pkg_calc.today;
        l_anr                 pkg_inv.tapricerec;
        l_bnr                 pkg_inv.tapricerec;
        l_nanr                PLS_INTEGER;
        l_nbnr                PLS_INTEGER;
        l_Result              PLS_INTEGER;
        l_Msg                 VARCHAR2(1000);
        l_taECA               taECA;
        l_taOECA              pkg_accum.trRAG;
        i                     PLS_INTEGER := 0;
        j                     PLS_INTEGER := 0;
        m                     PLS_INTEGER := 0;
        l_vc                  VARCHAR2(100);
        l_SplitDate           pkg_std.taDate;
        l_SplitDateVC         pkg_std.taPValCV;
        l_DateTo              DATE;
        l_To                  DATE;
        l_From                DATE;
        l_Rebill_DateFrom     Pkg_Std.taDate;
        l_Rebill_DateTo       Pkg_Std.taDate;
        l_MP_MPRN_SPID        CustomerSite.SupplyPointID%TYPE;   --WR69667
        l_SE_FRMP_StartDate   DATE;                              --WR69667
        l_BillFrom            DATE;
        l_BillTo              DATE;
        l_ReBillFrom          DATE;
        l_ReBillTo            DATE;
        l_RatingPlan_SeasonID pkg_Std.taInt;
        l_Keep                BOOLEAN := FALSE;
        l_GotLock_hmbrid      BOOLEAN := FALSE;
        l_GotLock_site        BOOLEAN := FALSE;
        l_LockHandler         VARCHAR2(128);
        l_LockId1             VARCHAR2(128);
        l_LockId2             VARCHAR2(128);
        l_LockName            VARCHAR2(128);
        l_LockResult          PLS_INTEGER;
        l_latestrdgdate       DATE;
        l_latestTOURddte      DATE; --MHA-898
        -- WR55825 Capacity for processing basic readings
        l_latestrdgdateDumb   DATE;
        l_UtilityType         VARCHAR2(2);

        l_Cons                trCons;
        l_ConsTB              trCons;
        l_Key                 VARCHAR2(100);
        l_Key2                VARCHAR2(100);
        l_TimeBandID          TimeBand.TimeBandID%TYPE;
        l_Consumption         NUMBER;
        l_hvf                 NUMBER;
        l_pcf                 NUMBER;
        l_sitespid            supplypoint.supplypointid%TYPE;
        expected_cnt          PLS_INTEGER := 0;
        rp                    cRP%ROWTYPE;
        l_idx                 PLS_INTEGER;
        l_From_prev           DATE := k_MinDate;
        l_to_prev             DATE := k_MaxDate;
        g_savecons            tasavecons;

        -- WR97143 season boundaries
        la_DateFrom  pkg_std.taDate;
        la_DateTo    pkg_std.taDate;

        -- WR99428 Monthly Graphing

  Type trConsTB    IS Record (ConsSource         varchar2(1)
                             ,TSetId             number
                             ,TBandId            number
                             ,RatingPlanID       number
                             ,DateFrom           Date
                             ,DateTo             Date
                             ,Cons               number
                             ,ConsUnit           varchar2(10)
                             ,NonZeroRate        varchar2(1)
                             );
  Type taCTB       IS Table of trConsTB Index by Varchar2(100);
  --Type taoCTB      IS Table of invoiceConsumption%rowtype Index by BINARY_INTEGER;
                                    -- ConsSource_TimeBand_YYYYMM
  Type trTS_a      Is Record (TSetId         pkg_std.taInt
                             ,RatingPlanID   pkg_std.taInt
                             ,DateFrom       pkg_std.taDate
                             ,DateTo         pkg_std.taDate
                             );
  Type taTS_a      Is Table of trTS_a  Index by Varchar2(100);

        l_CTB_key      varchar2(100);
        l_CTB_key1     varchar2(100);
        la_CTB         taCTB;
        lao_CTB        trInvCons;
        la_Temp        taCTB;
        la_TimeSet     taCTB;
        la_TimeSetTmp  taCTB;
        l_Save_key     varchar2(100);
        la_found       taInt;
        l_CBindx       pls_integer := 0;
        l_tidx         pls_integer;

        l_CT_DateSt    Date;
        la_CT_DateFrom pkg_std.taDate;
        la_CT_DateTo   pkg_std.taDate;
        l_Mixed        varchar2(1);
        l_CT_Temp_St   Date;
        l_CT_Temp_En   Date;
        l_CT_Int_St    Date;
        l_CT_bas_en    Date;
        l_CT_Cons      tasavecons;
        l_YYYYMM       Varchar2(6);
        l_ts_found     boolean;

        -- WR99428 end
        -- WR56993 Matching process
        la_ECAKey             taRAGKey;
        la_ECAIdx             t2daRAGID;
        l_ECAKey              PLS_INTEGER;
        l_ECAIdx              PLS_INTEGER;
        l_ECAKey_Idx          VARCHAR2(100);
        l_ECAIdx_Idx          PLS_INTEGER;

        -- WR57931 Implement creation of DumbAccum
        l2da_DumbCons         t2dDumbCons;
        l_ConsKey             VARCHAR2(100);
        l2da_DumbAccum        t2daDumbAccum;
        l_DAIdx               PLS_INTEGER;
        l_ConsIdx             VARCHAR2(100);

        -- WR57260 Check if there is any RP rate found
        l_FoundRate           BOOLEAN;
        l_Prevspid            PLS_INTEGER := 0;

        xhmbrlock             EXCEPTION;
        xsitelock             EXCEPTION;
        xexit                 EXCEPTION;
        --
        -- WR56993 Apply the consumption
        --
        PROCEDURE ApplyCons(iConKey IN VARCHAR2
                           ,iECAIdx IN PLS_INTEGER) IS
            l_found BOOLEAN;  -- WR57931
            l_PropertyKey rpproperty.propvalchar%TYPE;
            l_consTemp number; -- SEPI-24142
            l_lmt      number;
        BEGIN
            IF l_ConsTB.Consu(iConKey) = l_taECA(iECAIdx).Unit THEN
                l_taECA(iECAIdx).Consumption := NVL(l_taECA(iECAIdx).Consumption, 0) + l_ConsTB.Consumption(iConKey);
                l_ConsTB.ConsA(iConKey) := l_ConsTB.Consumption(iConKey); -- WR99428
            ELSE
                l_Consumption := 0;
                --WR67544 check the Rating Method
                BEGIN
                  SELECT rpp.propertykey
                  INTO  l_PropertyKey
                  FROM  RPPROPERTY  RPP
                  WHERE rpp.ratingplanid = l_taECA(iECAIdx).ratingplanid
                  AND   rpp.propertykey IN ('CONSU', 'DEMDU');
                EXCEPTION WHEN NO_DATA_FOUND THEN
                  l_PropertyKey := 'CONSU';
                END;
                IF l_PropertyKey = 'DEMDU' THEN  -- do not do the conversion for demand
                   l_taECA(iECAIdx).Consumption := NVL(l_taECA(iECAIdx).Consumption,0) + l_Consumption;
                  l_ConsTB.ConsA(iConKey) := l_ConsTB.Consumption(iConKey); -- WR99428
                ELSE
                   pkg_accum.convert_consumption3(iconsumption   => l_ConsTB.Consumption(iConKey)
                                                 ,ilossadjcons   => NULL
                                                 ,irp_units      => l_taECA(iECAIdx).Unit
                                                 ,isp_units      => l_ConsTB.Consu(iConKey)
                                                 ,idatefrom      => l_ConsTB.DateFrom(iConKey)
                                                 ,idateto        => l_ConsTB.DateTo(iConKey)
                                                 ,oconsumption   => l_consumption
                                                 ,oerrorcode     => l_UsageErrorCode
                                                 ,oerrordescr    => l_ErrorMessage
                                                 ,ohvf           => l_hvf
                                                 ,opcf           => l_pcf
                                                 ,ihvarea        => NULL
                                                 ,ihvunit        => NULL
                                                 ,irdpday        => 1
                                                 ,ipcf           => NULL
                                                 ,ipwrf          => NULL
                                                 ,isupplypointid => l_ConsTB.SupplyPointID(iConKey));
                   IF l_UsageErrorCode IS NOT NULL THEN
                       omsg(oMsg.COUNT + 1)   := l_UsageErrorCode || ' - ' || l_ErrorMessage;
                       oRetC(oRetC.COUNT + 1) := 8;
                       RAISE xexit;
                   ELSE
                       -- Base Consumption
                       l_taECA(iECAIdx).Consumption := NVL(l_taECA(iECAIdx).Consumption,0) + l_ConsTB.Consumption(iConKey);
                       -- Get the ConsBilledFactor from pkg_Accum Global Array
                       FOR i IN 1 .. pkg_accum.G_CU.Unit.COUNT LOOP
                           IF upper(pkg_accum.G_CU.FromUnit(i)) = upper(l_ConsTB.Consu(iConKey))
                           AND upper(pkg_accum.G_CU.ToUnit(i)) = upper(l_taECA(iECAIdx).Unit) THEN
                               l_taECA(iECAIdx).consbilledfactor := pkg_accum.G_CU.ConvFactor(i);
                           END IF;
                       END LOOP;
                       -- SEPI-24142 - check to ensure the billed consumption is correctly converted for WA Gas
                       If  l_taECA(iECAIdx).consbilledfactor > 0 and upper(l_taECA(iECAIdx).Unit) = 'UNIT' then
                           --
                           l_lmt := 1;
                           If  instr(to_char(l_taECA(iECAIdx).consbilledfactor), '.') > 0 then
                               l_lmt := 1/power(10,length( substr(to_char(l_taECA(iECAIdx).consbilledfactor),instr(to_char(l_taECA(iECAIdx).consbilledfactor),'.')+1)  ));
                           End If;
                           --
                           If  not l_Consumption between l_ConsTB.Consumption(iConKey)*(l_taECA(iECAIdx).consbilledfactor-l_lmt)
                                                     and l_ConsTB.Consumption(iConKey)*(l_taECA(iECAIdx).consbilledfactor+l_lmt) then                           
                               l_consTemp := l_ConsTB.Consumption(iConKey) * l_taECA(iECAIdx).consbilledfactor;
                               dbms_output.put_line('*Found conversion issue for hmbrid ' || iHMbrID);
                               dbms_output.put_line(' iConKey = ' || iConKey ||'>> '|| l_ConsTB.Consumption(iConKey) ||'*'|| l_taECA(iECAIdx).consbilledfactor ||'( ' || l_consTemp ||' ) <> '||l_Consumption);
                               dbms_output.put_line(' set consumption to '||l_consTemp);                 
                               l_Consumption := l_consTemp;
                           End If;
                       End If;
                       -- Billed Consumption
                       l_taECA(iECAIdx).ConsBilled := NVL(l_taECA(iECAIdx).ConsBilled, 0) + l_Consumption;
                       -- Adjusted Consumption (for later use in InvoiceConsumption)
                       l_ConsTB.ConsA(iConKey) := l_Consumption; -- WR99428
                       --
                   END IF;
                END IF;
            END IF;
            --
            l_taECA(iECAIdx).Match_TimeBand := TRUE;
            l_ConsTB.Found_Match(iConKey)   := FALSE;--???
            --
            -- WR57931 Implement creation of DumbAccum
            --         Link ECA entry to ReadingDumb/Cons list
            --         e.g. l2da_DumbAccum(8)(1) = 2641460_21_20080903000000_20081002000000_N__1_2698067_KWH
            --              8 is the ECA index and 1 is the sequence of readingdumbid
            --
            IF l2da_DumbCons.COUNT > 0 THEN
                IF l2da_DumbAccum.EXISTS(iECAIdx) THEN
                    -- Check duplicate readingdumbid for a same cons charge
                    l_found := FALSE;
                    FOR i IN 1 .. l2da_DumbAccum(iECAIdx).COUNT LOOP
                        IF NVL(l2da_DumbAccum(iECAIdx)(i), 'X') = NVL(iConKey, 'X') THEN
                            l_found := TRUE;
                            EXIT;
                        END IF;
                    END LOOP;
                    --
                    IF NOT l_found THEN
                        l2da_DumbAccum(iECAIdx)(l2da_DumbAccum(iECAIdx).COUNT + 1) := iConKey;
                    ELSE
                        -- Not supposed to be here
                        -- Investigation required
                        omsg(oMsg.COUNT + 1)   := 'Found duplicate ECA matching ConsKey';
                        oRetC(oRetC.COUNT + 1) := 8;
                    END IF;
                ELSE
                    l2da_DumbAccum(iECAIdx)(1) := iConKey;
                END IF;
            END IF;
            --
            IF g_debug THEN
                pkg_util.putbuf('Found match: iConKey = ' || iConKey ||
                                ', iECAIdx = '            || iECAIdx ||
                                ', l_ConsTB = '           || l_ConsTB.Consumption(iConKey) ||
                                ', Consumption = '        || l_taECA(iECAIdx).Consumption
                               ,255
                               ,NULL);
            END IF;
        END ApplyCons;
        --
        -- WR56993 Find TimeBand mapping
        --
        FUNCTION TBMapping(iConsKey IN VARCHAR2
                          ,iECAIdx  IN PLS_INTEGER)
                                    RETURN PLS_INTEGER IS
            l_return   PLS_INTEGER;
            l_rpkey    VARCHAR2(100);
        BEGIN
            -- Find mapping timeband if available
            l_return := l_ConsTB.TimeBandID(iConsKey);
            l_rpkey := l_taECA(iECAIdx).RatingPlanID || ',' || l_ConsTB.TimeBandID(iConsKey);
            --
            IF rpspmaptb.EXISTS(l_rpkey) THEN
                l_return := rpspmaptb(l_rpkey);
            END IF;
            --
            RETURN l_return;
        END TBMapping;
        --
        -- WR57726 Release lock
        --         iLockType = NULL, release lock for hmbrid and sitespid
        --         iLockType = HM, release lock for hmbrid
        --         iLockType = SITE, release lock for sitespid
        --
        --         Locking has been disabled to avoid implicit commit
        --
        PROCEDURE ReleaseLock(iLockType IN VARCHAR2 DEFAULT NULL) IS
            l_locktype VARCHAR2(10) := UPPER(TRIM(iLockType));
        BEGIN
            IF g_lock THEN
                IF l_locktype IS NULL OR l_locktype = 'HM' THEN
                    -- Release lock for hmbrid
                    IF l_GotLock_hmbrid THEN
                        IF pkg_Lock.RELEASE(l_LockId1) THEN
                            l_GotLock_hmbrid := FALSE;
                        END IF;
                    END IF;
                END IF;
                --
                IF l_locktype IS NULL OR l_locktype = 'SITE' THEN
                    -- Release lock for sitespid
                    IF l_GotLock_site THEN
                        IF pkg_Lock.RELEASE(l_LockId2) THEN
                            l_GotLock_site := FALSE;
                        END IF;
                    END IF;
                END IF;
            ELSE
                l_GotLock_hmbrid := FALSE;
                l_GotLock_site   := FALSE;
            END IF;
        END ReleaseLock;
        --
        -- WR57726 Set return code
        --         Find the worst return code from array
        --
        FUNCTION SetReturnCode(iRCList IN pkg_std.taInt)
                                       RETURN PLS_INTEGER IS
            l_return PLS_INTEGER;
        BEGIN
            IF iRCList.COUNT > 0 THEN
                -- Only reset the error ones, as warning ones will have followed the normal processing path.
                l_return := 4;
                --
                FOR i IN 1 .. iRCList.COUNT LOOP
                    IF NVL(iRCList(i), 0) > NVL(l_return, 0) THEN
                        l_return := iRCList(i);
                    END IF;
                END LOOP;
            ELSE
                l_return := 0;
            END IF;
            --
            RETURN l_return;
        END SetReturnCode;

    BEGIN  -- Code section
        oRetC.DELETE;
        oMsg.DELETE;
        orc              := 8;
        l_Msg            := NULL;
        l_GotLock_hmbrid := FALSE;
        --
        l_Msg := 'Failed to issue lock on hmbrid';  -- WR57931
        --
        -- WR57726 Disable locking to avoid implicit commit
        --
        IF g_debug THEN
          IF iDoDemand = 'N' THEN
             pkg_util.putbuf('======[USAGE] ECA CREATION======', 255, NULL);
          ELSE
             pkg_util.putbuf('======[DEMAND] ECA CREATION======', 255, NULL);
          END IF;
        END IF;

        IF g_lock THEN
            l_LockId1    := 'eca_hmbrid' || iHMbrID;
            l_LockResult := pkg_lock.obtain(ilockid   => l_LockId1
                                           ,itimeout  => 10
                                           ,ilockmode => dbms_lock.x_Mode
                                           , -- Exclusive
                                            olockid   => l_LockHandler
                                           ,olockname => l_LockName);
            IF l_LockResult = 0 THEN
                l_GotLock_hmbrid := TRUE;
            ELSE
                omsg(oMsg.COUNT + 1)   := 'Can not obtain lock ' || l_LockId1 || ' as is currently processed by another job';
                oRetC(oRetC.COUNT + 1) := 8;
                RAISE xhmbrlock;
            END IF;
        END IF;
        --
        l_Msg := 'Failed to find reference data';  -- WR57931
        --
        IF g_brcaltype IS NULL THEN
            FOR rec IN (SELECT FeatureVal
                              ,Featurekey
                        FROM   feature
                        WHERE  featurekey IN ('RAGSPLIT', 'ACCUMRNDSTYLE1', 'RND2DEC')) LOOP  -- WR55825
                CASE rec.featurekey
                    WHEN 'RAGSPLIT' THEN
                        g_brcaltype := rec.FeatureVal;
                    WHEN 'ACCUMRNDSTYLE1' THEN
                        g_AccumRndStyle1 := rec.FeatureVal;
                    WHEN 'RND2DEC' THEN
                        g_RND2DEC := rec.FeatureVal;
                END CASE; END LOOP;
        END IF; -- perftest end

        -- WR55825 Capacity for processing basic readings
        g_RdgCloseBP := NVL(pkg_feature.Val('RDGBP'), 'Y'); -- Default to Y
        --
        l_Msg := 'Failed to load timeband and/or timeset';  -- WR57931
        --
        IF l_TimeBand.COUNT = 0 THEN
            FOR tb IN (SELECT timebandid
                             ,descr
                       FROM   TimeBand) LOOP
                l_TimeBand(tb.TimeBandID) := tb.Descr;
            END LOOP;
        END IF;
        --
        IF l_TimeSet.COUNT = 0 THEN
            FOR ts IN (SELECT timeSetId
                             ,descr
                       FROM   TimeSet) LOOP
                l_TimeSet(ts.TimeSetID) := ts.Descr;
            END LOOP;
        END IF;
        --
        IF l_FeedinTB.COUNT = 0 THEN
            -- SEPI-13155 (Fix Issues with Original Query)
            FOR fi IN (SELECT  ctp1.propvalnumber
                       FROM    codetableline ctl
                       JOIN    propertyset ps ON ps.psid = ctl.psid
                                              AND ps.pskey = 'CDTB_GGCERPT_LST'
                       JOIN    ctlineproperty ctp1 ON ctp1.codetablelineid = ctl.codetablelineid
                                                   AND ctp1.propertykey = 'EXCLTIMEBAND'
                       )
            LOOP
                l_FeedinTB(fi.propvalnumber) := l_TimeBand(fi.propvalnumber);
            END LOOP;
        END IF;
        --
        IF l_Timerange.COUNT = 0 THEN
            FOR ts IN (SELECT timebandid
                             ,timesetversionid
                             ,timerangeid
                       FROM   Timerange) LOOP
                IF NOT l_Timerange.EXISTS(ts.timesetversionid || ',' || ts.timebandid) THEN
                    l_Timerange(ts.timesetversionid || ',' || ts.timebandid) := ts.timerangeid;
                END IF;
            END LOOP;
        END IF;
        --
        l_Msg := 'Failed to identify billing period';  -- WR57931
        --
        -- wr61535 :  change to enable calculate rags on the fly for any period independent of last bill period
        IF idatefrom is null then
            BEGIN
             SELECT MAX(i.DateTo) + 1
                INTO l_BillFrom
                FROM Invoice i
               WHERE i.HMbrID = iHMbrID
                 AND Invoicestatus NOT IN ('W', 'CWP', 'DWP');
            EXCEPTION
              WHEN no_Data_Found THEN
                l_BillFrom := NULL;
            END;
        else
            l_BillFrom := idatefrom;
        end if;
        --
        l_BillFrom := NVL(l_BillFrom
                         ,k_MinDate);
        l_BillTo   := NVL(iDateTo
                         ,l_Now);
        g_BillFrom := l_BillFrom;
        --
        -- WR69667 start - Ensure we do not bill from before start of current FRMP period with SE.  This has been added especially for returning customers but will work for newbies and continuing customers too
        --   Note, as at WR69667, the below 2 step method to determine the start of current FRMP period took < 0.02 seconds to execute.
        l_Msg := 'Failed to get latest customer MP/MPRN SPID from HMbrID='||iHMbrID||' as at '||iDateTo ;
        FOR rec IN (SELECT DISTINCT spid.PropValNumber SPID, i.DateActive, i.DateDeActive
                    FROM HierarchyMbr  bp
                        ,HierarchyMbr  nbp
                        ,HMbrInventory hmi
                        ,Inventory     i
                        ,InvProperty   spid
                        ,Product       p
                    WHERE  bp.HMbrID = iHMbrID
                       AND bp.buid = nbp.Parentbuid
                       AND nbp.hmbrid = hmi.hmbrid
                       AND hmi.InventoryID = i.InventoryID
                       AND i.dateactive <= iDateTo  -- only interested in MP/MPRN starting on or before the As At Date of the new Invoice -- MHA-1357
                       AND i.InventoryID = spid.InventoryID
                       AND spid.PropertyKey = 'SPID'
                       AND i.ProductID = p.productID
                       AND p.Chargetype LIKE 'U%'
                    ORDER BY i.DateActive DESC, i.DateDeActive DESC) -- if more than one MP/MPRN started on or before the As At Date of the new Invoice, get the latest MP/MPRN
        LOOP
            l_MP_MPRN_SPID := rec.SPID;
            EXIT;  -- just want first record read
        END LOOP;
        IF l_MP_MPRN_SPID IS NULL THEN
           Raise_Application_Error(-20012,'pkg_AMI.NewECA '||l_Msg);
        END IF;

        -- l_Msg := 'Failed to identify Simply Energy FRMP Start Date for HMBRID='||iHMbrID||' and SPID='||l_MP_MPRN_SPID; --- MHA-41
        l_Msg := 'Failed to identify FRMP Start Date for HMBRID='||iHMbrID||' and SPID='||l_MP_MPRN_SPID;
        FOR rec IN (SELECT spp.datestart
                    FROM supplypoint sp
                        ,spproperty spp
                        ,Thirdparty tp
                        ,TPPROPERTY tpp
                    WHERE sp.metertype in ('MP','MPRN')
                      AND sp.supplypointid = l_MP_MPRN_SPID
                      AND sp.supplypointid = spp.supplypointid
                      AND spp.propertykey  = 'RTL2'
                      AND spp.propvalnumber = tp.thirdpartyid
                      AND tp.thirdpartyid   = tpp.thirdpartyid
                      AND tpp.propertykey   = 'HOFLG'
                      AND tpp.propvalchar   = 'Y'
                      AND spp.datestart <= iDateTo  -- only interested in FRMP periods (hub retailer period) starting on or before the As At Date of the new Invoice
                    ORDER BY spp.datestart DESC, spp.dateend DESC)    -- if SPID has had more than hub retailer period that started on or before the As At Date of the new Invoice, get the latest period
        LOOP
            l_SE_FRMP_StartDate := rec.DateStart;
            EXIT;  -- just want first record read
        END LOOP;
        IF l_SE_FRMP_StartDate IS NULL THEN
           Raise_Application_Error(-20012,'pkg_AMI.NewECA '||l_Msg);
        END IF;
        --
        -- WR57408 To avoid unnecessary rebill, always pass NULL to rebill period.
        --
        l_ReBillFrom := NULL;
        l_ReBillTo   := NULL;
        --
        -- WR69667 end (including line change below) - Re Bill From the latest of the dates: k_MinDate, the to date of the previous bill or the start of this current FRMP period with SE
        l_ReBillFrom := NVL(l_ReBillFrom, GREATEST(l_BillFrom,l_SE_FRMP_StartDate));
        l_ReBillTo   := NVL(l_ReBillTo, l_BillTo);
        g_BillFrom   := l_ReBillFrom; --
        --
        -- Now we have a list of which dates to bill from and to for the current period,
        -- plus we know which bills from the past need to be rebilled.
        --
        -- WR55825 Some important comments:
        --         Comparing the current splitting in pkg_accum, some functionality have been missing:
        --         i)   Procedure Process_TCA -- IF NOT g_LFHierarchyUsed THEN
        --                                          wr18599 do not split on LF when a LF hierarchy is used
        --                                          l_FoundIt := FALSE;
        --         ii)  Procedure Process_TCA -- Split the RAG based on Bill Currency Change.
        --         iii) Procedure Process_TCA -- Split the RAG based on AnnDt rollover within the period
        --         iv)  Procedure Process_TCA -- Event Billing: Split on unbilled reading dates that occur
        --                                       upto and before the reading currently being processed.
        --
        l_Msg := 'Failed to load split date';  -- WR57931
        --
        m := 0;
        l_SplitDate.DELETE;
        l_SplitDateVC.DELETE;
        FOR asat IN cAsAt(iHMbrID
                         ,l_ReBillFrom
                         ,l_BillTo
                         ,g_brcaltype
                         ,iDoDemand) LOOP
            IF NOT l_SplitDateVC.exists(to_char(AsAt.AsAtDate,'YYYYMMDD')) THEN
                l_SplitDateVC(to_char(AsAt.AsAtDate,'YYYYMMDD')) := to_char(AsAt.AsAtDate,'YYYYMMDD');
                m := l_SplitDate.count + 1;
                l_SplitDate(m) := AsAt.AsAtDate;
                IF g_Debug THEN
                    dbms_output.put_line('As At Split Date = '||TO_char(asat.asatdate,'DD MON YYYY')||' Now there are '||l_SplitDate.count);
                END IF;
            END IF;
        END LOOP;

        -- SEPI-17994
        -- load split date for Tax Rate change
        FOR rTax IN cTaxRate (l_ReBillFrom
                              ,l_BillTo)
        LOOP
            IF NOT l_SplitDateVC.exists(to_char(rTax.AsAtDate,'YYYYMMDD')) THEN
                l_SplitDateVC(to_char(rTax.AsAtDate,'YYYYMMDD')) := to_char(rTax.AsAtDate,'YYYYMMDD');
                m := l_SplitDate.count + 1;
                l_SplitDate(m) := rTax.AsAtDate;
                IF g_Debug THEN
                    dbms_output.put_line('As At Split Date = '||TO_char(rTax.AsAtDate,'DD MON YYYY')||' Now there are '||l_SplitDate.count);
                END IF;
            END IF;
        END LOOP;
        --
        -- SEPI-16932
        -- load split date for Rate Reduction
        FOR rRec IN cAsAT_RateReduction(iHMbrID)
        LOOP
            IF NOT l_SplitDateVC.exists(to_char(rRec.DS,'YYYYMMDD')) THEN
                l_SplitDateVC(to_char(rRec.DS,'YYYYMMDD')||'_'||rRec.Inventoryid) := to_char(rRec.DS,'YYYYMMDD');
                m := l_SplitDate.count + 1;
                l_SplitDate(m) := rRec.DS;
                IF g_Debug THEN
                    dbms_output.put_line('Rate Reduction Change Split Date = '||TO_char(rRec.DS,'DD MON YYYY')||' for inventory id '||rRec.Inventoryid);
                END IF;
            END IF;
            --
            IF NOT l_SplitDateVC.exists(to_char(rRec.De,'YYYYMMDD')) THEN
                l_SplitDateVC(to_char(rRec.De,'YYYYMMDD')||'_'||rRec.Inventoryid) := to_char(rRec.De,'YYYYMMDD');
                m := l_SplitDate.count + 1;
                l_SplitDate(m) := rRec.De;
                IF g_Debug THEN
                    dbms_output.put_line('Rate Reduction Change Split Date = '||TO_char(rRec.De,'DD MON YYYY')||' for inventory id '||rRec.Inventoryid);
                END IF;
            END IF;
        END LOOP;
        --
        l_mixed     := null;
        l_Msg := 'Failed to generate the echargeaccum list';  -- WR57931
        -- Now we know which dates to split the new ECA's on.
        l_GotLock_site := FALSE;
        -- Get a list of all the top level products, ie: One's that dont have a parent.
        FOR rec IN cInv(iHMbrID
                       ,l_ReBillFrom
                       ,l_BillTo
                       ,iDoDemand) LOOP
            -- For each base product, populate the ProductCharge table
            --IF rec.chargetype LIKE 'U%' THEN  -- WR55825 Redundant test, condition already appiled in cursor cInv
                IF NOT l_GotLock_site THEN
                    l_Msg := 'Failed to issue lock on sitespid';  -- WR57931
                    --
                    SELECT sitespid
                    INTO   l_sitespid
                    FROM   supplypointlookup l
                    WHERE  supplypointid = rec.SPID
                    AND    l_BillTo BETWEEN datestart AND NVL(dateend
                                                             ,k_MaxDate)
                    AND    rownum <= 1;
                    --
                    -- WR57726 Disable locking to avoid implicit commit
                    --
                    IF g_lock THEN
                        l_LockId2    := 'eca_SiteSPID' || l_sitespid;
                        l_LockResult := pkg_lock.Obtain(ilockid   => l_LockId2
                                                       ,itimeout  => 0
                                                       ,ilockmode => dbms_lock.x_Mode  -- Exclusive
                                                       ,olockid   => l_LockHandler
                                                       ,olockname => l_LockName);
                        IF l_LockResult = 0 THEN
                            l_GotLock_site := TRUE;
                        ELSE
                            omsg(oMsg.COUNT + 1)   := 'Can not obtain lock ' || l_LockId2 || ' as is currently processed by another job';
                            oRetC(oRetC.COUNT + 1) := 8;
                            RAISE xsitelock;
                        END IF;
                    ELSE
                        l_GotLock_site := TRUE;
                    END IF;
                    --
                    l_Msg := 'Failed to find the latest ReadingTOU';  -- WR57931
                    --
                    IF rec.MeterType LIKE 'SITE%' THEN
                        SELECT NVL(MAX(timestamp) - 1 / 86400
                                  ,l_ReBillFrom)
                        INTO   l_latestrdgdate
                        FROM   ReadingTOU        t
                              ,SupplyPointLookup lu
                        WHERE  t.SupplyPointID = lu.SupplyPointID
                        AND    lu.SiteSPID = rec.SPID
                        AND    t.processstatus = 'A'
                        AND    t.timestamp > l_ReBillFrom
                        AND    t.PartKey = lu.PartKey;
                    ELSIF rec.MeterType = 'MP' THEN
                        SELECT NVL(MAX(timestamp) - 1 / 86400
                                  ,l_ReBillFrom)
                        INTO   l_latestrdgdate
                        FROM   ReadingTOU        t
                              ,SupplyPointLookup lu
                        WHERE  t.SupplyPointID = lu.SupplyPointID
                        AND    lu.MPSPID = rec.SPID
                        AND    t.processstatus = 'A'
                        AND    t.timestamp > l_ReBillFrom
                        AND    t.PartKey = lu.PartKey;
                    ELSIF rec.MeterType = 'TOUR' THEN
                        SELECT NVL(MAX(timestamp) - 1 / 86400
                                  ,l_ReBillFrom)
                        INTO   l_latestrdgdate
                        FROM   ReadingTOU t
                        WHERE  t.SupplyPointID = rec.SPID
                        AND    t.processstatus = 'A'
                        AND    t.timestamp > l_ReBillFrom;
                    ELSE
                        -- Because of the lack of a suitable index, we need to join SPLookup twice
                        SELECT NVL(MAX(timestamp) - 1 / 86400
                                  ,l_ReBillFrom)
                        INTO   l_latestrdgdate
                        FROM   ReadingTOU        t
                              ,SupplyPointLookup lu
                              ,SupplyPointLookup lu2
                        WHERE  t.SupplyPointID = lu.SupplyPointID
                        AND    lu2.sitespid = lu.sitespid
                        -- WR57786 Handle multiple MP under the same SITE
                        AND    lu2.mpspid = lu.mpspid
                        AND    lu2.Supplypointid = rec.SPID
                        AND    t.processstatus = 'A'
                        AND    t.timestamp > l_ReBillFrom
                        AND    t.PartKey = lu.PartKey;
                    END IF;
                    --
                    -- WR55825 Capacity for processing basic readings
                    --         Check if there is any basic readings to be processed
                    --         g_RdgCloseBP = 'Y'  -> First day of reading period is day after previous reading date,
                    --                                and last day is day of current reading date.
                    --         g_RdgCloseBP = ELSE -> First day of reading period is the previous reading date,
                    --                                and Last day is the day before the current reading date
                    --
                    l_Msg := 'Failed to find the latest ReadingDUMB';  -- WR57931
                    --
                    IF rec.MeterType LIKE 'SITE%' THEN
                        SELECT NVL(DECODE(g_RdgCloseBP
                                         ,'Y', MAX(timestamp)
                                         ,MAX(timestamp) - 1)
                                  ,l_ReBillFrom)
                        INTO   l_latestrdgdateDumb
                        FROM   readingdumb       d
                              ,SupplyPointLookup lu
                        WHERE  d.SupplyPointID = lu.SupplyPointID
                        AND    lu.SiteSPID = rec.SPID
                        AND    d.processstatus = 'A'
                        AND    d.timestamp > l_ReBillFrom;
                    ELSIF rec.MeterType LIKE 'MP%' THEN
                        SELECT NVL(DECODE(g_RdgCloseBP
                                         ,'Y', MAX(timestamp)
                                         ,MAX(timestamp) - 1)
                                  ,l_ReBillFrom)
                        INTO   l_latestrdgdateDumb
                        FROM   readingdumb       d
                              ,SupplyPointLookup lu
                        WHERE  d.SupplyPointID = lu.SupplyPointID
                        AND    lu.MPSPID = rec.SPID
                        AND    d.processstatus = 'A'
                        AND    d.timestamp > l_ReBillFrom;
                    ELSIF rec.MeterType IN ('MRDR', 'SRDG','SRDH') THEN
                        SELECT NVL(DECODE(g_RdgCloseBP
                                         ,'Y', MAX(timestamp)
                                         ,MAX(timestamp) - 1)
                                  ,l_ReBillFrom)
                        INTO   l_latestrdgdateDumb
                        FROM   readingdumb d
                        WHERE  d.SupplyPointID = rec.SPID
                        AND    d.processstatus = 'A'
                        AND    d.timestamp > l_ReBillFrom;
                    ELSE
                        -- Because of the lack of a suitable index, we need to join SPLookup twice
                        SELECT NVL(DECODE(g_RdgCloseBP
                                         ,'Y', MAX(timestamp)
                                         ,MAX(timestamp) - 1)
                                  ,l_ReBillFrom)
                        INTO   l_latestrdgdateDumb
                        FROM   readingdumb       d
                              ,SupplyPointLookup lu
                              ,SupplyPointLookup lu2
                        WHERE  d.SupplyPointID = lu.SupplyPointID
                        AND    lu2.sitespid = lu.sitespid
                        -- WR57786 Handle multiple MP under the same SITE
                        AND    lu2.mpspid = lu.mpspid
                        AND    lu2.Supplypointid = rec.SPID
                        AND    d.processstatus = 'A'
                        AND    d.timestamp > l_ReBillFrom;
                    END IF;
                    --
                    -- WR71013: l_latestrdgdate is usually one second before midnight of the final day of readings.
                    --  whereas l_latestrdgdateDumb is midnight (mtrd) or noon (manual) of the day.
                    --  Round the latter to the second before the end of that day.
                    -- The result allows a fairer comparison, and allows us to find dumb tariffs that start or change on this final day.
                    l_latestrdgdateDumb := trunc(l_latestrdgdateDumb) + 86399/86400;
                    --
                    --
                    -- WR55825 Capacity for processing basic readings
                    --
                    IF g_debug THEN
                        pkg_util.putbuf('TOU: l_latestrdgdate = '        || to_char(l_latestrdgdate,'DD/MON/YYYY HH24:MI:SS') ||
                                        ', DUMB: l_latestrdgdateDumb = ' || to_char(l_latestrdgdateDumb,'DD/MON/YYYY HH24:MI:SS')
                                       ,255
                                       ,NULL);
                    END IF;
                    --
                    -- WR99428
                    If  trunc(l_latestrdgdate) <> trunc(l_ReBillFrom)
                        and trunc(l_latestrdgdateDumb) <> trunc(l_ReBillFrom) Then
                        -- both interval and basic
                        l_Mixed := 'Y';
                        --
                    Elsif trunc(l_latestrdgdate) <> trunc(l_ReBillFrom) Then
                        -- interval only
                        l_Mixed := 'I';
                        --
                    Elsif trunc(l_latestrdgdateDumb) <> trunc(l_ReBillFrom) Then
                        -- basic only
                        l_Mixed := 'B';
                        --
                        if  iDateFrom is not null then
                            pkg_accum.g_rdg.TIMESTAMP := l_latestrdgdateDumb;
                        End If;
                        --
                    End If;

                    l_latestTOURddte := l_latestrdgdate;

                    l_latestrdgdate := GREATEST(l_latestrdgdate, l_latestrdgdateDumb);
                    --

                    IF l_latestrdgdate = l_latestTOURddte Then --- MHA-898 tou readings
                       IF l_latestrdgdate <=  l_ReBillFrom  THEN
                          omsg(oMsg.COUNT + 1)   := 'There exists no accumulated readings to aggregate';
                          oRetC(oRetC.COUNT + 1) := 8;
                          RAISE xexit;
                       END IF;
                    ELSIF trunc(l_latestrdgdate) = trunc(l_ReBillFrom) THEN
                        omsg(oMsg.COUNT + 1)   := 'There exists no accumulated readings to aggregate';
                        oRetC(oRetC.COUNT + 1) := 8;
                        RAISE xexit;
                    END IF;
                    --
                    -- WR55825 Enhancement of splitting on a loss factor change
                    --         For both basic and interval readings, Electricity only
                    --         If the utility type is Electricity, we need to check if there is TLF/DLF changes within the ECA period
                    --         We need to split the EChargeAccum entries on a change in Loss Factor during a billing period
                    --         Note, we consider both DLF and TLF as date effective although currently TLF is not
                    --
                    l_Msg := 'Failed to split charges on a loss factor change';  -- WR57931
                    --
                    l_UtilityType := GetUtilityType(rec.SPID);
                    --
                    IF l_UtilityType IS NULL THEN
                        omsg(oMsg.COUNT + 1)   := 'Can not identify utility type for SPID: ' || rec.SPID;
                        oRetC(oRetC.COUNT + 1) := 8;
                        RAISE xexit;
                    ELSIF l_UtilityType = 'E' THEN
                        -- Reload split date with new cursor cAsAt_LFC
                        m := 0;
                        --l_SplitDate.DELETE;
                        FOR asat IN cAsAt_LFC(iHMbrID
                                             ,rec.SPID
                                             ,l_ReBillFrom
                                             ,l_BillTo
                                             ,g_brcaltype
                                             ,iDoDemand) LOOP
                            IF NOT l_SplitDateVC.exists(to_char(AsAt.AsAtDate,'YYYYMMDD')) THEN
                                l_SplitDateVC(to_char(AsAt.AsAtDate,'YYYYMMDD')) := to_char(AsAt.AsAtDate,'YYYYMMDD');
                                m := l_SplitDate.count + 1;
                                l_SplitDate(m) := AsAt.AsAtDate;
                                IF g_Debug THEN
                                    dbms_output.put_line('LF Change Split Date = '||TO_char(asat.asatdate,'DD MON YYYY')||' Now there are '||l_SplitDate.count);
                                END IF;
                            END IF;
                        END LOOP;
                    END IF;
                END IF;
                -- WR57260 Init l_FoundRate for each inventory
                l_FoundRate := FALSE;
                --
                l_Msg := 'Failed to find inventory/product rate';  -- WR57931
                --
                l_result := pkg_inv.PriceHistArr(iinvid        => rec.InventoryID
                                                ,idtlo         => GREATEST(rec.dateactive, l_ReBillFrom)
                                                ,idthi         => NVL(rec.datedeactive, l_BillTo)
                                                ,icurrencycode => rec.Currencycode
                                                ,anr           => l_anr
                                                ,nanr          => l_nanr
                                                ,bnr           => l_bnr
                                                ,nbnr          => l_nbnr
                                                ,omsg          => l_Msg);
                IF NVL(l_Result,0) > 0 THEN
                    oMsg(oMsg.COUNT + 1)   := l_Msg;
                    oRetc(oRetC.COUNT + 1) := l_Result;
                END IF;
                -- WR57260 Set error message
                l_Msg := 'Failed to find RatingPlan rate';
                --
                IF l_Result = 0
                AND l_nanr > 0 THEN
                    FOR i IN 1 .. l_nanr LOOP
                        IF l_bnr(i).RatingPlanID IS NOT NULL
                        AND NOT rparr.EXISTS(l_bnr(i).RatingPlanID) THEN
                            --
                            l_Msg := 'Failed to load rating plan';  -- WR57931
                            -- ratingplan has not been cached
                            OPEN cRP(l_bnr(i).RatingPlanID);
                            FETCH cRP BULK COLLECT
                                INTO rparr(l_bnr(i).RatingPlanID) .rpdet; -- cache rating plan
                            CLOSE cRP;
                            rparr(l_bnr(i).RatingPlanID).idx := 1; -- initialize index for performance
                            --
                            l_Msg := 'Failed to load timeband mapping';  -- WR57931
                            -- Cache the TimeBand Mapping information as well.
                            FOR tb IN (SELECT RPTimeBandID
                                             ,SPTimeBandID
                                       FROM   RPTiBandSPTiBand
                                       WHERE  RatingPlanID = l_bnr(i).RatingPlanID) LOOP
                                l_key2 := l_bnr(i).RatingPlanID || ',' || tb.sptimebandid;
                                rpspmaptb(l_key2) := tb.rptimebandid;
                            END LOOP;
                        END IF;
                        --
                        l_Msg := 'Failed to find RatingPlan rate';  -- WR57931
                        --
                        IF rparr.EXISTS(l_bnr(i).RatingPlanID) THEN
                            FOR ix IN rparr(l_bnr(i).RatingPlanID).idx .. rparr(l_bnr(i).RatingPlanID).rpdet.COUNT LOOP
                                IF rparr(l_bnr(i).RatingPlanID).rpdet(ix).datestart > l_bnr(i).DeActiveDate THEN
                                    -- do not search further in ratingplan cache
                                    EXIT;
                                END IF;
                                -- check cache loop
                                IF rparr(l_bnr(i).RatingPlanID).rpdet(ix).datestart <= l_bnr(i).DeActiveDate
                                AND NVL(trunc(rparr(l_bnr(i).RatingPlanID).rpdet(ix).dateend)+86399/86400,k_maxdate) > l_bnr(i).ActiveDate THEN -- WR72187: Round up to nearly end of the day.
                                    -- WR57260 Indicate RP rate found
                                    IF NOT l_FoundRate THEN
                                        l_FoundRate := TRUE;
                                    END IF;
                                    --
                                    rp := rparr(l_bnr(i).RatingPlanID).rpdet(ix);
                                    rparr(l_bnr(i).RatingPlanID).idx := ix;
                                    l_RatingPlan_SeasonID(rp.RatingPlanID) := rp.SeasonID;
                                    l_From := TRUNC(GREATEST(rp.DateActive
                                                            ,l_bnr(i).ActiveDate
                                                            ,l_ReBillFrom));
                                    IF l_From < l_latestrdgdate THEN
                                        -- to handle when readings are not up to date
                                        l_To := TRUNC(LEAST(NVL(rp.DateDeActive
                                                               ,l_latestrdgdate)
                                                           ,NVL(l_bnr(i).DeActiveDate
                                                               ,l_latestrdgdate)
                                                           ,l_latestrdgdate));
                                        /* WR136279. Remove this checking since it is already performed in pkg_readingcomp and we need to allow NMI inactive period.
                                        IF l_From_prev <> l_From
                                           AND l_to_prev <> l_To THEN
                                            l_From_prev := l_From;
                                            l_to_prev   := l_To;
                                            -- get actual nr of accumulated reading for a aggregated cons period
                                            -- pre-validation to skip processing there exists missing reads
                                            l_Msg := 'Failed to verify the expecting readingTOU count';  -- WR57931
                                            --
                                            FOR rdgcnt IN (SELECT COUNT(*) cnt
                                                                 ,lu.SupplyPointID
                                                           FROM   ReadingTOU        t
                                                                 ,SupplyPointLookup lu
                                                           WHERE  t.SupplyPointID = lu.SupplyPointID
                                                           AND    lu.sitespid = l_sitespid
                                                           AND    t.processstatus = 'A'
                                                           AND    t.timestamp > l_From
                                                           AND    t.timestamp <= l_To + 1
                                                           AND    lu.metertype LIKE 'TOU%'
                                                           AND    lu.datestart <= l_From
                                                           AND   (lu.dateend IS NULL OR (trunc(lu.dateend)+86399/86400) > l_To)  -- WR55825, WR71287
                                                           AND    EXISTS (SELECT 0
                                                                          FROM   spproperty
                                                                          WHERE  supplypointid = lu.SupplyPointID
                                                                          AND    propertykey = 'NBREG'
                                                                          AND    PROPVALCHAR = 'N')
                                                           GROUP  BY lu.SupplyPointID) LOOP
                                                -- check whether the actual nr of readings equal to the expected nr
                                                expected_cnt := 0;
                                                FOR rec2 IN (SELECT NVL(PropValNumber
                                                                       ,0) rdperday
                                                                   ,datestart
                                                                   ,dateend
                                                             FROM   SPPROPERTY p
                                                             WHERE  SupplyPointID = rdgcnt.SupplyPointID
                                                             AND    PropertyKey = 'RDPDAY'
                                                             AND    p.datestart <= l_To
                                                             AND   (p.dateend IS NULL OR p.dateend >= l_From)  -- WR55825
                                                             ) LOOP
                                                    -- WR55825
                                                    expected_cnt := expected_cnt + rec2.rdperday * (LEAST(TRUNC(l_To)
                                                                                                         ,TRUNC(NVL(rec2.dateend
                                                                                                                   ,k_MaxDate))) - GREATEST(TRUNC(l_From)
                                                                                                                                           ,TRUNC(NVL(rec2.datestart
                                                                                                                                                     ,k_MinDate))) + 1);
                                                END LOOP;
                                                --
                                                IF rdgcnt.cnt <> expected_cnt THEN
                                                    l_ErrorMessage := 'Missing reading for period between ' || l_From ||
                                                                      ' and ' || l_To || ' for spid ' || rdgcnt.SupplyPointID ||
                                                                      ' , Hmbrid ' || iHMbrID;
                                                    RAISE X_OOPS;
                                                END IF;
                                            END LOOP;
                                        END IF; */
                                        --
                                        j := j + 1;
                                        l_taECA(j).inventoryid      := rec.inventoryid;
                                        l_taECA(j).supplypointid    := rec.SPID;
                                        l_taECA(j).timebandid       := rp.timebandid;
                                        l_taECA(j).etimechargeid    := rp.etimechargeid;
                                        l_taECA(j).datefrom         := l_From;
                                        l_taECA(j).dateto           := l_To;
                                        l_taECA(j).consumption      := NULL;
                                        l_taECA(j).factor1          := NULL;
                                        l_taECA(j).factor2          := NULL;
                                        l_taECA(j).chargeamtbill    := NULL;
                                        l_taECA(j).chargeamtbase    := NULL;
                                        l_taECA(j).invoicechargeid  := NULL;
                                        l_taECA(j).rowversion       := '0';
                                        l_taECA(j).consbilled       := NULL;
                                        l_taECA(j).consbilledfactor := NULL;
                                        l_taECA(j).DEMANDID         := NULL;
                                        l_taECA(j).CONSADJUSTED     := NULL;
                                        l_taECA(j).RatingPlanID     := rp.ratingplanid;
                                        l_taECA(j).SeasonID         := rp.SeasonID;
                                        l_taECA(j).TIMESETID        := rp.timesetid;
                                        l_taECA(j).UNIT             := rp.unit;
                                        l_taECA(j).TimestampUpd     := l_Now;
                                        l_taECA(j).PROCESSSTATUS    := NULL;
                                        l_taECA(j).meterType        := rec.MeterType;
                                        l_taECA(j).UDST             := rp.UDST;
                                        l_taECA(j).Match_TimeBand   := FALSE;
                                        l_taECA(j).rType            := null;
                                        l_taECA(j).productsubclass  := rec.productsubclass;   --WR99428
                                        l_taECA(j).CountNonZeroRate := rp.CountNonZeroRate;
                                       -- WR97143
                                        l_Msg := 'Failed to load the Season Boundaries';
                                        la_DateFrom.delete;
                                        la_DateTo.delete;
                                        --
                                        IF iDoDemand = 'N' THEN
                                          Get_TS_SeasonBoundaries(rp.timesetid
                                                                 ,rp.timebandid
                                                                 ,l_From
                                                                 ,l_To
                                                                 ,la_DateFrom
                                                                 ,la_DateTo
                                                                 );
                                        ELSE
                                          -- demand doesn't need seasonality
                                          la_DateFrom(1) := l_From;
                                          la_DateTo(1)   := l_To;
                                        END IF;
                                        --
                                        For SB in 1 .. la_DateFrom.count
                                        loop
                                            --
                                            If  SB > 1 Then
                                                -- not the first
                                                -- replicate the current row
                                                l_taECA(j + 1) := l_taECA(j);
                                                j := j + 1;
                                                --
                                            End If;
                                            --
                                            l_taECA(j).dateFrom := la_DateFrom(SB);
                                            l_taECA(j).dateTo   := la_DateTo(SB);
                                        --
                                        l_Msg := 'Failed to split the change';  -- WR57931
                                        --
                                        l_VC := l_SplitDateVC.first;
                                        FOR s IN 1 .. l_SplitDateVC.COUNT LOOP

                                            If  substr(l_VC,9,1) is null or substr(l_VC,10) = l_taECA(j).inventoryId Then  -- SEPI-16932
                                                --IF  to_date(l_SplitDateVC(l_VC),'YYYYMMDD') > l_taECA(j).dateFrom -- WR97143 -- l_From
                                                IF  to_date(l_SplitDateVC(l_VC),'YYYYMMDD') >= l_taECA(j).dateFrom       -- SEPI-13338  Demand - not creating a single day echargeaccum. e.g. split date:31-Jan, inventory start:31-Jan. Should create 31-Jan to 31-Jan ECA.
                                                AND to_date(l_SplitDateVC(l_VC),'YYYYMMDD') <  l_taECA(j).dateTo   THEN
                                                    -- Only split if the split date is between the rows
                                                    --pkg_util.putbuf('Split this one up on '||to_date(l_SplitDateVC(l_VC),'YYYYMMDD')
                                                    --              ||' What was '||l_taECA(j).dateFrom||' to '||l_taECA(j).dateTo, 255, NULL);
                                                    -- Split this one up
                                                    l_DateTo                := l_taECA(j).dateTo;         -- Save off the EndDate
                                                    l_taECA(j + 1)          := l_taECA(j);                -- Replicate the current row
                                                    l_taECA(j).dateTo       := TRUNC(to_date(l_SplitDateVC(l_VC),'YYYYMMDD'));     -- Reset the current entries end date to the split date
                                                    l_taECA(j + 1).DateFrom := TRUNC(to_date(l_SplitDateVC(l_VC),'YYYYMMDD')) + 1; -- Reset the Start of the new row
                                                    --pkg_util.putbuf('Is now '||l_taECA(j).dateFrom||' to '||l_taECA(j).dateTo, 255, NULL);
                                                    j := j + 1; -- Move onto the next ECA row
                                                    --pkg_util.putbuf('with a new row from '||l_taECA(j).dateFrom||' to '||l_taECA(j).dateTo, 255, NULL);
                                                END IF;
                                            END IF;
                                            l_VC := l_SplitDateVC.next(l_VC);
                                        END LOOP;
                                        End Loop;    -- WR97143
                                        -- To Do, Still need to do the following
                                        -- Update ADC
                                        -- Split ECA on
                                        -- Loss Factor change
                                        -- Change of Currency ??? (or just reject it if there are more than one currency)
                                    END IF;
                                END IF;
                            END LOOP;
                        END IF;
                        --
                        IF rparr.EXISTS(l_bnr(i).RatingPlanID) THEN
                            rparr(l_bnr(i).RatingPlanID).idx := 1;
                        END IF;
                    END LOOP;  -- l_nanr loop
                END IF;
                -- WR57260 Raise exception if no rate found for the entire billing period
                IF NOT l_FoundRate THEN
                    Raise_Application_Error(-20012
                                           ,'No RP rate found for period between ' || GREATEST(rec.dateactive,l_ReBillFrom) ||
                                            ' and ' || NVL(rec.datedeactive ,l_BillTo) || ' for inventoryid ' || rec.InventoryID);
                END IF;
        END LOOP;
        --
        la_TimeSetTmp.delete;  -- WR99428
        la_TimeSet.delete;
        --
        l_Msg := 'Failed to check the rebilling period';  -- WR57931
        --
        FOR i IN 1 .. l_taECA.COUNT LOOP
            l_Keep := FALSE;
            --
            IF l_taECA(i).DateFrom >= l_BillFrom THEN
                l_Keep := TRUE;
            ELSIF l_taECA(i).DateFrom BETWEEN l_ReBillFrom AND l_ReBillTo THEN
                FOR rb IN 1 .. l_Rebill_DateFrom.COUNT LOOP
                    IF l_Rebill_DateFrom(rb) < l_taECA(i).DateTo
                    AND l_Rebill_DateTo(rb) > l_taECA(i).DateFrom THEN
                        l_Keep := TRUE;
                        EXIT;
                    END IF;
                END LOOP;
            END IF;
            --
            IF NOT l_Keep THEN
                l_taECA.DELETE(i);
            Else
                If l_taECA(i).productsubclass in ('ENGYE','ENGYG') Then
                   --and l_taECA(i).CountNonZeroRate > 0
                    --l_CTB_key := l_taECA(i).RatingPlanID ||'_' ||l_taECA(i).timesetid;
                    l_CTB_key := l_taECA(i).inventoryid  ||'_' ||
                                 l_taECA(i).RatingPlanID ||'_' ||
                                 l_taECA(i).timesetid    ||'_' ||
                                 l_taECA(i).timebandid   ||'_' ||
                                 case when l_taECA(i).CountNonZeroRate > 0 then 'Y' Else 'N' end;
                    --
                    If  not la_TimeSetTmp.exists(l_CTB_key)  Then
                        la_TimeSetTmp(l_CTB_key).TSetId   := l_taECA(i).timesetid;
                        la_TimeSetTmp(l_CTB_key).DateFrom := l_taECA(i).DateFrom;
                        la_TimeSetTmp(l_CTB_key).DateTo   := l_taECA(i).DateTo;
                        la_TimeSetTmp(l_CTB_key).RatingPlanID   := l_taECA(i).RatingPlanID;
                        la_TimeSetTmp(l_CTB_key).TBandId  := l_taECA(i).timebandid;
                        la_TimeSetTmp(l_CTB_key).NonZeroRate := case when l_taECA(i).CountNonZeroRate > 0 then 'Y' Else 'N' end;
                    Else
                        la_TimeSetTmp(l_CTB_key).DateTo  := greatest(l_taECA(i).DateTo, la_TimeSetTmp(l_CTB_key).DateTo);
                        la_TimeSetTmp(l_CTB_key).DateFrom := least(l_taECA(i).DateFrom, la_TimeSetTmp(l_CTB_key).DateFrom);
                    End If;

                End If;
                --
            END IF;
        END LOOP;

      BEGIN

        --WR112694 - For demand ECA skip all consumption calculation. Consumption will be set to zero because it is calculated in pkg_demand.
        IF iDoDemand = 'Y' THEN
          RAISE xSkipDemand;
        END IF;

        --
        -- WR99428
        l_Msg := 'Failed to add l_taECA row for graphing data';
        -- remove the duplicates
        If  la_TimeSettmp.count > 0 then
            --
            l_CTB_key1 := la_TimeSettmp.first;
            For tt in 1 .. la_TimeSettmp.count
            loop
                --
                For tidx in 1 .. la_TimeSettmp.count
                loop
                    --
                    If  la_TimeSettmp(l_CTB_key1).NonZeroRate = 'Y' Then
                        --
                        l_CTB_key := '_' || la_TimeSettmp(l_CTB_key1).TSetId || '_' ||
                                     la_TimeSettmp(l_CTB_key1).RatingPlanID || '_' ||
                                     la_TimeSettmp(l_CTB_key1).TBandid || '_' ||
                                     to_char(la_TimeSettmp(l_CTB_key1).DateFrom,'yyyymmddhh24miss') || '_' ||
                                     to_char(la_TimeSettmp(l_CTB_key1).DateTo,'yyyymmddhh24miss');
                        --
                        la_TimeSet(l_CTB_key).TSetId   := la_TimeSettmp(l_CTB_key1).TSetId;
                        la_TimeSet(l_CTB_key).DateFrom := la_TimeSettmp(l_CTB_key1).DateFrom;
                        la_TimeSet(l_CTB_key).DateTo   := la_TimeSettmp(l_CTB_key1).DateTo;
                        la_TimeSet(l_CTB_key).RatingPlanID   := la_TimeSettmp(l_CTB_key1).RatingPlanID;
                        la_TimeSet(l_CTB_key).TBandid  := la_TimeSettmp(l_CTB_key1).TBandid;
                     End If;
                End loop;

                l_CTB_key1 := la_TimeSettmp.Next(l_CTB_key1);
                Exit when l_CTB_key1 is null;

            End loop;
            --
        End If;
        --
        If  la_TimeSet.count = 0 then
            l_CTB_key := '_';
            la_TimeSet(l_CTB_key).TSetId   := null;
            la_TimeSet(l_CTB_key).DateFrom := l_ReBillFrom;
            la_TimeSet(l_CTB_key).DateTo   := l_BillTo;
            la_TimeSet(l_CTB_key).RatingPlanID := null;
            la_TimeSet(l_CTB_key).TBandid := null;
        End If;
        --
        IF g_Debug THEN
            pkg_util.putbuf(' we have TimeSet ' || la_TimeSet.count);
            l_CTB_key := la_TimeSet.first;
            For ctb in 1 .. la_TimeSet.count
            loop
                pkg_util.putbuf(lp(la_TimeSet(l_CTB_key).TSetId, 5) ||
                                lp(la_TimeSet(l_CTB_key).DateFrom, 11) ||
                                lp(la_TimeSet(l_CTB_key).DateTo, 11)   ||
                                lp(la_TimeSet(l_CTB_key).RatingPlanID,6) ||
                                lp(la_TimeSet(l_CTB_key).TBandid,6)
                                );
                l_CTB_key := la_TimeSet.Next(l_CTB_key);
                Exit when l_CTB_key is null;
             End Loop;
        End If;
        --
        -- add rows to l_taECA array
        l_CTB_key := la_TimeSet.first;
        For ctb in 1 .. la_TimeSet.count
        loop
            --
            -- loop to split per calendar month
            If  l_Mixed in ('Y', 'I') Then
                --
                l_CT_Temp_En := la_TimeSet(l_CTB_key).DateTo;
                l_CT_Temp_St := greatest(trunc(l_CT_Temp_En, 'month'),l_ReBIllFrom);

                loop
                    l_taECA(j + 1)          := l_taECA(j);

                    j := j + 1;
                    l_taECA(j).inventoryid      := null;
                    l_taECA(j).timebandid       := la_TimeSet(l_CTB_key).TBandid;
                    l_taECA(j).etimechargeid    := null;
                    l_taECA(j).datefrom         := l_CT_Temp_St;
                    l_taECA(j).dateto           := l_CT_Temp_En;
                    l_taECA(j).consumption      := NULL;
                    l_taECA(j).factor1          := NULL;
                    l_taECA(j).factor2          := NULL;
                    l_taECA(j).chargeamtbill    := NULL;
                    l_taECA(j).chargeamtbase    := NULL;
                    l_taECA(j).invoicechargeid  := NULL;
                    l_taECA(j).rowversion       := '0';
                    l_taECA(j).consbilled       := NULL;
                    l_taECA(j).consbilledfactor := NULL;
                    l_taECA(j).DEMANDID         := NULL;
                    l_taECA(j).CONSADJUSTED     := NULL;
                    l_taECA(j).RatingPlanID     := la_TimeSet(l_CTB_key).RatingPlanID;
                    l_taECA(j).SeasonID         := null;
                    l_taECA(j).TIMESETID        := la_TimeSet(l_CTB_key).TSetId;
                  --l_taECA(j).UNIT             := null;
                    l_taECA(j).TimestampUpd     := l_Now;
                    l_taECA(j).PROCESSSTATUS    := NULL;
                  --l_taECA(j).meterType        := 'MP';
                  --l_taECA(j).UDST             := '';
                    l_taECA(j).Match_TimeBand   := FALSE;
                    l_taECA(j).rType            := 'I';
                    l_taECA(j).productsubclass  := null;
                    --
                    l_CT_Temp_En := l_CT_Temp_St - 1;
                    l_CT_Temp_St := greatest(add_months(l_CT_Temp_St, -1)
                                           , l_ReBillFrom
                                           ,la_TimeSet(l_CTB_key).DateFrom);
                    --
                    Exit When l_CT_Temp_St > l_CT_Temp_En;
                    --
                End Loop;
            End If;
            -- if there is basic meter, then add row
            If l_Mixed in ('Y', 'B')  Then
                --
                l_CT_Temp_En := la_TimeSet(l_CTB_key).DateTo;
                l_CT_Temp_St := la_TimeSet(l_CTB_key).DateFrom;
                --
                l_taECA(j + 1)          := l_taECA(j);

                j := j + 1;
                l_taECA(j).inventoryid      := null;
                l_taECA(j).timebandid       := la_TimeSet(l_CTB_key).TBandid;
                l_taECA(j).etimechargeid    := null;
                l_taECA(j).datefrom         := l_CT_Temp_St;
                l_taECA(j).dateto           := l_CT_Temp_En;
                l_taECA(j).consumption      := NULL;
                l_taECA(j).factor1          := NULL;
                l_taECA(j).factor2          := NULL;
                l_taECA(j).chargeamtbill    := NULL;
                l_taECA(j).chargeamtbase    := NULL;
                l_taECA(j).invoicechargeid  := NULL;
                l_taECA(j).rowversion       := '0';
                l_taECA(j).consbilled       := NULL;
                l_taECA(j).consbilledfactor := NULL;
                l_taECA(j).DEMANDID         := NULL;
                l_taECA(j).CONSADJUSTED     := NULL;
                l_taECA(j).RatingPlanID     := la_TimeSet(l_CTB_key).RatingPlanID;
                l_taECA(j).SeasonID         := null;
                l_taECA(j).TIMESETID        := la_TimeSet(l_CTB_key).TSetId;
              --l_taECA(j).UNIT             := Null;
                l_taECA(j).TimestampUpd     := l_Now;
                l_taECA(j).PROCESSSTATUS    := NULL;
              --l_taECA(j).meterType        := 'MP';
              --l_taECA(j).UDST             := '';
                l_taECA(j).Match_TimeBand   := FALSE;
                l_taECA(j).rType            := 'B';
                l_taECA(j).productsubclass  := null;
                --

            End If;
            --
            l_CTB_key := la_TimeSet.Next(l_CTB_key);
            Exit when l_CTB_key is null;
        End loop;

        --
        /* IF g_debug THEN
            pkg_util.putbuf('There are ' || l_taECA.COUNT || ' Rows in the ECA after rebill removal', 255, NULL);
        END IF;*/
        -- In here we loop through the EChargeAccum structures we have to obtain a
        -- distinct list of all the consumptions that we will need. This is done so we can
        -- limit the number of times we apply a given timeset, season and Daylight Savings setting
        -- to the accumulated readings
        --
        l_Msg := 'Failed to generate list of consumption';  -- WR57931
        --
        FOR i IN 1..l_taECA.COUNT LOOP
            -- Obtain a distinct list of Dates, Timesets, Timebands we need consumption for
            l_Key := l_taECA(i).SupplyPointID                        ||'_'||
                     l_taECA(i).timesetid                            ||'_'||
                     to_char(l_taECA(i).DateFrom,'yyyymmddhh24miss') ||'_'||
                     to_char(l_taECA(i).DateTo,'yyyymmddhh24miss')   ||'_'||
                     l_taECA(i).UDST                                 ||'_'||
                     l_taECA(i).SeasonID                             --||'_'||
--                     l_taECA(i).unit;
                     ;
            -- Exclude TimeBandID from the key and data to make best re-use of Selected data.
            l_Cons.SupplyPointID(l_Key) := l_taECA(i).SupplyPointID;
            l_Cons.TimeSetID(l_Key)     := l_taECA(i).TimeSetID;
            l_Cons.DateFrom(l_Key)      := l_taECA(i).DateFrom;
            l_Cons.DateTo(l_Key)        := l_taECA(i).DateTo;
            l_Cons.UDST(l_Key)          := l_taECA(i).UDST;
            l_Cons.SeasonID(l_Key)      := l_taECA(i).SeasonID;
            l_Cons.Consu(l_Key)         := l_taECA(i).Unit;
            l_Cons.InvMeterType(l_Key)  := l_taECA(i).MeterType;
        END LOOP;

        -- WR57931 Implement creation of DumbAccum
        l2da_DumbCons.DELETE;

        -- Once we know what consumption aggregates we need, we then go to the readings to
        -- obtain the consumptions.
        -- There are many routines so we can tune the SQL's better rather than overloading
        -- any single SQL with too many variations, even if the variations seem to be slight
        -- Performance is key to this program.
        l_Msg := 'Failed to calculate the consumption';  -- WR57931
        --
        g_loc_state := NULL;
        l_Key := l_Cons.DateFrom.FIRST;
        FOR i IN 1..l_Cons.DateFrom.COUNT LOOP
            -- WR80414. We only care about country and state locationid to query holiday.
            -- Usually spid does not change across inventories, so this quey is only run once.
            IF l_Prevspid <> l_Cons.SupplyPointID(l_Key) THEN
                l_Prevspid := l_Cons.SupplyPointID(l_Key);
                FOR loc IN (SELECT lhm2.locationid
                            FROM  (SELECT parentsupplypointid spid
                                   FROM supplypointparent sp
                                   CONNECT BY supplypointid = PRIOR parentsupplypointid
                                   START WITH supplypointid = l_Prevspid) sp
                                  ,SPProperty spp
                                  ,AddressPropertyVal apv
                                  ,LocHMbr            lhm
                                  ,LocHMbrLookup      lu
                                  ,LocHMbr            lhm2
                            WHERE  spp.SupplyPointID = sp.spid
                            AND    spp.PropertyKey = 'SADDR'
                            AND    apv.addressid = spp.PropValNumber
                            AND    apv.locationid = lhm.LocationID
                            AND    lu.rootlochmbrid = lhm.lochmbrid
                            AND    lhm2.lochmbrid = lu.lochmbrid
                            AND    lhm2.lochmbrtype = 'STATE') LOOP
                        g_loc_state := loc.locationid;
                END LOOP;
            END IF;
            IF g_Debug THEN
                Pkg_Util.putbuf('We need Cons for '||to_char(l_Cons.DateFrom(l_Key),'yyyy/mm/dd')         ||
                                ' to '||to_char(l_Cons.DateTo(l_Key),'yyyy/mm/dd')                        ||
                                ' for SupplyPointID = '||NVL(to_char(l_Cons.SupplyPointID(l_Key)),'NULL') ||
                                ' for TimesetID = '||NVL(to_char(l_Cons.TimeSetID(l_Key)),'NULL')         ||
                                ' for SeasonID = '||NVL(to_char(l_Cons.SeasonID(l_Key)),'NULL')           ||
                                ' for UDST = '||NVL(to_char(l_Cons.UDST(l_Key)),'NULL')                   --||
--                              ' for Unit = '||NVL(to_char(l_Cons.Consu(l_Key)),'NULL')
                               ,250, NULL, NULL);
            END IF;
            IF l_Cons.TimeSetID(l_Key) IS NOT NULL THEN
                IF l_Cons.UDST(l_Key) = 'Y' THEN
                    --WR80414. Combine these two procedures into one. Season makes no difference in the query.
                    Cons_By_TimeSet_UDST_Season(l_Cons.SupplyPointID(l_Key)
                                               ,l_Cons.TimeSetID(l_Key)
                                               ,l_Cons.SeasonID(l_Key)
                                               ,l_Cons.DateFrom(l_Key)
                                               ,l_Cons.DateTo(l_Key)
                                               ,l_ConsTB);
                ELSE
                    IF l_Cons.SeasonID(l_Key) IS NOT NULL THEN
                        Cons_By_TimeSet_Season(l_Cons.SupplyPointID(l_Key)
                                              ,l_Cons.TimeSetID(l_Key)
                                              ,l_Cons.SeasonID(l_Key)
                                              ,l_Cons.DateFrom(l_Key)
                                              ,l_Cons.DateTo(l_Key)
                                              ,l_ConsTB
                                              );
                    ELSE
                        Cons_By_TimeSet(l_Cons.SupplyPointID(l_Key)
                                       ,l_Cons.TimeSetID(l_Key)
                                       ,l_Cons.DateFrom(l_Key)
                                       ,l_Cons.DateTo(l_Key)
                                       ,l_Cons.InvMeterType(l_Key)
                                       ,l_ConsTB);
                    END IF;
                END IF;
            ELSE
                IF l_Cons.UDST(l_Key) = 'Y' THEN
                    IF l_Cons.SeasonID(l_Key) IS NOT NULL THEN
                        Cons_By_UDST_Season(l_Cons.SupplyPointID(l_Key)
                                           ,l_Cons.SeasonID(l_Key)
                                           ,l_Cons.DateFrom(l_Key)
                                           ,l_Cons.DateTo(l_Key)
                                           ,l_ConsTB);
                    ELSE
                        Cons_By_UDST(l_Cons.SupplyPointID(l_Key)
                                    ,l_Cons.DateFrom(l_Key)
                                    ,l_Cons.DateTo(l_Key)
                                    ,l_ConsTB);
                    END IF;
                ELSE
                    IF l_Cons.SeasonID(l_Key) IS NOT NULL THEN
                        Cons_By_Season(l_Cons.SupplyPointID(l_Key)
                                      ,l_Cons.SeasonID(l_Key)
                                      ,l_Cons.DateFrom(l_Key)
                                      ,l_Cons.DateTo(l_Key)
                                      ,l_ConsTB);
                    ELSE
                        Cons_All(l_Cons.SupplyPointID(l_Key)
                                ,l_Cons.DateFrom(l_Key)
                                ,l_Cons.DateTo(l_Key)
                                ,l_ConsTB);
                    END IF;
                END IF;
            END IF;
            --
            -- WR55825 Capacity for processing basic readings
            --
            IF l_latestrdgdateDumb <> l_ReBillFrom THEN
                Cons_Basic(l_Cons.SupplyPointID(l_Key)
                          ,l_Cons.DateFrom(l_Key)
                          ,l_Cons.DateTo(l_Key)
                          ,l_Cons.TimeSetID(l_Key)
                          ,l_Cons.UDST(l_Key)
                          ,l_Cons.SeasonID(l_Key)
                          ,l_SE_FRMP_StartDate   -- WR69667
                          ,l2da_DumbCons         -- WR57931
                          ,l_ConsTB);
            END IF;
            l_Cons.Found_Match(l_Key) := FALSE;
            --
            l_Key := l_Cons.DateFrom.NEXT(l_Key);
            EXIT WHEN l_Key IS NULL;
        END LOOP;
        -- Now we need to apply SP Timeband to RP Timeband mapping prior to
        -- aggregating and creating EChargeAccum entries, we also convert consumption
        -- units if this is nesecary. This is done as we put the consumption values
        -- against the EChargeAccum entries as the Rating Plan Unit and TB Mapping are a
        -- Rating Plan setting.
        --
        -- Need to loop through twice
        -- First loop tries to match on Timebanded rates
        -- Second loop matches on NULL timebanded rates.
        IF g_Debug THEN
            Display_TCA(l_taECA, NULL, NULL);
            --
            l_Key := l_ConsTB.DateFrom.FIRST;
            --
            Pkg_Util.putbuf('We Have Cons for ');
            Pkg_Util.putbuf('l_ConsTB>.DateFrom  .' ||
                            ' to       .' ||
                            'InvSPID   .' ||
                            'regSPID   .' ||
                            'TsetID.'     ||
                            'TBandID.'    ||
                            'Season.'     ||
                            'UDST.'       ||
                            'Unit .'      ||
                            'ConsTB.'     ||
                            'ConsA .'     ||
                            'Match.'      ||
                            'ECAK.'       ||
                            'Key'
                            ,250
                            ,NULL
                            ,NULL);
            FOR i IN 1..l_ConsTB.DateFrom.COUNT LOOP
                IF l_ConsTB.Found_Match(l_Key) THEN
                    l_vc := 'True';
                ELSE
                    l_vc := 'False';
                END IF;
                --
/*                Pkg_Util.putbuf('We Have Cons for ' || to_char(l_ConsTB.DateFrom(l_Key),'yyyy/mm/dd')     ||
                                ' to '              || to_char(l_ConsTB.DateTo(l_Key),'yyyy/mm/dd')       ||
                                ' For InvSPID = '   || NVL(to_char(l_ConsTB.InvSPID(l_Key)),'NULL')       ||
                                ' SupplyPointID = ' || NVL(to_char(l_ConsTB.SupplyPointID(l_Key)),'NULL') ||
                                ' TimesetID = '     || NVL(to_char(l_ConsTB.TimeSetID(l_Key)),'NULL')     ||
                                ' TimeBandID = '    || NVL(to_char(l_ConsTB.TimeBandID(l_Key)),'NULL')    ||
                                ' SeasonID = '      || NVL(to_char(l_ConsTB.SeasonID(l_Key)),'NULL')      ||
                                ' UDST = '          || NVL(to_char(l_ConsTB.UDST(l_Key)),'NULL')          ||
                                ' Unit = '          || NVL(to_char(l_ConsTB.Consu(l_Key)),'NULL')         ||
                                ' Consumption = '   || NVL(to_char(l_ConsTB.Consumption(l_Key)),'NULL')   ||
                                ' Found Match = '   || l_vc
                               ,250
                               ,NULL
                               ,NULL);*/
                Pkg_Util.putbuf(lp('l_ConsTB>',9) ||
                                lp(to_char(l_ConsTB.DateFrom(l_Key),'yyyy/mm/dd'),10)     ||
                                lp(to_char(l_ConsTB.DateTo(l_Key),'yyyy/mm/dd'),10)       ||
                                lp(l_ConsTB.InvSPID(l_Key),10)       ||
                                lp(NVL(to_char(l_ConsTB.SupplyPointID(l_Key)),'NULL'),10) ||
                                lp(NVL(to_char(l_ConsTB.TimeSetID(l_Key)),'NULL'),6)      ||
                                lp(NVL(to_char(l_ConsTB.TimeBandID(l_Key)),'NULL'),7)     ||
                                lp(NVL(to_char(l_ConsTB.SeasonID(l_Key)),'NULL'),6)      ||
                                lp(NVL(to_char(l_ConsTB.UDST(l_Key)),'NULL'),4)          ||
                                lp(NVL(to_char(l_ConsTB.Consu(l_Key)),'NULL'),5)         ||
                                lp(NVL(to_char(l_ConsTB.Consumption(l_Key)),'NULL'),6)   ||
                                lp(NVL(to_char(l_ConsTB.ConsA(l_Key)),'NULL'),6)         ||
                                lp(l_vc,5) ||
                                lp(nvl(to_char(l_ConsTB.ECAKeyGroup(l_Key)),' '),4)      ||
                               -- lp(l_ConsTB.InvMeterType(l_Key),5) ||
                                l_key
                               ,250
                               ,NULL
                               ,NULL);
                l_Key := l_ConsTB.DateFrom.NEXT(l_Key);
                EXIT WHEN l_Key IS NULL;
            END LOOP;
            -- WR57931 Implement creation of DumbAccum
            pkg_util.putbuf('l2da_DumbCons :' );
            pkg_util.putbuf(' n .'         ||
                            'RdgDumbID .' ||
                            'Cons    .'   ||
                            'l_ConsKey'
                            ,250
                            ,NULL
                            ,NULL);
            l_ConsKey := l2da_DumbCons.FIRST;
            FOR i IN 1 .. l2da_DumbCons.COUNT LOOP
                FOR j IN 1 .. l2da_DumbCons(l_ConsKey).RdgDumbID.COUNT LOOP
/*                    pkg_util.putbuf('l2da_DumbCons key = ' || l_ConsKey   ||
                                    ', RdgDumbID('         || j || ') = ' || l2da_DumbCons(l_ConsKey).RdgDumbID(j) ||
                                    ', Consumption('       || j || ') = ' || l2da_DumbCons(l_ConsKey).Consumption(j) */
                    pkg_util.putbuf(rpd(j,3) ||
                                    rpd(l2da_DumbCons(l_ConsKey).RdgDumbID(j),10) ||
                                    rpd(l2da_DumbCons(l_ConsKey).Consumption(j),8) ||
                                    l_ConsKey
                                   ,250
                                   ,NULL
                                   ,NULL);
                END LOOP;
                --
                l_ConsKey := l2da_DumbCons.NEXT(l_ConsKey);
                EXIT WHEN l_ConsKey IS NULL;
            END LOOP;
        END IF;
        --
        -- WR56993 Recode this matching process
        --
        l_Msg := 'Failed on the matching process';  -- WR57931
        --
        -- Clean up array
        la_ECAKey.DELETE;
        la_ECAIdx.DELETE;
        -- WR57931 Implement creation of DumbAccum
        l2da_DumbAccum.DELETE;
        --
        IF l_taECA.COUNT > 0 THEN
            --
            -- Generate a list of ECA index for the unique key
            -- The key is the combination of SupplyPointID, TimeSetID, DateFrom, DateTo, UDST, SeasonID and RatingPlan
            -- e.g. 2351168_22_20080625000000_20080904000000_N_1_1234
            --
            FOR i IN 1 .. l_taECA.COUNT LOOP
                l_ECAKey_Idx := TO_CHAR(l_taECA(i).SupplyPointID)                || '_' ||
                                TO_CHAR(l_taECA(i).TimeSetID)                    || '_' ||
                                TO_CHAR(l_taECA(i).DateFrom, 'YYYYMMDDHH24MISS') || '_' ||
                                TO_CHAR(l_taECA(i).DateTo, 'YYYYMMDDHH24MISS')   || '_' ||
                                l_taECA(i).UDST                                  || '_' ||
                                TO_CHAR(l_taECA(i).SeasonID)                     || '_' ||
                                TO_CHAR(l_taECA(i).RatingPlanID);
                IF NOT la_ECAKey.EXISTS(l_ECAKey_Idx) THEN
                    la_ECAKey(l_ECAKey_Idx)               := la_ECAKey.COUNT + 1;
                    la_ECAIdx(la_ECAKey(l_ECAKey_Idx))(1) := i;
                ELSE
                    la_ECAIdx(la_ECAKey(l_ECAKey_Idx))(la_ECAIdx(la_ECAKey(l_ECAKey_Idx)).COUNT + 1) := i;
                END IF;
            END LOOP;
        END IF;
        --
        IF g_debug THEN
            IF la_ECAKey.COUNT > 0 THEN
                l_ECAKey_Idx := la_ECAKey.FIRST;
                FOR i IN 1 .. la_ECAKey.COUNT LOOP
                    l_ECAKey := la_ECAKey(l_ECAKey_Idx);
                    Pkg_Util.putbuf('*** la_ECAKey(' || l_ECAKey_Idx || ') = ' || l_ECAKey
                                   ,255
                                   ,NULL);
                    FOR j IN la_ECAIdx(l_ECAKey).FIRST .. la_ECAIdx(l_ECAKey).LAST LOOP
                        Pkg_Util.putbuf('*** la_ECAIdx(' || l_ECAKey || ')(' || j || ') = ' || la_ECAIdx(l_ECAKey)(j)
                                       ,255
                                       ,NULL);
                    END LOOP;
                    --
                    l_ECAKey_Idx := la_ECAKey.NEXT(l_ECAKey_Idx);
                    EXIT WHEN l_ECAKey_Idx IS NULL;
                END LOOP;
            END IF;
        END IF;
        --
-- Matching process rules:
        -- 1. Scenario 1 (Straight mapping)
        --    a. SP to have two registers, one on Peak, the other Off Peak
        --    b. RP to have two prices, Peak and Off Peak
        --    c. RP does not have any timeband mappings
        --    d. Peak SP maps to Peak RP, OffPeak SP maps to OffPeak RP
        -- 2. Scenario 2 (Tests mapping to NULL timebanded rate)
        --    a. SP to have two registers, one on Peak, the other Off Peak
        --    b. RP to have two prices, Peak and NULL timebands
        --    c. RP does not have any timeband mappings
        --    d. Peak SP maps to Peak RP, OffPeak SP maps to NULL timeband RP
        -- 3. Scenario 3 (Tests mapping NULL timebanded consumption to not null timebanded rate)
        --    a. SP to have two registers, one on Peak, the other NULL timeband
        --    b. RP to have two prices, Peak and NULL timebands
        --    c. RP does not have any timeband mappings
        --    d. Peak consumption is priced at Peak rate, and NULL consumption is priced at NULL timebanded rate
        --    e. Also check that no consumption is priced more than once.
        -- 4. Scenario 4 (Tests mapping timebanded consumption to NULL timebanded rate)
        --    a. SP to have two registers, one on Peak, the other Off Peak
        --    b. RP to have two prices, Peak and NULL timebands
        --    c. RP also to have a timeband mapping of Off Peak SP maps to Peak Rate on RP
        --    d. Peak SP consumption is priced at Peak rate, Off Peak consumption also priced at Peak timeband rate
        --    e. Also check that no consumption is priced more than once.
        -- 5. Scenario 5 (Tests mapping timebanded consumption to NULL timebanded rate with aggregation of charges)
        --    a. SP to have two registers, one on Peak, the other Off Peak
        --    b. RP to have one price with NULL timeband
        --    c. No RP mappings
        --    d. All consumption to be priced at NULL timebanded rate
        --
        IF la_ECAKey.COUNT > 0 THEN
            l_ECAKey_Idx := la_ECAKey.FIRST;
            FOR i IN 1 .. la_ECAKey.COUNT LOOP  -- RP Group
                l_ECAKey := la_ECAKey(l_ECAKey_Idx);
                --
                -- Mark matched cons for each group of RP with Found_Match = TRUE, otherwise FALSE
                --
                IF g_Debug THEN
                    Pkg_Util.putbuf(lp('l_ConsTB>',9) || lp(i,3)||
                                    'DateFrom  .' ||
                                    ' to       .' ||
                                    'InvSPID   .' ||
                                    'regSPID   .' ||
                                    'TsetID.'     ||
                                    'TBandID.'    ||
                                    'Season.'     ||
                                    'UDST.  .'    ||
                                    'Unit .'      ||
                                    'ConsTB.'     ||
                                    'ConsA .'     ||
                                    'Match.'      ||
                                    'ECAK='       ||
                                    l_ECAKey_Idx
                                    ,250
                                    ,NULL
                                    ,NULL);
                End if;

                l_Key := l_ConsTB.SupplyPointID.FIRST;
                FOR c IN 1..l_ConsTB.SupplyPointID.COUNT LOOP
                    --
                    -- The key for la_ECAKey is the combination of SupplyPointID, TimeSetID, DateFrom, DateTo, UDST, SeasonID and RatingPlan
                    -- e.g. 2351168_22_20080625000000_20080904000000_N_1_1234
                    -- The key for l_ConsTB is the combination of SupplyPointID, TimeSetID, DateFrom, DateTo, UDST, SeasonID, TimeBandID, Register SPID and Unit
                    -- e.g. 1765595_22_20080630000000_20080924000000_N_1_1_1866748_KWH
                    -- We need to match the first 6 fields
                    --
                    l_ConsTB.Found_Match(l_Key) := FALSE;
                    l_VC := 'FALSE';

                    IF SUBSTR(l_ECAKey_Idx, 1, INSTR(l_ECAKey_Idx, '_', 1, 6) - 1) = SUBSTR(l_Key, 1, INSTR(l_Key, '_', 1, 6) - 1) THEN
                        l_ConsTB.Found_Match(l_Key) := TRUE;
                        l_VC := 'TRUE';
                        l_ConsTb.ECAKeyGroup(l_Key) := l_ECAKey;  -- WR99428
                    END IF;
                    IF g_Debug THEN
                        Pkg_Util.putbuf(lp('l_ConsTB>',9) || lp(c,3) ||
                                        lp(to_char(l_ConsTB.DateFrom(l_Key),'yyyy/mm/dd'),10)     ||
                                        lp(to_char(l_ConsTB.DateTo(l_Key),'yyyy/mm/dd'),10)       ||
                                        lp(l_ConsTB.InvSPID(l_Key),10)       ||
                                        lp(NVL(to_char(l_ConsTB.SupplyPointID(l_Key)),'NULL'),10) ||
                                        lp(NVL(to_char(l_ConsTB.TimeSetID(l_Key)),'NULL'),6)      ||
                                        lp(NVL(to_char(l_ConsTB.TimeBandID(l_Key)),'NULL'),7)     ||
                                        lp(NVL(to_char(l_ConsTB.SeasonID(l_Key)),'NULL'),6)      ||
                                        lp(NVL(to_char(l_ConsTB.UDST(l_Key)),'NULL'),4)          ||
                                        lp(NVL(to_char(l_ConsTB.ConsSource(l_Key)),' '),2)    ||
                                        lp(NVL(to_char(l_ConsTB.Consu(l_Key)),'NULL'),5)         ||
                                        lp(NVL(to_char(l_ConsTB.Consumption(l_Key)),'NULL'),6)   ||
                                        lp(NVL(to_char(l_ConsTB.ConsA(l_Key)),'NULL'),6)         ||
                                        lp(l_vc,5) ||
                                        lp(nvl(to_char(l_ConsTB.ECAKeyGroup(l_Key)),' '),4)      ||
                                        l_key
                                       ,250
                                       ,NULL
                                       ,NULL);


                    END IF;
                    --
                    l_Key := l_ConsTB.SupplyPointID.NEXT(l_Key);
                    EXIT WHEN l_Key IS NULL;
                END LOOP;
                --
                -- Matching process steps:
                -- Step1: Direct match timeband between RP with SP including NULL to NULL
                -- Step2: Match remaining RP with remaining SP
                --
                IF la_ECAIdx(l_ECAKey).COUNT > 0 THEN
                    --
                    -- Direct match on Timebanded rates
                    --
                    FOR j IN la_ECAIdx(l_ECAKey).FIRST .. la_ECAIdx(l_ECAKey).LAST LOOP  -- RP
                        l_ECAIdx_Idx := j;
                        l_ECAIdx := la_ECAIdx(l_ECAKey)(l_ECAIdx_Idx);
/*                      --
                        IF g_debug THEN
                            Display_TCA(l_taECA, l_ECAIdx, NULL);
                        END IF;
                        -- */
                        l_Key := l_ConsTB.SupplyPointID.FIRST;
                        FOR c IN 1..l_ConsTB.SupplyPointID.COUNT LOOP  -- SP
                            -- Find mapping timeband if available
                            l_TimeBandID := TBMapping(l_Key, l_ECAIdx);
                            l_ConsTb.rpTimebandid(l_key) := l_TimeBandid;
                            --
                            IF ( l_ConsTB.Found_Match(l_Key)
                                 or (l_ConsTB.ECAKeyGroup(l_key) = l_ECAKey and l_taECA(l_ECAIdx).rType is not null))
                            AND NVL(l_TimeBandID, 0) = NVL(l_taECA(l_ECAIdx).TimeBandID, 0)
                            AND NVL(l_ConsTB.TimeSetID(l_Key), 0) = NVL(l_taECA(l_ECAIdx).TimeSetID, 0)
                            And ( l_taECA(l_ECAIdx).rType is null or l_taECA(l_ECAIdx).rType = l_ConsTB.ConsSource(l_Key) ) THEN -- WR99428
                                ApplyCons(l_Key, l_ECAIdx);
                                IF g_debug THEN
                                    Display_TCA(l_taECA, l_ECAIdx, 'Direct TB Match');
                                END IF;
                                -- WR99428
                                If  l_taECA(l_ECAIdx).InventoryID is null and l_taECA(l_ECAIdx).rType is not null Then
                                    --
                                    l_CTB_key := l_taECA(l_ECAIdx).rType || '_' ||
                                                 l_consTB.RPTimeBandID(l_Key) || '_' ||
                                                 to_char(l_consTB.DateTo(l_Key),'yyyymm')
                                                 ;
                                    --
                                    If  not la_CTB.exists(l_CTB_key) Then
                                        --
                                        la_CTB(l_CTB_key).ConsSource := l_consTB.ConsSource(l_key);
                                        la_CTB(l_CTB_key).TBandId    := l_consTB.RPTimeBandID(l_Key);
                                        la_CTB(l_CTB_key).DateFrom   := l_consTB.DateFrom(l_Key);
                                        la_CTB(l_CTB_key).DateTo     := l_consTB.DateTo(l_Key);
                                        la_CTB(l_CTB_key).Cons       := l_consTB.ConsA(l_Key);
                                        la_CTB(l_CTB_key).ConsUnit   := l_taECA(l_ECAIdx).UNIT;
                                    Else
                                        la_CTB(l_CTB_key).Cons       := la_CTB(l_CTB_key).Cons + l_consTB.ConsA(l_Key);
                                        la_CTB(l_CTB_key).DateTo     := greatest(l_consTB.DateTo(l_Key),la_CTB(l_CTB_key).DateTo);
                                        la_CTB(l_CTB_key).DateFrom   := least(l_consTB.DateFrom(l_Key),la_CTB(l_CTB_key).DateFrom);
                                    End If;

                                End If;
                            END IF;
                            --
                            l_Key := l_ConsTB.SupplyPointID.NEXT(l_Key);
                            EXIT WHEN l_Key IS NULL;
                        END LOOP;  -- SP
                    END LOOP;  -- RP
                    --
                    -- Match remaining Timebanded rates when direct match is not available
                    --
                    FOR j IN la_ECAIdx(l_ECAKey).FIRST .. la_ECAIdx(l_ECAKey).LAST LOOP  -- RP
                        l_ECAIdx_Idx := j;
                        l_ECAIdx := la_ECAIdx(l_ECAKey)(l_ECAIdx_Idx);
                        --
                        IF NOT NVL(l_taECA(l_ECAIdx).Match_TimeBand, FALSE)
                        OR l_taECA(l_ECAIdx).Match_TimeBand THEN
                            IF g_debug THEN
                                Display_TCA(l_taECA, l_ECAIdx, 'Trying 2nd match on NULL TB');
                            END IF;
                            --
                            l_Key := l_ConsTB.SupplyPointID.FIRST;
                            FOR c IN 1..l_ConsTB.SupplyPointID.COUNT LOOP
                                --
                                IF l_ConsTB.Found_Match(l_Key)
                                AND l_taECA(l_ECAIdx).TimeBandID IS NULL
                                AND l_consTB.TimeBandID(l_Key)   IS NOT NULL
                                And l_taECA(l_ECAIdx).rType      is null  -- WR99428
                                AND nvl(l_taECA(l_ECAidx).TimeSetID,0) = nvl(l_ConsTB.TimeSetID(l_Key),0)
								And not (l_FeedinTB.exists(nvl(l_ConsTB.RpTimeBandID(l_Key),0))
                                         and l_taECA(l_ECAIdx).productsubclass = 'SETTL'/*<> in ('ENGYE', 'SVC', 'USAGE', 'SEW', 'ENGYG')*/  )
                                    THEN
                                    ApplyCons(l_Key, l_ECAIdx);
                                    IF g_debug THEN
                                        Display_TCA(l_taECA, l_ECAIdx, 'Null TB Match');
                                    END IF;
                                    --
                                    -- If RP only have one NULL-timeband rate, all cons will be priceed at this NULL-timeband rate
                                    -- If RP only have more than one rate, only the cons which hasn't found any match will be priced at this NULL-timeband rate
                                    --
                                    -- JN: Sorry, I dont understand this exit... Why would we stop allocating more consumption to the ECA because
                                    -- JN: of a lack of rates on the rating plan.
--                                    IF la_ECAIdx(l_ECAKey).COUNT > 1 THEN
--                                        EXIT;
--                                    END IF;
                                END IF;
                                --
                                l_Key := l_ConsTB.SupplyPointID.NEXT(l_Key);
                                EXIT WHEN l_Key IS NULL;
                            END LOOP;
                        END IF;
                    END LOOP;
                END IF;
                --
                l_ECAKey_Idx := la_ECAKey.NEXT(l_ECAKey_Idx);
                EXIT WHEN l_ECAKey_Idx IS NULL;
            END LOOP;  -- RP Group
        END IF;
        --
        IF g_debug THEN
            Display_TCA(l_taECA, NULL, NULL);
            --
            -- WR99428
            Pkg_Util.putbuf('**** CTB count ' || la_CTB.count);
            l_CTB_key := la_CTB.first;
            For i in 1 .. la_CTB.count
            loop
                Pkg_Util.putbuf(rpd(la_CTB(l_CTB_key).TBandid,5) ||
                                rpd(la_CTB(l_CTB_key).cons,8)   ||
                                rpd(la_CTB(l_CTB_key).DateFrom,10) ||
                                rpd(la_CTB(l_CTB_key).DateTo,10)||
                                lp(l_CTB_key,50)
                                ,255
                                ,null );
                l_CTB_key := la_CTB.next(l_CTB_key);
                exit when l_CTB_key is null;
            End Loop;
            Pkg_Util.putbuf('**');
            --
        END IF;

      EXCEPTION
         WHEN xSkipDemand THEN
           NULL;
      END;

        g_BillTotalCons := 0;    -- SEPI-16932
        g_BillConsUnit  := null;
        --
        i := 0;
        g_savecons.DELETE;
        g_spid_arr.DELETE;
        -- Now go through and delete any ECA rows that did not end up with consumption.
        -- This might happen if there are RatingPlans with Rates that dont match to registers with consumption.
        --
        l_Msg := 'Failed to remove charges with no cons';  -- WR57931
        --
        FOR i IN 1..l_taECA.COUNT LOOP
            IF (l_taECA(i).Consumption IS NULL AND iDoDemand = 'N') OR l_taECA(i).InventoryID IS NULL THEN -- WR99428
                --WR110367 - Do not delete the record if iDoDemand is Yes.
                -- that record is needed for SDIC in ETSA to calculate demand in a period out of the TimeSet.
                --
                l_taECA.DELETE(i);
                --
                -- WR57931 Implement creation of DumbAccum
                --
                IF l2da_DumbAccum.COUNT > 0 THEN
                    l2da_DumbAccum.DELETE(i);
                END IF;
            ELSE
                m := l_taOECA.SupplyPointID.COUNT + 1;
                --
                -- MHA-85  Daily billing (unbilled value) - use index when iSaveToDB is false
                IF iSaveToDB THEN
                  l_taOECA.RAGID(m) := EChargeAccumID.NEXTVAL;
                ELSE
                  l_taOECA.RAGID(m) := m;
                END IF;
                --
                l_taOECA.InventoryID(m)   := l_taECA(i).InventoryID;
                l_taOECA.SupplyPointID(m) := l_taECA(i).SupplyPointID;
                l_taOECA.TimeBandID(m)    := l_taECA(i).TimeBandID;
                l_taOECA.ETimeChargeID(m) := l_taECA(i).ETimeChargeID;
                l_taOECA.DateFrom(m)      := l_taECA(i).DateFrom;
                l_taOECA.DateTo(m)        := l_taECA(i).DateTo;
                l_taOECA.Consumption(m)   := NVL(l_taECA(i).Consumption, 0);   --WR110367 - set cons from null to zero for Demand ECA
                l_taOECA.ConsBilled(m)    := l_taECA(i).ConsBilled; --SEPI-10786
                l_taOECA.Factor1(m)       := l_taECA(i).Factor1;
                l_taOECA.Factor2(m)       := l_taECA(i).Factor2;
                l_taOECA.ConsBilledFactor(m) := l_taECA(i).ConsBilledfactor;  --SEPI-10786
                --
                g_spid_arr(l_taECA(i).SupplyPointID) := l_taECA(i).SupplyPointID;
                --
                -- WR57931 Implement creation of DumbAccum
                --
                IF l2da_DumbAccum.EXISTS(i) THEN
                    l2da_DumbAccum(l_taOECA.RAGID(m)) := l2da_DumbAccum(i);
                    l2da_DumbAccum.DELETE(i);
                END IF;
                --
                -- SEPI-16932 - sum the consumption for using in the Rate Reduction process.
                If  l_taECA(i).productsubclass in ('ENGYG','ENGYE')
                    and not l_FeedinTB.exists(nvl(l_taECA(i).timebandid,-1)) Then
                    --
                    g_BillTotalCons := g_BillTotalCons + nvl(l_taOECA.ConsBilled(m),l_taOECA.Consumption(m));
                    g_BillConsUnit  := nvl(l_taECA(i).Unit, g_BillConsUnit);
                    --
                End If;
                --
            END IF;
        END LOOP;
        --
        -- WR99428
        --
        IF iDoDemand = 'N' THEN
          l_Msg := 'Failed to build consumptions for monthly graphing';

          l_CBindx := 0;
          l_CTB_key := la_CTB.first;
          For i in 1 .. la_CTB.count
          loop
              --
              l_CBindx := l_CBindx + 1;

              -- MHA-85  Daily billing (unbilled value) - use index when iSaveToDB is false
              IF iSaveToDB THEN
                  lao_ctb.InvoiceConsumptionId(l_CBindx) := InvoiceConsumptionid.NEXTVAL;
              ELSE
                  lao_ctb.InvoiceConsumptionId(l_CBindx) := l_CBindx;
              END IF;
              --
              lao_ctb.TimeBandId(l_CBindx)  := la_CTB(l_CTB_key).TBandid;
              lao_ctb.ConsSource(l_CBindx)  := la_CTB(l_CTB_key).ConsSource;
              lao_ctb.DateFrom(l_CBindx)    := la_CTB(l_CTB_key).DateFrom;
              lao_ctb.DateTo(l_CBindx)      := la_CTB(l_CTB_key).DateTo;
              lao_ctb.Consumption(l_CBindx) := la_CTB(l_CTB_key).Cons;
              lao_ctb.ConsUnit(l_CBindx)    := la_CTB(l_CTB_key).ConsUnit;

              l_CT_Temp_St                  := Case when l_mixed = 'I' Then
                                                        -- interval only use calendar month consumption period
                                                        la_CTB(l_CTB_key).DateFrom
                                                    Else
                                                        l_BillFrom
                                                    End ;
              l_CT_Temp_En                  := Case when l_mixed = 'I' Then
                                                        -- interval only use calendar month consumption period
                                                        la_CTB(l_CTB_key).DateTo
                                                    Else
                                                        l_BillTo
                                                    End ;
              lao_ctb.EnergyType(l_CBindx)  := GetEnergyType(iHMbrID
                                                            ,l_CT_Temp_En
                                                             );
              lao_ctb.RenewPercent(l_CBindx) := GetRenewPercent(iHMbrID
                                                               ,lao_ctb.EnergyType(l_CBindx)
                                                               ,l_CT_Temp_En
                                                                );
              lao_ctb.GHCoefficient(l_CBindx) := GetConsumpCoEff(g_loc_state
                                                                ,l_UtilityType
                                                                ,l_CT_Temp_st
                                                                ,l_CT_Temp_En
                                                                );

              l_CTB_key := la_CTB.next(l_CTB_key);
               exit when l_CTB_key is null;
          End Loop;
        END IF;
        --
        IF g_debug THEN
            -- WR55825 Enhancement of splitting on a loss factor change
            --Display_TCA(l_taECA,NULL,NULL);
            --pkg_util.putbuf('There are ' || l_taECA.COUNT || ' Rows in the ECA', 255, NULL);
            Pkg_Util.putbuf('l_taOECA>. n .' ||
                            'EChgAccumID.' ||
                            'InventoryID.' ||
                            'InvSPID   .'  ||
                            'TBandID.' ||
                            'ETimeCharge.'||
                            'DateFrom .' ||
                            'DateTo   .' ||
                            'Cons    .'  ||
                            'Factor1 .'||
                            'Factor2 .'||
                            'ConsBilled.' ||  --SEPI-10786
                            'ConsBilledFactor.'
                           ,255
                           ,NULL
                           ,NULL);
            FOR i IN 1 .. l_taOECA.SupplyPointID.COUNT LOOP
               /* Pkg_Util.putbuf('EChargeAccumID(' || i || ')= ' || l_taOECA.RAGID(i)         ||
                                ' InventoryID = '               || l_taOECA.inventoryid(i)   ||
                                ' SupplyPointID = '             || l_taOECA.supplypointid(i) ||
                                ' TimeBandID = '                || l_taOECA.timebandid(i)    ||
                                ' ETimeChargeID = '             || l_taOECA.etimechargeid(i) ||
                                ' DateFrom = '                  || l_taOECA.datefrom(i)      ||
                                ' DateTo = '                    || l_taOECA.dateto(i)        ||
                                ' Cons = '                      || l_taOECA.Consumption(i)   ||
                                ' Factor1 = '                   || l_taOECA.Factor1(i)       ||
                                ' Factor2 = '                   || l_taOECA.Factor2(i)
                               ,255
                               ,NULL);*/
                    Pkg_Util.putbuf(lp('l_taOECA>',9) ||rpd(i,3) ||
                                    rpd(l_taOECA.RAGID(i),11)         ||
                                    rpd(l_taOECA.inventoryid(i),11)   ||
                                    rpd(l_taOECA.supplypointid(i),10) ||
                                    rpd(l_taOECA.timebandid(i),7)    ||
                                    rpd(l_taOECA.etimechargeid(i),10) ||
                                    lp(l_taOECA.datefrom(i),9)      ||
                                    lp(l_taOECA.dateto(i),9)        ||
                                    rpd(l_taOECA.Consumption(i),8)   ||
                                    lp(l_taOECA.Factor1(i),8)       ||
                                    lp(l_taOECA.Factor2(i),8)       ||
                                    rpd(l_taOECA.ConsBilled(i),8)   ||
                                    rpd(l_taOECA.ConsBilledFactor(i),8)
                                   ,255
                                   ,NULL
                                   ,NULL);
            END LOOP;
            --
            pkg_util.putbuf('There are ' || l_taOECA.SupplyPointID.COUNT || ' Rows in the l_taOECA'
                           ,255
                           ,NULL);
            -- SEPI-16932
            Pkg_Util.putbuf('g_BillTotalCons = ' || g_BillTotalCons);
            Pkg_Util.putbuf('g_BillConsUnit = ' || g_BillConsUnit);
            --
            IF iDoDemand = 'N' THEN
              --
              -- WR99428
              Pkg_Util.putbuf('l_mixed = ' || l_mixed);
              Pkg_Util.putbuf('lao_ctb>. n .' ||
                              'CS.' ||
                              'TBandID.' ||
                              'DateFrom .' ||
                              'DateTo   .' ||
                              'Cons      .'  ||
                              'ConsU .'||
                              'ET .' ||
                              'ReN%.' ||
                              'GHCoeff.'
                             ,255
                             ,NULL
                             ,NULL);
              --
              For i in 1 .. lao_ctb.ConsSource.count
              loop
                  Pkg_Util.putbuf(lp('lao_ctb>',8) ||rpd(i,3) ||
                                  rpd(lao_ctb.ConsSource(i),2) ||
                                  rpd(lao_ctb.TimeBandid(i),7) ||
                                  lp(lao_ctb.DateFrom(i),9) ||
                                  lp(lao_ctb.DateTo(i),9) ||
                                  rpd(lao_ctb.Consumption(i),10)  ||
                                  lp(lao_ctb.ConsUnit(i),6) ||
                                  lp(lao_ctb.EnergyType(i),3) ||
                                  rpd(lao_ctb.RenewPercent(i),4) ||
                                  rpd(lao_ctb.GHCoefficient(i),7)
                                 ,255
                                 ,NULL
                                 ,NULL);
              End loop;
              --
              pkg_util.putbuf('There are ' || lao_ctb.ConsSource.count || ' Rows in the lao_CTB'
                             ,255
                             ,NULL);
            END IF;
            --
        END IF;
        --- insert echaregaccum
        IF iSaveToDB                               -- WR99428
        AND l_taOECA.SupplyPointID.COUNT > 0
        AND iDoDemand = 'N' THEN                   -- WR110367
            l_Msg := 'Failed to delete existing unbilled ECA records';  -- WR57931
            --
            l_idx := g_spid_arr.FIRST;
            ---   the following code may need further consolidation, i.e. move/merge into pkg_accum2 for unaccumulation
            FOR i IN 1 .. g_spid_arr.COUNT LOOP
                -- As IDE will no longer create TOUAccum records, nothing should be deleted here
                DELETE touaccum
                WHERE  echargeaccumid IN (SELECT echargeaccumid
                                          FROM   echargeaccum
                                          WHERE  supplypointid = g_spid_arr(l_idx)
                                          AND    invoicechargeid IS NULL);
                -- WR55825 Capacity for processing basic readings
                --         In IDE processing, we still create DUMBAccum same as before
                DELETE dumbaccum
                WHERE  echargeaccumid IN (SELECT echargeaccumid
                                          FROM   echargeaccum
                                          WHERE  supplypointid = g_spid_arr(l_idx)
                                          AND    invoicechargeid IS NULL);
                -- Clean up all existing unbilled ECA records
                DELETE echargeaccum
                WHERE  supplypointid = g_spid_arr(l_idx)
                AND    invoicechargeid IS NULL;
                --
                l_idx := g_spid_arr.NEXT(l_idx);
                EXIT WHEN NOT g_spid_arr.EXISTS(l_idx);
            END LOOP;
            --
            -- WR55825 Enhancement of splitting on a loss factor change
            --         For both basic and interval readings, Electricity only
            --         Populate Factor1 and Factor2 for ECA records
            --
            l_Msg := 'Failed to retrieve factor1 and factor2';
            --
            Factor_ECA(l_taOECA);
            --
            l_Msg := 'Bulk Insert failed on EChargeAccum';
            --SAVEPOINT ECASavePoint;
            BEGIN
            FORALL i IN 1 .. l_taOECA.SupplyPointID.COUNT
                INSERT INTO EChargeAccum
                    (EChargeAccumID
                    ,Inventoryid
                    ,Supplypointid
                    ,Timebandid
                    ,Etimechargeid
                    ,Datefrom
                    ,Dateto
                    ,Consumption
                    ,Factor1
                    ,Factor2
                    ,ConsBilled
                    ,ConsBilledFactor)  -- SEPI-10786
                VALUES
                    (l_taOECA.RAGID(i)
                    ,l_taOECA.InventoryID(i)
                    ,l_taOECA.SupplyPointID(i)
                    ,l_taOECA.TimeBandID(i)
                    ,l_taOECA.ETimeChargeID(i)
                    ,l_taOECA.DateFrom(i)
                    ,l_taOECA.DateTo(i)
                    ,l_taOECA.Consumption(i)
                    ,l_taOECA.Factor1(i)
                    ,l_taOECA.Factor2(i)
                    ,DECODE(g_ACCUMRNDSTYLE1,'Y'
                           ,ROUND(NVL(l_taOECA.ConsBilled(i),l_taOECA.Consumption(i)), g_RND2DEC)
                           ,NVL(l_taOECA.ConsBilled(i),l_taOECA.Consumption(i)))  -- wr21832 rnd the consbilled
                    ,l_taOECA.ConsBilledfactor(i));  -- SEPI-10786
            EXCEPTION
                WHEN OTHERS THEN
                    oMsg(oMsg.COUNT + 1)   := l_Msg || ' ' || SQLERRM;
                    oRetC(oRetC.COUNT + 1) := 8;
            END;
            --
            IF SQL%ROWCOUNT <> l_taOECA.SupplyPointID.COUNT THEN
                Raise_Application_Error(-20012, l_msg);
            END IF;
            --
            -- WR57931 Implement creation of DumbAccum
            --
            l_Msg := 'Bulk Insert failed on DumbAccum';  -- WR57931
            --
            IF l2da_DumbAccum.COUNT > 0 THEN
                l_DAIdx := l2da_DumbAccum.FIRST;
                FOR i IN 1 .. l2da_DumbAccum.COUNT LOOP
                    FOR j IN 1 .. l2da_DumbAccum(l_DAIdx).COUNT LOOP
                        l_ConsIdx := l2da_DumbAccum(l_DAIdx)(j);
                        --
                        IF l2da_DumbCons.EXISTS(l_ConsIdx) THEN
                            BEGIN
                                FORALL k IN 1 .. l2da_DumbCons(l_ConsIdx).RdgDumbID.COUNT
                                    INSERT INTO DumbAccum
                                        (readingdumbid
                                        ,echargeaccumid
                                        ,consumption)
                                    VALUES
                                        (l2da_DumbCons(l_ConsIdx).RdgDumbID(k)
                                        ,l_DAIdx
                                        ,l2da_DumbCons(l_ConsIdx).Consumption(k));
                            EXCEPTION
                                WHEN OTHERS THEN
                                    oMsg(oMsg.COUNT + 1)   := 'Bulk Insert failed on DumbAccum' || ' ' || SQLERRM;
                                    oRetC(oRetC.COUNT + 1) := 8;
                            END;
                            --
                            IF SQL%ROWCOUNT <> l2da_DumbCons(l_ConsIdx).RdgDumbID.COUNT THEN
                                Raise_Application_Error(-20012, 'Bulk Insert failed on DumbAccum');
                            END IF;
                            --
                            IF g_debug THEN
                                FOR k IN 1 .. l2da_DumbCons(l_ConsIdx).RdgDumbID.COUNT LOOP
                                    Pkg_Util.putbuf('echargeaccumid = ' || l_DAIdx ||
                                                    ', readingdumbid = ' || l2da_DumbCons(l_ConsIdx).RdgDumbID(k) ||
                                                    ', consumption = ' || l2da_DumbCons(l_ConsIdx).Consumption(k)
                                                   ,255
                                                   ,NULL);
                                END LOOP;
                            END IF;
                        END IF;
                    END LOOP;
                    --
                    l_DAIdx := l2da_DumbAccum.NEXT(l_DAIdx);
                    EXIT WHEN l_DAIdx IS NULL;
                END LOOP;

            END IF;
            --
            --  WR99428 implement creation of InvoiceConsumption based on consumption period
            --
            l_Msg := 'Bulk Insert failed on InvoiceConsumption';

            --
            SaveInvCons(iHmbrid, null, lao_ctb);
            --
            IF g_debug THEN
                Pkg_Util.putbuf('l_taOECA>. n .' ||
                                'EChgAccumID.' ||
                                'InventoryID.' ||
                                'InvSPID   .'  ||
                                'TBandID.' ||
                                'ETimeCharge.'||
                                'DateFrom .' ||
                                'DateTo   .' ||
                                'Cons    .'  ||
                                'Factor1 .'||
                                'Factor2 .'
                               ,255
                               ,NULL
                               ,NULL);
                FOR i IN 1 .. l_taOECA.SupplyPointID.COUNT LOOP
/*                  Pkg_Util.putbuf('EChargeAccumID(' || i || ')= ' || l_taOECA.RAGID(i)         ||
                                    ' InventoryID = '               || l_taOECA.inventoryid(i)   ||
                                    ' SupplyPointID = '             || l_taOECA.supplypointid(i) ||
                                    ' TimeBandID = '                || l_taOECA.timebandid(i)    ||
                                    ' ETimeChargeID = '             || l_taOECA.etimechargeid(i) ||
                                    ' DateFrom = '                  || l_taOECA.datefrom(i)      ||
                                    ' DateTo = '                    || l_taOECA.dateto(i)        ||
                                    ' Cons = '                      || l_taOECA.Consumption(i)   ||
                                    ' Factor1 = '                   || l_taOECA.Factor1(i)       ||
                                    ' Factor2 = '                   || l_taOECA.Factor2(i)
                                   ,255
                               ,NULL);*/
                    Pkg_Util.putbuf(lp('l_taOECA>',9) ||rpd(i,3) ||
                                    rpd(l_taOECA.RAGID(i),11)         ||
                                    rpd(l_taOECA.inventoryid(i),11)   ||
                                    rpd(l_taOECA.supplypointid(i),10) ||
                                    rpd(l_taOECA.timebandid(i),7)    ||
                                    rpd(l_taOECA.etimechargeid(i),11) ||
                                    lp(l_taOECA.datefrom(i),9)      ||
                                    lp(l_taOECA.dateto(i),9)        ||
                                    rpd(l_taOECA.Consumption(i),8)   ||
                                    lp(l_taOECA.Factor1(i),8)       ||
                                    lp(l_taOECA.Factor2(i),8)
                                   ,255
                                   ,NULL
                                   ,NULL);
                END LOOP;
                --
                pkg_util.putbuf('There are ' || l_taOECA.SupplyPointID.COUNT || ' Rows in the l_taOECA'
                               ,255
                               ,NULL);
            END IF;
        --Do Demand Usage
        ELSIF iSaveToDB
          AND l_taOECA.SupplyPointID.COUNT > 0
          AND iDoDemand = 'Y' THEN                         -- WR110367

            l_Msg := 'Failed to retrieve factor1 and factor2 for Demand';
            Factor_ECA(l_taOECA);

            l_Msg := 'Bulk Insert failed on EChargeAccum for Demand';
            BEGIN
              FORALL i IN 1 .. l_taOECA.SupplyPointID.COUNT
                  INSERT INTO EChargeAccum
                      (EChargeAccumID
                      ,Inventoryid
                      ,Supplypointid
                      ,Timebandid
                      ,Etimechargeid
                      ,Datefrom
                      ,Dateto
                      ,Consumption
                      ,Factor1
                      ,Factor2
                      ,ConsBilled
                      ,ConsBilledfactor)  -- SEPI-10786
                  VALUES
                      (l_taOECA.RAGID(i)
                      ,l_taOECA.InventoryID(i)
                      ,l_taOECA.SupplyPointID(i)
                      ,l_taOECA.TimeBandID(i)
                      ,l_taOECA.ETimeChargeID(i)
                      ,l_taOECA.DateFrom(i)
                      ,l_taOECA.DateTo(i)
                      ,l_taOECA.Consumption(i)
                      ,l_taOECA.Factor1(i)
                      ,l_taOECA.Factor2(i)
                      ,DECODE(g_ACCUMRNDSTYLE1,'Y'
                             ,ROUND(NVL(l_taOECA.ConsBilled(i),l_taOECA.Consumption(i)), g_RND2DEC)
                             ,NVL(l_taOECA.ConsBilled(i),l_taOECA.Consumption(i)))  -- wr21832 rnd the consbilled
                      ,l_taOECA.ConsBilledfactor(i));  -- SEPI-10786

            EXCEPTION
                WHEN OTHERS THEN
                    oMsg(oMsg.COUNT + 1)   := l_Msg || ' ' || SQLERRM;
                    oRetC(oRetC.COUNT + 1) := 8;
            END;
            --
            IF SQL%ROWCOUNT <> l_taOECA.SupplyPointID.COUNT THEN
                Raise_Application_Error(-20012, l_msg);
            END IF;

        END IF;
        otaOECA := l_taOECA;
        otaCTB := lao_CTB;
        --
        l_Msg := 'Failed to release locks';  -- WR57931
        ReleaseLock;
        oRC := SetReturnCode(oRetC);
        --
    EXCEPTION
        WHEN X_OOPS THEN
            omsg(oMsg.COUNT + 1)   := l_ErrorMessage;
            oRetC(oRetC.COUNT + 1) := 8;  -- WR58161
            ReleaseLock;
            oRC := SetReturnCode(oRetC);
        WHEN xexit THEN
            ReleaseLock;
            oRC := SetReturnCode(oRetC);
        WHEN xhmbrlock THEN
            oRC := SetReturnCode(oRetC);
        WHEN xsitelock THEN
            ReleaseLock('HM');
            oRC := SetReturnCode(oRetC);
        WHEN OTHERS THEN
            --      ROLLBACK TO ECASavePoint;
            omsg(oMsg.COUNT + 1)   := SUBSTR(l_msg || ', Account HMBRID ' || iHMbrID ||
                                             ', Date to ' || iDateTo || ' - ' || SQLERRM, 1, 250);
            oRetC(oRetC.COUNT + 1) := 8;
            ReleaseLock;
            oRC := SetReturnCode(oRetC);
    END NewECA;

    ------------------------------------------------------------
    -- WR99428
    Procedure CreateInvoiceConsumption(iHmbrid    number
                                     ,iInvoiceId number
                                     ,iDateFrom  Date
                                     ,iDateTo    Date
                                     ) IS

    lao_CTB         trInvCons;
	l_taOECA        pkg_accum.trRAG;

    l_Tmp_retc      Pkg_Std.taInt;
    l_Tmp_errdescr  pkg_Std.taDescr;
    l_Tmp_rc        PLS_INTEGER;

    Begin
        --
        If  iHmbrid is null
           or iInvoiceid is null
           or iDateFrom is null
           or iDateTo is null Then
           --
           Return;
        End If;
        --
        neweca(ihmbrid => iHMbrID,
               idateto => iDateTo,
                   orc => l_Tmp_rc,
                 oretc => l_Tmp_retc,
                  omsg => l_Tmp_errdescr,
             idatefrom => iDateFrom,
			   otaOECA => l_taOECA,
             iSaveToDB => false,
                otaCTB => lao_CTB
               );
        --
        If  l_Tmp_rc <= 4 then
            -- ok to insert
            SaveInvCons(iHmbrid
                       ,iInvoiceId
                       ,lao_CTB
                        );
            --
        Else
            Raise_Application_Error(-20012, 'Failed to Create Invoice Consumption');
        End If;
    End CreateInvoiceConsumption;
    --
    -------------------------------------------------------------------------------------------------
    PROCEDURE TestNewECA(iInvoiceID IN Invoice.InvoiceID%TYPE
                        ,iDocumentNbr IN Invoice.Documentnbr%TYPE
                        ,iDetailed    IN VARCHAR2
                        ) AS
        l_InvoiceID Invoice.InvoiceID%TYPE := iInvoiceID;
        l_rc    PLS_INTEGER;
        l_retc pkg_std.taint;
        l_msg pkg_std.tadescr;
        --l_orc  NUMBER;
        l_taOECA  pkg_accum.trRAG;
		lao_CTB         trInvCons;
        l_Key     VARCHAR2(250);
        TYPE taRAGKey IS TABLE OF pkg_accum.trRAG INDEX BY VARCHAR2(100);
        l_taSECA  taRAGKey;
        --l_taEECA  taRAGKey;
        l_Line    BOOLEAN := TRUE;
        l_ProductCode Product.ProductCode%TYPE;
        l_RatingPlan  RatingPlan.Descr%TYPE;
        l_Status      VARCHAR2(30);
        l_IncRetail   VARCHAR2(5);
        l_Count_Tested    PLS_INTEGER := 0;
        l_Count_OK        PLS_INTEGER := 0;
        l_Count_Failed    PLS_INTEGER := 0;
        l_Count_Skipped   PLS_INTEGER := 0;

    BEGIN
        g_lock  := FALSE;
        --g_SaveToDB := FALSE;
        IF iDocumentNbr IS NOT NULL
        AND iInvoiceID IS NULL THEN
            SELECT InvoiceID
            INTO   l_InvoiceID
            FROM Invoice
            WHERE DocumentNbr = iDocumentNbr;
        END IF;

        FOR inv IN (SELECT HMbrID, trunc(DateFrom) DateFrom, trunc(DateTo) DateTo, InvoiceID, i.DOCUMENTNBR, rownum, InvoiceStatus
                    FROM Invoice i
                    WHERE i.InvoiceID = iInvoiceID
                    ) LOOP

            l_taSECA.delete;
            l_Msg.delete;
            l_Line := FALSE;
            l_Status := NULL;
            IF inv.InvoiceStatus IN ('C','F', 'D', 'H') THEN
                FOR eca IN (
                    SELECT
                        eca.inventoryid,
                        eca.timebandid,
                        sum(eca.consumption) Consumption,
                        eca.InventoryID||'_'||eca.TimebandID ECAKey
                    FROM EChargeAccum eca, InvoiceCharge ic
                    WHERE ic.InvoiceID = inv.InvoiceID
                    AND   eca.InvoiceChargeID = ic.InvoiceChargeID
                    and   not exists ( select 1
                                         from timeband td
                                        where td.timebandid = eca.timebandid
                                          and upper(descr) like '%DEMAND%')
                    GROUP BY eca.InventoryID, eca.TimebandID, eca.InventoryID||'_'||eca.TimebandID
                    ORDER BY eca.InventoryID, eca.TimebandID) LOOP

                    l_taSECA(eca.ecaKey).inventoryid(1) := eca.InventoryID;
                    l_taSECA(eca.ecaKey).timebandid(1) := eca.timebandid;
                    l_taSECA(eca.ecaKey).consumption(1) := eca.consumption;

                END LOOP;

                l_Count_Tested := l_Count_Tested + 1;
                l_Status := NULL;
                neweca(ihmbrid => inv.HMbrID,
                       idateto => inv.DateTo,
                       orc => l_rc,
                       oretc => l_retc,
                       omsg => l_msg,
                       idatefrom => inv.DateFrom,
                       otaOECA => l_taOECA,
					   iSaveToDB => false,
                       otaCTB => lao_CTB);
                FOR i IN 1..l_msg.count LOOP
                    dbms_output.put_line('omsg = '||l_msg(i));
                    l_Line := TRUE;
                    l_Status := 'Skipped';
                END LOOP;
            ELSE
                l_Msg(1) := 'Skipped invoice because of status';
                l_Status := 'Skipped';
            END IF;

            IF l_Msg.count = 0 THEN
                FOR i IN 1 .. l_taOECA.SupplyPointID.COUNT LOOP
                    l_Key := l_taOECA.inventoryid(i)||'_'||l_taOECA.timebandid(i);

                    IF NOT l_taSECA.exists(l_Key)
                    OR NOT l_taSECA(l_Key).Contrib_Cons.exists(1) THEN
                        l_taSECA(l_Key).Contrib_Cons(1) := l_taOECA.Consumption(i);
                    ELSE
                        l_taSECA(l_Key).Contrib_Cons(1) := l_taSECA(l_Key).Contrib_Cons(1) + l_taOECA.Consumption(i);
                    END IF;
                END LOOP;
                --


                l_key := l_taSECA.first;
                FOR i IN 1..l_taSECA.count LOOP
                    IF NOT l_taSECA.exists(l_Key)
                    OR NOT l_taSECA(l_Key).Contrib_Cons.exists(1) THEN
                        pkg_util.putbuf('Missing entry from Pkg_AMI '||l_Key||' InvDoc#='||inv.Documentnbr||' InvoiceID='||inv.InvoiceID||' HMbrID='||inv.HMbrID,255);
                        l_Line := TRUE;
                        l_Status := 'Failed';
                    ELSIF NOT l_taSECA.exists(l_Key)
                    OR NOT l_taSECA(l_Key).Consumption.exists(1) THEN
                        l_Status := 'Failed';
                        pkg_util.putbuf(chr(13)||chr(10)||'Missing entry from DB '||l_Key||' InvDoc#='||inv.Documentnbr||' InvoiceID='||inv.InvoiceID||' HMbrID='||inv.HMbrID
                                       ,255);
                        l_Line := TRUE;
                        FOR j IN 1 .. l_taOECA.SupplyPointID.COUNT LOOP
                            IF substr(l_Key,1,instr(l_Key,'_',1)-1) = l_taOECA.inventoryid(j) THEN
                                SELECT p.ProductCode
                                INTO l_ProductCode
                                FROM Inventory i, Product p
                                WHERE i.InventoryID = l_taOECA.inventoryid(j)
                                AND   p.ProductID = i.ProductID;
                                SELECT Descr
                                INTO l_RatingPlan
                                FROM RatingPlan rp, ETimeCharge etc
                                WHERE etc.ETimeChargeID = l_taOECA.etimechargeid(j)
                                AND   rp.RatingPlanID = etc.RatingPlanID;
                                l_IncRetail := 'N';
                                BEGIN
                                    SELECT 'Y'
                                    INTO   l_IncRetail
                                    FROM dual
                                    WHERE EXISTS
                                        (SELECT 0
                                        FROM  InvProperty
                                        WHERE InventoryID = l_taOECA.inventoryid(j)
                                        AND   PropValChar = 'Y');
                                EXCEPTION
                                    WHEN OTHERS THEN NULL;
                                END;

                                IF l_IncRetail = 'N'
                                OR iDetailed = 'Y' THEN
                                    Pkg_Util.putbuf('EChargeAccumID(' || i || ')= ' || l_taOECA.RAGID(j)         ||
                                                    ' InventoryID = '               || l_taOECA.inventoryid(j)   ||
                                                    ' SupplyPointID = '             || l_taOECA.supplypointid(j) ||
                                                    ' TimeBandID = '                || l_taOECA.timebandid(j)    ||
                                                    ' ETimeChargeID = '             || l_taOECA.etimechargeid(j) ||
                                                    ' DateFrom = '                  || l_taOECA.datefrom(j)      ||
                                                    ' DateTo = '                    || l_taOECA.dateto(j)        ||
                                                    ' Cons = '                      || round(l_taOECA.Consumption(j),4)   ||
                                                    ' Product = '                   || l_ProductCode             ||
                                                    ' RatingPlan = '                || l_RatingPlan              ||
                                                    ' Incl in Rtl = '               ||l_IncRetail
                                                   ,255
                                                   ,NULL);
                                END IF;
                            END IF;
                        END LOOP;

                    ELSIF round(l_taSECA(l_Key).Consumption(1),3) = round(l_taSECA(l_Key).Contrib_Cons(1),3) THEN
                        l_Status := nvl(l_Status,'OK');
                    ELSE
                        pkg_util.putbuf('Cons Bad InvDoc#='||inv.Documentnbr||' InvoiceID='||inv.InvoiceID||' HMbrID='||inv.HMbrID||' Key='||l_Key||' DB='||l_taSECA(l_Key).Consumption(1)||' Pkg_AMI='||l_taSECA(l_Key).Contrib_Cons(1),255);
                        l_Status := 'Failed';
                        FOR j IN 1 .. l_taOECA.SupplyPointID.COUNT LOOP
                            IF substr(l_Key,1,instr(l_Key,'_',1)-1) = l_taOECA.inventoryid(j) THEN
                                SELECT p.ProductCode
                                INTO l_ProductCode
                                FROM Inventory i, Product p
                                WHERE i.InventoryID = l_taOECA.inventoryid(j)
                                AND   p.ProductID = i.ProductID;
                                SELECT Descr
                                INTO l_RatingPlan
                                FROM RatingPlan rp, ETimeCharge etc
                                WHERE etc.ETimeChargeID = l_taOECA.etimechargeid(j)
                                AND   rp.RatingPlanID = etc.RatingPlanID;
                                l_IncRetail := 'N';
                                BEGIN
                                    SELECT 'Y'
                                    INTO   l_IncRetail
                                    FROM dual
                                    WHERE EXISTS
                                        (SELECT 0
                                        FROM  InvProperty
                                        WHERE InventoryID = l_taOECA.inventoryid(j)
                                        AND   PropValChar = 'Y');
                                EXCEPTION
                                    WHEN OTHERS THEN NULL;
                                END;
                                IF l_IncRetail = 'N'
                                OR iDetailed = 'Y' THEN
                                    Pkg_Util.putbuf('EChargeAccumID(' || i || ')= ' || l_taOECA.RAGID(j)         ||
                                                    ' InventoryID = '               || l_taOECA.inventoryid(j)   ||
                                                    ' SupplyPointID = '             || l_taOECA.supplypointid(j) ||
                                                    ' TimeBandID = '                || l_taOECA.timebandid(j)    ||
                                                    ' ETimeChargeID = '             || l_taOECA.etimechargeid(j) ||
                                                    ' DateFrom = '                  || l_taOECA.datefrom(j)      ||
                                                    ' DateTo = '                    || l_taOECA.dateto(j)        ||
                                                    ' Cons = '                      || round(l_taOECA.Consumption(j),4)   ||
                                                    ' Product = '                   || l_ProductCode             ||
                                                    ' RatingPlan = '                || l_RatingPlan              ||
                                                    ' Incl in Rtl = '               || l_IncRetail
                                                   ,255
                                                   ,NULL);
                                END IF;
                            END IF;
                        END LOOP;
                        l_Line := TRUE;
                    END IF;
                    l_Key := l_taSECA.Next(l_Key);
                END LOOP;
            END IF;
            IF l_Line THEN
                pkg_util.putbuf('-------------------');
            END IF;
            l_Line := FALSE;
            IF l_Status = 'Failed' THEN
                l_Count_Failed := l_Count_Failed + 1;
            ELSIF l_Status = 'Skipped' THEN
                l_Count_Skipped := l_Count_Skipped + 1;
            ELSIF l_Status = 'OK' THEN
                l_Count_OK := l_Count_OK + 1;
            END IF;
            ROLLBACK;
        END LOOP;
        pkg_util.putbuf('Count Tested = '||l_Count_Tested||chr(13)||chr(10)
                      ||'Count Skipped = '||l_Count_Skipped||chr(13)||chr(10)
                      ||'Count Failed = '||l_Count_Failed||chr(13)||chr(10)
                      ||'Count OK = '||l_Count_OK);
    END TestNewECA;
    -------------------------------------------------------------------------------------------------
    PROCEDURE Clear_Arrays IS
    BEGIN
        rparr.DELETE;
        l_TimeBand.DELETE;
        l_TimeSet.DELETE;
        l_timerange.DELETE;
        g_brcaltype := NULL;
        g_AccumRndStyle1 := NULL;
        rpspmaptb.DELETE;
        g_spid_arr.DELETE;
    END;

    -------------------------------------------------------------------------------------------------
    -- Returns the package version and date mainly used for debugging wrapped code
    -------------------------------------------------------------------------------------------------
    FUNCTION version RETURN VARCHAR2 IS
    BEGIN
        --RETURN 'pkg_AMI.sql $Revision: \hubu_unix_src?main?eraus\41 $ $Date: Fri May 20 15:04:57 2016 $';
        RETURN pkg_Prop_Java.formatVersion($$PLSQL_UNIT, currentRelease, devVersion);
    END;
    ----------------------------------------------------------------------------------------

BEGIN
    -- WR80414. Only need to retrieve country location once.
    FOR i IN (SELECT LocationID FROM LOCATION
              WHERE  LOCATIONTYPE = 'CNTRY' AND CompleteFlg = 'Y') LOOP
        g_loc_country := i.locationid;
    END LOOP;
    --
    g_debug := ( g_debug or  pkg_feature.val('DEBUGLEVEL') > 80 );

END pkg_AMI;
/
