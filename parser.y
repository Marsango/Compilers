%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declaração de yyin
extern FILE *yyin;

void yyerror(const char *s);
int yylex(void);

int status = 1; // 1 = correctly, 0 = incorrectly
#define YYERROR_VERBOSE 1
%}
%token PV LET COLON IF MULT PRINT ATRIB END VIRG PLUS GOTO OF READ THEN ELSE BIG EQUAL SMALL DIV ID NUM MINUS
%left PLUS MINUS
%left MULT DIV
%nonassoc BIG EQUAL SMALL

%start programa

%%
programa: sequencia_de_comandos END {printf("programa -> sequencia de comandos\n");};
sequencia_de_comandos: comando {printf("sequencia_de_comandos -> comando PV\n");} | sequencia_de_comandos PV comando {printf("sequencia_de_comandos -> sequencia_de_comandos PV comando\n");};
comando: atribuicao {printf("comando -> atribuicao\n");}| desvio {printf("comando -> desvio\n");}| leitura {printf("comando -> leitura\n");} | impressao{printf("comando -> impressao\n");}| decisao {printf("comando -> decisao\n");}| /* empty */ {printf("comando -> EPSILON\n");}| ID COLON comando {printf("comando -> ID COLON comando\n");};
atribuicao: LET ID ATRIB expressao {printf("atribuicao -> LET ID ATRIB expressao\n");};
expressao: expressao PLUS termo {printf("expressao -> expressao PLUS termo\n");} | expressao MINUS termo {printf("expressao -> expressao MINUS termo\n");} | termo {printf("expressao -> termo\n");} ;
termo: termo MULT fator {printf("termo -> termo MULT fator\n");}  | termo DIV fator {printf("termo -> termo DIV fator\n");}  | fator {printf("termo -> fator\n");} ;
fator: ID {printf("fator -> ID\n");}  | NUM {printf("fator -> NUM\n");}  | '(' expressao ')' {printf("fator -> ( expressao )\n");} ;
desvio: GOTO ID {printf("desvio -> GOTO ID\n");} | GOTO ID OF lista_de_rotulos {printf("desvio -> GOTO ID of lista_de_rotulos\n");};
lista_de_rotulos: ID {printf("lista_de_rotulos -> ID\n");} | lista_de_rotulos VIRG ID {printf("lista_de_rotulos -> lista_de_rotulos VIRG ID\n");};
leitura: READ lista_de_identificadores {printf("leitura -> READ lista_de_identificadores\n");};
lista_de_identificadores: ID {printf("lista_de_identificadores -> ID\n");} | ID VIRG lista_de_identificadores {printf("lista_de_identificadores -> ID VIRG lista_de_identificadores\n");};
impressao: PRINT lista_de_expressoes {printf("impressao -> PRINT lista_de_expressoes\n");};
lista_de_expressoes: expressao {printf("lista_de_expressoes -> expressao\n");} | expressao VIRG lista_de_expressoes {printf("lista_de_expressoes -> expressao VIRG lista_de_expressoes\n");};
decisao: IF comparacao THEN comando PV ELSE comando {printf("decisao -> IF comparacao THEN comando ELSE comando\n");};
comparacao: expressao operador_de_comparacao expressao {printf("comparacao -> expressao operador_de_comparacao expressao\n");};
operador_de_comparacao: BIG {printf("operador_de_comparacao -> BIG\n");} | EQUAL {printf("operador_de_comparacao -> EQUAL\n");} | SMALL {printf("operador_de_comparacao -> SMALL\n");};
%%
void yyerror(const char *s) {
    fprintf(stderr, "Erro sintatico: %s\n", s);
    status = 0; // Definir como "Sintaticamente Incorreto"
}

int main(int argc, char *argv[]) {

    if (argc > 1) {
        yyin = fopen(argv[1], "r");

        if (!yyin) {
                perror(argv[1]);
                return 1;
            }
            char ch;
            while ((ch = fgetc(yyin)) != EOF) {
                putchar(ch);
            }
            printf("\n\n");
            rewind(yyin); //voltar o ponteiro para o começo
    }


    yyparse();
    if (status) {
        printf("Sintaticamente Correto\n");
    } else {
        printf("Sintaticamente Incorreto\n");
    }
    fclose(yyin);
    return 0;
}