%option noyywrap
%{
#include <stdio.h>
%}
%%
[0-9] { printf("digito encontrado!") ; }
%%
int main(){
yylex();
return 0;
}