ALTER TABLE DECODES_Site_ext ADD CONSTRAINT
 decodes_site_ext_fk1 FOREIGN KEY
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID)
  ON DELETE CASCADE;

