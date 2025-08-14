#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Custom gets() replacement for modern GCC
char* my_gets(char* s) {
    fgets(s, 1024, stdin); // intentionally large to allow overflow in lab
    size_t len = strlen(s);
    if (len && s[len-1] == '\n') s[len-1] = '\0'; // remove newline
    return s;
}

void win() {
    FILE *f = fopen("flag.txt", "r");
    if (!f) {
        puts("Flag file missing!");
        exit(1);
    }

    char flag[256];
    if (!fgets(flag, sizeof(flag), f)) {
        puts("Could not read flag!");
        fclose(f);
        exit(1);
    }

    puts(flag);
    fclose(f);
    exit(0);
}

void vuln() {
    char buffer[64];
    puts("Welcome to basic bof. Overflow me!");
    my_gets(buffer); // unsafe enough for CTF
    printf("You said: %s\n", buffer);
}

int main() {
    setvbuf(stdout, NULL, _IONBF, 0);
    vuln();
    puts("Bye!");
    return 0;
}
