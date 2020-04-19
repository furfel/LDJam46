package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.ui.FlxButton;

class SettingsState extends FlxState
{
	private var playButton:FlxButton;
	private var playLength:FlxUIRadioGroup;

	override function create()
	{
		super.create();

		add(playButton = new FlxButton(0, 0, "Play", playGame));
		playButton.screenCenter(X);
		playButton.y = FlxG.height - playButton.height - 32;
	}

	private function playGame()
	{
		FlxG.switchState(new PlayState());
	}
}
