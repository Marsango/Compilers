#include <stdio.h>
#include "lex.yy.h"

extern int yyparse (void);
void yyerror(char const *message){
printf("Error: %s\n", message);
}

int main(int argc, char const *argv[]) {
yyin = fopen(argv[1], "r");
int result_code = yyparse();
fclose(yyin);
return result_code;
}