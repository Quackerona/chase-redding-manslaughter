package;

import openfl.Lib;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import shaders.ShaderHandler.ShaderObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;

class PauseSubState extends MusicBeatSubstate {
	var allButtons:Array<PauseButton> = [];
	var curSelection:Int = 0;
	override function create() {
		super.create();
		FlxG.sound.play(Paths.sound("menuAccept"), 0.8);
		FlxG.sound.play(Paths.music("pause"), 1, true);

		var bar = new FlxSprite(1280);
		bar.loadGraphic(Paths.image("pauseAssets/bar"));
		bar.scrollFactor.set();
		bar.antialiasing = ClientPrefs.globalAntialiasing;
		add(bar);

		var paused = new FlxSprite(-1280);
		paused.loadGraphic(Paths.image("pauseAssets/paused"));
		paused.scrollFactor.set();
		paused.antialiasing = ClientPrefs.globalAntialiasing;
		add(paused);

		var resume = new PauseButton(1280, 0, "continue");
		resume.onClick = function() close(); //a function inside of a function?? so funny!!
		resume.scrollFactor.set();
		resume.antialiasing = ClientPrefs.globalAntialiasing;
		add(resume);
		
		var restart = new PauseButton(1280, 0, "restart");
		restart.onClick = function() restartSong(); //woops, again!
		restart.scrollFactor.set();
		restart.antialiasing = ClientPrefs.globalAntialiasing;
		add(restart);

		var exit = new PauseButton(1280, 0, "exit");
		exit.onClick = function(){
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;

			WeekData.loadTheFirstEnabledMod();
			MusicBeatState.switchState(new MainMenuState());
			PlayState.cancelMusicFadeTween();
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.changedDifficulty = false;
			PlayState.chartingMode = false;

		};
		exit.scrollFactor.set();
		exit.antialiasing = ClientPrefs.globalAntialiasing;
		add(exit);

		allButtons.push(resume);
		allButtons.push(restart);
		allButtons.push(exit);

		FlxTween.tween(bar, {x:0}, 0.3, {ease:FlxEase.sineIn});
		FlxTween.tween(paused, {x:0}, 0.3, {ease:FlxEase.sineIn});
		for (buttons in allButtons)
			FlxTween.tween(buttons, {x:0}, 0.3, {ease:FlxEase.sineIn});
		
		switchSelection();

		camera = FlxG.cameras.list[FlxG.cameras.list.length - 1];
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		ShaderObject.update(elapsed);
		if (controls.UI_DOWN_P)
		{
			FlxG.sound.play(Paths.sound("menuBleep"), 0.8);
			curSelection += 1;
			switchSelection();
		}

		if (controls.UI_UP_P)
		{
			FlxG.sound.play(Paths.sound("menuBleep"), 0.8);
			curSelection -= 1;
			switchSelection();
		}
	}

	function switchSelection()
	{
		if (curSelection >= allButtons.length)
			curSelection = 0;
		if (curSelection < 0)
			curSelection = allButtons.length - 1;

		for (i in 0...allButtons.length)
		{
			allButtons[i].selected = false;
			allButtons[curSelection].selected = true;
		}
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}
}

class PauseButton extends FlxSprite
{
	public var selected:Bool = false;
	public var onClick:Void -> Void = null;

	public function new(X:Float = 0, Y:Float = 0, sprPath:String)
	{
		super(X, Y);
		loadGraphic(Paths.image("pauseAssets/" + sprPath));
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		color = FlxColor.WHITE;
		if (selected)
		{
			color = FlxColor.YELLOW;
			if (FlxG.keys.justPressed.ENTER && onClick != null)
			{
				FlxG.sound.play(Paths.sound("menuAccept"), 0.8);
				FlxFlicker.flicker(this, 1, 0.04, true, true, function(e:FlxFlicker){
					onClick();
				});
			}
		}
	}
}