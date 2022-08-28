package zygame.utils;

#if (mac)
typedef FileDialog = zygame.utils.hl.mac.FileDialog;
#elseif window
typedef FileDialog = zygame.utils.hl.win.FileDialog;
#end
