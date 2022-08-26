import hxsl.Shader;
import h2d.filter.Bloom;
import h2d.filter.Glow;
import zygame.display.LoaderXMLScene;
import zygame.display.Scene;

/**
 * 自动构造XmlScene
 */
@:build(zygame.macro.AutoXMLBuilder.build("XmlScene"))
class AutoXMLScene extends LoaderXMLScene {
	var shader = new Test2Shader();

	override function onBuilded() {
		super.onBuilded();
		this.label.text = "123";
		this.button.onClick = function(btn, e) {
			this.replaceScene(MainScene, false);
		}

		shader.time = 0;
		this.label.addShader(shader);
		// this.img.addShader(shader);

		var shader = new SineDeformShader();
		// shader.showAlpha = false;
		this.img.addShader(shader);
	}

	override function update(dt:Float) {
		super.update(dt);
		shader.time += 0.01;
	}
}

@:build(macro.ShaderTest.build())
class Test2Shader extends hxsl.Shader {
	static var SRC = {
		@param var time:Float;
		var pixelColor:Vec4;
		function fragment() {
			pixelColor.rgb += time;
		}
	}
}

@:build(macro.ShaderTest.build())
class TestShader extends hxsl.Shader {
	static var SRC = {
		var pixelColor:Vec4;
		@const var showAlpha:Bool;
		function fragment() {
			if (showAlpha)
				pixelColor.rgb = pixelColor.aaa;
			else
				pixelColor *= vec4(1, 0, 0, 1);
		}
	}
}

class SineDeformShader extends hxsl.Shader {
    static var SRC = {
        @:import h3d.shader.Base2d;
        
        function fragment() {
			pixelColor.r += sin(time);
        }
    }
}
