CREATE OR REPLACE PACKAGE pkg_ActionAfter IS--
    --------------------------------------------------------------------------------
    -- Package      : pkg_ActionAfter
    -- Application  : Scottish Power
    -- Purpose      : Performance a certain actions after a row change.
    -- Author       : Shan Zeng
    -- Spec X-Ref   : WR13579
    -- History      :
    --------------------------------------------------------------------------------
    -- $Revision: \hubu_unix_src?main?enaus\5 $
    -- $Date: Wed Apr 20 16:01:58 2016 $
    -- $Log: M:\zixn35_ERAUS_hubub132399\hubu_unix_src?PVCS?Packages\pkg_ActionAfter.sql $

-- \hubu_unix_src?main?enaus\5  Wed Apr 20 16:01:58 2016  zixn35

--merge


-- \hubu_unix_src?main?enaus\hubub132399\1  Fri Jan 29 10:21:17 2016  zixn35

--Add CustomerDetailsNotification for gas


-- \hubu_unix_src?main?enaus\4  Wed Aug 20 16:47:42 2014  ztxj10

--Merge


-- \hubu_unix_src?main?enaus\3  Wed Aug 20 16:40:29 2014  ztxj10

--Merge


-- \hubu_unix_src?main?enaus\hubub105625\2  Wed Aug 20 16:46:29 2014  ztxj10

--WR105625 Change hitransactionpropertyid size


-- \hubu_unix_src?main?enaus\2  Mon Sep 23 15:56:29 2013  ztxj10

--Merge


-- \hubu_unix_src?main?enaus\hubub101117\1  Mon Sep 23 15:56:02 2013  ztxj10

--WR101117 Change the remotejob to midnight


-- \hubu_unix_src?main?enaus\1  Wed Nov 30 16:31:04 2005  zixn35

--Merge EAIND to ENAUS


-- \hubu_unix_src?main?enaus?eaind?5  Fri Oct  7 10:40:57 2005  zgxy22

--WR19894 : bug fix


-- \hubu_unix_src?main?enaus?eaind?4  Fri Sep 30 11:16:24 2005  zgxy22

--WR19874 : bug fix


-- \hubu_unix_src?main?enaus?eaind?1  Mon Sep 26 09:50:14 2005  zjxt10



-- \hubu_unix_src?main?enaus\hubub19504\1  Fri Sep 23 14:32:37 2005  zjxt10



-- \hubu_unix_src?main?scotpr\hubub13579\3  Mon Jul  4 13:05:43 2005  shanz

--Call Call pkg_soGetRetailerFromSPIDl_SiteSPID to get RTL2 value to avoid table mutating problem



-- \hubu_unix_src?main?scotpr\hubub13579\2  Mon Jul  4 11:21:04 2005  shanz

--Fixed a couple of problems


-- \hubu_unix_src?main?scotpr\hubub13579\1  Fri Jul  1 16:45:39 2005  shanz

--WR13579: Performance a certain acitons after a row change


    -- Public type declarations

    -- Public constant declarations

    -- Public variable declarations

    -- Public function and procedure declarations

    -- #usage Perform indirect actions: create pending messages
    -- #param iPMKNM               Object Table Primary Key Name
    -- #param iPMKID               Object Table Primary Key ID
    -- #param iTableName           Object Table Name
    -- #param iHITKeyRefList       List of Hitransaction Key Refs
    PROCEDURE Perform(iPMKNM         IN VARCHAR2
                     ,iPMKID         IN NUMBER
                     ,iTableName     IN user_tables.table_name%TYPE
                     ,iHITKeyRefList IN pkg_ActionAudit.taHiTKeyRef
                     ,iRowInfo       IN pkg_ActionAudit.taColInfo
                     ,iAction        IN CHAR); -- SEPi-12756

    -- #usage Perform indirect actions: create reports or other special functions
    -- #param iAction              Trigger Action (I, U, or D)
    -- #param iRowInfo             Row Info
    -- #param iSpecialFuncList     List of Special Functions
    PROCEDURE Perform(iAction          IN CHAR
                     ,iRowInfo         IN pkg_ActionAudit.taColInfo
                     ,iSpecialFuncList IN pkg_ActionAudit.taSpecialFunc);

    -----------------------------------------------------------------------------
    -- Returns a string containing source control file version information
    FUNCTION version RETURN VARCHAR2;


END pkg_ActionAfter;
/
CREATE OR REPLACE PACKAGE BODY pkg_ActionAfter IS

    -- Private type declarations

    -- Private constant declarations

    -- Private variable declarations


    -- Function and procedure implementations
    --------------------------------------------------------------------------------
    --
    --  This function returns the version of the current package.
    --
    --------------------------------------------------------------------------------

    FUNCTION version RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Pkg_ActionAfter.sql $Revision: \hubu_unix_src?main?enaus\5 $ $Date: Wed Apr 20 16:01:58 2016 $';
    END version;
    --
    -- Get Remote Job Wait Time
    FUNCTION GetWaitTime(iTKRef IN HiTransactionDefinition.Transactionkeyref%TYPE)
        RETURN PLS_INTEGER AS
    BEGIN
        FOR rec IN (SELECT NVL(PropValNumber
                              ,0) WaitTime
                    FROM   HiTransactionDefinition htd
                          ,HiTDProperty            htdp
                    WHERE  htd.transactionkeyref = iTKRef
                    AND    htd.hitransactiondefinitionid =
                           htdp.hitransactiondefinitionid
                    AND    htdp.propertykey = 'RMWAIT') LOOP
            RETURN rec.WaitTime;
        END LOOP;
        RETURN 0;
    END GetWaitTime;
    --
    -- Get Column Info
    FUNCTION GetColInfo(iRowInfo IN pkg_ActionAudit.taColInfo
                       ,iColName IN VARCHAR2) RETURN pkg_ActionAudit.trColInfo AS
        i         PLS_INTEGER;
        l_ColInfo pkg_ActionAudit.trColInfo := NULL;
    BEGIN
        FOR i IN 1 .. iRowInfo.COUNT LOOP
            IF upper(iRowInfo(i).NAME) = upper(iColName) THEN
                l_ColInfo := iRowInfo(i);
                EXIT;
            END IF;
        END LOOP;
        --
        RETURN l_ColInfo;
    END GetColInfo;
    --
    -- GetMPSPID: Get Supply Point Id at Metering Point level
    FUNCTION GetMPSPId(iSPID IN supplypoint.supplypointid%TYPE)
                             RETURN supplypoint.supplypointid%TYPE AS
    BEGIN
        -- Check the meter type:
        --     If the meter type is like 'MP%', then iSPID is at Meter Point level
        --     If the meter type is like 'SITE%', then get its child
        --     else, get its parent
        FOR rec IN (SELECT sp.metertype
                    FROM   supplypoint sp
                    WHERE  sp.supplypointid = iSPId) LOOP
            IF rec.MeterType LIKE 'MP%' THEN
                RETURN iSPID;
            ELSIF rec.MeterType LIKE 'SITE%' THEN
                FOR rec1 IN (SELECT supplypointid
                             FROM   supplypointparent spp
                             WHERE  parentsupplypointid = iSPID
                             AND    spp.datestart <= pkg_Calc.Now
                             AND    (   spp.dateend > pkg_Calc.Now
                                     OR spp.dateend IS NULL)) LOOP
                    RETURN rec1.supplypointid;
                END LOOP;
            ELSE
                FOR rec1 IN (SELECT parentsupplypointid
                             FROM   supplypointparent spp
                             WHERE  supplypointid = iSPID
                             AND    spp.datestart <= pkg_Calc.Now
                             AND    (   spp.dateend > pkg_Calc.Now
                                     OR spp.dateend IS NULL)) LOOP
                    RETURN rec1.parentsupplypointid;
                END LOOP;
            END IF;
        END LOOP;
        --
        RETURN NULL;
        --
    END GetMPSPId;
    --
    -- GetSitePID: Get Supply Point Id at Site level
    FUNCTION GetSiteSPId(iSPID IN supplypoint.supplypointid%TYPE)
                             RETURN supplypoint.supplypointid%TYPE AS
    BEGIN
        -- Check the meter type:
        --     If the meter type is like 'SITE%', then iSPID is at Site Level
        --     If the meter type is like 'MP%', then get its parent
        --     else, get its parent
        FOR rec IN (SELECT sp.metertype
                    FROM   supplypoint sp
                    WHERE  sp.supplypointid = iSPId) LOOP
            IF rec.MeterType LIKE 'SITE%' THEN
                RETURN iSPID;
            ELSIF rec.MeterType LIKE 'MP%' THEN
                FOR rec1 IN (SELECT parentsupplypointid
                             FROM   supplypointparent spp
                             WHERE  supplypointid = iSPID
                             AND    spp.datestart <= pkg_Calc.Now
                             AND    (   spp.dateend > pkg_Calc.Now
                                     OR spp.dateend IS NULL)) LOOP
                    RETURN rec1.parentsupplypointid;
                END LOOP;
            ELSE
                FOR rec1 IN (SELECT spp2.parentsupplypointid
                             FROM   supplypointparent spp1
                                   ,supplypointparent spp2
                             WHERE  spp1.supplypointid = iSPID
                             AND    spp1.parentsupplypointid = spp2.supplypointid
                             AND    spp1.datestart <= pkg_Calc.Now
                             AND    (   spp1.dateend > pkg_Calc.Now
                                     OR spp1.dateend IS NULL)
                             AND    spp2.datestart <= pkg_Calc.Now
                             AND    (   spp2.dateend > pkg_Calc.Now
                                     OR spp2.dateend IS NULL)) LOOP
                    RETURN rec1.parentsupplypointid;
                END LOOP;
            END IF;
        END LOOP;
        --
        RETURN NULL;
        --
    END GetSiteSPId;
    --
    -- GetUitilityType
    FUNCTION GetUtilityType(iSPID IN supplypoint.supplypointid%TYPE)
                                   RETURN VARCHAR2 AS
    BEGIN
        FOR rec IN (SELECT sp.utilitytype
                    FROM   vw_supplypoint sp
                    WHERE  sp.supplypointid = iSPID) LOOP
            RETURN rec.utilitytype;
        END LOOP;
        --
        RETURN NULL;
        --
    END GetUtilityType;
    --
    -- Here contains code related to create pending messages in old triggers
    PROCEDURE ProcessOldHITKeyRef(iPMKNM     IN VARCHAR2
                                 ,iPMKID     IN NUMBER
                                 ,iHITKeyRef IN ActionDefinition.Transactionkeyref%TYPE) AS
        --
        cStandingDataNotification    VARCHAR2(30) := 'StandingDataNotification3007a';
        cNotificationofMIRNstatus    VARCHAR2(30) := 'StandingDataNotification3008a';
        cAmendMeterRouteDetails      VARCHAR2(30) := 'AmendMeterRouteDetails3080a';
        cAmendMeterRouteDetailsSADDR VARCHAR2(30) := 'AmendMeterRouteDetailsSADDR';
        cGasMeterNotification        VARCHAR2(30) := 'GasMeterNotification3038a';
        ioprops                      pkg_std.trProp;
        l_version                    hitransactiondefinition.version%TYPE := 'r9';
        result                       PLS_INTEGER;
        err_num                      PLS_INTEGER;
        err_msg                      VARCHAR2(300);
        l_MPSPID                     supplypoint.supplypointid%TYPE;
        l_SiteSPID                   supplypoint.supplypointid%TYPE;
        l_RTL2                       spproperty.propvalnumber%TYPE;
        x_NoMPSPID                   EXCEPTION;
        x_NoRTL2                     EXCEPTION;
        --
    BEGIN
        IF pkg_spproperty.g_bulk_update THEN
            RETURN;
        END IF;
        --
        -- replace trigger spproperty_aiur01 and trigger spprooperty_aur01
        IF iHITKeyRef IN (cStandingDataNotification
                         ,cNotificationofMIRNstatus
                         ,cAmendMeterRouteDetailsSADDR
                         ,cAmendMeterRouteDetails
                         ,cGasMeterNotification) AND
           upper(iPMKNM) = 'SUPPLYPOINTID' THEN
            BEGIN
                --
                l_MPSPID := GetMPSPId(iPMKID);
                IF l_MPSPID IS NULL THEN
                    RAISE x_NoMPSPID;
                END IF;
                   -- AUTONOMOUS_TRANSACTION call
                l_RTL2 := pkg_so.GetRetailerFromSPID(l_MPSPID);
                IF l_RTL2 IS NULL THEN
                   l_SiteSPID := GetSiteSPId(l_MPSPID);
                   l_RTL2 := pkg_so.GetRetailerFromSPID(l_SiteSPID);
                end IF;
                --
                IF l_RTL2 IS NULL THEN
                    RAISE x_NoRTL2;
                END IF;
                --
                pkg_std.Delete_prop(ioprops);

                ioprops.PropertyKey(1) := 'SPID3';
                ioprops.PropValNumber(1) := l_MPSPID;
                ioprops.PropValChar(1) := NULL;
                ioprops.PropValDate(1) := NULL;
                ioprops.DateStart(1) := NULL;
                ioprops.DateEnd(1) := NULL;

                IF iHITKeyRef = cStandingDataNotification THEN
                    ioprops.PropertyKey(2) := 'TRANTYPE';
                    ioprops.PropValNumber(2) := NULL;
                    ioprops.PropValChar(2) := 'Change';
                    ioprops.PropValDate(2) := NULL;
                    ioprops.DateStart(2) := NULL;
                    ioprops.DateEnd(2) := NULL;

                    ioprops.PropertyKey(3) := 'ASADT';
                    ioprops.PropValNumber(3) := NULL;
                    ioprops.PropValChar(3) := NULL;
                    ioprops.PropValDate(3) := pkg_calc.today;
                    ioprops.DateStart(3) := NULL;
                    ioprops.DateEnd(3) := NULL;
                ELSIF iHITKeyRef IN (cAmendMeterRouteDetails
                                    ,cAmendMeterRouteDetailsSADDR) THEN
                    ioprops.PropertyKey(2) := 'UTLTYP';
                    ioprops.PropValNumber(2) := NULL;
                    ioprops.PropValChar(2) := GetUtilityType(l_MPSPID);
                    ioprops.PropValDate(2) := NULL;
                    ioprops.DateStart(2) := NULL;
                    ioprops.DateEnd(2) := NULL;

                    ioprops.PropertyKey(3) := 'RTL2';
                    ioprops.PropValNumber(3) := l_RTL2;
                    ioprops.PropValChar(3) := NULL;
                    ioprops.PropValDate(3) := NULL;
                    ioprops.DateStart(3) := NULL;
                    ioprops.DateEnd(3) := NULL;
                ELSIF iHITKeyRef = cGasMeterNotification THEN
                    ioprops.PropertyKey(2) := 'MACT';
                    ioprops.PropValNumber(2) := NULL;
                    ioprops.PropValChar(2) := NULL;
                    ioprops.PropValDate(2) := NULL;
                    ioprops.DateStart(2) := NULL;
                    ioprops.DateEnd(2) := NULL;

                    ioprops.PropertyKey(3) := 'SOCDT';
                    ioprops.PropValNumber(3) := NULL;
                    ioprops.PropValChar(3) := NULL;
                    ioprops.PropValDate(3) := pkg_calc.today;
                    ioprops.DateStart(3) := NULL;
                    ioprops.DateEnd(3) := NULL;
                END IF;
                --
                IF NOT
                    pkg_message_broker.IsPendMessageFound(itransactionkeyref => iHITKeyRef
                                                         ,iversion           => l_version
                                                         ,ioprops            => ioprops) THEN

                    -- Call the function to insert the HITransaction/HITransaction Property rows

                    result := pkg_message_broker.creatependmessage(iParentTransactionId => NULL
                                                                  ,itransactionkeyref   => cStandingDataNotification
                                                                  ,iversion             => l_version
                                                                  ,ioprops              => ioprops);
                END IF; --NOT pkg_message_broker.IsPendMessageFound
            EXCEPTION
                WHEN x_NoMPSPId THEN
                    RAISE_APPLICATION_ERROR(-20001
                                           ,'Could not get a supply point at Metering Point. Supply Point Id: ' ||
                                            iPMKId);
                WHEN x_NoRTL2 THEN
                    RAISE_APPLICATION_ERROR(-20001
                                           ,'Could not get a Supplier for Supply Point Id: ' ||
                                            iPMKId);
                WHEN OTHERS THEN
                    err_num := SQLCODE;
                    err_msg := SUBSTR(SQLERRM, 1, 300);
                    RAISE_APPLICATION_ERROR(-20001
                                           ,'Could not get a supply point at Metering Point. Supply Point Id: ' ||
                                            iPMKId ||
                                            ' Error Code: ' || err_num ||
                                            ' Error Message: ' || err_msg);
            END;
        END IF;
    END ProcessOldHITKeyRef;
    --
    -- Perform indirect actions: create pending messages
    PROCEDURE Perform(iPMKNM         IN VARCHAR2
                     ,iPMKID         IN NUMBER
                     ,iTableName     IN user_tables.table_name%TYPE
                     ,iHITKeyRefList IN pkg_ActionAudit.taHiTKeyRef
                     ,iRowInfo       IN pkg_ActionAudit.taColInfo
                     ,iAction        IN CHAR) AS  -- SEPi-12756 it is to identify add or update action being done for CDN

        CURSOR cGetNMI4Cust(iRootBuid    Businessunit.BUID%TYPE, iUT VARCHAR2 ) IS
            SELECT Distinct spp.Supplypointid
            FROM   CustomerSite cs, SupplyPoint s, MeterType mt, SupplyPointParent spp
            WHERE  cs.dateend IS NULL
              AND  cs.SupplyPointId = s.SupplyPointID
              AND  s.MeterType = mt.metertype
              AND  mt.UtilityType in ('E','G')
              AND  (iUT is null or iUT = mt.UtilityType)
              AND  spp.ParentSupplyPointID = s.SupplyPointID
              AND  spp.DateEnd is NULL
              AND  RootBuid = iRootBuid ;


        CURSOR cGetNMI4BP (iHmbrID  HierarchyMbr.HMbrId%TYPE, iUT VARCHAR2) IS
            Select Distinct ip.PropValNumber
            FROM HmbrInventory hi,
                InvProperty ip,
                SupplyPoint s,
                MeterType mt,
                Inventory i,
                (Select HmbrID
                from hierarchymbr
                connect by prior buid = parentbuid
                and hmbrtype != 'BP'
                start with hmbrid = iHmbrID ) x
            Where x.HmbrID = hi.HmbrID
              and hi.InventoryID = ip.InventoryId
              and ip.PropertyKey = 'SPID'
              and ip.PropValNumber = s.SupplyPointID
              and s.MeterType = mt.MeterType
              and i.Inventoryid = ip.InventoryId
              and i.DateDeactive IS NULL
              and mt.UtilityType in ('E','G')
              AND  (iUT is null or iUT = mt.UtilityType);

        CURSOR cNMI4Site(iSiteSPID      SupplyPoint.SupplyPointID%TYPE, iUT VARCHAR2) IS
            SELECT DISTINCT s.supplypointID
            FROM   supplypointparent spp, metertype mt, SupplyPoint s
            WHERE  spp.parentsupplypointid = iSiteSPID
              AND  DateEnd IS NULL
              AND  spp.supplypointid = s.supplypointid
              AND  s.MeterType = mt.MeterType
              AND  mt.UtilityType in ('E','G')
              AND  (iUT is null or iUT = mt.UtilityType);

        CURSOR cDescr(iHITKeyRef IN VARCHAR2) IS
            SELECT htd.descr
            FROM   HITransactionDefinition htd
            WHERE  htd.transactionkeyref = iHITKeyRef;

        i               PLS_INTEGER := 0;
        ioprops         pkg_std.trProp;
        --eh l_HiTKeyRef     HitransactionDefinition.Transactionkeyref%TYPE;
        l_HITID         PLS_INTEGER;
        l_Descr         HitransactionDefinition.Descr%TYPE := NULL;
        l_PMKName       user_tab_cols.column_name%TYPE;
        l_TableName     user_tables.table_name%TYPE;
        l_SQL           VARCHAR2(500) := NULL;
        l_Len           PLS_INTEGER;
        l_FirstLine     VARCHAR2(10000) := NULL;
        l_PMKRec        VARCHAR2(100) := NULL;
        l_PMKIDList     pkg_std.taFloat;
        l_PMKIDtmp      pkg_std.taFloat;
        l_UT            UtilityType.UtilityType%TYPE;
        l_CHGST         HITransactionProperty.PropValChar%TYPE;
        l_ColInfo       pkg_ActionAudit.trColInfo;
        --eh L_TRANSKEYREF   HITRansactionDefinition.TransactionKeyRef%TYPE;
        l_BILLERID      Feature.FeatuREVal%TYPE ;
        l_errmsg        VARCHAR2(500);
        --
        lBuContactId         BuContactProperty.BuContactId%type;
        lBUID                BuContact.Buid%type;
        lRootBuid            BusinessUnit.Rootbuid%type;
        --eh lparentsupplypointid supplypointparent.parentsupplypointid%type;
        lsupplypointid       supplypointparent.parentsupplypointid%type;

        lNMI                 HiTransactionProperty.Propvalchar%type;
        l_scheddate      DATE;    -- SEPI-12756
        loutageflg       boolean;  -- SEPI-12756
        --
        --eh l_MyTask             VARCHAR2(250) ;       --RSM --SEPI-16052
        --eh l_SysMsg             pkg_msg.tsysmsg;      --RSM --SEPI-16052
        lEmbeddedNWChild     spproperty.propvalchar%TYPE; --SEPI-16052
        --
        lHmbrId              HmbrProperty.Hmbrid%type;
        l_lsstatus           lsstatus.status%type := null;
        l_lsstartdate        lsstatus.datestart%type := null;
        l_lsregid            lsregistration.lsregid%type := null;
        --
    BEGIN
        l_BILLERID := pkg_Feature.Val('BILLERID');

        FOR i IN 1 .. iHiTKeyRefList.COUNT LOOP
            -- ProcessOldHITKeyRef contains the code to create pending messages
            -- from old trigger
            ProcessOldHITKeyRef(iPMKNM, iPMKID, iHiTKeyRefList(i).HITKeyRef);
            --
            -- WR132399: Add CustomerDetailsNotification for gas. Easiest to distinguish by keyref
            if iHiTKeyRefList(i).HITKeyRef = 'CustomerDetailsNotifRcB2B' THEN
                l_UT := 'E';
            ELSIF  iHiTKeyRefList(i).HITKeyRef = 'CustomerDetailsNotifRcB2BGAS' THEN
                l_UT := 'G';
            ELSE
                l_UT := null;
            END IF;
            --RSM --SEPI-16052
            IF iHiTKeyRefList(i).HITKeyRef = 'MYTASK_LS_EMBEDDED' THEN
                l_UT := 'E';
            END IF;

            --
            l_PMKIDList.DELETE;
            -- If Business Object Column Name is not null and is not
            -- same as the Object Primary Key Name
            IF iHITKeyRefList(i).BOColName IS NOT NULL
               AND iHITKeyRefList(i).BOColName != iPMKNM THEN
                l_PMKName := iHITKeyRefList(i).BOColName;
                -- If Business Object Column Name is BUID
                IF upper(iHITKeyRefList(i).BOColName) = 'BUID' AND
                    l_BILLERID = '00016' THEN
                    -- IF Table Name is 'Hierarchymbr' or 'Contact', get the root BUID
                    IF upper(iTableName) IN ('HIERARCHYMBR' ,'CONTACT') THEN
                        FOR rec1 IN (SELECT bu.rootbuid
                                     FROM   Businessunit bu
                                     WHERE  bu.buid = iPMKID) LOOP
                            IF rec1.rootbuid IS NOT NULL THEN
                                l_PMKIDList(l_PMKIDList.COUNT + 1) := rec1.rootbuid;
                            ELSE
                                l_PMKIDList(l_PMKIDList.COUNT + 1) := iPMKID;
                            END IF;
                        END LOOP;
                    -- If Table Name is 'CustomerSite', get RootBUID
                    ELSIF upper(iTableName) = 'CUSTOMERSITE' THEN
                        l_SQL := 'SELECT RootBUId FROM CustomerSite' || ' ' ||
                                 'WHERE ' || iPMKNM || ' = ' || iPMKID;
                        BEGIN
                            EXECUTE IMMEDIATE l_SQL BULK COLLECT
                                INTO l_PMKIdList;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                NULL;
                        END;
                    END IF;
                ELSIF upper(iHITKeyRefList(i).BOColName) = 'SUPPLYPOINTID' AND  -- Get the NMI SupplyPointID
                    l_BILLERID = '00009' THEN

                    IF upper(iTableName) = 'BUCONTACT' THEN
                        lBuContactId := iPMKID ;

                        SELECT BUID
                        INTO   lBUID
                        FROM   BuContact
                        WHERE  BuContactId = lBuContactId;

                        SELECT RootBuid
                        INTO   lRootBuid
                        FROM   BusinessUnit
                        WHERE  BuId = lBUID;

                        IF lRootBuid IS NULL THEN
                            lRootBuid := lBUID;
                        END IF;

                        OPEN cGetNMI4Cust(lRootBuid,l_UT);
                        FETCH cGetNMI4Cust BULK COLLECT INTO l_PMKIdList;
                        CLOSE cGetNMI4Cust;

                        IF l_UT = 'E' THEN -- CDN for Elec acct SEPC-210
                           FOR i in 1 .. l_PMKIdList.count loop
                               IF pkg_actionaudit.g_exkeylist.exists(pkg_bu.SpBUId (l_PMKIdList(i))) THEN  -- exclude the NMIs when their acct in the exclusion list
                                  null;
                               ELSE
                                  l_PMKIDtmp (l_PMKIDtmp.count + 1) := l_PMKIdList(i);
                               END IF;
                           END LOOP;
                           l_PMKIdList := l_PMKIDtmp;
                           pkg_actionaudit.g_exkeylist.delete;

                           IF iHITKeyRefList(i).propertykey = 'MTADD' THEN  -- SEPI-12756 start -- use startdate of the changed MTADD
                               l_ColInfo := GetColInfo(iRowInfo, 'propvalnumber');
                               IF (l_ColInfo.NewVal IS NOT NULL AND l_ColInfo.OldVal IS NULL) OR
                                  (l_ColInfo.NewVal IS NULL AND l_ColInfo.OldVal IS NOT NULL) OR
                                  (l_ColInfo.NewVal <> l_ColInfo.OldVal ) OR iaction = 'I'
                                 THEN -- generate CDN upon insertion of new MTADD or update on existing MTADD
                                  l_scheddate := NULL;    -- SEPI-12756 reset l_scheddate
                                  l_ColInfo := GetColInfo(iRowInfo, 'DateStart');
                                  if l_ColInfo.NewVal IS NOT NULL then
                                      l_Scheddate := to_date(pkg_audit.DateOut(l_ColInfo.NewVal), 'YYYYMMDDHH24MISS'); -- schedule run date is set to the startdate
                                  end if;
                                  IF  (iaction = 'I' and l_Scheddate IS NOT null) OR iaction = 'U' THEN -- new inserted MTADD with startdate or change on existing MTADD
                                      null;                                    --- retain the above populated lists of SPIDs for CDN generation
                                  else
                                      l_PMKIdList.delete;     -- this is to stop the existing ended date MTADD from triggering CDN - CDN will be triggered by the new added MTADD entry
                                  end if;
                               ELSE
                                  l_PMKIdList.delete;     -- this is to stop the existing ended date MTADD from triggering CDN as the new added MTADD already triggers the CDN  - CDN will be triggered by the new added MTADD entry
                               END IF;
                           END IF;
                        END IF;

                    ELSIF upper(iTableName) = 'BUSINESSUNIT' THEN
                        l_ColInfo := GetColInfo(iRowInfo, 'ROOTBUID');
                        lRootBuid := to_number(l_ColInfo.NewVal);

                        lBUID := iPMKID ;

                        IF lRootBuid IS NULL THEN
                            lRootBuid := lBUID;
                            OPEN cGetNMI4Cust(lRootBuid,l_UT);
                            FETCH cGetNMI4Cust BULK COLLECT INTO l_PMKIdList;
                            CLOSE cGetNMI4Cust;
                        END IF;

                        IF l_UT = 'E' THEN -- CDN for Elec acct SEPC-210
                           FOR i in 1 .. l_PMKIdList.count loop
                               IF pkg_actionaudit.g_exkeylist.exists(pkg_bu.SpBUId (l_PMKIdList(i))) THEN  -- exclude the NMIs when their acct in the exclusion list
                                  null;
                               ELSE
                                  l_PMKIDtmp (l_PMKIDtmp.count + 1) := l_PMKIdList(i);
                               END IF;
                           END LOOP;
                           l_PMKIdList := l_PMKIDtmp;
                           pkg_actionaudit.g_exkeylist.delete;
                        END IF;
                    ELSIF upper(iTableName) = 'HIERARCHYMBR' THEN
                        IF l_UT in ('E','G') AND upper(iTableName) = 'HIERARCHYMBR' and iHITKeyRefList(i).propertykey = 'MTADD' THEN  -- SEPI-12756 start -- use startdate of the changed MTADD
                           IF l_UT = 'E' THEN -- check whether outage contact exists
                              BEGIN
                                 select buid
                                 into   lBUID
                                 from   hierarchymbr
                                 where  hmbrid = iPMKID;
                                 exception
                                   WHEN others THEN
                                       NULL;
                              END;
                            -- check whether outage Contact exists
                              lBuContactId := pkg_bucontact.GetOutageContactId(iBuid => lBUID, iHmbrid => NULL);

                              IF lBuContactId is null THEN --- SEPI-12756 start
                                      --
                                      -- No outage contact is found
                                      --
                                     loutageflg := FALSE;
                              ELSE
                                     loutageflg := TRUE;
                              END IF; -- SEPI-12756 END

                           END IF;

                           IF l_UT = 'E' AND loutageflg THEN
                              null; -- outage contact exists therefore no need to auto-trigger CDN when the Elec Account's MTADD is changed
                           ELSE
                               l_ColInfo := GetColInfo(iRowInfo, 'propvalnumber');
                               IF (l_ColInfo.NewVal IS NOT NULL AND l_ColInfo.OldVal IS NULL) OR
                                  (l_ColInfo.NewVal IS NULL AND l_ColInfo.OldVal IS NOT NULL) OR
                                  (l_ColInfo.NewVal <> l_ColInfo.OldVal ) OR iaction = 'I'
                                 THEN -- generate CDN upon insertion of new MTADD or update on existing MTADD
                                  l_scheddate := NULL;    -- SEPI-12756 reset l_scheddate
                                  l_ColInfo := GetColInfo(iRowInfo, 'DateStart');
                                  if l_ColInfo.NewVal IS NOT NULL then
                                      l_Scheddate := to_date(pkg_audit.DateOut(l_ColInfo.NewVal), 'YYYYMMDDHH24MISS');
                                  end if;
                                  IF  (iaction = 'I' and l_Scheddate IS NOT null) OR iaction = 'U' THEN -- new inserted MTADD with startdate or change on existing MTADD
                                     -- Get the NMIs of the billing point
                                      OPEN cGetNMI4BP(iPMKID,l_UT);
                                      FETCH cGetNMI4BP BULK COLLECT INTO l_PMKIdList;
                                      CLOSE cGetNMI4BP;
                                  END IF;
                               END IF;
                           END IF;
                        ELSE -- SEPI-12756 end
                            -- Get the NMIs of the billing point
                            OPEN cGetNMI4BP(iPMKID,l_UT);
                            FETCH cGetNMI4BP BULK COLLECT INTO l_PMKIdList;
                            CLOSE cGetNMI4BP;
                        END IF;

                    ELSIF upper(iTableName) = 'HITRANSACTION' THEN
                        IF iHITKeyRefList(i).propertykey = 'CHGST' THEN
                            l_ColInfo := GetColInfo(iRowInfo, 'PropValChar');
                            l_CHGST := to_number(l_ColInfo.NewVal);

                            IF l_CHGST = 'COM' THEN
                                SELECT propvalchar
                                INTO   lNMI
                                FROM   HiTransactionProperty
                                WHERE  propertykey in ('MPCORE','MRN')
                                AND    HiTransactionPropertyID = iPMKID;

                                SELECT supplypointid
                                INTO   lsupplypointid
                                FROM   spproperty
                                WHERE  propertykey in ('MPCORE','MRN')
                                AND    propvalchar = lNMI;

                                l_PMKIdList(l_PMKIDList.COUNT + 1) := lsupplypointid;
                            END IF;
                        ELSIF iHITKeyRefList(i).propertykey = 'SOCDT' THEN

                            SELECT propvalchar
                            INTO   lNMI
                            FROM   HiTransactionProperty
                            WHERE  propertykey in ('MPCORE','MRN')
                            AND    HiTransactionPropertyID = iPMKID;

                            SELECT supplypointid
                            INTO   lsupplypointid
                            FROM   spproperty
                            WHERE  propertykey in ('MPCORE','MRN')
                              AND    propvalchar = lNMI;

                            l_PMKIdList(l_PMKIDList.COUNT + 1) := lsupplypointid;
                        END IF;

                    ELSIF upper(iTableName) = 'VW_SUPPLYPOINT' THEN

                        IF iHITKeyRefList(i).propertykey = 'HZCD' THEN
                            SELECT mt.UtilityType
                            Into l_UT
                            From MeterType mt, SupplyPoint s
                            Where s.SupplyPointId = iPMKID
                              and s.MeterType = mt.MeterType;

                            IF l_UT in ('E','G') THEN
                                l_PMKIdList(l_PMKIDList.COUNT + 1) := iPMKID;
                             END IF;
                        ELSIF iHITKeyRefList(i).propertykey = 'MLOCN' THEN
                            SELECT mt.UtilityType
                            Into l_UT
                            From MeterType mt, SupplyPoint s
                            Where s.SupplyPointId = iPMKID
                              and s.MeterType = mt.MeterType;

                            IF l_UT in ('E','G') THEN
                                SELECT ParentSupplyPointid
                                INTO   lsupplypointid
                                FROM   SupplyPointParent
                                WHERE  supplypointid = iPMKID;

                                l_PMKIdList(l_PMKIDList.COUNT + 1) := lsupplypointid;
                             END IF;
                        ELSIF iHITKeyRefList(i).propertykey = 'SADDR' THEN
                            OPEN cNMI4Site (iPMKID,l_UT) ;
                            FETCH cNMI4Site BULK COLLECT INTO l_PMKIdList ;
                            CLOSE cNMI4Site;
                        ELSIF iHITKeyRefList(i).propertykey = 'EMBNC'  THEN        --RSM  ---SEPI-16052 LIFE SUPPORT EMBEDDED
                            SELECT mt.UtilityType
                            Into l_UT
                            From MeterType mt, SupplyPoint s
                            Where s.SupplyPointId = iPMKID
                            AND s.MeterType = mt.MeterType;

                            IF l_UT in ('E','G') THEN
                                 l_PMKIdList(l_PMKIDList.COUNT + 1) := iPMKID;
                            END IF;
                            lEmbeddedNWChild := NULL;
                            l_ColInfo := GetColInfo(iRowInfo, 'propvalchar');
                            IF (l_ColInfo.NewVal IS NOT NULL AND l_ColInfo.OldVal IS NULL) OR
                              (l_ColInfo.NewVal IS NULL AND l_ColInfo.OldVal IS NOT NULL) OR
                              (l_ColInfo.NewVal <> l_ColInfo.OldVal ) OR iaction = 'I'
                            THEN
                              lEmbeddedNWChild := l_ColInfo.NewVal;
                            END IF;

                        END IF;  ---SEPI-16052 LIFE SUPPORT EMBEDDED
                    END IF;
                ELSE
                    l_SQL := 'SELECT ' || iHITKeyRefList(i).BOColName || ' ' ||
                             'FROM ' || iTableName || ' ' ||
                             'WHERE ' || iTableName || '.' || iPMKNM ||
                             ' = ' || iPMKID;
                    BEGIN
                        EXECUTE IMMEDIATE l_SQL BULK COLLECT
                            INTO l_PMKIdList;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
                END IF;
                l_TableName := NULL;
            ELSE
                -- If Business Object Column Name is Null or it is same as Object Primary
                -- Key Name
                l_PMKName := iPMKNM;
                l_PMKIDList(l_PMKIDList.COUNT + 1) := iPMKID;
                IF iHITKeyRefList(i).BOColName IS NULL THEN
                    l_TableName := iTableName;
                ELSE
                    l_TableName := NULL;
                END IF;
            END IF;
            --
            FOR j IN 1 .. l_PMKIDList.COUNT LOOP
                pkg_std.Delete_prop(ioprops);
                --
                ioprops.PropertyKey(1) := 'PMKNM';
                ioprops.PropValNumber(1) := NULL;
                ioprops.PropValChar(1) := l_PMKName;
                ioprops.PropValDate(1) := NULL;
                ioprops.DateStart(1) := NULL;
                ioprops.DateEnd(1) := NULL;
                --
                ioprops.PropertyKey(2) := 'PMKID';
                ioprops.PropValNumber(2) := l_PMKIDList(j);
                ioprops.PropValChar(2) := NULL;
                ioprops.PropValDate(2) := NULL;
                ioprops.DateStart(2) := NULL;
                ioprops.DateEnd(2) := NULL;
                --
                ioprops.PropertyKey(3) := 'TBLNM';
                ioprops.PropValNumber(3) := NULL;
                ioprops.PropValChar(3) := l_TableName;
                ioprops.PropValDate(3) := NULL;
                ioprops.DateStart(3) := NULL;
                ioprops.DateEnd(3) := NULL;
                --
                FOR rec IN cDescr(iHiTKeyRefList(i).HITKeyRef) LOOP
                    l_Descr := rec.Descr;
                END LOOP;
                    --
                IF  iHiTKeyRefList(i).HITKeyRef = 'CustomerDetailsNotifRcB2B' THEN -- dealing with CustomerDetailsNotifRcB2B   -- SEPC-762
                    l_errmsg := NULL;
                    l_HITID := Pkg_Hi_CustDetNotif.FindPendingb2bCDN (NULL,l_errmsg,l_PMKIDList(j),l_Scheddate);  -- SEPI-12756 check for Penidng transaction on the scheduled run date start
                ELSIF  iHiTKeyRefList(i).HITKeyRef = 'CustomerDetailsNotifRcB2BGAS' THEN
                    IF pkg_so_customer.GetMarket(pkg_supplypoint.spcharprop(ioprops.PropValNumber(2),'MRN')) = 'WAGAS' THEN
                            NULL;
                    ELSE -- -- SEPI-12756 end
                        l_HITID := pkg_message_broker.GetPendMessage(itransactionkeyref => iHiTKeyRefList(i).HITKeyRef
                                                                    ,iversion           => NULL
                                                                    ,ioprops            => ioprops
                                                                    ,idate              => greatest(nvl(l_scheddate,Pkg_Calc.Today),Pkg_Calc.Today)); -- SEPI-12756 check for Penidng transaction this is scheduled to run in future
                    END IF;
                ELSE -- Non- CDN transaction SEPi-12756
                    l_HITID := pkg_message_broker.GetPendMessage(itransactionkeyref => iHiTKeyRefList(i).HITKeyRef
                                                                ,iversion           => NULL
                                                                ,ioprops            => ioprops);
                END IF; -- SEPC-762

                IF l_HITID IS NULL THEN
                    --SEPI-10909 Stop CustomerDetailsNotifRcB2BGAS in WAGAS
                    IF iHiTKeyRefList(i).HITKeyRef = 'CustomerDetailsNotifRcB2BGAS' THEN
                        -- Only create if not WAGAS market
                        IF pkg_so_customer.GetMarket(pkg_supplypoint.spcharprop(ioprops.PropValNumber(2),'MRN')) = 'WAGAS' THEN
                            NULL;
                        ELSE
                            l_HITID    := pkg_message_broker.creatependmessage(iParentTransactionId => NULL
                                                                              ,itransactionkeyref   => iHiTKeyRefList(i).HITKeyRef
                                                                              ,iversion             => NULL
                                                                              ,ioprops              => ioprops
                                                                              ,iStartTime           => greatest(nvl(l_scheddate,Pkg_Calc.Today),Pkg_Calc.Today) + 1); --SEPI-12756: change to passed in a future scheduled date when MTADD is updated with future start date, otherwise schedule to run overnight
                        END IF;
                    ELSIF  iHiTKeyRefList(i).HITKeyRef = 'CustomerDetailsNotifRcB2B' THEN -- dealing with CustomerDetailsNotifRcB2B   -- SEPC-762
                        l_HITID    := pkg_message_broker.creatependmessage(iParentTransactionId => NULL
                                                                          ,itransactionkeyref   => iHiTKeyRefList(i).HITKeyRef
                                                                          ,iversion             => NULL
                                                                          ,ioprops              => ioprops
                                                                          ,iStartTime           => greatest(nvl(l_scheddate,Pkg_Calc.Today),Pkg_Calc.Today) + 1); --SEPI-12756: change to passed in a future scheduled date when MTADD is updated with future start date, otherwise schedule to run overnight

                    ELSIF iHiTKeyRefList(i).HITKeyRef = 'MYTASK_LS_EMBEDDED' THEN      --RSM  ---SEPI-16052 LIFE SUPPORT EMBEDDED

                          IF pkg_hi_LifeSupportNotif.gaEMBNC.trCreateMyTask = TRUE THEN
                             pkg_hi_LifeSupportNotif.gaEMBNC.trEMBNCReason := nvl(pkg_hi_LifeSupportNotif.gaEMBNC.trEMBNCReason,'UPD_CHILD_NMI');

                             IF nvl(pkg_hi_LifeSupportNotif.gaEMBNC.trNMISpid,ioprops.PropValNumber(2)) = ioprops.PropValNumber(2)
                                 AND nvl(pkg_hi_LifeSupportNotif.gaEMBNC.trEMBNCName,nvl(lEmbeddedNWChild,'x')) = nvl(lEmbeddedNWChild,'x') THEN
                                -- LifeSupport Check
                                begin

                                   pkg_hi_LifeSupportNotif.gaEMBNC.trAccNbrBUID := nvl(pkg_hi_LifeSupportNotif.gaEMBNC.trAccNbrBUID,pkg_bu.SpBUId(ioprops.PropValNumber(2)));

                                   SELECT hmbrid into lHmbrId
                                   FROM   hierarchymbr
                                   WHERE  buid = pkg_hi_LifeSupportNotif.gaEMBNC.trAccNbrBUID
                                   AND    hmbrtype = 'BP';


                                   l_lsregid := pkg_lifesupport.activeLSRegExist(lHmbrId);

                                   pkg_hi_LifeSupportNotif.gaEMBNC.trLSRegID := nvl(pkg_hi_LifeSupportNotif.gaEMBNC.trLSRegID,l_lsregid);

                                   --Only create task when customer is on lifesupport
                                   if l_lsregid is not null then
                                     for ls in ( SELECT    ls.status , ls.datestart
                                                 FROM      lsstatus ls
                                                 WHERE     ls.lsregid = l_lsregid
                                                 ORDER BY 1 desc) loop
                                            l_lsstatus    := ls.status;
                                            l_lsstartdate := ls.datestart;
                                            exit;
                                     end loop;
                                     -- if pkg_lifesupport.g pkg_bu.SpBUId(ioprops.PropValNumber(2))
                                     pkg_hi_LifeSupportNotif.CreateEmbMyTask
                                                                    (nvl(pkg_hi_LifeSupportNotif.gaEMBNC.trParentId,NULL)
                                                                    ,'MYTASK_LS_EMBEDDED'
                                                                    ,ioprops.PropValNumber(2)
                                                                    ,lEmbeddedNWChild
                                                                    ,nvl(pkg_hi_LifeSupportNotif.gaEMBNC.trLSStatus,l_lsstatus)
                                                                    ,nvl(pkg_hi_LifeSupportNotif.gaEMBNC.trLSStatusDAte,l_lsstartdate)
                                                                    ,pkg_hi_LifeSupportNotif.gaEMBNC.trEMBNCReason
                                                                    ,l_HITID
                                                                    ,pkg_hi_LifeSupportNotif.gaEMBNC.trAccNbrBUID
                                                                    ,pkg_hi_LifeSupportNotif.gaEMBNC.trLSRegID);

                                  end if;
                                exception
                                  when others then
                                    null;
                                end;
                             END IF;
                          END IF;


                           ---SEPI-16052 LIFE SUPPORT EMBEDDED
                    ELSE
                    l_HITID    := pkg_message_broker.creatependmessage(iParentTransactionId => NULL
                                                                      ,itransactionkeyref   => iHiTKeyRefList(i).HITKeyRef
                                                                      ,iversion             => NULL
                                                                      ,ioprops              => ioprops
                                                                      ,iStartTime           => nvl(l_Scheddate,pkg_calc.today) + 1); --WR101117. Change the remotejob to midnight.--SEPI-12756: change to passed in a future scheduled date when MTADD is updated with future start date
                    END IF;
                END IF;
                --
                IF l_HITID IS NOT NULL THEN
                    FOR rec IN (SELECT PropValClob FirstLine
                                FROM   hitransactionproperty hp
                                WHERE  hp.hitransactionid = l_HITID
                                AND    hp.propertykey = 'PMKLST') LOOP
                        l_Len       := dbms_lob.getlength(rec.FirstLine);
                        l_FirstLine := dbms_lob.substr(rec.FirstLine
                                                      ,l_Len
                                                      ,1);
                        --
                        l_PMKRec := upper(iTableName || ':' || iPMKNM || ':' ||
                                          iPMKID);
                        IF l_FirstLine IS NOT NULL THEN
                            -- Check whether the primary key alread exists in the
                            -- list.
                            IF instr(l_FirstLine
                                    ,l_PMKRec || ';') > 0
                               OR -- in the middle
                               substr(l_FirstLine
                                     ,instr(l_FirstLine
                                           ,';'
                                           ,-1) + 1
                                     ,length(l_FirstLine)) = l_PMKRec THEN
                                -- at end
                                -- found the primary key in the list
                                NULL;
                            ELSE
                                l_FirstLine := l_FirstLine || ';' ||
                                               l_PMKRec;
                            END IF;
                        ELSE
                            l_FirstLIne := l_PMKRec;
                        END IF;
                    END LOOP;
                    UPDATE hitransactionproperty hp
                    SET    propvalclob = l_FirstLine
                    WHERE  hp.hitransactionid = l_HITID
                    AND    hp.propertykey = 'PMKLST';
                END IF;
            END LOOP;
        END LOOP;
    END Perform;
    --
    -- Perform indirect actions: create reports or other special functions
    PROCEDURE Perform(iAction          IN CHAR
                     ,iRowInfo         IN pkg_ActionAudit.taColInfo
                     ,iSpecialFuncList IN pkg_ActionAudit.taSpecialFunc) AS
        --
        l_SpecialFunc       VARCHAR2(80);
        l_PropertyKey       Property.Propertykey%TYPE;
        l_TableName         user_tables.table_name%TYPE;
        l_ColInfo           pkg_ActionAudit.trColInfo;
        l_SPID              supplypoint.supplypointid%TYPE;
        --eh l_DateStart         spproperty.datestart%TYPE;
        --eh l_PropValNum        spproperty.propvalnumber%TYPE;
        l_metertype         supplypoint.metertype%TYPE;
        err_num             PLS_INTEGER;
        err_msg             VARCHAR2(300);
        l_File              utl_file.file_type;
        --
    BEGIN
        FOR i IN 1..iSpecialFuncList.COUNT LOOP
            l_SpecialFunc := iSpecialFuncList(i).SpecialFunc;
            l_TableName   := iSpecialFuncList(i).TableName;
            IF upper(l_TableName) = 'SPPROPERTY' THEN
               l_PropertyKey := iSpecialFuncList(i).PropertyKey;
                IF l_SpecialFunc = 'DRP002R' AND -- replace trigger spproperty_aiur01
                   l_PropertyKey = 'RGRP' THEN
                    IF iAction IN ('I', 'U') THEN
                        l_ColInfo := GetColInfo(iRowInfo, 'SupplyPointId');
                        l_SPID := to_number(l_ColInfo.NewVal);
                        BEGIN
                          SELECT sp.metertype
                            INTO l_metertype
                            FROM supplypointparent spp, supplypoint sp
                           WHERE spp.parentsupplypointid = l_SPID AND
                                 SPP.DateStart <= pkg_calc.today AND
                                 (SPP.DateEnd >= pkg_calc.today OR SPP.DateEnd IS NULL) and
                                 spp.supplypointid = sp.supplypointid AND
                                 ((metertype LIKE 'SRD%') or (metertype LIKE 'MRD%'));
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                            l_metertype := 'SRDG';
                            WHEN TOO_MANY_ROWS THEN
                            l_metertype := 'SRDG';
                            WHEN OTHERS THEN
                            err_num := SQLCODE;
                            err_msg := SUBSTR(SQLERRM, 1, 300);
                            RAISE_APPLICATION_ERROR(-20001,
                                                    'Could not get a supply point child. Supply Point Id: ' ||
                                                    l_SPID || ' Error Code: ' ||
                                                    err_num || ' Error Message: ' || err_msg);
                        END;
                        IF ((l_metertype LIKE 'SRD%') or (l_metertype LIKE 'MRD%')) THEN
                            pkg_rept_DRP002R.dummycntr := pkg_rept_DRP002R.dummycntr + 1;
                            pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_supplypointid := to_number(l_ColInfo.NewVal);
                            l_ColInfo := GetColInfo(iRowInfo, 'DateStart');
                            l_File := utl_file.fopen('/tmp', 'shan_spptrig.log', 'a');
                            utl_file.put_line(l_File, 'DateStart: ' || l_ColInfo.NewVal);
                            utl_file.fclose(l_File);
                            IF l_ColInfo.NewVal IS NOT NULL THEN
                                pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_datestart := to_date(l_ColInfo.NewVal, 'DD/MM/YYYY');
                            ELSE
                                pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_datestart := NULL;
                            END IF;
                            l_ColInfo := GetColInfo(iRowInfo, 'PropValNumber');
                            pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_route := to_number(l_ColInfo.NewVal);
                            IF iAction = 'I' THEN
                               pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).old_route := null;
                            ELSE
                               pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).old_route := to_number(l_ColInfo.OldVal);
                            END IF;
                            pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_supplypointid := NULL;
                       END IF;
                   END IF;
               END IF;
               --
               IF l_SpecialFunc = 'DRP167R' AND -- replace trigger spproperty_aiur01 and spproperty_aur01
                  NOT pkg_spproperty.g_bulk_update THEN
                   l_ColInfo := GetColInfo(iRowInfo, 'SupplyPointId');
                   pkg_rept_DRP002R.dummycntr := pkg_rept_DRP002R.dummycntr + 1;
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_supplypointid := to_number(l_ColInfo.NewVal);
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_datestart := null;
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_route := 999999;
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).old_route := 666666;
                   l_ColInfo := GetColInfo(iRowInfo, 'SPPropertyId');
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_supplypointid := to_number(l_ColInfo.NewVal);
               END IF;
               --
               IF l_SpecialFunc = 'DRP182R' AND -- replace trigger spproperty_aiur01 and spproperty_aur01
                  NOT pkg_spproperty.g_bulk_update THEN
                   l_ColInfo := GetColInfo(iRowInfo, 'SupplyPointId');
                   pkg_rept_DRP002R.dummycntr := pkg_rept_DRP002R.dummycntr + 1;
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_supplypointid := to_number(l_ColInfo.NewVal);
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_datestart := null;
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_route := 999999;
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).old_route := 888888;
                   pkg_rept_DRP002R.dummytable(pkg_rept_DRP002R.dummycntr).new_supplypointid := NULL;
               END IF;
            END IF;

            -- MHA-1018 Customer notifications via Notes
            IF l_SpecialFunc = 'RECORD_CUSTOMEREVENT' THEN
                pkg_CustNotification.ActionAfterCreateEvent (
                    iAction       => iAction
                   ,iaRowInfo     => iRowInfo
                   ,irSpecialFunc => iSpecialFuncList(i)
                   );
            -- SPEI-27136. Record events from any changes to entities configured in the actionaudit table.
            ELSIF l_SpecialFunc = 'RECORD_ENTITY_CHANGE_EVENT' THEN
                pkg_EntityEvent.ActionAfterEntityChangeEvent (
                    iAction       => iAction
                   ,iaRowInfo     => iRowInfo
                   ,irSpecialFunc => iSpecialFuncList(i)
                   );
            END IF;

        END LOOP;

    END Perform;
    --
--
BEGIN
    -- Initialization
    NULL;
END pkg_ActionAfter;
/
