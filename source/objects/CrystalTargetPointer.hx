package objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class CrystalTargetPointer extends FlxSprite
{
	public function new(X:Float, Y:Float, color:Float, rotation:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/target.png", 64, 64);
		this.color = FlxColor.fromHSL(color, Crystal.DEFAULT_SATURATION, Crystal.DEFAULT_LIGHTNESS);
		this.angle = rotation;
	}
}
