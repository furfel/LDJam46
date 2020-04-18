package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.input.FlxKeyManager;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic(AssetPaths.player__png, true, 32, 32);
		animation.add("d", [1]);
		animation.add("l", [4]);
		animation.add("r", [7]);
		animation.add("u", [10]);
		animation.add("md", [0, 1, 2, 1]);
		animation.add("ml", [3, 4, 5, 4]);
		animation.add("mr", [6, 7, 8, 7]);
		animation.add("mu", [9, 10, 11, 10]);
		animation.play("d");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		getKeys();
		move();
	}

	private function animate(motion:Bool)
	{
		var an:String = "";
		if (motion)
			an = "m";

		if (facing == FlxObject.UP)
			an += "u";
		else if (facing == FlxObject.DOWN)
			an += "d";
		else if (facing == FlxObject.LEFT)
			an += "l";
		else if (facing == FlxObject.RIGHT)
			an += "r";
		animation.play(an);
	}

	private function move()
	{
		velocity.set(0, 0);

		var angle:Float = 0;

		if (up)
		{
			angle = -90;
			facing = FlxObject.UP;
		}
		else if (down)
		{
			angle = 90;
			facing = FlxObject.DOWN;
		}
		else if (left)
		{
			angle = 180;
			facing = FlxObject.LEFT;
		}
		else if (right)
		{
			angle = 0;
			facing = FlxObject.RIGHT;
		}

		if (up || down || left || right)
		{
			velocity.set(200, 0);
			animate(true);
		}
		else
		{
			animate(false);
		}

		velocity.rotate(FlxPoint.weak(0, 0), angle);
	}

	private var up:Bool;
	private var down:Bool;
	private var left:Bool;
	private var right:Bool;

	private function getKeys()
	{
		up = press(FlxKey.W);
		down = press(FlxKey.S);
		left = press(FlxKey.A);
		right = press(FlxKey.D);
		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;
	}

	private inline function press(?key:flixel.input.keyboard.FlxKey, ?keys:Array<flixel.input.keyboard.FlxKey>):Bool
	{
		return if (key != null) FlxG.keys.anyPressed([key]); else if (keys != null) FlxG.keys.anyPressed(keys); else false;
	}
}
