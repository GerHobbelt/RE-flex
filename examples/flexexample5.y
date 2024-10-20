/* Parser to convert "C" assignments to lisp using Bison in C. */
/* Demonstrates bison pure parser with parameters passed to yyparse and to yylex */
/* Compile: bison -d -y flexexample5.y */

%{
#include <stdio.h>
#include "lex.yy.h"  /* Generated by reflex: scanner_t, yyscan_t, yylex_init, yylex_destroy */
/* %pure-parser requires us to pass the argument 'params->scanner' from yyparse through to yylex. */
#define YYLEX_PARAM ((struct pass_through*)params)->scanner
/* Pass argument `struct pass_through *param` with scanner object and other data */
struct pass_through {
  yyscan_t scanner; /* void* in C, the old way */
  int count;
};
void yyerror(struct pass_through *params, const char *msg); /* yyerror accepts `params` */
%}

/* pure-parser adds yylval parameter to yylex() */
%pure-parser
/* Add params->scanner parameter to yylex() using YYLEX_PARAM */
%lex-param { void *YYLEX_PARAM }
/* Add pass-through parameter to yyparse() as void* - using 'struct pass_through*' causes C compilation errors */
%parse-param { void *params }

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
assignment  : STRING '=' NUMBER ';' { printf("(setf %s %d)\n", $1, $3); ++((struct pass_through*)params)->count; }
            ;

%%

int main(void)
{
  struct pass_through params;
  yyscan_t scanner;	/* the old way in C */
  yylex_init(&scanner);
  params.scanner = scanner;
  params.count = 0;
  yyparse(&params);	/* %parse-param, we pass params->scanner on to yylex() */
  yylex_destroy(scanner);
  printf("# assignments = %d\n", params.count);
  return 0;
}

void yyerror(struct pass_through *params, const char *msg)
{
  fprintf(stderr, "%s at %d\n", msg, yyget_lineno(params->scanner));
}
