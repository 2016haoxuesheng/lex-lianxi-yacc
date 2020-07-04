%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1
%}
%union {
    int         int_value;
    double      double_value;
}
%token <double_value>       DOUBLE_LITERAL
%token ADD SUB MUL DIV CR XF ES
%type <double_value> equation_one equation_two equation_thr equation_fou line_list line
%%
primary_expression
    : DOUBLE_LITERAL
    ;
equation_one
    : primary_expression
    | primary_expression ADD XF ES primary_expression
    {
        $$ = $5 - $1;
    }
    | primary_expression MUL XF ES primary_expression
    {
        $$ = $5 / $1;
    }
    ;
equation_two
    : equation_one
    | equation_one SUB XF ES equation_one
    {
        $$ = $1 - $5;
    }
    | equation_one DIV XF ES equation_one
    {
        $$ = $1 / $5;
    }
    ;
equation_thr
    : equation_two
    | XF ADD equation_two ES equation_two
    {
        $$ = $5 - $3;
    }
    | XF MUL equation_two ES equation_two
    {
        $$ = $5 / $3;
    }
    | XF SUB equation_two ES equation_two
    {
        $$ = $5 + $3;
    }
    | XF DIV equation_two ES equation_two
    {
        $$ = $5 * $3;
    }
    ;
line_list
    : line
    | line_list line
    ;
line
    : equation_one CR
    {
        printf(">>%lf\n", $5);
    }
    | equation_two CR
    {
        printf(">>%lf\n", $1);
    }
    | equation_thr CR
    {
        printf(">>%lf\n", $5);
    }
    ;
%%
int yyerror(char const *str) {
    extern char *yytext;
    fprintf(stderr, "parser error near %s\n", yytext);
    return 0;
}

int main(void) {
    extern int yyparse(void)
    extern FILE *yyin;
    
    yyin = stdin;
    if (yyparse()) {
        fprintf(stderr, "Error! Error!! Error!!!\n");
        exit(1);
    }
}
