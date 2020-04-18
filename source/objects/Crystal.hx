package objects;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class Crystal extends FlxSprite
{
	public static final TARGET_POINTER_DISTANCE = 72.0;
	public static final DEFAULT_SATURATION = 0.75;
	public static final DEFAULT_LIGHTNESS = 0.6;

	public static function CreateCrystalsOnPortal(portal:Portal):Array<Crystal>
	{
		var radius = portal.width / 2.0 + 6.0;
		var cx = portal.x + portal.width / 2.0;
		var cy = portal.y + portal.height / 2.0;
		var deg = -90.0;

		var crystals = new Array<Crystal>();

		while (deg < 260)
		{
			var x = cx + radius * Math.cos(deg * Math.PI / 180.0) - 72 / 2.0;
			var y = cy + radius * Math.sin(deg * Math.PI / 180.0) - 72 / 2.0;
			var tx = cx + (radius + TARGET_POINTER_DISTANCE) * Math.cos(deg * Math.PI / 180.0) - 64 / 2.0;
			var ty = cy + (radius + TARGET_POINTER_DISTANCE) * Math.sin(deg * Math.PI / 180.0) - 64 / 2.0;
			var tp = new CrystalTargetPointer(tx, ty, deg + 90, deg);
			crystals.push(new Crystal(x, y, deg + 90.0, tp));
			deg += 60;
		}

		return crystals;
	}

	private var targetPointer:CrystalTargetPointer;

	private var targetHue:Float;

	public function new(X:Float, Y:Float, targetHue:Float, ?targetPointer:CrystalTargetPointer)
	{
		super(X, Y);
		this.targetHue = targetHue;
		loadGraphic("assets/images/crystal.png", false, 72, 72);
		color = FlxColor.fromHSL(targetHue, DEFAULT_SATURATION, DEFAULT_LIGHTNESS);
		this.targetPointer = targetPointer;
	}

	public function getTargetHue():Float
	{
		return targetHue;
	}

	public function getTargetPointer():CrystalTargetPointer
	{
		return targetPointer;
	}
}
