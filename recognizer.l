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

[ \t\n]+ {;}

. {printf("INVALID CHARACTER");}

%%


#include <stdio.h>

//global variables
int reading;


//function declarations
void error();
void success();
void prog();
void opt_stmts();

void error() {
    
    printf("Invalid Program\n");
}

void success() {

    printf("Valid Program\n");
}

void prog() {
    
    if(reading == PROGRAM) {
        
        reading = yylex();

        if(reading == ID) {

            reading = yylex();

            if(reading == MY_BEGIN) {

                reading = yylex();
                
                opt_stmts();

                if(reading == END) {
                    
                    success();
                }
                else {
                    
                    error();
                }
            }
            else {

                error();
            }
        }
        else {
            
            error();
        }
    }
    else {

        error();
    }
}

void opt_stmts() {
    
    if(reading == END) {
        //continue
    }
    else {

        printf("To be continued...");
    }
}

int main() {

    reading = yylex();
    prog();
    return 0;
}