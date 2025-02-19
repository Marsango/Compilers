%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Declaração de yyin
extern FILE *yyin;

void yyerror(const char *s);
int yylex(void);

int status = 1; // 1 significa "Sintaticamente Correto", 0 significa "Sintaticamente Incorreto"
#define YYERROR_VERBOSE 1
#define IMPRIMIR_PRODUCAO(production) printf(" %s\n", production)

%}

%token LET ID IF THEN ELSE PRINT READ GOTO END VIRG PV FOR WHILE TO DO DOISP OF
%token NUM
%token MAIOR MENOR IGUAL
%token PLUS MINUS MULT DIV
%token ATRIB

%left PLUS MINUS
%left MULT DIV
%nonassoc MAIOR MENOR IGUAL

%start programa


%%

programa
    : sequencia_comandos END { IMPRIMIR_PRODUCAO("programa -> sequencia_comandos END"); }
    ;

sequencia_comandos
    : comando { IMPRIMIR_PRODUCAO("sequencia_comandos -> comando"); }
    | sequencia_comandos PV comando { IMPRIMIR_PRODUCAO("sequencia_comandos -> sequencia_comandos ';' comando"); }
    ;

comando
    : atribuicao { IMPRIMIR_PRODUCAO("comando -> atribuicao"); }
    | desvio { IMPRIMIR_PRODUCAO("comando -> desvio"); }
    | leitura { IMPRIMIR_PRODUCAO("comando -> leitura"); }
    | impressao { IMPRIMIR_PRODUCAO("comando -> impressao"); }
    | decisao { IMPRIMIR_PRODUCAO("comando -> decisao"); }
    | ID DOISP comando { IMPRIMIR_PRODUCAO("comando -> ID ':' comando"); }
    ;

atribuicao
    : LET ID ATRIB expressao { IMPRIMIR_PRODUCAO("atribuicao -> LET ID ATRIB expressao"); }
    ;

expressao
    : expressao PLUS termo { IMPRIMIR_PRODUCAO("expressao -> expressao '+' termo"); }
    | expressao MINUS termo { IMPRIMIR_PRODUCAO("expressao -> expressao '-' termo"); }
    | termo { IMPRIMIR_PRODUCAO("expressao -> termo"); }
    ;

termo
    : termo MULT fator { IMPRIMIR_PRODUCAO("termo -> termo '*' fator"); }
    | termo DIV fator { IMPRIMIR_PRODUCAO("termo -> termo '/' fator"); }
    | fator { IMPRIMIR_PRODUCAO("termo -> fator"); }
    ;

fator
    : ID  { IMPRIMIR_PRODUCAO("fator -> ID"); }
    | NUM  { IMPRIMIR_PRODUCAO("fator -> NUM"); }
    | '(' expressao ')' { IMPRIMIR_PRODUCAO("fator -> '(' expressao ')'"); }
    ;

desvio
    : GOTO ID { IMPRIMIR_PRODUCAO("desvio -> GOTO ID"); }
    ;

leitura
    : READ lista_identificadores { IMPRIMIR_PRODUCAO("leitura -> READ lista_identificadores"); }
    ;

lista_identificadores
    : ID  { IMPRIMIR_PRODUCAO("lista_identificadores -> ID"); }
    | ID VIRG lista_identificadores { IMPRIMIR_PRODUCAO("lista_identificadores -> ID ',' lista_identificadores"); }
    ;

impressao
    : PRINT lista_expressoes PV { IMPRIMIR_PRODUCAO("impressao -> PRINT lista_expressoes"); }
    ;

lista_expressoes
    : expressao { IMPRIMIR_PRODUCAO("lista_expressoes -> expressao"); }
    | expressao VIRG lista_expressoes { IMPRIMIR_PRODUCAO("lista_expressoes -> expressao ',' lista_expressoes"); }
    ;

decisao
    : IF comparacao THEN comando ELSE comando { IMPRIMIR_PRODUCAO("decisao -> IF comparacao THEN comando ELSE comando"); }
    ;

comparacao
    : expressao operador_comparacao expressao { IMPRIMIR_PRODUCAO("comparacao -> expressao operador_comparacao expressao"); }
    ;

operador_comparacao
    : MAIOR { IMPRIMIR_PRODUCAO("operador_comparacao -> '>'"); }
    | IGUAL { IMPRIMIR_PRODUCAO("operador_comparacao -> '='"); }
    | MENOR { IMPRIMIR_PRODUCAO("operador_comparacao -> '<'"); }
    ;

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

            // imprimir o conteudo do arquivo
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
