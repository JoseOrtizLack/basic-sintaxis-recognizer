{%
    const int PROGRAM = 1;
    const int ID = 2;
    const int BEGIN = 3;
    const int END = 4;
    const int IF = 5;
    const int THEN = 6;
    const int ENDIF = 7;
    const int FOR = 8;
    const int ASSIGN = 9;
    const int STEP = 10;
    const int UNTIL = 11;
    const int DO = 12;
    const int ENDFOR = 13;
    const int NUM = 14;
%}

LETRA [a-z,A-Z]
DIGITO [0-9]
DIGITOSC [1-9]


%%

{LETRA}({DIGITO}|{LETRA}*) { return ID; }

{DIGITOSC}{DIGITO}* { return NUM; }

program { return PROGRAM; }

begin { return BEGIN; }

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


[ \t\n]+

%%

int main() {
}