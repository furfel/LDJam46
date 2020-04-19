package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledObject;
import flixel.input.FlxKeyManager;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	public static final SQRT2 = Math.sqrt(2.0);

	public static function CreateFromObject(o:TiledObject):Player
	{
		return new Player(o.x, o.y);
	}

	private var centralPoint:FlxPoint = new FlxPoint(0, 0);

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/player.png", true, 27, 33);
		animation.add("md", [0, 1, 0, 2], 10);
		animation.add("sd", [0], 2);
		animation.add("ml", [3, 4, 3, 5], 10);
		animation.add("sl", [3], 2);
		animation.add("mr", [6, 7, 6, 8], 10);
		animation.add("sr", [6], 2);
		animation.add("mu", [9, 10, 9, 11], 10);
		animation.add("su", [9], 2);
		animation.play("sd");
		centralPoint.set(X + 27 / 2, Y + 33 / 2);
	}

	private var directionangle = 0.0;

	private function getDirection(point:FlxPoint):Float
	{
		var cpoint = new FlxPoint(this.x + this.width / 2.0, this.y + this.height / 2.0);
		var dist = cpoint.distanceTo(point);
		if (dist <= 0.05)
			return directionangle;
		var relpoint = point.subtractPoint(cpoint);
		return Math.atan2(relpoint.y, relpoint.x) * (180 / Math.PI);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var point = FlxG.mouse.getWorldPosition();
		directionangle = getDirection(point);
		getKeys();
		move();
		centralPoint.set(x + 27 / 2, y + 33 / 2);
	}

	private function animate(motion:Bool)
	{
		var an:String = "s";
		if (motion)
			an = "m";
		var dir = directionangle;

		// Normalization
		while (dir < 0.0)
			dir += 360.0;
		while (dir > 360.0)
			dir -= 360.0;

		if (dir >= 0.0 && dir <= 45.0)
			an += "r";
		else if (dir > 45.0 && dir <= 135.0)
			an += "d";
		else if (dir > 135.0 && dir <= 135.0 + 90.0)
			an += "l";
		else if (dir > 135.0 + 90.0 && dir <= 135.0 + 180.0)
			an += "u";
		else
			an += "r";
		animation.play(an);
	}

	private function move()
	{
		velocity.set(0, 0);

		var velx:Float = 0;
		var vely:Float = 0;

		if (up)
		{
			velx = 200;
		}
		else if (down)
		{
			velx = -200;
		}

		if (left)
		{
			vely = -200;
		}
		else if (right)
		{
			vely = 200;
		}

		if (up || down || left || right)
		{
			if ((velx > 1.0 || velx < -1.0) && (vely > 1.0 || vely < -1.0))
			{
				velx /= SQRT2;
				vely /= SQRT2;
			}
			velocity.set(velx, vely);
			animate(true);
		}
		else
		{
			animate(false);
		}

		velocity.rotate(FlxPoint.weak(0, 0), directionangle);
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
	}

	private inline function press(?key:flixel.input.keyboard.FlxKey, ?keys:Array<flixel.input.keyboard.FlxKey>):Bool
	{
		return if (key != null) FlxG.keys.anyPressed([key]); else if (keys != null) FlxG.keys.anyPressed(keys); else false;
	}

	public function getCentralPoint():FlxPoint
	{
		return centralPoint;
	}
}
