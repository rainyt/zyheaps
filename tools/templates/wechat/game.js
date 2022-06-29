//核心渲染DOM库
import './index.js'
import core from 'zygameui-dom.js'

if(window.isWebView != true){
    window.Window = Object;
    window.Image = core.Image;
    window.Canvas = core.Canvas;
    window.HTMLCanvasElement = core.HTMLCanvasElement;
    window.HTMLDocument = core.HTMLDocument;
    window.HTMLElement = core.HTMLElement;
    window.XMLHttpRequest = core.XMLHttpRequest;
    window.WebSocket = core.WebSocket;
    window.CanvasRenderingContext2D = core.CanvasRenderingContext2D;
}

window.canvas = core.Window.canvas;

window.biliappid = '::SET_BILI_APPID::';
// 微信bannerkey
window.bannerAdKey = '::SET_WX_BANNERKEY::';
// 微信视频广告key
window.videoAdKey = '::SET_WX_VIDEOKEY::';
window.videoAdKey2 = '::SET_WX_VIDEOKEY2::';
// APP下一章跳转其他微信小游戏的ID
window.toId="::SET_WX_TOID::";
// 支付Key
window.payId='::SET_WX_PAY::';
// 插屏广告KEY
window.interstitiaKey="::SET_INTER_KEY::";
// KengSDK配置
window.KENGSDK_APPKEY="::SET_KENGSDK_APPKEY::";
window.KENGSDK_APPSECRET="::SET_KENGSDK_APPSECRET::";
window.KENGSDK_INIT_CLASS="::SET_KENGSDK_INIT_CLASS::";
window.KENGSDK_CHANNEL="::SET_KENGSDK_CHANNEL::";

window.PAY_CLASS="::SET_PAY_CLASS::";
window.APPID="::SET_WX_APPID::";
window.SCRECT=null;
window.GAME_VERSION=::SET_GAME_VERSION::;
window.NOTCH_CLASS="::SET_NOTCH_CLASS::";
//百度使用的APPKEY
window.APPKEY="::SET_BD_APPKEY::";
window.ADAPPID = "::SET_BD_AD_APPID::";
window.dealId = "::SET_BD_PAY_DEALIID::";
window.bdPayAppKey = "::SET_BD_PAY_APPKEY::";
//远程路径
window.webPath='::SET_REMOTE_PATH::';
if(window.webPath == "null")
    window.webPath = null;

import * as heaps from '::APP_FILE::.js'

var cw = window.innerWidth;
var ch  = window.innerHeight;
window.canvas.width = 600;
window.canvas.height = Math.ceil(ch / cw * canvas.width);