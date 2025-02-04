/* Query to check on consistency between Hydromet archive data and SCADA data 
*/
-- command line argument for number of days to search back
define days_back = &1;

-- setup output
set feedback off
-- set the pagesize to 1 so that we can use the pno as a row count
set pagesize 9999
set linesize 100
set verify off

set termout off
column num_rows new_value num_rows
select count(*) num_rows
from r_base a, r_day b, hdb_site_datatype c where
a.interval = 'day' and
a.collection_system_id = 3 and
a.site_datatype_id = b.site_datatype_id and
a.start_date_time = b.start_date_time and
((abs(a.value - b.value) > .3 and
  c.datatype_id in (39,46,1197)) or
 (abs(a.value - b.value) > .009 and
  c.datatype_id = 49)) and
a.start_date_time > sysdate - &&days_back and
c.site_datatype_id = a.site_datatype_id and
c.datatype_id in (39,49,46,1197) and
c.site_id in (913,914,915,916,917,919,920,965,966,967,968,969,970);

set termout on
column site format A25
column datatype format A15
select a.start_date_time "Day",
round(a.value,3) "r_base from ARCHIVE", round(b.value,3) "r_day", round(abs(a.value -b.value),3) "Diff",
d.site_common_name site, e.datatype_common_name datatype, a.site_datatype_id sdi
from r_base a, r_day b, hdb_site_datatype c, hdb_site d, hdb_datatype e where
a.interval = 'day' and
a.collection_system_id = 3 and --make sure this is a hydromet source value
a.site_datatype_id = b.site_datatype_id and
a.start_date_time = b.start_date_time and
((abs(a.value - b.value) > .3 and   -- now check for problems. .5 cfs or .01 feet is threshold
  c.datatype_id in (39,46,1197)) or -- .3 cfs is roughly the possible rounding error in rounding to nearest
 (abs(a.value - b.value) > .009 and -- whole acre foot when putting data into Hydromet from Scada
  c.datatype_id = 49)) and          --    
a.start_date_time > sysdate - &&days_back and
c.site_datatype_id = a.site_datatype_id and
c.site_id = d.site_id and
c.datatype_id = e.datatype_id and
c.datatype_id in (39,49,46,1197) and
c.site_id in (913,914,915,916,917,919,920,965,966,967,968,969,970)
order by a.start_date_time, d.site_id, e.datatype_id;

exit num_rows;
