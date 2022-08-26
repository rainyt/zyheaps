import zygame.display.TextInput;
import zygame.display.Box;
import h2d.RenderContext;
import haxe.io.Bytes;
import hxd.fs.FileEntry;
import hxd.res.Model;
import h3d.prim.ModelCache;
import zygame.display.batch.BButton;
import zygame.display.Progress;
import motion.easing.Linear;
import hxd.Event;
import h2d.col.Point;
import hxd.Window;
import h3d.scene.Object;
import zygame.display.Spine;
import haxe.Json;
import zygame.display.Graphics;
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
	private var g:Button;

	private var gx:Float = 0;

	private var gy:Float = 0;

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
		// assets.loadFile("assets/dj_wenzi_fly.FBX");
		// 加载精灵图
		assets.loadAtlas("assets/FetterDescAtlas.png", "assets/FetterDescAtlas.xml");
		// 加载音频
		assets.loadFile("assets/mc1043.mp3");
		assets.loadFile("assets/tree.fbx");
		assets.loadFile("assets/treeTexture.png");
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
				img.left = 940;
				img.right = 40;

				// 非九宫格图
				var img2 = new Image("btn_LvSe", this);
				img2.x = 930;
				img2.y = 80 + img2.height + 30;
				img2.width = 800;
				img2.bottom = 30;
				img2.left = 940;

				var array = [
					"过渡动画", "3D渲染", "网络请求", "播放音乐", "加载资源", "进入场景", "进入XML场景", "XML自动构造", "Spine测试", "卸载资源", "批渲染"
				];

				var vbox = new Box(this);
				// vbox.gap = 30;
				vbox.left = 80;
				vbox.top = 40;
				vbox.right = 80;
				vbox.layout = new zygame.layout.FlowLayout();

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
						trace(Window.getInstance().mouseX, Window.getInstance().mouseY);
						switch (btn.text) {
							case "3D渲染":
								this.replaceScene(Object3DScene);
							case "批渲染":
								this.replaceScene(BatchScene);
							case "卸载资源":
								assets.unloadAll();
							case "Spine测试":
								this.replaceScene(SpineScene);
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
								#if !mac
								var request = new zygame.net.HttpRequest("http://www.baidu.com");
								request.onData = function(code, data) {
									trace("请求成功:" + data.toString().substr(0, 100));
								}
								request.onError = function(code, msg) {
									trace("请求失败:" + msg + "(" + code + ")");
								}
								request.load();

								// HTTPS
								var request = new zygame.net.HttpRequest("https://www.baidu.com");
								request.onData = function(code, data) {
									trace("请求成功:" + data.toString().substr(0, 100));
								}
								request.onError = function(code, msg) {
									trace("请求失败:" + msg + "(" + code + ")");
								}
								request.load();
								#end
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
							case "XML自动构造":
								this.replaceScene(AutoXMLScene);
						}
						// img.scale9Grid = null;
					}
				}

				var p:Progress = new Progress("btn_LvSe", new Quad(100, 100, 0xff0000, null, 6), this);
				p.right = 20;
				p.top = 30;
				p.progress = 0.5;

				var p:Progress = new Progress("btn_LvSe", new Quad(100, 100, 0xff0000, null, 6), this);
				p.right = 20;
				p.top = 230;
				p.style = VERTICAL;
				p.progress = 0.5;

				// 读取精灵图
				var tile = assets.getBitmapDataTile("FetterDescAtlas:et1001");
				var atlasimg = new Image(tile, vbox);
				atlasimg.right = 0;

				var label:Label = new Label(vbox);
				label.setSize(120);
				label.textAlign = Left;
				label.text = "中文测试";
				// label.scale(5);
				label.filter = new h2d.filter.Glow(0xff0000, 100, 1);

				// atlasimg.x = Math.random() * (atlasimg.stageWidth);
				// atlasimg.y = Math.random() * (atlasimg.stageHeight);

				// 测试
				g = Button.create("btn_LvSe", null, this);
				// g = new Graphics(this);
				// g.beginFill(0xff0000);
				// g.drawTriangles([0, 0, 300, 0, 100, 50, 0, 100], [0, 1, 2, 2, 3, 0]); // @:privateAccess g.content.
				// g.endFill();
				// g.enableInteractive = true;
				// g.beginFill(0xffff00);
				// g.drawTriangles([-200, 0, 300, 0, -100, 50, 0, 100], [0, 1, 2, 2, 3, 0]); // @:privateAccess g.content.
				// g.endFill();
				// g.centerX = 0;
				// g.centerY = 0;

				var isDown = false;
				var pos:Point = new Point();
				var beginpos:Point = new Point();
				Start.current.s2d.startCapture((e:Event) -> {
					// mx = e.relX;
					// my = e.relY;
					switch e.kind {
						case EPush:
							g.alpha = 0.7;
							var localPos = this.globalToLocal(new Point(e.relX, e.relY));
							pos.x = localPos.x;
							pos.y = localPos.y;
							beginpos.x = g.x;
							beginpos.y = g.y;
							isDown = true;
						case ERelease:
							g.alpha = 1;
							isDown = false;
						case EMove:
							if (isDown) {
								var localPos = this.globalToLocal(new Point(e.relX, e.relY));
								gx = beginpos.x - (pos.x - localPos.x);
								gy = beginpos.y - (pos.y - localPos.y);
								g.x = gx;
								g.y = gy;
							}
						case EOver:
						case EOut:
						case EWheel:
						case EFocus:
						case EFocusLost:
						case EKeyDown:
						case EKeyUp:
						case EReleaseOutside:
						case ETextInput:
						case ECheck:
					}
				});

				// 测试输入法
				var input:TextInput = new TextInput();
				input.backgroundColor = 0xffff0000;
				this.addChild(input);
				input.inputWidth = 300;
				input.x = 400;
				input.y = 400;
				input.scale(3);
				input.left = 20;
				input.centerX = 0;
				
				this.updateLayout();
			}
		});
	}

	override function update(dt:Float) {
		super.update(dt);
	}
}
