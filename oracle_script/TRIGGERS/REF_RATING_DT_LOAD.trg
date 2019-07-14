  CREATE OR REPLACE TRIGGER REF_RATING_DT_LOAD
  BEFORE INSERT OR UPDATE ON REF_RATING
  REFERENCING FOR EACH ROW
  begin
:new.date_time_loaded := sysdate; end;
/

show errors trigger REF_RATING_DT_LOAD;