  CREATE OR REPLACE TRIGGER HDB_OBJECTTYPE_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_OBJECTTYPE
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.OBJECTTYPE_ID := populate_pk.get_pk_val( 'HDB_OBJECTTYPE', FALSE );  END IF; ELSIF updating THEN :new.OBJECTTYPE_ID := :old.OBJECTTYPE_ID; END IF; END;
/

show errors trigger HDB_OBJECTTYPE_PK_TRIG;