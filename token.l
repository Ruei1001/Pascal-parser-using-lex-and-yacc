%{
#include "y.tab.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#define MAX 32
unsigned charCount = 0,lineCount = 1, first_position = 1;
int state = 0;
int flag = 0;
void print_char();
int nextlineFlag = 0;
int first_position_flag = 0;
//int flag = 0;
/*
int search( char * target);
void insert(char * varname);
void delete();*/
int find_operator(char* start, int start_index);
void print_str(char * target,int start,int end);
int find_e(char * start, int p);
void print_line_num();

//char symbol_table2[MAX][MAX];
//int symbol_count = 0;
%}
%x op
/* basic char */
letter [a-zA-Z]
digit [0-9]
arithemetic_operator [\+\-\*\/]
simp [\+\-\*\/]
term [\*\/]
relational_operator =|<>|<|>|<=|>=
logical_operator [Aa][Nn][Dd]|[Oo][Rr]|[Nn][Oo][Tt]
space [ \t]
quote [\"\']
identity ({letter}|[_])+({digit}|{letter})*
comment \(\*([^\*]|{eol}|([\*]+[^\)]))*[\*]+\)
number [1-9]
datatype [Ss][Tt][Rr][Ii][Nn][Gg]|[Ii][Nn][Tt][Ee][Gg][Ee][Rr]|[Cc][Hh][Aa][Rr]|[Ff][Ll][Oo][Aa][Tt]
/* basic char combine */
/*reserved_word [Aa][Rr][Rr][Aa][Yy]|[Cc][Aa][Ss][Ee]|[Cc][Oo][Nn][Ss][Tt]|[Dd][Ii][Vv]|[Dd][Oo]|[Dd][Oo][Ww][Nn][Tt][Oo]|[Ee][Ll][Ss][Ee]|[Ff][Ii][Ll][Ee]|[Ff][Oo][Rr]|[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]|[Gg][Oo][Tt][Oo]|[Ii][Ff]|[Ii][Nn]|[Ll][Aa][Bb][Ee][Ll]|[Mm][Oo][Dd]|[Nn][Ii][Ll]|[Nn][Oo][Tt]|[Oo][Ff]|[Oo][Rr]|[Pp][Aa][Cc][Kk][Ee][Dd]|[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee]|[Rr][Ee][Cc][Oo][Rr][Dd]|[Rr][Ee][Pp][Ee][Aa][Tt]|[Ss][Ee][Tt]|[Tt][Hh][Ee][Nn]|[Tt][Oo]|[Tt][Yy][Pp][Ee]|[Uu][Nn][Tt][Ii][Ll]|[Ww][Hh][Ii][Ll][Ee]|[Ww][Ii][Tt][Hh]|[Bb][Ee][Gg][Ii][Nn]|[Vv][Aa][Rr]|[Pp][Rr][Oo][Gg][Rr][Aa][Mm]|[Ee][Nn][Dd]*/
reserved_word [Aa][Bb][Ss][Oo][Ll][Uu][Tt][Ee]|[Aa][Nn][Dd]|[Bb][Ee][Gg][Ii][Nn]|[Bb][Rr][Ee][Aa][Kk]|[Cc][Aa][Ss][Ee]|[Cc][Oo][Nn][Ss][Tt]|[Cc][Oo][Nn][Tt][Ii][Nn][Uu][Ee]|[Dd][Oo]|[Ee][Ll][Ss][Ee]|[Ee][Nn][Dd]|[Ff][Oo][Rr]|[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]|[Ii][Ff]|[Mm][Oo][Dd]|[Nn][Ii][Ll]|[Nn][Oo][Tt]]|[Oo][Bb][Jj][Ee][Cc][Tt]|[Oo][Ff]|[Oo][Rr]|[Pp][Rr][Oo][Gg][Rr][Aa][Mm]|[Tt][Hh][Ee][Nn]|[Tt][Oo]|[Vv][Aa][Rr]|[Ww][Hh][Ii][Ll][Ee]|[Aa][Rr][Rr][Aa][Yy]|[Ii][Nn][Tt][Ee][Gg][Ee][Rr]|[Dd][Oo][Uu][Bb][Ll][Ee]|[Ww][Rr][Ii][Tt][Ee]|[Ww][Rr][Ii][Tt][Ee][Ll][Nn]|[Ss][Tt][Rr][Ii][Nn][Gg]|[Ff][Ll][Oo][Aa][Tt]|[Rr][Ee][Aa][Dd]
integer [+-]?0|[+-]?{number}+{digit}*
string \'([^'\n]|[\'][\'])*\'
real {integer}(\.{digit}+)?([Ee]{integer})?
eol \n
Symbol [.;\"\',\[\]\{\}\?\/\(\)]
/*operation ({real}|{integer}){arithemetic_operator}({real}|{integer})*/

/* invalids*/
invalid_id [0-9^#][a-zA-Z0-9]*|({letter}|[_])+({digit}|{letter}){15,}
/*miss_semi [^;]+\n*/
mismatch_paranthesis \([^\)]$
string_not_closed \'[^';\n\r\\]*
invalid_integer [+-]?[0]+[\d]+
invalid_real {invalid_integer}(\.{digit}+)?([Ee]{integer})?|{integer}(\.{digit}+)?([^Ee\+\-\*\/]{integer})|{integer}(\.{digit}+)?([Ee]{invalid_integer})
unmatch_comment \(\*[^\n\r;*)]*
invalid_comment \(\*([^\*]|{eol}|([\*]+[^\)]))*
/* space must be at the last line */

%%
<*>[Ii][Nn][Tt][Ee][Gg][Ee][Rr] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return INTEGER;
}
<*>[Ss][Tt][Rr][Ii][Nn][Gg] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return STRINGTYPE;
}
<*>[Cc][Hh][Aa][Rr] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return CHARTYPE;
}
<*>[Ff][Ll][Oo][Aa][Tt] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return FLOATTYPE;
}
<*>[Rr][Ee][Aa][Dd] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return READ;
}
<*>[Ww][Rr][Ii][Tt][Ee] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return WRITE;
}
<*>[Ww][Rr][Ii][Tt][Ee][Ll][Nn] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return WRITELN;
}
<*>[Tt][Oo] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return TO;
}
<*>[Ff][Oo][Rr] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return FOR;
}
<*>[Dd][Oo] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return DO;
}
<*>[Ii][Ff] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return IF;
}
<*>[Tt][Hh][Ee][Nn] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return THEN;
}
<*>[Oo][Ff] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return OF;
}
<*>[Aa][Rr][Rr][Aa][Yy] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return ARRAY;
}
<*>[Bb][Ee][Gg][Ii][Nn] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    //printf("Correct in .l");
    BEGIN 0;
    return BEGINN;
}
<*>[Pp][Rr][Oo][Gg][Rr][Aa][Mm] {
    print_line_num();
    printf("%s", yytext);
    state = 2;
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return PROGRAM;
}
<*>[Vv][Aa][Rr] {
    print_line_num();
    printf("%s", yytext);
    state = 1;
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return VAR;
}
<*>[Ee][Nn][Dd] {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return END;
}
<*>[Mm][Oo][Dd] {
    print_line_num();
    printf("%s",yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return MOD;
}
<*>{space} {
    print_line_num();
    //printf("Read space ");
    charCount++;
    printf("%s", yytext);
}
<*>{eol} {
    print_line_num();
    lineCount++;
    charCount = 0;
    nextlineFlag = 1;
    //printf("%s", yytext);
    //printf("Line %d : ", lineCount);
}
<*>{relational_operator} {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return RELOP;
}
<*>{logical_operator} {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return LOGICALOP;
}
{integer} {
    print_line_num();
    //printf("Read a int");
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN op;
    return INT;
}
{real} {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN op;
    return REAL;
}
<op>"+" {
    //printf("Read PLUS ");
    charCount += yyleng;
    printf("%s", yytext);
    yylval.name=strdup(yytext);
    BEGIN 0;
    return PLUS;
}
<op>"-" {
    //printf("Read MINUS ");
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return MIN;
}
<*>"*" {
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return MUL;
}
<*>"/" {
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return DIV;
}
<*>"{" {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return LBRKET;
}
<*>"}" {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return RBRKET;
}
<*>"." {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return DOT;
}
<*>"(" {
    print_line_num();
    charCount++;
    printf("%s", yytext);
    yylval.name=strdup(yytext);
    BEGIN 0;
    return LP;
}
<*>")" {
    print_line_num();
    charCount++;
    printf("%s", yytext);
    yylval.name=strdup(yytext);
    BEGIN 0;
    return RP;
}
<*>"," {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return COMMA;
}
<*>":=" {
    print_line_num();
    //printf("Read assign ");
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    flag = 1;
    return ASSIGN;
}
<*>":" {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return COLON;
}
<*>";" {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return SEMICOLON;
}
<*>"[" {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return LBRAC;
}
<*>"]" {
    print_line_num();
    printf("%s", yytext);
    charCount += yyleng;
    yylval.name=strdup(yytext);
    BEGIN 0;
    return RBRAC;
}

<*>{reserved_word} {
    print_line_num();
    BEGIN 0;
    charCount += yyleng;
    yylval.name=strdup(yytext);
    printf("Line: %d, 1st char: %d, \"%s\" is a \"reserved word\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
    for(int i = 0; yytext[i]; i++)
        yytext[i] = tolower(yytext[i]);
    if(!strcmp(yytext, "var"))
        state = 1;
    else if(!strcmp(yytext, "begin"))
        state = 2;
    else if(!strcmp(yytext, "end"))
        state = 3;
    else if(!strcmp(yytext, "program"))
        state = 4;
    else
        state = 0;
        
}
<*>{identity} {
    print_line_num();
    /* found in the symbol table */
    //printf("Read an id");
    BEGIN op;
    yylval.name=strdup(yytext);
    charCount += yyleng;
    //printf("search the word \"%s\", insert return %d\n",yytext,search(yytext));
    if(yyleng >= 16)
    {
        printf("Line: %d, 1st char: %d, \"%s\" is an invalid ID : too long.\n", lineCount, charCount, yytext);
        charCount += yyleng;
        return ID;
    }
    else
    {
        
        printf("%s", yytext);
        return ID;
    }
    
    
}/*
{operation}	{
    printf("Line: %d, 1st char: %d, \"%s\" is a \"operation\".\n", lineCount, charCount, yytext);
	charCount += yyleng;

}*/
{string}	{
    print_line_num();
    BEGIN 0;
    yylval.name=strdup(yytext);
    charCount += yyleng;
    if(yyleng >32)
    {
        printf("Line: %d, 1st char: %d, \"%s\" is a invalid \"string\", too long.\n", lineCount, charCount, yytext);

    }
    else
    {
        //printf("Line: %d, 1st char: %d, \"%s\" is a \"string\".\n", lineCount, charCount, yytext);
	    charCount += yyleng;
        printf("%s", yytext);
        return STRING;
    }
    

}


<*>{comment} {
    BEGIN 0;
    yylval.name=strdup(yytext);
    charCount += yyleng;
    //printf("Line: %d, 1st char: %d, \"%s\" is a \" comment\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
    for(int i=0;i<yyleng;i++) 
	{
		if (yytext[i]==10)
		{
			lineCount++;
		} 
	}
}
{string_not_closed} {
    printf("Line: %d, 1st char: %d, \"%s\" string is not closed.\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{invalid_id} {
    printf("Line: %d, 1st char: %d, \"%s\" is a \"invalid id\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{mismatch_paranthesis} {
    printf("Line: %d, 1st char: %d, \"%s\" mismatch paranthesis.\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{invalid_integer} {
    printf("Line: %d, 1st char: %d, \"%s\" is a \"invalid integer\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{invalid_real} {
    printf("Line: %d, 1st char: %d, \"%s\" is a \" invalid real\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
{invalid_comment} {
    printf("Line: %d, 1st char: %d, \"%s\" is a \" unmatched comment\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}
"." {
    printf("Line: %d, 1st char: %d, \"%s\" is a \"unknown word\".\n", lineCount, charCount, yytext);
	charCount += yyleng;
}

%%


void print_line_num()
{
    if (nextlineFlag == 1)
    {
        if (charCount == 0)
        {
            printf("\nLine %d : ", lineCount);
            //first_position = 0;
        }
        nextlineFlag = 0;
    }
    
}

void print_char()
{
	printf("[In print_char]Symbol:\'%s\'\n",yytext);charCount++;
}
/*
void insert(char * varname)
{
    struct symbol_entry * node = malloc(sizeof(struct symbol_entry));
    strcpy(node->symbol_name, varname);
    //printf("the insert variable is \"%s\"\n",varname);
    node->next = NULL;
    
    if(table->head == NULL && table->tail == NULL)
    {
        table->head = node;
        table->tail = node;
    }
    else
    {
        table->head->next = node;
        table->head = node;
    }

}
*/
/*
void insert(char * target)
{
    strcpy(symbol_table2[symbol_count], target);
    symbol_count++;
}
*/
/*
int search(char * target)
{
    struct symbol_entry * index = table->tail;
    if(index == NULL)
        return 0;
    while(index != NULL)
    {
        if(!strcmp(target, index->symbol_name))
            return 1;
        else
            index = index->next;
    }
    return 0;
}
*/
/*
int search(char * target)
{
    for(int i = 0; i < symbol_count; i++)
    {
        if (!strcmp(symbol_table2[i], target))
            return 1;
    }
    return 0;

}
*/
/*find the position of the operator*/
int find_operator(char* start, int start_index)
{
    int i;
    
    for(i = start_index; i < sizeof(start)/2; i++)
    {
        if(start[i] == '+'|| start[i] == '-' || start[i] == '*' || start[i] == '/')
        {
            return i;
        }
    }
    return -1;
}
int find_e(char * start, int p)
{
    int i;
    
    for(i = p; i < sizeof(start)/2; i++)
    {
        if(start[i] == 'e' || start[i] == 'E')
        {
            return i;
        }
    }
    return -1;
}
//print the string in costomize way string[start:end]
void print_str(char * target,int start,int end)
{
    for(int i = start; i< end; i++)
    {
        printf("%c", target[i]);
    }
    return;
}