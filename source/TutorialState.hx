package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import map.TutorialMap;
import objects.ColorBucket;
import objects.Crystal;
import objects.CrystalHolder;
import objects.Player;
import tools.TutorialMessage;

class TutorialState extends FlxState
{
	private var hud:HUD;
	private var tutorialMessage:TutorialMessage;
	private var player:Player;
	private var buckets:FlxTypedGroup<ColorBucket> = new FlxTypedGroup<ColorBucket>(2);
	private var crystal:Crystal;
	private var holder:CrystalHolder;

	public var collisions:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>(1000);

	override function create()
	{
		super.create();

		new TutorialMap(this);
		add(hud = new HUD());
		add(tutorialMessage = new TutorialMessage());
	}

	public function getBuckets():FlxTypedGroup<ColorBucket>
	{
		return buckets;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.collide(player, collisions);
		FlxG.collide(player, buckets);
		FlxG.collide(player, holder);

		if (!(FlxG.mouse.pressed && FlxG.mouse.pressedRight))
		{
			if (FlxG.mouse.pressed && hud.leftBottle.getHue() >= 0.0 && !hud.leftBottle.isLocked())
			{
				trace("Left bottle");
				if (holder.checkCrystalClicked(player))
				{
					holder.getCrystal().setColor(hud.leftBottle.dumpHue(1.0));
				}
			}
			else if (FlxG.mouse.pressedRight && hud.rightBottle.getHue() >= 0.0 && !hud.rightBottle.isLocked())
			{
				if (holder.checkCrystalClicked(player))
				{
					holder.getCrystal().setColor(hud.rightBottle.dumpHue(1.0));
				}
			}

			if (FlxG.mouse.pressed && hud.leftBottle.getHue() < 0.0 && !hud.leftBottle.isLocked())
			{
				buckets.forEach(bucket ->
				{
					if (bucket.checkClicked(player))
					{
						FlxG.sound.play("assets/sounds/takewater.ogg");
						hud.leftBottle.setColor(bucket.getHue());
					}
				});
			}
			else if (FlxG.mouse.pressedRight && hud.rightBottle.getHue() < 0.0 && !hud.rightBottle.isLocked())
			{
				buckets.forEach(bucket ->
				{
					if (bucket.checkClicked(player))
					{
						FlxG.sound.play("assets/sounds/takewater.ogg");
						hud.rightBottle.setColor(bucket.getHue());
					}
				});
			}
		}

		if (FlxG.keys.anyPressed([Q]))
			hud.leftBottle.mixWith(hud.rightBottle.dumpHue(hud.leftBottle.getHue()));
		else if (FlxG.keys.anyPressed([E]))
			hud.rightBottle.mixWith(hud.leftBottle.dumpHue(hud.rightBottle.getHue()));
		else if (FlxG.keys.anyPressed([Z]))
			hud.leftBottle.flushBottle();
		else if (FlxG.keys.anyPressed([X]))
			hud.rightBottle.flushBottle();
	}

	public function setPlayer(player:Player)
	{
		add(this.player = player);
		FlxG.camera.follow(player, TOPDOWN, 1);
	}

	public function addCollision(ob:FlxObject)
	{
		ob.immovable = true;
		ob.solid = true;
		collisions.add(ob);
	}

	public function addCrystal(c:Crystal, holder:CrystalHolder)
	{
		this.crystal = c;
		this.holder = holder;
		add(this.crystal);
		add(this.holder);
	}
}
