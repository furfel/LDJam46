package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;

class ColorBucket extends FlxTypedGroup<FlxSprite>
{
	public static final MIN_PLAYER_DISTANCE = 72.0;
	public static final BUCKETS_DISTANCE_RADIUS = 180.0;

	private static inline function normalizeH(h:Float)
	{
		return h % 360.0;
	}

	public static function createBuckets(amount:Int, portal:Portal):Array<ColorBucket>
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
			var x = cx + radius * Math.cos(deg * Math.PI / 180.0) - 84 / 2.0;
			var y = cy + radius * Math.sin(deg * Math.PI / 180.0) - (30 + 55) / 2.0;
			buckets.push(new ColorBucket(x, y, normalizeH(deg + randomShift * angleDelta)));
			deg += angleDelta;
		}

		return buckets;
	}

	private var fluid:FlxSprite;
	private var bucketback:FlxSprite;
	private var bucketfront:FlxSprite;

	private var originalColorBucketback:FlxColor;
	private var originalColorBucketfront:FlxColor;

	private var centralPoint = new FlxPoint(-100000, -100000);

	private var hue:Float = -1.0;

	public function new(X:Float, Y:Float, hue:Float)
	{
		super();
		this.hue = hue;
		add(bucketback = new FlxSprite(X, Y));
		bucketback.loadGraphic("assets/images/bucketback.png", false, 84, 48);
		bucketback.immovable = bucketback.solid = true;
		add(fluid = new FlxSprite(X + 3, Y + 6));
		fluid.loadGraphic("assets/images/boil.png", true, 78, 53);
		fluid.animation.add("boil", [0, 1, 2, 3, 4], 8);
		fluid.animation.play("boil");
		fluid.color = FlxColor.fromHSL(hue, 0.8, 0.7);
		fluid.immovable = fluid.solid = true;
		add(bucketfront = new FlxSprite(X, Y + 30));
		bucketfront.loadGraphic("assets/images/bucketfront.png", false, 84, 55);
		bucketfront.immovable = true;

		originalColorBucketback = bucketback.color;
		originalColorBucketfront = bucketfront.color;

		centralPoint.set(X + 84 / 2, Y + (30 + 55) / 2);
	}

	private var tweenAnimation:FlxTween = null;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (tweenAnimation == null && inCoords())
		{
			tweenAnimation = FlxTween.color(bucketback, 0.33, FlxColor.fromRGB(220, 220, 60), FlxColor.fromRGB(80, 80, 80),
				{ease: FlxEase.circIn, type: PINGPONG, onUpdate: moreTweens});
		}
		else if (tweenAnimation != null && !inCoords())
		{
			tweenAnimation.cancel();
			bucketback.color = originalColorBucketback;
			bucketback.alpha = 1;
			bucketfront.color = originalColorBucketfront;
			bucketfront.alpha = 1;
			tweenAnimation = null;
		}
	}

	private inline function inCoords():Bool
	{
		return FlxG.mouse.getWorldPosition().inCoords(bucketback.x, bucketback.y, bucketback.width, 30 + bucketfront.height);
	}

	private function moreTweens(tween:FlxTween)
	{
		bucketfront.color = cast(tween, ColorTween).color;
	}

	public function checkClicked(player:Player):Bool
	{
		return inCoords() && player.getCentralPoint().distanceTo(centralPoint) < MIN_PLAYER_DISTANCE;
	}

	public function getHue():Float
	{
		return hue;
	}
}
