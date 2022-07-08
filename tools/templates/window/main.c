#include <stdio.h>
#include <string.h>

// #if defined(_MSC_VER)
// #include <direct.h>
// #define CWD _getcwd
// #elif defined(__unix__)
// #include <unistd.h>
// #include <stdlib.h>
// #define CWD getcwd
// #else
// #endif
#include <direct.h>
#include <stdlib.h>
#define CWD _getcwd
#include <windows.h>

void get_current_directory(char* p)
{
    char* ret = CWD(p, 250);
}
int main ()
{	
   char exep [256] = "\\Contents\\Frameworks\\hl.exe main.hl";
   // char real[1024] = strcat(get_current_directory(), exe);
   char str[512] = "sdsdsd";
   get_current_directory(str);
   strcat(str, exep);
   printf("path:   %s\n", str);
   //system(str);
   WinExec(str, SW_HIDE);
   return 0;
}