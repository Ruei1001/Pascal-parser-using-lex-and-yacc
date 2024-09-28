all:	clean y.tab.c lex.yy.c
	gcc lex.yy.c y.tab.c -lfl -o temp

y.tab.c:
	bison -y -d syntax.y

lex.yy.c:
	flex token.l

clean:
	rm -f temp lex.yy.c y.tab.c y.tab.h