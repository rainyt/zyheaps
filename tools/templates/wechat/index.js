//获取微信的平台处理
const global = GameGlobal;
GameGlobal.global = GameGlobal.global || global;
if(global.window == undefined)
    global.window = global;