/* Parser to convert "C" assignments to lisp using Bison in C. */
/* Demonstrates bison pure parsers */
/* Compile: bison -d -y flexexample4.y */

%{
#include <stdio.h>
#include "lex.yy.h"  /* Generated by reflex --header-file */
void yyerror(yyscan_t, const char*);
/* Pass the parameter 'scanner' to yyparse through to yylex. */
#define YYPARSE_PARAM scanner
#define YYLEX_PARAM   scanner
%}

%pure-parser
%lex-param { void *scanner }
%parse-param { void *scanner }

%union {
    int   num;
    char *str;
}

%token <str> STRING
%token <num> NUMBER

%%

assignments : assignment
            | assignment assignments
            ;
assignment  : STRING '=' NUMBER ';' { printf("(setf %s %d)\n", $1, $3); }
            ;

%%

int main(void)
{
  yyscan_t scanner;	/* the old way in C */
  yylex_init(&scanner);
  yyparse(scanner);	/* scanner is passed on to yylex() */
  yylex_destroy(scanner);
  return 0;
}

void yyerror(yyscan_t scanner, const char *msg)
{
  (void)scanner; /* appease -Wall -Werror */
  fprintf(stderr, "%s\n", msg); /* how to use yylineno with bison-bridge? See flexexample5.y */
}
