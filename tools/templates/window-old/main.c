#include <stdio.h>
#include <string.h>
#include <direct.h>
#include <stdlib.h>
#include <windows.h>

void get_current_directory(char* p)
{
    char* ret = _getcwd(p, 256);
}
int main ()
{	
   char exep [128] = "\\Contents\\Frameworks\\hl.exe main.hl";
   char str[512] = "";
   get_current_directory(str);
   strcat(str, exep);
   WinExec(str, SW_HIDE);
   return 0;
}