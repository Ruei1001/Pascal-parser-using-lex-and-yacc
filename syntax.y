%{
#include <stdio.h>
#include<string.h>
#include<ctype.h>
#include <stdlib.h>
#define MAX 32
int yylex();
double ans = 0;
extern int lineCount, charCount, flag;
void yyerror(const char* message) {
    printf("Invaild format\n");
};
struct symbol_table {
    char varname[MAX];
    char data_type[MAX];
};
struct symbol_table symbol_table2[MAX];
int symbol_count = 0;
int search( char * target);
void insert(char * varname, char * type);
int op_flag = 0;
int is_string(char*);
char * str = "string";
char temp1[MAX], * temp2;
char * expected_type;
char * insert_type;
void foo();
//extern int flag;
%}
%union {
    char * name;
}
%type <name> prog prog_name dec_list dec type standtype arraytype id_list stmt_list stmt assign ifstmt exp relop simpexp term factor read write write_list for index_exp varid body write_line
%token <name> INTEGER REALTYPE FLOATTYPE CHARTYPE STRINGTYPE
%token <name> BEGINN VAR PROGRAM END DO FOR TO READ WRITE WRITELN
%token <name> PLUS MINUS MUL DIV AROP LOGICALOP RELOP TERMOP SIMPOP DOT MIN SMPEXP MOD
%token <name> ID ARRAY STDTYPE OF IF THEN INT REAL STRING
%token <name> COLON SEMICOLON LP RP ASSIGN LBRAC RBRAC COMMA LBRKET RBRKET EQUAL
%%
prog : PROGRAM prog_name SEMICOLON VAR dec_list SEMICOLON BEGINN stmt_list SEMICOLON END DOT
    {
        //printf("Here");
    }
    | PROGRAM prog_name SEMICOLON VAR dec_list SEMICOLON BEGINN stmt_list SEMICOLON END
    {
        printf("\rLine %d, at char %d, ",lineCount,charCount);
        printf("syntax error, unexpected end, expecting DOT\n");
    }
    ;
prog_name : ID
    ;
dec_list : dec
    | dec_list SEMICOLON dec
    ;
dec : id_list COLON type
    {
        //insert_type = strdup($3);
        //insert($1,$3);
        for(int i = 0; i < symbol_count; i++)
        {
            if(strcmp(symbol_table2[i].varname , "") && !strcmp(symbol_table2[i].data_type , ""))
                strcpy(symbol_table2[i].data_type , $3);
        }
        //printf("\":=\" expected, but \":\" found");
        /*
        for(int i = 0; i< symbol_count; i++)
        {
            if(!strcmp(symbol_table2[i].varname , ""))
                break;
            printf("\nvarname : %s | data type : %s", symbol_table2[i].varname, symbol_table2[i].data_type);
        }*/
        //printf("symbol count is %d", symbol_count);
        //printf("%s to insert \t", insert_type);
        //id_list_type = strdup($3);
        //printf("inserted %s", $1);
    }
    | id_list ASSIGN type
    {
        printf("\rLine %d, at char %d",lineCount,charCount);
        printf(" \":\" expected , but %s found ", $2);
    }
    ;
type : standtype
    | arraytype
    ;
standtype : STRINGTYPE
    | ARRAY
    | INTEGER
    | REALTYPE
    | FLOATTYPE
    ;
arraytype : ARRAY LBRAC INT DOT DOT INT RBRAC OF standtype
    | ARRAY LBRAC INT DOT INT RBRAC OF standtype
    {
        printf("\rLine %d",lineCount);
        printf("1 dot missing between braces ");
    }
    ;
id_list : ID
    {
        insert($1, "");
    }
    | id_list COMMA ID
    {
        insert($3, "");
    }
    | id_list ID
    {
        printf("\",\" expected in ID list");
    }
    ;
stmt_list : stmt 
    {
        //printf("Here");
    }
    | stmt_list SEMICOLON stmt
    {
        //printf("Here");
    }
    | stmt_list stmt
    {
        printf("\rLine %d",lineCount);
        printf("Missing \";\" at the end of statement");
    }
    ;
stmt : assign
    | read
    | write
    | for
    | ifstmt
    | write_line
    ;
assign : varid ASSIGN simpexp
    {
        flag = 1;
        //printf("Here");
        //expected_type = strdup(symbol_table2[search($1)].data_type);
        //printf("expect type is %s", expected_type);
    }
    | varid relop simpexp
    {
        flag = 1;
        if(strcmp(symbol_table2[search($1)].data_type, symbol_table2[search($3)].data_type))
        {
            //printf("Incompatibale type, %s, expect datapyte %s\n",symbol_table2[search($3)].data_type, symbol_table2[search($1)].data_type);
        }
        //printf("\rLine %d, at char %d",lineCount,charCount);
        //printf(" \":=\" expected , but \"%s\" found \t", $2);
        
    }
    | varid ASSIGN STRING
    ;
ifstmt : IF LP exp RP THEN body
    ;
exp : simpexp
    | exp relop simpexp
    ;
relop : RELOP
    ;
simpexp : term
    {
        //printf("Go to here");
        /*if (is_string($1))
        {
            printf("\nInvalid string operation ");
        }*/
        strcpy(temp1 , symbol_table2[search($1)].data_type);
        //printf("%s", temp1);
        //printf("temp1 is %s", temp1);
        //printf("Expected type is %s", expected_type);
        //foo();
    }
    | simpexp PLUS STRING
    {
        printf("\nInvalid string operation ");
    }
    | simpexp PLUS term
    {
        //printf("Go to here");
        //printf("%s %s", $1, $3);
        //printf("Type is %s", symbol_table2[search($3)].data_type);
        //printf("Type is %s", symbol_table2[search($1)].data_type);
        //printf("Expected type is %s", expected_type);
        strcpy(temp1 , symbol_table2[search($1)].data_type);
        temp2 = strdup(symbol_table2[search($3)].data_type);
        //printf("%s", temp1);
        //printf("\t%d\t", strcmp(temp1, temp2));
        //foo();

        if (strcmp(temp1, temp2) != 0)
        {
            printf("Invalid type operation \t");
            //printf(" expect type is %s", expected_type);
        }
    }
    | simpexp MIN term
    {
        if (!strcmp(symbol_table2[search($3)].data_type, str))
        {
            printf("\nInvalid string operation ");
        }
    }
    ;
term : factor
    | term MUL factor
    | term  DIV factor
    | term MOD factor
    ;
factor : varid
    {
        //printf("expected type is %s", expected_type);
        /*
        if(strcmp(expected_type, symbol_table2[search($1)].data_type))
        {
            printf("Incompatibale type %s found, expect %s type ", symbol_table2[search($1)].data_type, expected_type);
        }*/
    }
    | INT
    | REAL
    | LP simpexp RP
    | STRING
    ;
read : READ LBRAC id_list RBRAC
    ;
write : WRITE LP write_list RP
    ;
write_list : varid 
	| STRING 
	| write_list COMMA varid 
	| write_list COMMA STRING;
for : FOR index_exp DO body
    ;
index_exp : varid ASSIGN simpexp TO exp
    ;
varid : ID
    {
        if(flag == 0)
        {
            expected_type = strdup(symbol_table2[search($1)].data_type);
            flag = 1;
        }
        
        if (search($1) < 0)
        {
            printf("\rLine %d, at char %d",lineCount,charCount);
            printf(" Identifier not found \"%s\"", $1);
        }
    }
    | ID LBRAC simpexp RBRAC
    {
        if (search($1) < 0)
        {
            printf("\rLine %d, at char %d",lineCount,charCount);
            printf(" Identifier not found \"%s\"", $1);
        }
    }
    | ID LBRAC INT RBRAC
    {
        if (search($1) < 0 )
        {
            printf("\rLine %d, at char %d",lineCount,charCount);
            printf(" Identifier not found \"%s\"", $1);
        }
    }
    ;
write_line : WRITELN
    ;
body : stmt
    | BEGINN stmt_list SEMICOLON END
    ;


%%
int main() {
    printf("Line 1 : ");
    yyparse();
    printf("\n");
    return 0;
}
void insert(char * target, char * type)
{
    strcpy(symbol_table2[symbol_count].varname, target);
    strcpy(symbol_table2[symbol_count].data_type, type);
    symbol_count++;
}
int search(char * target)
{
    //printf("in search");
    for(int i = 0; i < symbol_count; i++)
    {
        if (!strcmp(symbol_table2[i].varname, target))
            return i;
    }
    return -1;
}

int is_string(char * varname)
{
    int index = search(varname);
    if(!strcmp(symbol_table2[index].data_type, str))
    {
        return 1;
    }
    else
        return 0;
}

void foo()
{
    if(strcmp(temp1, expected_type) != 0)
    {
        printf("Incompatibale type, %s, expect datapyte %s\n",temp1, expected_type);
    }
    
    if(strcmp(temp2, expected_type) != 0)
    {
        printf("Incompatibale type, %s, expect datapyte %s\n",temp2, expected_type);
    }
}