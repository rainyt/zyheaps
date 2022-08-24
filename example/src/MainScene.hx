import zygame.core.Start;
import zygame.display.Label;
import motion.Actuate;
import zygame.display.Button;
import zygame.display.VBox;
import zygame.display.Image;
import zygame.display.Quad;
import zygame.res.AssetsBuilder;
import zygame.utils.Assets;
import zygame.display.Scene;
import hxd.clipper.Rect;

/**
 * 主要加载场景
 */
class MainScene extends Scene {
	override function onInit() {
		super.onInit();
		var assets = new Assets();
		// 资源共享绑定
		AssetsBuilder.bindAssets(assets);
		// 图片
		assets.loadFile("assets/btn_LvSe.png");
		assets.loadFile("assets/img.png");
		// JSON
		assets.loadFile("assets/data.json");
		// XML
		assets.loadFile("assets/test.xml");
		assets.loadFile("assets/XmlScene.xml");
		// 当加载不认识的文件时，可以统一通过getBytes获取
		assets.loadFile("assets/dj_wenzi_fly.FBX");
		// 加载精灵图
		assets.loadAtlas("assets/FetterDescAtlas.png", "assets/FetterDescAtlas.xml");
		// 加载音频
		assets.loadFile("assets/mc1043.mp3");
		assets.start(function(f) {
			trace("loading", f);
			if (f == 1) {
				var quad = new Quad(Start.current.stageWidth - 100, Start.current.stageHeight - 100, 0x011627, this);
				quad.left = 50;
				quad.right = 50;
				quad.top = 50;
				quad.bottom = 50;

				// 九宫格图支持
				var img = new Image("btn_LvSe", this);
				img.x = 930;
				img.y = 80;
				img.width = 800;
				img.scale9Grid = new Rect(30, 30, 30, 30);
				img.bottom = 200;
				img.left = 40;
				img.right = 40;

				// 非九宫格图
				var img2 = new Image("btn_LvSe", this);
				img2.x = 930;
				img2.y = 80 + img2.height + 30;
				img2.width = 800;
				img2.bottom = 30;
				img2.left = 40;

				var array = ["过渡动画", "网络请求", "播放音乐", "加载资源", "进入场景", "进入XML场景"];

				var vbox = new VBox(this);
				vbox.gap = 30;
				vbox.left = 80;
				vbox.top = 40;

				var img = new Image(assets.getBitmapDataTile("img"), vbox);
				img.right = 0;

				for (index => item in array) {
					var button = Button.create("btn_LvSe", null, vbox);
					// button.img.scale9Grid = new Rect(30, 30, 30, 30);
					button.width = 800;
					button.text = item;
					button.label.setSize(40);
					button.label.setColor(0x0);
					button.onClick = function(btn, e) {
						switch (btn.text) {
							case "播放音乐":
								assets.getSound("mc1043").play(true);
							case "过渡动画":
								var targetX = btn.x;
								btn.x = btn.stageWidth;
								Actuate.tween(btn, 3, {
									x: targetX
								}).onUpdate(function() {
									@:privateAccess btn.posChanged = true;
								});
							case "网络请求":
							// 网络请求
							// var request = new zygame.net.HttpRequest("https://www.baidu.com");
							// request.onData = function(code, data) {
							// 	label.text = "请求成功:" + data.toString().substr(0, 100);
							// }
							// request.onError = function(code, msg) {
							// 	label.text = "请求失败:" + msg + "(" + code + ")";
							// }
							// request.load();
							case "加载资源":
								var a = new Assets();
								a.loadFile("assets/FetterDescAtlas.png");
								a.start(function(f) {
									if (f == 1) {
										for (i in 0...100) {
											var img = new Image(a.getBitmapDataTile("FetterDescAtlas"), this);
											img.y = img.stageHeight - img.height;
											img.x = Math.random() * stageWidth;
										}
									}
								});
							case "进入场景":
								this.replaceScene(PageScene);
							case "进入XML场景":
								this.replaceScene(XMLScene);
						}
						// img.scale9Grid = null;
					}
				}

				// 读取精灵图
				var tile = assets.getBitmapDataTile("FetterDescAtlas:et1001");
				var atlasimg = new Image(tile, vbox);
				atlasimg.right = 0;

				var label:Label = new Label(vbox);
				label.setSize(40);
				label.textAlign = Left;
				label.text = "中文测试";
				// atlasimg.x = Math.random() * (atlasimg.stageWidth);
				// atlasimg.y = Math.random() * (atlasimg.stageHeight);
			}
		});
	}
}
