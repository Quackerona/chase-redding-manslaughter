package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import shaders.ShaderHandler.ShaderObject;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.tweens.FlxTween;

class Events {
    var songName:String;

    var fog:FlxSprite;
    var whiteNE:FlxSprite;
    var whiteOverlay:FlxSprite;
    var face:FlxSprite;
    var glitchTween:FlxTween;
    public function new(name:String)
    {
        songName = name;

        switch (songName)
        {
            case "null":
                new FlxSound().loadEmbedded(Paths.music("pause"));
                new FlxSound().loadEmbedded(Paths.music("gameOver"));
                new FlxSound().loadEmbedded(Paths.music("death"));

                PlayState.instance.boyfriend.visible = false;

                PlayState.instance.dad.alpha = 0;
                PlayState.instance.camHUD.alpha = 0;

                PlayState.instance.moveCamera(true);
                PlayState.instance.isCameraOnForcedPos = true;

                whiteNE = new FlxSprite(230, -130);
                whiteNE.loadGraphicFromSprite(PlayState.instance.dad);
                whiteNE.antialiasing = ClientPrefs.globalAntialiasing;
                whiteNE.scale.set(1.7, 1.7);
                whiteNE.updateHitbox();
                whiteNE.setColorTransform(1, 1, 1, 1, 255, 255, 255);
                whiteNE.alpha = 0;
                add(whiteNE);

                face = new FlxSprite();
                face.loadGraphic(Paths.image("NE/fear"));
                face.screenCenter();
                face.scrollFactor.set();
                face.antialiasing = ClientPrefs.globalAntialiasing;
                face.alpha = 0;
                add(face);

                fog = new FlxSprite();
                fog.frames = Paths.getSparrowAtlas("NE/fog");
                fog.alpha = 0.75;
                fog.screenCenter();
                fog.animation.addByPrefix("loop", "fog", 10);
                fog.animation.play("loop");
                add(fog);

                whiteOverlay = new FlxSprite();
                whiteOverlay.makeGraphic(2000, 2000);
                whiteOverlay.screenCenter();
                whiteOverlay.alpha = 0;
                add(whiteOverlay);
                
        }
    }

    public function onStep(curStep:Int)
    {
        switch (songName)
        {
            case "null":
                if (curStep == 1)
                    PlayState.instance.tweenManager.tween(whiteNE, {alpha:0.3}, 4.5);
                if (curStep == 33)
                    PlayState.instance.defaultCamZoom += 0.055;
                if (curStep == 64)
                {
                    PlayState.instance.defaultCamZoom += 0.075;

                    PlayState.instance.tweenManager.tween(whiteNE, {alpha:0}, 0.7);
                    PlayState.instance.tweenManager.tween(PlayState.instance.dad, {alpha:1}, 0.7);
                    PlayState.instance.tweenManager.tween(fog, {alpha:0.65}, 0.7);
                    PlayState.instance.tweenManager.tween(PlayState.instance.camHUD, {alpha:1}, 0.7);
                }
                if (curStep == 184)
                {
                    PlayState.instance.defaultCamZoom -= 0.25;
                    PlayState.instance.tweenManager.num(0, -1.4, 0.7, {ease:FlxEase.sineOut}, function(val:Float)
                    {
                        ShaderObject.shaderHandler.distortion.kV.value[0] = val;
                    });
                }
                if (curStep == 191)
                {
                    PlayState.instance.defaultCamZoom += 0.25;
                    PlayState.instance.tweenManager.num(-1.4, 0, 0.6, {ease:FlxEase.sineOut}, function(val:Float)
                    {
                        ShaderObject.shaderHandler.distortion.kV.value[0] = val;
                    });
                }
                if (curStep == 192)
                {
                    PlayState.instance.camGame.flash(FlxColor.WHITE, 1.3);
                    PlayState.instance.camGame.zoom += 0.1;
                    PlayState.instance.camHUD.zoom += 0.05;
                }
                if (curStep == 512)
                {
                    PlayState.instance.camGame.shake(0.001, 3);

                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0.35}, 3);

                    PlayState.instance.tweenManager.num(PlayState.instance.defaultCamZoom, PlayState.instance.defaultCamZoom + 0.3, 3, {ease:FlxEase.sineOut}, function(val:Float)
                    {
                        PlayState.instance.defaultCamZoom = val;
                    });

                    PlayState.instance.tweenManager.num(0.0005, 0.007, 3, {ease:FlxEase.sineOut}, function(val:Float)
                    {
                        ShaderObject.shaderHandler.crt.chromatic.value[0] = val;
                    });
                }

                if (curStep == 544)
                {
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0}, 0.4);
                    PlayState.instance.tweenManager.tween(PlayState.instance.dad, {alpha: 0}, 0.4);
                    PlayState.instance.tweenManager.tween(PlayState.instance.boyfriend, {alpha: 0}, 0.4);
                    PlayState.instance.tweenManager.tween(fog, {alpha: 0.3}, 0.4);
                    PlayState.instance.tweenManager.tween(PlayState.instance.camHUD, {alpha: 0}, 0.4);
                }

                if (curStep == 562)
                {
                    ShaderObject.shaderHandler.crt.chromatic.value[0] = 0;
                    PlayState.instance.tweenManager.num(0, 0.007, 1.3, {ease:FlxEase.sineOut}, function(val:Float)
                    {
                        ShaderObject.shaderHandler.crt.chromatic.value[0] = val;
                    });

                    PlayState.instance.tweenManager.tween(face, {alpha: 0.6}, 1.6);
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0.35}, 1.3);
                    PlayState.instance.camGame.shake(0.002, 1.6);
                }
                

                if (curStep == 576)
                {
                    PlayState.instance.camGame.flash(FlxColor.WHITE, 1.2);

                    PlayState.instance.tweenManager.tween(PlayState.instance.camHUD, {alpha: 1}, 0.4);
                    PlayState.instance.dad.alpha = 1;
                    PlayState.instance.boyfriend.alpha = 1;
                    fog.alpha = 0.55;
                    face.visible = false;
                    whiteOverlay.alpha = 0;
                    ShaderObject.shaderHandler.crt.chromatic.value[0] = 0;

                    PlayState.instance.defaultCamZoom -= 0.3;
                }

                if (curStep == 1072)
                {
                    PlayState.instance.camGame.angle = 0;
                    PlayState.instance.camHUD.angle = 0;

                    PlayState.instance.tweenManager.num(0, 0.007, 1.55, {ease:FlxEase.sineOut}, function(val:Float)
                    {
                        ShaderObject.shaderHandler.crt.chromatic.value[0] = val;
                    });
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0.35}, 1.55);
                    PlayState.instance.camGame.shake(0.004, 1.55);

                    PlayState.instance.defaultCamZoom += 0.2;
                }

                if (curStep == 1088)
                {
                    PlayState.instance.camGame.flash(FlxColor.WHITE, 1.2);

                    PlayState.instance.defaultCamZoom = 0.83;
                    whiteOverlay.alpha = 0;
                    ShaderObject.shaderHandler.crt.chromatic.value[0] = 0;

                    PlayState.instance.camHUD.angle = -1.5;
                    PlayState.instance.tweenManager.tween(PlayState.instance.camHUD, {angle: 1.5}, 5, {ease:FlxEase.sineInOut, type:PINGPONG});

                    PlayState.instance.camGame.angle = -1;
                    PlayState.instance.tweenManager.tween(PlayState.instance.camGame, {angle: 1}, 5, {ease:FlxEase.sineInOut, type:PINGPONG});

                    PlayState.instance.boyfriend.visible = true;
                    PlayState.instance.boyfriend.alpha = 0.7;
                    PlayState.instance.tweenManager.tween(PlayState.instance.boyfriend, {alpha: 0.4}, 1.3, {ease:FlxEase.sineOut, type: PINGPONG});
                    PlayState.instance.dad.setPosition(100, 180);

                    PlayState.instance.isCameraOnForcedPos = false;
                    PlayState.instance.camFollow.x = 779;
                    PlayState.instance.camFollow.y = 600;
                    PlayState.instance.isCameraOnForcedPos = true;

                    PlayState.instance.greenhill.scale.set(1, 1);
                    PlayState.instance.waterfall.scale.set(1, 1);
                }

                if (curStep == 1600)
                {
                    PlayState.instance.tweenManager.cancelTweensOf(PlayState.instance.camHUD);
                    PlayState.instance.tweenManager.cancelTweensOf(PlayState.instance.camGame);

                    PlayState.instance.tweenManager.tween(PlayState.instance.camGame, {alpha: 0.7}, 0.4, {ease:FlxEase.sineOut});
                    PlayState.instance.tweenManager.num(PlayState.instance.defaultCamZoom, PlayState.instance.defaultCamZoom + 0.05, 0.4, null, function(val:Float)
                    {
                        PlayState.instance.defaultCamZoom = val;
                    });
                    PlayState.instance.camGame.angle = 0;
                    PlayState.instance.camHUD.angle = 0;
                }

                if (curStep == 2176)
                {
                    PlayState.instance.tweenManager.tween(PlayState.instance.camGame, {alpha: 0.5}, 0.4, {ease:FlxEase.sineOut});
                    PlayState.instance.tweenManager.num(PlayState.instance.defaultCamZoom, PlayState.instance.defaultCamZoom + 0.1, 0.4, null, function(val:Float)
                    {
                        PlayState.instance.defaultCamZoom = val;
                    });
                }

                if (curStep == 2232)
                {
                    PlayState.instance.defaultCamZoom += 0.15;
                    PlayState.instance.tweenManager.tween(PlayState.instance.camGame, {alpha: 0.4}, 0.4, {ease:FlxEase.sineOut});
                }

                if (curStep == 2240)
                {
                    PlayState.instance.camGame.alpha = 1;
                    PlayState.instance.camGame.flash(FlxColor.WHITE, 1.2);

                    PlayState.instance.defaultCamZoom = 0.73;
                    PlayState.instance.dad.setPosition();

                    PlayState.instance.greenhill.visible = false;
                    PlayState.instance.waterfall.visible = false;
                    PlayState.instance.isCameraOnForcedPos = false;
                    PlayState.instance.boyfriend.visible = false;

                    PlayState.instance.camHUD.angle = -1.5;
                    PlayState.instance.tweenManager.tween(PlayState.instance.camHUD, {angle: 1.5}, 5, {ease:FlxEase.sineInOut, type:PINGPONG});

                    PlayState.instance.camGame.angle = -1;
                    PlayState.instance.tweenManager.tween(PlayState.instance.camGame, {angle: 1}, 5, {ease:FlxEase.sineInOut, type:PINGPONG});
                }

                if (curStep == 2241)
                    PlayState.instance.isCameraOnForcedPos = true;

                if (curStep == 2736)
                {
                    PlayState.instance.tweenManager.cancelTweensOf(PlayState.instance.camHUD);
                    PlayState.instance.tweenManager.cancelTweensOf(PlayState.instance.camGame);

                    PlayState.instance.tweenManager.tween(PlayState.instance.camGame, {alpha: 0.5}, 0.4, {ease:FlxEase.sineOut});
                    PlayState.instance.tweenManager.num(PlayState.instance.defaultCamZoom, PlayState.instance.defaultCamZoom + 0.2, 0.4, null, function(val:Float)
                    {
                        PlayState.instance.defaultCamZoom = val;
                    });
                    PlayState.instance.camGame.angle = 0;
                    PlayState.instance.camHUD.angle = 0;
                }

                if (curStep == 2756)
                {
                    PlayState.instance.camGame.alpha = 1;
                    PlayState.instance.camGame.flash(FlxColor.WHITE, 1.2);
                    PlayState.instance.defaultCamZoom = 0.73;
                }

                if (curStep == 3012)
                    PlayState.instance.tweenManager.tween(PlayState.instance.dad, {alpha: 0}, 1);

                if (curStep == 3024)
                {
                    PlayState.instance.camHUD.visible = false;
                    PlayState.instance.tweenManager.cancelTweensOf(PlayState.instance.dad);
                    PlayState.instance.dad.alpha = 1;

                    PlayState.instance.tweenManager.num(0.003, 0.05, 4, {ease:FlxEase.sineOut}, function(val:Float)
                    {
                        ShaderObject.shaderHandler.crt.chromatic.value[0] = val;
                    });

                    whiteOverlay.alpha = 0.3;
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0.65}, 4);
                    PlayState.instance.camGame.shake(0.006, 4);
                    PlayState.instance.tweenManager.num(PlayState.instance.defaultCamZoom, PlayState.instance.defaultCamZoom + 0.3, 4, null, function(val:Float)
                    {
                        PlayState.instance.defaultCamZoom = val;
                    });
                }

                if (curStep == 3059)
                    throw "There is no BitmapData asset with an ID of \"assets/shared/images/characters/Tails.png\"";
        }
    }

    public function onBeat(curBeat:Int)
    {
        switch (songName)
        {
            case "null":
                if (curBeat >= 16 && curBeat < 48 && curBeat % 4 == 0)
                {
                    PlayState.instance.camGame.zoom += 0.05;
                    PlayState.instance.camHUD.zoom += 0.02;
                }

                if (curBeat >= 48 && curBeat < 128 && curBeat % 2 == 0)
                {
                    PlayState.instance.tweenManager.cancelTweensOf(whiteOverlay);
                    whiteOverlay.alpha = 0.2;
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0}, 0.4, {ease:FlxEase.sineOut});

                    PlayState.instance.camGame.zoom += 0.055;
                    PlayState.instance.camHUD.zoom += 0.03;
                }

                if (curBeat >= 144 && curBeat < 268)
                {
                    PlayState.instance.tweenManager.cancelTweensOf(whiteOverlay);
                    whiteOverlay.alpha = 0.2;
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0}, 0.4, {ease:FlxEase.sineOut});

                    PlayState.instance.camGame.zoom += 0.055;
                    PlayState.instance.camHUD.zoom += 0.03;

                    if (curBeat % 2 == 0)
                    {
                        PlayState.instance.camGame.angle = 1;
                        PlayState.instance.camHUD.angle = 1;
                    }
                    else
                    {
                        PlayState.instance.camGame.angle = -1;
                        PlayState.instance.camHUD.angle = -1;
                    }
                }

                if (curBeat >= 272 && curBeat < 400)
                {
                    PlayState.instance.tweenManager.cancelTweensOf(whiteOverlay);
                    whiteOverlay.alpha = 0.2;
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0}, 0.4, {ease:FlxEase.sineOut});

                    PlayState.instance.camGame.zoom += 0.055;
                    PlayState.instance.camHUD.zoom += 0.03;

                    if (glitchTween != null)
                        glitchTween.cancel();
                    glitchTween = PlayState.instance.tweenManager.num(0.0035, 0.0004, 0.4, {ease:FlxEase.sineOut}, function(e:Float)
                    {
                        ShaderObject.shaderHandler.crt.chromatic.value[0] = e;
                    });
                }

                if (curBeat >= 400 && curBeat < 560 && curBeat % 2 == 0)
                {
                    PlayState.instance.tweenManager.cancelTweensOf(whiteOverlay);
                    whiteOverlay.alpha = 0.2;
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0}, 0.4, {ease:FlxEase.sineOut});

                    PlayState.instance.camGame.zoom += 0.055;
                    PlayState.instance.camHUD.zoom += 0.03;
                }

                if (curBeat >= 560 && curBeat < 684)
                {
                    PlayState.instance.tweenManager.cancelTweensOf(whiteOverlay);
                    whiteOverlay.alpha = 0.2;
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0}, 0.4, {ease:FlxEase.sineOut});

                    PlayState.instance.camGame.zoom += 0.055;
                    PlayState.instance.camHUD.zoom += 0.03;

                    if (glitchTween != null)
                        glitchTween.cancel();
                    glitchTween = PlayState.instance.tweenManager.num(0.0035, 0.0004, 0.4, {ease:FlxEase.sineOut}, function(e:Float)
                    {
                        ShaderObject.shaderHandler.crt.chromatic.value[0] = e;
                    });
                }

                if (curBeat >= 689 && curBeat < 753 && curBeat % 2 == 0)
                {
                    PlayState.instance.tweenManager.cancelTweensOf(whiteOverlay);
                    whiteOverlay.alpha = 0.2;
                    PlayState.instance.tweenManager.tween(whiteOverlay, {alpha: 0}, 0.4, {ease:FlxEase.sineOut});

                    PlayState.instance.camGame.zoom += 0.055;
                    PlayState.instance.camHUD.zoom += 0.03;
                }
        }
    }

    public function onSection(curSection:Int)
    {
        switch (songName)
        {
            case "null":
                
        }
    }

    public function onUpdate(elapsed:Float)
    {
        switch (songName)
        {
            case "null":
                whiteNE.loadGraphicFromSprite(PlayState.instance.dad);
        }
    }

    function add(Object:FlxBasic, ?layer:Null<Int>)
    {
        var layerID:Int;
        if (layer != null)
            layerID = layer;
        else
            layerID = PlayState.instance.members.length + 1;

         PlayState.instance.insert(layerID, Object);
    }
}