#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void win() {
    FILE *f = fopen("flag.txt", "r");
    if (!f) {
        puts("Flag file missing! Contact the challenge admin.");
        exit(1);
    }

    char flag[256];
    if (!fgets(flag, sizeof(flag), f)) {
        puts("Could not read flag!");
        fclose(f);
        exit(1);
    }

    puts(flag);  // Prints: TheEasiestOverflow
    fclose(f);
    exit(0);
}

void vuln() {
    char buffer[64];
    puts("Welcome to basic bof. Overflow me!");
    gets(buffer); // INTENTIONALLY UNSAFE
    printf("You said: %s\n", buffer);
}

int main() {
    setvbuf(stdout, NULL, _IONBF, 0); // no buffering
    vuln();
    puts("Bye!");
    return 0;
}

