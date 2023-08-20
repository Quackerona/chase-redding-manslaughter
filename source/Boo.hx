package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import hxcodec.VideoHandler;

class Boo extends MusicBeatState{
    override function create() {
        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
        PlayerSettings.init();

        super.create();
        FlxG.mouse.visible = false;

        FlxG.save.bind('funkin', CoolUtil.getSavePath());
		ClientPrefs.loadPrefs();
        Highscore.load();
        if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			FlxG.fullscreen = FlxG.save.data.fullscreen;

        new FlxTimer().start(1, function(e:FlxTimer)
        {
            var fakeIntro = new VideoHandler();
            fakeIntro.canSkip = false;
            fakeIntro.finishCallback = function(){
                FlxG.switchState(new MainMenuState());
            }
            fakeIntro.playVideo(Paths.video("intro"));
        });
    }
}