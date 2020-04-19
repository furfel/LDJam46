package objects;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class ColorBucket extends FlxTypedGroup<FlxSprite>
{
	private var fluid:FlxSprite;
	private var bucketback:FlxSprite;
	private var bucketfront:FlxSprite;

	public function new(X:Float, Y:Float, hue:Float)
	{
		super();
		add(bucketback = new FlxSprite(X, Y));
		bucketback.loadGraphic("assets/images/bucketback.png", false, 168, 96);
		add(fluid = new FlxSprite(X + 6, Y + 11));
		fluid.loadGraphic("assets/images/boil.png", true, 156, 106);
		fluid.animation.add("boil", [0, 1, 2, 3, 4], 8);
		fluid.animation.play("boil");
		fluid.color = FlxColor.fromHSL(hue, 0.8, 0.7);
		add(bucketfront = new FlxSprite(X, Y + 59));
		bucketfront.loadGraphic("assets/images/bucketfront.png", false, 168, 109);
	}
}
