
#include <windows.h>
#include <Commdlg.h>
#include <stdio.h>

// 返回值: 成功 1, 失败 0
// 通过 path 返回获取的路径
int FileDialog(char *path)
{
	OPENFILENAME ofn;
	ZeroMemory(&ofn, sizeof(ofn));
    ofn.lStructSize = sizeof(ofn); // 结构大小
    ofn.lpstrFile = path; // 路径
    ofn.nMaxFile = MAX_PATH; // 路径大小
    ofn.lpstrFilter = "All\0*.*\0Text\0*.TXT\0"; // 文件类型
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST;
	return GetOpenFileName(&ofn);
}

int main(int argc, char* argv[])
{
    char szFile[MAX_PATH] = {0};
	if(FileDialog(szFile))
	{
        printf("%s save to %s", szFile, argv[1]);
        FILE* f1 = fopen(argv[1], "w+");
        fputs(szFile, f1);
        fclose(f1);
    }
    return 0;
}