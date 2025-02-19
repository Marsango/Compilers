%{
#include "trabalho2.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%

[0-9]+                          { return NUM;}
[+]                             { return PLUS;}
[,]                             { return VIRG;}
[;]                             { return PV;}
[:]                             { return DOISP;}
[-]                             { return MINUS;}
[*]                             { return MULT;}
[/]                             { return DIV;}
[>]                             { return MAIOR;}
[<]                             { return MENOR;}
"if"                            { return IF;}
"else"                          { return ELSE;}
"then"                          { return THEN;}
"let"                           { return LET;}
"end"                           { return END;}
"for"                           { return FOR;}
"while"                         { return WHILE;}
"read"                          { return READ;}
"print"                         { return PRINT;}
":="                            { return ATRIB;}
"go to"                         { return GOTO;}
"do"                            { return DO;}
"of"                            { return OF;}
[a-zA-Z]([0-9]|[a-zA-Z])*       { return ID;}
[\t\n] 
. 

%%

int yywrap(void) {
    return 1;
}
