package;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;

class Death extends MusicBeatState {
    var canGo:Bool = false;

    var black:FlxSprite;
    override function create() {
        super.create();
        var tails = new FlxSprite();
        tails.frames = Paths.getSparrowAtlas("NE/Tailsded");
        tails.animation.addByPrefix("loop", "Tailsded loop", 12);
        tails.animation.play("loop");
        tails.scrollFactor.set();
        tails.antialiasing = ClientPrefs.globalAntialiasing;
        tails.alpha = 0;
        tails.scale.set(2.2, 2.2);
        tails.updateHitbox();
        tails.screenCenter();
        add(tails);

        black = new FlxSprite();
        black.makeGraphic(1280, 720, FlxColor.BLACK);
        black.screenCenter();
        black.visible = false;
        add(black);

        FlxG.sound.play(Paths.sound("death"), 1, false, null, true, function()
        {
            FlxTween.tween(tails, {alpha: 0.7}, 2);
            FlxG.sound.play(Paths.music("gameOver"), 1, true);
            canGo = true;
        });
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (controls.ACCEPT)
        {
            if (canGo)
            {
                black.visible = true;
                CustomFadeTransition.nextCamera = null;
                FlxG.switchState(new PlayState());
            }
        }
        if (controls.BACK)
        {
            black.visible = true;
            CustomFadeTransition.nextCamera = null;
            FlxG.switchState(new MainMenuState());
        }
    }
}