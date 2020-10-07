/***This Artifact belongs to the Data SQL Ninja Engineering Team***/
-- FEATURE 1 (DATABASE_SIZE_MB)
SELECT '01' AS FEATURE_ID,'Total Database Size' AS FEATURE_NAME , INT((A.SPACETS + B.SPACEIX)/1024) AS VALUE
FROM 
(	SELECT SUM(A.SPACEF) AS SPACETS 
	FROM SYSIBM.SYSTABLEPART A
	WHERE A.SPACEF > 0 
) AS A , 
(	SELECT SUM(B.SPACEF) AS SPACEIX 
	FROM SYSIBM.SYSINDEXPART B
	WHERE B.SPACEF > 0
) AS B

UNION ALL


-- FEATURE 2 (DATABASE_VERSION)
SELECT '02' AS FEATURE_ID,'Database Version' AS FEATURE_NAME, INT(SUBSTR(GETVARIABLE('SYSIBM.VERSION'),4)) AS VALUE FROM SYSIBM.SYSDUMMY1

UNION ALL


-- FEATURE 3 (DATABASE_ENCODING)
SELECT '03' AS FEATURE_ID,'Database Encoding' AS FEATURE_NAME, 
CASE 
	WHEN GETVARIABLE('SYSIBM.ENCODING_SCHEME') = 'EBCDIC' THEN 37
	WHEN GETVARIABLE('SYSIBM.ENCODING_SCHEME') = 'UNICODE' THEN 1024 
	WHEN GETVARIABLE('SYSIBM.ENCODING_SCHEME') = 'ASCII' THEN 65 
	ELSE 0
END AS VALUE FROM SYSIBM.SYSDUMMY1

UNION ALL


-- FEATURE 4 (DATABASE_COUNT)
SELECT '04' AS FEATURE_ID,'Databases' AS FEATURE_NAME, COUNT(*) AS VALUE FROM SYSIBM.SYSDATABASE

UNION ALL


-- FEATURE 5 (PACKAGE_COUNT)
SELECT '05' AS FEATURE_ID,'Packages' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSPACKAGE
WHERE VALID <> 'N' 
  AND OPERATIVE <> 'N' 
  AND TYPE = ' '

UNION ALL

  
-- FEATURE 6 (TABLE_COUNT)
SELECT '06' AS FEATURE_ID,'Tables' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLES
WHERE TYPE NOT IN ('M','V','G')

UNION ALL



-- FEATURE 7 (VIEW_COUNT)
SELECT '07' AS FEATURE_ID,'Views' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLES
WHERE TYPE IN ('V')

UNION ALL



-- FEATURE 8 (MQT_COUNT)
SELECT '08' AS FEATURE_ID,'Materialized Query Tables' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLES
WHERE TYPE IN ('M')

UNION ALL



-- FEATURE 9 (GTT_COUNT)
SELECT '09' AS FEATURE_ID,'Global Temporary Tables' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLES
WHERE TYPE IN ('G')

UNION ALL



-- FEATURE 10 (TRIGGER_COUNT)
SELECT '10' AS FEATURE_ID,'Triggers' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTRIGGERS
WHERE TRIGTIME NOT IN ('I')

UNION ALL



-- FEATURE 11 (INDEX_COUNT)
SELECT '11' AS FEATURE_ID,'Indexes' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSINDEXES

UNION ALL



-- FEATURE 12 (TABLESPACE_COUNT)
SELECT '12' AS FEATURE_ID,'Tablespaces' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLESPACE

UNION ALL



-- FEATURE 13 (STORAGEGROUP_COUNT)
SELECT '13' AS FEATURE_ID, 'Storagegroups' AS FEATURE_NAME, COUNT(*) AS VALUE 
FROM SYSIBM.SYSSTOGROUP

UNION ALL



-- FEATURE 14 (SEQUENCE_COUNT)
SELECT '14' AS FEATURE_ID, 'Sequences' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSSEQUENCES

UNION ALL



-- FEATURE 15 (ADMIN_AUTHORITIES_COUNT)
SELECT '15' AS FEATURE_ID, 'Admin Authorities' AS FEATURE_NAME, COUNT(*) AS VALUE  
FROM SYSIBM.SYSUSERAUTH
WHERE SYSADMAUTH <> ' '
   OR SYSOPRAUTH <> ' '
   OR SYSCTRLAUTH <> ' '
   OR SQLADMAUTH <> ' '
   OR SDBADMAUTH <> ' '

UNION ALL


   
-- FEATURE 16 (DATATYPES_COUNT)
SELECT '16' AS FEATURE_ID, 'Data Types' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM ( SELECT DISTINCT COLTYPE FROM SYSIBM.SYSCOLUMNS) A

UNION ALL



-- FEATURE 17 (PARTITIONED_TS_COUNT)
SELECT '17' AS FEATURE_ID, 'Partitioned Tablespaces' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLESPACE
WHERE PARTITIONS > 0
  AND TYPE NOT IN ('G','P','O')

UNION ALL  



-- FEATURE 18 (RBAC_COUNT)
SELECT '18' AS FEATURE_ID, 'Role-based Access Control' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSCONTROLS  
WHERE CONTROL_TYPE = 'R'

UNION ALL



-- FEATURE 19 (SP_COUNT)
SELECT '19' AS FEATURE_ID, 'Stored Procedures' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSROUTINES
WHERE ROUTINETYPE = 'P'

UNION ALL



-- FEATURE 20 (UDF_COUNT)
SELECT '20' AS FEATURE_ID, 'User-Defined Functions' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSROUTINES
WHERE ROUTINETYPE = 'F'

UNION ALL



-- FEATURE 21 (TEMPORAL_COUNT)
SELECT '21' AS FEATURE_ID, 'Temporal Tables' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLES A
WHERE A.TYPE = 'H'
  AND EXISTS (SELECT 1 FROM SYSIBM.SYSCOLUMNS B
  			  WHERE A.NAME = B.TBNAME
  			  	AND A.CREATOR = B.TBCREATOR
  			  	AND B.PERIOD IN ('B','C','S','T'))

UNION ALL  			  	



-- FEATURE 22 (CHECK_CONSTRAINT_COUNT)
SELECT '22' AS FEATURE_ID, 'Check Constraints' AS FEATURE_NAME, COUNT(*) AS VALUE 
FROM SYSIBM.SYSCHECKS  			 

UNION ALL



-- FEATURE 23 (UNIQUE_PRIMARYKEY_COUNT)
SELECT '23' AS FEATURE_ID, 'Unique Constraints' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABCONST

UNION ALL



-- FEATURE 24 (SCHEMA_COUNT)
SELECT '24' AS FEATURE_ID, 'Schemas' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM
(SELECT DISTINCT OBJECTSCHEMA FROM SYSIBM.SYSAUDITPOLICIES UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSCHECKS UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSCOLAUTH UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSCOLUMNS UNION
 SELECT DISTINCT TYPESCHEMA FROM SYSIBM.SYSCOLUMNS UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSCOLUMNS_HIST UNION
 SELECT DISTINCT BSCHEMA FROM SYSIBM.SYSCONSTDEP UNION
 SELECT DISTINCT DTBCREATOR FROM SYSIBM.SYSCONSTDEP UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSCONTROLS UNION
 SELECT DISTINCT TBSCHEMA FROM SYSIBM.SYSCONTROLS UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSDATABASE UNION
 SELECT DISTINCT CREATORTYPE FROM SYSIBM.SYSDATABASE UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSDATATYPES UNION
 SELECT DISTINCT SOURCESCHEMA FROM SYSIBM.SYSDATATYPES UNION
 SELECT DISTINCT PLCREATOR FROM SYSIBM.SYSDBRM UNION
 SELECT DISTINCT PLCREATORTYPE FROM SYSIBM.SYSDBRM UNION
 SELECT DISTINCT BSCHEMA FROM SYSIBM.SYSDEPENDENCIES UNION
 SELECT DISTINCT DSCHEMA FROM SYSIBM.SYSDEPENDENCIES UNION
 SELECT DISTINCT CURRENT_SCHEMA FROM SYSIBM.SYSENVIRONMENT UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSFIELDS UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSFOREIGNKEYS UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSINDEXES UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSINDEXES UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSINDEXES_HIST UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSINDEXES_HIST UNION
 SELECT DISTINCT IXCREATOR FROM SYSIBM.SYSINDEXPART UNION
 SELECT DISTINCT IXCREATOR FROM SYSIBM.SYSINDEXPART_HIST UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSINDEXSPACESTATS UNION
 SELECT DISTINCT JARSCHEMA FROM SYSIBM.SYSJARCONTENTS UNION
 SELECT DISTINCT JARSCHEMA FROM SYSIBM.SYSJAROBJECTS UNION
 SELECT DISTINCT BUILDSCHEMA FROM SYSIBM.SYSJAVAOPTS UNION
 SELECT DISTINCT JARSCHEMA FROM SYSIBM.SYSJAVAOPTS UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSKEYCOLUSE UNION
 SELECT DISTINCT IXCREATOR FROM SYSIBM.SYSKEYS UNION
 SELECT DISTINCT IXSCHEMA FROM SYSIBM.SYSKEYTARGETS UNION
 SELECT DISTINCT TYPESCHEMA FROM SYSIBM.SYSKEYTARGETS UNION
 SELECT DISTINCT IXSCHEMA FROM SYSIBM.SYSKEYTARGETSTATS UNION
 SELECT DISTINCT IXSCHEMA FROM SYSIBM.SYSKEYTARGETS_HIST UNION
 SELECT DISTINCT TYPESCHEMA FROM SYSIBM.SYSKEYTARGETS_HIST UNION
 SELECT DISTINCT IXSCHEMA FROM SYSIBM.SYSKEYTGTDIST UNION
 SELECT DISTINCT IXSCHEMA FROM SYSIBM.SYSKEYTGTDISTSTATS UNION
 SELECT DISTINCT IXSCHEMA FROM SYSIBM.SYSKEYTGTDIST_HIST UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSOBDS UNION
 SELECT DISTINCT DSCHEMA FROM SYSIBM.SYSOBJROLEDEP UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSPACKAGE UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSPACKCOPY UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSPARMS UNION
 SELECT DISTINCT TYPESCHEMA FROM SYSIBM.SYSPARMS UNION
 SELECT DISTINCT OBJSCHEMA FROM SYSIBM.SYSPENDINGDDL UNION
 SELECT DISTINCT OBJSCHEMA FROM SYSIBM.SYSPENDINGOBJECTS UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSPLAN UNION
 SELECT DISTINCT CREATORTYPE FROM SYSIBM.SYSPLAN UNION
 SELECT DISTINCT BCREATOR FROM SYSIBM.SYSPLANDEP UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSQUERY UNION
 SELECT DISTINCT ACCESSCREATOR FROM SYSIBM.SYSQUERYPLAN UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSQUERYPLAN UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSRELS UNION
 SELECT DISTINCT REFTBCREATOR FROM SYSIBM.SYSRELS UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSROUTINEAUTH UNION
 SELECT DISTINCT JARSCHEMA FROM SYSIBM.SYSROUTINES UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSROUTINES UNION
 SELECT DISTINCT SOURCESCHEMA FROM SYSIBM.SYSROUTINES UNION
 SELECT DISTINCT BUILDSCHEMA FROM SYSIBM.SYSROUTINES_OPTS UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSROUTINES_OPTS UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSROUTINES_SRC UNION
 SELECT DISTINCT SCHEMANAME FROM SYSIBM.SYSSCHEMAAUTH UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSSEQUENCEAUTH UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSSEQUENCES UNION
 SELECT DISTINCT SEQSCHEMA FROM SYSIBM.SYSSEQUENCES UNION
 SELECT DISTINCT BSCHEMA FROM SYSIBM.SYSSEQUENCESDEP UNION
 SELECT DISTINCT DCREATOR FROM SYSIBM.SYSSEQUENCESDEP UNION
 SELECT DISTINCT DSCHEMA FROM SYSIBM.SYSSEQUENCESDEP UNION
 SELECT DISTINCT IXCREATOR FROM SYSIBM.SYSSTATFEEDBACK UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSSTATFEEDBACK UNION
 SELECT DISTINCT PLCREATOR FROM SYSIBM.SYSSTMT UNION
 SELECT DISTINCT PLCREATORTYPE FROM SYSIBM.SYSSTMT UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSSTOGROUP UNION
 SELECT DISTINCT CREATORTYPE FROM SYSIBM.SYSSTOGROUP UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSSYNONYMS UNION
 SELECT DISTINCT CREATORTYPE FROM SYSIBM.SYSSYNONYMS UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSSYNONYMS UNION
 SELECT DISTINCT SCREATOR FROM SYSIBM.SYSTABAUTH UNION
 SELECT DISTINCT TCREATOR FROM SYSIBM.SYSTABAUTH UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSTABCONST UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSTABCONST UNION
 SELECT DISTINCT IXCREATOR FROM SYSIBM.SYSTABLEPART UNION
 SELECT DISTINCT ARCHIVING_SCHEMA FROM SYSIBM.SYSTABLES UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSTABLES UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.SYSTABLES UNION
 SELECT DISTINCT VERSIONING_SCHEMA FROM SYSIBM.SYSTABLES UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSTABLESPACE UNION
 SELECT DISTINCT CREATORTYPE FROM SYSIBM.SYSTABLESPACE UNION
 SELECT DISTINCT ROOTCREATOR FROM SYSIBM.SYSTABLESPACE UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSTABLES_HIST UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSTABLES_PROFILES UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSTRIGGERS UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSVARIABLEAUTH UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.SYSVARIABLES UNION
 SELECT DISTINCT TYPESCHEMA FROM SYSIBM.SYSVARIABLES UNION
 SELECT DISTINCT BCREATOR FROM SYSIBM.SYSVIEWDEP UNION
 SELECT DISTINCT BSCHEMA FROM SYSIBM.SYSVIEWDEP UNION
 SELECT DISTINCT DCREATOR FROM SYSIBM.SYSVIEWDEP UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.SYSVIEWS UNION
 SELECT DISTINCT SGCREATOR FROM SYSIBM.SYSVOLUMES UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.PLAN_TABLE UNION
 SELECT DISTINCT ACCESSCREATOR FROM SYSIBM.PLAN_TABLE UNION
 SELECT DISTINCT SCHEMA_NAME FROM SYSIBM.DSN_FUNCTION_TABLE UNION
 SELECT DISTINCT VIEW_CREATOR FROM SYSIBM.DSN_FUNCTION_TABLE UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.DSN_VIEWREF_TABLE UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.DSN_COLDIST_TABLE UNION
 SELECT DISTINCT IXSCHEMA FROM SYSIBM.DSN_KEYTGTDIST_TABLE UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.DSN_STAT_FEEDBACK UNION
 SELECT DISTINCT IXCREATOR FROM SYSIBM.DSN_STAT_FEEDBACK UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.DSNPROGAUTH UNION
 SELECT DISTINCT SCHEMA FROM SYSIBM.EXPLAIN_MAINT_TB_NOT_UPGRADED UNION
 SELECT DISTINCT SCOPE_SCHEMA FROM SYSIBM.SQTCOLUMNS UNION
 SELECT DISTINCT TABLE_SCHEMA FROM SYSIBM.SQTCOLUMNS_OLEDB UNION
 SELECT DISTINCT CHARACTER_SET_SCHEMA FROM SYSIBM.SQTCOLUMNS_OLEDB UNION
 SELECT DISTINCT COLLATION_SCHEMA FROM SYSIBM.SQTCOLUMNS_OLEDB UNION
 SELECT DISTINCT DOMAIN_SCHEMA FROM SYSIBM.SQTCOLUMNS_OLEDB UNION
 SELECT DISTINCT CREATOR FROM SYSIBM.UINDEXES UNION
 SELECT DISTINCT TBCREATOR FROM SYSIBM.UINDEXES UNION
 SELECT DISTINCT XSROBJECTSCHEMA FROM SYSIBM.XSROBJECTS UNION
 SELECT DISTINCT TABSCHEMA FROM SYSIBM.XSRANNOTATIONINFO
 )

UNION ALL



-- FEATURE 25 (TABLESPACE_LOGING_PERCENT)
SELECT '25' AS FEATURE_ID, 'Tablespace Logging' AS FEATURE_NAME, 
INT((SELECT FLOAT(COUNT(*)) FROM SYSIBM.SYSTABLESPACE WHERE LOG = 'Y')*100 / (SELECT FLOAT(COUNT(*)) FROM SYSIBM.SYSTABLESPACE)) AS VALUE
FROM SYSIBM.SYSDUMMY1

UNION ALL



-- FEATURE 26 (REMOTE_LINKS_COUNT)
SELECT '26' AS FEATURE_ID, 'Linked Servers' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM (SELECT DISTINCT LINKNAME FROM SYSIBM.IPNAMES)

UNION ALL



-- FEATURE 27 (USERAUTH_COUNT)
SELECT '27' AS FEATURE_ID, 'User Authorities' AS FEATURE_NAME, COUNT(*) AS VALUE 
FROM 
(
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSCOLAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSDBAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSPACKAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSPLANAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSRESAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSROUTINEAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSSCHEMAAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSSEQUENCEAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSTABAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSUSERAUTH WHERE GRANTEETYPE = ' ' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSVARIABLEAUTH WHERE GRANTEETYPE = ' ' 
)

UNION ALL



-- FEATURE 28 (ROLEAUTH_COUNT)
SELECT '28' AS FEATURE_ID, 'Role Authorities' AS FEATURE_NAME, COUNT(*) AS VALUE 
FROM 
(
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSCOLAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSDBAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSPACKAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSPLANAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSRESAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSROUTINEAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSSCHEMAAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSSEQUENCEAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSTABAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSUSERAUTH WHERE GRANTEETYPE = 'L' UNION
SELECT DISTINCT GRANTEE FROM SYSIBM.SYSVARIABLEAUTH WHERE GRANTEETYPE = 'L' 
)     

UNION ALL



-- FEATURE 29 (TABLE_BACKUP_COUNT)
SELECT '29' AS FEATURE_ID, 'Table Backups' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM
(
SELECT DISTINCT B.CREATOR, B.NAME 
--A.DBNAME, A.TSNAME, B.NAME, B.CREATOR, A.DSNUM, A.ICDATE, A.JOBNAME, A.TIMESTAMP 
FROM SYSIBM.SYSCOPY A,
	 SYSIBM.SYSTABLES B
WHERE A.ICTYPE = 'F'
  AND A.DBNAME = B.DBNAME
  AND A.TSNAME = B.TSNAME
 )
 
 UNION ALL
 
 
 
 -- FEATURE 30 (REPLICATION_TABLES_PRESENT)
 SELECT '30' AS FEATURE_ID, 'Replication Tables' AS FEATURE_NAME, COUNT(*) AS VALUE
 FROM
 (
 SELECT DISTINCT CREATOR
 FROM SYSIBM.SYSTABLES
 WHERE CREATOR = 'ASN'
 )

UNION ALL



 -- FEATURE 31 (ALIAS_COUNT)
SELECT '31' AS FEATURE_ID, 'Aliases' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLES
WHERE TYPE = 'A'

UNION ALL



-- FEATURE 32 (CLONE_TABLE_COUNT)
SELECT '32' AS FEATURE_ID, 'Clone Tables' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLES
WHERE TYPE = 'C'

UNION ALL



-- FEATURE 33 (XML_TABLE_COUNT)
SELECT '33' AS FEATURE_ID, 'XML Tables' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLES
WHERE TYPE = 'P'

UNION ALL



-- FEATURE 34 (AUXILARY_TABLE_COUNT)
SELECT '34' AS FEATURE_ID, 'Auxiliary Tables' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTABLES
WHERE TYPE = 'X'    

UNION ALL



-- FEATURE 35 (REBUID_INDEX_JOB_COUNT)
SELECT '35' AS FEATURE_ID, 'Rebuild Indexes' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM
( SELECT DISTINCT JOBNAME FROM SYSIBM.SYSCOPY WHERE ICTYPE = 'B'
)

UNION ALL



-- FEATURE 36 (BACKUP_JOB_COUNT)
SELECT '36' AS FEATURE_ID, 'Backup Jobs' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM
( SELECT DISTINCT JOBNAME FROM SYSIBM.SYSCOPY WHERE ICTYPE IN ( 'F','I')
)

UNION ALL



-- FEATURE 37 (REORG_JOB_COUNT)
SELECT '37' AS FEATURE_ID, 'Reorg Jobs' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM
( SELECT DISTINCT JOBNAME FROM SYSIBM.SYSCOPY WHERE ICTYPE IN ( 'W','X')
)

UNION ALL



-- FEATURE 38 (LOAD_JOB_COUNT)
SELECT '38' AS FEATURE_ID, 'Load Jobs' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM
( SELECT DISTINCT JOBNAME FROM SYSIBM.SYSCOPY WHERE ICTYPE IN ( 'R','S')
)

UNION ALL



-- FEATURE 39 (QUIESCE_JOB_COUNT)
SELECT '39' AS FEATURE_ID, 'Quiesce Jobs' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM
( SELECT DISTINCT JOBNAME FROM SYSIBM.SYSCOPY WHERE ICTYPE IN ( 'Q')
)

UNION ALL



-- FEATURE 40 (MODIFY_RECOVERY_JOB_COUNT)
SELECT '40' AS FEATURE_ID, 'Modify Recovery Jobs' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM
( SELECT DISTINCT JOBNAME FROM SYSIBM.SYSCOPY WHERE ICTYPE IN ( 'M')
)

UNION ALL



-- FEATURE 41 (INSTEAD_TRIGGER_COUNT)
SELECT '41' AS FEATURE_ID,'Instead Triggers' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSTRIGGERS
WHERE TRIGTIME IN ('I')

UNION ALL



-- FEATURE 42 (WHERE_NOT_NULL_INDEXES_COUNT)
SELECT '42' AS FEATURE_ID,'Unique indexes' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSINDEXES
WHERE UNIQUERULE = 'N'

UNION ALL



-- FEATURE 43 (ROWID_INDEXES_COUNT)
SELECT '43' AS FEATURE_ID,'RowId Indexes' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSINDEXES
WHERE UNIQUERULE = 'G'

UNION ALL



-- FEATURE 44 (NODEID_INDEXES_COUNT)
SELECT '44' AS FEATURE_ID,'NodeId Indexes' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSINDEXES
WHERE IX_EXTENSION_TYPE = 'N'

UNION ALL



-- FEATURE 45 (SCALAR EXPRESSION_INDEXES_COUNT)
SELECT '45' AS FEATURE_ID,'Expression Indexes' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSINDEXES
WHERE IX_EXTENSION_TYPE = 'S'

UNION ALL



-- FEATURE 46 (SPATIAL_INDEXES_COUNT)
SELECT '46' AS FEATURE_ID,'Spatial Indexes' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSINDEXES
WHERE IX_EXTENSION_TYPE = 'T'

UNION ALL



-- FEATURE 47 (COMPRESSED_INDEXES_COUNT)
SELECT '47' AS FEATURE_ID,'Index compression' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSINDEXES
WHERE COMPRESS = 'Y'

UNION ALL



-- FEATURE 48 (COLUMN_MASKS_COUNT)
SELECT '48' AS FEATURE_ID, 'Data Masking' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSCONTROLS  
WHERE CONTROL_TYPE = 'C'

UNION ALL



-- FEATURE 49 (INCLUDE_COLUMN_INDEXES_COUNT)
SELECT '49' AS FEATURE_ID,'Include Column Index' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSINDEXES
WHERE UNIQUE_COUNT > 0

UNION ALL



-- FEATURE 50 (AUDIT_POLICIES_COUNT)
SELECT '50' AS FEATURE_ID,'Database Auditing' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSAUDITPOLICIES

UNION ALL



-- FEATURE 51 (GLOBAL_VARIABLES_COUNT)
SELECT '51' AS FEATURE_ID,'Global Variables' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSVARIABLES

UNION ALL



-- FEATURE 52 (ACCESS_PATH_HINT_COUNT)
SELECT '52' AS FEATURE_ID,'Query Hints' AS FEATURE_NAME, COUNT(*) AS VALUE
FROM SYSIBM.SYSQUERY;


