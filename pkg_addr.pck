CREATE OR REPLACE PACKAGE pkg_addr
IS
    --
    --    $Revision: \hubu_unix_src?main?aiew?enaus?28 $
    --    $Date: Wed Aug  3 14:36:04 2016 $
    --
    --    Application  : Hansen Universal Billing (HUB)
    --    Author       : Ewen Haylock
    --    Purpose      : Address maintenance functions.
    --                   Functions that use third party products are implemented
    --                   in pkg_addr_lib_online and pkg_addr_lib_batch.
    --
    -- Revision History:
    -- -------------------------------------------------------
    -- $Log: M:\shanz_ERAUS_hubub139035\hubu_unix_src?PVCS?Packages\pkg_addr.sql $
    
-- Latest log on the top please........
-- Ver      	Date        WR/Story        Author                  Description
-- ---      	----        ---------       -------------------     --------------------------------------------------------------------------------------
-- 21.2.002     09/04/2021  SEPI-27251      Tai Pham                Invalid character Error in Partner Portal upload due to Street names with apostrophes
-- 21.2.001     19/03/2021  SEPI-27315      Ngu Dong                Create a property set for address attributes: UIADDRDET
-- 21.2.002     12/04/2021  SEPI-27450      Ngu Dong                Update procedure: SaveAddrDetail (UIADDRDET)
-- 21.2.003     06/05/2021  SEPI-27442      Ngu Dong                Concantenate specific address attributes for HouseNumber and PostalDeliveryNumber payload attributes in Structured Address for outbound events

-- \hubu_unix_src?main?aiew?enaus?28  Wed Aug  3 14:36:04 2016  shanz

--Merge to main line


-- \hubu_unix_src?main?aiew?enaus?hubub139035\1  Wed Jul 20 12:06:00 2016  shanz

--WR139035: use trimmed postcode when calling pkg_pqaGetAddr in function GetAddrId


-- \hubu_unix_src?main?aiew?enaus?27  Thu Mar 10 18:00:23 2016  zedh01

--Wr 133668  release


-- \hubu_unix_src?main?aiew?enaus?hubub133668\1  Thu Mar 10 15:08:27 2016  zedh01

--Wr 133668  java web services - enable a part of a formatted
--address parts to be retrieved eg line 1, line 2, state


-- \hubu_unix_src?main?aiew?enaus?26  Mon Sep 21 18:17:10 2015  zkxf28

--wr124379 - merge to mainline


-- \hubu_unix_src?main?aiew?enaus?hubub124397\1  Fri Aug  7 09:43:46 2015  zkxf28

--wr124397 - Do Address checking on indiviual address components rather than address ids


-- \hubu_unix_src?main?aiew?enaus?25  Fri May  2 08:30:31 2014  jonesb

--Re-checkin to create HyperLink to CQ


-- \hubu_unix_src?main?aiew?enaus?24  Thu May  1 12:03:14 2014  zsxn20



-- \hubu_unix_src?main?aiew?enaus?hubub80722\2  Thu May  1 12:00:33 2014  zsxn20

--Checked out and checked in without any code change to overcome an issue relating to ClearCase version control -zsxn20


-- \hubu_unix_src?main?aiew?enaus?hubub80722\1  Tue May 29 16:02:07 2012  ztxj10

--WR80722 Fix transaction gets stuck in loop when NULL Address


-- \hubu_unix_src?main?aiew?enaus?22  Wed Oct 12 17:03:28 2011  ztxj10

--Merge


-- \hubu_unix_src?main?aiew?enaus?hubub70835\1  Wed Oct 12 16:11:15 2011  ztxj10

--WR70835 Make address matching case insensitive


-- \hubu_unix_src?main?aiew?enaus?21  Tue Mar 16 16:37:29 2010  ztxw50

--WR57542 - In the calls to pkg_lochlinkedlocn, require a match on lochid rather than assuming the first row is sufficient


-- \hubu_unix_src?main?aiew?enaus?hubub57542\1  Tue Mar  2 11:59:55 2010  zixn35

--In the calls to pkg_lochlinkedlocn, require a match on lochid rather than assuming the first row is sufficient


-- \hubu_unix_src?main?aiew?enaus?18  Wed Oct 29 09:08:57 2008  zjxp25

--wr45916


-- \hubu_unix_src?main?aiew?enaus?eraus\1  Wed Oct 29 09:07:57 2008  zjxp25

--wr45916


-- \hubu_unix_src?main?aiew?enaus?eraus\hubub45916\1  Wed Oct 29 09:06:06 2008  zjxp25

--wr45916 merge agl changes to ea


-- \hubu_unix_src?main?aiew?enaus?17  Fri Oct 12 13:20:02 2007  danny

--WR37720 -merge


-- \hubu_unix_src?main?aiew?enaus?hubub37720\1  Tue Sep 18 17:22:22 2007  zsxn20

--WR37720 - Postal delivery address failure in HUBNet

    --

-- \hubu_unix_src?main?aiew?enaus?16  Fri Oct 12 12:25:42 2007  danny

--WR38298 - merge


-- \hubu_unix_src?main?aiew?enaus?hubub38298\1  Fri Oct 12 12:23:08 2007  danny

--WR38298 - Fixed no data found on new address


-- \hubu_unix_src?main?aiew?enaus?14  Tue Aug 28 10:41:16 2007  zsxn20



-- \hubu_unix_src?main?aiew?enaus?hubub37154\2  Tue Aug 28 10:39:57 2007  zsxn20



-- \hubu_unix_src?main?aiew?enaus?hubub37154\1  Mon Aug 27 10:53:00 2007  zsxn20

--WR37154 - Postal Develivery Type not displayed in the address line


-- \hubu_unix_src?main?aiew?enaus?12  Fri Mar 30 13:58:21 2007  zrxc20

--WR29951: Merge


    -- \hubu_unix_src?main?aiew?enaus?hubub29951\1  Fri Mar  2 16:44:14 2007  zrxc20

    --WR29951: HUB-QAS Integration


    -- \hubu_unix_src?main?aiew?enaus?10  Fri Sep 10 15:51:32 2004  zoxm35

    --WR 10700 Fix "double space" problem


    -- \hubu_unix_src?main?aiew?enaus?9  Thu Sep  2 15:20:02 2004  zoxm35

    --WR10700 - Unstructured addresses validation - merge to main line


    -- \hubu_unix_src?main?aiew?enaus?hubub10700\1  Wed Aug 25 16:23:03 2004  zoxm35

    --WR 10700 - Unstructured Address Validation


    -- \hubu_unix_src?main?aiew?enaus?8  Thu Mar 11 11:07:21 2004  zexv10

    --WR9415, Small fix after System Test


    -- \hubu_unix_src?main?aiew?enaus?hubub9415\3  Thu Mar 11 10:59:20 2004  zexv10

    --WR9415

    --Small fix after System Test


    --Apply ASEXML standards to address data entry


    -- \hubu_unix_src?main?aiew?enaus?hubub9415\2  Fri Feb 27 12:19:07 2004  zexv10

    --WR9415
    --Apply ASEXML standards to address validation


    -- \hubu_unix_src?main?aiew?enaus?hubub9415\1  Fri Feb 20 16:01:55 2004  zexv10

    --WR9415


    -- \hubu_unix_src?main?aiew?enaus?4  Fri Aug  1 11:18:15 2003  ztxc21

    --WR8255 - Merge to enaus branch


    -- \hubu_unix_src?main?aiew?enaus?hubub8255\1  Fri Aug  1 11:09:35 2003  ztxc21

    --WR8255 - Add new function for Address Matching


    -- \hubu_unix_src?main?aiew?enaus?2  Mon May 26 19:24:24 2003  zedh01

    --Wr 7772  Merge changes to release branch


    -- \hubu_unix_src?main?aiew?enaus?hubub7772\1  Mon May 26 19:09:57 2003  zedh01
    -- \hubu_unix_src?main?aiew?enaus?1  Tue May 20 15:54:06 2003  zgxy22

    --Wr 7772  Address initialisation issues

    --Street and Suburb cleanup issues


    --WR 7668 : merge to mainline


    -- \hubu_unix_src?main?aiew?enaus?hubub7668\1  Mon May 19 18:13:26 2003  zedh01

    --Wr 7668 7005  Enable creation of lochmbrs from online address maint

    --Enable creation of asexml unstructured addresses

    --Move functions for accessing third party address maint software to other packages



    -- Public type declarations
    --  type <TypeName> is <Datatype>;
    k_Fld_Delim CONSTANT VARCHAR(1) := pkg_K.K_Fld_Delim;
    -- Public constant declarations
    --  <ConstantName> constant <Datatype> := <Value>;

    -- Public variable declarations
    --  <VariableName> <Datatype>;

    -- Public function and procedure declarations
    --  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;
    --
    FUNCTION version RETURN VARCHAR2 ;

    FUNCTION InsertAPKey(iAPKey         IN AddressProperty.APkey%TYPE
                        ,iAPKeyDescr    IN AddressProperty.Descr%TYPE
                        ,iAddrTmplDescr IN AddressTemplate.Descr%TYPE
                        ,iAddrTmplKey   IN AddressTemplate.Addresstemplatekey%TYPE
                        ,iFmtMthd       IN FormatMethod.Fmkey%TYPE
                        ,iFmtMthdDescr  IN FormatMethod.Descr%TYPE
                        ,iAfterAPKey    IN AddressProperty.APkey%TYPE DEFAULT NULL
                        ,iLocnType      IN LocationType.Locationtype%TYPE DEFAULT NULL
                        ,iCountryDescr  IN Dictionary.Phrase%TYPE DEFAULT NULL
                        ,iAPLocHType    IN AddressProperty.LocHType%TYPE DEFAULT NULL
                        ,iAPLocHMbrType IN AddressProperty.LochMbrType%TYPE DEFAULT NULL
                        ,iAPPropertyKey IN AddressProperty.Propertykey%TYPE DEFAULT NULL) RETURN countryap.countryapid%TYPE;
    --
    PROCEDURE RefreshAPKeys(iAddressTemplateId IN addresstemplate.addresstemplateid%TYPE DEFAULT NULL
                           ,iDescr             IN addresstemplate.descr%TYPE DEFAULT NULL);
    --
    FUNCTION LochmbrLocationId(iCountryAPId       IN countryap.countryapid%TYPE
                              ,iAddressLocationId IN addresspropertyval.addressid%TYPE) RETURN location.locationid%TYPE;
    --
    FUNCTION LochmbrLocationDescr(iCountryAPId       IN countryap.countryapid%TYPE
                                 ,iAddressLocationId IN addresspropertyval.addressid%TYPE) RETURN dictionary.phrase%TYPE;
    --
    PROCEDURE GetAddrId(iAction             IN VARCHAR2
                       ,iAddressTemplateKey IN addresstemplate.addresstemplatekey%TYPE
                       ,iAPKey              IN pkg_std.takey
                       ,iPropValChar        IN pkg_std.tadescr
                       ,oAddressId          OUT Address.AddressId%TYPE);
    --
    PROCEDURE GetAddrId(iAction            IN VARCHAR2
                       ,iAddressTemplateId IN addresstemplate.addresstemplateid%TYPE
                       ,iCountryAPId       IN pkg_std.tainteger
                       ,iLocationId        IN pkg_std.tainteger
                       ,iPropValChar       IN pkg_std.tadescr
                       ,oAddressId         OUT Address.AddressId%TYPE);
    --
    FUNCTION Barcode(iAddressId IN address.addressid%TYPE) RETURN address.barcode%TYPE;
    --IAG     PRAGMA RESTRICT_REFERENCES (Barcode ,WNDS) ;
    --
    -- WR8255
    FUNCTION AddrMatch(iAddressID1 IN address.addressid%TYPE
                      ,iAddressID2 IN address.addressid%TYPE) RETURN BOOLEAN;

    FUNCTION AddrMatch2(iAddressID1 IN address.addressid%TYPE
                       ,iAddressID2 IN address.addressid%TYPE) RETURN VARCHAR;
                       
    -- SEPI-25123  Address compare between two addressIDs.
    -- Ignore non-critical address element matches.
    FUNCTION AddrMatch(iAddressID1 IN address.addressid%TYPE
                      ,iAddressID2 IN address.addressid%TYPE
                      ,oMsg        OUT VARCHAR2) RETURN PLS_INTEGER;
     
    -- SEPI-25123  Address compare between an existing address and new addressElements.
    -- Ignore non-critical address element matches.                 
    FUNCTION AddrMatch(iAddressID1 IN address.addressid%TYPE
                      ,iAddressRec IN pkg_ws_offercreate.rAddressInfo
                      ,oMsg        OUT VARCHAR2) RETURN PLS_INTEGER;

    FUNCTION AddrMatch(iAddressRec IN pkg_ws_offercreate.rAddressInfo
                      ,iAddrLst    IN  VARCHAR2 DEFAULT NULL
                      ,oRc         OUT pls_integer
                      ,oMsg        OUT VARCHAR2) RETURN PLS_INTEGER;

    -- SEPI-26819 / SEPI-26820 Do address matching using table function.
    FUNCTION AddrMatch_TF(iAddressRec IN  pkg_ws_offercreate.rAddressInfo
                      ,iAddrLst    IN  VARCHAR2 DEFAULT NULL
                      ,oRc         OUT pls_integer
                      ,oMsg        OUT VARCHAR2) RETURN PLS_INTEGER;
                      
    -- SEPI-26819 / SEPI-26820 Convert vw_detailaddress view to a table function.
    FUNCTION ADDRESSDETAIL (
             iAddressID    IN Address.AddressID%TYPE DEFAULT NULL
            ,iSTATEDESCR   IN VARCHAR2 DEFAULT NULL
            ,iSUBURBDESCR  IN VARCHAR2 DEFAULT NULL
            ,iSUBPCDESCR   IN VARCHAR2 DEFAULT NULL
            ,iSTRDESCR     IN VARCHAR2 DEFAULT NULL
            ,iPREMNM       IN VARCHAR2 DEFAULT NULL
            ,iPREMNM2      IN VARCHAR2 DEFAULT NULL
            ,iFUT          IN VARCHAR2 DEFAULT NULL
            ,iSPREM        IN VARCHAR2 DEFAULT NULL
            ,iFLT          IN VARCHAR2 DEFAULT NULL
            ,iFLRLVL       IN VARCHAR2 DEFAULT NULL
            ,iPREMNO       IN VARCHAR2 DEFAULT NULL
            ,iPREMSFX      IN VARCHAR2 DEFAULT NULL
            ,iPREMNO2      IN VARCHAR2 DEFAULT NULL
            ,iPREMSFX2     IN VARCHAR2 DEFAULT NULL               
            ,iLOTNO        IN VARCHAR2 DEFAULT NULL                   
            ,iPOBOXTY      IN VARCHAR2 DEFAULT NULL                      
            ,iPOBOXP       IN VARCHAR2 DEFAULT NULL                    
            ,iPOBOX        IN VARCHAR2 DEFAULT NULL                
            ,iPOBOXS       IN VARCHAR2 DEFAULT NULL                     
            ,iLOCDESC      IN VARCHAR2 DEFAULT NULL                 
            ,iLOCHPCODE    IN VARCHAR2 DEFAULT NULL                 
            ,iDPID         IN VARCHAR2 DEFAULT NULL)
    RETURN TT_ADDRESSDETAIL;
    
    --
    -- WR10700
    TYPE taStrip IS TABLE OF VARCHAR2(10) INDEX BY PLS_INTEGER;
    FUNCTION UnstructAddressCompare(iEntred_Address IN VARCHAR2
                                   ,iMarket_Address IN VARCHAR2) RETURN BOOLEAN;
    FUNCTION UnstructAddressComp(iEntred_Address IN VARCHAR2
                                ,iMarket_Address IN VARCHAR2) RETURN PLS_INTEGER; -- 0 OK, 4 Warning, 8 Error

     --Returns a formatted address string
    --The delimitor allows some control of the display format, for example, allows line feed to
    --be included in the string output
    FUNCTION get_Formatted(iAddressID   IN PLS_INTEGER
                          ,iLocHDescFlg IN VARCHAR2 DEFAULT 'Y'
                          ,iDelimiter   IN VARCHAR2 DEFAULT k_Fld_Delim
                          ,iLocHMbrType IN VARCHAR2 DEFAULT NULL
                          ,iCallingPgm  in varchar2 default null) RETURN VARCHAR2;

    -- Returns a formatted address string for the new UI
    -- Shell function to call the existing routine with a parameter to modify behaviour. The only difference
    -- being that the address string contains full-text descriptions for flat/unit location types
    FUNCTION get_FormattedUI(iAddressID   IN PLS_INTEGER
                            ,iLocHDescFlg IN VARCHAR2 DEFAULT 'Y'
                            ,iDelimiter   IN VARCHAR2 DEFAULT k_Fld_Delim
                            ,iLocHMbrType IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

    -- Wr 133668  Java Web Service address retieval
    -- Enables a query to retrieve parts of a formatted address
    -- The part group is a name for a collection of parts
    -- The part key identifies a part of the collection
    --   iPartGroup = 'WSADDR'
    --   iPartkey
    --     L1                    address line 1
    --     L2                    address line 2
    --     L3                    address line 3
    --     L<iMaxAddrLines>      address line (iMaxAddrLines)
    --     LOCN
    --     PCD
    -- The maximum address lines determines if parts are dropped from the result
    -- -----------------------------------------------------------------------------------------
    FUNCTION getFormattedPart (
        iAddressId                     IN address.addressid%TYPE
       ,iPartGroup                     IN VARCHAR2
       ,iPartKey                       IN VARCHAR2
       ,iMaxAddrLines                  IN PLS_INTEGER                 DEFAULT NULL
       )
    RETURN VARCHAR2;


    -- Return a part of a address as it is stored in the DB
    -- iPartKey is any of the field names from pkg_Loch.AddressVariables
    -- EG 'BuildingName1' or 'StreetType2'

    FUNCTION getRawPart(iAddressID1 IN address.addressid%TYPE
                       ,iPartKey    IN VARCHAR2)
    RETURN VARCHAR2;

    --*************************************************************************
    -- SEPI-1878 / SEPI-1357 SE Credit Check's use
    -- Return a delimeter seperated address for the credit checking application
    -- Example:  BuildingName|UnitNumber|StreetNumber|StreetName|StreetType|Suburb|PostCode
    FUNCTION getDelimitedAddress(iAddressID1 IN address.addressid%TYPE
                                ,iDelimiter  IN VARCHAR2)
    RETURN VARCHAR2;


    -- Create an address in HUB from QAS

    FUNCTION CreateQASAddress(iAddrTemplateKey in varchar2
                             ,iData            in varchar2)
    RETURN pls_integer;

    FUNCTION getAddrMatchForDtl (iAddrRec pkg_ws_offercreate.rAddressInfo) 
      RETURN address.addressid%TYPE;              --SEPI-24567
    
    ---- SEPI-27315
    PROCEDURE SaveAddrDetail(p_action              IN VARCHAR2,
                            p_data                 IN CLOB,
                            p_languageCode         IN  VARCHAR2 DEFAULT 'ENG',
                            p_statusInd            OUT VARCHAR2,
                            p_messageJSON          OUT CLOB,
                            p_returnFieldsJSON     OUT CLOB);
    
    ---- SEPI-27315
    FUNCTION GetAddrDetail (iAddressID    IN Address.AddressID%TYPE)
    RETURN TT_UIADDRDET; 
    
END pkg_addr;
/
CREATE OR REPLACE PACKAGE BODY pkg_addr
IS
    -- Private type declarations
    --
    --  Address templates
    TYPE r_adt IS RECORD(
         addresstemplateid  pkg_std.taint
        ,addresstemplatekey pkg_std.tapropkey
        ,inclcountryflg     pkg_std.tacode
        ,locationid         pkg_std.taint
        ,phrase             pkg_std.tapvc1000);
    --
    --  CountryAP rows
    TYPE r_cap IS RECORD(
         countryapid    pkg_std.taint
        ,addrtemplateid pkg_std.taint
        ,locationtype   pkg_std.tacode
        ,apkey          pkg_std.tapropkey
        ,seq            pkg_std.taint
        ,lochtype       pkg_std.tacode
        ,lochmbrtype    pkg_std.tacode
        ,propertykey    pkg_std.tapropkey
        ,descr          pkg_std.tadescr);

    --  Location abbreviations
    TYPE r_locationdescr IS RECORD(
         locationid pkg_std.taint
        ,phrase     pkg_std.tapvc1000
        ,abbrevtext pkg_std.tadescr);
    --
    --  Cached vars for AddrLochmbrLocation
    TYPE r_AddrLochMbrLocVars IS RECORD(
         CountryAPId    countryap.countryapid%TYPE
        ,AddrLocationId addresspropertyval.addressid%TYPE
        ,LocationId     addresspropertyval.locationid%TYPE
        ,LocationDescr  dictionary.phrase%TYPE);
     --
    TYPE taFMKey IS TABLE OF AddressTemplate.FMKey%TYPE INDEX BY BINARY_INTEGER;
    TYPE taInclCountry IS TABLE OF VARCHAR2(1) INDEX BY BINARY_INTEGER;
    TYPE taCountry IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
    TYPE taLocnDescrAbbrev IS TABLE OF DictionaryText.AbbrevText%TYPE INDEX BY BINARY_INTEGER;
    TYPE taAddrLocnDescr IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;

    -- SEPI-25123 - Used for address matching with critical non critical info.
    TYPE rAddrCompare IS RECORD (
         apkey       vw_addrelement_compare.apkey%TYPE,
         descr       vw_addrelement_compare.descr%TYPE,
         Critical    vw_addrelement_compare.Critical%TYPE,
         Addr1Element addresspropertyval.propvalchar%TYPE,
         Addr2Element addresspropertyval.propvalchar%TYPE,
         Match        VARCHAR2(1));
       
  TYPE tAddrCompare IS TABLE OF rAddrCompare INDEX BY VARCHAR2(50);
  gAddr tAddrCompare; 

    --
    -- Private constant declarations
    --
    g_me     CONSTANT CHAR(08) := 'pkg_addr';
    g_nl     CONSTANT CHAR(01) := chr(10);
    g_flddlm CONSTANT CHAR(01) := pkg_k.k_Fld_Delim;
    g_msgkey CONSTANT CHAR(06) := 'AD_SYS';
    --
    k_FUT         CONSTANT VARCHAR2(12) := 'FUT';
    k_SPREM       CONSTANT VARCHAR2(12) := 'SPREM';
    k_FLT         CONSTANT VARCHAR2(12) := 'FLT';
    k_FLRLVL      CONSTANT VARCHAR2(12) := 'FLRLVL';
    k_PREMNO      CONSTANT VARCHAR2(12) := 'PREMNO';
    k_PREMSFX     CONSTANT VARCHAR2(12) := 'PREMSFX';
    k_PREMNO2     CONSTANT VARCHAR2(12) := 'PREMNO2';
    k_PREMSFX2    CONSTANT VARCHAR2(12) := 'PREMSFX2';
    k_LOTNO       CONSTANT VARCHAR2(12) := 'LOTNO';
    k_POBOXTY     CONSTANT VARCHAR2(12) := 'POBOXTY';
    k_POBOXP      CONSTANT VARCHAR2(12) := 'POBOXP';
    k_POBOX       CONSTANT VARCHAR2(12) := 'POBOX';
    k_POBOXS      CONSTANT VARCHAR2(12) := 'POBOXS';
    k_LOCHMSTRNM  CONSTANT VARCHAR2(12) := 'LOCHMSTRNM';
    k_LOCHMSTRTP  CONSTANT VARCHAR2(12) := 'LOCHMSTRTP';
    k_LOCHMSTRSFX CONSTANT VARCHAR2(12) := 'LOCHMSTRSFX';
    k_LOCHMSUB    CONSTANT VARCHAR2(12) := 'LOCHMSUB';
    k_LOCHMSTATE  CONSTANT VARCHAR2(12) := 'LOCHMSTATE';
    k_LOCHMPCODE  CONSTANT VARCHAR2(12) := 'LOCHMPCODE';
    --
    k_DPID        CONSTANT VARCHAR2(12) := 'DPID' ;
    --
    k_AddrLocHType   CONSTANT VARCHAR(4) := 'ADDR';
    k_PcodeLocHType  CONSTANT VARCHAR(5) := 'PCODE';
    k_Yes            CONSTANT VARCHAR(1) := 'Y';

    --
    -- Private variable declarations
    --
    g_adttemp r_adt;
    g_adt     r_adt;
    g_captemp r_cap;
    g_cap     r_cap;
 --   g_capseq           r_capseq;
 --   g_molhm            r_molhm;
    g_locdescrtemp     r_locationdescr;
    g_locdescr         r_locationdescr;
    g_ALMLVars         r_AddrLochMbrLocVars;
    g_ADDRLocHId       locationhierarchy.lochid%TYPE;
    g_PCODELocHId      locationhierarchy.lochid%TYPE;
    g_GetAddrId_TmplId addresstemplate.addresstemplateid%TYPE;

    x_DPID_Already_Exists EXCEPTION;

    g_InclCountry      taInclCountry;
    g_FMKey            taFMKey;
    g_Country          taCountry;
    g_LocnDescrAbbrev  taLocnDescrAbbrev;
    g_AddrLocnDescr    taAddrLocnDescr;
    g_AddrTemplate     taAddrLocnDescr;
    g_HIDAddr          LocationHierarchy.Lochid%TYPE;
    g_HIDPcode         LocationHierarchy.Lochid%TYPE;

    -- Wr 133668  JAVA Web Service address retieval
    TYPE trFPCache
      IS RECORD (
          aAddrLine                      pkg_Util.taString
         ,townsuburb                     VARCHAR2(100)
         ,statecd                        VARCHAR2(30)
         ,postcode                       VARCHAR2(30)
         ,cachetime                      DATE
         );

    TYPE taFPAddr
      IS TABLE OF trFPCache
      INDEX BY BINARY_INTEGER;

    gaFPAddr                       taFPAddr;
    
    gDebug BOOLEAN := FALSE;       -- SEPI-24567
    -- end Wr 133668

    --
    -- Function and procedure implementations
    --
    FUNCTION version RETURN VARCHAR2 AS
    BEGIN
        RETURN 'pkg_addr.sql $Revision: \hubu_unix_src?main?aiew?enaus?28 $ $Date: Wed Aug  3 14:36:04 2016 $' ;
    END ;

    PROCEDURE writeOut(iText VARCHAR2) IS
    BEGIN
        pkg_util.putbuf(iText);
    END writeOut;
    --
    PROCEDURE log(istr VARCHAR2) IS
        l_LineLength PLS_INTEGER := 250;
    BEGIN
        FOR i IN 1 .. ceil(LENGTH(istr) / l_LineLength) LOOP
            dbms_output.put_line(substr(istr, 1 + (l_LineLength * (i - 1)), l_LineLength));
        END LOOP;
    END log;
    --
    PROCEDURE GetAddrPropDetails(iCapID countryap.countryapid%TYPE DEFAULT NULL) IS
    BEGIN
        --
        --  Get address template member (countryap) info.
        IF iCapID IS NULL THEN
            SELECT a.countryapid
                  ,a.Addresstemplateid
                  ,a.locationtype
                  ,a.apkey
                  ,a.seq
                  ,b.lochtype
                  ,b.lochmbrtype
                  ,b.propertykey
                  ,nvl(a.descr
                      ,b.descr) descr BULK COLLECT
            INTO   g_captemp.countryapid
                  ,g_captemp.addrtemplateid
                  ,g_captemp.locationtype
                  ,g_captemp.apkey
                  ,g_captemp.seq
                  ,g_captemp.lochtype
                  ,g_captemp.lochmbrtype
                  ,g_captemp.propertykey
                  ,g_captemp.descr
            FROM   countryap       a
                  ,addressproperty b
            WHERE  b.apkey = a.apkey
            ORDER  BY a.countryapid;
        ELSE
            SELECT a.countryapid
                  ,a.Addresstemplateid
                  ,a.locationtype
                  ,a.apkey
                  ,a.seq
                  ,b.lochtype
                  ,b.lochmbrtype
                  ,b.propertykey
                  ,nvl(a.descr
                      ,b.descr) descr BULK COLLECT
            INTO   g_captemp.countryapid
                  ,g_captemp.addrtemplateid
                  ,g_captemp.locationtype
                  ,g_captemp.apkey
                  ,g_captemp.seq
                  ,g_captemp.lochtype
                  ,g_captemp.lochmbrtype
                  ,g_captemp.propertykey
                  ,g_captemp.descr
            FROM   countryap       a
                  ,addressproperty b
            WHERE  b.apkey = a.apkey
            AND    a.countryapid = iCapID
            ORDER  BY a.countryapid;
        END IF;
        --
        IF g_captemp.countryapid.COUNT > 0 THEN
            FOR i IN 1 .. g_captemp.countryapid.COUNT LOOP
                g_cap.addrtemplateid(g_captemp.countryapid(i)) := g_captemp.addrtemplateid(i);
                g_cap.locationtype(g_captemp.countryapid(i)) := g_captemp.locationtype(i);
                g_cap.apkey(g_captemp.countryapid(i)) := g_captemp.apkey(i);
                g_cap.seq(g_captemp.countryapid(i)) := g_captemp.seq(i);
                g_cap.lochtype(g_captemp.countryapid(i)) := g_captemp.lochtype(i);
                g_cap.lochmbrtype(g_captemp.countryapid(i)) := g_captemp.lochmbrtype(i);
                g_cap.propertykey(g_captemp.countryapid(i)) := g_captemp.propertykey(i);
                g_cap.descr(g_captemp.countryapid(i)) := g_captemp.descr(i);
            END LOOP;
        END IF;

        g_captemp.addrtemplateid.DELETE;
        g_captemp.locationtype.DELETE;
        g_captemp.apkey.DELETE;
        g_captemp.seq.DELETE;
        g_captemp.lochtype.DELETE;
        g_captemp.lochmbrtype.DELETE;
        g_captemp.propertykey.DELETE;
        g_captemp.descr.DELETE;
        --
        IF g_ADDRLocHId IS NULL THEN
            g_ADDRLocHId := pkg_loch.lochid('ADDR');
        END IF;
        IF g_PCODELocHId IS NULL THEN
            g_PCODELocHId := pkg_loch.lochid('PCODE');
        END IF;
        --
    END GetAddrPropDetails;

    PROCEDURE GetTemplateInfo IS
    BEGIN
        --
        IF g_ADDRLocHId IS NULL THEN
            g_ADDRLocHId := pkg_loch.lochid('ADDR');
        END IF;
        IF g_PCODELocHId IS NULL THEN
            g_PCODELocHId := pkg_loch.lochid('PCODE');
        END IF;
        --  Get template info.
        SELECT c.addresstemplateid
              ,c.addresstemplatekey
              ,c.inclcountryflg
              ,d.locationid
              ,f.phrase BULK COLLECT
        INTO   g_adttemp.addresstemplateid
              ,g_adttemp.addresstemplatekey
              ,g_adttemp.inclcountryflg
              ,g_adttemp.locationid
              ,g_adttemp.phrase
        FROM   addresstemplate c
              ,countrytemplate d
              ,location        e
              ,dictionary      f
        WHERE  d.addresstemplateid(+) = c.addresstemplateid
        AND    e.locationid(+) = d.locationid
        AND    f.dictid(+) = e.descrdictid
        ORDER  BY c.addresstemplateid
                 ,c.inclcountryflg;
        --
        FOR i IN 1 .. g_adttemp.addresstemplateid.COUNT LOOP
            g_adt.addresstemplatekey(g_adttemp.addresstemplateid(i)) := g_adttemp.addresstemplatekey(i);
            g_adt.inclcountryflg(g_adttemp.addresstemplateid(i)) := g_adttemp.inclcountryflg(i);
            g_adt.locationid(g_adttemp.addresstemplateid(i)) := g_adttemp.locationid(i);
            g_adt.phrase(g_adttemp.addresstemplateid(i)) := g_adttemp.phrase(i);
            --  If the country isn't included in the address template
            --  and the template is linked to more than one country then
            --  this process can't work which country to use.
            IF i > 1
               AND g_adttemp.inclcountryflg(i - 1) = 'N'
               AND g_adttemp.inclcountryflg(i) = 'N'
               AND g_adttemp.addresstemplateid(i) = g_adttemp.addresstemplateid(i - 1) THEN
                --  Can't determine country for address template [?]
                pkg_msg.sysmsg(g_msgkey
                              ,1
                              ,g_adttemp.addresstemplatekey(i));
            END IF;
        END LOOP;
    END GetTemplateInfo;

    PROCEDURE GetLocationDescriptions(iLocationID location.locationid%TYPE DEFAULT NULL) IS
    BEGIN
        --  Get descriptions for address related
        --  location types that use abbreviations
        IF iLocationID IS NULL THEN
            SELECT locationid
                  ,phrase
                  ,abbrevtext BULK COLLECT
            INTO   g_locdescrtemp.locationid
                  ,g_locdescrtemp.phrase
                  ,g_locdescrtemp.abbrevtext
            FROM   location       a
                  ,dictionary     b
                  ,dictionarytext c
            WHERE  locationtype IN ('FLT', 'FUT', 'PDT', 'STRTP', 'STRSF')
            AND    b.dictid = a.descrdictid
            AND    c.dictid = a.descrdictid;
        ELSE
            SELECT locationid
                  ,phrase
                  ,abbrevtext BULK COLLECT
            INTO   g_locdescrtemp.locationid
                  ,g_locdescrtemp.phrase
                  ,g_locdescrtemp.abbrevtext
            FROM   location       a
                  ,dictionary     b
                  ,dictionarytext c
            WHERE  b.dictid = a.descrdictid
            AND    c.dictid (+) = a.descrdictid       -- WR38298
            AND    a.locationid = iLocationID;
        END IF;
        --
        FOR i IN 1 .. g_locdescrtemp.locationid.COUNT LOOP
            g_locdescr.phrase(g_locdescrtemp.locationid(i)) := g_locdescrtemp.phrase(i);
            g_locdescr.abbrevtext(g_locdescrtemp.locationid(i)) := g_locdescrtemp.abbrevtext(i);
        END LOOP;
        g_locdescrtemp.locationid.DELETE;
        g_locdescrtemp.phrase.DELETE;
        g_locdescrtemp.abbrevtext.DELETE;

        IF g_ADDRLocHId IS NULL THEN
            g_ADDRLocHId := pkg_loch.lochid('ADDR');
        END IF;

        IF g_PCODELocHId IS NULL THEN
            g_PCODELocHId := pkg_loch.lochid('PCODE');
        END IF;
        --

    END GetLocationDescriptions;

    FUNCTION GetLocIDAbbrev(iLocID location.locationid%TYPE) RETURN VARCHAR2 IS
        l_LocDescr VARCHAR2(250);
    BEGIN
        IF NOT g_locdescr.abbrevtext.EXISTS(iLocID) THEN
            GetLocationDescriptions(iLocID);
        END IF;
        l_LocDescr := g_locdescr.abbrevtext(iLocID);
        RETURN l_LocDescr;
    END GetLocIDAbbrev;

    FUNCTION GetLocIDDescr(iLocID location.locationid%TYPE) RETURN VARCHAR2 IS
        l_LocDescr VARCHAR2(250);
    BEGIN
        IF NOT g_locdescr.phrase.EXISTS(iLocID) THEN
            GetLocationDescriptions(iLocID);
        END IF;
        l_LocDescr := g_locdescr.phrase(iLocID);
        RETURN l_LocDescr;
    END GetLocIDDescr;

    FUNCTION GetLocationDescr(iLoc VARCHAR2) RETURN VARCHAR2 IS
        l_LocID    location.locationid%TYPE;
        l_LocDescr VARCHAR2(250);
    BEGIN
        IF iLoc IS NOT NULL THEN
            BEGIN
                l_LocID    := iLoc;
                l_LocDescr := GetLocIDDescr(l_LocID);
            EXCEPTION
                WHEN OTHERS THEN
                    l_LocDescr := iLoc;
            END;
        ELSE
            l_LocDescr := NULL;
        END IF;
        RETURN l_LocDescr;
    END GetLocationDescr;

    FUNCTION GetLocationAbbrev(iLoc VARCHAR2) RETURN VARCHAR2 IS
        l_LocID    location.locationid%TYPE;
        l_LocDescr VARCHAR2(250);
    BEGIN
        IF iLoc IS NOT NULL THEN
            BEGIN
                l_LocID    := iLoc;
                l_LocDescr := GetLocIDAbbrev(l_LocID);
            EXCEPTION
                WHEN OTHERS THEN
                    l_LocDescr := iLoc;
            END;
        ELSE
            l_LocDescr := NULL;
        END IF;
        RETURN l_LocDescr;
    END GetLocationAbbrev;
    -- *************************************************************************
    PROCEDURE Init IS
    BEGIN
        --
        --
        g_ADDRLocHId  := pkg_loch.lochid('ADDR');
        g_PCODELocHId := pkg_loch.lochid('PCODE');

        GetTemplateInfo();

        GetAddrPropDetails();

        GetLocationDescriptions();

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN - 20999 AND - 20000 THEN
                -- HUB specific error - let it go
                RAISE;
            ELSE
                pkg_msg.sysmsg('PLSQL'
                              ,0
                              ,REPLACE(SQLERRM
                                      ,'ORA'
                                      ,'ORA.')
                              ,g_me || '.Init()');
            END IF;
    END Init;
    --
    --
    -- *************************************************************************
    -- Create Address Template Member function
    FUNCTION InsertAPKey(iAPKey         IN AddressProperty.APkey%TYPE
                        ,iAPKeyDescr    IN AddressProperty.Descr%TYPE
                        ,iAddrTmplDescr IN AddressTemplate.Descr%TYPE
                        ,iAddrTmplKey   IN AddressTemplate.Addresstemplatekey%TYPE
                        ,iFmtMthd       IN FormatMethod.Fmkey%TYPE
                        ,iFmtMthdDescr  IN FormatMethod.Descr%TYPE
                        ,iAfterAPKey    IN AddressProperty.APkey%TYPE DEFAULT NULL
                        ,iLocnType      IN LocationType.Locationtype%TYPE DEFAULT NULL
                        ,iCountryDescr  IN Dictionary.Phrase%TYPE DEFAULT NULL
                        ,iAPLocHType    IN AddressProperty.LocHType%TYPE DEFAULT NULL
                        ,iAPLocHMbrType IN AddressProperty.LochMbrType%TYPE DEFAULT NULL
                        ,iAPPropertyKey IN AddressProperty.Propertykey%TYPE DEFAULT NULL) RETURN countryap.countryapid%TYPE IS

        --l_dictid      DICTIONARY.DICTID%TYPE ;
        l_addtid       addresstemplate.addresstemplateid%TYPE;
        l_countrylocid location.locationid%TYPE;
        l_capid        countryap.countryapid%TYPE;
        l_cnt          PLS_INTEGER;
        --l_ret         PLS_INTEGER := 0 ;
        l_x   PLS_INTEGER;
        l_seq countryap.countryapid%TYPE;

    BEGIN
        -- Add Address Format Method
        INSERT INTO formatmethod
            (fmkey
            ,descr)
            SELECT iFmtMthd
                  ,iFmtMthdDescr
            FROM   dual
            WHERE  NOT EXISTS (SELECT 0
                    FROM   formatmethod
                    WHERE  fmkey = iFmtMthd);
        writeOut('------------------------------------------');
        IF SQL%ROWCOUNT = 0 THEN
            writeOut('FormatMethod exists-' || iFmtMthd);
        ELSE
            writeOut('NEW FormatMethod-' || iFmtMthd);
        END IF;
        --
        --  Find / create address template
        l_cnt := 0;
        SELECT COUNT(*)
        INTO   l_cnt
        FROM   addresstemplate
        WHERE  descr = iAddrTmplDescr;
        --
        IF l_cnt > 0 THEN
            SELECT MIN(addresstemplateid)
            INTO   l_addtid
            FROM   addresstemplate
            WHERE  descr = iAddrTmplDescr;
            writeOut('Address template exists-' || iAddrTmplDescr);
        ELSE
            INSERT INTO addresstemplate
                (descr
                ,inclcountryflg
                ,fmkey
                ,addresstemplatekey)
            VALUES
                (iAddrTmplDescr
                ,'N'
                ,iFmtMthd
                ,iAddrTmplKey)
            RETURNING addresstemplateid INTO l_addtid;
            writeOut('NEW Address template-' || iAddrTmplKey || ' : ' || iAddrTmplDescr);
        END IF;
        --
        --  Find / create country
        IF iCountryDescr IS NULL THEN
            SELECT propvalchar
            INTO   l_countrylocid
            FROM   systemproperty
            WHERE  propertykey = 'MAILFROMCNTRY';
        ELSE
            l_cnt := 0;
            LOOP
                l_cnt := l_cnt + 1;
                IF l_cnt > 2 THEN
                    raise_application_error(-20999
                                           ,'Failed to find / create country ' || iCountryDescr);
                END IF;
                BEGIN
                    SELECT locationid
                    INTO   l_CountryLocId
                    FROM   location   a
                          ,DICTIONARY b
                    WHERE  a.locationtype = 'CNTRY'
                    AND    a.descrdictid = b.dictid
                    AND    b.phrasesearch = pkg_util.fix_upc(iCountryDescr)
                    AND    EXISTS (SELECT locationid
                            FROM   lochmbr           c
                                  ,locationhierarchy d
                            WHERE  d.lochtype = 'ADDR'
                            AND    c.lochid = d.lochid
                            AND    c.lochmbrtype = 'CNTRY'
                            AND    c.locationid = a.locationid);
                    --
                    EXIT;
                    --
                EXCEPTION
                    WHEN no_data_found THEN
                        SELECT psid
                        INTO   pkg_prop.g_psid
                        FROM   locationtype
                        WHERE  locationtype = 'CNTRY';
                        --
                        --  Create the country location
                        l_x := pkg_loch.InsertLocation(iCountryDescr
                                                      ,'CNTRY');
                        --
                        --  Create the country location location hierarchy entry
                        INSERT INTO lochmbr
                            (locationid
                            ,lochid
                            ,lochmbrtype
                            ,psid
                            ,parentlochmbrid)
                            SELECT l_x
                                  ,a.lochid
                                  ,'CNTRY'
                                  ,b.psid
                                  ,NULL
                            FROM   locationhierarchy a
                                  ,lochtypehmbrtype  b
                            WHERE  a.lochtype = 'ADDR'
                            AND    b.lochmbrtype = 'CNTRY';
                END;
            END LOOP;
        END IF;
        --
        --  Link address template with country
        INSERT INTO countrytemplate
            (locationid
            ,addresstemplateid)
            SELECT l_countrylocid
                  ,l_addtid
            FROM   dual
            WHERE  NOT EXISTS (SELECT 0
                    FROM   countrytemplate
                    WHERE  addresstemplateid = l_addtid);
        --
        IF SQL%ROWCOUNT = 0 THEN
            writeOut('Address template ' || iAddrTmplDescr || ' is already linked with ' || iCountryDescr);
        END IF;
        --
        --
        --  Validate location type
        --  The location type is used to display a combo box in the
        --  address maint. control hence it should exist and have at
        --  least one value associated with it.
        IF iLocnType IS NOT NULL THEN
            BEGIN
                SELECT 0
                INTO   l_x
                FROM   locationtype
                WHERE  locationtype = iLocnType;
            EXCEPTION
                WHEN no_data_found THEN
                    raise_application_error(-20999
                                           ,'ERROR Location type does''t exist-' || iLocnType);
            END;
        END IF;
        --
        --  Add address property definition
        INSERT INTO addressproperty
            (apkey
            ,descr
            ,lochtype
            ,lochmbrtype
            ,propertykey)
            SELECT iapkey
                  ,iapkeydescr
                  ,iaplochtype
                  ,iaplochmbrtype
                  ,iAPPropertyKey
            FROM   dual
            WHERE  NOT EXISTS (SELECT 0
                    FROM   addressproperty
                    WHERE  apkey = iapkey);
        --
        IF SQL%ROWCOUNT = 0 THEN
            writeOut('Address property exists-' || iapkey || ' ' || iapkeydescr);
        ELSE
            writeOut('NEW Address property ' || iapkey || ' ' || iapkeydescr);
        END IF;
        --
        --
        --  Add address property to address template
        --  Is it already there ?
        BEGIN
            SELECT countryapid
            INTO   l_capid
            FROM   countryap
            WHERE  addresstemplateid = l_addtid
            AND    apkey = iapkey;
        EXCEPTION
            WHEN no_data_found THEN
                NULL;
        END;
        --
        IF l_capid IS NULL THEN
            --  Work out the sequence to be assigned to the
            --  property in the countryap table
            IF iAfterAPKey IS NULL THEN
                l_seq := 1;
            ELSE
                BEGIN
                    SELECT seq + 1
                    INTO   l_seq
                    FROM   countryap
                    WHERE  apkey = iAfterAPKey
                    AND    addresstemplateid = l_addtid;
                EXCEPTION
                    WHEN no_data_found THEN
                        l_seq := 1;
                END;
            END IF;
            --  Is the new sequence available ?
            BEGIN
                l_x := NULL;
                SELECT 1
                INTO   l_x
                FROM   countryap
                WHERE  addresstemplateid = l_addtid
                AND    seq = l_seq;
                --  Found an existing row therefore need to resequence
                l_x := l_seq;
                FOR rec IN (SELECT apkey
                                  ,ROWID
                            FROM   countryap
                            WHERE  addresstemplateid = l_addtid
                            AND    seq >= l_seq
                            ORDER  BY seq) LOOP
                    l_x := l_x + 1;
                    UPDATE countryap
                    SET    seq = l_x
                    WHERE  ROWID = rec.ROWID;
                END LOOP;
                --
            EXCEPTION
                WHEN no_data_found THEN
                    NULL;
            END;
            --
            INSERT INTO countryap
                (addresstemplateid
                ,locationtype
                ,apkey
                ,descr
                ,seq
                ,requiredflg)
            VALUES
                (l_addtid
                ,iLocnType
                ,iapkey
                ,iapkeydescr
                ,l_seq
                ,'N')
            RETURNING countryapid INTO l_capid;
        END IF;
        --
        RETURN l_capid;
        --
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN - 20999 AND - 20000 THEN
                -- HUB specific error - let it go
                RAISE;
            ELSE
                pkg_msg.sysmsg('PLSQL'
                              ,0
                              ,REPLACE(SQLERRM
                                      ,'ORA'
                                      ,'ORA.')
                              ,g_me || '.insertapkeys(''' || iAPKey || ''',''' || g_nl || iAPKeyDescr || ''',''' || g_nl ||
                               iAddrTmplDescr || ''',''' || g_nl || iFmtMthd || ''',''' || g_nl || iFmtMthdDescr || ''',''' || g_nl ||
                               iAfterAPKey || ''',''' || g_nl || iLocnType || ''',''' || g_nl || iCountryDescr || ''',''' || g_nl ||
                               iAPLocHType || ''',''' || g_nl || iAPLocHMbrType || ''')');
            END IF;
    END InsertAPKey;
    --
    --
    --*************************************************************************
    PROCEDURE RefreshAPKeys(iAddressTemplateId IN addresstemplate.addresstemplateid%TYPE DEFAULT NULL
                           ,iDescr             IN addresstemplate.descr%TYPE DEFAULT NULL) IS
        --
        l_addresstemplateid addresstemplate.addresstemplateid%TYPE;
        l_addrtmpldescr     addresstemplate.descr%TYPE;
        l_delcnt            PLS_INTEGER := 0;
        l_addcnt            PLS_INTEGER := 0;
        --
        xDone EXCEPTION;
        --
    BEGIN
        --
        writeOut('--');
        writeOut('-- REFRESHAPKeys --');
        IF iAddressTemplateId IS NOT NULL THEN
            l_addresstemplateid := iAddressTemplateId;
            writeOut('AddressTemplateId = ' || iAddressTemplateId);
            BEGIN
                SELECT descr
                INTO   l_addrtmpldescr
                FROM   addresstemplate
                WHERE  addresstemplateid = iAddressTemplateId;
                writeOut('Descr            = ' || l_addrtmpldescr);
            EXCEPTION
                WHEN no_data_found THEN
                    NULL;
            END;
        ELSIF iDescr IS NOT NULL THEN
            l_addrtmpldescr := iDescr;
            writeOut('Descr        = ' || idescr);
            BEGIN
                SELECT addresstemplateid
                INTO   l_addresstemplateid
                FROM   addresstemplate
                WHERE  descr = iDescr;
                writeOut('AddressTemplateId    = ' || l_AddressTemplateId);
            EXCEPTION
                WHEN no_data_found THEN
                    NULL;
            END;
        ELSE
            writeOut('Nothing to do.');
            RAISE xDone;
        END IF;
        --
        IF l_addresstemplateid IS NULL
           OR l_addrtmpldescr IS NULL THEN
            writeOut('Can''t find address template details.');
            RAISE xDone;
        END IF;
        --
        DELETE FROM addresspropertyval a
        WHERE  a.addressid IN (SELECT p.addressid
                               FROM   address p
                               WHERE  p.addresstemplateid = l_addresstemplateid)
        AND    a.countryapid IN (SELECT q.countryapid
                                 FROM   addresspropertyval q
                                 WHERE  q.addressid = a.addressid
                                 AND    NOT EXISTS (SELECT r.countryapid
                                         FROM   countryap r
                                         WHERE  r.addresstemplateid = l_addresstemplateid));
        l_delcnt := SQL%ROWCOUNT;
        writeOut('Address rows deleted = ' || l_delcnt);
        --
        INSERT INTO addresspropertyval
            (addressid
            ,countryapid)
            SELECT addressid
                  ,countryapid
            FROM   address   b
                  ,countryap c
            WHERE  b.Addresstemplateid = l_addresstemplateid
            AND    c.Addresstemplateid = l_addresstemplateid
            AND    NOT EXISTS (SELECT 1
                    FROM   addresspropertyval q
                    WHERE  q.addressid = b.addressid
                    AND    q.countryapid = c.countryapid);
        --
        l_addcnt := SQL%ROWCOUNT;
        writeOut('Address rows added   = ' || l_addcnt);
        --
    EXCEPTION
        WHEN xDone THEN
            NULL;
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN - 20999 AND - 20000 THEN
                -- HUB specific error - let it go
                RAISE;
            ELSE
                pkg_msg.sysmsg('PLSQL'
                              ,0
                              ,REPLACE(SQLERRM
                                      ,'ORA'
                                      ,'ORA.')
                              ,g_me || '.RefreshAPKeys(' || iAddressTemplateId || ',''' || iDescr || ''')');
            END IF;
    END RefreshAPKeys;
    --
    --
    --*************************************************************************
    PROCEDURE AddrLochmbrLocation(iCountryAPId       IN countryap.countryapid%TYPE
                                 ,iAddressLocationId IN addresspropertyval.addressid%TYPE
                                 ,oLocationId        OUT addresspropertyval.locationid%TYPE
                                 ,oLocationDescr     OUT dictionary.phrase%TYPE) IS
        --
        l_LocationId     addresspropertyval.locationid%TYPE;
        l_leaflocationid addresspropertyval.locationid%TYPE;
        l_LocationDescr  dictionary.phrase%TYPE;
        l_tolochid       locationhierarchy.lochid%TYPE;
        --l_x                PLS_INTEGER ;
        --
    BEGIN
        --
        --  Cached result from last call.  The proc. will be called
        --  twice for each countryapid to get locationid and description
        IF iCountryAPId = g_ALMLVars.CountryAPId
           AND iAddressLocationId = g_ALMLVars.AddrLocationId THEN
            oLocationId    := g_ALMLVars.LocationId;
            oLocationDescr := g_ALMLVars.LocationDescr;
            --
        ELSE

            IF g_cap.countryapid.COUNT = 0
               OR NOT g_cap.countryapid.EXISTS(iCountryAPId) THEN
                --
                --  Load address country ap info.
                GetAddrPropDetails(iCountryAPId);

            END IF;
            --
            -- If this APKEY has a link to the lochmbr table then get more info.
            IF g_cap.lochtype(iCountryAPId) IS NOT NULL THEN
                --
                --  If looking for a value from a 'linked' locationhieararchy
                --  we have to determine the locationid that is linked to
                --  the base address locationid.  This new id is the starting
                --  point for getting a value from the linked branch
                l_leaflocationid := iAddressLocationId;
                l_tolochid       := g_ADDRLocHId;
                IF g_cap.lochtype(iCountryAPId) <> 'ADDR' THEN
                    IF g_cap.lochtype(iCountryAPId) = 'PCODE' THEN
                        l_tolochid := g_PCODELocHId;
                    ELSE
                        l_tolochid := pkg_loch.lochid(g_cap.lochtype(iCountryAPId));
                    END IF;
                    --
                    l_leaflocationid := pkg_loch.linkedlocn(g_ADDRLocHId
                                                           ,iAddressLocationId
                                                           ,l_tolochid
                                                           ,'Y');
                    --
                END IF;
                pkg_loch.AddrLochmbrLocation(l_tolochid
                                            ,l_leaflocationid
                                            ,g_cap.lochmbrtype(iCountryAPId)
                                            ,g_cap.propertykey(iCountryAPId)
                                            ,1
                                            ,l_LocationId
                                            ,l_LocationDescr);
                --
                g_ALMLVars.CountryAPId    := iCountryAPId;
                g_ALMLVars.AddrLocationId := iAddressLocationId;
                g_ALMLVars.LocationId     := l_LocationId;
                oLocationId               := l_LocationId;
                g_ALMLVars.LocationDescr  := l_LocationDescr;
                oLocationDescr            := l_LocationDescr;
                --
            END IF;
        END IF;
        --
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN - 20999 AND - 20000 THEN
                -- HUB specific error - let it go
                RAISE;
            ELSE
                pkg_msg.sysmsg('PLSQL'
                              ,0
                              ,REPLACE(SQLERRM
                                      ,'ORA'
                                      ,'ORA.')
                              ,g_me || '.AddrLochmbrLocation(' || iCountryAPId || ',' || iAddressLocationId || ''')');
            END IF;

    END AddrLochmbrLocation;
    --
    --
    --*************************************************************************
    FUNCTION LochmbrLocationId(iCountryAPId       IN countryap.countryapid%TYPE
                              ,iAddressLocationId IN addresspropertyval.addressid%TYPE) RETURN location.locationid%TYPE IS
        --
        l_LocationId    addresspropertyval.locationid%TYPE;
        l_LocationDescr dictionary.phrase%TYPE;
        --
    BEGIN
        --
        -- raise_application_error (-20099 ,'Id CAPID='||iCountryAPId||'  ,AddressLocnId='||iAddressLocationId) ;
        AddrLochmbrLocation(iCountryAPId
                           ,iAddressLocationId
                           ,l_LocationId
                           ,l_LocationDescr);
        --    IF iCountryAPId = 413 THEN
        --      raise_application_error (-20099 ,'Id CAPID='||iCountryAPId||'  ,AddressLocnId='||iAddressLocationId||'  ,descr='||
        --    END IF ;
        --
        RETURN l_LocationId;
        --
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN - 20999 AND - 20000 THEN
                -- HUB specific error - let it go
                RAISE;
            ELSE
                pkg_msg.sysmsg('PLSQL'
                              ,0
                              ,REPLACE(SQLERRM
                                      ,'ORA'
                                      ,'ORA.')
                              ,g_me || '.LochmbrLocationId(' || iCountryAPId || ',' || iAddressLocationId || ''')');
            END IF;
            --
    END LochmbrLocationId;
    --
    --
    --*************************************************************************
    FUNCTION LochmbrLocationDescr(iCountryAPId       IN countryap.countryapid%TYPE
                                 ,iAddressLocationId IN addresspropertyval.addressid%TYPE) RETURN dictionary.phrase%TYPE IS
        --
        l_LocationId    addresspropertyval.locationid%TYPE;
        l_LocationDescr dictionary.phrase%TYPE;
        --
    BEGIN
        --
        -- raise_application_error (-20099 ,'Descr CAPID='||iCountryAPId||'  ,AddressLocnId='||iAddressLocationId) ;
        AddrLochmbrLocation(iCountryAPId
                           ,iAddressLocationId
                           ,l_LocationId
                           ,l_LocationDescr);
        --
        --    IF iCountryAPId = 413 THEN
        --      raise_application_error (-20099 ,'Id CAPID='||iCountryAPId||'  ,AddressLocnId='||iAddressLocationId||'  ,descr='||l_LocationDescr) ;
        --    END IF ;
        --
        RETURN l_LocationDescr;
        --
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN - 20999 AND - 20000 THEN
                -- HUB specific error - let it go
                RAISE;
            ELSE
                pkg_msg.sysmsg('PLSQL'
                              ,0
                              ,REPLACE(SQLERRM
                                      ,'ORA'
                                      ,'ORA.')
                              ,g_me || '.LochmbrLocationDescr(' || iCountryAPId || ',' || iAddressLocationId || ''')');
            END IF;
            --
    END LochmbrLocationDescr;
    --
    --
    --*************************************************************************
    PROCEDURE GetAddrId(iAction             IN VARCHAR2
                       ,iAddressTemplateKey IN addresstemplate.addresstemplatekey%TYPE
                       ,iAPKey              IN pkg_std.takey
                       ,iPropValChar        IN pkg_std.tadescr
                       ,oAddressId          OUT Address.AddressId%TYPE) IS
        --
        --  Addresses maintained via this entrypoint are presumed to be valid
        l_Sub_Premises        addresspropertyval.propvalchar%TYPE;
        l_Premises_Number     addresspropertyval.propvalchar%TYPE;
        l_Premises_Name       addresspropertyval.propvalchar%TYPE;
        l_Building_Group_Name addresspropertyval.propvalchar%TYPE;
        l_Thoroughfare        addresspropertyval.propvalchar%TYPE;
        l_Dep_Thoroughfare    addresspropertyval.propvalchar%TYPE;
        l_Dep_Locality        addresspropertyval.propvalchar%TYPE;
        l_Doub_Dep_Locality   addresspropertyval.propvalchar%TYPE;
        l_Post_Town           addresspropertyval.propvalchar%TYPE;
        l_PO_Box              addresspropertyval.propvalchar%TYPE;
        l_County              addresspropertyval.propvalchar%TYPE;
        l_Country             addresspropertyval.propvalchar%TYPE;
        l_PostCode            addresspropertyval.propvalchar%TYPE;
        l_PostCode_Trim       addresspropertyval.propvalchar%TYPE;
        l_LocationDescription addresspropertyval.propvalchar%TYPE;
        l_DPID                addresspropertyval.propvalchar%TYPE := NULL;
        l_DPID_CountryAPID    addresspropertyval.countryapid%TYPE ;
        l_checkExists         Address.AddressId%TYPE;
        l_S111                addresspropertyval.propvalchar%TYPE;
        l_S112                addresspropertyval.propvalchar%TYPE;
        l_S113                addresspropertyval.propvalchar%TYPE;
        l_L21                 addresspropertyval.propvalchar%TYPE;
        l_L12                 addresspropertyval.propvalchar%TYPE;
        l_X11                 addresspropertyval.propvalchar%TYPE;
        l_C11                 addresspropertyval.propvalchar%TYPE;

        l_house_no_char       CHAR(01);
        l_house_no1_flg       BOOLEAN := TRUE;
        l_temp                VARCHAR2(200);
        l_temp_chr            CHAR(01);
        l_house_no1           VARCHAR2(100) := g_flddlm;
        l_house_no1_sfx       VARCHAR2(100) := g_flddlm;
        l_house_no2           VARCHAR2(100) := g_flddlm;
        l_house_no2_sfx       VARCHAR2(100) := g_flddlm;
        l_pobox_pfx           VARCHAR2(100) := g_flddlm;
        l_pobox               VARCHAR2(100) := g_flddlm;
        l_pobox_sfx           VARCHAR2(100) := g_flddlm;
        l_lotno               VARCHAR2(100) := g_flddlm;
        l_premnm              VARCHAR2(100) := g_flddlm;
        l_premnm2             VARCHAR2(100) := g_flddlm;
        l_flatunittype        VARCHAR2(100) := g_flddlm;
        l_flatunitno          VARCHAR2(100) := g_flddlm;
        l_flrlvltype          VARCHAR2(100) := g_flddlm;
        l_flrlvlno            VARCHAR2(100) := g_flddlm;
        l_strnm1              VARCHAR2(100) := g_flddlm;
        l_strtyp1             VARCHAR2(100) := g_flddlm;
        l_strsfx1             VARCHAR2(100) := g_flddlm;
        l_strnm2              VARCHAR2(100) := g_flddlm;
        l_strtyp2             VARCHAR2(100) := g_flddlm;
        l_strsfx2             VARCHAR2(100) := g_flddlm;
        l_addrline1           VARCHAR2(100) := g_flddlm;
        l_addrline2           VARCHAR2(100) := g_flddlm;
        l_addrline3           VARCHAR2(100) := g_flddlm;
        l_err_key_info        VARCHAR2(4000);
        l_idx                 PLS_INTEGER := 0;
        l_adtTempID           countryap.addresstemplateid%TYPE;
        l_AddressTemplateKey  addresstemplate.addresstemplatekey%TYPE;
        --
    BEGIN
        --
        IF g_adt.addresstemplatekey.COUNT = 0 THEN
            --  Load address country ap info.
            GetTemplateInfo();
        END IF;
        --
        -- Check to see if a templatekey or templateid is passed in.
        BEGIN
            l_adtTempID := iAddressTemplateKey;
            IF g_adt.addresstemplatekey.EXISTS(l_adtTempID) THEN
                l_AddressTemplateKey := g_adt.addresstemplatekey(l_adtTempID);
            ELSE
                pkg_msg.sysmsg(g_msgkey
                              ,2
                              ,l_adtTempID);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Address template id is not a number.  Assume it is character.
                l_AddressTemplateKey := iAddressTemplateKey;
        END;
        --  Determine the AddressTemplateId
        IF g_GetAddrId_TmplId IS NULL
           OR (g_GetAddrId_TmplId IS NOT NULL AND g_adt.addresstemplatekey(g_GetAddrId_TmplId) <> l_AddressTemplateKey) THEN
            --
            g_GetAddrId_TmplId := NULL;
            l_idx              := g_adt.addresstemplatekey.FIRST;
            WHILE l_idx IS NOT NULL LOOP
                IF g_adt.addresstemplatekey(l_idx) = l_AddressTemplateKey THEN
                    g_GetAddrId_TmplId := l_idx;
                    EXIT;
                END IF;
                l_idx := g_adt.addresstemplatekey.NEXT(l_idx);
            END LOOP;
            --
        END IF;
        IF g_GetAddrId_TmplId IS NULL THEN
            --  Can't find address template id for template [?]
            pkg_msg.sysmsg(g_msgkey
                          ,2
                          ,l_AddressTemplateKey);
        END IF;

        writeout('Template: ' || l_AddressTemplateKey);
        FOR i IN 1 .. ipropvalchar.COUNT LOOP
            writeout('Key=' || iAPKey(i) || ', PropValChar(' || i || ')=' || ipropvalchar(i));
            IF iAPKey(i) = 'S111' THEN
               l_S111 := ipropvalchar(i);
            ELSIF iAPKey(i) = 'S112' THEN
               l_S112 := ipropvalchar(i);
            ELSIF iAPKey(i) = 'S113' THEN
               l_S113 := ipropvalchar(i);
            ELSIF iAPKey(i) = 'L21' THEN
               l_L21 := ipropvalchar(i);
            ELSIF iAPKey(i) = 'L12' THEN
               l_L12 := ipropvalchar(i);
            ELSIF iAPKey(i) = 'X11' THEN
               l_X11 := ipropvalchar(i);
            ELSIF iAPKey(i) = 'C11' THEN
               l_C11 := ipropvalchar(i);
            END IF;
        END LOOP;
        BEGIN
        select a.locationid INTO l_checkExists
          from vw_location_street a,
               (select locationid
                  from location
                 where locationtype = 'STRTP'
                   and descrdictid in (select dictid
                                         from dictionarytext
                                        where abbrevtext = l_S112)
               ) b,
               (select locationid
                  from location
                 where locationtype = 'STRSF'
                   and descrdictid in (select dictid
                                         from dictionarytext
                                        where abbrevtext = l_S113)
               ) c
         where lower(trim(a.subpc))  = lower(trim(l_C11)) || ' ' || lower(trim(l_L21))
           and lower(trim(a.state))  = lower(trim(l_L12))
           and lower(trim(a.street)) = lower(trim(l_S111))
           and a.strtp  = b.locationid
           and a.strsfx = c.locationid;
        EXCEPTION
           WHEN OTHERS THEN
              l_checkExists := -1;
        END;

        --IF l_checkExists <> -1 THEN
        --   RETURN;
        --END IF;

        --
        --  Format the data for input to pkg_pqa.getaddr
        IF l_AddressTemplateKey = 'QASEnergy01' THEN
            --
            l_idx           := 1;
            l_Premises_Name := ipropvalchar(01) || g_flddlm --    l_Buildingname1         || g_flddlm
                               || ipropvalchar(02) || g_flddlm; -- || l_Buildingname2         || g_flddlm
            --
            l_idx          := 3;
            l_flatunittype := GetLocationAbbrev(ipropvalchar(3));
            l_flrlvltype   := GetLocationAbbrev(ipropvalchar(5));

            l_Sub_Premises := l_flatunittype || g_flddlm --    l_flatType    || g_flddlm
                              || ipropvalchar(04) || g_flddlm -- || l_flatNumber  || g_flddlm
                              || l_flrlvltype || g_flddlm -- || l_FloorType   || g_flddlm
                              || ipropvalchar(06) || g_flddlm; -- || l_FloorNumber || g_flddlm
            --
            --  The following presumes the house no. format is n(n)a-n(n)a
            --  ie  12b
            --      172
            --      31-41
            --      1a-3c
            l_idx           := 7;
            l_temp          := upper(ipropvalchar(07));
            l_house_no1     := NULL;
            l_house_no1_sfx := NULL;
            l_house_no2     := NULL;
            l_house_no2_sfx := NULL;
            IF l_temp IS NOT NULL THEN
                FOR I IN 1 .. length(l_temp) LOOP
                    l_house_no_char := substr(l_temp
                                             ,i
                                             ,1);
                    IF l_house_no1_flg THEN
                        IF l_house_no_char BETWEEN '0' AND '9' THEN
                            l_house_no1 := l_house_no1 || l_house_no_char;
                        ELSIF l_house_no_char BETWEEN 'A' AND 'Z' THEN
                            l_house_no1_sfx := l_house_no_char;
                        ELSE
                            l_house_no1_flg := FALSE;
                        END IF;
                    ELSE
                        IF l_house_no_char BETWEEN '0' AND '9' THEN
                            l_house_no2 := l_house_no2 || l_house_no_char;
                        ELSIF l_house_no_char BETWEEN 'A' AND 'Z' THEN
                            l_house_no2_sfx := l_house_no_char;
                        ELSE
                            NULL; -- !!
                        END IF;
                    END IF;
                END LOOP;
            END IF;
            --
            l_idx             := 8;
            l_Premises_Number := l_house_no1 || g_flddlm --    l_Housenumberfrom       || g_flddlm
                                 || l_house_no1_sfx || g_flddlm -- || l_HouseNumberFromSuffix || g_flddlm
                                 || l_house_no2 || g_flddlm -- || l_HouseNumberTo         || g_flddlm
                                 || l_house_no2_sfx || g_flddlm -- || l_Housenumbertosuffix   || g_flddlm
                                 || ipropvalchar(08) || g_flddlm; -- || l_LotNumber || g_flddlm
            --

            l_idx              := 9;
            l_Dep_Thoroughfare := GetLocationAbbrev(ipropvalchar(09)); -- Postal delivery type  -- WR37720

            --
            l_idx       := 10;
            l_temp      := upper(ipropvalchar(10));
            l_pobox     := NULL;
            l_pobox_pfx := NULL;
            l_pobox_sfx := NULL;
            IF l_temp IS NOT NULL THEN
                FOR I IN 1 .. length(l_temp) LOOP
                    l_temp_chr := substr(l_temp
                                        ,i
                                        ,1);
                    IF l_temp_chr BETWEEN 'A' AND 'Z' THEN
                        IF l_pobox IS NULL THEN
                            l_pobox_pfx := l_pobox_pfx || l_temp_chr;
                        ELSE
                            l_pobox_sfx := l_pobox_sfx || l_temp_chr;
                        END IF;
                    ELSE
                        IF l_pobox_sfx IS NULL THEN
                            l_pobox := l_pobox || l_temp_chr;
                        ELSE
                            l_pobox_sfx := l_pobox_sfx || l_temp_chr;
                        END IF;
                    END IF;
                END LOOP;
            END IF;
            l_PO_Box := l_pobox_pfx || g_flddlm -- Postal delivery prefix
                        || l_pobox || g_flddlm -- Postal delivery no.
                        || l_pobox_sfx || g_flddlm; -- Postal delivery suffix
            --
            l_idx     := 11;
            l_strtyp1 := GetLocationAbbrev(ipropvalchar(12));

            l_Thoroughfare := ipropvalchar(11) || g_flddlm --    l_Streetname1   || g_flddlm
                              || l_strtyp1 || g_flddlm -- || l_Streettype1   || g_flddlm
                              || GetLocationAbbrev(ipropvalchar(13)) || g_flddlm -- || l_Streetsuffix1 || g_flddlm   -- WR37720
                              || g_flddlm --    l_Streetname2
                              || g_flddlm --    l_Streettype2
                              || g_flddlm; --    l_Streetsuffix2
            --                                                       -- || l_Streetname2   || g_flddlm
            --                                                       -- || l_Streettype2   || g_flddlm
            --                                                       -- || l_Streetsuffix2 || g_flddlm
            l_idx                 := 14;
            l_Post_Town           := ipropvalchar(14); --    l_Siteaddresscity
            l_idx                 := 15;
            l_County              := GetLocationDescr(ipropvalchar(15)); --    l_Statefulltext
            l_idx                 := 16;
            l_Country             := GetLocationDescr(ipropvalchar(16)); --    l_Country
            l_idx                 := 17;
            l_PostCode            := ipropvalchar(17); --    l_Siteaddresspostcode
            l_idx                 := 18;
            l_Doub_Dep_Locality   := ipropvalchar(18); --    l_SiteAddressDPID
            l_DPID                := ipropvalchar(18) ;              --    L_SiteDPID
            l_idx                 := 19;
            l_Building_Group_Name := ipropvalchar(19); --    barcode
            --
            l_Dep_Locality        := NULL;
            l_LocationDescription := NULL; --    l_Locationdescriptor
            --
        ELSIF l_AddressTemplateKey IN ('AUS_INPUT_STRUCTURED_FUH', 'AUS_INPUT_STRUCTURED_PD', 'AUS_INPUT_STRUCTURED_ALL',
               'AUS_INPUT_STRUCTURED_ASEXML', 'AUS_INPUT_UNSTRUCTURED_ASEXML') THEN
            --
            FOR i IN 1 .. iAPKey.COUNT LOOP
                l_idx := i;
                --
                IF iAPKey(i) = 'FUT' THEN
                    --
                    -- Flat Type could numeric of string.
                    -- If numeric, a location id is assumed.

                    l_flatunittype := GetLocationAbbrev(ipropvalchar(i)) || g_flddlm;

                ELSIF iAPKey(i) = 'SPREM' THEN
                    l_flatunitno := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'FLT' THEN
                    -- Floor Level Type could numeric of string.
                    -- If numeric, a location id is assumed.
                    l_flrlvltype := GetLocationAbbrev(ipropvalchar(i)) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'FLRLVL' THEN
                    l_flrlvlno := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'PREMNO' THEN
                    l_house_no1 := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'PREMSFX' THEN
                    l_house_no1_sfx := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'PREMNO2' THEN
                    l_house_no2 := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'PREMSFX2' THEN
                    l_house_no2_sfx := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'LOTNO' THEN
                    l_lotno := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'PREMNM' THEN
                    l_Premnm := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'PREMNM2' THEN
                    l_Premnm2 := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'LOCHMSTRNM' THEN
                    l_strnm1 := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'LOCHMSTRTP' THEN
                    -- First check if a location id is passed down.  It will
                    -- be numeric if it is.
                    l_strtyp1 := GetLocationAbbrev(ipropvalchar(i)) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'LOCHMSTRSFX' THEN
                    l_strsfx1 := GetLocationAbbrev(ipropvalchar(i)) || g_flddlm;               -- WR37720
                    --                    --
                ELSIF iAPKey(i) = 'LOCHMSTRNM' THEN
                    -- This will never be execurted.  Already trapped above.
                    l_strnm2 := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'LOCHMSTRTP' THEN
                    -- This will never be execurted.  Already trapped above.
                    l_strtyp2 := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'LOCHMSTRSFX' THEN
                    -- This will never be execurted.  Already trapped above.
                    l_strsfx2 := GetLocationAbbrev(ipropvalchar(i)) || g_flddlm;               -- WR37720
                    --
                ELSIF iAPKey(i) = 'POBOXTY' THEN
                    l_Dep_Thoroughfare := GetLocationAbbrev(ipropvalchar(i));                  -- WR37720
                    --
                ELSIF iAPKey(i) = 'POBOXP' THEN
                    l_POBox_pfx := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'POBOX' THEN
                    l_POBox := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'POBOXS' THEN
                    l_POBox_sfx := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'ADDRESSLINE' THEN
                    l_addrline1 := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'ADDRESSLINE2' THEN
                    l_addrline2 := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'ADDRESSLINE3' THEN
                    l_addrline3 := ipropvalchar(i) || g_flddlm;
                    --
                ELSIF iAPKey(i) = 'LOCHMSUB' THEN
                    l_Post_Town := ipropvalchar(i); -- l_Siteaddresscity
                    --
                ELSIF iAPKey(i) = 'LOCHMSTATE' THEN
                    -- l_Statefulltext
                    -- First check if a location id is passed down.  It will
                    -- be numeric if it is.
                    l_County := GetLocationDescr(ipropvalchar(i));
                    --
                ELSIF iAPKey(i) = 'LOCHMCNTRY' THEN
                    l_Country := ipropvalchar(i); -- l_Country
                    --
                ELSIF iAPKey(i) = 'LOCHMPCODE' THEN
                    l_PostCode := ipropvalchar(i); -- l_Siteaddresspostcode
                    --
                ELSIF iAPKey(i) = 'DPID' THEN
                   l_DPID := ipropvalchar(i) ;  -- l_SiteaddressDeliveryPointID
                --

                END IF;
                --
            END LOOP;
            --
            IF l_country IS NULL THEN
                l_Country := g_adt.phrase(g_GetAddrId_TmplId); -- l_Country
            END IF;
            --
            l_Sub_Premises        := l_flatunittype || l_flatunitno || l_flrlvltype || l_flrlvlno;
            l_Premises_Number     := l_house_no1 || l_house_no1_sfx || l_house_no2 || l_house_no2_sfx || l_lotno;
            l_Premises_Name       := l_premnm || l_premnm2;
            l_Thoroughfare        := l_strnm1 || l_strtyp1 || l_strsfx1 || l_strnm2 || l_strtyp2 || l_strsfx2;
            l_PO_Box              := l_pobox_pfx || l_pobox || l_pobox_sfx;
            l_Dep_Locality        := l_addrline1 || l_addrline2 || l_addrline3;
            l_LocationDescription := NULL;
            --
        ELSE
            raise_application_error(-20000
                                   ,'Unknown address template key-' || l_AddressTemplateKey);
        END IF;
        --

        l_idx := -2;

        ----- WR9415
        DECLARE
            length_flat_number PLS_INTEGER;
            str_flat_number    VARCHAR(100);

            length_lotno PLS_INTEGER;

            length_building_name1 PLS_INTEGER;
            length_building_name2 PLS_INTEGER;

            str_house_no1    VARCHAR2(100);
            str_house_no2    VARCHAR2(100);
            length_house_no1 PLS_INTEGER;
            length_house_no2 PLS_INTEGER;

            str_house_suffix1    VARCHAR2(100);
            str_house_suffix2    VARCHAR2(100);
            length_house_suffix1 PLS_INTEGER;
            length_house_suffix2 PLS_INTEGER;

            length_street_name PLS_INTEGER;
            str_street_name    VARCHAR2(100);

            length_post_code PLS_INTEGER;
            str_post_code    VARCHAR2(100);

            --length_postal_delivery_number NUMBER(3);
            --str_postal_delivery_number    VARCHAR(100);
        BEGIN
            IF l_Doub_Dep_Locality IS NULL THEN
                l_idx := -3;
                -- Flat/Unit Number must not exceed 7 characters
                length_flat_number := LENGTH(LTRIM(RTRIM(l_flatunitno))) - 1;
                str_flat_number    := SUBSTR(LTRIM(RTRIM(TO_CHAR(l_flatunitno)))
                                            ,1
                                            ,length_flat_number);

                FOR i IN 1 .. length_flat_number LOOP
                    IF UPPER(SUBSTR(str_flat_number
                                   ,i
                                   ,1)) IN ('#'
                                           ,'%'
                                           ,'&') THEN
                        pkg_msg.sysmsg(g_msgkey
                                      ,17
                                      ,str_flat_number);
                    END IF;
                END LOOP;

                IF length_flat_number > 7 THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,14);
                END IF;

                l_idx := -4;

                -- Building name must not exceed 30 charachters
                length_building_name1 := LENGTH(LTRIM(RTRIM(ipropvalchar(01))));
                length_building_name2 := LENGTH(LTRIM(RTRIM(ipropvalchar(02))));
                IF length_building_name1 > 30 THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,9
                                  ,ipropvalchar(01));
                END IF;

                IF length_building_name2 > 30 THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,9
                                  ,ipropvalchar(02));
                END IF;

                l_idx := -5;

                -- Lot Number must not exceed 6 charachters
                length_lotno := LENGTH(LTRIM(RTRIM(l_lotno))) - 1;
                IF length_lotno > 6 THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,8
                                  ,length_lotno);
                END IF;

                l_idx := -6;

                -- House Number must be positive integer, no more than 5 digit long
                str_house_no1 := LTRIM(RTRIM(l_house_no1));
                str_house_no2 := LTRIM(RTRIM(l_house_no2));

                length_house_no1 := LENGTH(str_house_no1) - 1;
                length_house_no2 := LENGTH(str_house_no2) - 1;

                str_house_no1 := SUBSTR(str_house_no1
                                       ,1
                                       ,length_house_no1);
                str_house_no2 := SUBSTR(str_house_no2
                                       ,1
                                       ,length_house_no2);

                IF length_house_no1 > 0 THEN
                    FOR i IN 1 .. length_house_no1 LOOP
                        IF SUBSTR(str_house_no1
                                 ,i
                                 ,1) NOT IN ('0'
                                            ,'1'
                                            ,'2'
                                            ,'3'
                                            ,'4'
                                            ,'5'
                                            ,'6'
                                            ,'7'
                                            ,'8'
                                            ,'9') THEN
                            pkg_msg.sysmsg(g_msgkey
                                          ,11
                                          ,str_house_no1);
                        END IF;
                    END LOOP;
                END IF;

                IF length_house_no2 > 0 THEN
                    FOR i IN 1 .. length_house_no2 LOOP
                        IF SUBSTR(str_house_no2
                                 ,i
                                 ,1) NOT IN ('0'
                                            ,'1'
                                            ,'2'
                                            ,'3'
                                            ,'4'
                                            ,'5'
                                            ,'6'
                                            ,'7'
                                            ,'8'
                                            ,'9') THEN
                            pkg_msg.sysmsg(g_msgkey
                                          ,11
                                          ,str_house_no2);
                        END IF;
                    END LOOP;
                END IF;

                IF length_house_no1 > 5
                   OR length_house_no2 > 5 THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,10);
                END IF;

                l_idx := -7;

                -- House Suffix must be alphanumeric, no more than 1 digit long

                str_house_suffix1 := LTRIM(RTRIM(l_house_no1_sfx));
                str_house_suffix2 := LTRIM(RTRIM(l_house_no2_sfx));

                length_house_suffix1 := LENGTH(str_house_suffix1) - 1;
                length_house_suffix2 := LENGTH(str_house_suffix2) - 1;

                str_house_suffix1 := SUBSTR(str_house_suffix1
                                           ,1
                                           ,length_house_suffix1);
                str_house_suffix2 := SUBSTR(str_house_suffix2
                                           ,1
                                           ,length_house_suffix2);

                IF length_house_suffix1 > 1
                   OR length_house_suffix2 > 1 THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,12);
                END IF;

                IF UPPER(str_house_suffix1) NOT IN ('A'
                                                   ,'B'
                                                   ,'C'
                                                   ,'D'
                                                   ,'E'
                                                   ,'F'
                                                   ,'G'
                                                   ,'H'
                                                   ,'I'
                                                   ,'J'
                                                   ,'K'
                                                   ,'L'
                                                   ,'M'
                                                   ,'N'
                                                   ,'O'
                                                   ,'P'
                                                   ,'Q'
                                                   ,'R'
                                                   ,'S'
                                                   ,'T'
                                                   ,'U'
                                                   ,'V'
                                                   ,'W'
                                                   ,'X'
                                                   ,'Y'
                                                   ,'Z'
                                                   ,'1'
                                                   ,'2'
                                                   ,'3'
                                                   ,'4'
                                                   ,'5'
                                                   ,'6'
                                                   ,'7'
                                                   ,'8'
                                                   ,'9'
                                                   ,'0') THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,13
                                  ,str_house_suffix1);
                END IF;

                IF UPPER(str_house_suffix2) NOT IN ('A'
                                                   ,'B'
                                                   ,'C'
                                                   ,'D'
                                                   ,'E'
                                                   ,'F'
                                                   ,'G'
                                                   ,'H'
                                                   ,'I'
                                                   ,'J'
                                                   ,'K'
                                                   ,'L'
                                                   ,'M'
                                                   ,'N'
                                                   ,'O'
                                                   ,'P'
                                                   ,'Q'
                                                   ,'R'
                                                   ,'S'
                                                   ,'T'
                                                   ,'U'
                                                   ,'V'
                                                   ,'W'
                                                   ,'X'
                                                   ,'Y'
                                                   ,'Z'
                                                   ,'1'
                                                   ,'2'
                                                   ,'3'
                                                   ,'4'
                                                   ,'5'
                                                   ,'6'
                                                   ,'7'
                                                   ,'8'
                                                   ,'9'
                                                   ,'0') THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,13
                                  ,str_house_suffix2);
                END IF;

                l_idx := -8;

                -- Street Name must be alphanumeric (plus \n,\r,\t, '-', ' ',apostrophe)
                -- no more than 30 characters long
                length_street_name := LENGTH((LTRIM(RTRIM(l_strnm1)))) - 1;
                str_street_name    := SUBSTR(LTRIM(RTRIM(TO_CHAR(l_strnm1)))
                                            ,1
                                            ,length_street_name);

                FOR i IN 1 .. length_street_name LOOP
                    IF UPPER(SUBSTR(str_street_name
                                   ,i
                                   ,1)) NOT IN ('A'
                                               ,'B'
                                               ,'C'
                                               ,'D'
                                               ,'E'
                                               ,'F'
                                               ,'G'
                                               ,'H'
                                               ,'I'
                                               ,'J'
                                               ,'K'
                                               ,'L'
                                               ,'M'
                                               ,'N'
                                               ,'O'
                                               ,'P'
                                               ,'Q'
                                               ,'R'
                                               ,'S'
                                               ,'T'
                                               ,'U'
                                               ,'V'
                                               ,'W'
                                               ,'X'
                                               ,'Y'
                                               ,'Z'
                                               ,'1'
                                               ,'2'
                                               ,'3'
                                               ,'4'
                                               ,'5'
                                               ,'6'
                                               ,'7'
                                               ,'8'
                                               ,'9'
                                               ,'0'
                                               ,'-'
                                               ,' '
                                               ,''''
                                               ,CHR(10)
                                               ,CHR(13)
                                               ,CHR(9)) THEN
                        pkg_msg.sysmsg(g_msgkey
                                      ,16
                                      ,str_street_name);
                    END IF;
                END LOOP;

                IF length_street_name > 30 THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,15);
                END IF;

                l_idx := -9;

                -- Post Code must be positive integer, 4 digits long
                str_post_code    := LTRIM(RTRIM(l_postcode));
                length_post_code := LENGTH(str_post_code);
                str_post_code    := SUBSTR(str_post_code
                                          ,1
                                          ,length_post_code);

                IF length_post_code > 0 THEN
                    FOR i IN 1 .. length_post_code LOOP
                        IF SUBSTR(str_post_code
                                 ,i
                                 ,1) NOT IN ('0'
                                            ,'1'
                                            ,'2'
                                            ,'3'
                                            ,'4'
                                            ,'5'
                                            ,'6'
                                            ,'7'
                                            ,'8'
                                            ,'9') THEN
                            pkg_msg.sysmsg(g_msgkey
                                          ,18
                                          ,str_post_code);
                        END IF;
                    END LOOP;
                END IF;

                IF length_post_code != 4 THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,18
                                  ,str_post_code);
                END IF;
                l_PostCode_Trim := str_post_code;

            END IF; -- IS NULL
        END; ----- end of WR9415

        l_idx := -1;
            --
    -- IF DeliveryPointID supplied
    -- Quick Check to see if DPID already exists in the Database
    --
    IF l_DPID IS NOT NULL THEN
        -- Find the correct CountryAPID
        FOR Arec IN (SELECT COUNTRYAPID from countryap
                     WHERE  APKEY=k_DPID) LOOP
             l_DPID_CountryAPID:=arec.CountryAPID;
        END LOOP;
        -- Obtain the latest
        FOR Arec in (SELECT ADDRESSID
                      FROM ADDRESSPROPERTYVAL ap
                      WHERE ap.countryapid = l_DPID_CountryAPID
                      AND   ap.propvalchar = l_DPID
                      ORDER by ADDRESSID desc
                      ) loop
            --
            -- If you've got here then an Address with a Matching DPID
            -- Already exists so use that one instead of creating a New one.
            --
            oAddressID:=arec.addressid;
            -- Skip Out
            RAISE x_DPID_Already_Exists;
        END LOOP;
        --
    END IF;
    --
    IF l_checkExists = -1 THEN
        oAddressId := pkg_pqa.GetAddr(l_Sub_Premises
                                     ,l_Premises_Number
                                     ,l_Premises_Name
                                     ,l_Building_Group_Name
                                     ,l_Thoroughfare
                                     ,l_Dep_Thoroughfare
                                     ,l_Dep_Locality
                                     ,l_Doub_Dep_Locality
                                     ,l_Post_Town
                                     ,l_PO_Box
                                     ,l_County
                                     ,l_Country
                                     ,NVL(l_PostCode_Trim, l_PostCode) --l_PostCode WR139035: use trimmed postcode
                                     ,l_LocationDescription);
    ELSE
        -- SEPI-20136
        oAddressId := l_checkExists;
        BEGIN
            SELECT ADDRESSID INTO l_checkExists FROM AddressPropertyVal WHERE locationID = l_checkExists AND ROWNUM <= 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                oAddressId := pkg_pqa.GetAddr(l_Sub_Premises
                                             ,l_Premises_Number
                                             ,l_Premises_Name
                                             ,l_Building_Group_Name
                                             ,l_Thoroughfare
                                             ,l_Dep_Thoroughfare
                                             ,l_Dep_Locality
                                             ,l_Doub_Dep_Locality
                                             ,l_Post_Town
                                             ,l_PO_Box
                                             ,l_County
                                             ,l_Country
                                             ,NVL(l_PostCode_Trim, l_PostCode) --l_PostCode WR139035: use trimmed postcode
                                             ,l_LocationDescription);
            END;
        RAISE x_DPID_Already_Exists;
    END IF;
        --
    EXCEPTION
        WHEN x_DPID_Already_Exists THEN
        -- Good result, re-using an Address!!  Skip out quietly
            NULL;

        WHEN OTHERS THEN
            IF SQLCODE BETWEEN - 20999 AND - 20000 THEN
                -- HUB specific error - let it go
                writeOut(SQLERRM(SQLCODE));
                RAISE;
            ELSE
                -- Unexpected error !
                l_err_key_info := 'Actn=' || iAction || ',AddrTmplKey=' || l_AddressTemplateKey || ',Idx=' || l_idx ||
                                  ',Addr=SubPremNo=';
                IF l_idx = -1 THEN
                    l_err_key_info := l_err_key_info || l_Sub_Premises || '|PremNo=' || l_Premises_Number || '|PName=' ||
                                      l_Premises_Name || '|BGName=' || l_Building_Group_Name || '|TFare=' || l_Thoroughfare ||
                                      '|DepTFare=' || l_Dep_Thoroughfare || '|DepLoc' || l_Dep_Locality || '|DDepLoc=' ||
                                      l_Doub_Dep_Locality || '|PTown=' || l_Post_Town || '|POBox=' || l_PO_Box || '|County=' ||
                                      l_County || '|Country=' || l_Country || '|PCode=' || l_PostCode || '|LocDesc=' ||
                                      l_LocationDescription;
                ELSE
                    l_err_key_info := l_err_key_info || iAPKey(1) || '=' || ipropvalchar(1);

                    FOR i IN 2 .. iapkey.COUNT LOOP
                        l_err_key_info := l_err_key_info || '|' || iapkey(i) || '=' || ipropvalchar(i);
                    END LOOP;
                END IF;
                writeOut(SQLERRM(SQLCODE));
                writeOut(l_err_key_info);
                pkg_msg.sysmsg('PLSQL'
                              ,0
                              ,substr(REPLACE(SQLERRM
                                             ,'ORA'
                                             ,'ORA.')
                                     ,1
                                     ,180)
                              ,substr(g_me || '.getaddrid[1](''' || l_err_key_info || ''')'
                                     ,1
                                     ,180));
            END IF;
            --
    END GetAddrId;
    --
    --
    --*************************************************************************
    PROCEDURE GetAddrId(iAction            IN VARCHAR2
                       ,iAddressTemplateId IN addresstemplate.addresstemplateid%TYPE
                       ,iCountryAPId       IN pkg_std.tainteger
                       ,iLocationId        IN pkg_std.tainteger
                       ,iPropValChar       IN pkg_std.tadescr
                       ,oAddressId         OUT Address.AddressId%TYPE) IS
        --
        --  Addresses maintained via this entrypoint are validated for completeness
        l_apkey              pkg_std.takey;
        l_pvchar             pkg_std.tadescr;
        l_idx                PLS_INTEGER := 0;
        l_err_key_info       VARCHAR2(1000);
        l_addressTemplateKey addresstemplate.addresstemplatekey%TYPE;
        --
        --  Completeness flags for groups of apkeys
        l_val_flatunit   VARCHAR(02) := 'NN';
        l_val_floorlevel VARCHAR(02) := 'NN';
        l_val_premno     VARCHAR(04) := 'NNNN';
        --    l_val_premno2           VARCHAR(02) := 'NN' ;
        l_val_postal VARCHAR(04) := 'NNNN';
        l_val_street VARCHAR(03) := 'NNN';
        l_val_lotno  VARCHAR(01) := 'N';
        --
        FUNCTION CAP_Descr(iAPKey IN addressproperty.apkey%TYPE) RETURN VARCHAR2 IS
        BEGIN
            -- Find the capid for this apkey from the input and
            -- then get it's description from the global array
            FOR i IN 1 .. l_apkey.COUNT LOOP
                IF l_apkey(i) = iAPKey THEN
                    RETURN g_cap.descr(iCountryAPId(i));
                END IF;
            END LOOP;
            RETURN iAPKey;
        END CAP_Descr;
        --
    BEGIN
        --
        IF g_adt.addresstemplatekey.COUNT = 0 THEN
            --  Load address country ap info.
            GetTemplateInfo;
        END IF;
        --
        --
        --  Get the address template key
        l_addresstemplatekey := g_adt.addresstemplatekey(iAddressTemplateId);
        --
        --  Convert to a structure that pkg_pqa understands
        FOR i IN 1 .. iCountryapid.COUNT LOOP
            --
            IF iCountryapid(i) = 0 THEN
                EXIT;
            END IF;

            -- Check to see if we have had this before.
            -- Add it to the cache then.

            IF NOT g_cap.apkey.EXISTS(icountryAPId(i)) THEN
                GetAddrPropDetails(icountryAPId(i));
            END IF;

            l_idx := i;
            l_apkey(i) := g_cap.apkey(icountryAPId(i));
            --
            IF iLocationId(i) IS NOT NULL THEN
                --  Location types which use abbreviations
                IF g_cap.locationtype(icountryAPId(i)) IN ('FLT'
                                                          ,'FUT'
                                                          ,'PDT'
                                                          ,'STRTP'
                                                          ,'STRSF') THEN
                    -- Have we had this location before?
                    -- If not get it from the cache for reuse.

                    l_pvchar(i) := GetLocIDAbbrev(iLocationId(i));

                ELSE
                    -- Not abbreviated, then use phrase
                    -- WR9034: If we're not using abbreviations but the locationID is set, use the phrase.
                    l_pvchar(i) := GetLocIDDescr(iLocationId(i));
                END IF;
            ELSE
                l_pvchar(i) := iPropValChar(i);
            END IF;
            --
            --  Some validation
            IF l_addressTemplateKey LIKE 'AUS_INPUT%' THEN
                IF l_pvchar(i) IS NULL THEN
                    IF l_APKey(i) IN (k_LOCHMSUB
                                     ,k_LOCHMSTATE
                                     ,k_LOCHMPCODE) THEN
                        --  Suburb / Town / Locality, State / Region, Postal code
                        -- '[?] must be entered'
                        pkg_msg.sysmsg(g_msgkey
                                      ,3
                                      ,cap_descr(l_APKey(i)));
                    END IF;
                ELSE
                    --  Component flags for later completeness checking
                    IF l_apkey(i) = k_FUT THEN
                        l_val_flatunit := 'Y' || substr(l_val_flatunit
                                                       ,2);
                    ELSIF l_apkey(i) = k_SPREM THEN
                        l_val_flatunit := substr(l_val_flatunit
                                                ,1
                                                ,1) || 'Y';
                    ELSIF l_apkey(i) = k_FLT THEN
                        l_val_floorlevel := 'Y' || substr(l_val_floorlevel
                                                         ,2);
                    ELSIF l_apkey(i) = k_FLRLVL THEN
                        l_val_floorlevel := substr(l_val_floorlevel
                                                  ,1
                                                  ,1) || 'Y';
                    ELSIF l_apkey(i) = k_PREMNO THEN
                        l_val_premno := 'Y' || substr(l_val_premno
                                                     ,2);
                    ELSIF l_apkey(i) = k_PREMSFX THEN
                        l_val_premno := substr(l_val_premno
                                              ,1
                                              ,1) || 'Y' || substr(l_val_premno
                                                                  ,3);
                    ELSIF l_apkey(i) = k_PREMNO2 THEN
                        l_val_premno := substr(l_val_premno
                                              ,1
                                              ,2) || 'Y' || substr(l_val_premno
                                                                  ,4);
                    ELSIF l_apkey(i) = k_PREMSFX2 THEN
                        l_val_premno := substr(l_val_premno
                                              ,1
                                              ,3) || 'Y';
                    ELSIF l_apkey(i) = k_LOTNO THEN
                        l_val_lotno := 'Y';
                    ELSIF l_apkey(i) = k_POBOXTY THEN
                        l_val_postal := 'Y' || substr(l_val_postal
                                                     ,2);
                    ELSIF l_apkey(i) = k_POBOXP THEN
                        l_val_postal := substr(l_val_postal
                                              ,1
                                              ,1) || 'Y' || substr(l_val_postal
                                                                  ,3);
                    ELSIF l_apkey(i) = k_POBOX THEN
                        l_val_postal := substr(l_val_postal
                                              ,1
                                              ,2) || 'Y' || substr(l_val_postal
                                                                  ,4);
                    ELSIF l_apkey(i) = k_POBOXS THEN
                        l_val_postal := substr(l_val_postal
                                              ,1
                                              ,3) || 'Y';
                    ELSIF l_APKey(i) = k_LOCHMSTRNM THEN
                        l_val_street := 'Y' || substr(l_val_street
                                                     ,2);
                    ELSIF l_APKey(i) = k_LOCHMSTRTP THEN
                        l_val_street := substr(l_val_street
                                              ,1
                                              ,1) || 'Y' || substr(l_val_street
                                                                  ,3);
                    ELSIF l_APKey(i) = k_LOCHMSTRSFX THEN
                        l_val_street := substr(l_val_street
                                              ,1
                                              ,2) || 'Y';
                    END IF;
                    --
                END IF; -- pvchar(i)
                --
            END IF; -- addresstemplate key like ???
        --
        END LOOP;
        --
        --  Completeness validation
        --  message 4 - [?] and [?] must be enetered together
        --  message 5 - [?] and [?] can't be entered together
        --  message 6 - one of [?] and [?] must be entered
        IF l_addressTemplateKey LIKE 'AUS_INPUT%' THEN
            --  Flat/Unit type and number
            IF l_val_flatunit NOT IN ('NN', 'YY') THEN
                pkg_msg.sysmsg(g_msgkey
                              ,4
                              ,cap_descr(k_FUT)
                              ,cap_descr(k_SPREM));
            END IF;
            --  Floor/Level type and number
            IF l_val_floorlevel NOT IN ('NN', 'YY') THEN
                pkg_msg.sysmsg(g_msgkey
                              ,4
                              ,cap_descr(k_FLT)
                              ,cap_descr(k_FLRLVL));
            END IF;
            --  House no. suffix and house no.
            IF l_val_premno NOT IN ('NNNN', 'YNNN', 'YYNN', 'YNYN', 'YYYY') THEN
                -- suffix must have a no.
                IF substr(l_val_premno
                         ,1
                         ,2) = 'NY'
                   OR substr(l_val_premno
                            ,3
                            ,2) = 'NY' THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,4
                                  ,cap_descr(k_PREMNO)
                                  ,cap_descr(k_PREMSFX));
                END IF;
                -- no. 2 must have no. 1
                IF substr(l_val_premno
                         ,1
                         ,1) <> 'Y'
                   AND substr(l_val_premno
                             ,3
                             ,1) = 'Y' THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,4
                                  ,cap_descr(k_PREMNO2)
                                  ,cap_descr(k_PREMNO));
                END IF;
            END IF;
            --  Flat / Unit and House no.
            IF l_val_flatunit LIKE '%Y%'
               AND NOT l_val_premno LIKE '%Y%' THEN
                pkg_msg.sysmsg(g_msgkey
                              ,4
                              ,cap_descr(k_SPREM)
                              ,cap_descr(k_PREMNO));
            END IF;
            --  Floor / Level and House no.
            IF l_val_floorlevel LIKE '%Y%'
               AND NOT l_val_premno LIKE '%Y%' THEN
                pkg_msg.sysmsg(g_msgkey
                              ,4
                              ,cap_descr(k_FLRLVL)
                              ,cap_descr(k_PREMNO));
            END IF;
            --  Postal delivery prefix/suffix and no.
            IF l_val_postal NOT IN ('NNNN', 'YNYN', 'YYYN', 'YNYY') THEN
                -- postal delivery number and prefix
                IF substr(l_val_postal
                         ,3
                         ,1) <> 'Y'
                   AND substr(l_val_postal
                             ,2
                             ,1) = 'Y' THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,4
                                  ,cap_descr(k_POBOXP)
                                  ,cap_descr(k_POBOX));
                END IF;
                -- postal delivery number and suffix
                IF substr(l_val_postal
                         ,3
                         ,1) <> 'Y'
                   AND substr(l_val_postal
                             ,4
                             ,1) = 'Y' THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,4
                                  ,cap_descr(k_POBOXS)
                                  ,cap_descr(k_POBOX));
                END IF;
                -- postal delivery type and number
                IF substr(l_val_postal
                         ,1
                         ,1) = 'N'
                   OR substr(l_val_postal
                            ,3
                            ,1) = 'N' THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,4
                                  ,cap_descr(k_POBOXTY)
                                  ,cap_descr(k_POBOX));
                END IF;
                --
            END IF;
            --  Street type/suffix and street name
            IF l_val_street NOT IN ('NNN', 'YNN', 'YYN', 'YYY') THEN
                --  street name must be entered with type
                IF substr(l_val_street
                         ,1
                         ,1) <> 'Y'
                   AND substr(l_val_street
                             ,2
                             ,1) = 'Y' THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,4
                                  ,cap_descr(k_LOCHMSTRNM)
                                  ,cap_descr(k_LOCHMSTRTP));
                END IF;
                --  street suffix must be enetered with type
                IF substr(l_val_street
                         ,3
                         ,1) = 'Y'
                   AND substr(l_val_street
                             ,2
                             ,1) <> 'Y' THEN
                    pkg_msg.sysmsg(g_msgkey
                                  ,4
                                  ,cap_descr(k_LOCHMSTRSFX)
                                  ,cap_descr(k_LOCHMSTRTP));
                END IF;
                --
            END IF;
            --  House no. or Lot no. or Postal Delivery
            IF l_val_premno NOT LIKE '%Y%'
               AND l_val_lotno NOT LIKE '%Y%'
               AND l_val_postal NOT LIKE '%Y%' THEN
                pkg_msg.sysmsg(g_msgkey
                              ,6
                              ,cap_descr(k_PREMNO) || ',' || cap_descr(k_LOTNO)
                              ,cap_descr(k_POBOX));
            END IF;
            --  Postal delivery and street
            IF l_val_postal LIKE '%Y%'
               AND l_val_street LIKE '%Y%' THEN
                pkg_msg.sysmsg(g_msgkey
                              ,5
                              ,cap_descr(k_POBOX)
                              ,cap_descr(k_LOCHMSTRNM));
            END IF;
            IF NOT l_val_postal LIKE '%Y%'
               AND NOT l_val_street LIKE '%Y%' THEN
                pkg_msg.sysmsg(g_msgkey
                              ,6
                              ,cap_descr(k_POBOX)
                              ,cap_descr(k_LOCHMSTRNM));
            END IF;
        END IF;
        --

        GetAddrId(iAction
                 ,g_adt.addresstemplatekey(iAddressTemplateId)
                 ,l_APKey
                 ,l_PVChar
                 ,oAddressId);
        --
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN - 20999 AND - 20000 THEN
                -- HUB specific error - let it go
                RAISE;
            ELSE
                -- Unexpected error !
                l_err_key_info := 'Actn=' || iAction || ',AddrTmplId=' || iAddressTemplateId || ',Idx=' || l_idx || ',Addr=' ||
                                  icountryapid(1) || ',' || ilocationid(1) || ',' || ipropvalchar(1);
                --
                FOR i IN 2 .. icountryapid.COUNT LOOP
                    l_err_key_info := l_err_key_info || '|' || icountryapid(i) || ',' || ilocationid(i) || ',' || ipropvalchar(i);
                END LOOP;

                pkg_util.putbuf(l_err_key_info);
                pkg_msg.sysmsg('PLSQL'
                              ,0
                              ,REPLACE(SQLERRM
                                      ,'ORA'
                                      ,'ORA.')
                              ,substr(g_me || '.getaddrid[2](''' || l_err_key_info || ''')'
                                     ,1
                                     ,180));
            END IF;
    END GetAddrId;
    --
    --
    --*************************************************************************
    FUNCTION Barcode(iAddressId IN address.addressid%TYPE) RETURN address.barcode%TYPE IS
        --
        l_barcode address.barcode%TYPE;
        --
    BEGIN
        --
        BEGIN
            SELECT barcode
            INTO   l_barcode
            FROM   address
            WHERE  addressid = iAddressId;
        EXCEPTION
            WHEN no_data_found THEN
                NULL;
        END;
        --
        RETURN l_barcode;
        --
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE BETWEEN - 20999 AND - 20000 THEN
                -- HUB specific error - let it go
                RAISE;
            ELSE
                pkg_msg.sysmsg('PLSQL'
                              ,0
                              ,REPLACE(SQLERRM
                                      ,'ORA'
                                      ,'ORA.')
                              ,g_me || '.Barcode(' || iAddressId || ')');
            END IF;
            --
    END Barcode;
    --
    --
    --*************************************************************************
    FUNCTION AddrMatch(iAddressID1 IN address.addressid%TYPE
                      ,iAddressID2 IN address.addressid%TYPE) RETURN BOOLEAN IS
        --
        l_AddrDtls1 pkg_Loch.AddressVariables;
        l_AddrDtls2 pkg_Loch.AddressVariables;
        --
        x_NotMatched EXCEPTION;
        --
    BEGIN
        --
        l_AddrDtls1 := pkg_Loch.GetAddrDetails(iAddressID1);
        l_AddrDtls2 := pkg_Loch.GetAddrDetails(iAddressID2);
        --
        --  Building Name
        --
        IF (l_AddrDtls1.BuildingName1 IS NOT NULL AND l_AddrDtls2.BuildingName1 IS NULL)
           OR (l_AddrDtls1.BuildingName1 IS NULL AND l_AddrDtls2.BuildingName1 IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.BuildingName1 IS NOT NULL AND l_AddrDtls2.BuildingName1 IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.BuildingName1) != pkg_util.fix_upc(l_AddrDtls2.BuildingName1) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.BuildingName2 IS NOT NULL AND l_AddrDtls2.BuildingName2 IS NULL)
              OR (l_AddrDtls1.BuildingName2 IS NULL AND l_AddrDtls2.BuildingName2 IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.BuildingName2 IS NOT NULL AND l_AddrDtls2.BuildingName2 IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.BuildingName2) != pkg_util.fix_upc(l_AddrDtls2.BuildingName2) THEN
            --
            RAISE x_NotMatched;
            --
            --
            --  Floor/Level Number
            --
        ELSIF (l_AddrDtls1.FloorLevelNo IS NOT NULL AND l_AddrDtls2.FloorLevelNo IS NULL)
              OR (l_AddrDtls1.FloorLevelNo IS NULL AND l_AddrDtls2.FloorLevelNo IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.FloorLevelNo IS NOT NULL AND l_AddrDtls2.FloorLevelNo IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.FloorLevelNo) != pkg_util.fix_upc(l_AddrDtls2.FloorLevelNo) THEN
            --
            RAISE x_NotMatched;
            --
            --  Flat/Unit Number
            --
        ELSIF (l_AddrDtls1.FlatUnitNo IS NOT NULL AND l_AddrDtls2.FlatUnitNo IS NULL)
              OR (l_AddrDtls1.FlatUnitNo IS NULL AND l_AddrDtls2.FlatUnitNo IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.FlatUnitNo IS NOT NULL AND l_AddrDtls2.FlatUnitNo IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.FlatUnitNo) != pkg_util.fix_upc(l_AddrDtls2.FlatUnitNo) THEN
            --
            RAISE x_NotMatched;
            --
            --  House Number
            --
        ELSIF (l_AddrDtls1.HouseNo1 IS NOT NULL AND l_AddrDtls2.HouseNo1 IS NULL)
              OR (l_AddrDtls1.HouseNo1 IS NULL AND l_AddrDtls2.HouseNo1 IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.HouseNo1 IS NOT NULL AND l_AddrDtls2.HouseNo1 IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.HouseNo1) != pkg_util.fix_upc(l_AddrDtls2.HouseNo1) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.HouseNo2 IS NOT NULL AND l_AddrDtls2.HouseNo2 IS NULL)
              OR (l_AddrDtls1.HouseNo2 IS NULL AND l_AddrDtls2.HouseNo2 IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.HouseNo2 IS NOT NULL AND l_AddrDtls2.HouseNo2 IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.HouseNo2) != pkg_util.fix_upc(l_AddrDtls2.HouseNo2) THEN
            --
            RAISE x_NotMatched;
            --
            --  House Number Suffix
            --
        ELSIF (l_AddrDtls1.HouseSfx1 IS NOT NULL AND l_AddrDtls2.HouseSfx1 IS NULL)
              OR (l_AddrDtls1.HouseSfx1 IS NULL AND l_AddrDtls2.HouseSfx1 IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.HouseSfx1 IS NOT NULL AND l_AddrDtls2.HouseSfx1 IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.HouseSfx1) != pkg_util.fix_upc(l_AddrDtls2.HouseSfx1) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.HouseSfx2 IS NOT NULL AND l_AddrDtls2.HouseSfx2 IS NULL)
              OR (l_AddrDtls1.HouseSfx2 IS NULL AND l_AddrDtls2.HouseSfx2 IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.HouseSfx2 IS NOT NULL AND l_AddrDtls2.HouseSfx2 IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.HouseSfx2) != pkg_util.fix_upc(l_AddrDtls2.HouseSfx2) THEN
            --
            RAISE x_NotMatched;
            --
            --  Street Name
            --
        ELSIF (l_AddrDtls1.StreetName1 IS NOT NULL AND l_AddrDtls2.StreetName1 IS NULL)
              OR (l_AddrDtls1.StreetName1 IS NULL AND l_AddrDtls2.StreetName1 IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.StreetName1 IS NOT NULL AND l_AddrDtls2.StreetName1 IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.StreetName1) != pkg_util.fix_upc(l_AddrDtls2.StreetName1) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.StreetName2 IS NOT NULL AND l_AddrDtls2.StreetName2 IS NULL)
              OR (l_AddrDtls1.StreetName2 IS NULL AND l_AddrDtls2.StreetName2 IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.StreetName2 IS NOT NULL AND l_AddrDtls2.StreetName2 IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.StreetName2) != pkg_util.fix_upc(l_AddrDtls2.StreetName2) THEN
            --
            RAISE x_NotMatched;
            --
            --  State
            --
        ELSIF (l_AddrDtls1.State IS NOT NULL AND l_AddrDtls2.State IS NULL)
              OR (l_AddrDtls1.State IS NULL AND l_AddrDtls2.State IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.State IS NOT NULL AND l_AddrDtls2.State IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.State) != pkg_util.fix_upc(l_AddrDtls2.State) THEN
            --
            RAISE x_NotMatched;
            --
            --  Postcode
            --
        ELSIF (l_AddrDtls1.PostCode IS NOT NULL AND l_AddrDtls2.PostCode IS NULL)
              OR (l_AddrDtls1.PostCode IS NULL AND l_AddrDtls2.PostCode IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.PostCode IS NOT NULL AND l_AddrDtls2.PostCode IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.PostCode) != pkg_util.fix_upc(l_AddrDtls2.PostCode) THEN
            --
            RAISE x_NotMatched;
            --
            --  Validate Lot Number if House Number is not provided
            --
        ELSIF (l_AddrDtls1.HouseNo1 IS NULL AND l_AddrDtls1.HouseNo2 IS NULL)
              AND (l_AddrDtls1.LotNo IS NOT NULL AND l_AddrDtls2.LotNo IS NULL)
              OR (l_AddrDtls1.LotNo IS NULL AND l_AddrDtls2.LotNo IS NOT NULL) THEN
            --
            RAISE x_NotMatched;
            --
        ELSIF (l_AddrDtls1.HouseNo1 IS NULL AND l_AddrDtls1.HouseNo2 IS NULL)
              AND (l_AddrDtls1.LotNo IS NOT NULL AND l_AddrDtls2.LotNo IS NOT NULL)
              AND pkg_util.fix_upc(l_AddrDtls1.LotNo) != pkg_util.fix_upc(l_AddrDtls2.LotNo) THEN
            --
            RAISE x_NotMatched;
            --
        END IF;
        --
        --  All matching criteria satisfied
        --
        RETURN TRUE;
        --
    EXCEPTION
        WHEN x_NotMatched THEN
            RETURN FALSE;
            --
    END AddrMatch;
    --
    --
    --*************************************************************************
    FUNCTION AddrMatch2(iAddressID1 IN address.addressid%TYPE
                       ,iAddressID2 IN address.addressid%TYPE) RETURN VARCHAR IS
        --
        l_exptn        varchar2(10);
        l_exptn_msg    varchar2(500);
        l_rec          varchar2(500);
        --
        ----------------------------------------------------------------------------------------
        --
        procedure Compare_Suburb (ivar1        in  varchar2
                                 ,ivar2        in  varchar2
                                 ) as
            --
            l_var1                  varchar2(500);
            l_var2                  varchar2(500);
            --ehl_var3                  varchar2(500);
            --
            g_array1                gen_util.array_t ;
            g_count1                pls_integer;
            --
            g_array2                gen_util.array_t ;
            g_count2                pls_integer;
            --
            --ehl_count                 pls_integer;
            --
            l_found                 pls_integer;
            --
        begin -- Compare_Suburb
            --
            l_var1 := upper(ivar1);
            l_var2 := upper(ivar2);
            --
            gen_util.csv_to_array(l_var1, g_count1, g_array1, ' ');
            gen_util.csv_to_array(l_var2, g_count2, g_array2, ' ');
            --
            l_found := 0;
            --
            --  Check addresses
            --
            for i in 1..g_count1
            loop
                --
                if  instr(l_var2,g_array1(i)) > 0 then
                    l_found := l_found + 1;
                end if;
                --
            end loop;
            --
            --  Same number of suburb components
            --
            if  g_count1 = g_count2 then
                if  l_found = g_count1 then
                    l_rec := l_rec || ' << difference >>';
                else
                    --
                    l_rec   := l_rec || ' << critical difference >>';
                    if  l_exptn_msg is null then
                        l_exptn_msg := 'Critical Address differences found ' || ' ' || 'Suburb';
                    else
                        l_exptn_msg := l_exptn_msg || ' ' || 'Suburb';
                    end if;
                    --
                    if  l_exptn is null then
                        l_exptn := 'YES';
                    end if;
                end if;
            end if;
            --
            --  Site Components > Energy Offer Components
            --
            if  g_count1 > g_count2 then
                if  l_found = g_count2 then
                    l_rec := l_rec || ' << difference >>';
                else
                    --
                    l_rec   := l_rec || ' << critical difference >>';
                    if  l_exptn_msg is null then
                        l_exptn_msg := 'Critical Address differences found ' || ' ' || 'Suburb';
                    else
                        l_exptn_msg := l_exptn_msg || ' ' || 'Suburb';
                    end if;
                    --
                    if  l_exptn is null then
                        l_exptn := 'YES';
                    end if;
                end if;
            end if;
            --
            --  Site Components < Energy Offer Components
            --
            if  g_count1 < g_count2 then
                if  l_found = g_count1 then
                    l_rec := l_rec || ' << difference >>';
                else
                    --
                    l_rec   := l_rec || ' << critical difference >>';
                    if  l_exptn_msg is null then
                        l_exptn_msg := 'Critical Address differences found ' || ' ' || 'Suburb';
                    else
                        l_exptn_msg := l_exptn_msg || ' ' || 'Suburb';
                    end if;
                    --
                    if  l_exptn is null then
                        l_exptn := 'YES';
                    end if;
                end if;
            end if;
            --
        end Compare_Suburb;
        --
        --------------------------------------------------------------------------------------------
        --
        procedure Compare (ivar1        in  varchar2
                          ,ivar2        in  varchar2
                          ,ivar3        in  varchar2
                          ) as
            --
            --ehl_var1              varchar2(500);
            l_var2              varchar2(500);
            l_var3              varchar2(500);
            --
        begin -- Compare
            --
            --  Store inpits
            --
            --ehl_var1 := ivar1;
            l_var2 := ivar2;
            l_var3 := ivar3;
            --
            --  If both null, then do nothing
            --
            l_rec   := rpad(ivar1,16,' ') || rpad(l_var2,50,' ') || rpad(l_var3,50,' ');
            --
            if  l_var2 is null
            and l_var3 is null then
                null;
            else
                --
                --  Replace null values with a space
                --
                l_var2 := nvl(l_var2,' ');
                l_var3 := nvl(l_var3,' ');
                --
                --  Output details
                --
                l_rec   := rpad(ivar1,16,' ') || rpad(l_var2,50,' ') || rpad(l_var3,50,' ');
                --
                --  Difference in values ?
                --
                if  nvl(upper(trim(l_var2)),' ') != nvl(upper(trim(l_var3)),' ') then
                    --
                    --  Check type
                    --
                    if    iVar1 in ('FlatUnitType','StreetType1','StreetType2','DPID') then
                          --
                          l_rec := l_rec || ' << difference >>';
                    elsif iVar1 = 'Suburb' then
                          --
                          Compare_Suburb (l_var2, l_var3);
                    else
                          l_rec        := l_rec || ' << critical difference >>';
                          l_exptn     := 'YES';
                          --
                          if  l_exptn_msg is null then
                              l_exptn_msg := 'Critical Address differences found ' || iVar1;
                          else
                              l_exptn_msg := l_exptn_msg || ' ' || iVar1;
                          end if;
                    end if;
                    --
                end if;
            end if;
            --
        end Compare;
        --
        --------------------------------------------------------------------------------------------
        --
        procedure Address_Compare (ivar1        in  pls_integer
                                  ,ivar2        in  pls_integer
                                  ) is
            --
            l_tmp1              varchar2(100);
            l_tmp2              varchar2(100);
            --
            l_addr1             pkg_loch.AddressVariables;
            l_addr2             pkg_loch.AddressVariables;
            --
        begin -- Address_Compare
            --
            --  Get address templates
            --
            begin
                --
                select at.descr
                into   l_tmp1
                from   address         a
                      ,addresstemplate at
                where  a.addressid         = ivar1
                and    a.addresstemplateid = at.addresstemplateid;
            exception
                when others then
                    l_tmp1 := 'xxx';
            end;
            --
            begin
                --
                select at.descr
                into   l_tmp2
                from   address         a
                      ,addresstemplate at
                where  a.addressid         = ivar2
                and    a.addresstemplateid = at.addresstemplateid;
            exception
                when others then
                    l_tmp2 := 'yyy';
            end;
            --
            --  If the same, do a compare
            --
            if  l_tmp1 = l_tmp2 then
                --
                l_addr1 := pkg_loch.GetAddrDetails(iAddrId => ivar1);
                l_addr2 := pkg_loch.GetAddrDetails(iAddrId => ivar2);
                --
                --Compare ('Address Id'         ,ivar1                      ,ivar2                    );
                Compare ('FlatUnitType'       ,l_addr1.FlatUnitType       ,l_addr2.FlatUnitType     );
                Compare ('FlatUnitNo'         ,l_addr1.FlatUnitNo         ,l_addr2.FlatUnitNo       );
                --
                Compare ('FloorLevelNo'       ,l_addr1.FloorLevelNo       ,l_addr2.FloorLevelNo     );
                --
                if  l_addr1.HouseNo1 is null
                or  l_addr2.HouseNo1 is null then
                    Compare ('LotNo'          ,l_addr1.LotNo              ,l_addr2.LotNo            );
                end if;
                --
                Compare ('HouseNo1'           ,l_addr1.HouseNo1           ,l_addr2.HouseNo1         );
                Compare ('HouseSfx1'          ,l_addr1.HouseSfx1          ,l_addr2.HouseSfx1        );
                Compare ('StreetName1'        ,l_addr1.StreetName1        ,l_addr2.StreetName1      );
                Compare ('StreetType1'        ,l_addr1.StreetType1        ,l_addr2.StreetType1      );
                --
                Compare ('HouseNo2'           ,l_addr1.HouseNo2           ,l_addr2.HouseNo2         );
                Compare ('HouseSfx2'          ,l_addr1.HouseSfx2          ,l_addr2.HouseSfx2        );
                Compare ('StreetName2'        ,l_addr1.StreetName2        ,l_addr2.StreetName2      );
                Compare ('StreetType2'        ,l_addr1.StreetType2        ,l_addr2.StreetType2      );
                --
              /*Compare ('PostalType'         ,l_addr1.PostalType         ,l_addr2.PostalType       );
                Compare ('PostalNumberPfx'    ,l_addr1.PostalNumberPfx    ,l_addr2.PostalNumberPfx  );
                Compare ('PostalNumber'       ,l_addr1.PostalNumber       ,l_addr2.PostalNumber     );
                Compare ('PostalNumberSfx'    ,l_addr1.PostalNumberSfx    ,l_addr2.PostalNumberSfx  );*/
                --
                Compare ('AddressLine'        ,l_addr1.AddressLine        ,l_addr2.AddressLine      );
                Compare ('AddressLine2'       ,l_addr1.AddressLine2       ,l_addr2.AddressLine2     );
                Compare ('AddressLine3'       ,l_addr1.AddressLine3       ,l_addr2.AddressLine3     );
                --
                Compare ('Suburb'             ,l_addr1.Suburb             ,l_addr2.Suburb           );
                Compare ('StateAbbrev'        ,l_addr1.StateAbbrev        ,l_addr2.StateAbbrev      );
                Compare ('PostCode'           ,l_addr1.PostCode           ,l_addr2.PostCode         );
                --
                Compare ('DPID'               ,l_addr1.DPID               ,l_addr2.DPID             );
            else
                --
                l_exptn     := 'YES';
                l_exptn_msg := 'Different address templates or no address found';
            end if;
            --
        end Address_Compare;
        --
        ----------------------------------------------------------------------------------------
        --
    BEGIN
        --
        l_exptn     := null;
        l_exptn_msg := null;
        --
        Address_Compare(iAddressID1,iAddressID2);
        --
        if  l_exptn = 'YES' then
            RETURN l_exptn_msg;
        end if;
        --
        RETURN NULL;
        --
    END AddrMatch2;
    -- WR10700 - Unstructured Address Comparasion
    --
    PROCEDURE LoadStripTable(oTblStrp OUT taStrip) AS
        --
        CURSOR cGetStripValue IS
            SELECT code
            FROM   domaincode dc
            WHERE  dc.domainkey = 'UADSTR';
        Idx PLS_INTEGER := 0;
        --
    BEGIN
        oTblStrp.DELETE;
        FOR Strip IN cGetStripValue LOOP
            idx := idx + 1;
            oTblStrp(idx) := Strip.Code;
        END LOOP;

    END LoadStripTable;
    --
    FUNCTION ReplaceMultiSpaces(iString IN VARCHAR2) RETURN VARCHAR2 IS
        lSingleSpaceCommaPos PLS_INTEGER := 0;
        lMultiSpacePos       PLS_INTEGER := 0;
        oString              VARCHAR2(1000) := iString;
        tmpString            VARCHAR2(1000);
        tmp1String           VARCHAR2(1000);
        xFinished EXCEPTION;
    BEGIN
        tmpString := TRIM(iString);
        LOOP
            lMultiSpacePos := INSTR(tmpString
                                   ,'  ');
            IF lMultiSpacePos = 0
               OR lMultiSpacePos IS NULL
               OR lMultiSpacePos > length(iString) THEN
                RAISE xFinished;
            END IF;
            tmpString := TRIM(REPLACE(tmpString
                                     ,'  '
                                     ,' '));
        END LOOP;
        --
    EXCEPTION
        WHEN xFinished THEN
            lSingleSpaceCommaPos := INSTR(tmpString
                                         ,' ,');
            IF lSingleSpaceCommaPos > 0
               AND lSingleSpaceCommaPos <= length(tmpString) THEN
                tmp1String := tmpString;
                tmpString  := REPLACE(tmp1String
                                     ,' ,'
                                     ,',');
            END IF;
            oString := TRIM(tmpString);
            RETURN oString;
        WHEN OTHERS THEN
            raise_application_error(-20998
                                   ,'pkg_addr.ReplaceMultiSpace failed' || SQLCODE || SQLERRM);

    END ReplaceMultiSpaces;

    --
    FUNCTION StripTagFromAddressString(iString IN VARCHAR2
                                      ,iStrip  IN VARCHAR2
                                      ,iAction IN VARCHAR2) RETURN VARCHAR2 IS
        CURSOR DeleteValueFlag(iStrip IN VARCHAR2) IS
            SELECT Substr(dc.descr
                         ,1
                         ,1)
            FROM   domaincode dc
            WHERE  dc.domainkey = 'UADSTR'
            AND    dc.code = iStrip;

        oString      VARCHAR2(1000);
        PartString   VARCHAR2(1000) := NULL;
        RestString   VARCHAR2(1000) := iString;
        TempString   VARCHAR2(1000);
        ActiveString VARCHAR2(1000);
        lAddressLen  PLS_INTEGER;
        lPosI        PLS_INTEGER;
        lShift       PLS_INTEGER;
        lPos         PLS_INTEGER;
        lTestChar    CHAR(1);
        lTestFlag    CHAR(1);
        lDoReplace   BOOLEAN;
        xFinished EXCEPTION;
        l1     PLS_INTEGER;
        l2     PLS_INTEGER;
        l3     PLS_INTEGER;
        lFound BOOLEAN := FALSE;
        TYPE NullTable IS TABLE OF CHAR(1) INDEX BY PLS_INTEGER;
        lNulltable nulltable;
    BEGIN
        --
        lAddressLen := Length(iString);
        lNullTable(1) := ' ';
        --
        FOR l1 IN 1 .. lAddressLen LOOP
            lPos       := Instr(RestString
                               ,iStrip
                               ,1
                               ,1);
            lDoReplace := FALSE;
            IF lPos = 0 THEN
                RAISE xFinished;
            END IF;
            lPosI     := lPos + length(iStrip); -- Position of lTestChar
            lTestChar := SUBSTR(UPPER(RestString)
                               ,lPosI
                               ,1);
            --
            IF lPosI - 1 > length(RestString) THEN
                RAISE xFinished;
            END IF;
            IF lTestChar = ' '
               OR (lTestChar >= '1' AND lTestChar <= '9') THEN
                -- Strip Required !
                --
                lDoReplace := TRUE;
                IF iAction = 'STRIP_TAG' THEN
                    ActiveString := REPLACE(SUBSTR(RestString
                                                  ,1
                                                  ,lPosI - 1)
                                           ,iStrip
                                           ,NULL);
                    lShift       := lPosI;
                ELSIF iAction = 'STRIP_TAG_VALUE' THEN
                    ActiveString := REPLACE(SUBSTR(RestString
                                                  ,1
                                                  ,lPosI)
                                           ,iStrip
                                           ,NULL);
                    lShift       := lPosI;
                    OPEN DeleteValueFlag(iStrip);
                    FETCH DeleteValueFlag
                        INTO lTestFlag;
                    CLOSE DeleteValueFlag;

                    IF lTestFlag = '#' THEN

                        IF lTestChar = ' ' THEN
                            lFound := FALSE;
                            FOR l2 IN lPosI .. lAddressLen LOOP
                                IF SUBSTR(RestString
                                         ,l2
                                         ,1) <> ' ' THEN
                                    FOR l3 IN l2 .. lAddressLen LOOP
                                        IF SUBSTR(RestString
                                                 ,l3
                                                 ,1) = ' ' THEN
                                            lFound       := TRUE;
                                            lShift       := l3;
                                            ActiveString := REPLACE(SUBSTR(RestString
                                                                          ,1
                                                                          ,lPosI)
                                                                   ,iStrip
                                                                   ,NULL);
                                            EXIT;
                                        END IF;
                                    END LOOP;
                                    IF lFound THEN
                                        EXIT;
                                    END IF;
                                END IF;
                            END LOOP;

                        ELSIF lTestChar >= '1'
                              AND lTestChar <= '9' THEN
                            FOR l2 IN lPosI .. lAddressLen LOOP
                                IF SUBSTR(RestString
                                         ,l2
                                         ,1) = ' ' THEN
                                    lShift       := l2;
                                    ActiveString := REPLACE(SUBSTR(RestString
                                                                  ,1
                                                                  ,lPosI - 1)
                                                           ,iStrip
                                                           ,NULL);
                                    EXIT;
                                END IF;
                            END LOOP;
                        END IF;
                    ELSE
                        ActiveString := REPLACE(SUBSTR(RestString
                                                      ,1
                                                      ,lPosI)
                                               ,iStrip
                                               ,NULL);
                    END IF;
                END IF;

            ELSE
                lDoReplace   := FALSE;
                ActiveString := SUBSTR(RestString
                                      ,1
                                      ,lPosI);
                lShift       := lPosI + 1;

            END IF;

            TempString := SUBSTR(RestString
                                ,lShift
                                ,length(RestString));
            RestString := TempString;
            PartString := PartString || ActiveString;

            IF length(RestString) = 0
               OR RestString = ' '
               OR RestString IS NULL
               OR PartString = iString THEN
                RAISE xFinished;
            END IF;

        END LOOP;
    EXCEPTION
        WHEN xFinished THEN
            oString := PartString || RestString;
            RETURN oString;
        WHEN OTHERS THEN
            raise_application_error(-20998
                                   ,'pkg_addr.StripTagFromAddressString failed' || SQLCODE || SQLERRM);

    END StripTagFromAddressString;
    --
    PROCEDURE GetStreetType(iString       IN VARCHAR2
                           ,oStreetType   OUT VARCHAR2
                           ,oNewStringEnd OUT PLS_INTEGER) AS
        l1  PLS_INTEGER;
        l2  PLS_INTEGER;
        ind PLS_INTEGER;
    BEGIN
        l2 := length(iString);
        FOR ind IN REVERSE 1 .. l2 LOOP
            l1 := ind;
            IF SUBSTR(iString
                     ,ind
                     ,1) = ' ' THEN
                EXIT;
            END IF;
        END LOOP;
        l1 := l1 + 1;
        IF l1 > 0
           AND l2 > l1 THEN
            oStreetType   := SUBSTR(iString
                                   ,l1
                                   ,l2);
            oNewStringEnd := l2 - 2;
        END IF;
        --


    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20998
                                   ,'pkg_addr.GetStreetType failed' || SQLCODE || SQLERRM);

    END GetStreetType;
    --
    FUNCTION CompareAdrresses(lEnteredAddress IN VARCHAR2
                             ,lMarketAddress  IN VARCHAR2
                             ,lTblStrp1       IN taStrip
                             ,lAction         IN VARCHAR2) RETURN PLS_INTEGER IS

        CURSOR ChkStreetType(iStreetType IN VARCHAR2) IS
            SELECT COUNT(*)
            FROM   dictionarytext
            WHERE  langcode = 'ENG'
            AND    abbrevtext = iStreetType;

        oReturnCode         PLS_INTEGER;
        tmp1_EnteredAddress VARCHAR2(1000);
        tmp1_MarketAddress  VARCHAR2(1000);
        tmp2_EntredAddress  VARCHAR2(1000);
        tmp2_MarketAddress  VARCHAR2(1000);
        tmp3_EntredAddress  VARCHAR2(1000);
        tmp3_MarketAddress  VARCHAR2(1000);
        lStrp               VARCHAR2(10);
        l11                 PLS_INTEGER := 0;
        l21                 PLS_INTEGER := 0;
        ind                 PLS_INTEGER;
        xFinished EXCEPTION;
        lStreetType1 VARCHAR2(30) := NULL;
        nStreetType1 PLS_INTEGER := 0;
        lStreetType2 VARCHAR2(30) := NULL;
        nStreetType2 PLS_INTEGER := 0;
        --lPos                 PLS_INTEGER          ;

        PROCEDURE DoStrip AS
        BEGIN
            IF lAction = 'STRIP_TAG'
               OR lAction = 'STRIP_TAG_VALUE' THEN
                FOR ind IN lTblStrp1.FIRST .. lTblStrp1.LAST LOOP
                    lStrp              := REPLACE(lTblStrp1(ind)
                                                 ,' '
                                                 ,NULL);
                    tmp3_EntredAddress := StripTagFromAddressString(UPPER(tmp1_EnteredAddress)
                                                                   ,lStrp
                                                                   ,lAction);
                    tmp3_MarketAddress := StripTagFromAddressString(UPPER(tmp1_MarketAddress)
                                                                   ,lStrp
                                                                   ,lAction);

                    --tmp2_EntredAddress := REPLACE (tmp3_EntredAddress , ' ',NULL) ;
                    --tmp2_MarketAddress := REPLACE (tmp3_MarketAddress , ' ',NULL) ;

                    tmp2_EntredAddress := ReplaceMultiSpaces(tmp3_EntredAddress);
                    tmp2_MarketAddress := ReplaceMultiSpaces(tmp3_MarketAddress);

                    IF TRIM(tmp2_EntredAddress) = TRIM(tmp2_MarketAddress) THEN
                        oReturnCode := pkg_k.rc_ok;
                        RAISE xFinished;
                    END IF;
                    tmp1_EnteredAddress := tmp3_EntredAddress;
                    tmp1_MarketAddress  := tmp3_MarketAddress;
                END LOOP;

            ELSIF lAction = 'STRIP_TAG_VALUE_MIX' THEN
                FOR ind IN lTblStrp1.FIRST .. lTblStrp1.LAST LOOP
                    lStrp              := REPLACE(lTblStrp1(ind)
                                                 ,' '
                                                 ,NULL);
                    tmp3_EntredAddress := StripTagFromAddressString(UPPER(tmp1_EnteredAddress)
                                                                   ,lStrp
                                                                   ,'STRIP_TAG');
                    tmp3_MarketAddress := StripTagFromAddressString(UPPER(tmp1_MarketAddress)
                                                                   ,lStrp
                                                                   ,'STRIP_TAG_VALUE');

                    --tmp2_EntredAddress := REPLACE (tmp3_EntredAddress , ' ',NULL) ;
                    --tmp2_MarketAddress := REPLACE (tmp3_MarketAddress, ' ',NULL);
                    tmp2_EntredAddress := ReplaceMultiSpaces(tmp3_EntredAddress);
                    tmp2_MarketAddress := ReplaceMultiSpaces(tmp3_MarketAddress);
                    IF TRIM(tmp2_EntredAddress) = TRIM(tmp2_MarketAddress) THEN
                        oReturnCode := pkg_k.rc_ok;
                        RAISE xFinished;
                    END IF;
                    tmp1_EnteredAddress := tmp3_EntredAddress;
                    tmp1_MarketAddress  := tmp3_MarketAddress;
                END LOOP;

                FOR ind IN lTblStrp1.FIRST .. lTblStrp1.LAST LOOP
                    lStrp              := REPLACE(lTblStrp1(ind)
                                                 ,' '
                                                 ,NULL);
                    tmp3_EntredAddress := StripTagFromAddressString(UPPER(tmp1_EnteredAddress)
                                                                   ,lStrp
                                                                   ,'STRIP_TAG_VALUE');
                    tmp3_MarketAddress := StripTagFromAddressString(UPPER(tmp1_MarketAddress)
                                                                   ,lStrp
                                                                   ,'STRIP_TAG');

                    --tmp2_EntredAddress := REPLACE (tmp3_EntredAddress , ' ',NULL) ;
                    --tmp2_MarketAddress := REPLACE (tmp3_MarketAddress, ' ',NULL);
                    tmp2_EntredAddress := ReplaceMultiSpaces(tmp3_EntredAddress);
                    tmp2_MarketAddress := ReplaceMultiSpaces(tmp3_MarketAddress);
                    IF TRIM(tmp2_EntredAddress) = TRIM(tmp2_MarketAddress) THEN
                        oReturnCode := pkg_k.rc_ok;
                        RAISE xFinished;
                    END IF;
                    tmp1_EnteredAddress := tmp3_EntredAddress;
                    tmp1_MarketAddress  := tmp3_MarketAddress;
                END LOOP;

            END IF;
        END DoStrip;
        ---
        ---
    BEGIN
        --
        -- Strip all possible tags and match
        --
        tmp1_EnteredAddress := lEnteredAddress;
        tmp1_MarketAddress  := lMarketAddress;
        DoStrip;

        --
        -- Make Attempt to stip Street Type
        --
        GetStreetType(iString       => lEnteredAddress
                     ,oStreetType   => lStreetType1
                     ,oNewStringEnd => l11);
        GetStreetType(iString       => lMarketAddress
                     ,oStreetType   => lStreetType2
                     ,oNewStringEnd => l21);

        OPEN ChkStreetType(lStreetType1);
        FETCH ChkStreetType
            INTO nStreetType1;
        CLOSE ChkStreetType;

        OPEN ChkStreetType(lStreetType2);
        FETCH ChkStreetType
            INTO nStreetType2;
        CLOSE ChkStreetType;

        IF lStreetType1 <> lStreetType2
           AND lStreetType1 IS NOT NULL
           AND lStreetType2 IS NOT NULL
           AND nStreetType1 = 1
           AND nStreetType2 = 1 THEN
            tmp1_EnteredAddress := Substr(lEnteredAddress
                                         ,1
                                         ,l11);
            tmp1_MarketAddress  := Substr(lMarketAddress
                                         ,1
                                         ,l21);
            DoStrip;
        END IF;

        oReturnCode := pkg_k.rc_error;
        RETURN oReturnCode;
    EXCEPTION
        WHEN xFinished THEN
            RETURN oReturnCode;
        WHEN OTHERS THEN
            raise_application_error(-20998
                                   ,'pkg_addr.CompareAdrresses failed' || SQLCODE || SQLERRM);

    END CompareAdrresses;


    FUNCTION UnstructAddressCompare(iEntred_Address IN VARCHAR2
                                   ,iMarket_Address IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        IF UnstructAddressComp(NVL(UPPER(iEntred_Address),'x'),NVL(UPPER(iMarket_Address),'y')) = pkg_k.RC_OK THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END;
    --
    FUNCTION UnstructAddressComp(iEntred_Address IN VARCHAR2
                                ,iMarket_Address IN VARCHAR2) RETURN PLS_INTEGER IS

        oReturnCode         PLS_INTEGER;
        RC_ERROR            PLS_INTEGER := pkg_k.rc_error;
        tmp1_EnteredAddress VARCHAR2(1000);
        tmp1_MarketAddress  VARCHAR2(1000);
        tmp2_EntredAddress  VARCHAR2(1000);
        tmp2_MarketAddress  VARCHAR2(1000);
        PostCode1           VARCHAR2(10);
        PostCode2           VARCHAR2(10);
        lTblStrp            taStrip;
        xFinished EXCEPTION;

    BEGIN

        tmp1_EnteredAddress := REPLACE(iEntred_Address
                                      ,',');
        tmp1_MarketAddress  := REPLACE(iMarket_Address
                                      ,',');
        --
        -- Stage 1: Strip commas,remove spaces and compare
        --
        IF tmp1_EnteredAddress = tmp1_MarketAddress THEN
            oReturnCode := pkg_k.rc_ok;
            RAISE xFinished;
        ELSE
            --tmp2_EntredAddress := REPLACE (tmp1_EnteredAddress, ' ',NULL) ;
            --tmp2_MarketAddress := REPLACE (tmp1_MarketAddress, ' ',NULL) ;
            tmp2_EntredAddress := ReplaceMultiSpaces(tmp1_EnteredAddress);
            tmp2_MarketAddress := ReplaceMultiSpaces(tmp1_MarketAddress);
            IF TRIM(tmp2_EntredAddress) = TRIM(tmp2_MarketAddress) THEN
                oReturnCode := pkg_k.rc_ok;
                RAISE xFinished;
            END IF;
        END IF;
        --
        -- Stage 2: Strip Suburb /State Code / Post code.
        --          If Post Codes are matching, strip literals :House/Flat/Unit/Lot/etc
        --
        PostCode1 := SUBSTR(tmp1_EnteredAddress
                           ,length(tmp1_EnteredAddress) - 3
                           ,4);
        PostCode2 := SUBSTR(tmp1_MarketAddress
                           ,length(tmp1_MarketAddress) - 3
                           ,4);
        IF PostCode1 = Postcode2 THEN
            --
            -- If Post codes have been validated OK, we will check Flat/House/Street Part of Address (cut Suburb and State)
            --
            tmp1_EnteredAddress := SUBSTR(iEntred_Address
                                         ,1
                                         ,instr(iEntred_Address
                                               ,','
                                               ,1
                                               ,1) - 1);
            tmp1_MarketAddress  := SUBSTR(iMarket_Address
                                         ,1
                                         ,instr(iMarket_Address
                                               ,','
                                               ,1
                                               ,1) - 1);

            IF TRIM(tmp1_EnteredAddress) = TRIM(tmp1_MarketAddress) THEN
                oReturnCode := pkg_k.rc_ok;
                RAISE xFinished;
            END IF;

            LoadStripTable(oTblStrp => lTblStrp);
            oReturnCode := CompareAdrresses(lEnteredAddress => tmp1_EnteredAddress
                                           ,lMarketAddress  => tmp1_MarketAddress
                                           ,lTblStrp1       => lTblStrp
                                           ,lAction         => 'STRIP_TAG');
            IF oReturnCode = pkg_k.rc_ok THEN
                RAISE xFinished;
            ELSE
                tmp1_EnteredAddress := SUBSTR(iEntred_Address
                                             ,1
                                             ,instr(iEntred_Address
                                                   ,','
                                                   ,1
                                                   ,1) - 1);
                tmp1_MarketAddress  := SUBSTR(iMarket_Address
                                             ,1
                                             ,instr(iMarket_Address
                                                   ,','
                                                   ,1
                                                   ,1) - 1);
                oReturnCode         := CompareAdrresses(lEnteredAddress => tmp1_EnteredAddress -- Next attempt. Try to strip Lot Number
                                                       ,lMarketAddress  => tmp1_MarketAddress --
                                                       ,lTblStrp1       => lTblStrp
                                                       ,lAction         => 'STRIP_TAG_VALUE');
                IF oReturnCode = pkg_k.rc_ok THEN
                    RAISE xFinished;
                ELSE
                    tmp1_EnteredAddress := SUBSTR(iEntred_Address
                                                 ,1
                                                 ,instr(iEntred_Address
                                                       ,','
                                                       ,1
                                                       ,1) - 1);
                    tmp1_MarketAddress  := SUBSTR(iMarket_Address
                                                 ,1
                                                 ,instr(iMarket_Address
                                                       ,','
                                                       ,1
                                                       ,1) - 1);
                    oReturnCode         := CompareAdrresses(lEnteredAddress => tmp1_EnteredAddress -- Last attempt. Try to strip Lot Number
                                                           ,lMarketAddress  => tmp1_MarketAddress -- and/or tag
                                                           ,lTblStrp1       => lTblStrp
                                                           ,lAction         => 'STRIP_TAG_VALUE_MIX');
                    IF oReturnCode = pkg_k.rc_ok THEN
                        RAISE xFinished;
                    ELSE

                        oReturnCode := pkg_k.rc_error;
                    END IF;
                END IF;

            END IF;

        ELSE
            oReturnCode := pkg_k.rc_error;
            RAISE xFinished;
        END IF;


        RETURN RC_ERROR;
    EXCEPTION
        WHEN xFinished THEN
            RETURN oReturnCode;
        WHEN OTHERS THEN
            raise_application_error(-20998
                                   ,'pkg_addr.UnstructAddressComp failed' || SQLCODE || SQLERRM);

    END UnstructAddressComp;

  PROCEDURE LoadAddressTemplates AS
    BEGIN
        FOR rec IN (SELECT adt.AddressTemplateID
                          ,adt.InclCountryFlg
                          ,adt.FMKey
                          ,pkg_Dict.Xlate(l.DescrDictID
                                         ,NULL) Country
                    FROM   AddressTemplate adt
                          ,CountryTemplate ct
                          ,Location        l
                    WHERE  ct.AddressTemplateID(+) = adt.AddressTemplateID
                    AND    l.LocationID(+) = ct.LocationID) LOOP
            g_InclCountry(rec.AddressTemplateID) := rec.InclCountryFlg;
            g_FMKey(rec.AddressTemplateID) := rec.FMKey;
            g_Country(rec.AddressTemplateID) := rec.Country;
        END LOOP;
        --
        --  Get a few Location Hierarchy Ids which will be used
        --  to get a Controlled Addresses description
        SELECT pkg_loch.lochid(k_AddrLocHType)
              ,pkg_loch.lochid(k_PcodeLocHType)
        INTO   g_HIDAddr
              ,g_HIDPCode
        FROM   DUAL;
        --
        --  Load Location abbreviations if available
        FOR csr IN (SELECT a.locationid
                          ,c.AbbrevText
                    FROM   SystemProperty aa
                          ,Location       a
                          ,Dictionary     b
                          ,DictionaryText c
                    WHERE  aa.propertykey = 'DFLTLANG'
                    AND    a.locationtype = 'PDT' --  Postal Delivery types
                    AND    b.dictid = a.descrdictid
                    AND    c.dictid = a.descrdictid
                    AND    c.langcode = aa.propvalchar) LOOP
            g_LocnDescrAbbrev(csr.locationid) := csr.abbrevtext;
        END LOOP;

        --  Load flat/unit descriptions if available
        FOR csr IN (SELECT a.locationid
                          ,c.AbbrevText
                          ,c.FullText
                    FROM   SystemProperty aa
                          ,Location a
                          ,Dictionary b
                          ,DictionaryText c
                    WHERE  aa.propertykey = 'DFLTLANG'
                    AND    a.locationtype in ('FLT', 'FUT')
                    AND    b.dictid       = a.descrdictid
                    AND    c.dictid       = a.descrdictid
                    AND    c.langcode     = aa.propvalchar) LOOP
            g_LocnDescrAbbrev (csr.locationid) := csr.fulltext ;
        END LOOP ;

    END LoadAddressTemplates;

    FUNCTION get_Formatted(iAddressID   IN PLS_INTEGER
                          ,iLocHDescFlg IN VARCHAR2 DEFAULT 'Y'
                          ,iDelimiter   IN VARCHAR2 DEFAULT k_Fld_Delim
                           -- 37933
                          ,iLocHMbrType IN VARCHAR2 DEFAULT NULL
                          ,iCallingPgm  in varchar2 default null
                          ) RETURN VARCHAR2 AS
        --
        TYPE taTemplateID IS TABLE OF PLS_INTEGER INDEX BY BINARY_INTEGER;
        TYPE taAPKey IS TABLE OF AddressProperty.APKey%TYPE INDEX BY BINARY_INTEGER;
        TYPE taVal IS TABLE OF AddressPropertyVal.PropValChar%TYPE INDEX BY BINARY_INTEGER;
        TYPE taLocnId IS TABLE OF AddressPropertyVal.LocationId%TYPE INDEX BY BINARY_INTEGER;
        TYPE taLocHType IS TABLE OF AddressProperty.LocHType%TYPE INDEX BY BINARY_INTEGER;

        TYPE taLocHMbrType IS TABLE OF LocHMbr.LocHMbrType%TYPE INDEX BY BINARY_INTEGER;
        --TYPE taLocHLocnId IS TABLE OF LocHMbr.LocationId%TYPE INDEX BY BINARY_INTEGER;
        TYPE taLocnDesc IS TABLE OF Dictionary.Phrase%TYPE INDEX BY BINARY_INTEGER;
        --
        xDone EXCEPTION;
        l_ret VARCHAR2(2000) := NULL;
        --
        l_TemplateID taTemplateID;
        l_APKey      taAPKey;
        l_PVal       taVal;
        l_LocationId taLocnId;
        l_LocHType   taLocHType;
        --
        o_LocHMbrType taLocHMbrType;
        --l_LocHLocnId      taLocHLocnId;
        o_LocnDesc        taLocnDesc;
        o_LocnAbbrev      taLocnDesc;
        l_LocHAddr_LocnId LocHMbr.LocationId%TYPE;
        l_PremNumber      VARCHAR2(2000);
        l_PremName        VARCHAR2(2000);
        l_SPremName       VARCHAR2(2000);
        --
        l_POBox             VARCHAR2(2000);
        l_BuildLocnDescrFlg BOOLEAN := TRUE; -- Cache control...
        l_separator         VARCHAR2(5) := k_fld_delim;
        l_FlatUnit          VARCHAR2(2000);
        l_Level             VARCHAR2(2000);
        --l_locality          VARCHAR2(2000);
        l_temp           VARCHAR2(2000);
        l_LocnDescriptor VARCHAR2(2000);
        lAddrLine1       addresspropertyval.propvalchar%TYPE;
        lAddrLine2       addresspropertyval.propvalchar%TYPE;
        lAddrLine3       addresspropertyval.propvalchar%TYPE;
        --
        lLocHDescFlg     VARCHAR2(1); -- 37933

        PROCEDURE GetLocHMbrDescr(iLocHType         IN LOCHTYPE.LOCHTYPE%TYPE
                                 ,i_LocHAddr_LocnId IN LOCATION.LOCATIONID%TYPE
                                 ,o_LocnDesc        OUT taLocnDesc
                                 ,o_LocHMbrType     OUT taLocHMbrType
                                 ,o_LocnAbbrev      OUT taLocnDesc) IS
            --
            l_HIDTo          LocationHierarchy.Lochid%TYPE;
            l_LocationIdFrom LocHMbr.LocationId%TYPE;
            l_Street         LocationProperty.PropValChar%TYPE;

            FUNCTION getFullStreetName (
              iLocationID IN LOCATION.LOCATIONID%TYPE
            ) RETURN VARCHAR2
            IS
               oStreet VARCHAR2(250) := NULL;
            BEGIN
               SELECT (str.propvalchar || ' ' ||
                      (select abbrevtext from vw_location_strtp a where a.locationid = strtp.propvalnumber) || ' ' ||
                      (select abbrevtext from vw_location_strsf a where a.locationid = strsfx.propvalnumber))
                 INTO
                      oStreet
                 FROM locationproperty str,
                      locationproperty strtp,
                      locationproperty strsfx
                WHERE str.LocationID = iLocationID
                  AND str.locationid = strtp.locationid
                  AND str.locationid = strsfx.locationid
                  AND str.propertykey    = 'STRNM'
                  AND strtp.propertykey  = 'STRTP'
                  AND strsfx.propertykey = 'STRSFX';
               RETURN oStreet;
            EXCEPTION
               WHEN OTHERS THEN
                  RETURN NULL;
            END;
            --
        BEGIN
            --
            IF iLocHType = k_AddrLocHType THEN
                l_HIDTo          := g_HIDAddr;
                l_LocationIdFrom := i_LocHAddr_LocnId;
                --
            ELSIF iLocHType = k_PcodeLocHType THEN
                l_HIDTo          := g_HIDPcode;
                l_LocationIdFrom := pkg_loch.linkedlocn(g_HIDAddr
                                                       ,l_LocHAddr_LocnId
                                                       ,l_HIDTo
                                                       ,'Y');
                --
            ELSE
                --  Other LocationHierarchy types used in addresses (I can't think of any!)
                l_HIDTo := pkg_loch.lochid(iLocHType);
                --
                l_LocationIdFrom := pkg_loch.linkedlocn(g_HIDAddr
                                                       ,l_LocHAddr_LocnId
                                                       ,l_HIDTo
                                                       ,'Y');
            END IF;
            --
            l_Street := getFullStreetName(i_LocHAddr_LocnId);
            --
            --  Get the description of each LocationId in the LochMbr hierarchy
            SELECT CASE
                        WHEN LHM.LocHMbrType =  'STR'
                        AND  l_Street        IS NOT NULL THEN l_Street
                        ELSE D.Phrase
                   END
                  ,LHM.LocHMbrType
                  ,E.AbbrevText
            BULK COLLECT INTO o_LocnDesc
                             ,o_LocHMbrType
                             ,o_LocnAbbrev
            FROM   (
                    SELECT LocationId
                          ,LocHMbrType
                          ,LEVEL        AS llevel  -- MHA-1711  Address formatted in state, sub, street order instead of Street, sub, state order
                    FROM   LocHMbr
                    WHERE  LocHID = l_HIDTo -- Wr1755
                    CONNECT BY LocHMbrID = PRIOR ParentLocHMbrID
                    START  WITH LocationID = l_LocationIdFrom
                   ) LHM
                  ,Location L
                  ,Dictionary D
                  ,DictionaryText E
            WHERE  L.LocationID = LHM.LocationID
            AND    D.DictID = L.DescrDictId
            AND    E.DictID(+) = L.DescrDictId
            AND    NOT EXISTS (
                       SELECT lp.PropValChar
                       FROM   LocationProperty LP
                       WHERE  lp.LocationID = lhm.LocationID
                       AND    lp.PropertyKey = 'IPAFLG'
                       AND    lp.PropValChar <> 'Y'
                      )
            ORDER BY llevel;  -- MHA-1711
            --
        END GetLocHMbrDescr;
        --
        --
        FUNCTION UKFormatNo(iString IN VARCHAR2) RETURN PLS_INTEGER IS
            --
            l_char_1   CHAR(1) := NULL;
            l_char_n   CHAR(1) := NULL;
            l_char_n_1 CHAR(1) := NULL;
            l_FormatNo PLS_INTEGER;
            --
        BEGIN
            --
            l_char_1 := substr(iString
                              ,1
                              ,1);
            l_char_n := substr(iString
                              ,length(iString)
                              ,1);
            IF length(iString) > 1 THEN
                l_char_n_1 := substr(iString
                                    ,length(iString) - 1
                                    ,1);
            END IF;
            --
            l_FormatNo := 9;
            --
            IF l_char_1 BETWEEN '0' AND '9' THEN
                IF l_char_n BETWEEN '0' AND '9' THEN
                    l_FormatNo := 1;
                ELSIF l_char_n_1 IS NOT NULL
                      AND l_char_n_1 BETWEEN '0' AND '9'
                      AND (l_char_n BETWEEN 'A' AND 'Z' OR l_char_n BETWEEN 'a' AND 'z') THEN
                    l_FormatNo := 1;
                END IF;
            END IF;
            --
            RETURN l_FormatNo;
            --
        END UKFormatNo;
        --
        --
        -- 37933
        FUNCTION formatForLocHMbrType(iLocHMbrType IN VARCHAR2, istring IN VARCHAR2, k_Fld_Delim IN VARCHAR2) RETURN VARCHAR2 IS

          lDelimPos        PLS_INTEGER;
          lPos             PLS_INTEGER;
          lFormatedString  VARCHAR2(200);
        BEGIN

           lDelimPos := instr(istring,k_Fld_Delim,1);

           IF iLocHMbrType = 'SUB' THEN
              lPos := instr(istring,'  ',-1,2);
              lFormatedString := substr(istring,lDelimPos+1,lPos-lDelimPos-1);

           ELSIF iLocHMbrType = 'STR' THEN
              lFormatedString := substr(istring,1,lDelimPos-1);
           ELSE
              lFormatedString := istring;
           END IF;

           RETURN lFormatedString;

        END formatForLocHMbrType;


    BEGIN
        -- SEPI-12818  Planned Interruption Notification mailing address
        IF iAddressId IS NULL THEN
            RETURN NULL;
        END IF;

        -- 37933
        IF iLocHMbrType IS NOT NULL THEN
          lLocHDescFlg := 'X';
        ELSE
           lLocHDescFlg := iLocHDescFlg;
        END IF;

        BEGIN
            IF iAddressID IS NULL
               OR iAddressID = 0 THEN
                RAISE xDone;
            END IF;
            --
            IF g_FMKey.COUNT = 0 THEN
                LoadAddressTemplates;
            END IF;
            --
            SELECT a.AddressTemplateID
                  ,cap.APKey
                  ,decode(lLocHDescFlg,'X',NULL,av.PropValChar) --37933
                  ,av.LocationId
                  ,ap.LocHType BULK COLLECT
            INTO   l_TemplateID
                  ,l_APKey
                  ,l_PVal
                  ,l_LocationId
                  ,l_LocHType
            FROM   Address            a
                  ,AddressPropertyVal av
                  ,CountryAP          cap
                  ,AddressProperty    ap
            WHERE  a.AddressID = iAddressID
            AND    av.AddressID = a.AddressID
            AND    cap.CountryAPID = av.CountryAPID
            AND    ap.APKey = cap.APKey
            ORDER  BY cap.Seq;
            --
            IF l_TemplateID.COUNT = 0 THEN
                pkg_Msg.SysMsg('F_SYS'
                              ,4
                              ,iAddressID);
            END IF;
            --
            --  Is this a Controlled Address, that is an address linked
            --  to the location hierarchy ??  Find the linking LocationId.
            FOR i IN 1 .. l_TemplateID.COUNT LOOP
                IF l_LocHType(i) = k_AddrLocHType THEN
                    l_LocHAddr_LocnId := l_LocationId(i);
                    --            Has the description for this location already been determined ?
                    IF g_AddrLocnDescr.EXISTS(l_LocHAddr_LocnId)
                       AND g_AddrTemplate(l_LocHAddr_LocnId) = g_FMKey(l_TemplateID(1)) THEN
                        l_BuildLocnDescrFlg := FALSE; -- In Cache.  Use this value.
                    END IF;
                    EXIT;
                END IF;
            END LOOP;
            --
            IF NOT g_FMKey.EXISTS(l_TemplateID(1))
               OR g_FMKey(l_TemplateID(1)) IS NULL THEN
                FOR i IN 1 .. l_TemplateID.COUNT LOOP
                    IF l_PVal(i) IS NOT NULL THEN
                        IF l_ret IS NULL THEN
                            l_ret := l_PVal(i);
                        ELSE
                            l_ret := l_ret || k_Fld_Delim || l_PVal(i);
                        END IF;
                    END IF;
                END LOOP;
                --
            ELSIF g_FMKey(l_TemplateID(1)) = 'EUADD' THEN
                FOR i IN 1 .. l_TemplateID.COUNT LOOP
                    IF l_PVal(i) IS NOT NULL THEN
                        IF l_APKey(i) = 'ZIPCODE' THEN
                            l_ret := l_ret || l_PVal(i) || ' ';
                        ELSE
                            l_ret := l_ret || l_PVal(i) || k_Fld_Delim;
                        END IF;
                    END IF;
                END LOOP;
                --
            ELSIF g_FMKey(l_TemplateID(1)) = 'UKUADD' THEN
                --  United Kingdom Uncontrolled Address
                FOR i IN 1 .. l_TemplateID.COUNT LOOP
                    IF l_PVal(i) IS NOT NULL THEN
                        IF l_ret IS NULL THEN
                            l_ret := l_PVal(i);
                        ELSE
                            l_ret := l_ret || k_Fld_Delim || l_PVal(i);
                        END IF;
                    END IF;
                END LOOP;
                --
            ELSIF g_FMKey(l_TemplateID(1)) = 'UKCADD' THEN
                --  United Kingdom Controlled Address
                FOR i IN 1 .. l_TemplateID.COUNT LOOP
                    --
                    IF l_LocHType(i) IS NOT NULL
                       AND l_LocHAddr_LocnId IS NOT NULL
                       AND (lLocHDescFlg = k_Yes OR lLocHDescFlg = 'X') THEN
                        --
                        --  Previously derived address location descriptions are reused.
                        IF l_BuildLocnDescrFlg THEN
                            --
                            GetLocHMbrDescr(l_LocHType(i)
                                           ,l_LocHAddr_LocnId
                                           ,o_LocnDesc
                                           ,o_LocHMbrType
                                           ,o_LocnAbbrev);
                            --
                            FOR j IN 1 .. o_LocHMbrType.COUNT LOOP
                                IF o_LocHMbrType(j) <> 'CNTRY' THEN
                                    l_temp := o_LocnDesc(j);
                                    IF l_ret IS NULL THEN
                                        l_ret := l_temp;
                                    ELSE
                                        l_ret := l_ret || k_Fld_Delim || l_temp;
                                    END IF;
                                END IF;
                            END LOOP;
                            --
                            --  Save the description in an array of descriptions
                            g_AddrLocnDescr(l_LocHAddr_LocnId) := l_ret;
                            g_AddrTemplate(l_LocHAddr_LocnId) := g_FMKey(l_TemplateID(1));
                            --
                        ELSE
                            --  get the saved description
                            l_ret := g_AddrLocnDescr(l_LocHAddr_LocnId);
                        END IF;
                        --
                        --  Else use the value from the address property val
                        --  Join and save off various fields for final concatination later on
                    ELSIF l_PVal(i) IS NOT NULL THEN
                        --
                        IF l_APKey(i) = 'SPREM' THEN
                            IF l_SPremName IS NULL THEN
                                l_SPremName := l_PVal(i);
                            ELSE
                                l_SPremName := l_SPremName || ' ' || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) IN ('PREMNM'
                                            ,'BGRPNM') THEN
                            IF l_PremName IS NULL THEN
                                l_PremName := l_PVal(i);
                            ELSE
                                l_PremName := l_PremName || ' ' || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) = 'PREMNO' THEN
                            IF l_PremNumber IS NULL THEN
                                l_PremNumber := l_PVal(i);
                            ELSE
                                l_PremNumber := l_PremNumber || ' ' || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) = 'POBOX' THEN
                            l_POBox := l_PVal(i);
                            --
                        ELSE
                            IF l_ret IS NULL THEN
                                l_ret := l_PVal(i);
                            ELSE
                                l_ret := l_ret || k_Fld_Delim || l_PVal(i);
                            END IF;
                        END IF;
                        --
                    END IF;
                END LOOP;
                --
                --  Now join everything together in the correct order
                IF l_PremNumber IS NOT NULL THEN
                    l_ret := l_PremNumber || ' ' || l_ret;
                END IF;
                --
                IF l_PremName IS NOT NULL THEN
                    IF l_PremNumber IS NULL
                       AND UKFormatNo(l_PremName) = 1 THEN
                        l_ret := l_PremName || ' ' || l_ret;
                    ELSE
                        l_ret := l_PremName || k_Fld_Delim || l_ret;
                    END IF;
                END IF;
                --
                IF l_SPremName IS NOT NULL THEN
                    IF l_PremNumber IS NULL THEN
                        --  Sub Premises and Premises Names but no Premises Number
                        IF l_PremName IS NULL THEN
                            --  This should not occur !
                            l_ret := l_SPremName || k_Fld_Delim || l_ret;
                        ELSE
                            IF UKFormatNo(l_SPremName) = 1 THEN
                                l_ret := l_SPremName || ' ' || l_ret;
                            ELSE
                                l_ret := l_SPremName || k_Fld_Delim || l_ret;
                            END IF;
                        END IF;
                    ELSE
                        IF l_PremName IS NULL THEN
                            --  Sub Premises Name and Premises Number but no Premises Name
                            l_ret := l_SPremName || k_Fld_Delim || l_ret;
                        ELSE
                            --  Sub Premises and Premises Names and Premises Number
                            IF UKFormatNo(l_SPremName) = 1 THEN
                                l_ret := l_SPremName || ' ' || l_ret;
                            ELSE
                                l_ret := l_SPremName || k_Fld_Delim || l_ret;
                            END IF;
                        END IF;
                    END IF;
                END IF;
                --
                IF l_POBox IS NOT NULL THEN
                    l_ret := l_POBox || k_Fld_Delim || l_ret;
                END IF;
                --
            ELSIF g_FMKey(l_TemplateID(1)) = 'AUSCADD' THEN
                --
                --
                --  Australian Controlled Address
                --
                FOR i IN 1 .. l_TemplateID.COUNT LOOP
                    --
                    IF l_LocHType(i) IS NOT NULL
                       AND l_LocHAddr_LocnId IS NOT NULL
                       AND (lLocHDescFlg = k_Yes OR lLocHDescFlg = 'X') THEN
                        --
                        --  Previously derived address location descriptions are reused.
                        IF l_BuildLocnDescrFlg THEN
                            --
                            GetLocHMbrDescr(l_LocHType(i)
                                           ,l_LocHAddr_LocnId
                                           ,o_LocnDesc
                                           ,o_LocHMbrType
                                           ,o_LocnAbbrev);
                            --
                            FOR j IN 1 .. o_LocHMbrType.COUNT LOOP
                                IF o_LocHMbrType(j) <> 'CNTRY'
                                   AND o_LocHMbrType(j) <> 'SUBPC' THEN
                                    IF o_LocHMbrType(j) = 'STATE' THEN
                                        --  Use abbreviation for above types
                                        l_temp := o_LocnAbbrev(j);
                                    ELSE
                                        l_temp := o_LocnDesc(j);
                                    END IF;
                                    IF l_ret IS NULL THEN
                                        l_ret := l_temp;
                                    ELSE
                                        l_ret := l_ret || l_separator || l_temp;
                                    END IF;
                                    --
                                    l_separator := k_Fld_Delim;
                                    --
                                    --  Join the first and second street name with a '&'
                                    IF o_LocHMbrType(j) = 'STR'
                                       AND o_LocHMbrType.EXISTS(j + 1)
                                       AND o_LocHMbrType(j + 1) = 'STR' THEN
                                        l_separator := ' & ';
                                    END IF;
                                    --  Locality, State/Territory and Postcode all appear
                                    --  on the same line separated by two spaces
                                    IF o_LocHMbrType(j) IN ('SUB'
                                                           ,'STATE'
                                                           ,'PCODE') THEN
                                        l_separator := '  ';
                                    END IF;
                                END IF;
                            END LOOP;
                            --
                            --  Save the description in an array of descriptions
                            g_AddrLocnDescr(l_LocHAddr_LocnId) := l_ret;
                            g_AddrTemplate(l_LocHAddr_LocnId) := g_FMKey(l_TemplateID(1));
                            --
                        ELSE
                            --  get the saved description
                            l_ret := g_AddrLocnDescr(l_LocHAddr_LocnId);
                        END IF;
                        --
                        --  Else use the value from the address property val
                        --  Join and save off various fields for final concatination later on
                    ELSIF l_PVal(i) IS NOT NULL THEN
                        --
                        IF l_APKey(i) IN ('PREMNM'
                                         ,'PREMNM2'
                                         ,'BGRPNM') THEN
                            IF l_PremName IS NULL THEN
                                l_PremName := l_PVal(i);
                            ELSE
                                l_PremName := l_PremName || k_Fld_Delim || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) IN ('FUT'
                                            ,'SPREM') THEN
                            --  Check for a long-text description of the location
                            if  iCallingPgm = 'UI'  then
                                IF  l_APKey (i) = 'FUT'
                                AND g_LocnDescrAbbrev.EXISTS(l_LocationId (i)) THEN
                                    l_PVal (i) := g_LocnDescrAbbrev (l_LocationId (i)) ;
                                END IF ;
                            end if;
                            IF l_FlatUnit IS NULL THEN
                                l_FlatUnit := l_PVal(i);
                            ELSE
                                l_FlatUnit := l_FlatUnit || ' ' || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) IN ('FLT'
                                            ,'FLRLVL') THEN
                            --  Check for a long-text description of the location
                            if  iCallingPgm = 'UI'  then
                                IF  l_APKey (i) = 'FLT'
                                AND g_LocnDescrAbbrev.EXISTS(l_LocationId (i)) THEN
                                    l_PVal (i) := g_LocnDescrAbbrev (l_LocationId (i)) ;
                                END IF ;
                            end if;
                            IF l_Level IS NULL THEN
                                l_Level := l_PVal(i);
                            ELSE
                                l_Level := l_Level || ' ' || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) IN ('PREMNO'
                                            ,'PREMSFX') THEN
                            l_PremNumber := l_PremNumber || l_PVal(i);
                            --
                        ELSIF l_APKey(i) = 'PREMNO2' THEN
                            IF l_PremNumber IS NULL THEN
                                l_PremNumber := l_PVal(i);
                            ELSE
                                l_PremNumber := l_PremNumber || '-' || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) = 'PREMSFX2' THEN
                            l_PremNumber := l_PremNumber || l_PVal(i);
                            --
                        ELSIF l_APKey(i) = 'LOCNO'
                              AND l_PVal(i) IS NOT NULL THEN
                            IF l_PremNumber IS NULL THEN
                                l_PremNumber := 'LOC ' || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) = 'LOTNO'
                              AND l_PVal(i) IS NOT NULL THEN
                            IF l_PremNumber IS NULL THEN
                                l_PremNumber := 'LOT ' || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) = 'LOCDESC' THEN
                            l_LocnDescriptor := l_PVal(i);
                            --
                        ELSIF l_APKey(i) IN ('POBOXTY'
                                            ,'POBOX') THEN
                            --  Check for an abbreviated form of the description
                            IF l_APKey(i) = 'POBOXTY'
                               AND g_LocnDescrAbbrev.EXISTS(l_LocationId(i)) THEN
                                l_PVal(i) := g_LocnDescrAbbrev(l_LocationId(i));
                            END IF;
                            IF l_POBox IS NULL THEN
                                l_POBox := l_PVal(i);
                            ELSE
                                l_POBox := l_POBox || ' ' || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) = 'DPID' THEN
                            --  Delivery point identifier.  Will be converted to a barcode someday !
                            NULL;
                            --
                        ELSIF l_APKey(i) = 'DFISID' THEN
                            --  DFISID (Feature Id) is not to be included in the formatted string
                            NULL;
                            --
                        ELSIF l_APKey(i) = 'ADDRESSLINE' THEN
                            lAddrLine1 := l_PVal(i);
                            --
                        ELSIF l_APKey(i) = 'ADDRESSLINE2' THEN
                            lAddrLine2 := l_PVal(i);
                            --
                        ELSIF l_APKey(i) = 'ADDRESSLINE3' THEN
                            lAddrLine3 := l_PVal(i);
                            --
                        ELSE
                            IF l_ret IS NULL THEN
                                l_ret := l_PVal(i);
                            ELSE
                                l_ret := l_ret || k_Fld_Delim || l_PVal(i);
                            END IF;
                        END IF;
                        --
                    END IF;
                END LOOP;
                --
                --  Now join everything together in the correct order
                IF l_LocnDescriptor IS NOT NULL THEN
                    l_ret := l_LocnDescriptor || ' ' || l_ret;
                END IF;
                --
                IF l_PremNumber IS NOT NULL THEN
                    l_ret := l_PremNumber || ' ' || l_ret;
                END IF;
                --
                IF l_FlatUnit IS NOT NULL
                   OR l_Level IS NOT NULL THEN
                    -- FlatUnit / Level info is separated from
                    -- the house number by two spaces
                    IF l_FlatUnit IS NOT NULL
                       AND l_Level IS NOT NULL THEN
                        l_ret := l_FlatUnit || k_Fld_Delim || l_Level || '  ' || l_ret;
                    ELSE
                        l_ret := NVL(l_FlatUnit
                                    ,l_Level) || '  ' || l_ret;
                    END IF;
                END IF;
                --
                IF l_POBox IS NOT NULL THEN
                    l_ret := l_POBox || k_Fld_Delim || l_ret;
                END IF;
                --
                IF l_PremName IS NOT NULL THEN
                    l_ret := l_PremName || k_Fld_Delim || l_ret;
                END IF;
                --
                IF lAddrLine3 IS NOT NULL THEN
                    l_ret := lAddrLine3 || k_Fld_Delim || l_ret;
                END IF;
                --
                IF lAddrLine2 IS NOT NULL THEN
                    l_ret := lAddrLine2 || k_Fld_Delim || l_ret;
                END IF;
                --
                IF lAddrLine1 IS NOT NULL THEN
                    l_ret := lAddrLine1 || k_Fld_Delim || l_ret;
                END IF;
                --
                l_ret := upper(l_ret);
                --
            ELSIF g_FMKey(l_TemplateID(1)) = 'JPNCADD' THEN
                --
                --
                --  JAPANESE Controlled Address
                --
                FOR i IN 1 .. l_TemplateID.COUNT LOOP
                    --
                    IF l_LocHType(i) IS NOT NULL
                       AND l_LocHAddr_LocnId IS NOT NULL
                       AND (lLocHDescFlg = k_Yes OR lLocHDescFlg = 'X') THEN
                        --
                        --  Previously derived address location descriptions are reused.
                        IF l_BuildLocnDescrFlg THEN
                            --
                            GetLocHMbrDescr(l_LocHType(i)
                                           ,l_LocHAddr_LocnId
                                           ,o_LocnDesc
                                           ,o_LocHMbrType
                                           ,o_LocnAbbrev);
                            --
                            FOR j IN 1 .. o_LocHMbrType.COUNT LOOP
                                IF o_LocHMbrType(j) <> 'CNTRY' THEN
                                    l_temp := o_LocnDesc(j);
                                    IF l_ret IS NULL THEN
                                        l_ret := l_temp;
                                    ELSE
                                        l_ret := l_temp || l_separator || l_ret;
                                    END IF;
                                    --
                                    l_separator := ' ';
                                    --
                                END IF;
                            END LOOP;
                            --
                            --  Save the description in an array of descriptions
                            g_AddrLocnDescr(l_LocHAddr_LocnId) := l_ret;
                            g_AddrTemplate(l_LocHAddr_LocnId) := g_FMKey(l_TemplateID(1));
                            --
                        ELSE
                            --  get the saved description
                            l_ret := g_AddrLocnDescr(l_LocHAddr_LocnId);
                        END IF;
                        --
                        --  Else use the value from the address property val
                        --  Join and save off various fields for final concatination later on
                    ELSIF l_PVal(i) IS NOT NULL THEN
                        --
                        IF l_APKey(i) IN ('JPNBAN') THEN
                            IF l_PremName IS NULL THEN
                                l_PremName := l_PVal(i);
                            ELSE
                                l_PremName := l_PremName || k_Fld_Delim || l_PVal(i);
                            END IF;
                            --
                        ELSIF l_APKey(i) IN ('JPNAA1'
                                            ,'JPNAA2'
                                            ,'JPNBAP') THEN
                            IF l_LocnDescriptor IS NULL THEN
                                l_LocnDescriptor := l_PVal(i);
                            ELSE
                                l_LocnDescriptor := l_LocnDescriptor || '-' || l_PVal(i);
                            END IF;
                            --
                        ELSE
                            IF l_ret IS NULL THEN
                                l_ret := l_PVal(i);
                            ELSE
                                l_ret := l_ret || chr(13) || chr(10) || l_PVal(i);
                            END IF;
                        END IF;
                        --
                    END IF;
                END LOOP;
                --
                --  Now join everything together in the correct order
                --
                IF l_PremName IS NOT NULL THEN
                    l_ret := l_ret || ' ' || l_PremName;
                END IF;
                --
                IF l_LocnDescriptor IS NOT NULL THEN
                    l_ret := l_ret || chr(13) || chr(10) || l_LocnDescriptor;
                END IF;
                --
                l_ret := upper(l_ret);

                --        ELSIF l_FMKey(l_TemplateID(1)) = '?????' THEN
                --
                --            ??FormatSpecificAddress?? ;
            ELSE
                --
                --    Unknown address format method
                FOR i IN 1 .. l_TemplateID.COUNT LOOP
                    IF l_PVal(i) IS NOT NULL THEN
                        IF l_ret IS NULL THEN
                            l_ret := l_PVal(i);
                        ELSE
                            l_ret := l_ret || k_Fld_Delim || l_PVal(i);
                        END IF;
                    END IF;
                END LOOP;
                --
            END IF;
            --
            IF g_FMKey.EXISTS(l_TemplateID(1))
               AND g_InclCountry(l_TemplateID(1)) = 'Y'
               AND g_Country(l_TemplateID(1)) IS NOT NULL THEN
                IF g_FMKey(l_TemplateID(1)) = 'UKCADD'
                   OR g_FMKey(l_TemplateID(1)) = 'UKUADD' THEN
                    l_ret := l_ret || k_Fld_Delim || g_Country(l_TemplateID(1));
                ELSE
                    l_ret := l_ret || g_Country(l_TemplateID(1)) || k_Fld_Delim;
                END IF;
            END IF;

        EXCEPTION
            WHEN xDone THEN
                RETURN NULL;

        END;

        IF iLocHMbrType IS NOT NULL THEN
           l_ret := formatForLocHMbrType(iLocHMbrType,l_ret,k_Fld_Delim);
        END IF;

        IF iDelimiter <> k_Fld_Delim THEN
            l_ret := REPLACE (l_ret, k_fld_delim, iDelimiter);
        END IF;

        RETURN l_ret;

    END get_Formatted;

    FUNCTION get_FormattedUI(iAddressID   IN PLS_INTEGER
                            ,iLocHDescFlg IN VARCHAR2 DEFAULT 'Y'
                            ,iDelimiter   IN VARCHAR2 DEFAULT k_Fld_Delim
                             -- 37933
                            ,iLocHMbrType IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2 AS
        --
        lAddress             varchar2(2000) := null;
        --
    begin
        lAddress := get_Formatted(iAddressID
                                 ,iLocHDescFlg
                                 ,iDelimiter
                                 ,iLocHMbrType
                                 ,'UI');
        return lAddress;
    end get_FormattedUI;

    -- Wr 133668  Java Web Service address retieval
    --   iPartGroup = 'LINES'
    --   iPartkey
    --     L(1)                    address line 1
    --     L(2)                    address line 2
    --     ....                    ..............
    --     L(iMaxAddrLines)        address line (iMaxAddrLines)
    --
    --   iPartGroup = 'WSADDR'
    --   iPartkey
    --     L(1)                    address line 1
    --     L(2)                    address line 2
    --     ....                    ..............
    --     L(iMaxAddrLines)        address line (iMaxAddrLines)
    --     SUB                     suburb
    --     STATE                   state
    --     LOCN                    location (suburb and state)
    --     PCD                     postcode
    -- -----------------------------------------------------------------------------------------
    FUNCTION getFormattedPart (
        iAddressId                     IN address.addressid%TYPE
       ,iPartGroup                     IN VARCHAR2
       ,iPartKey                       IN VARCHAR2
       ,iMaxAddrLines                  IN PLS_INTEGER                 DEFAULT NULL
       )
    RETURN VARCHAR2
    IS
        kMaxCacheTime                  CONSTANT NUMBER                := 4 / (60 * 24);  -- 4 minutes as a fraction of a day
        kWSADDR                        CONSTANT VARCHAR2(30)          := 'WSADDR';
        k2Spaces                       CONSTANT VARCHAR2(05)          := '  ';

        lPartGroup                     VARCHAR2(30)                   := UPPER (iPartGroup);
        lPartKey                       VARCHAR2(30)                   := UPPER (iPartKey);

        lCnt                           PLS_INTEGER;
        laAddrLine                     pkg_util.tastring;
        laSubStatePCd                  pkg_std.tadescr;
        lLine                          VARCHAR2(250);
        lOffset                        PLS_INTEGER                    := 0;
        lRet                           VARCHAR2(100);
        lIdx                           PLS_INTEGER;

    BEGIN
        -- SEPI-12818  Planned Interruption Notification mailing address
        IF iAddressId IS NULL THEN
            RETURN NULL;
        END IF;

        -- get data if not already cached
        IF NOT gaFPAddr.EXISTS(iAddressId)
        OR (pkg_calc.now - gaFPAddr(iAddressId).cachetime) > kMaxCacheTime THEN
            -- get the formatted address, break it into lines and extract parts
            --   addressline 1
            --   ...
            --   addressline n
            --   suburb
            --   state
            --   postcode
            lCnt      :=
                pkg_util.words (
                    ibuf    => get_Formatted (iaddressid  => iAddressId)
                   ,isep    => k_Fld_Delim
                   ,oarray  => laAddrLine
                   ,itrim   => TRUE
                   );

            -- split the last line into three words delimited by two spaces
            lLine            := TRIM (laAddrLine(lCnt));
            laSubStatePCd(1) := NULL;  -- town / suburb
            laSubStatePCd(2) := NULL;  -- state
            laSubStatePCd(3) := NULL;  -- postcode
            FOR i IN 1 .. 2 LOOP
                IF INSTR (lLine, k2spaces) > 0 THEN
                    laSubStatePCd(i) :=  -- get the first word
                        SUBSTR (
                            lLine
                           ,1
                           ,INSTR (lLine, k2spaces) - 1
                           );

                    lLine :=  -- remove the first word
                        SUBSTR (
                            lLine
                           ,LENGTH (laSubStatePCd(i)) + LENGTH(k2Spaces) + 1  -- start of the next word
                           );

                    IF i = 2 THEN
                        laSubStatePCd(i+1) := lLine;
                    END IF;

                END IF;

            END LOOP;

            -- is the postcode a number?
            IF NOT pkg_util.isNumber (laSubStatePCd(3)) THEN
                -- it appears that the postcode wasn't found
                laSubStatePCd(2) :=
                       laSubStatePCd(2)
                    || CASE WHEN laSubStatePCd(3) IS NULL THEN NULL ELSE k2Spaces END
                    || laSubStatePCd(3);
                laSubStatePCd(3) := NULL;
            END IF;

            gaFPAddr(iAddressId).aAddrLine  := laAddrLine;
            gaFPAddr(iAddressId).TownSuburb := laSubStatePCd(1);
            gaFPAddr(iAddressId).StateCd    := laSubStatePCd(2);
            gaFPAddr(iAddressId).Postcode   := laSubStatePCd(3);
            gaFPAddr(iAddressId).Cachetime  := pkg_calc.now;

        END IF;  --  IF not cached

        -- Return part from cache of parts
        -- Allow for a maximum of x address lines plus suburb state and postcode
        laAddrLine := gaFPAddr(iAddressId).aAddrLine;
        lCnt       := laAddrLine.COUNT;
        IF  lPartGroup                    =  kWSADDR
        AND gaFPAddr(iAddressId).Postcode IS NOT NULL THEN
            -- ignore the 'town/suburb  state  postcode' line
            lCnt := lCnt - 1;
        END IF;

        -- Drop leading lines if the address has more than x address lines
        IF lCnt > iMaxAddrLines THEN
            lOffset := lCnt - iMaxAddrLines;
        END IF;

        CASE lPartKey
            WHEN 'SUB'   THEN lRet := gaFPAddr(iAddressId).TownSuburb;
            WHEN 'STATE' THEN lRet := gaFPAddr(iAddressId).StateCd;
            WHEN 'LOCN'  THEN lRet := gaFPAddr(iAddressId).TownSuburb || k2spaces || gaFPAddr(iAddressId).StateCd;
            WHEN 'PCD'   THEN lRet := gaFPAddr(iAddressId).Postcode;
            ELSE  -- return an address line
                BEGIN
                    IF lPartKey LIKE 'L%' THEN
                        lIdx := SUBSTR (lPartKey, 2) + lOffset;  -- assume the second and subsequent characters are numeric
                        IF lIdx <= lCnt THEN
                            lRet := laAddrLine(lIdx);
                        END IF;
                    END IF;

                EXCEPTION
                    WHEN VALUE_ERROR THEN
                        NULL;
                END;

        END CASE;

        RETURN lRet;

    END getFormattedPart;
    -- end Wr 133668

    --
    --
    --*************************************************************************
    FUNCTION getRawPart(iAddressID1 IN address.addressid%TYPE
                       ,iPartKey    IN VARCHAR2)
    RETURN VARCHAR2
    IS
        --
        l_AddrDetail pkg_Loch.AddressVariables;
        l_PartKey    VARCHAR2(30) := UPPER (iPartKey);
        l_Ret        VARCHAR2(100);

    BEGIN

        l_AddrDetail := pkg_Loch.GetAddrDetails(iAddressID1);

        CASE l_PartKey
            WHEN 'BUILDINGNAME1' THEN l_Ret := l_AddrDetail.BuildingName1;
            WHEN 'BUILDINGNAME2' THEN l_Ret := l_AddrDetail.BuildingName2;
            WHEN 'FLATUNITTYPE' THEN l_Ret := l_AddrDetail.FlatUnitType;
            WHEN 'FLATUNITTYPEABBREV' THEN l_Ret := l_AddrDetail.FlatUnitTypeAbbrev;
            WHEN 'FLATUNITNO' THEN l_Ret := l_AddrDetail.FlatUnitNo;
            WHEN 'FLOORLEVELTYPE' THEN l_Ret := l_AddrDetail.FloorLevelType;
            WHEN 'FLOORLEVELTYPEABBREV' THEN l_Ret := l_AddrDetail.FloorLevelTypeAbbrev;
            WHEN 'FLOORLEVELNO' THEN l_Ret := l_AddrDetail.FloorLevelNo;
            WHEN 'HOUSENO1' THEN l_Ret := l_AddrDetail.HouseNo1;
            WHEN 'HOUSESFX1' THEN l_Ret := l_AddrDetail.HouseSfx1;
            WHEN 'HOUSENO2' THEN l_Ret := l_AddrDetail.HouseNo2;
            WHEN 'HOUSESFX2' THEN l_Ret := l_AddrDetail.HouseSfx2;
            WHEN 'LOTNO' THEN l_Ret := l_AddrDetail.LotNo;
            WHEN 'LOCATIONDESCR' THEN l_Ret := l_AddrDetail.LocationDescr;
            WHEN 'STREETNAME1' THEN l_Ret := l_AddrDetail.StreetName1;
            WHEN 'STREETTYPE1' THEN l_Ret := l_AddrDetail.StreetType1;
            WHEN 'STREETSFX1' THEN l_Ret := l_AddrDetail.StreetSfx1;
            WHEN 'STREETNAME2' THEN l_Ret := l_AddrDetail.StreetName2;
            WHEN 'STREETTYPE2' THEN l_Ret := l_AddrDetail.StreetType2;
            WHEN 'STREETSFX2' THEN l_Ret := l_AddrDetail.StreetSfx2;
            WHEN 'POSTALTYPE' THEN l_Ret := l_AddrDetail.PostalType;
            WHEN 'POSTALNUMBERPFX' THEN l_Ret := l_AddrDetail.PostalNumberPfx;
            WHEN 'POSTALNUMBER' THEN l_Ret := l_AddrDetail.PostalNumber;
            WHEN 'POSTALNUMBERSFX' THEN l_Ret := l_AddrDetail.PostalNumberSfx;
            WHEN 'ADDRESSLINE' THEN l_Ret := l_AddrDetail.AddressLine;
            WHEN 'ADDRESSLINE2' THEN l_Ret := l_AddrDetail.AddressLine2;
            WHEN 'ADDRESSLINE3' THEN l_Ret := l_AddrDetail.AddressLine3;
            WHEN 'SUBURB' THEN l_Ret := l_AddrDetail.Suburb;
            WHEN 'STATE' THEN l_Ret := l_AddrDetail.State;
            WHEN 'STATEABBREV' THEN l_Ret := l_AddrDetail.StateAbbrev;
            WHEN 'POSTCODE' THEN l_Ret := l_AddrDetail.PostCode;
            WHEN 'DPID' THEN l_Ret := l_AddrDetail.DPID;
            ELSE l_Ret := '';
        END CASE;

        RETURN l_Ret;

    END getRawPart;

    --*************************************************************************
    -- SEPI-1357 SE Credit Check's use
    -- Return a delimeter seperated address for the credit checking application
    -- Example:  BuildingName|UnitNumber|StreetNumber|StreetName|StreetType|Suburb|PostCode
    FUNCTION getDelimitedAddress(iAddressID1 IN address.addressid%TYPE
                                ,iDelimiter  IN VARCHAR2)
    RETURN VARCHAR2
    IS
        --
        l_AddrDetail pkg_Loch.AddressVariables;
        l_Delimiter  VARCHAR2(1);
        l_Ret        VARCHAR2(200);
        l_CtryCode   VARCHAR2(2) := '61';

    BEGIN
        IF iAddressID1 IS NULL THEN
          RETURN NULL;
        END IF;

        -- default the delimeter to | (pipe) if none is supplied
        IF iDelimiter IS null THEN
            l_Delimiter := '|';
        ELSE
            l_Delimiter := iDelimiter;
        END IF;

        -- get the address parts
        l_AddrDetail := pkg_Loch.GetAddrDetails(iAddressID1);

        -- build the return string
        -- Building Name
        l_Ret := TRIM(l_AddrDetail.BuildingName1 || l_AddrDetail.BuildingName2) || l_Delimiter;
        -- Flat Number
        l_Ret := l_Ret || TRIM(l_AddrDetail.FlatUnitType || Chr(32) || l_AddrDetail.FlatUnitNo || Chr(32) || l_AddrDetail.FloorLevelType || Chr(32) || l_AddrDetail.FloorLevelNo) ||  l_Delimiter;
        -- Street Number
        l_Ret := l_Ret || TRIM(l_AddrDetail.HouseNo1 || Chr(32) || l_AddrDetail.HouseSfx1 || Chr(32) || l_AddrDetail.LotNo) || l_Delimiter;
        -- Street name
        l_Ret := l_Ret || l_AddrDetail.StreetName1 || l_Delimiter;
        -- Street Type
        l_Ret := l_Ret || TRIM(l_AddrDetail.StreetType1 || Chr(32) || l_AddrDetail.StreetSfx1) || l_Delimiter;
        -- Suburb
        l_Ret := l_Ret || l_AddrDetail.Suburb || l_Delimiter;
        -- State
        l_Ret := l_Ret || l_AddrDetail.StateAbbrev || l_Delimiter;
        -- Postcode
        l_Ret := l_Ret || l_AddrDetail.PostCode || l_Delimiter;
        -- CountryCode
        l_Ret := l_Ret || l_CtryCode;
/*
        CASE l_PartKey
        WHEN 'BUILDINGNAME1' THEN l_Ret := l_AddrDetail.BuildingName1;
        WHEN 'BUILDINGNAME2' THEN l_Ret := l_AddrDetail.BuildingName2;
            WHEN 'FLATUNITTYPE' THEN l_Ret := l_AddrDetail.FlatUnitType;
            WHEN 'FLATUNITTYPEABBREV' THEN l_Ret := l_AddrDetail.FlatUnitTypeAbbrev;
        WHEN 'FLATUNITNO' THEN l_Ret := l_AddrDetail.FlatUnitNo;
            WHEN 'FLOORLEVELTYPE' THEN l_Ret := l_AddrDetail.FloorLevelType;
            WHEN 'FLOORLEVELTYPEABBREV' THEN l_Ret := l_AddrDetail.FloorLevelTypeAbbrev;
            WHEN 'FLOORLEVELNO' THEN l_Ret := l_AddrDetail.FloorLevelNo;
        WHEN 'HOUSENO1' THEN l_Ret := l_AddrDetail.HouseNo1;
        WHEN 'HOUSESFX1' THEN l_Ret := l_AddrDetail.HouseSfx1;
        WHEN 'HOUSENO2' THEN l_Ret := l_AddrDetail.HouseNo2;
        WHEN 'HOUSESFX2' THEN l_Ret := l_AddrDetail.HouseSfx2;
        WHEN 'LOTNO' THEN l_Ret := l_AddrDetail.LotNo;
            WHEN 'LOCATIONDESCR' THEN l_Ret := l_AddrDetail.LocationDescr;
        WHEN 'STREETNAME1' THEN l_Ret := l_AddrDetail.StreetName1;
        WHEN 'STREETTYPE1' THEN l_Ret := l_AddrDetail.StreetType1;
            WHEN 'STREETSFX1' THEN l_Ret := l_AddrDetail.StreetSfx1;
            WHEN 'STREETNAME2' THEN l_Ret := l_AddrDetail.StreetName2;
            WHEN 'STREETTYPE2' THEN l_Ret := l_AddrDetail.StreetType2;
            WHEN 'STREETSFX2' THEN l_Ret := l_AddrDetail.StreetSfx2;
            WHEN 'POSTALTYPE' THEN l_Ret := l_AddrDetail.PostalType;
            WHEN 'POSTALNUMBERPFX' THEN l_Ret := l_AddrDetail.PostalNumberPfx;
            WHEN 'POSTALNUMBER' THEN l_Ret := l_AddrDetail.PostalNumber;
            WHEN 'POSTALNUMBERSFX' THEN l_Ret := l_AddrDetail.PostalNumberSfx;
            WHEN 'ADDRESSLINE' THEN l_Ret := l_AddrDetail.AddressLine;
            WHEN 'ADDRESSLINE2' THEN l_Ret := l_AddrDetail.AddressLine2;
            WHEN 'ADDRESSLINE3' THEN l_Ret := l_AddrDetail.AddressLine3;
        WHEN 'SUBURB' THEN l_Ret := l_AddrDetail.Suburb;
            WHEN 'STATE' THEN l_Ret := l_AddrDetail.State;
            WHEN 'STATEABBREV' THEN l_Ret := l_AddrDetail.StateAbbrev;
        WHEN 'POSTCODE' THEN l_Ret := l_AddrDetail.PostCode;
            WHEN 'DPID' THEN l_Ret := l_AddrDetail.DPID;
            ELSE l_Ret := '';
        END CASE;
*/

        RETURN l_Ret;

    END getDelimitedAddress;
    --
    --
    --*************************************************************************
    FUNCTION CreateQASAddress(iAddrTemplateKey in varchar2
                             ,iData            in varchar2)
                             RETURN pls_integer is

        lTemplate            addresstemplate.addresstemplatekey%type := trim(iAddrTemplateKey);
        lData                varchar2(4096) := iData;
        lAddrId              pls_integer;
        laData               pkg_util.taString;
        lWordCnt             PLS_INTEGER := 0;
        laAPKey              pkg_std.taKey;
        laAPValue            pkg_std.tadescr;
        kDelim               varchar2(01) := '|';

        cursor cTemplate(pTemplate in Addresstemplate.Addresstemplatekey%type)  is
            select apkey
            from   countryap
            where  addresstemplateid = (select addresstemplateid from addresstemplate where addresstemplatekey = pTemplate)
            order  by seq
        ;

    begin

        lWordcnt := Pkg_Util.Words(Ibuf   => lData
                                  ,Isep   => kDelim
                                  ,iTrim => true
                                  ,Oarray => laData);

        open cTemplate(lTemplate);
        fetch cTemplate bulk collect into laAPKey;
        close cTemplate;

        for i in 1..laData.count loop
            laApvalue(i) := trim(laData(i));
        end loop;

        for i in 1..laAPKey.count loop
            dbms_output.put_line(laAPKey(i) || '=' || laApvalue(i));
        end loop;

        pkg_addr.GetAddrId(iAction => null
                          ,iAddressTemplateKey => lTemplate
                          ,iAPKey => laApkey
                          ,iPropValChar => laApvalue
                          ,oAddressId => lAddrId);

--        dbms_output.put_line('Addressid...' || lAddrId);

        return lAddrId;

    end CreateQASAddress;
    
    -- SEPI-24567 -- Get address ID when extract match found for given address detail
    FUNCTION getAddrMatchForDtl (iAddrRec pkg_ws_offercreate.rAddressInfo) 
    RETURN address.addressid%TYPE IS
      
    lRet address.addressid%TYPE := NULL;  
    l_StateOrTerritory dictionarytext.fulltext%TYPE;
    
    BEGIN
        IF  gDebug THEN
            pkg_ws_offercreate.DumpAddrRecord(iAddrRec);
        END IF; 
        
        IF iAddrRec.StateOrTerritory IS NOT NULL THEN
            BEGIN
                SELECT Dt.Fulltext -- Find full text of State field in XML
                INTO   l_StateOrTerritory
                FROM   Dictionarytext Dt
                WHERE  UPPER(Dt.Abbrevtext) = UPPER(Rtrim(iAddrRec.StateOrTerritory));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
        END IF;
        
        FOR i IN (
            SELECT *
            FROM   vw_addressdetail a
            WHERE  UPPER(a.CountryDescr) = UPPER(iAddrRec.Country)
            AND    UPPER(a.stateDescr)   = UPPER(NVL(l_StateOrTerritory,iAddrRec.StateOrTerritory))
            AND    UPPER(a.suburbDescr)  = UPPER(iAddrRec.SuburbOrPlaceOrLocality)
            AND    UPPER(substr(a.subpcDescr,1,4)) = UPPER(iAddrRec.PostCode)
            AND    UPPER(a.strDescr)     = UPPER((CASE WHEN trim(iAddrRec.StreetName1||' '||iAddrRec.StreetType1) IS NOT NULL THEN iAddrRec.StreetName1||' '||iAddrRec.StreetType1
                                                       ELSE iAddrRec.StreetName2||' '||iAddrRec.StreetType2
                                                  END))
            AND    UPPER(NVL(a.PREMNM,'x'))      = UPPER(NVL(iAddrRec.BuildingOrPropertyName1,'x'))
            AND    UPPER(NVL(a.PREMNM2,'x'))     = UPPER(NVL(iAddrRec.BuildingOrPropertyName2,'x'))
            AND    UPPER(NVL(a.FUT,'x'))         = UPPER(NVL(iAddrRec.FlatOrUnitType,'x'))
            AND    UPPER(NVL(a.SPREM,'x'))       = UPPER(NVL(iAddrRec.FlatOrUnitNumber,'x'))
            AND    UPPER(NVL(a.FLT,'x'))         = UPPER(NVL(iAddrRec.FloorOrLevelType,'x'))
            AND    UPPER(NVL(a.FLRLVL,'x'))      = UPPER(NVL(iAddrRec.FloorOrLevelNumber,'x'))
            AND    UPPER(NVL(a.LOTNO,'x'))       = UPPER(NVL(iAddrRec.LotNumber,'x'))
            AND    UPPER(NVL(a.premno,'x'))      = UPPER(NVL(iAddrRec.HouseNumberFROM,'x'))
            AND    UPPER(NVL(a.PREMSFX,'x'))     = UPPER(NVL(iAddrRec.HouseNumberFROMsuffix,'x'))
            AND    UPPER(NVL(a.PREMNO2,'x'))     = UPPER(NVL(iAddrRec.HouseNumberTO,'x'))
            AND    UPPER(NVL(a.PREMSFX2,'x'))    = UPPER(NVL(iAddrRec.HouseNumberTOsuffix,'x'))
            AND    UPPER(NVL(a.POBOXTY,'x'))     = UPPER(NVL(iAddrRec.PostalDeliveryType,'x'))
            AND    UPPER(NVL(a.POBOXP,'x'))      = UPPER(NVL(iAddrRec.PostalDeliveryNumberPrefix,'x'))
            AND    UPPER(NVL(a.POBOX,'x'))       = UPPER(NVL(iAddrRec.PostalDeliveryNumberValue,'x'))
            AND    UPPER(NVL(a.POBOXS,'x'))      = UPPER(NVL(iAddrRec.PostalDeliveryNumberSuffix,'x'))
            AND    UPPER(NVL(a.LOCDESC,'x'))     = UPPER(NVL(iAddrRec.LocationDescriptor,'x'))
            AND    UPPER(NVL(a.DPID,'x'))        = UPPER(NVL(iAddrRec.DeliveryPointIdentifier,'x'))) LOOP
            lRet := i.addressid;
            EXIT;
        END LOOP;
        
        RETURN lRet;
    END getAddrMatchForDtl;
    
    PROCEDURE compareElement (iIdx IN VARCHAR2, iElement1 IN VARCHAR2, iElement2 IN VARCHAR2) IS
    BEGIN
        gAddr(iIdx).Addr1Element := upper(replace(trim(iElement1),' ',''));
        gAddr(iIdx).Addr2Element := upper(replace(trim(iElement2),' ',''));
         
        IF  NVL(gAddr(iIdx).Addr1Element,'x') <> NVL(gAddr(iIdx).Addr2Element,'x') THEN
            gAddr(iIdx).Match := 'N';
        ELSE
            gAddr(iIdx).Match := 'Y';
        END IF; 
    END compareElement;
    
    -- SEPI-25123  Address compare between two addressIDs.
    -- Ignore non-critical address element matches.
    FUNCTION AddrMatch(iAddressID1 IN address.addressid%TYPE
                      ,iAddressID2 IN address.addressid%TYPE
                      ,oMsg        OUT VARCHAR2) RETURN PLS_INTEGER IS
                      
        l_addr1        pkg_loch.AddressVariables;
        l_addr2        pkg_loch.AddressVariables;
        idx            VARCHAR2(50);
        
        lRc            PLS_INTEGER := 0;
    BEGIN
        gAddr.delete;
        
        -- Load critical/non-critical address elements detail for comparison.
        FOR i IN (
            SELECT v.apkey, v.descr, v.Critical
            FROM   vw_addrelement_compare v) LOOP
            idx := i.apkey;
            gAddr(idx).apkey := i.apkey;
            gAddr(idx).descr := i.descr;
            gAddr(idx).critical := i.critical;
        END LOOP;
        
        l_addr1 := pkg_loch.GetAddrDetails(iAddrId => iAddressID1);
        l_addr2 := pkg_loch.GetAddrDetails(iAddrId => iAddressID2);
     
        compareElement('PREMNM', l_addr1.BuildingName1, l_addr2.BuildingName1);
        compareElement('PREMNM2', l_addr1.BuildingName2, l_addr2.BuildingName2);
     
        compareElement('FUT', l_addr1.FlatUnitType, l_addr2.FlatUnitType);
        compareElement('SPREM', l_addr1.FlatUnitNo, l_addr2.FlatUnitNo);
     
        compareElement('FLT', l_addr1.FloorLevelType, l_addr2.FloorLevelType);
        compareElement('FLRLVL', l_addr1.FloorLevelNo, l_addr2.FloorLevelNo);
     
        compareElement('PREMNO', l_addr1.HouseNo1, l_addr2.HouseNo1);
        compareElement('PREMSFX', l_addr1.HouseSfx1, l_addr2.HouseSfx1);
        compareElement('PREMNO2', l_addr1.HouseNo2, l_addr2.HouseNo2);
        compareElement('PREMSFX2', l_addr1.HouseSfx2, l_addr2.HouseSfx2);

        compareElement('LOTNO', l_addr1.LotNo, l_addr2.LotNo);
     
        compareElement('STREETNAME1', l_addr1.StreetName1, l_addr2.StreetName1);
        compareElement('STREETSFX1', l_addr1.StreetSfx1, l_addr2.StreetSfx1);
        compareElement('STREETTYPE1', l_addr1.StreetType1, l_addr2.StreetType1);
     
        compareElement('STREETNAME2', l_addr1.StreetName2, l_addr2.StreetName2);
        compareElement('STREETSFX2', l_addr1.StreetSfx2, l_addr2.StreetSfx2);
        compareElement('STREETTYPE2', l_addr1.StreetType2, l_addr2.StreetType2);
     
        compareElement('ADDRESSLINE', l_addr1.AddressLine, l_addr2.AddressLine);
        compareElement('ADDRESSLINE2', l_addr1.AddressLine2, l_addr2.AddressLine2);
        compareElement('ADDRESSLINE3', l_addr1.AddressLine3, l_addr2.AddressLine3);
     
        compareElement('POBOXTY', l_addr1.PostalType, l_addr2.PostalType);
        compareElement('POBOXP', l_addr1.PostalNumberPfx, l_addr2.PostalNumberPfx);
        compareElement('POBOX', l_addr1.PostalNumber, l_addr2.PostalNumber);
        compareElement('POBOXS', l_addr1.PostalNumberSfx, l_addr2.PostalNumberSfx);
     
        compareElement('LOCDESC', l_addr1.LocationDescr, l_addr2.LocationDescr);
        compareElement('DPID', l_addr1.DPID, l_addr2.DPID);
     
        compareElement('SUBURB', l_addr1.Suburb, l_addr2.Suburb);
        compareElement('STATE', l_addr1.State, l_addr2.State);
        compareElement('POSTCODE', l_addr1.PostCode, l_addr2.PostCode);  

        --compareElement('LOCHADDR', l_addr1.HouseNo1, l_addr2.HouseNo1);
        --compareElement('LOCHPCODE', l_addr1.HouseSfx1, l_addr2.HouseSfx1);
        
        -- When Lot No is found to be in mis-match and House No matches, then make Lot No match 
        -- non-critical.
        IF (l_addr1.HouseNo1 IS NOT NULL OR l_addr2.HouseNo1 IS NOT null) AND
            gAddr('PREMNO').Match = 'Y' THEN
            gAddr('LOTNO').critical := 'N';
        END IF; 
     
        /*IF  gAddr.COUNT > 0 THEN
            dbms_output.put_line(rpad('APKEY',15,' ')||rpad('Descr',35,' ')||rpad('Critical',9,' ')||
                                 rpad(NVL('Element1','~'),35,' ')||rpad(NVL('Element2','~'),35,' ')||'Match');
        END IF;*/ 
     
        idx := gAddr.FIRST;
        
        WHILE idx IS NOT NULL LOOP
            --dbms_output.put_line(rpad(idx,15,' ')||rpad(gAddr(idx).descr,35,' ')||rpad(gAddr(idx).critical,9,' ')||
            --                     rpad(NVL(gAddr(idx).Addr1Element,'~'),35,' ')||rpad(NVL(gAddr(idx).Addr2Element,'~'),35,' ')||gAddr(idx).Match);
                              
            IF  gAddr(idx).critical = 'Y' AND gAddr(idx).Match = 'N' THEN
                oMsg := 'Critical Address mismatch';
                RETURN 8;
            ELSIF gAddr(idx).critical = 'N' AND gAddr(idx).Match = 'N' THEN
                lRc  := 4;
                oMsg := 'Non-Critical Address mismatch';
            END IF; 
            idx := gAddr.NEXT(idx);
        END LOOP;
        
        RETURN lRc;
    END AddrMatch;
     
    -- SEPI-25123  Address compare between an existing address and new addressElements.
    -- Ignore non-critical address element matches.                 
    FUNCTION AddrMatch(iAddressID1 IN address.addressid%TYPE
                      ,iAddressRec IN pkg_ws_offercreate.rAddressInfo
                      ,oMsg        OUT VARCHAR2) RETURN PLS_INTEGER IS
                      
        l_addr         pkg_loch.AddressVariables;
        idx            VARCHAR2(50);
  
        rAddr          pkg_ws_offercreate.rAddressInfo;
        lRc            PLS_INTEGER := 0;
    BEGIN
        gAddr.delete;
        
        l_addr := pkg_loch.GetAddrDetails(iAddrId => iAddressID1);
        rAddr  := iAddressRec;
        
        -- Load critical/non-critical address elements detail for comparison.
        FOR i IN (
            SELECT v.apkey, v.descr, v.Critical
            FROM   vw_addrelement_compare v) LOOP
            idx := i.apkey;
            gAddr(idx).apkey := i.apkey;
            gAddr(idx).descr := i.descr;
            gAddr(idx).critical := i.critical;
        END LOOP;
        
        -- Compare each elements for match
        compareElement('PREMNM', l_addr.BuildingName1, rAddr.BuildingOrPropertyName1);
        compareElement('PREMNM2', l_addr.BuildingName2, rAddr.BuildingOrPropertyName2);
     
        compareElement('FUT', l_addr.FlatUnitType, rAddr.FlatOrUnitType);
        compareElement('SPREM', l_addr.FlatUnitNo, rAddr.FlatOrUnitNumber);
     
        compareElement('FLT', l_addr.FloorLevelType, rAddr.FloorOrLevelType);
        compareElement('FLRLVL', l_addr.FloorLevelNo, rAddr.FloorOrLevelNumber);
     
        compareElement('PREMNO', l_addr.HouseNo1, rAddr.HouseNumberFROM);
        compareElement('PREMSFX', l_addr.HouseSfx1, rAddr.HouseNumberFROMsuffix);
        compareElement('PREMNO2', l_addr.HouseNo2, rAddr.HouseNumberTO);
        compareElement('PREMSFX2', l_addr.HouseSfx2, rAddr.HouseNumberTOsuffix);

        compareElement('LOTNO', l_addr.LotNo, rAddr.LotNumber);
     
        compareElement('STREETNAME1', l_addr.StreetName1, rAddr.StreetName1);
        compareElement('STREETSFX1', l_addr.StreetSfx1, rAddr.StreetSuffix1);
        compareElement('STREETTYPE1', l_addr.StreetType1, rAddr.StreetType1);
     
        compareElement('STREETNAME2', l_addr.StreetName2, rAddr.StreetName2);
        compareElement('STREETSFX2', l_addr.StreetSfx2, rAddr.StreetSuffix2);
        compareElement('STREETTYPE2', l_addr.StreetType2, rAddr.StreetType2);
     
        compareElement('ADDRESSLINE', l_addr.AddressLine, rAddr.AddressLine1);
        compareElement('ADDRESSLINE2', l_addr.AddressLine2, rAddr.AddressLine2);
        compareElement('ADDRESSLINE3', l_addr.AddressLine3, rAddr.AddressLine3);
     
        --compareElement('POBOXTY', l_addr.PostalType, rAddr.PostalDeliveryType);
        --compareElement('POBOXP', l_addr.PostalNumberPfx, rAddr.PostalDeliveryNumberPrefix);
        --compareElement('POBOX', l_addr.PostalNumber, rAddr.PostalDeliveryNumberValue);
        --compareElement('POBOXS', l_addr.PostalNumberSfx, rAddr.PostalDeliveryNumberSuffix);
     
        compareElement('LOCDESC', l_addr.LocationDescr, rAddr.LocationDescriptor);
        compareElement('DPID', l_addr.DPID, rAddr.DeliveryPointIdentifier);
     
        compareElement('SUBURB', l_addr.Suburb, rAddr.SuburbOrPlaceOrLocality);
        
        IF  rAddr.StateOrTerritory IS NOT NULL THEN
            BEGIN
                SELECT Dt.Fulltext
                INTO   rAddr.StateOrTerritory
                FROM   Dictionarytext Dt
                WHERE  UPPER(Dt.Abbrevtext) = UPPER(Rtrim(rAddr.StateOrTerritory));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     NULL;
            END;
        END IF;
        compareElement('STATE', l_addr.State, rAddr.StateOrTerritory);
        compareElement('POSTCODE', l_addr.PostCode, rAddr.PostCode);  

        compareElement('COUNTRY', 'AUSTRALIA', rAddr.Country);
        
        -- When Lot No is found to be in mis-match and House No matches, then make Lot No match 
        -- non-critical.
        IF (l_addr.HouseNo1 IS NOT NULL OR rAddr.HouseNumberFROM IS NOT null) AND
            gAddr('PREMNO').Match = 'Y' THEN
            gAddr('LOTNO').critical := 'N';
        END IF; 
     
        /*IF  gAddr.COUNT > 0 THEN
            dbms_output.put_line(rpad('APKEY',15,' ')||rpad('Descr',35,' ')||rpad('Critical',9,' ')||
                                 rpad(NVL('Element1','~'),35,' ')||rpad(NVL('Element2','~'),35,' ')||'Match');
        END IF;*/
        
        idx := gAddr.FIRST;
        WHILE idx IS NOT NULL LOOP
            --dbms_output.put_line(rpad(idx,15,' ')||rpad(gAddr(idx).descr,35,' ')||rpad(gAddr(idx).critical,9,' ')||
            --                     rpad(NVL(gAddr(idx).Addr1Element,'~'),35,' ')||rpad(NVL(gAddr(idx).Addr2Element,'~'),35,' ')||gAddr(idx).Match);
                              
            IF  gAddr(idx).critical = 'Y' AND gAddr(idx).Match = 'N' THEN
                oMsg := 'Critical Address mismatch';
                RETURN 8;
            ELSIF gAddr(idx).critical = 'N' AND gAddr(idx).Match = 'N' THEN
                lRc  := 4;
                oMsg := 'Non-Critical Address mismatch';
            END IF; 
            idx := gAddr.NEXT(idx);
        END LOOP;
        
        RETURN lRc;
        
    END AddrMatch;
    
    FUNCTION ListEmptyAddrElement(iAddressRec IN  pkg_ws_offercreate.rAddressInfo) RETURN VARCHAR2 IS
        lAddrEmptyElementLst VARCHAR2(3000) := NULL;
        rAddr           pkg_ws_offercreate.rAddressInfo;
    BEGIN
        rAddr := iAddressRec;
        
        -- List incoming address elements
        lAddrEmptyElementLst := NULL;
        IF  rAddr.BuildingOrPropertyName1 IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',PREMNM'; END IF;
        IF  rAddr.BuildingOrPropertyName2 IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',PREMNM2'; END IF; 
        IF  rAddr.FlatOrUnitType IS NULL then lAddrEmptyElementLst := lAddrEmptyElementLst||',FUT'; END IF; 
        IF  rAddr.FlatOrUnitNumber IS NULL then lAddrEmptyElementLst := lAddrEmptyElementLst||',SPREM'; END IF; 
        IF  rAddr.FloorOrLevelType IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',FLT'; END IF; 
        IF  rAddr.FloorOrLevelNumber IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',FLRLVL'; END IF; 
        IF  rAddr.HouseNumberFROM IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',PREMNO'; END IF; 
        IF  rAddr.HouseNumberFROMsuffix IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',PREMSFX'; END IF; 
        IF  rAddr.HouseNumberTO IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',PREMNO2'; END IF; 
        IF  rAddr.HouseNumberTOsuffix IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',PREMSFX2'; END IF; 
        IF  rAddr.LotNumber IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',LOTNO'; END IF; 
        IF  rAddr.StreetName1 IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',STREETNAME1'; END IF; 
        IF  rAddr.StreetSuffix1 IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',STREETSFX1'; END IF; 
        IF  rAddr.StreetType1 IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',STREETTYPE1'; END IF; 
        IF  rAddr.StreetName2 IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',STREETNAME2'; END IF; 
        IF  rAddr.StreetSuffix2 IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',STREETSFX2'; END IF;    
        IF  rAddr.StreetType2 IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',STREETTYPE2'; END IF;      
        IF  rAddr.LocationDescriptor IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',LOCDESC'; END IF; 
        IF  rAddr.DeliveryPointIdentifier IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',DPID'; END IF; 
        IF  rAddr.PostalDeliveryType IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',POBOXTY'; END IF; 
        IF  rAddr.PostalDeliveryNumberPrefix IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',POBOXP'; END IF; 
        IF  rAddr.PostalDeliveryNumberValue IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',POBOX'; END IF; 
        IF  rAddr.PostalDeliveryNumberSuffix IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',POBOXS'; END IF; 
        IF  rAddr.SuburbOrPlaceOrLocality IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',SUBURB'; END IF; 
        IF  rAddr.StateOrTerritory IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',STATE'; END IF; 
        IF  rAddr.PostCode IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',POSTCODE'; END IF; 
        IF  rAddr.Country IS NULL THEN lAddrEmptyElementLst := lAddrEmptyElementLst||',COUNTRY'; END IF; 
        lAddrEmptyElementLst := lAddrEmptyElementLst||',';
        
        RETURN lAddrEmptyElementLst;
    END ListEmptyAddrElement;
    
        FUNCTION ListAddrElement(iAddressRec IN  pkg_ws_offercreate.rAddressInfo) RETURN VARCHAR2 IS
        lAddrElementLst VARCHAR2(3000) := NULL;
        rAddr           pkg_ws_offercreate.rAddressInfo;
    BEGIN
        rAddr := iAddressRec;
        
        -- List incoming address elements
        lAddrElementLst := NULL;
        IF  rAddr.BuildingOrPropertyName1 IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',PREMNM'; END IF;
        IF  rAddr.BuildingOrPropertyName2 IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',PREMNM2'; END IF; 
        IF  rAddr.FlatOrUnitType is not null then lAddrElementLst := lAddrElementLst||',FUT'; END IF; 
        IF  rAddr.FlatOrUnitNumber is not null then lAddrElementLst := lAddrElementLst||',SPREM'; END IF; 
        IF  rAddr.FloorOrLevelType IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',FLT'; END IF; 
        IF  rAddr.FloorOrLevelNumber IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',FLRLVL'; END IF; 
        IF  rAddr.HouseNumberFROM IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',PREMNO'; END IF; 
        IF  rAddr.HouseNumberFROMsuffix IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',PREMSFX'; END IF; 
        IF  rAddr.HouseNumberTO IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',PREMNO2'; END IF; 
        IF  rAddr.HouseNumberTOsuffix IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',PREMSFX2'; END IF; 
        IF  rAddr.LotNumber IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',LOTNO'; END IF; 
        IF  rAddr.StreetName1 IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',STREETNAME1'; END IF; 
        IF  rAddr.StreetSuffix1 IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',STREETSFX1'; END IF; 
        IF  rAddr.StreetType1 IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',STREETTYPE1'; END IF; 
        IF  rAddr.StreetName2 IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',STREETNAME2'; END IF; 
        IF  rAddr.StreetSuffix2 IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',STREETSFX2'; END IF;    
        IF  rAddr.StreetType2 IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',STREETTYPE2'; END IF;      
        IF  rAddr.LocationDescriptor IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',LOCDESC'; END IF; 
        IF  rAddr.DeliveryPointIdentifier IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',DPID'; END IF; 
        IF  rAddr.PostalDeliveryType IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',POBOXTY'; END IF; 
        IF  rAddr.PostalDeliveryNumberPrefix IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',POBOXP'; END IF; 
        IF  rAddr.PostalDeliveryNumberValue IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',POBOX'; END IF; 
        IF  rAddr.PostalDeliveryNumberSuffix IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',POBOXS'; END IF; 
        IF  rAddr.SuburbOrPlaceOrLocality IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',SUBURB'; END IF; 
        IF  rAddr.StateOrTerritory IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',STATE'; END IF; 
        IF  rAddr.PostCode IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',POSTCODE'; END IF; 
        IF  rAddr.Country IS NOT NULL THEN lAddrElementLst := lAddrElementLst||',COUNTRY'; END IF; 
        lAddrElementLst := lAddrElementLst||',';
        
        RETURN lAddrElementLst;
    END ListAddrElement;
    
    
    -- SEPI-25123  Search existing address using incoming address elements.
    -- Ignore non-critical address element during the matches.  
    FUNCTION AddrMatch(iAddressRec IN  pkg_ws_offercreate.rAddressInfo
                      ,iAddrLst    IN  VARCHAR2 DEFAULT NULL
                      ,oRc         OUT pls_integer
                      ,oMsg        OUT VARCHAR2) RETURN PLS_INTEGER IS
                      
        TYPE curtype IS REF CURSOR;
        cAddr curtype;

        idx           VARCHAR2(50);
        lSQL          VARCHAR2(32600);
        lADDRID       address.addressid%TYPE := NULL;
        lAddr         pkg_std.taint;
        lStr          VARCHAR2(100);
        lStr2         VARCHAR2(100);
        lIgnoreLst    VARCHAR2(1000) := ','; 
        lAddrLst      VARCHAR2(300);
        lState        VARCHAR2(40);
        lStreetName   VARCHAR2(300);
        lAddrElement  VARCHAR2(500);
        --lAddrElementLst VARCHAR2(3000);
        lAddrEmptyElementLst VARCHAR2(5000);
  
        rAddr         pkg_ws_offercreate.rAddressInfo;
        lRc           PLS_INTEGER := 0;
        lMsg          VARCHAR2(300);
        
        TYPE rAddrCompare IS RECORD (
             apkey       vw_addrelement_compare.apkey%TYPE,
             descr       vw_addrelement_compare.descr%TYPE,
             seq         vw_addrelement_compare.seq%TYPE,
             Critical    vw_addrelement_compare.Critical%TYPE,
             Addr1Element addresspropertyval.propvalchar%TYPE,
             Addr2Element addresspropertyval.propvalchar%TYPE,
             Match        VARCHAR2(1));
       
        TYPE tAddrCompare IS TABLE OF rAddrCompare INDEX BY VARCHAR2(50);
        gAddr tAddrCompare;
        
    BEGIN
        gAddr.delete; 
        rAddr := iAddressRec;
        
        IF  iAddrLst IS NOT NULL THEN
            lAddrLst := ','||iAddrLst||',';
        END IF;
        
        -- Load address elements..
        FOR i IN (
            SELECT v.apkey, v.descr, v.seq, v.Critical
            FROM   vw_addrelement_compare v) LOOP
            idx := i.apkey;
            gAddr(idx).apkey := i.apkey;
            gAddr(idx).descr := i.descr;
            gAddr(idx).seq   := i.seq;
            gAddr(idx).critical := i.critical;
            
            IF  i.critical = 'N' THEN
                IF  lIgnoreLst IS NULL THEN
                    lIgnoreLst := ','||i.apkey||',';
                ELSE
                    lIgnoreLst := lIgnoreLst ||i.apkey||',';
                END IF;
            END IF; 
        END LOOP;

        -- SEPI-25662 - Make Lot No non critical when House No is known.
        IF  rAddr.LotNumber is not null and 
            rAddr.HouseNumberFROM is not null and 
            gAddr('LOTNO').critical <> 'N' then
            gAddr('LOTNO').critical := 'N';
            
            IF  lIgnoreLst IS NULL THEN
                lIgnoreLst := ',LOTNO,';
            ELSE
                lIgnoreLst := lIgnoreLst ||'LOTNO,';
            END IF;
        END IF; 
        
        -- List incoming address elements
        --lAddrElementLst := ListAddrElement(rAddr);    --SEPI-26819
        lAddrEmptyElementLst := ListEmptyAddrElement(rAddr);
        
        lIgnoreLst := REPLACE(lIgnoreLst ||lAddrEmptyElementLst,',,',',');
        
        lStr := NULL;  
        lStr2 := NULL;     
        lSQL := 'SELECT addressid FROM vw_addressdetail WHERE '; 
            
        idx := gAddr.FIRST;
        
        WHILE idx IS NOT NULL LOOP
            IF  instr(lIgnoreLst,','||idx||',') > 0 THEN
                GOTO NextKey;
            END IF;
            
            CASE idx 
                 WHEN 'PREMNM' THEN 
                      IF  rAddr.BuildingOrPropertyName1 IS NOT NULL THEN
                          IF  instr(rAddr.BuildingOrPropertyName1,CHR(39)) > 0 THEN
                              lAddrElement := REPLACE(rAddr.BuildingOrPropertyName1,CHR(39),'');
                              lSQL := lSQL ||' UPPER('||REPLACE(idx,CHR(39),'''')||') =  UPPER('''||lAddrElement||''') AND ';
                          ELSE
                              lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.BuildingOrPropertyName1||''') AND ';
                          END IF; 
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF; 
                 WHEN 'PREMNM2' THEN 
                      IF  rAddr.BuildingOrPropertyName2 IS NOT NULL THEN
                          IF  instr(rAddr.BuildingOrPropertyName2,CHR(39)) > 0 THEN
                              lAddrElement := REPLACE(rAddr.BuildingOrPropertyName2,CHR(39),'');
                              lSQL := lSQL ||' UPPER('||REPLACE(idx,CHR(39),'''')||') =  UPPER('''||lAddrElement||''') AND ';
                          ELSE
                              lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.BuildingOrPropertyName2||''') AND ';
                          END IF; 
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF; 
                 WHEN 'FUT'  THEN
                      IF  rAddr.FlatOrUnitType IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.FlatOrUnitType||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF; 
                 WHEN 'SPREM' THEN
                      IF  rAddr.FlatOrUnitNumber IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.FlatOrUnitNumber||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'FLT' THEN 
                      IF  rAddr.FloorOrLevelType IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.FloorOrLevelType||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'FLRLVL' THEN
                      IF  rAddr.FloorOrLevelNumber IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.FloorOrLevelNumber||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'PREMNO' THEN 
                      IF  rAddr.HouseNumberFROM IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.HouseNumberFROM||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'PREMSFX' THEN
                      IF  rAddr.HouseNumberFROMsuffix IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.HouseNumberFROMsuffix||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'PREMNO2' THEN
                      IF  rAddr.HouseNumberTO IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.HouseNumberTO||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'PREMSFX2' THEN
                      IF  rAddr.HouseNumberTOsuffix IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.HouseNumberTOsuffix||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'LOTNO' THEN
                      IF  rAddr.LotNumber IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.LotNumber||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'STREETNAME1' THEN
                      IF  rAddr.StreetName1 IS NOT NULL THEN
                          lStr := lStr ||rAddr.StreetName1;
                      END IF; 
                 WHEN 'STREETSFX1' THEN           
                      IF  rAddr.StreetSuffix1 IS NOT NULL THEN
                          lStr := lStr||' '||rAddr.StreetSuffix1;
                      END IF; 
                 WHEN 'STREETTYPE1' THEN
                      IF  rAddr.StreetType1 IS NOT NULL THEN
                          lStr := lStr||' '||rAddr.StreetType1;
                      END IF;
                 WHEN 'STREETNAME2' THEN           
                      IF  rAddr.StreetName2 IS NOT NULL THEN
                          lStr2 := lStr2||rAddr.StreetName2;
                      END IF;
                 WHEN 'STREETSFX2' THEN          
                      IF  rAddr.StreetSuffix2 IS NOT NULL THEN
                          lStr2 := lStr2||' '||rAddr.StreetSuffix2;
                      END IF; 
                 WHEN 'STREETTYPE2' THEN              
                      IF  rAddr.StreetType2 IS NOT NULL THEN
                          lStr2 := lStr2||' '||rAddr.StreetType2;
                      END IF;  
                 WHEN 'LOCDESC' THEN
                      IF  rAddr.LocationDescriptor IS NOT NULL THEN
                          IF  instr(rAddr.LocationDescriptor,CHR(39)) > 0 THEN
                              lAddrElement := REPLACE(rAddr.LocationDescriptor,CHR(39),'');
                              lSQL := lSQL ||' UPPER('||REPLACE(idx,CHR(39),'''')||') =  UPPER('''||lAddrElement||''') AND ';
                          ELSE
                              lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.LocationDescriptor||''') AND ';
                          END IF; 
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'DPID' THEN 
                      IF  rAddr.DeliveryPointIdentifier IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.DeliveryPointIdentifier||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'POBOXTY' THEN 
                      IF  rAddr.PostalDeliveryType IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.PostalDeliveryType||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'POBOXP' THEN 
                      IF  rAddr.PostalDeliveryNumberPrefix IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.PostalDeliveryNumberPrefix||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'POBOX' THEN
                      IF  rAddr.PostalDeliveryNumberValue IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.PostalDeliveryNumberValue||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'POBOXS' THEN 
                      IF  rAddr.PostalDeliveryNumberSuffix IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER('||idx||') =  UPPER('''||rAddr.PostalDeliveryNumberSuffix||''') AND ';
                      ELSE
                          lSQL := lSQL ||idx||' IS NULL AND ';
                      END IF;
                 WHEN 'SUBURB' THEN 
                      IF  rAddr.SuburbOrPlaceOrLocality IS NOT NULL THEN
                          IF  instr(rAddr.SuburbOrPlaceOrLocality,CHR(39)) > 0 THEN
                              lAddrElement := REPLACE(rAddr.SuburbOrPlaceOrLocality,CHR(39),'');
                              lSQL := lSQL ||' UPPER(REPLACE(SUBURBDESCR,CHR(39),'''')) =  UPPER('''||lAddrElement||''') AND ';
                          ELSE
                              lSQL := lSQL ||' UPPER(SUBURBDESCR) =  UPPER('''||rAddr.SuburbOrPlaceOrLocality||''') AND ';
                          END IF; 
                      ELSE
                          lSQL := lSQL ||' SUBURBDESCR IS NULL AND ';
                      END IF;
                 WHEN 'STATE' THEN
                      IF  rAddr.StateOrTerritory IS NOT NULL THEN  
                          lState := rAddr.StateOrTerritory;                                                   
                          BEGIN
                              SELECT Dt.Fulltext 
                              INTO   lState
                              FROM   Dictionarytext Dt
                              WHERE  UPPER(Dt.Abbrevtext) = UPPER(Rtrim(lState));
                          EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                   NULL;
                          END;

                          lSQL := lSQL ||' UPPER(STATEDESCR) =  UPPER('''||lState||''') AND ';
                      ELSE
                          lSQL := lSQL ||' STATEDESCR IS NULL AND ';
                      END IF;
                 WHEN 'POSTCODE' THEN
                      IF  rAddr.PostCode IS NOT NULL THEN
                          lSQL := lSQL ||' SUBSTR(SUBPCDESCR,1,4) =  '''||rAddr.PostCode||''' AND ';
                      ELSE
                          lSQL := lSQL ||' SUBSTR(SUBPCDESCR,1,4) IS NULL AND ';
                      END IF; 
                 WHEN 'COUNTRY' THEN 
                      IF  rAddr.Country IS NOT NULL THEN
                          lSQL := lSQL ||' UPPER(COUNTRYDESCR) =  UPPER('''||rAddr.Country||''') AND ';
                      ELSE
                          lSQL := lSQL ||' UPPER(COUNTRYDESCR) = ''AUSTRALIA'' AND ';
                      END IF; 
                 ELSE NULL;
            END  CASE;  
                              
            <<NextKey>>
            
            idx := gAddr.NEXT(idx);
        END LOOP;
        
        IF  TRIM(lStr) IS NOT NULL THEN
            IF  instr(lStr,CHR(39)) > 0 OR instr(rAddr.StreetName1,CHR(39)) > 0 THEN
                lStr := REPLACE(lStr,CHR(39),'');
                lStreetName := REPLACE(rAddr.StreetName1,CHR(39),'');
                    
                IF  instr(lIgnoreLst,',STREETTYPE1,') > 0 AND 
                    instr(lIgnoreLst,',STREETSFX1,') > 0 THEN
                    lSQL := lSQL ||' UPPER(REPLACE(STRDESCR,CHR(39),'''')) LIKE  UPPER('''||lStreetName||''')||''%'' AND ';--SEPI-27251 
                ELSIF instr(lIgnoreLst,',STREETSFX1,') > 0  THEN  
                    lSQL := lSQL ||' UPPER(REPLACE(STRDESCR,CHR(39),'''')) LIKE  UPPER('''||lStreetName||'%'||rAddr.StreetType1||''') AND ';
                ELSIF instr(lIgnoreLst,',STREETTYPE1,') > 0  THEN  
                    lSQL := lSQL ||' UPPER(REPLACE(STRDESCR,CHR(39),'''')) LIKE  UPPER('''||lStreetName||' '||rAddr.StreetSuffix1||''')||''%'' AND ';
                ELSE
                    lSQL := lSQL ||' UPPER(REPLACE(STRDESCR,CHR(39),'''')) = UPPER('''||lStr||''') AND ';
                END IF; 
            ELSE
                IF  instr(lIgnoreLst,',STREETTYPE1,') > 0 AND 
                    instr(lIgnoreLst,',STREETSFX1,') > 0 THEN
                    lSQL := lSQL ||' UPPER(STRDESCR) LIKE  UPPER('''||rAddr.StreetName1||''')||''%'' AND ';
                ELSIF instr(lIgnoreLst,',STREETSFX1,') > 0  THEN  
                    lSQL := lSQL ||' UPPER(STRDESCR) LIKE  UPPER('''||rAddr.StreetName1||'%'||rAddr.StreetType1||''') AND ';
                ELSIF instr(lIgnoreLst,',STREETTYPE1,') > 0  THEN  
                    lSQL := lSQL ||' UPPER(STRDESCR) LIKE  UPPER('''||rAddr.StreetName1||' '||rAddr.StreetSuffix1||''')||''%'' AND ';
                ELSE
                    lSQL := lSQL ||' UPPER(STRDESCR) = UPPER('''||lStr||''') AND ';
                END IF; 
            END IF;
        ELSIF TRIM(lStr2) IS NOT NULL THEN
            IF  instr(lStr2,CHR(39)) > 0 OR instr(rAddr.StreetName2,CHR(39)) > 0 THEN
                lStr2 := REPLACE(lStr2,CHR(39),'');
                lStreetName := REPLACE(rAddr.StreetName2,CHR(39),'');
                IF  instr(lIgnoreLst,',STREETTYPE2,') > 0 AND 
                    instr(lIgnoreLst,',STREETSFX2,') > 0 THEN
                    lSQL := lSQL ||' UPPER(REPLACE(STRDESCR,CHR(39),'''')) LIKE  UPPER('''||lStreetName||''')||''%'' AND ';
                ELSIF instr(lIgnoreLst,',STREETSFX2,') > 0  THEN  
                    lSQL := lSQL ||' UPPER(REPLACE(STRDESCR,CHR(39),'''')) LIKE  UPPER('''||lStreetName||'%'||rAddr.StreetType2||''') AND ';
                ELSIF instr(lIgnoreLst,',STREETTYPE2,') > 0  THEN  
                    lSQL := lSQL ||' UPPER(REPLACE(STRDESCR,CHR(39),'''')) LIKE  UPPER('''||lStreetName||' '||rAddr.StreetSuffix2||''')||''%'' AND ';
                ELSE
                    lSQL := lSQL ||' UPPER(REPLACE(STRDESCR,CHR(39),'''')) = UPPER('''||lStr2||''') AND ';
                END IF; 
            ELSE
                IF  instr(lIgnoreLst,',STREETTYPE2,') > 0 AND 
                    instr(lIgnoreLst,',STREETSFX2,') > 0 THEN
                    lSQL := lSQL ||' UPPER(STRDESCR) LIKE  UPPER('''||rAddr.StreetName2||''')||''%'' AND ';
                ELSIF instr(lIgnoreLst,',STREETSFX2,') > 0  THEN  
                    lSQL := lSQL ||' UPPER(STRDESCR) LIKE  UPPER('''||rAddr.StreetName2||'%'||rAddr.StreetType2||''') AND ';
                ELSIF instr(lIgnoreLst,',STREETTYPE2,') > 0  THEN  
                    lSQL := lSQL ||' UPPER(STRDESCR) LIKE  UPPER('''||rAddr.StreetName2||' '||rAddr.StreetSuffix2||''')||''%'' AND ';
                ELSE
                    lSQL := lSQL ||' UPPER(STRDESCR) = UPPER('''||lStr2||''') AND ';
                END IF; 
            END IF;
        ELSE
            lSQL := lSQL ||' STRDESCR IS NULL AND '; 
        END IF;  
        
        lSQL := SUBSTR(lSQL,1,LENGTH(lSQL) - 5);
        
        OPEN cAddr FOR lSQL;
        FETCH cAddr BULK COLLECT INTO lAddr;
        CLOSE cAddr;
        
        IF  lAddr.COUNT > 0 THEN
            IF  lAddr.COUNT = 1 THEN
                RETURN lAddr(1);              
            ELSE
                -- Check whether the selected address matches to incoming address list
                IF  lAddrLst IS NOT NULL THEN
                    FOR i IN 1 .. lAddr.COUNT LOOP
                        IF  lAddr(i) IS NOT NULL AND
                            instr(lAddrLst,lAddr(i)) > 0 THEN
                            -- When found address is matches to the incoming list, select that address.
                            oRc  := lRc;
                            oMsg := REPLACE(lMsg,',]',']');
                            RETURN lAddr(i); 
                        END IF; 
                    END LOOP;
                END IF;
                        
                -- IF No address match found with lAddrLst, redo the check without comparing lAddrLst value
                FOR i IN 1 .. lAddr.COUNT LOOP
                    IF  pkg_addr.AddrMatch(lAddr(i), iAddressRec, lMsg) <> 8 THEN
                        RETURN lAddr(i);
                    END IF;
                END LOOP;
            END IF;
        END IF;
        
        RETURN lAddrID;
    END AddrMatch;

    ------------------------------------------------------------------------------------------------------
    -- SEPI-26819 / SEPI-26820 Do address matching using table function
    FUNCTION AddrMatch_TF(iAddressRec IN  pkg_ws_offercreate.rAddressInfo
                      ,iAddrLst    IN  VARCHAR2 DEFAULT NULL
                      ,oRc         OUT pls_integer
                      ,oMsg        OUT VARCHAR2) RETURN PLS_INTEGER IS

        idx           VARCHAR2(50);
        lADDRID       address.addressid%TYPE := NULL;
        lStr          VARCHAR2(100);
        lStr2         VARCHAR2(100);
        lIgnoreLst    VARCHAR2(1000) := ','; 
        lAddrLst      VARCHAR2(300);
        lState        VARCHAR2(40);
        lStreetName   VARCHAR2(300);
        lAddrElement  VARCHAR2(500);

        lBuildingOrPropertyName1         VARCHAR2(100);
        lBuildingOrPropertyName2         VARCHAR2(100);
        lFlatOrUnitType                  VARCHAR2(100);
        lFlatOrUnitNumber                VARCHAR2(100);
        lFloorOrLevelType                VARCHAR2(100);
        lFloorOrLevelNumber              VARCHAR2(100);
        lHouseNumberFROM                 VARCHAR2(100);
        lHouseNumberFROMsuffix           VARCHAR2(100);
        lHouseNumberTO                   VARCHAR2(100);
        lHouseNumberTOsuffix             VARCHAR2(100);
        lLotNumber                       VARCHAR2(100);
        lLocationDescriptor              VARCHAR2(100);
        lDPID                            VARCHAR2(100);
        lPostalDeliveryType              VARCHAR2(100);
        lPostalDeliveryNumberPrefix      VARCHAR2(100);
        lPostalDeliveryNumberValue       VARCHAR2(100);
        lPostalDeliveryNumberSuffix      VARCHAR2(100);
        lSuburbOrPlaceOrLocality         VARCHAR2(100);
        lPostCode                        VARCHAR2(100);
        lCountry                         VARCHAR2(100);
        lAddrElementLst                  VARCHAR2(4000);
          
        rAddr         pkg_ws_offercreate.rAddressInfo;
        lRc           PLS_INTEGER := 0;
        lMsg          VARCHAR2(300);
        
        TYPE rAddrCompare IS RECORD (
             apkey       vw_addrelement_compare.apkey%TYPE,
             descr       vw_addrelement_compare.descr%TYPE,
             seq         vw_addrelement_compare.seq%TYPE,
             Critical    vw_addrelement_compare.Critical%TYPE,
             Addr1Element addresspropertyval.propvalchar%TYPE,
             Addr2Element addresspropertyval.propvalchar%TYPE,
             Match        VARCHAR2(1));
       
        TYPE tAddrCompare IS TABLE OF rAddrCompare INDEX BY VARCHAR2(50);
        gAddr tAddrCompare;
        
    BEGIN
        gAddr.delete; 
        rAddr := iAddressRec;
        lAddrLst := ','||iAddrLst||',';
        
        -- Load address elements..
        FOR i IN (
            SELECT v.apkey, v.descr, v.seq, v.Critical
            FROM   vw_addrelement_compare v) LOOP
            idx := i.apkey;
            gAddr(idx).apkey := i.apkey;
            gAddr(idx).descr := i.descr;
            gAddr(idx).seq   := i.seq;
            gAddr(idx).critical := i.critical;
        END LOOP;

        -- SEPI-25662 - Make Lot No non critical when House No is known.
        IF  rAddr.LotNumber is not null and 
            rAddr.HouseNumberFROM is not null and 
            gAddr('LOTNO').critical <> 'N' then
            gAddr('LOTNO').critical := 'N';
        END IF; 

        -- List incoming address elements
        lAddrElementLst := ListAddrElement(rAddr);
        
        FOR i IN (
            -- Load non-critical address elements to remove from address query
            SELECT 'ALL' apkey, 0 seq FROM dual
            UNION   
            SELECT v.apkey , v.seq
            FROM   vw_addrelement_compare v
            WHERE  v.seq IS NOT NULL
            AND    v.Critical = 'N'
            AND    v.apkey NOT IN ('ADDRESSLINE','ADDRESSLINE2','ADDRESSLINE3')
            AND    EXISTS (
                   SELECT 1
                   FROM   dual 
                   WHERE  INSTR(lAddrElementLst,','||v.apkey||',') > 0)
            UNION
            -- Make Lot No non critical when House No is known. -- SEPI-25662
            SELECT v.apkey , NVL(v.seq,99)
            FROM   vw_addrelement_compare v
            WHERE  v.apkey = 'LOTNO'
            AND    rAddr.LotNumber IS NOT NULL
            AND    rAddr.HouseNumberFROM IS NOT NULL
            ORDER  BY 2) LOOP
            
            lIgnoreLst := lIgnoreLst||i.apkey||',';
            
            --Intialize local variables.
            lState                       := NULL;
            lStreetName                  := NULL;
            lBuildingOrPropertyName1     := NULL;
            lBuildingOrPropertyName2     := NULL;
            lFlatOrUnitType              := NULL;
            lFlatOrUnitNumber            := NULL;
            lFloorOrLevelType            := NULL;
            lFloorOrLevelNumber          := NULL;
            lHouseNumberFROM             := NULL;
            lHouseNumberFROMsuffix       := NULL;
            lHouseNumberTO               := NULL;
            lHouseNumberTOsuffix         := NULL;
            lLotNumber                   := NULL;
            lLocationDescriptor          := NULL;
            lDPID                        := NULL;
            lPostalDeliveryType          := NULL;
            lPostalDeliveryNumberPrefix  := NULL;
            lPostalDeliveryNumberValue   := NULL;
            lPostalDeliveryNumberSuffix  := NULL;
            lSuburbOrPlaceOrLocality     := NULL;
            lPostCode                    := NULL;
            lCountry                     := NULL;
            lStr := NULL;  
            lStr2 := NULL;     
            
            idx := gAddr.FIRST;
            
            WHILE idx IS NOT NULL LOOP
                IF  instr(lIgnoreLst,','||idx||',') > 0 THEN
                    lRc  := 4;
                    lMsg := 'Non-critical address elements ['||REPLACE(lIgnoreLst,',ALL,','')||'] ignored';
                    GOTO NextKey;
                END IF;
                
                CASE idx 
                    WHEN 'PREMNM' THEN 
                         IF  rAddr.BuildingOrPropertyName1 IS NOT NULL THEN
                             IF  instr(rAddr.BuildingOrPropertyName1,CHR(39)) > 0 THEN
                                 lBuildingOrPropertyName1 := UPPER(REPLACE(rAddr.BuildingOrPropertyName1,CHR(39),''));
                             ELSE
                                 lBuildingOrPropertyName1 := UPPER(rAddr.BuildingOrPropertyName1);
                             END IF; 
                         ELSE
                             lBuildingOrPropertyName1 := NULL;
                         END IF;  
                    WHEN 'PREMNM2' THEN 
                         IF  rAddr.BuildingOrPropertyName2 IS NOT NULL THEN
                             IF  instr(rAddr.BuildingOrPropertyName2,CHR(39)) > 0 THEN
                                 lBuildingOrPropertyName2 := UPPER(REPLACE(rAddr.BuildingOrPropertyName2,CHR(39),''));
                             ELSE
                                 lBuildingOrPropertyName2 := UPPER(rAddr.BuildingOrPropertyName2);
                             END IF; 
                         ELSE
                             lBuildingOrPropertyName2 := NULL;
                         END IF;  
                    WHEN 'FUT'  THEN
                         IF  rAddr.FlatOrUnitType IS NOT NULL THEN
                             lFlatOrUnitType := UPPER(rAddr.FlatOrUnitType);
                         ELSE
                             lFlatOrUnitType := NULL;
                         END IF; 
                    WHEN 'SPREM' THEN
                         IF  rAddr.FlatOrUnitNumber IS NOT NULL THEN
                             lFlatOrUnitNumber := UPPER(rAddr.FlatOrUnitNumber);
                         ELSE
                             lFlatOrUnitNumber := NULL;
                         END IF;
                    WHEN 'FLT' THEN 
                         IF  rAddr.FloorOrLevelType IS NOT NULL THEN
                             lFloorOrLevelType := UPPER(rAddr.FloorOrLevelType);
                         ELSE
                             lFloorOrLevelType := NULL;
                         END IF;
                    WHEN 'FLRLVL' THEN
                         IF  rAddr.FloorOrLevelNumber IS NOT NULL THEN
                             lFloorOrLevelNumber := UPPER(rAddr.FloorOrLevelNumber);
                         ELSE
                             lFloorOrLevelNumber := NULL;
                         END IF;

                    WHEN 'PREMNO' THEN 
                         IF  rAddr.HouseNumberFROM IS NOT NULL THEN
                             lHouseNumberFROM := UPPER(rAddr.HouseNumberFROM);
                         ELSE
                             lHouseNumberFROM := NULL;
                         END IF;
                    WHEN 'PREMSFX' THEN
                         IF  rAddr.HouseNumberFROMsuffix IS NOT NULL THEN
                             lHouseNumberFROMsuffix := UPPER(rAddr.HouseNumberFROMsuffix);
                         ELSE
                             lHouseNumberFROMsuffix := NULL;
                         END IF;
                    WHEN 'PREMNO2' THEN
                         IF  rAddr.HouseNumberTO IS NOT NULL THEN
                             lHouseNumberTO := UPPER(rAddr.HouseNumberTO);
                         ELSE
                             lHouseNumberTO := NULL;
                         END IF;
                    WHEN 'PREMSFX2' THEN
                         IF  rAddr.HouseNumberTOsuffix IS NOT NULL THEN
                             lHouseNumberTOsuffix := UPPER(rAddr.HouseNumberTOsuffix);
                         ELSE
                             lHouseNumberTOsuffix := NULL;
                         END IF;
                    WHEN 'LOTNO' THEN
                         IF  rAddr.LotNumber IS NOT NULL THEN
                             lLotNumber := UPPER(rAddr.LotNumber);
                         ELSE
                             lLotNumber := NULL;
                         END IF;
                    WHEN 'STREETNAME1' THEN
                         IF  rAddr.StreetName1 IS NOT NULL THEN
                             lStr := lStr ||rAddr.StreetName1;
                         END IF; 
                    WHEN 'STREETSFX1' THEN           
                         IF  rAddr.StreetSuffix1 IS NOT NULL THEN
                             lStr := lStr||' '||rAddr.StreetSuffix1;
                         END IF; 
                    WHEN 'STREETTYPE1' THEN
                         IF  rAddr.StreetType1 IS NOT NULL THEN
                             lStr := lStr||' '||rAddr.StreetType1;
                         END IF;
                    WHEN 'STREETNAME2' THEN           
                         IF  rAddr.StreetName2 IS NOT NULL THEN
                             lStr2 := lStr2||rAddr.StreetName2;
                         END IF;
                    WHEN 'STREETSFX2' THEN          
                         IF  rAddr.StreetSuffix2 IS NOT NULL THEN
                             lStr2 := lStr2||' '||rAddr.StreetSuffix2;
                         END IF; 
                    WHEN 'STREETTYPE2' THEN              
                         IF  rAddr.StreetType2 IS NOT NULL THEN
                             lStr2 := lStr2||' '||rAddr.StreetType2;
                         END IF;  

                    WHEN 'LOCDESC' THEN
                         IF  rAddr.LocationDescriptor IS NOT NULL THEN
                             IF  instr(rAddr.LocationDescriptor,CHR(39)) > 0 THEN
                                 lLocationDescriptor := UPPER(REPLACE(rAddr.LocationDescriptor,CHR(39),''));
                             ELSE
                                 lLocationDescriptor := UPPER(rAddr.LocationDescriptor);
                             END IF; 
                         ELSE
                             lLocationDescriptor := NULL;
                         END IF;
                    WHEN 'DPID' THEN 
                         IF  rAddr.DeliveryPointIdentifier IS NOT NULL THEN
                             lDPID := UPPER(rAddr.DeliveryPointIdentifier);
                         ELSE
                             lDPID := NULL;
                         END IF;
                    WHEN 'POBOXTY' THEN 
                         IF  rAddr.PostalDeliveryType IS NOT NULL THEN
                             lPostalDeliveryType := UPPER(rAddr.PostalDeliveryType);
                         ELSE
                             lPostalDeliveryType := NULL;
                         END IF;
                    WHEN 'POBOXP' THEN 
                         IF  rAddr.PostalDeliveryNumberPrefix IS NOT NULL THEN
                             lPostalDeliveryNumberPrefix := UPPER(rAddr.PostalDeliveryNumberPrefix);
                         ELSE
                             lPostalDeliveryNumberPrefix := NULL;
                         END IF;
                    WHEN 'POBOX' THEN
                         IF  rAddr.PostalDeliveryNumberValue IS NOT NULL THEN
                             lPostalDeliveryNumberValue := UPPER(rAddr.PostalDeliveryNumberValue);
                         ELSE
                             lPostalDeliveryNumberValue := NULL;
                         END IF;
                    WHEN 'POBOXS' THEN 
                         IF  rAddr.PostalDeliveryNumberSuffix IS NOT NULL THEN
                             lPostalDeliveryNumberSuffix := UPPER(rAddr.PostalDeliveryNumberSuffix);
                         ELSE
                             lPostalDeliveryNumberSuffix := NULL;
                         END IF;
                    WHEN 'SUBURB' THEN 
                         IF  rAddr.SuburbOrPlaceOrLocality IS NOT NULL THEN
                             IF  instr(rAddr.SuburbOrPlaceOrLocality,CHR(39)) > 0 THEN
                                 lAddrElement := REPLACE(rAddr.SuburbOrPlaceOrLocality,CHR(39),'');
                                 lSuburbOrPlaceOrLocality := UPPER(REPLACE(rAddr.SuburbOrPlaceOrLocality,CHR(39),''));
                             ELSE
                                 lSuburbOrPlaceOrLocality := UPPER(rAddr.SuburbOrPlaceOrLocality);
                             END IF; 
                         ELSE
                             lSuburbOrPlaceOrLocality := NULL;
                         END IF;
                    WHEN 'STATE' THEN
                         IF  rAddr.StateOrTerritory IS NOT NULL THEN  
                             lState := rAddr.StateOrTerritory;                                                   
                             BEGIN
                                 SELECT Dt.Fulltext 
                                 INTO   lState
                                 FROM   Dictionarytext Dt
                                 WHERE  UPPER(Dt.Abbrevtext) = UPPER(Rtrim(lState));
                             EXCEPTION
                                 WHEN NO_DATA_FOUND THEN
                                      NULL;
                             END;

                             lState := UPPER(lState);
                         ELSE
                             lState := NULL;
                         END IF;

                    WHEN 'POSTCODE' THEN
                         IF  rAddr.PostCode IS NOT NULL THEN
                             lPostCode := rAddr.PostCode;
                         ELSE
                             lPostCode := NULL;
                         END IF; 
                    WHEN 'COUNTRY' THEN 
                         IF  rAddr.Country IS NOT NULL THEN
                             lCountry := UPPER(rAddr.Country);
                         ELSE
                             lCountry := 'AUSTRALIA';
                         END IF; 
                    ELSE NULL;
                END CASE;                
                <<NextKey>>
                idx := gAddr.NEXT(idx);
            END LOOP;
            
            IF  TRIM(lStr) IS NOT NULL THEN
                IF  instr(lStr,CHR(39)) > 0 OR instr(rAddr.StreetName1,CHR(39)) > 0 THEN
                    lStr := REPLACE(lStr,CHR(39),'');
                    lStreetName := REPLACE(rAddr.StreetName1,CHR(39),'');
                    
                    IF  instr(lIgnoreLst,',STREETTYPE1,') > 0 AND 
                        instr(lIgnoreLst,',STREETSFX1,') > 0 THEN
                        lStreetName := UPPER(lStreetName)||'%';
                    ELSIF instr(lIgnoreLst,',STREETSFX1,') > 0  THEN  
                        lStreetName := UPPER(lStreetName||'%'||rAddr.StreetType1);
                    ELSIF instr(lIgnoreLst,',STREETTYPE1,') > 0  THEN  
                        lStreetName := UPPER(lStreetName||' '||rAddr.StreetSuffix1||'%');
                    ELSE
                        lStreetName := UPPER(lStr);
                    END IF; 
                ELSE
                    IF  instr(lIgnoreLst,',STREETTYPE1,') > 0 AND 
                        instr(lIgnoreLst,',STREETSFX1,') > 0 THEN
                        lStreetName := UPPER(rAddr.StreetName1)||'%';
                    ELSIF instr(lIgnoreLst,',STREETSFX1,') > 0  THEN  
                        lStreetName := UPPER(rAddr.StreetName1||'%'||rAddr.StreetType1);
                    ELSIF instr(lIgnoreLst,',STREETTYPE1,') > 0  THEN  
                        lStreetName := UPPER(rAddr.StreetName1||' '||rAddr.StreetSuffix1||'%');
                    ELSE
                        lStreetName := UPPER(lStr);
                    END IF; 
                END IF;
            ELSIF TRIM(lStr2) IS NOT NULL THEN
                IF  instr(lStr2,CHR(39)) > 0 OR instr(rAddr.StreetName2,CHR(39)) > 0 THEN
                    lStr2 := REPLACE(lStr2,CHR(39),'');
                    lStreetName := REPLACE(rAddr.StreetName2,CHR(39),'');
                    IF  instr(lIgnoreLst,',STREETTYPE2,') > 0 AND 
                        instr(lIgnoreLst,',STREETSFX2,') > 0 THEN
                        lStreetName := UPPER(lStreetName)||'%';
                    ELSIF instr(lIgnoreLst,',STREETSFX2,') > 0  THEN  
                        lStreetName := UPPER(lStreetName||'%'||rAddr.StreetType2);
                    ELSIF instr(lIgnoreLst,',STREETTYPE2,') > 0  THEN  
                        lStreetName := UPPER(lStreetName||' '||rAddr.StreetSuffix2||'%');
                    ELSE
                        lStreetName := UPPER(lStr2);
                    END IF; 
                ELSE
                    IF  instr(lIgnoreLst,',STREETTYPE2,') > 0 AND 
                        instr(lIgnoreLst,',STREETSFX2,') > 0 THEN
                        lStreetName := UPPER(rAddr.StreetName2)||'%';
                    ELSIF instr(lIgnoreLst,',STREETSFX2,') > 0  THEN  
                        lStreetName := UPPER(rAddr.StreetName2||'%'||rAddr.StreetType2);
                    ELSIF instr(lIgnoreLst,',STREETTYPE2,') > 0  THEN  
                        lStreetName := UPPER(rAddr.StreetName2||' '||rAddr.StreetSuffix2||'%');
                    ELSE
                        lStreetName := UPPER(lStr2);
                    END IF; 
                END IF;
            ELSE
                lStreetName := NULL;
            END IF;  
                        
            FOR  i IN (
                 SELECT addressid 
                 FROM   TABLE(pkg_addr.ADDRESSDETAIL(
                        iSTATEDESCR  => lState,
                        iSUBURBDESCR => lSuburbOrPlaceOrLocality,
                        iSUBPCDESCR  => lPostCode||' '||lSuburbOrPlaceOrLocality,
                        iSTRDESCR    => lStreetName,
                        iPREMNM      => lBuildingOrPropertyName1,
                        iPREMNM2     => lBuildingOrPropertyName2,
                        iFUT         => lFlatOrUnitType,
                        iSPREM       => lFlatOrUnitNumber,
                        iFLT         => lFloorOrLevelType,
                        iFLRLVL      => lFloorOrLevelNumber,
                        iPREMNO      => lHouseNumberFROM,
                        iPREMSFX     => lHouseNumberFROMsuffix,
                        iPREMNO2     => lHouseNumberTO,
                        iPREMSFX2    => lHouseNumberTOsuffix,
                        iLOTNO       => lLotNumber,
                        iPOBOXTY     => lPostalDeliveryType,
                        iPOBOXP      => lPostalDeliveryNumberPrefix,
                        iPOBOX       => lPostalDeliveryNumberValue,
                        iPOBOXS      => lPostalDeliveryNumberSuffix,
                        iLOCDESC     => lLocationDescriptor,
                        iDPID        => lDPID))) LOOP
                        
                IF  i.addressid IS NOT NULL AND
                    instr(lAddrLst,i.addressid) > 0 THEN
                    -- When found address is matches to the incoming list, select that address.
                    oRc  := lRc;
                    oMsg := REPLACE(lMsg,',]',']');
                    RETURN i.addressid; 
                END IF; 
                lAddrId := i.addressid;
            END LOOP;
            
            IF  lAddrID IS NOT NULL THEN
                oRc  := lRc;
                oMsg := REPLACE(lMsg,',]',']');
                RETURN lAddrID;
                EXIT;
            END IF;
        END LOOP;
        
        RETURN lAddrID;
    END AddrMatch_TF;
    ------------------------------------------------------------------------------------------------------------------------
    -- SEPI-26819 Table function to replace vw_addressdetail table due to performance issue.
    FUNCTION ADDRESSDETAIL (
             iAddressID    IN Address.AddressID%TYPE DEFAULT NULL
            ,iSTATEDESCR   IN VARCHAR2 DEFAULT NULL
            ,iSUBURBDESCR  IN VARCHAR2 DEFAULT NULL
            ,iSUBPCDESCR   IN VARCHAR2 DEFAULT NULL
            ,iSTRDESCR     IN VARCHAR2 DEFAULT NULL
            ,iPREMNM       IN VARCHAR2 DEFAULT NULL
            ,iPREMNM2      IN VARCHAR2 DEFAULT NULL
            ,iFUT          IN VARCHAR2 DEFAULT NULL
            ,iSPREM        IN VARCHAR2 DEFAULT NULL
            ,iFLT          IN VARCHAR2 DEFAULT NULL
            ,iFLRLVL       IN VARCHAR2 DEFAULT NULL
            ,iPREMNO       IN VARCHAR2 DEFAULT NULL
            ,iPREMSFX      IN VARCHAR2 DEFAULT NULL
            ,iPREMNO2      IN VARCHAR2 DEFAULT NULL
            ,iPREMSFX2     IN VARCHAR2 DEFAULT NULL               
            ,iLOTNO        IN VARCHAR2 DEFAULT NULL                   
            ,iPOBOXTY      IN VARCHAR2 DEFAULT NULL                      
            ,iPOBOXP       IN VARCHAR2 DEFAULT NULL                    
            ,iPOBOX        IN VARCHAR2 DEFAULT NULL                
            ,iPOBOXS       IN VARCHAR2 DEFAULT NULL                     
            ,iLOCDESC      IN VARCHAR2 DEFAULT NULL                 
            ,iLOCHPCODE    IN VARCHAR2 DEFAULT NULL                 
            ,iDPID         IN VARCHAR2 DEFAULT NULL)
    RETURN TT_ADDRESSDETAIL IS
    
    lAddrDtlLst TT_ADDRESSDETAIL := TT_ADDRESSDETAIL(NULL);
    
    TYPE trADDRDtl IS RECORD (
         ADDRESSID         NUMBER(9),                                
         ADDRESSTEMPLATEID NUMBER(9),                                
         COUNTRYLOCTYPE    VARCHAR2(5),                              
         COUNTRYLOCHMBRID  NUMBER(9),                                
         COUNTRYLOCID      NUMBER(9),                                
         COUNTRYDESCR      VARCHAR2(4000),                           
         STATELOCTYPE      VARCHAR2(5),                              
         STATELOCHMBRID    NUMBER(9),                                
         STATELOCID        NUMBER(9),                                
         STATEDESCR        VARCHAR2(4000),                           
         SUBURBLOCTYPE     VARCHAR2(5),                              
         SUBURBLOCHMBRID   NUMBER(9),                                
         SUBURBLOCID       NUMBER(9),                                
         SUBURBDESCR       VARCHAR2(4000),                           
         SUBPCODELOCTYPE   VARCHAR2(5),                              
         SUBPCLOCHMBRID    NUMBER(9),                                
         SUBPCLOCID        NUMBER(9),                                
         SUBPCDESCR        VARCHAR2(4000),                           
         STRLOCTYPE        VARCHAR2(5),                              
         STRLOCHMBRID      NUMBER(9),                                
         STRLOCID          NUMBER(9),                                
         STRDESCR          VARCHAR2(4000),                           
         PREMNM            VARCHAR2(250),                           
         PREMNM2           VARCHAR2(250),                           
         FUT               VARCHAR2(250),                           
         SPREM             VARCHAR2(250),                           
         FLT               VARCHAR2(250),                           
         FLRLVL            VARCHAR2(250),                           
         PREMNO            VARCHAR2(250),                           
         PREMSFX           VARCHAR2(250),                          
         PREMNO2           VARCHAR2(250),                           
         PREMSFX2          VARCHAR2(250),                           
         LOTNO             VARCHAR2(250),                          
         POBOXTY           VARCHAR2(250),                        
         POBOXP            VARCHAR2(250),                          
         POBOX             VARCHAR2(250),                          
         POBOXS            VARCHAR2(250),                           
         LOCDESC           VARCHAR2(250),                         
         LOCHPCODE         VARCHAR2(250),                        
         DPID              VARCHAR2(250)
        );


    TYPE taADDRDtl IS TABLE OF trADDRDtl INDEX BY BINARY_INTEGER;
    gADDRDtl taADDRDtl;
    
    
    laINPUT         pkg_std.taVarchar; 
    lAddrID         pkg_std.taInteger;
    lSrcType VARCHAR2(2000);
    lSrcType1 VARCHAR2(2000);
    lSQL     VARCHAR2(32000);
    lAPVSQL  VARCHAR2(32000);
    lLHMSQL  VARCHAR2(32000);
    lFirstRec BOOLEAN := FALSE;
    lAPVOnly  BOOLEAN := FALSE;
    lPrvAPKey VARCHAR2(30) := NULL;
    lPrvLOCType VARCHAR2(30) := NULL;
    lAddrTemplateID addresstemplate.addresstemplateid%TYPE;
    lLOCHADDRCAPID  countryap.countryapid%TYPE;
    
    CURSOR getAddr (iAddressID IN address.addressid%TYPE) IS
           -- Get Street/Postcode/State/Country elements
           WITH str AS (
                SELECT iAddressID addressid, 
                       lm.lochmbrtype, 
                       lm.locationid, 
                       lm.lochmbrid, 
                      (SELECT phrase 
                       FROM   dictionary d, 
                              location l 
                       WHERE  l.locationid = lm.locationid 
                       AND    l.descrdictid = d.dictid) val
                      ,level lvl
                FROM   lochmbr lm
                CONNECT BY PRIOR lm.parentlochmbrid = lm.lochmbrid
                START WITH lm.lochmbrid IN (
                      SELECT lmr.lochmbrid
                      FROM   addresspropertyval a
                      JOIN   lochmbr lmr ON lmr.locationid = a.locationid AND lmr.lochmbrtype = 'STR' 
                      WHERE  addressid = iAddressID))
           SELECT ROW_NUMBER () OVER ( ORDER BY lvl DESC) rn,
                  r.*
           FROM   str r
           UNION
           -- Get Lot/House/Flat/POBox elements
           SELECT ROW_NUMBER() OVER (ORDER BY a.addressid ASC) + 5,
                  a.addressid,
                  cap.apkey,
                  apv.locationid,
                 (SELECT DISTINCT lhm.lochmbrid
                  FROM   lochmbr lhm, addresspropertyval apv2, countryap cap2, address a2
                  WHERE  apv.locationid = lhm.locationid AND lhm.locationid = apv2.locationid
                  AND    lhm.lochmbrtype NOT IN ('HVA', 'SUBPC')
                  AND    apv2.addressid = a2.addressid AND apv2.countryapid = cap2.countryapid AND a2.addresstemplateid = cap2.addresstemplateid
                  AND    cap2.apkey = 'LOCHADDR') lochmbrid,
                  NVL(apv.propvalchar,
                     (SELECT phrase 
                      FROM   dictionary d, location l 
                      WHERE  l.locationid = apv.locationid 
                      AND    l.descrdictid = d.dictid)),
                  0
           FROM   address a,
                  addresspropertyval apv,
                  countryap cap
           WHERE  1 = 1
           AND    a.addressid = apv.addressid
           AND    apv.countryapid = cap.countryapid
           AND    a.addresstemplateid = cap.addresstemplateid
           AND    a.addressid = iAddressID
           ;
           
    FUNCTION loadToAddrDtl(iList IN TT_ADDRESSDETAIL, iCode IN NUMBER, iMsg IN VARCHAR2) RETURN TT_ADDRESSDETAIL IS
      lList TT_ADDRESSDETAIL := TT_ADDRESSDETAIL(NULL);
    BEGIN
        IF iList IS NOT NULL THEN
           lList(lList.LAST) := TO_ADDRESSDETAIL(
                                lList(1).ADDRESSID                           
                               ,lList(1).ADDRESSTEMPLATEID                             
                               ,lList(1).COUNTRYLOCTYPE                             
                               ,lList(1).COUNTRYLOCHMBRID                                  
                               ,lList(1).COUNTRYLOCID                                      
                               ,lList(1).COUNTRYDESCR                               
                               ,lList(1).STATELOCTYPE                               
                               ,lList(1).STATELOCHMBRID                                    
                               ,lList(1).STATELOCID                                        
                               ,lList(1).STATEDESCR                                 
                               ,lList(1).SUBURBLOCTYPE                              
                               ,lList(1).SUBURBLOCHMBRID                                   
                               ,lList(1).SUBURBLOCID                                       
                               ,lList(1).SUBURBDESCR                                
                               ,lList(1).SUBPCODELOCTYPE                            
                               ,lList(1).SUBPCLOCHMBRID                                    
                               ,lList(1).SUBPCLOCID                                        
                               ,lList(1).SUBPCDESCR                                 
                               ,lList(1).STRLOCTYPE                                 
                               ,lList(1).STRLOCHMBRID                                      
                               ,lList(1).STRLOCID                                          
                               ,lList(1).STRDESCR                                   
                               ,lList(1).PREMNM                                     
                               ,lList(1).PREMNM2                                    
                               ,lList(1).FUT                                        
                               ,lList(1).SPREM                                      
                               ,lList(1).FLT                                        
                               ,lList(1).FLRLVL                                     
                               ,lList(1).PREMNO                                     
                               ,lList(1).PREMSFX                                    
                               ,lList(1).PREMNO2                                    
                               ,lList(1).PREMSFX2                                   
                               ,lList(1).LOTNO                                      
                               ,lList(1).POBOXTY                                    
                               ,lList(1).POBOXP                                     
                               ,lList(1).POBOX                                      
                               ,lList(1).POBOXS                                     
                               ,lList(1).LOCDESC                                    
                               ,lList(1).LOCHPCODE                                  
                               ,lList(1).DPID);
        ELSE
           lList(lList.LAST) := TO_ADDRESSDETAIL(
                                NULL,                  --ADDRESSID                  
                                NULL,                  --ADDRESSTEMPLATEID                         
                                NULL,                  --COUNTRYLOCTYPE                             
                                NULL,                  --COUNTRYLOCHMBRID                                  
                                NULL,                  --COUNTRYLOCID                                      
                                NULL,                  --COUNTRYDESCR                               
                                NULL,                  --STATELOCTYPE                               
                                NULL,                  --STATELOCHMBRID                                    
                                NULL,                  --STATELOCID                                        
                                NULL,                  --STATEDESCR                                
                                NULL,                  --SUBURBLOCTYPE                             
                                NULL,                  --SUBURBLOCHMBRID                                   
                                NULL,                  --SUBURBLOCID                                       
                                NULL,                  --SUBURBDESCR                              
                                NULL,                  --SUBPCODELOCTYPE                         
                                NULL,                  --SUBPCLOCHMBRID                                  
                                NULL,                  --SUBPCLOCID                                      
                                NULL,                  --SUBPCDESCR                             
                                NULL,                  --STRLOCTYPE                                
                                NULL,                  --STRLOCHMBRID                                    
                                NULL,                  --STRLOCID                                     
                                NULL,                  --STRDESCR                           
                                NULL,                  --PREMNM                                 
                                NULL,                  --PREMNM2                             
                                NULL,                  --FUT                                  
                                NULL,                  --SPREM                             
                                NULL,                  --FLT                                 
                                NULL,                  --FLRLVL                                
                                NULL,                  --PREMNO                              
                                NULL,                  --PREMSFX                                  
                                NULL,                  --PREMNO2                               
                                NULL,                  --PREMSFX2                              
                                NULL,                  --LOTNO                                     
                                NULL,                  --POBOXTY                                
                                NULL,                  --POBOXP                               
                                NULL,                  --POBOX                                  
                                NULL,                  --POBOXS                          
                                NULL,                  --LOCDESC                              
                                NULL,                  --LOCHPCODE                        
                                NULL                  --DPID      
                               );
        END IF;  
        
        RETURN lList; 
    END loadToAddrDtl;
    
    PROCEDURE loadAddr(iAddrID pkg_std.taInteger) IS
    BEGIN
        FOR i IN 1 .. iAddrID.COUNT LOOP
            lFirstRec := TRUE;
            FOR j IN getAddr(iAddrID(i)) LOOP
                IF  lFirstRec THEN
                    gADDRDtl(i).AddressId := iAddrID(i);
                    
                    BEGIN
                       SELECT a.addresstemplateid
                       INTO   gADDRDtl(i).ADDRESSTEMPLATEID 
                       FROM   address a
                       WHERE  a.addressid = iAddrID(i);
                    EXCEPTION
                       WHEN no_data_found THEN
                            gADDRDtl(i).ADDRESSTEMPLATEID := NULL;
                    END;
                    
                    lFirstRec := FALSE;
                END IF;
                
                CASE j.lochmbrtype 
                     WHEN 'CNTRY' THEN                            
                          gADDRDtl(i).COUNTRYLOCTYPE   := j.lochmbrtype;                              
                          gADDRDtl(i).COUNTRYLOCHMBRID := j.lochmbrid;                              
                          gADDRDtl(i).COUNTRYLOCID     := j.locationid;                           
                          gADDRDtl(i).COUNTRYDESCR     := j.val;
                     WHEN 'STATE' THEN                         
                          gADDRDtl(i).STATELOCTYPE     := j.lochmbrtype;                   
                          gADDRDtl(i).STATELOCHMBRID   := j.lochmbrid;                          
                          gADDRDtl(i).STATELOCID       := j.locationid;                      
                          gADDRDtl(i).STATEDESCR       := j.val;  
                     WHEN 'SUB' THEN                  
                          gADDRDtl(i).SUBURBLOCTYPE    := j.lochmbrtype;                     
                          gADDRDtl(i).SUBURBLOCHMBRID  := j.lochmbrid;                           
                          gADDRDtl(i).SUBURBLOCID      := j.locationid;                          
                          gADDRDtl(i).SUBURBDESCR      := j.val;  
                     WHEN 'SUBPC' THEN                    
                          gADDRDtl(i).SUBPCODELOCTYPE  := j.lochmbrtype;                     
                          gADDRDtl(i).SUBPCLOCHMBRID   := j.lochmbrid;                                
                          gADDRDtl(i).SUBPCLOCID       := j.locationid;                          
                          gADDRDtl(i).SUBPCDESCR       := j.val;   
                     WHEN 'STR' THEN                      
                          gADDRDtl(i).STRLOCTYPE       := j.lochmbrtype;                   
                          gADDRDtl(i).STRLOCHMBRID     := j.lochmbrid;                     
                          gADDRDtl(i).STRLOCID         := j.locationid;                           
                          gADDRDtl(i).STRDESCR         := j.val;   
                     WHEN 'PREMNM' THEN                   
                          gADDRDtl(i).PREMNM           := j.val; 
                     WHEN 'PREMNM2' THEN                     
                          gADDRDtl(i).PREMNM2          := j.val;  
                     WHEN 'FUT' THEN                          
                          gADDRDtl(i).FUT              := j.val;
                     WHEN 'SPREM' THEN                            
                          gADDRDtl(i).SPREM            := j.val;
                     WHEN 'FLT' THEN                          
                          gADDRDtl(i).FLT              := j.val; 
                     WHEN 'FLRLVL' THEN                         
                          gADDRDtl(i).FLRLVL           := j.val; 
                     WHEN 'PREMNO' THEN                          
                          gADDRDtl(i).PREMNO           := j.val; 
                     WHEN 'PREMSFX' THEN                            
                          gADDRDtl(i).PREMSFX          := j.val;
                     WHEN 'PREMNO2' THEN                        
                          gADDRDtl(i).PREMNO2          := j.val;
                     WHEN 'PREMSFX2' THEN                         
                          gADDRDtl(i).PREMSFX2         := j.val;   
                     WHEN 'LOTNO' THEN                    
                          gADDRDtl(i).LOTNO            := j.val; 
                     WHEN 'POBOXTY' THEN                        
                          gADDRDtl(i).POBOXTY          := j.val;  
                     WHEN 'POBOXP' THEN               
                          gADDRDtl(i).POBOXP           := j.val;
                     WHEN 'POBOX' THEN                         
                          gADDRDtl(i).POBOX            := j.val; 
                     WHEN 'POBOXS' THEN                    
                          gADDRDtl(i).POBOXS           := j.val;  
                     WHEN 'LOCDESC' THEN                        
                          gADDRDtl(i).LOCDESC          := j.val;
                     WHEN 'LOCHPCODE' THEN                          
                          gADDRDtl(i).LOCHPCODE        := j.val;  
                     WHEN 'DPID' THEN               
                          gADDRDtl(i).DPID             := j.val; 
                     ELSE
                          NULL;
                END  CASE;
            END LOOP;          
        END LOOP;
    END loadAddr;
    
    -- Main ..............................................................
    BEGIN
        lAddrDtlLst.TRIM;
        laINPUT.DELETE;
        
        -- Move input values into array to be reused in dynamic sql
        laINPUT('STATE')     := iSTATEDESCR;
        laINPUT('SUB')       := iSUBURBDESCR;
        laINPUT('SUBPC')     := iSUBPCDESCR;
        laINPUT('STR')       := iSTRDESCR;
        laINPUT('PREMNM')    := iPREMNM;
        laINPUT('PREMNM2')   := iPREMNM2;
        laINPUT('FUT')       := iFUT;
        laINPUT('SPREM')     := iSPREM;
        laINPUT('FLT')       := iFLT;
        laINPUT('FLRLVL')    := iFLRLVL;
        laINPUT('PREMNO')    := iPREMNO;
        laINPUT('PREMSFX')   := iPREMSFX;
        laINPUT('PREMNO2')   := iPREMNO2;
        laINPUT('PREMSFX2')  := iPREMSFX2;         
        laINPUT('LOTNO')     := iLOTNO;           
        laINPUT('POBOXTY')   := iPOBOXTY;                     
        laINPUT('POBOXP')    := iPOBOXP;          
        laINPUT('POBOX')     := iPOBOX;         
        laINPUT('POBOXS')    := iPOBOXS;              
        laINPUT('LOCDESC')   := iLOCDESC;   
        laINPUT('LOCHPCODE') := iLOCHPCODE;             
        laINPUT('DPID')      := iDPID;                

        BEGIN
           SELECT a.addresstemplateid
           INTO   lAddrTemplateID
           FROM   addresstemplate a
           WHERE  a.addresstemplatekey = 'AUS_STORE_STRUCTURED';
        EXCEPTION
           WHEN no_data_found THEN
                RETURN loadToAddrDtl(NULL,0001,'Unable to find address template'); 
        END;
        
        BEGIN
           SELECT countryapid
           INTO   lLOCHADDRCAPID
           FROM   countryap c
           WHERE  c.addresstemplateid = lAddrTemplateID
           AND    c.apkey = 'LOCHADDR';
        EXCEPTION
           WHEN no_data_found THEN
                RETURN loadToAddrDtl(NULL,0002,'Unable to find COUNTRYAP LOCHADDR CountryAPID value.'); 
        END;    

        IF  iAddressid IS NOT NULL THEN
            lAddrID(1) := iAddressId;
            loadAddr(lAddrID);
        ELSE         
            IF  iSTATEDESCR IS NOT NULL THEN lSrcType := 'STATE'; END IF;           
            IF  iSUBURBDESCR IS NOT NULL THEN lSrcType := lSrcType||',SUB'; END IF; 
            IF  iSUBPCDESCR IS NOT NULL THEN lSrcType := lSrcType||',SUBPC'; END IF; 
            IF  iSTRDESCR IS NOT NULL THEN lSrcType := lSrcType||',STR'; END IF;            
            IF  iPREMNM IS NOT NULL THEN lSrcType := lSrcType||',PREMNM'; END IF;  
            IF  iPREMNM2 IS NOT NULL THEN lSrcType := lSrcType||',PREMNM2'; END IF;  
            IF  iFUT IS NOT NULL THEN lSrcType := lSrcType||',FUT'; END IF;  
            IF  iSPREM IS NOT NULL THEN lSrcType := lSrcType||',SPREM'; END IF;  
            IF  iFLT IS NOT NULL THEN lSrcType := lSrcType||',FLT'; END IF;  
            IF  iFLRLVL IS NOT NULL THEN lSrcType := lSrcType||',FLRLVL'; END IF; 
            IF  iPREMNO IS NOT NULL THEN lSrcType := lSrcType||',PREMNO'; END IF; 
            IF  iPREMSFX IS NOT NULL THEN lSrcType := lSrcType||',PREMSFX'; END IF; 
            IF  iPREMNO2 IS NOT NULL THEN lSrcType := lSrcType||',PREMNO2'; END IF; 
            IF  iPREMSFX2 IS NOT NULL THEN lSrcType := lSrcType||',PREMSFX2'; END IF; 
            IF  iLOTNO IS NOT NULL THEN lSrcType := lSrcType||',LOTNO'; END IF; 
            IF  iPOBOXTY IS NOT NULL THEN lSrcType := lSrcType||',POBOXTY'; END IF;  
            IF  iPOBOXP IS NOT NULL THEN lSrcType := lSrcType||',POBOXP'; END IF; 
            IF  iPOBOX IS NOT NULL THEN lSrcType := lSrcType||',POBOX'; END IF; 
            IF  iPOBOXS IS NOT NULL THEN lSrcType := lSrcType||',POBOXS'; END IF; 
            IF  iLOCDESC IS NOT NULL THEN lSrcType := lSrcType||',LOCDESC'; END IF; 
            IF  iDPID IS NOT NULL THEN lSrcType := lSrcType||',DPID'; END IF; 
            lSrcType1 := lSrcType;
            lSrcType := ','||lSrcType||',';
            
            IF  length(lSrcType1) > 0 THEN --Input values are passed in
                -- Construct dynamic sql query for address elements in the addresspropertyval table.
                lAPVSQL := 'SELECT DISTINCT a.addressID '||
                           'FROM   address a ';        
                IF  length(lSrcType) = length(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(lSrcType,',STR,',''),',SUBPC,',''),',SUB,',''),',STATE,',''),',CNTRY,','')) THEN
                    lAPVOnly := TRUE;
                ELSE
                    -- Otherwise use the locationID to search LochMbr to find the remaining address match
                    IF  instr(lSrcType,',STR,') > 0 THEN
                        lLHMSQL := 'SELECT DISTINCT l.LOCATIONID '||
                                   'FROM   LOCATION l ';
                    ELSE
                        lLHMSQL := 'SELECT lm.locationid '||
                                   'FROM   lochmbr lm '||
                                   'WHERE  lm.lochmbrtype = ''STR'' '||
                                   'CONNECT BY PRIOR lm.lochmbrid = lm.parentlochmbrid '||
                                   'START WITH lm.locationid IN ( '||
                                   'SELECT DISTINCT l.LOCATIONID '||
                                   'FROM   LOCATION l ';
                    END IF; 
                END IF;  
            
                -- Construct dynamic sql to capture addresspropertyval address element conditions.
                lPrvAPKey := NULL; 
                 
                FOR i IN (
                    SELECT cp.apkey, cp.countryapid
                    FROM   countryap cp
                    WHERE  cp.addresstemplateid = lAddrTemplateID
                    AND    cp.apkey IN (
                           WITH str AS (SELECT lSrcType1 APKEY FROM dual)
                           SELECT t.*
                           FROM  (SELECT TRIM(COLUMN_VALUE) APKEY 
                                  FROM  str s, XMLTABLE(('"'||REPLACE(APKEY,',','","')||'"'))) t)) LOOP

                    IF  lPrvAPKey IS NULL THEN
                        IF  Instr(laINPUT(i.apkey),'%') > 0 THEN
                            lAPVSQL := lAPVSQL||' JOIN addresspropertyval ap'||i.apkey||' ON ap'||i.apkey||'.countryapid = '||i.countryapid||
                                            ' AND ap'||i.apkey||'.propvalchar LIKE '''||laINPUT(i.apkey)||'''';
                        ELSE
                            lAPVSQL := lAPVSQL||' JOIN addresspropertyval ap'||i.apkey||' ON ap'||i.apkey||'.countryapid = '||i.countryapid||
                                            ' AND ap'||i.apkey||'.propvalchar = '''||laINPUT(i.apkey)||'''';
                        END IF; 
                    ELSE
                        IF  Instr(laINPUT(i.apkey),'%') > 0 THEN
                            lAPVSQL := lAPVSQL||' JOIN addresspropertyval ap'||i.apkey||' ON ap'||i.apkey||'.countryapid = '||i.countryapid||
                                            ' AND ap'||i.apkey||'.propvalchar LIKE '''||laINPUT(i.apkey)||''''||
                                            ' AND ap'||i.apkey||'.addressid = ap'||lPrvAPKey||'.addressId';
                        ELSE
                             lAPVSQL := lAPVSQL||' JOIN addresspropertyval ap'||i.apkey||' ON ap'||i.apkey||'.countryapid = '||i.countryapid||
                                            ' AND ap'||i.apkey||'.propvalchar = '''||laINPUT(i.apkey)||''''||
                                            ' AND ap'||i.apkey||'.addressid = ap'||lPrvAPKey||'.addressId';
                        END IF;
                    END IF; 

                    lPrvAPKey := i.apkey;
                END LOOP;
            
                IF  lAPVOnly THEN
                    -- When only contryAP address element values are passed in as input value....
                    lAPVSQL := lAPVSQL||' WHERE  a.addressID = ap'||lPrvAPKey||'.ADDRESSID ';
                
                    --writeOut ('lAPVSQL = '||lAPVSQL);
                    --log ('lAPVSQL = '||lAPVSQL);
                
                    EXECUTE IMMEDIATE lAPVSQL BULK COLLECT INTO lAddrId;
                
                    IF  lAddrID.COUNT > 0 THEN
                        loadAddr(lAddrID);
                    ELSE
                        RETURN loadToAddrDtl(NULL,0003,'No Address found for given address element values.'); 
                    END IF; 
                ELSE
                    -- Constract dynamic sql query for address elements in the lochmbr table
                    lPrvLOCType := NULL;
                
                    FOR i IN (WITH str AS (SELECT 'CNTRY,STATE,SUBPC,SUB,STR' LOCTYPE FROM dual)
                        SELECT t.*
                        FROM  (SELECT TRIM(COLUMN_VALUE) LOCTYPE 
                               FROM  str s, XMLTABLE(('"'||REPLACE(LOCTYPE,',','","')||'"'))) t) LOOP
                               
                        IF  instr(','||lSrcType||',', ','||i.LOCTYPE||',') > 0 THEN 
                            IF  Instr(laINPUT(i.loctype),'%') > 0 THEN
                                lLHMSQL := lLHMSQL||' JOIN location loc'||i.loctype||' ON loc'||i.loctype||'.locationtype = '''||i.loctype||''''||
                                                ' JOIN lochmbr lm'||i.loctype||' ON lm'||i.loctype||'.locationid = loc'||i.loctype||'.locationid AND lm'||i.loctype||'.lochid = 2'||
                                                ' JOIN dictionary dic'||i.loctype||' ON dic'||i.loctype||'.dictid = loc'||i.loctype||'.descrdictid AND upper(dic'||i.loctype||'.phrase) LIKE upper('''||laINPUT(i.loctype)||''')';
                            ELSE
                                 lLHMSQL := lLHMSQL||' JOIN location loc'||i.loctype||' ON loc'||i.loctype||'.locationtype = '''||i.loctype||''''||
                                                ' JOIN lochmbr lm'||i.loctype||' ON lm'||i.loctype||'.locationid = loc'||i.loctype||'.locationid AND lm'||i.loctype||'.lochid = 2'||
                                                ' JOIN dictionary dic'||i.loctype||' ON dic'||i.loctype||'.dictid = loc'||i.loctype||'.descrdictid AND upper(dic'||i.loctype||'.phrase) = upper('''||laINPUT(i.loctype)||''')';
                            END IF;       
                            lPrvLOCType := i.loctype;
                        END IF;
                    END LOOP;
            
                    lAPVSQL := lAPVSQL||' WHERE  a.addressID = ap'||lPrvAPKey||'.ADDRESSID ';
                
                    IF  instr(lSrcType,',STR,') > 0 THEN
                        lLHMSQL := lLHMSQL||' WHERE locSTR.locationid = l.locationid ';
                    ELSE
                        lLHMSQL := lLHMSQL||' WHERE loc'||lPrvLOCType||'.locationid = l.locationid)';
                    END IF;
                
                    lSQL := 'SELECT DISTINCT apv.addressid '||
                            'FROM   addresspropertyval apv '||
                            'WHERE  apv.countryapid = '||lLOCHADDRCAPID||' '||
                            'AND    apv.addressid IN ('||lAPVSQL||') '|| 
                            'AND    apv.locationid IN ('||lLHMSQL||')';

                    --writeOut ('lSQL = '||lSQL);
                    --log ('lSQL = '||lSQL);
               
                    EXECUTE IMMEDIATE lSQL BULK COLLECT INTO lAddrId;
                
                    IF  lAddrID.COUNT > 0 THEN
                        loadAddr(lAddrID);
                    ELSE
                        RETURN loadToAddrDtl(NULL,0004,'No Address records found for given address element values.'); 
                    END IF; 
                END IF; --lAPVOnly
            ELSE

                -- No specific input values passed in. Retrieve all.
                lAddrId.DELETE;

                SELECT a.addressid
                BULK COLLECT INTO lAddrId
                FROM   address a
                WHERE  a.addresstemplateid = lAddrTemplateID;
               
                IF  lAddrID.COUNT > 0 THEN
                    loadAddr(lAddrId);
                ELSE
                    RETURN loadToAddrDtl(NULL,0005,'No Address records found.'); 
                END IF;   
            END IF; -- Input passed in 
        END IF; --AddrID not null
       
        -- Load values to the list
        FOR i IN 1 .. gADDRDtl.COUNT LOOP
            lAddrDtlLst.EXTEND;

            lAddrDtlLst(lAddrDtlLst.LAST) := TO_ADDRESSDETAIL(
                                             gADDRDtl(i).AddressId,
                                             gADDRDtl(i).ADDRESSTEMPLATEID, 
                                             gADDRDtl(i).COUNTRYLOCTYPE,                             
                                             gADDRDtl(i).COUNTRYLOCHMBRID,                          
                                             gADDRDtl(i).COUNTRYLOCID,                         
                                             gADDRDtl(i).COUNTRYDESCR,
                                             gADDRDtl(i).STATELOCTYPE,                  
                                             gADDRDtl(i).STATELOCHMBRID,                      
                                             gADDRDtl(i).STATELOCID,                
                                             gADDRDtl(i).STATEDESCR,
                                             gADDRDtl(i).SUBURBLOCTYPE,                
                                             gADDRDtl(i).SUBURBLOCHMBRID,                   
                                             gADDRDtl(i).SUBURBLOCID,                     
                                             gADDRDtl(i).SUBURBDESCR,
                                             gADDRDtl(i).SUBPCODELOCTYPE,                 
                                             gADDRDtl(i).SUBPCLOCHMBRID,                             
                                             gADDRDtl(i).SUBPCLOCID,                         
                                             gADDRDtl(i).SUBPCDESCR,
                                             gADDRDtl(i).STRLOCTYPE,                
                                             gADDRDtl(i).STRLOCHMBRID,                  
                                             gADDRDtl(i).STRLOCID,                         
                                             gADDRDtl(i).STRDESCR,
                                             gADDRDtl(i).PREMNM,
                                             gADDRDtl(i).PREMNM2,
                                             gADDRDtl(i).FUT,
                                             gADDRDtl(i).SPREM,
                                             gADDRDtl(i).FLT,
                                             gADDRDtl(i).FLRLVL,
                                             gADDRDtl(i).PREMNO,
                                             gADDRDtl(i).PREMSFX,
                                             gADDRDtl(i).PREMNO2,
                                             gADDRDtl(i).PREMSFX2,
                                             gADDRDtl(i).LOTNO,
                                             gADDRDtl(i).POBOXTY,
                                             gADDRDtl(i).POBOXP,
                                             gADDRDtl(i).POBOX,
                                             gADDRDtl(i).POBOXS,
                                             gADDRDtl(i).LOCDESC,
                                             gADDRDtl(i).LOCHPCODE,
                                             gADDRDtl(i).DPID);            
        END LOOP;
        
        RETURN lAddrDtlLst;
    END ADDRESSDETAIL;

    ---- SEPI-27315
    PROCEDURE RemoveJSON IS
        l_tableIndex PLS_INTEGER;
        l_tableName  VARCHAR2(250);
        l_psid       propertyset.psid%TYPE;
        l_parentpsid propertyset.psid%TYPE;
    BEGIN
        l_tableIndex :=  pkg_prop_java.tableRow.FIRST;
        WHILE l_tableIndex IS NOT NULL
        LOOP
            pkg_prop_java.removeTable(l_tableIndex);
          l_tableIndex := pkg_prop_java.tableRow.NEXT(l_tableIndex);
        END LOOP;
        -- This Process is called from pkg_prop_java.processdml2
        -- Since we removed the data from the table we do not want processdml2 to continue on it
        Pkg_Prop_Java.exit_json_parse_Loop := TRUE;
    END RemoveJSON;
    
    
    PROCEDURE SaveAddrDetail(p_action              IN VARCHAR2,
                            p_data                 IN CLOB,
                            p_languageCode         IN VARCHAR2 DEFAULT 'ENG',
                            p_statusInd            OUT VARCHAR2,
                            p_messageJSON          OUT CLOB,
                            p_returnFieldsJSON     OUT CLOB) IS

    l_tableIndex            PLS_INTEGER;
    l_rowID                 VARCHAR2(60);
    l_currentPropertyKey    Property.Propertykey%TYPE;
    l_SubActionInd          VARCHAR2(01);
    l_MsgKey                SystemMessage.SysMsgKey%TYPE;
    l_Msg                   pkg_Msg.tsysmsg;

    l_Addrid                Address.Addressid%TYPE;
    l_StateOrTerritory      VARCHAR2(250);
    l_Country               VARCHAR2(100) := 'AUSTRALIA';
    l_LOCDESC               VARCHAR2(250);
    l_ADDRESSLINE2          VARCHAR2(250);
    l_ADDRESSLINE3          VARCHAR2(250);
    
    l_LOCHMSTRNM2           VARCHAR2(250);
    l_LOCHMSTRTP2           VARCHAR2(250);
    l_LOCHMSTRSFX2          VARCHAR2(250);
    l_ADDRESSLINE           VARCHAR2(250);
    l_PREMNM                VARCHAR2(250);
    l_PREMNM2               VARCHAR2(250);
    l_DPID                  VARCHAR2(250);
    l_SPREM                 VARCHAR2(250);
    l_FUT                   VARCHAR2(250);
    l_FLRLVL                VARCHAR2(250);
    l_FLT                   VARCHAR2(250);
    l_HouseNumber           VARCHAR2(250); -- House Number temp
    l_PREMNO                VARCHAR2(250); -- House Number
    l_PREMSFX               VARCHAR2(250); -- House Suffix
    l_PREMNO2               VARCHAR2(250); -- House Number 2
    l_PREMSFX2              VARCHAR2(250); -- House Suffix 2
    l_LOTNO                 VARCHAR2(250);
    l_PostalDeliveryNumber  VARCHAR2(250); -- Postal Delivery Number temp
    l_POBOX                 VARCHAR2(250); -- Postal Delivery Number
    l_POBOXP                VARCHAR2(250); -- Postal Delivery Number Prefix
    l_POBOXS                VARCHAR2(250); -- Postal Delivery Number Suffix
    l_POBOXTY               VARCHAR2(250);
    l_LOCHMPCODE            VARCHAR2(250);
    l_LOCHMSTATE            VARCHAR2(250);
    l_LOCHMSTRNM            VARCHAR2(250);
    l_LOCHMSTRSFX           VARCHAR2(250);
    l_LOCHMSTRTP            VARCHAR2(250);
    l_LOCHMSUB              VARCHAR2(250);

    l_count                 PLS_INTEGER;
    xExit                   EXCEPTION;
    
    PROCEDURE Format_HouseNumber (i_temp VARCHAR2, o_house_no1 OUT VARCHAR2, o_house_no1_sfx OUT VARCHAR2, o_house_no2 OUT VARCHAR2, o_house_no2_sfx OUT VARCHAR2)IS 
        l_house_no_char       CHAR(01);
        l_house_no1_flg       BOOLEAN := TRUE;
    BEGIN
        IF i_temp IS NOT NULL THEN
            FOR I IN 1 .. LENGTH(i_temp) LOOP
                l_house_no_char := SUBSTR(i_temp
                                     ,i
                                     ,1);
                IF l_house_no1_flg THEN
                    IF l_house_no_char BETWEEN '0' AND '9' THEN
                        o_house_no1 := o_house_no1 || l_house_no_char;
                    ELSIF UPPER(l_house_no_char) BETWEEN 'A' AND 'Z' THEN
                        o_house_no1_sfx := l_house_no_char;
                    ELSE
                        l_house_no1_flg := FALSE;
                    END IF;
                ELSE
                    IF l_house_no_char BETWEEN '0' AND '9' THEN
                        o_house_no2 := o_house_no2 || l_house_no_char;
                    ELSIF UPPER(l_house_no_char) BETWEEN 'A' AND 'Z' THEN
                        o_house_no2_sfx := l_house_no_char;
                    ELSE
                        NULL; -- !!
                    END IF;
                END IF;
            END LOOP;
        END IF;
    END Format_HouseNumber;
    
    PROCEDURE Format_PostalDeliveryNumber (i_temp VARCHAR2, o_pobox_pfx OUT VARCHAR2, o_pobox OUT VARCHAR2, o_pobox_sfx OUT VARCHAR2)IS 
        l_temp_chr            CHAR(01);
    BEGIN
        IF i_temp IS NOT NULL THEN
            FOR I IN 1 .. LENGTH(i_temp) LOOP
                l_temp_chr := SUBSTR(i_temp
                                    ,i
                                    ,1);
                IF UPPER(l_temp_chr) BETWEEN 'A' AND 'Z' THEN
                    IF o_pobox IS NULL THEN
                        o_pobox_pfx := o_pobox_pfx || l_temp_chr;
                    ELSE
                        o_pobox_sfx := o_pobox_sfx || l_temp_chr;
                    END IF;
                ELSE
                    IF o_pobox_sfx IS NULL THEN
                        o_pobox := o_pobox || l_temp_chr;
                    ELSE
                        o_pobox_sfx := o_pobox_sfx || l_temp_chr;
                    END IF;
                END IF;
            END LOOP;
        END IF;
    END Format_PostalDeliveryNumber;

    BEGIN

        p_statusInd := 'P';
        l_tableIndex  := Pkg_Prop_Java.currentTableindex;

        WHILE l_tableIndex IS NOT NULL LOOP
            l_rowid := pkg_prop_java.tableRow(l_tableIndex).tableRowid;

            l_currentPropertyKey := 'B_FUT';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_FUT := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;

                IF l_FUT IS NOT NULL THEN
                    SELECT COUNT(1)
                    INTO l_count
                    FROM VW_FLATUNITTYPE
                    WHERE ABBREVTEXT = l_FUT;

                    IF l_count = 0 THEN
                       p_statusInd := 'F';
                       l_MsgKey := 'LOC_SYS';
                       l_msg := pkg_msg.GetMsg(l_MsgKey,'09','Flat or Unit Type');
                       GOTO CHECK_STATUS;
                    END IF;
                END IF;
            END IF;

            l_currentPropertyKey := 'B_FLT';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_FLT := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;

                IF l_FLT IS NOT NULL THEN
                    SELECT COUNT(1)
                    INTO l_count
                    FROM VW_FLOORLEVELTYPE
                    WHERE ABBREVTEXT = l_FLT;

                    IF l_count = 0 THEN
                       p_statusInd := 'F';
                       l_MsgKey := 'LOC_SYS';
                       l_msg := pkg_msg.GetMsg(l_MsgKey,'09','Floor Level Type');
                       GOTO CHECK_STATUS;
                    END IF;
                END IF;
            END IF;

            l_currentPropertyKey := 'B_POBOXTY';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_POBOXTY := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;

                IF l_POBOXTY IS NOT NULL THEN
                    SELECT COUNT(1)
                    INTO l_count
                    FROM VW_POSTALTYPE
                    WHERE ABBREVTEXT = l_POBOXTY;

                    IF l_count = 0 THEN
                       p_statusInd := 'F';
                       l_MsgKey := 'LOC_SYS';
                       l_msg := pkg_msg.GetMsg(l_MsgKey,'09','Postal Delivery Type');
                       GOTO CHECK_STATUS;
                    END IF;
                END IF;
            END IF;

            l_currentPropertyKey := 'B_LOCHMSTRSFX';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCHMSTRSFX := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;

                IF l_LOCHMSTRSFX IS NOT NULL THEN
                    SELECT COUNT(1)
                    INTO l_count
                    FROM VW_STREETSUFFIX
                    WHERE ABBREVTEXT = l_LOCHMSTRSFX;

                    IF l_count = 0 THEN
                       p_statusInd := 'F';
                       l_MsgKey := 'LOC_SYS';
                       l_msg := pkg_msg.GetMsg(l_MsgKey,'09','Street Suffix 1');
                       GOTO CHECK_STATUS;
                    END IF;
                END IF;
            END IF;

            l_currentPropertyKey := 'B_LOCHMSTRTP';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCHMSTRTP := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;

               IF l_LOCHMSTRTP IS NOT NULL THEN
                    SELECT COUNT(1)
                    INTO l_count
                    FROM VW_STREETTYPE
                    WHERE ABBREVTEXT = l_LOCHMSTRTP;

                    IF l_count = 0 THEN
                       p_statusInd := 'F';
                       l_MsgKey := 'LOC_SYS';
                       l_msg := pkg_msg.GetMsg(l_MsgKey,'09','Street Type 1');
                       GOTO CHECK_STATUS;
                    END IF;
                END IF;
            END IF;

            l_currentPropertyKey := 'B_LOCHMSTRTP2';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCHMSTRTP2 := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;

                IF l_LOCHMSTRTP2 IS NOT NULL THEN
                    SELECT COUNT(1)
                    INTO l_count
                    FROM VW_STREETTYPE
                    WHERE ABBREVTEXT = l_LOCHMSTRTP2;

                    IF l_count = 0 THEN
                       p_statusInd := 'F';
                       l_MsgKey := 'LOC_SYS';
                       l_msg := pkg_msg.GetMsg(l_MsgKey,'09','Street Type 2');
                       GOTO CHECK_STATUS;
                    END IF;
                END IF;
            END IF;

            l_currentPropertyKey := 'B_LOCHMSTRSFX2';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCHMSTRSFX2 := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;

                IF l_LOCHMSTRSFX2 IS NOT NULL THEN
                    SELECT COUNT(1)
                    INTO l_count
                    FROM VW_STREETSUFFIX
                    WHERE ABBREVTEXT = l_LOCHMSTRSFX2;

                    IF l_count = 0 THEN
                       p_statusInd := 'F';
                       l_MsgKey := 'LOC_SYS';
                       l_msg := pkg_msg.GetMsg(l_MsgKey,'09','Street Suffix 2');
                       GOTO CHECK_STATUS;
                    END IF;
                END IF;
            END IF;

            l_currentPropertyKey := 'B_LOCDESC';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCDESC := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_ADDRESSLINE2';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_ADDRESSLINE2 := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_ADDRESSLINE3';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_ADDRESSLINE3 := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_LOCHMSTRNM2';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCHMSTRNM2 := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_ADDRESSLINE';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_ADDRESSLINE := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_PREMNM';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_PREMNM := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_PREMNM2';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_PREMNM2 := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_DPID';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_DPID := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_SPREM';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_SPREM := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_FLRLVL';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_FLRLVL := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_PREMNO';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_HouseNumber := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_LOTNO';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOTNO := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_POBOX';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_PostalDeliveryNumber := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;            

            l_currentPropertyKey := 'B_LOCHMPCODE';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCHMPCODE := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_LOCHMSTATE';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCHMSTATE := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_LOCHMSTRNM';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCHMSTRNM := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;

            l_currentPropertyKey := 'B_LOCHMSUB';
            IF  pkg_prop_java.tableRow(l_tableIndex).propertyKey.exists(l_currentPropertyKey) THEN
               l_LOCHMSUB := pkg_prop_java.tableRow(l_tableIndex).propertyKey(l_currentPropertyKey).VALUE;
            END IF;
                       
            l_tableIndex := Pkg_Prop_Java.tableRow.NEXT(l_tableIndex);
            EXIT WHEN l_tableIndex IS NULL;
        END LOOP;
                
        <<CHECK_STATUS>>
        IF  p_statusInd = 'F' THEN
            RAISE xExit;
        END IF;

        IF  p_statusInd = 'P'  THEN       
            FOR rec IN (SELECT Dt.Fulltext -- Find full text of State field in XML
                        FROM   Dictionarytext Dt
                        WHERE  UPPER(Dt.Abbrevtext) = UPPER(RTRIM(l_LOCHMSTATE)))
            LOOP
                l_StateOrTerritory := rec.Fulltext;
            END LOOP;
            
            Format_HouseNumber(i_temp           => l_HouseNumber, 
                               o_house_no1      => l_PREMNO, 
                               o_house_no1_sfx  => l_PREMSFX, 
                               o_house_no2      => l_PREMNO2, 
                               o_house_no2_sfx  => l_PREMSFX2);
                               
            Format_PostalDeliveryNumber (i_temp         => l_PostalDeliveryNumber, 
                                        o_pobox_pfx     => l_POBOXP, 
                                        o_pobox         => l_POBOX, 
                                        o_pobox_sfx     => l_POBOXS);

            l_Addrid := Pkg_Pqa.Getaddr(l_FUT || CHR(2) || l_SPREM || CHR(2) || l_FLT || CHR(2) || l_FLRLVL || CHR(2)
                                       ,l_PREMNO || CHR(2) || l_PREMSFX || CHR(2) || l_PREMNO2 || CHR(2) || l_PREMSFX2 || CHR(2) || l_LOTNO || CHR(2)
                                       ,l_PREMNM || CHR(2) || l_PREMNM2 || CHR(2)
                                       ,NULL
                                       ,l_LOCHMSTRNM || CHR(2) || l_LOCHMSTRTP || CHR(2) || l_LOCHMSTRSFX || CHR(2) || l_LOCHMSTRNM2 || CHR(2) || l_LOCHMSTRTP2 || CHR(2) || l_LOCHMSTRSFX2 || CHR(2)
                                       ,l_POBOXTY
                                       ,l_ADDRESSLINE || CHR(2) || l_ADDRESSLINE2 || CHR(2) || l_ADDRESSLINE3
                                       ,l_DPID
                                       ,UPPER(l_LOCHMSUB)
                                       ,l_POBOXP|| CHR(2) || l_POBOX || CHR(2) || l_POBOXS
                                       ,l_StateOrTerritory
                                       ,l_Country
                                       ,l_LOCHMPCODE
                                       ,l_LOCDESC);
        END IF;       
        Pkg_Prop_Java.addReturnField(p_propertySetKey => 'UIADDRDET',
                                     p_propertyKey    => 'ADDRESSID2',
                                     p_value          => l_Addrid
                                     );
        RemoveJSON;
        pkg_Msg.getMessageJSON(iMsgs     => Pkg_Prop_Java.g_msgTable, oJSONMsgs   => p_messageJSON);
        Pkg_Prop_Java.getReturnFieldsJSON(p_returnFieldsJson => p_returnFieldsJSON);
        
    EXCEPTION
        WHEN xExit THEN
            Pkg_Prop_Java.StackMessage (iMsgText     => l_msg.MsgText
                                       ,iSysMsgKey   => l_MsgKey
                                       ,iMsgSeverity => l_msg.MsgSeverity
                                       ,iPKey        => l_currentPropertyKey
                                       );
            RemoveJSON;
            Pkg_Msg.getMessageJSON(Pkg_Prop_Java.g_msgTable,p_messageJSON);
            Pkg_Prop_Java.getReturnFieldsJSON(p_returnFieldsJSON);
        WHEN OTHERS THEN
            Pkg_Context.clear_parameters;
            Pkg_Prop_Java.calledFromProcessDML := FALSE;
            p_statusInd := 'F';
            Pkg_Prop_Java.StackMessage (iSQLErrm  => SQLERRM
                                       ,iSQLCode  => SQLCODE
                                       ,iData     => p_Data);
            Pkg_Msg.getMessageJSON(iMsgs     => Pkg_Prop_Java.g_msgTable
                                  ,oJSONMsgs => p_messageJSON);
            Pkg_Prop_Java.getReturnFieldsJSON(p_returnFieldsJson => p_returnFieldsJSON);

    END SaveAddrDetail;
    
    FUNCTION GetAddrDetail (iAddressID    IN Address.AddressID%TYPE)
                            RETURN TT_UIADDRDET AS

    l_Address       pkg_loch.AddressVariables;
    l_AddrDtlLst    TT_UIADDRDET := TT_UIADDRDET(NULL);
    l_MyrowID       VARCHAR2(250);
    l_RowVersion    CHAR(1);
    l_HouseNumber   VARCHAR2(250);
    l_PO_Box        VARCHAR2(250);
    l_flddlm CONSTANT CHAR(01) := pkg_k.k_Fld_Delim;
    l_StateCode     VARCHAR2(250);
    BEGIN
        BEGIN
            SELECT ad.rowid AS MyrowID, ad.ROWVERSION
            INTO l_MyrowID, l_RowVersion
            FROM address ad
            WHERE ADDRESSID = iAddressID;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            l_AddrDtlLst(l_AddrDtlLst.LAST) := TO_UIADDRDET(iAddressID
                                                          ,NULL ----    BuildingName1
                                                          ,NULL ----    BuildingName2
                                                          ,NULL ----    FlatUnitType
                                                          ,NULL ----    FlatUnitNo
                                                          ,NULL ----    FloorLevelType
                                                          ,NULL ----    FloorLevelNo
                                                          ,NULL ----    HouseNo1
                                                          ,NULL ----    HouseSfx1
                                                          ,NULL ----    HouseNo2
                                                          ,NULL ----    HouseSfx2
                                                          ,NULL ----    LotNo
                                                          ,NULL ----    LocationDescr
                                                          ,NULL ----    StreetName1
                                                          ,NULL ----    StreetType1
                                                          ,NULL ----    StreetSfx1
                                                          ,NULL ----    StreetName2
                                                          ,NULL ----    StreetType2
                                                          ,NULL ----    StreetSfx2
                                                          ,NULL ----    PostalType
                                                          ,NULL ----    PostalNumberPfx
                                                          ,NULL ----    PostalNumber
                                                          ,NULL ----    PostalNumberSfx
                                                          ,NULL ----    AddressLine
                                                          ,NULL ----    AddressLine2
                                                          ,NULL ----    AddressLine3
                                                          ,NULL ----    Suburb
                                                          ,NULL ----    STATE
                                                          ,NULL ----    PostCode
                                                          ,NULL ----    DPID
                                                          ,NULL ----    MYROWID
                                                          ,NULL ----    ROWVERSION
                                                          ,'AddressID does not exist.' ----    ERRORMSG
                                                          );
            RETURN l_AddrDtlLst;
        END;

        l_Address := pkg_loch.GetAddrDetails(iAddressID);
        l_AddrDtlLst.TRIM;
        l_AddrDtlLst.EXTEND;
        
        IF l_Address.HouseNo1 IS NOT NULL THEN
            l_HouseNumber := l_Address.HouseNo1||l_Address.HouseSfx1;
            IF l_Address.HouseNo2 IS NOT NULL THEN
                l_HouseNumber := l_HouseNumber||'-'||l_Address.HouseNo2||l_Address.HouseSfx2;
            END IF;
        ELSE
            IF l_Address.HouseNo2 IS NOT NULL THEN
                l_HouseNumber := l_Address.HouseNo2||l_Address.HouseSfx2;
            END IF;
        END IF;
        
        l_PO_Box := l_Address.PostalNumberPfx  -- Postal delivery prefix
                    || l_Address.PostalNumber -- Postal delivery no.
                    || l_Address.PostalNumberSfx; -- Postal delivery suffix
        
        FOR vCur IN (SELECT dt.Abbrevtext
                    FROM   Dictionarytext Dt
                    WHERE  UPPER(Dt.Fulltext) = UPPER(RTRIM(l_Address.STATE)))
        LOOP
            l_StateCode := vCur.Abbrevtext;
        END LOOP;
        
        l_AddrDtlLst(l_AddrDtlLst.LAST) := TO_UIADDRDET(iAddressID
                                                      ,l_Address.BuildingName1
                                                      ,l_Address.BuildingName2
                                                      ,l_Address.FlatUnitType
                                                      ,l_Address.FlatUnitNo
                                                      ,l_Address.FloorLevelType
                                                      ,l_Address.FloorLevelNo
                                                      ,l_HouseNumber --l_Address.HouseNo1
                                                      ,l_Address.HouseSfx1
                                                      ,l_Address.HouseNo2
                                                      ,l_Address.HouseSfx2
                                                      ,l_Address.LotNo
                                                      ,l_Address.LocationDescr
                                                      ,l_Address.StreetName1
                                                      ,l_Address.StreetType1
                                                      ,l_Address.StreetSfx1
                                                      ,l_Address.StreetName2
                                                      ,l_Address.StreetType2
                                                      ,l_Address.StreetSfx2
                                                      ,l_Address.PostalType
                                                      ,l_Address.PostalNumberPfx
                                                      ,TRIM(l_PO_Box) ----l_Address.PostalNumber
                                                      ,l_Address.PostalNumberSfx
                                                      ,l_Address.AddressLine
                                                      ,l_Address.AddressLine2
                                                      ,l_Address.AddressLine3
                                                      ,l_Address.Suburb
                                                      ,l_StateCode
                                                      ,l_Address.PostCode
                                                      ,l_Address.DPID
                                                      ,l_MyrowID
                                                      ,l_RowVersion
                                                      ,NULL ----    ERRORMSG
                                                      );

        RETURN l_AddrDtlLst;
    END GetAddrDetail;
    ------------------------------------------------------------------------------------------------------
END pkg_addr;
/
