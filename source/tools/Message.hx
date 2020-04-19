package tools;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.motion.LinearMotion;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Message extends FlxTypedGroup<FlxSprite>
{
	public static final MESSAGE_WIDTH = 360;
	public static final MESSAGE_HEIGHT = 120;
	public static final OUTLINE = 2;

	var box:FlxSprite;
	private var outline:FlxSprite;
	private var text:FlxText;

	public function new()
	{
		super();
		box = new FlxSprite(FlxG.width / 2 - MESSAGE_WIDTH / 2, FlxG.height + MESSAGE_HEIGHT + OUTLINE);

		box.makeGraphic(MESSAGE_WIDTH, MESSAGE_HEIGHT, FlxColor.BLACK);

		add(outline = new FlxSprite(box.x - OUTLINE, box.y - OUTLINE).makeGraphic(MESSAGE_WIDTH + OUTLINE * 2, MESSAGE_HEIGHT + OUTLINE * 2));
		add(box);
		add(text = new FlxText(box.x + 8, box.y + 8, box.width - 16, "Message", 18));
		// super(FlxG.width / 2 - MESSAGE_WIDTH / 2, FlxG.height - MESSAGE_HEIGHT);
		forEach(sprite -> sprite.scrollFactor.set(0, 0));
	}

	public function showMessage(message:String)
	{
		countdown = 3.0;
		text.text = message;
		if (currentTween != null && !currentTween.finished)
			currentTween.cancel();
		currentTween = FlxTween.linearMotion(box, box.x, box.y, box.x, FlxG.height - MESSAGE_HEIGHT - OUTLINE, 0.4, true,
			{ease: FlxEase.bounceInOut, type: ONESHOT, onUpdate: motionOthers});
	}

	private var countdown = 0.0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (countdown > 0)
		{
			countdown -= elapsed;
			if (countdown <= 0)
				hideMessage();
		}
	}

	private var currentTween:FlxTween = null;

	private function hideMessage()
	{
		if (currentTween != null && !currentTween.finished)
			currentTween.cancel();
		currentTween = FlxTween.linearMotion(box, box.x, box.y, box.x, box.y + MESSAGE_HEIGHT + 2 * OUTLINE, 0.4, true,
			{ease: FlxEase.bounceInOut, type: ONESHOT, onUpdate: motionOthers});
	}

	function motionOthers(tw:FlxTween)
	{
		outline.y = cast(tw, LinearMotion).y - OUTLINE;
		text.y = cast(tw, LinearMotion).y + 8;
	}
}
