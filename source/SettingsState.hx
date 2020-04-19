package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIRadioGroup;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;

class SettingsState extends FlxUIState
{
	private var playButton:FlxButton;
	private var playLength:FlxUIRadioGroup;

	private var buckets = 6;
	private var minutes = 3;

	override public function create()
	{
		_xml_id = "settings";
		super.create();

		// add(playButton = new FlxButton(0, 0, "Play", playGame));
		// playButton.screenCenter(X);
		// playButton.y = FlxG.height - playButton.height - 32;
	}

	private function playGame()
	{
		FlxG.sound.play("assets/sounds/click.wav");
		FlxG.switchState(new PlayState(minutes * 60, buckets));
	}

	private function updateText()
	{
		FlxG.sound.play("assets/sounds/click.wav");
		var btn:FlxUIButton = cast this._ui.getAsset("play");
		if (btn != null)
		{
			btn.label.text = "Play: " + buckets + " buckets & " + minutes + " minutes";
		}
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		super.getEvent(id, sender, data, params);
		if (id == "click_button")
		{
			if (params != null && params.length > 0)
			{
				var str:String = cast params[0];
				if (str == "play")
					playGame();
				else if (StringTools.startsWith(str, "buckets"))
				{
					buckets = Std.parseInt(str.split(":")[1]);
					updateText();
				}
				else if (StringTools.startsWith(str, "minutes"))
				{
					minutes = Std.parseInt(str.split(":")[1]);
					updateText();
				}
			}
		}
	}
}
