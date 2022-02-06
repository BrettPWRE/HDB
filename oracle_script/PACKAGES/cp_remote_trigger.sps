create or replace package CP_REMOTE_TRIGGER as
/*  PACKAGE CP_REMOTE_TRIGGER is the package designed to contain all
    the procedures and functions for the Remote computation triggering use.
    
    Created by M. Bogner April 2010   
*/

/*  DECLARE ALL GLOBAL variables  */
/*  none so far */


 PROCEDURE POST_ON_TASKLIST(
    P_LOADING_APPLICATION_ID	NUMBER,
    P_SITE_DATATYPE_ID			NUMBER,
    P_INTERVAL					VARCHAR2,
    P_TABLE_SELECTOR			VARCHAR2,
    P_START_DATE_TIME			DATE,
	P_MODEL_RUN_ID				NUMBER,
	P_VALUE						NUMBER,
	P_VALIDATION				VARCHAR2,
    P_DERIVATION_FLAGS			VARCHAR2,
    P_DELETE_FLAG				VARCHAR2) ;
  
 PROCEDURE REMOTE_DATA_CHANGED(
    P_SITE_DATATYPE_ID		NUMBER,
    P_INTERVAL				VARCHAR2,
    P_START_DATE_TIME		DATE,
    P_MODEL_RUN_ID			NUMBER,
	P_VALUE					NUMBER,
	P_VALIDATION			VARCHAR2,
    P_DERIVATION_FLAGS		VARCHAR2,
    P_DELETE_FLAG			VARCHAR2);
 
 PROCEDURE TRIGGER_REMOTE_CP(
    P_DB_LINK				VARCHAR2,
    P_SITE_DATATYPE_ID		NUMBER,
    P_INTERVAL				VARCHAR2,
    P_START_DATE_TIME		DATE,
    P_MODEL_RUN_ID			NUMBER,
	P_VALUE					NUMBER,
	P_VALIDATION			VARCHAR2,
    P_DERIVATION_FLAGS		VARCHAR2,
    P_DELETE_FLAG			VARCHAR2);
     
END CP_REMOTE_TRIGGER;
.
/

create or replace public synonym CP_REMOTE_TRIGGER for CP_REMOTE_TRIGGER;
grant execute on CP_REMOTE_TRIGGER to app_role;
