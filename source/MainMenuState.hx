package;

import flixel.effects.FlxFlicker;
import options.OptionsState;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import openfl.filters.ShaderFilter;
import shaders.ShaderHandler.ShaderObject;
import flixel.FlxG;
import Discord.DiscordClient;
import flixel.addons.transition.FlxTransitionableState;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC

	var allOptions:Array<MainMenuButtons> = [];
	var curSelected:Int = 0;

	var isTransitioning:Bool = false;
	
	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null, null, "menu");
		#end

		var bg = new FlxSprite();
		bg.loadGraphic(Paths.image("menuAssets/bg"));
		bg.screenCenter();
		add(bg);

		var two = new FlxSprite(74, 160);
		two.loadGraphic(Paths.image("menuAssets/2"));
		add(two);

		var mainMenuBar = new FlxSprite(31);
		mainMenuBar.loadGraphic(Paths.image("menuAssets/mainMenu"));
		add(mainMenuBar);

		var play = new MainMenuButtons(699, 233, "play");
		add(play);

		var credits = new MainMenuButtons(593, 353, "credits");
		add(credits);

		var options = new MainMenuButtons(484, 473, "options");
		add(options);

		allOptions.push(play);
		allOptions.push(credits);
		allOptions.push(options);

		changeSelection();

		super.create();
		FlxG.mouse.visible = false;
		
		if(FlxG.sound.music == null || !FlxG.sound.music.playing) 
			FlxG.sound.playMusic(Paths.music('freakyMenu'));	

		ShaderObject.coordFix();
		FlxG.camera.setFilters([new ShaderFilter(ShaderObject.shaderHandler.crt)]);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		ShaderObject.update(elapsed);

		if (!isTransitioning)
		{
			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound("menuBleep"), 0.8);
				curSelected += 1;
				changeSelection();
			}

			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound("menuBleep"), 0.8);
				curSelected -= 1;
				changeSelection();
			}

			if (controls.ACCEPT)
			{
				isTransitioning = true;
				FlxG.sound.play(Paths.sound("menuAccept"), 0.8);
				FlxFlicker.flicker(allOptions[curSelected], 1, 0.04, true, true, function(e:FlxFlicker)
				{
					switch (curSelected)
					{
						case 0:
							PlayState.SONG = Song.loadFromJson("null-hard", "null");
							PlayState.isStoryMode = false;
							PlayState.storyDifficulty = 2;
							
							LoadingState.loadAndSwitchState(new PlayState());
						case 1:
							FlxG.switchState(new CreditsState());
						case 2:
							FlxG.switchState(new OptionsState());
					}
				});
			}
		}
	}

	function changeSelection()
	{
		if (curSelected >= allOptions.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = allOptions.length - 1;

		for (curOp in 0...allOptions.length)
		{
			allOptions[curOp].selected = false;
			if (curOp == curSelected) allOptions[curOp].selected = true;
		}
	}
}

class MainMenuButtons extends FlxSpriteGroup
{
	public var selected:Bool = false;
	var shouldTween:Bool = true;

	var indicator:FlxSprite;
	var button:FlxSprite;

	var originalPos:Array<Array<Float>> = [[], []];
	public function new(X:Float = 0, Y:Float = 0, name:String)
	{
		super(X, Y);

		indicator = new FlxSprite(20, 30);
		indicator.loadGraphic(Paths.image("menuAssets/selected"));
		indicator.color = 0xff767676;
		add(indicator);
		originalPos[0].push(indicator.getPosition().x);
		originalPos[0].push(indicator.getPosition().y);

		button = new FlxSprite();
		button.loadGraphic(Paths.image("menuAssets/option_" + name));
		add(button);
		originalPos[1].push(button.getPosition().x);
		originalPos[1].push(button.getPosition().y);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if (selected)
		{
			indicator.visible = true;
			if (shouldTween){tweenStuff(); shouldTween = false; FlxTween.color(indicator, 0.5, 0xff767676, 0xffE9E9E9, {type:PINGPONG});}
		}
		else
		{
			indicator.visible = false;
			shouldTween = true;
			resetPos();
		}
	}

	function tweenStuff()
	{
		FlxTween.tween(indicator, {x: indicator.x + 20, y: indicator.y + 30}, 0.1);
		FlxTween.tween(button, {x: button.x - 20, y: button.y - 30}, 0.1);

		new FlxTimer().start(0.1, function(e:FlxTimer)
		{
			FlxTween.tween(indicator, {x: indicator.x - 20, y: indicator.y - 30}, 0.09);
		    FlxTween.tween(button, {x: button.x + 20, y: button.y + 30}, 0.09);
		});
	}

	function resetPos()
	{
		FlxTween.cancelTweensOf(indicator);
		FlxTween.cancelTweensOf(button);

		indicator.setPosition(originalPos[0][0], originalPos[0][1]);
		button.setPosition(originalPos[1][0], originalPos[1][1]);
	}
}
