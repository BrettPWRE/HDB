
CREATE TABLE REF_DB_PARAMETER
(
	GLOBAL_NAME					VARCHAR2(100) NOT NULL,
	PARAM_NAME					VARCHAR2(64) NOT NULL,
	PARAM_VALUE					VARCHAR2(64) NOT NULL,
	ACTIVE_FLAG					VARCHAR2(1)  DEFAULT 'Y' NOT NULL,
	DESCRIPTION					VARCHAR2(400) NOT NULL,
	EFFECTIVE_START_DATE_TIME	DATE,
	EFFECTIVE_END_DATE_TIME		DATE
)
tablespace HDB_data;

drop public synonym REF_DB_PARAMETER;
create or replace public synonym REF_DB_PARAMETER for REF_DB_PARAMETER;
grant select on REF_DB_PARAMETER to public;

insert into REF_DB_PARAMETER
select global_name,'TIME_ZONE','MST','Y','DATABASES DEFAULT TIME SERIES TIME ZONE',
sysdate,null from global_name;

update REF_DB_PARAMETER set EFFECTIVE_END_DATE_TIME = sysdate where param_name = 'DB_RELEASE_VERSION';

insert into REF_DB_PARAMETER
select global_name,'DB_RELEASE_VERSION','2.4','Y','DATABASES LATEST SOFTWARE RELEASE VERSION',
sysdate,null from global_name;

commit;