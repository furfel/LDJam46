package objects;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

class ColorBucket extends FlxTypedGroup<FlxSprite>
{
	public static final BUCKETS_DISTANCE_RADIUS = 120.0;

	private static inline function normalizeH(h:Float)
	{
		return h % 360.0;
	}

	public static function createBuckets(amount:Int, portal:Portal)
	{
		var buckets = new Array<ColorBucket>();
		var deg = -90.0;
		var angleDelta = 360.0 / amount;
		var cx = portal.x + portal.width / 2.0;
		var cy = portal.y + portal.height / 2.0;
		var radius = portal.width / 2 + BUCKETS_DISTANCE_RADIUS;
		var randomShift = new FlxRandom().int(amount);

		while (deg < 270.0)
		{
			var x = cx + radius * Math.cos(deg * Math.PI / 180.0) - 72 / 2.0;
			var y = cy + radius * Math.sin(deg * Math.PI / 180.0) - 72 / 2.0;
			buckets.push(new ColorBucket(x, y, normalizeH(deg + randomShift * angleDelta)));
			deg += angleDelta;
		}
	}

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

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
