package shaders;

import openfl.display.Sprite;
import flixel.FlxG;


class ShaderObject {
    public static var shaderHandler = new ShaderHandler();

    public static function update(elapsed:Float) {
        shaderHandler.update(elapsed);
    }

    public static function coordFix(){
        shaderHandler.shaderCoordFix();
    }
}

class ShaderHandler {
    public var crt = new CRT();
    public var distortion = new Distortion();
    public function new()
    {
        crt.iTime.value = [0];
        crt.iResolution.value = [FlxG.width, FlxG.height, 0.0];
        crt.chromatic.value = [0.0005];
        
        distortion.kV.value = [0];
    }

    public function update(elasped:Float)
    {
        crt.iTime.value[0] += elasped;
    }

    public function shaderCoordFix(){
        var resetCamCache = function(spr:Sprite) {
            if (spr == null || spr.filters == null) return;
            @:privateAccess
            {
                spr.__cacheBitmap = null;
                spr.__cacheBitmapData = null;
            }
        }
        
        var fixShaderCoordFix = function(?b:Int, ?t:Int) {
            resetCamCache(FlxG.camera.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
    }
}
