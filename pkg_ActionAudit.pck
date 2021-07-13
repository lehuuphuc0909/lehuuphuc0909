CREATE OR REPLACE PACKAGE pkg_ActionAudit IS
    --------------------------------------------------------------------------------
    -- Package      : pkg_ActionAudit
    -- Application  : Scottish Power
    -- Purpose      : Audit a row for user changes
    -- Author       : Shan Zeng
    -- Spec X-Ref   : WR13579
    -- History      :
    --------------------------------------------------------------------------------
    -- $Revision: \hubu_unix_src?main?enaus\3 $
    -- $Date: Wed Aug 20 16:33:15 2014 $
    -- $Log: M:\ztxj10_ERAUS_hubub105625\hubu_unix_src?PVCS?Packages\pkg_ActionAudit.sql $

-- \hubu_unix_src?main?enaus\3  Wed Aug 20 16:33:15 2014  ztxj10

--Merge


-- \hubu_unix_src?main?enaus\hubub105625\1  Wed Aug 20 16:32:33 2014  ztxj10

--WR105625 Increase HITransactionPropertyID size


-- \hubu_unix_src?main?enaus\2  Mon Nov  4 11:41:06 2013  danny

--WR101318 - merge


-- \hubu_unix_src?main?enaus\hubub101318\1  Tue Oct  8 15:01:10 2013  danny

--WR101318 - additional changes


-- \hubu_unix_src?main?enaus\1  Wed Nov 30 16:31:00 2005  zixn35

--Merge EAIND to ENAUS


-- \hubu_unix_src?main?enaus?eaind?3  Fri Sep 30 11:10:42 2005  zgxy22

--WR19874 : if the user doing the update is BATCH then exit for most cases


-- \hubu_unix_src?main?enaus?eaind?2  Tue Sep 27 17:10:43 2005  zgxy22

--WR19712 : add in array of changes


-- \hubu_unix_src?main?enaus?eaind?1  Mon Sep 26 09:52:33 2005  zjxt10



-- \hubu_unix_src?main?enaus\hubub19504\1  Fri Sep 23 14:34:16 2005  zjxt10


    g_exkeylist        pkg_std.taVarchar; -- SEPC-210
    g_BypassAction     BOOLEAN := FALSE;
    -- Public type declarations
    TYPE trColInfo IS RECORD( -- Column Info
         NAME   user_tab_columns.COLUMN_NAME%TYPE -- Column Name
        ,OldVal LONG                              -- Old Value
        ,NewVal LONG);                            -- New Value

    TYPE taColInfo IS TABLE OF trColInfo INDEX BY BINARY_INTEGER;
    --
    TYPE trActionDef IS RECORD(
         HITKeyRef   HitransactionDefinition.Transactionkeyref%TYPE
        ,SpecialFunc VARCHAR2(80)                      -- Special Function, such as Report, etc.
        ,BOColName   user_tab_columns.COLUMN_NAME%TYPE -- Business Object Column Name
        ,TableName   user_tables.table_name%TYPE       -- Table Name
        ,ColumnName  user_tab_columns.COLUMN_NAME%TYPE -- Column Name
        ,PropertyKey property.propertykey%TYPE         -- Property Key
        ,PSKey       propertyset.pskey%TYPE);          -- PS Key
    --
    TYPE taHiTKeyRef IS TABLE OF trActionDef INDEX BY BINARY_INTEGER;
    TYPE taSpecialFunc IS TABLE OF trActionDef INDEX BY BINARY_INTEGER;

    -- Public constant declarations

    -- Public variable declarations

    -- Public function and procedure declarations

    -- #usage Append the given column name, new and old values to a specified array
    -- #usage to be used in procedure CheckVal.
    -- #param iColName   Column Name
    -- #param iNewVal    New Value
    -- #param iOldVal    Old Value
    -- #param ioRowInfo  Row Info
    PROCEDURE SetColInfo(iColName  IN VARCHAR2
                        ,iNewVal   IN LONG
                        ,iOldVal   IN LONG
                        ,ioRowInfo IN OUT taColInfo);

    -- #usage Determine what action to be taken by looking at the table name, PFCode,
    -- #usage trigger action and row information passed in
    -- #param iTableName     Table Name
    -- #param iPFCode        PF Code
    -- #param iAction        Trigger Action, (I, U, or D)
    -- #param iRowInfo       Row Info
    PROCEDURE CheckVal(iTableName       IN VARCHAR2
                      ,iPFCode          IN VARCHAR2
                      ,iAction          IN CHAR
                      ,iRowInfo         IN taColInfo);

    -- #usage Check whether there are any action definitions for the given
    -- #usage property table and propertykey in actiondefintion table.  This
    -- #usage is called in the beginning of the user defined row trigger for
    -- #usage a quick check.
    -- #param iTableName     Table Name
    -- #param iPropertyKey   Property Key
    -- SEPC-27136. Added RESULT_CACHE to improve performance.
    FUNCTION AnyActionDef(iTableName   IN VARCHAR2
                         ,iPropertyKey IN Property.Propertykey%TYPE
                         ,iAction      IN CHAR)
                         RETURN BOOLEAN RESULT_CACHE;
    -----------------------------------------------------------------------------
    -- Returns a string containing source control file version information
    FUNCTION version RETURN VARCHAR2;

    g_BatchUser     PLS_Integer := pkg_util.syspropval ('BATCH_USERID', 'N');

END pkg_ActionAudit;
/
CREATE OR REPLACE PACKAGE BODY pkg_ActionAudit IS

    -- Private type declarations
    TYPE trPropFunc IS RECORD(
         PFCode       propertyfunction.pfcode%TYPE
        ,TableName    propertyfunction.tablename%TYPE
        ,FKColName    propertyfunction.fkcolname%TYPE
        ,ObjTableName propertyfunction.objecttablename%TYPE
        ,IDColName    propertyfunction.idcolname%TYPE);

    TYPE taPropFunc IS TABLE OF trPropFunc INDEX BY PropertyFunction.Pfcode%TYPE;
    g_PropFuncSet taPropFunc;

    -- Function and procedure implementations
    --
    --------------------------------------------------------------------------------
    --
    --  This function returns the version of the current package.
    --
    --------------------------------------------------------------------------------
    FUNCTION version RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Pkg_ActionAudit.sql $Revision: \hubu_unix_src?main?enaus\3 $ $Date: Wed Aug 20 16:33:15 2014 $';
    END version;
    --
    --
    PROCEDURE SetColInfo(iColName  VARCHAR2
                        ,iNewVal   LONG
                        ,iOldVal   LONG
                        ,ioRowInfo IN OUT taColInfo) IS
        i PLS_INTEGER := 0;
    BEGIN
        i := ioRowInfo.COUNT + 1;
        ioRowInfo(i).NAME := iColName;
        ioRowInfo(i).NewVal := iNewVal;
        ioRowInfo(i).OldVal := iOldVal;
    END SetColInfo;
    --
    -- SEPI-27136. Hard coding 'BACCT','CCNO','LSMACH','EMBNC','PPSTATUS' in this generic procedure is bad coding style. It caused trouble when we want to trigger both CDN and other special functions.
    -- The current CDN logic appears to be:
    --  1. If triggered from HITRANSACTIONPROPERTY, then send CDN regardless of batch user.
    --  2. If triggered from anywhere else, then bypass CDN if triggered by batch user.
    --  3. All other transactions and special functions should still fire regardless of batch user.
    -- Therefore a better way to handle CDN is in the cActionDef cursor of CheckVal.
    FUNCTION AnyActionDef(iTableName   IN VARCHAR2
                         ,iPropertyKey IN Property.Propertykey%TYPE
                         ,iAction      IN CHAR)
                         RETURN BOOLEAN RESULT_CACHE IS
    BEGIN
        FOR rec IN (SELECT ad.transactionkeyref
                          ,ad.specialfunc
                    FROM   ActionDefinition ad
                    WHERE  upper(ad.tablename) = upper(iTableName)
                    AND   (ad.propertykey||ad.ColumnName IS NULL OR ad.propertykey||ad.ColumnName = iPropertyKey)  -- SEPC-27136. Added NULL propertyky check.
                    AND    instr(ad.TriggerAction,iAction) > 0
                    AND    status = 'A') LOOP
            RETURN TRUE;
        END LOOP;
        
        RETURN FALSE;
    END AnyActionDef;
    --
    -- Load Property Functions
    PROCEDURE LoadPropFuncs AS
        CURSOR cPropFunc IS
            SELECT PFCode
                  ,TableName
                  ,FKColName
                  ,ObjectTableName
                  ,IDColName
            FROM   PropertyFunction
            WHERE  PFTYPE = 'BASE'
            ORDER  BY PFCode
                     ,TableName;
        --
        l_Key VARCHAR2(40);
    BEGIN
        FOR rec IN cPropFunc LOOP
            l_Key := rec.PFCode;
            g_PropFuncSet(l_Key).PFCode := rec.PFCode;
            g_PropFuncSet(l_Key).TableName := rec.TableName;
            g_PropFuncSet(l_Key).FKColName := rec.FKColName;
            g_PropFuncSet(l_Key).ObjTableName := rec.ObjectTableName;
            g_PropFuncSet(l_Key).IDColName := rec.IDColName;
        END LOOP;
    END LoadPropFuncs;
    --
    -- Get Column Info
    FUNCTION GetColInfo(iRowInfo IN taColInfo
                       ,iColName IN VARCHAR2) RETURN VARCHAR2 AS
        i         PLS_INTEGER;
        l_ColInfo trColInfo := NULL;
    BEGIN
        FOR i IN 1 .. iRowInfo.COUNT LOOP
            IF upper(iRowInfo(i).NAME) = upper(iColName) THEN
                l_ColInfo := iRowInfo(i);
                EXIT;
            END IF;
        END LOOP;
        --
        RETURN NVL(l_ColInfo.NewVal,l_ColInfo.OldVal);
    END GetColInfo;
    --
    -- Get the Primary Key Column Name
    FUNCTION GetPKName(iTableName IN VARCHAR2) RETURN VARCHAR2 RESULT_CACHE AS
    BEGIN
        FOR rec IN (SELECT column_name
                    FROM   user_cons_columns ucc
                    WHERE  ucc.constraint_name =
                           (SELECT uc.constraint_name
                            FROM   user_constraints uc
                            WHERE  table_name = upper(iTableName)
                            AND    constraint_type = 'P')
                    AND    ucc.table_name = upper(iTableName)) LOOP
            RETURN rec.column_name;
        END LOOP;
        RETURN NULL;
    END GetPKName;
    --
    -- CheckVal: Check whether the value has changed, if so, determine
    --           what action to be taken.
    PROCEDURE CheckVal(iTableName IN VARCHAR2
                      ,iPFCode    IN VARCHAR2
                      ,iAction    IN CHAR
                      ,iRowInfo   IN taColInfo) IS
        --
    CURSOR cActionDef(iPSId      IN PropertySet.Psid%TYPE
                     ,iTableName IN VARCHAR2
                     ,iPropKey   IN VARCHAR2
                     ,iColName   IN VARCHAR2
                     ,iAction    IN VARCHAR2) IS
        SELECT /*+ result_cache */ ad.transactionKeyRef
              ,ad.specialfunc
              ,ad.BOColName
              ,ad.tablename
              ,ad.columnname
              ,ad.propertykey
              ,ad.PSKey
        FROM   ActionDefinition ad
        WHERE  ((iPSID IS NULL AND ad.PSKey IS NULL) OR
               (iPSID IS NOT NULL AND
               ad.pskey = (SELECT ps.pskey
                           FROM   PropertySet ps
                           WHERE  ps.psid = iPSID)))
        AND    upper(ad.TableName) = upper(iTableName)
        AND   (ad.propertyKey||ad.ColumnName IS NULL OR ad.propertyKey||ad.ColumnName = iPropKey||iColName)
        AND    ad.Status = 'A'
        AND    instr(ad.TriggerAction,iAction) > 0;
        --
        l_NewVal        LONG := NULL;
        l_OldVal        LONG := NULL;
        HiTKeyRefList   taHiTKeyRef;
        SpecialFuncList taSpecialFunc;
        l_PSID          PropertySet.Psid%TYPE;
        l_FKColName     PropertyFunction.Fkcolname%TYPE;
        l_ObjTableName  PropertyFunction.Objecttablename%TYPE;
        l_SQL           VARCHAR2(500);
        l_Key           VARCHAR2(40);
        l_ByPass        VARCHAR2(250);
        l_ParentID      NUMBER;
        l_PMKID         NUMBER;
        l_PMKNM         user_tab_columns.COLUMN_NAME%TYPE;
        --
        -- Check whether the value has been changed
        FUNCTION ValChanged(iNewVal IN LONG
                           ,iOldVal IN LONG) RETURN BOOLEAN AS
        BEGIN
            IF iNewVal IS NOT NULL
               AND iOldVal IS NULL THEN
                RETURN TRUE;
            ELSIF iNewVal IS NULL
                  AND iOldVal IS NOT NULL THEN
                RETURN TRUE;
            ELSIF iNewVal != iOldVal THEN
                RETURN TRUE;
            END IF;

            RETURN FALSE;
        END ValChanged;
        --
        -- Add a record to HITKeyRefList or ReportKeyList
        PROCEDURE AddToList(iHITKeyRef        IN HitransactionDefinition.Transactionkeyref%TYPE
                           ,iSpecialFunc      IN VARCHAR2
                           ,iBOColName        IN user_tab_columns.COLUMN_NAME%TYPE
                           ,iTableName        IN user_tables.table_name%TYPE
                           ,iColumnName       IN user_tab_columns.COLUMN_NAME%TYPE
                           ,iPropertyKey      IN property.propertykey%TYPE
                           ,iPSKey            IN propertyset.pskey%TYPE
                           ,ioHITKeyRefList   IN OUT taHiTKeyRef
                           ,ioSpecialFuncList IN OUT taSpecialFunc) AS
            --
            l_Count        PLS_INTEGER := 0;
        BEGIN
            IF iHITKeyRef IS NOT NULL THEN
                l_Count := ioHiTKeyRefList.COUNT + 1;
                ioHiTKeyRefList(l_Count).HITKeyRef := iHITKeyRef;
                ioHiTKeyRefList(l_Count).BOColName := iBOColName;
                ioHiTKeyRefList(l_Count).TableName := iTableName;
                ioHiTKeyRefList(l_Count).ColumnName :=iColumnName;
                ioHiTKeyRefList(l_Count).PropertyKey := iPropertyKey;
                ioHiTKeyRefList(l_Count).PSKey := iPSKey;
            END IF;
            --
            IF iSpecialFunc IS NOT NULL THEN
                l_Count := ioSpecialFuncList.COUNT + 1;
                ioSpecialFuncList(l_Count).SpecialFunc := iSpecialFunc;
                ioSpecialFuncList(l_Count).BOColName := iBOColName;
                ioSpecialFuncList(l_Count).TableName := iTableName;
                ioSpecialFuncList(l_Count).ColumnName :=iColumnName;
                ioSpecialFuncList(l_Count).PropertyKey := iPropertyKey;
                ioSpecialFuncList(l_Count).PSKey := iPSKey;
            END IF;
        END AddToList;
        --
        -- Look through ActionDefinition table to build up HITKeyRefList and
        -- ReportKeyList
        PROCEDURE SearchActionDef(iPSID             IN VARCHAR2
                                 ,iTableName        IN VARCHAR2
                                 ,iPropKey          IN VARCHAR2
                                 ,iColName          IN VARCHAR2
                                 ,iAction           IN VARCHAR2
                                 ,ioHITKeyRefList   IN OUT taHiTKeyRef
                                 ,ioSpecialFuncList IN OUT taSpecialFunc) AS
        lctacttype  bucontact.contacttype%type;
        lhmbrtype   hierarchymbr.hmbrtype%type;
        lhmbrID     hierarchymbr.hmbrID%type;
        ltreatmtgrp hmbrproperty.propvalchar%type;
        loutccnt    pls_integer;
        lbuid       bucontact.buid%type;
        BEGIN
            FOR rec IN cActionDef(iPSID
                                 ,iTableName
                                 ,iPropKey
                                 ,iColName
                                 ,iAction) LOOP
                IF instr(rec.transactionkeyref||rec.specialfunc,l_ByPass) > 0 THEN
                    NULL; -- this can be used in some cases a property change actions can be bypassed.
                ELSIF rec.TransactionKeyRef LIKE 'CustomerDetailsNotifRcB2B%' THEN
                    IF pkg_audit.GetUserID = g_BatchUser THEN
                        NULL;  -- this part is moved from AnyActionDef. A special handling on CDN and batch user.
                    ELSIF upper(iTableName)  = 'BUCONTACTPROPERTY' AND l_ParentId IS NOT NULL THEN
                        FOR BUCREC in (Select bu.contacttype , hmbrtype, hmbrid, bu.buid   -- get contact type and details of the linked BU
                                       from   bucontact bu, hierarchymbr hm
                                       where  BUCONTACTID = l_ParentId
                                       AND    hm.buid     = bu.buid
                                       AND    hm.hmbrtype in ('R','BP')
                                       ) LOOP
                            lctacttype := BUCREC.contacttype;
                            lhmbrtype  := BUCREC.hmbrtype;
                            lhmbrID    := BUCREC.hmbrID;
                            lbuid      := BUCREC.buid ;
                        END LOOP;

                        IF Pkg_Hi_CustDetNotif.g_BUoutageflg = 'Y' THEN -- default outage contact
                            lctacttype := 'OUT' ;
                        END IF;
                        IF (lctacttype = 'OUT' )  THEN  --  trigger CDN for Elec account only

                            IF rec.TransactionKeyRef = 'CustomerDetailsNotifRcB2B' THEN

                               IF  lhmbrtype = 'R' THEN -- SEPC-210 outage contact at the account billing point level is modified
                                   FOR BUCREC in ( select bu1.buid -- check to see whether there exists outage contact at Elec Billing accounts
                                            from   bucontact bu1, hierarchymbr hm
                                            Where  bu1.BUID in  (select hm1.buid
                                                                 from hierarchymbr hm1
                                                                 where   hmbrtype = 'BP'
                                                                 connect by parentbuid = prior buid
                                                                 start with parentbuid = lbuid)
                                             AND contacttype = 'OUT'
                                             AND hm.buid     = bu1.buid
                                             AND exists  (select 0
                                                          from   hmbrproperty
                                                          where  propertykey = 'TRTGRP'
                                                          and    hmbrid = hm.hmbrid
                                                          and    propvalchar = 'E') )  LOOP
                                       g_exkeylist(BUCREC.buid) := 'Y';  -- populate list of account to be excldued from CDN
                                   END LOOP;
                               ELSE  -- account outage is changed
                                  FOR ACCRec in (select propvalchar
                                                 from   hmbrproperty
                                                 where  propertykey = 'TRTGRP'
                                                 and    hmbrid = lhmbrID) loop
                                      ltreatmtgrp := ACCRec.propvalchar;
                                  END LOOP;
                                  IF ltreatmtgrp = 'E' THEN -- outage on an Elec Account account is changed
                                      FOR BUCREC in ( select h.buid
                                                      from hierarchymbr h,
                                                      (select hm1.buid
                                                      from hierarchymbr hm1
                                                      where   hmbrtype = 'BP'
                                                      connect by parentbuid = prior buid
                                                      start with parentbuid = (select rootbuid
                                                                              from   businessunit
                                                                              where  buid = lbuid)) h2
                                                      where h.buid = h2.buid
                                                      AND   h.buid <> lbuid
                                                      AND exists  (select 0
                                                                  from   hmbrproperty
                                                                  where  propertykey = 'TRTGRP'
                                                                  and    hmbrid = h.hmbrid
                                                                  and    propvalchar = 'E') )  LOOP
                                            g_exkeylist(BUCREC.buid) := 'Y';  -- populate list of account to be excldued from CDN
                                       END LOOP;
                                  END IF;
                               END IF;
                               AddToList(rec.TransactionKeyRef
                                         ,rec.SpecialFunc
                                         ,rec.BOColName
                                         ,rec.TableName
                                         ,rec.ColumnName
                                         ,rec.PropertyKey
                                         ,rec.PSKey
                                         ,ioHITKeyRefList
                                         ,ioSpecialFuncList);
                            END IF;
                        ELSE -- non-outage contage change
                            select count(*)
                            into   loutccnt
                            from   bucontact bu
                            where  bu.BUID = lbuid
                            AND    contacttype = 'OUT';

                            IF loutccnt > 0 THEN -- a Non-outage contact is change but there exists customer outage  therefore no CDN triggers for all Elec accts
                               IF rec.TransactionKeyRef <> 'CustomerDetailsNotifRcB2B' THEN -- trigger CDN for GAS only
                                  AddToList(rec.TransactionKeyRef
                                           ,rec.SpecialFunc
                                           ,rec.BOColName
                                           ,rec.TableName
                                           ,rec.ColumnName
                                           ,rec.PropertyKey
                                           ,rec.PSKey
                                           ,ioHITKeyRefList
                                           ,ioSpecialFuncList);
                               END IF;
                            ELSE -- no customer outage contact therefore need to check to exclude Elec accounts that has outage contact attached to them
                               FOR BUCREC in (  select hm.buid
                                                from   bucontact bu1, hierarchymbr hm
                                                Where  hm.BUID in  ( select hm1.buid
                                                                     from hierarchymbr hm1
                                                                     where   hmbrtype = 'BP'
                                                                     connect by parentbuid = prior buid
                                                                     start with parentbuid = lbuid)
                                                 AND hm.buid     = bu1.buid
                                                 AND hm.hmbrtype = 'BP'
                                                 AND contacttype = 'OUT'
                                                 AND exists  (select 0
                                                              from   hmbrproperty
                                                              where  propertykey = 'TRTGRP'
                                                              and    hmbrid = hm.hmbrid
                                                              and    propvalchar = 'E') )  LOOP
                                   g_exkeylist(BUCREC.buid) := 'Y';  -- populate list of account to be excldued from CDN
                               END LOOP;
                               AddToList(rec.TransactionKeyRef
                                         ,rec.SpecialFunc
                                         ,rec.BOColName
                                         ,rec.TableName
                                         ,rec.ColumnName
                                         ,rec.PropertyKey
                                         ,rec.PSKey
                                         ,ioHITKeyRefList
                                         ,ioSpecialFuncList);
                            END IF;

                        END IF;
                    ELSE
                        -- SEPI-27136. The CustomerDetailsNotifRcB2B in actiondefinition table is already disabled so no need to hard code here.
                       AddToList(rec.TransactionKeyRef
                                 ,rec.SpecialFunc
                                 ,rec.BOColName
                                 ,rec.TableName
                                 ,rec.ColumnName
                                 ,rec.PropertyKey
                                 ,rec.PSKey
                                 ,ioHITKeyRefList
                                 ,ioSpecialFuncList);
                    END IF;
                ELSE
                    AddToList(rec.TransactionKeyRef
                             ,rec.SpecialFunc
                             ,rec.BOColName
                             ,rec.TableName
                             ,rec.ColumnName
                             ,rec.PropertyKey
                             ,rec.PSKey
                             ,ioHITKeyRefList
                             ,ioSpecialFuncList);
                END IF;
            END LOOP;
        END SearchActionDef;
    --
    BEGIN
        g_exkeylist.delete; -- SEPC-210
        -- Load PropertyFunction into an associated arry If it has not been loaded,
        IF g_PropFuncSet.COUNT = 0 THEN
            LoadPropFuncs;
        END IF;
        --
        -- For the given PFCode, Check whether the specified table is
        -- a property table
        IF iPFCode IS NOT NULL
           AND iTableName IS NOT NULL THEN
            l_Key := iPFCode;
            BEGIN
                l_FKColName    := g_PropFuncSet(l_Key).FKColName;
                l_ObjTableName := g_PropFuncSet(l_Key).ObjTableName;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
        END IF;
        l_ByPass := GetColInfo(iRowInfo,'BYPASSACTION');
        --
        HiTKeyRefList.DELETE;
        SpecialFuncList.DELETE;
        --
        -- If the ObjectTableName is different with the TableName, we know
        -- the specified table is a property table.  The example of such table
        -- is SPProperty
        IF l_ObjTableName IS NOT NULL
           AND upper(iTableName) != upper(l_ObjTableName) THEN
            -- Get PSID via looking the parent table
            l_ParentId := to_number(GetColInfo(iRowInfo,l_FKColName));
            IF l_ParentId IS NOT NULL THEN
                l_SQL := 'SELECT PSID FROM ' || l_ObjTableName || ' ' ||
                         'WHERE ' || l_FKColName || ' = ' || l_ParentId;
                EXECUTE IMMEDIATE l_SQL
                    INTO l_PSID;
            END IF;
            --
            FOR i IN 1 .. iRowInfo.COUNT LOOP
                l_NewVal := l_NewVal || iRowInfo(i).NewVal;
                l_OldVal := l_OldVal || iRowInfo(i).OldVal;
            END LOOP;
            --  If the row changed, look through the ActionDefinition table for HiTransactionKeyRef
            IF ValChanged(l_NewVal
                         ,l_OldVal) THEN
                SearchActionDef(l_PSID
                               ,iTableName
                               ,GetColInfo(iRowInfo,'PropertyKey')
                               ,NULL
                               ,iAction
                               ,HiTKeyRefList
                               ,SpecialFuncList);
            END IF;
        ELSE
            -- Check whether the table contains PSID column, if so, get
            -- the PSID value.  The example of this kind table is SupplyPoint.
            -- If the table doesn't contain PSID column, l_PSID will be NULL as
            -- it is set via initialisation.  The example of such table is ReadingDumb.
            l_PSID := GetColInfo(iRowInfo,'PSID');
            -- Look through ActionDefiniton table for the HiTransactionKeyRef for the column changed.
            FOR i IN 1 .. iRowInfo.COUNT LOOP
                IF NVL(iRowInfo(i).NAME,'x') NOT IN ('ENTITY','ENTITYID','PSID') THEN
                    IF ValChanged(iRowInfo(i).NewVal
                                 ,iRowInfo(i).OldVal) THEN
                        -- Look through ActionDefintion table
                        SearchActionDef(l_PSID
                                       ,iTableName
                                       ,NULL
                                       ,iRowInfo(i).NAME      -- Column Name
                                       ,iAction
                                       ,HiTKeyRefList
                                       ,SpecialFuncList);
                    END IF;
                END IF;
            END LOOP;
        END IF;
        --
        IF HITKeyRefList.COUNT > 0 THEN
            -- Get Primary Key Name and ID
            IF l_ObjTableName IS NOT NULL
               AND upper(l_ObjTableName) != upper(iTableName) THEN
                l_PMKID := l_ParentID;
                l_PMKNM := l_FKColName;
            ELSE
                l_PMKNM        := GetPKName(iTableName);
                l_PMKID        := to_number(GetColInfo(iRowInfo,l_PMKNM));
                l_ObjTableName := iTableName;
            END IF;
            --
            pkg_ActionAfter.Perform(l_PMKNM         -- Object Table Primary Key Name
                                   ,l_PMKID         -- Object Table Primary Key ID
                                   ,l_ObjTableName  -- Object Table Name
                                   ,HITKeyRefList   -- List of Hitransaction Key Refs
                                   ,iRowInfo
                                   ,iAction);      -- SEPI-12756
        END IF;
        -- SEPI-27136. Now we need to call them all since one change could trigger multiple actions.
        IF SpecialFuncList.COUNT > 0 THEN
            pkg_ActionAfter.Perform(iAction
                                   ,iRowInfo
                                   ,SpecialFuncList);
        END IF;
    END;
    --
BEGIN
    -- Initialization
    NULL;
END pkg_ActionAudit;
/
