
/* The following 6 NUM_ values size the arrays for inputparm */
/* ver 1.1  SEP 10, 97 DGB
            Added MAX_INPUT.  This will replace the 80 character
            limit on shef input.
            Add MAX_COMMENT_LENGTH.
            JAN 29 98 DGB
            Add NUM_BLANKS parameter.
*/
#define NUM_BLANKS  50                                     /* dgb:01/29/98 */
#define NUM_PEVAL  190
#define NUM_DURVAL  35
#define NUM_TSVAL  165
#define NUM_EXVAL   30
#define NUM_PROVAL  40
#define NUM_SENVAL  45
#define PE_SIZE      4
#define TS_SIZE      3
#define MAX_ACCEPTABLE_PE  20
#define MAX_ACCEPTABLE_TS  50
#define MAXLIN 30
#define MAX_ACCEPTABLE_CATEGORIES 5
#define MAX_BUFF_CFG_LINE 600
#define LIMIT_OF_MISSING_DATA -9000
#define TOLERANCE 1
#define PRINT_UNKNOWN_STATIONS 0
#define PRINT_UNKNOWN_SENSORS 0
#define MISSING_VALUE    -99
#define MISSING_CRITERIA -98
#define MAX_F 91
#define MAX_SHEF_INPUT 150                                 /* dgb:09/10/97 */    
#define MAX_COMMENT_LENGTH 80                              /* dgb:09/10/97 */
