%{ 
#define PROGRAM 1
#define ID 2
#define MY_BEGIN 3
#define END 4
#define IF 5
#define THEN 6
#define ENDIF 7
#define FOR 8
#define ASSIGN 9
#define STEP 10
#define UNTIL 11
#define DO 12
#define ENDFOR 13
#define NUM 14
#define OPEN_PARENTHESIS 15
#define CLOSE_PARENTHESIS 16
#define PLUS 17
#define MINUS 18
#define MULTIPLIER 19
#define DIVISOR 20
#define SEMICOLON 21
#define INVALID 22
%}


DIGITO [0-9]
DIGITOSC [1-9]
IDENTIFIER [a-zA-Z][a-zA-Z0-9]*

%%

begin { return MY_BEGIN; }

program { return PROGRAM; }

end { return END; }

:= { return ASSIGN; }

if { return IF; }

then { return THEN; }

endif { return ENDIF; }

for { return FOR; }

step { return STEP; }

until { return UNTIL; }

do { return DO; }

endfor { return ENDFOR; }

{IDENTIFIER} { return ID; }

({DIGITOSC}({DIGITO}*)) { return NUM; }

[(] { return OPEN_PARENTHESIS; }

[)] { return CLOSE_PARENTHESIS; }

[+] { return PLUS; }

[-] { return MINUS; }

[*] { return MULTIPLIER; }

[\/] { return DIVISOR; }

[;] { return SEMICOLON; }

[ \t\n]+ {;}

. { return INVALID; }

%%


#include <stdio.h>

//global variables
int reading;
int error;

//function declarations
int success();
int prog();
int opt_stmts();
int stmt_list();
int stmt();
int expr();
int term();
int ra();
int factor();
int rb();
int expresion();


int prog() {
    
    if(reading == PROGRAM) {
        
        reading = yylex();

        if(reading == ID) {

            reading = yylex();

            if(reading == MY_BEGIN) {
                
                reading = yylex();

                if(opt_stmts()) {
                    
                    if(reading == END) {
                    
                        return 1;

                    } else {
                        
                        return 0;
                    }

                } else {

                    return 0;
                }

            } else {

                return 0;
            }

        } else {
            
            return 0;
        }

    } else {

        return 0;
    }
}

int opt_stmts() {

    if(stmt_list()) {
        
        return 1;

    } else {

        return 0;
    }
}

int stmt_list() {

    if(stmt()) {

        return 1;

    } else {

        return 0;
    }
}

int stmt() {

    if(reading == ID) {

        reading = yylex();
        
        if(reading == ASSIGN) {

            reading = yylex();

            if(expr()) {

                return 1;

            } else {

                return 0;
            }
        }

    } else {
        return 0;
    }
}

int expr() {

    if(term()) {

        return 1;

    } else {

        return 0;
    }
}

int term() {

    if(factor()) {

        if(rb()) {
            
            return 1;

        } else {

            return 0;
        }

    } else {

        return 0;
    }
}

int factor() {

    if(reading == ID) {
        
        reading = yylex();
        
        return 1;

    } else if(reading == NUM) {
       
        reading = yylex();

        return 1;

    } else {

        return 0;
    }
}

int rb() {

    if(reading == MULTIPLIER) {

        reading = yylex();
        
        if(factor()) {

            if(rb()) {

                return 1;

            } else {

                return 0;

            }

        } else {

            return 0;
        }
    } else if(reading == DIVISOR) {
        
        reading = yylex();

        if(factor()) {

            if(rb()) {

                return 1;

            } else {

                return 0;
            }
        } else {

            return 0;
        }
    }

    else {
        return 1;
    }
}

int main() {

    reading = yylex();

    int valid = prog();

    if(valid) {
        
        printf("si\n");

    } else {

        printf("no\n");
    }
    return 0;
}