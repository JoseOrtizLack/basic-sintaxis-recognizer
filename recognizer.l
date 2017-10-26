%{ 
#define INVALID 0
#define VALID 1
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
#define LESS_THAN 22
#define GREATER_THAN 23
#define EQUAL_TO 24
#define INVALID_CHAR 25
#define PROGRAM 26
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

0|({DIGITOSC}({DIGITO}*)) { return NUM; }

[(] { return OPEN_PARENTHESIS; }

[)] { return CLOSE_PARENTHESIS; }

[+] { return PLUS; }

[-] { return MINUS; }

[*] { return MULTIPLIER; }

[\/] { return DIVISOR; }

[;] { return SEMICOLON; }

[>] { return GREATER_THAN; }

[<] { return LESS_THAN; }

[=] { return EQUAL_TO; }

[\n\t ] {;}

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
                    
                        return VALID;

                    } else {
                        
                        return INVALID;
                    }

                } else {
                    return INVALID;
                }

            } else {

                return INVALID;
            }

        } else {
            
            return INVALID;
        }

    } else {

        return INVALID;
    }
}

int opt_stmts() {

    if(stmt_list()) {
        
        return VALID;

    } else {
        
        return VALID;

    }
}

int stmt_list() {

    if(stmt()) {

        if(reading == SEMICOLON) {

            reading = yylex();

            if(stmt_list()) {

                return VALID;

            } else {

                return INVALID;
            }

        } else {

            return VALID;

        }

    } else {

        return INVALID;
        
    }
}

int stmt() {

    if(reading == ID) {

        reading = yylex();
        
        if(reading == ASSIGN) {
            
            reading = yylex();

            if(expr()) {

                return VALID;

            } else {

                return INVALID;
            }

        } else {

            return INVALID;

        }

    } else if(reading == IF) {
        
        reading = yylex();

        if(expresion()) {

            if(reading == THEN) {

                reading = yylex();

                if(opt_stmts()) {

                    if(reading == ENDIF) {

                        reading = yylex();

                        return VALID;

                    } else {

                        return INVALID;
                    }

                } else {

                    return INVALID;
                }

            } else {

                return INVALID;
            }

        } else {

            return INVALID;
        }

    } else if(reading == FOR) {

        reading = yylex();

        if(reading == ID) {

            reading = yylex();

            if(reading == ASSIGN) {

                reading = yylex();

                if(expr()) {

                    if(reading == STEP) {

                        reading = yylex();

                        if(expr()) {

                            if(reading == UNTIL) {

                                reading = yylex();

                                if(expr()) {

                                    if(reading == DO) {

                                        reading = yylex();

                                        if(opt_stmts()) {

                                            if(reading == ENDFOR) {

                                                reading = yylex();

                                                return VALID;

                                            } else {

                                                return INVALID;

                                            }

                                        } else {

                                            return INVALID;

                                        }

                                    } else {

                                        return INVALID;

                                    }

                                } else {

                                    return INVALID;

                                }

                            }

                        } else {

                            return INVALID;

                        }

                    } else {

                        return INVALID;

                    }

                } else {

                    return INVALID;

                }

            } else {

                return INVALID;

            }

        } else {

            return INVALID;
        }


    } else {

         return INVALID;
    }
}

int expr() {

    if(term()) {

        if(ra()) {

            return VALID;

        } else {

            return INVALID;
        }

    } else {

        return INVALID;
    }
}

int term() {

    if(factor()) {

        if(rb()) {
            
            return VALID;

        } else {

            return INVALID;
        }

    } else {

        return INVALID;
    }
}

int factor() {

    if(reading == ID) {
        
        reading = yylex();
        
        return VALID;

    } else if(reading == NUM) {
       
        reading = yylex();

        return VALID;

    } else if(reading == OPEN_PARENTHESIS) {

        reading = yylex();

        if(expr()) {

            if(reading == CLOSE_PARENTHESIS) {
                
                reading = yylex();

                return VALID;

            } else {

                return INVALID;

            }


        } else {

            return INVALID;
        }

    } else {

        return INVALID;
    }
}

int rb() {

    if(reading == MULTIPLIER || reading == DIVISOR) {

        reading = yylex();
        
        if(factor()) {

            if(rb()) {

                return VALID;

            } else {

                return INVALID;

            }

        } else {

            return INVALID;

        }
    } 

    else {

        return VALID;
    }
}

int ra() {

    if(reading == PLUS || reading == MINUS) {

        reading = yylex();

        if(term()) {

            if(ra()) {
                
                return VALID;

            } else {

                return INVALID;
            }

        } else {

            return INVALID;
            
        }

    } else {

        return VALID;

    }
}

int expresion() {

    if(expr()) {

        if(reading == GREATER_THAN || reading  == LESS_THAN || reading == EQUAL_TO) {

            reading = yylex();

            if(expr()) {

                return VALID;
                
            } else {

                return INVALID;

            }

        } else {

            return INVALID;

        }

    } else {

        return INVALID;

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

    return INVALID;
}