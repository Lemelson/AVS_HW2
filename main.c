#include <stdio.h>

int size = 0;

void read(char* str) {
    int i = 0;
    int ch;
    do {
        ch = fgetc(stdin);
        str[i++] = ch;
        size++;
    } while(ch != -1);
    str[i-1] = '\0';
}

int brackets(const char* string) {
    int checker = 0;
    for (int i = 0; i < size; ++i) {
        if (string[i] == '(') {
            checker++;
        }
        if (string[i] == ')') {
            checker--;
        }
        if (checker < 0) {
            return 1;
        }
    }
    if (checker == 0) {
        return 0;
    }
    return 1;
}

int main() {
    char str[1000000];
    read(str);
    int result = brackets(str);
    if (result == 0) {
        printf("Correct\n");
    }
    else {
        printf("Incorrect\n");
    }
}
