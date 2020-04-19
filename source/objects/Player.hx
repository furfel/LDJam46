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

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/playerrot.png", true, 32, 32);
		animation.add("m", [0, 1, 0, 2], 10);
		animation.add("s", [0], 2);
		animation.play("s");
		angle = 0;
	}

	private function getDirection(point:FlxPoint):Float
	{
		var cpoint = new FlxPoint(this.x + this.width / 2.0, this.y + this.height / 2.0);
		var dist = cpoint.distanceTo(point);
		if (dist <= 0.05)
			return angle;
		var relpoint = point.subtractPoint(cpoint);
		return Math.atan2(relpoint.y, relpoint.x) * (180 / Math.PI);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var point = FlxG.mouse.getWorldPosition();
		angle = getDirection(point);
		getKeys();
		move();
	}

	private function animate(motion:Bool)
	{
		var an:String = "s";
		if (motion)
			an = "m";
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
	}

	private inline function press(?key:flixel.input.keyboard.FlxKey, ?keys:Array<flixel.input.keyboard.FlxKey>):Bool
	{
		return if (key != null) FlxG.keys.anyPressed([key]); else if (keys != null) FlxG.keys.anyPressed(keys); else false;
	}
}
