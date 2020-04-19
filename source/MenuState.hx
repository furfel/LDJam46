package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	var tutorialButton:FlxButton;
	var playButton:FlxButton;

	override function create()
	{
		super.create();
		add(tutorialButton = new FlxButton(FlxG.width / 2, FlxG.height / 2 - 100, "Tutorial", playTutorial));
		tutorialButton.screenCenter(XY);
		tutorialButton.y -= tutorialButton.height + 12;
		add(playButton = new FlxButton(0, 0, "Play", playSettings));
		playButton.screenCenter(XY);
		playButton.y += playButton.height + 12;
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
