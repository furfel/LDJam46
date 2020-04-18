package objects;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Fireball extends FlxSprite
{
	public function new(X:Float, Y:Float, direction:Int, type:FireballType)
	{
		super(X, Y);
		loadGraphic("assets/images/fireball.png", true, 16, 16);

		setFacingFlip(FlxObject.DOWN, false, false);
		setFacingFlip(FlxObject.UP, false, true);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		animation.add("sh", [0, 1]);
		animation.add("sv", [2, 3]);
		animation.add("mh", [4, 5]);
		animation.add("mv", [6, 7]);
		animation.add("lh", [8, 9]);
		animation.add("lv", [10, 11]);

		facing = direction;

		var anim = "";
		if (type == SMALL)
			anim = "s";
		else if (type == MEDIUM)
			anim = "m";
		else if (type == LARGE)
			anim = "l";

		if (facing == FlxObject.UP || facing == FlxObject.DOWN)
			anim += "v";
		else if (facing == FlxObject.LEFT || facing == FlxObject.RIGHT)
			anim += "h";

		velocity.set(300, 0);

		if (facing == FlxObject.UP)
			velocity.rotate(FlxPoint.weak(0, 0), -90);
		else if (facing == FlxObject.DOWN)
			velocity.rotate(FlxPoint.weak(0, 0), 90);
		else if (facing == FlxObject.LEFT)
			velocity.rotate(FlxPoint.weak(0, 0), 180);
		else
			velocity.rotate(FlxPoint.weak(0, 0), 0);
	}
}

enum FireballType
{
	SMALL;
	MEDIUM;
	LARGE;
}
