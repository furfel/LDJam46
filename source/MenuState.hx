package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;

class MenuState extends FlxUIState
{
	var tutorialButton:FlxUIButton;
	var playButton:FlxUIButton;

	override public function create()
	{
		_xml_id = "menu";

		super.create();
		/*add(tutorialButton = new FlxUIButton(FlxG.width / 2, FlxG.height / 2 - 100, "Tutorial", playTutorial));
			tutorialButton.screenCenter(XY);
			tutorialButton.y -= tutorialButton.height * 2 + 24;
			add(playButton = new FlxUIButton(0, 0, "Play", playSettings));
			playButton.screenCenter(XY);
			playButton.y += playButton.height * 2 + 24; */
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		super.getEvent(id, sender, data, params);
		if (id == "click_button")
		{
			var i:Int = cast params[0];
			switch (i)
			{
				case 1:
					playTutorial();
				case 2:
					playSettings();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	private function playTutorial()
	{
		FlxG.switchState(new TutorialState());
	}

	private function playSettings()
	{
		FlxG.switchState(new SettingsState());
	}
}
