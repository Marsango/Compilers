%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}
/* Definições Regulares */
COMMENT "{"[^}]*"}"
LET let
ATRIB :=
PLUS "+"
MINUS -
VIRG ,
IF if
END end
GOTO go[ ]to
OF of
READ read
THEN then
ELSE else
BIG >
EQUAL =
MULT \*
SMALL <
PV ;
COLON : 
DIV \/
PRINT PRINT
ID ([a-zA-Z])([0-9]|[a-z]|[A-Z])*
NUM ([0-9]+)


%%
{COMMENT} {;}
{MINUS} {return MINUS;}
{MULT} {return MULT;}
{PV} { return PV;}
{LET} { return LET; }
{IF} { return IF; }
{PRINT} { return PRINT; }
{ATRIB} { return ATRIB; }
{END} { return END; }
{VIRG} { return VIRG; }
{PLUS} { return PLUS; }
{GOTO} { return GOTO; }
{OF} { return OF; }
{READ} { return READ; }
{THEN} { return THEN; }
{ELSE} { return ELSE; }
{BIG} { return BIG; }
{EQUAL} { return EQUAL; }
{SMALL} { return SMALL; }
{DIV} { return DIV; }
{ID} { return ID; }
{NUM} { return NUM; }

\n {printf("\n");}
%%
int yywrap(void) {
    return 1;
}