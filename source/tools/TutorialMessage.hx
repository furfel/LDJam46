package tools;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.ButtonLabelStyle;
import flixel.addons.ui.FlxButtonPlus;
import flixel.addons.ui.FontDef;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class TutorialMessage extends FlxTypedGroup<FlxSprite>
{
	public static final TIPS = [
		"Welcome to the tutorial!\nPress \"Next\" to continue.", "Move mouse around the character to set the direction.",
		"Use \"W\" on the keyboard to move forward in the direction.", "Now, move towards the bucket in the top of the room.",
		"Stand just next to the bucket. Left mouse click on it to fill the left bottle.",
		"Move towards the other bucket. Right click to fill the right bottle.",
		"Press \"Q\" to mix right bottle into the left. \"E\" for the other way round.", "Now go go down to the crystal.",
		"Stand just next to it. Left mouse click on it to fill it with left color.", "The arrow next to it shows what is the target color.",
		"For the crystal to activate, it should be as close to the target color as possible.", "Now you can continue to play the actual game :)."
	];

	public static final MESSAGE_WIDTH = 360;
	public static final MESSAGE_HEIGHT = 120;
	public static final OUTLINE = 2;

	var box:FlxSprite;
	private var outline:FlxSprite;
	private var text:FlxText;
	private var next:FlxButton;
	private var prev:FlxButton;
	private var exitAndPlay:FlxButton;

	public function new()
	{
		super();

		add(outline = new FlxSprite(FlxG.width / 2 - MESSAGE_WIDTH / 2 - OUTLINE, FlxG.height - MESSAGE_HEIGHT - OUTLINE * 2));
		outline.makeGraphic(MESSAGE_WIDTH + OUTLINE * 2, MESSAGE_HEIGHT + OUTLINE * 2, FlxColor.WHITE);

		add(box = new FlxSprite(FlxG.width / 2 - MESSAGE_WIDTH / 2, FlxG.height - MESSAGE_HEIGHT - OUTLINE));
		box.makeGraphic(MESSAGE_WIDTH, MESSAGE_HEIGHT, FlxColor.BLACK);

		add(text = new FlxText(box.x + 8, box.y + 8, box.width - 16, "Welcome to the tutorial!\nPress \"Next\" to continue.", 16));

		add(next = new FlxButton(0, 0, "Next", nextTip));
		add(prev = new FlxButton(0, 0, "Prev", prevTip));
		add(exitAndPlay = new FlxButton(0, 0, "Play game", play));
		next.scale.set(1.5, 1.5);
		prev.scale.set(1.5, 1.5);
		exitAndPlay.scale.set(1.5, 1.5);
		exitAndPlay.label.size = prev.label.size = next.label.size = Math.floor(next.label.size * 1.5);

		prev.setPosition(box.x + 8 + 8 * 1.5, box.y + MESSAGE_HEIGHT - 8 - prev.height * 1.5);
		next.setPosition(box.x + box.width - 8 - next.width * 1.5, box.y + MESSAGE_HEIGHT - 8 - next.height * 1.5);
		exitAndPlay.setPosition(box.x + box.width - 8 - exitAndPlay.width * 1.5, box.y + MESSAGE_HEIGHT - 8 - exitAndPlay.height * 1.5);
		prev.visible = false;
		exitAndPlay.visible = false;

		forEach(sp -> sp.scrollFactor.set(0, 0));
	}

	private var tip:Int = 0;

	private function nextTip()
	{
		FlxG.sound.play("assets/sounds/click.wav");
		prev.visible = true;
		if (tip < TIPS.length - 1)
			tip++;
		if (tip >= TIPS.length - 1)
		{
			next.visible = false;
			exitAndPlay.visible = true;
		}
		updateTip();
	}

	private function prevTip()
	{
		FlxG.sound.play("assets/sounds/click.wav");
		next.visible = true;
		if (tip > 0)
			tip--;
		if (tip == 0)
		{
			prev.visible = false;
		}
		updateTip();
	}

	private function updateTip()
	{
		text.text = TIPS[tip];
	}

	private function play()
	{
		FlxG.sound.play("assets/sounds/click.wav");
		FlxG.switchState(new SettingsState());
	}
}
