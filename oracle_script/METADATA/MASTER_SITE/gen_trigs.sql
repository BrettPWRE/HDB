set echo off
set heading off
set feedback off
set pagesize 0
set linesize 500
set verify off

spool gen_trigs_script.sql

SELECT 'CREATE OR REPLACE TRIGGER '||substr (a.table_name, 1, 22)||'_PK_TRIG BEFORE INSERT OR UPDATE ON '||a.table_name||' FOR EACH ROW BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.'||a.column_name||' := populate_pk.get_pk_val( '''||a.table_name||''', FALSE );  END IF; ELSIF updating THEN :new.'||a.column_name||' := :old.'||a.column_name||'; END IF; END;'||chr(10)||'.'||chr(10)||'/'||chr(10)
      FROM user_cons_columns a, user_constraints b
      WHERE b.constraint_type = 'P'
      AND a.constraint_name = b.constraint_name
      AND a.table_name = b.table_name
      AND a.table_name IN
      ('HDB_AGEN','HDB_ATTR','HDB_COLLECTION_SYSTEM','HDB_COMPUTED_DATATYPE',
       'HDB_DAMTYPE','HDB_DATATYPE','HDB_DATA_SOURCE',
       'HDB_DIMENSION','HDB_GAGETYPE','HDB_LOADING_APPLICATION','HDB_METHOD',
       'HDB_METHOD_CLASS','HDB_MODEL','HDB_OBJECTTYPE','HDB_RIVER',
       'HDB_SITE','HDB_SITE_DATATYPE','HDB_STATE','HDB_UNIT','HDB_USBR_OFF',
       'REF_AGG_DISAGG','REF_MODEL_USER','REF_DB_LIST')
      ORDER BY a.TABLE_NAME;

spool off;
set feedback on
@gen_trigs_script
quit