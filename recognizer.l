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

//include statements
#include <stdio.h>

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

//global variables
int token;

%}


DIGIT [0-9]
DIGITNZ [1-9] //Digit no zero
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

0|({DIGITNZ}({DIGIT}*)) { return NUM; }

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

int prog() {
    
    if(token == PROGRAM) {
        
        token = yylex();

        if(token == ID) {

            token = yylex();

            if(token == MY_BEGIN) {
                
                token = yylex();

                if(token == END) {

                    return VALID;

                } else if(opt_stmts()) {

                    if(token == END) {
                    
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

        return INVALID;

    }
}

int stmt_list() {

    if(stmt()) {

        if(token == SEMICOLON) {

            token = yylex();

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

    if(token == ID) {

        token = yylex();
        
        if(token == ASSIGN) {
            
            token = yylex();

            if(expr()) {

                return VALID;

            } else {

                return INVALID;
            }

        } else {

            return INVALID;

        }

    } else if(token == IF) {
        
        token = yylex();

        if(expresion()) {

            if(token == THEN) {

                token = yylex();

                if(opt_stmts()) {

                    if(token == ENDIF) {

                        token = yylex();

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

    } else if(token == FOR) {

        token = yylex();

        if(token == ID) {

            token = yylex();

            if(token == ASSIGN) {

                token = yylex();

                if(expr()) {

                    if(token == STEP) {

                        token = yylex();

                        if(expr()) {

                            if(token == UNTIL) {

                                token = yylex();

                                if(expr()) {

                                    if(token == DO) {

                                        token = yylex();

                                        if(opt_stmts()) {

                                            if(token == ENDFOR) {

                                                token = yylex();

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

    if(token == ID) {
        
        token = yylex();
        
        return VALID;

    } else if(token == NUM) {
       
        token = yylex();

        return VALID;

    } else if(token == OPEN_PARENTHESIS) {

        token = yylex();

        if(expr()) {

            if(token == CLOSE_PARENTHESIS) {
                
                token = yylex();

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

    if(token == MULTIPLIER || token == DIVISOR) {

        token = yylex();
        
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

    if(token == PLUS || token == MINUS) {

        token = yylex();

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

        if(token == GREATER_THAN || token  == LESS_THAN || token == EQUAL_TO) {

            token = yylex();

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

    token = yylex();

    int valid = prog();

    if(valid) {
        
        printf("yes\n");

    } else {

        printf("no\n");
    }

    return INVALID;
}