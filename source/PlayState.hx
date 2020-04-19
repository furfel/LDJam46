package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.debug.console.ConsoleUtil;
import objects.*;

class PlayState extends FlxState
{
	private var bucketsAmount:Int = 6;

	private var player:Player;
	private var portal:Portal;
	private var portalHolder:PortalHolder;
	private var crystals:FlxTypedGroup<Crystal>;
	private var crystalHolders:FlxTypedGroup<CrystalHolder>;
	private var crystalPointers:FlxTypedGroup<CrystalTargetPointer>;
	private var colorBuckets:FlxTypedGroup<ColorBucket>;

	private var hud:HUD;
	private var message:tools.Message;

	public var collisions:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>(1000);

	override public function create()
	{
		super.create();
		new map.Map(this);
		add(collisions);

		add(hud = new HUD());
		add(message = new tools.Message());
		message.showMessage("Welcome!");
	}

	public function setPlayer(player:Player)
	{
		add(this.player = player);
		this.player.allowCollisions = FlxObject.ANY;
		FlxG.camera.follow(player);
	}

	public function setPortal(portal:Portal)
	{
		add(this.portal = portal);
		add(this.portal.getPortalHolder());

		add(this.crystals = new FlxTypedGroup<Crystal>(6));
		for (c in Crystal.CreateCrystalsOnPortal(this.portal))
			this.crystals.add(c);

		add(this.crystalHolders = new FlxTypedGroup<CrystalHolder>(6));
		this.crystals.forEach((crystal) ->
		{
			crystalHolders.add(new CrystalHolder(crystal));
		});

		add(this.crystalPointers = new FlxTypedGroup<CrystalTargetPointer>(6));
		this.crystals.forEach((crystal) ->
		{
			crystalPointers.add(crystal.getTargetPointer());
		});

		add(this.colorBuckets = new FlxTypedGroup<ColorBucket>(bucketsAmount));
		for (b in ColorBucket.createBuckets(bucketsAmount, this.portal))
		{
			this.colorBuckets.add(b);
		}
	}

	public function addCollision(object:FlxObject)
	{
		object.solid = true;
		object.immovable = true;
		collisions.add(object);
	}

	private var stage2:Bool = false;

	private function checkPortalActivation()
	{
		if (portal.activate(crystals))
		{
			message.showMessage("Portal is now activated.\nKeep it alive by refilling crystals!");
			stage2 = true;
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, collisions);
		FlxG.collide(player, crystalHolders);
		FlxG.collide(player, colorBuckets);

		if (!(FlxG.mouse.pressed && FlxG.mouse.pressedRight))
		{
			if (FlxG.mouse.pressed && hud.leftBottle.getHue() >= 0.0 && !hud.leftBottle.isLocked())
				crystalHolders.forEach(holder ->
				{
					if (holder.checkCrystalClicked(player))
					{
						holder.getCrystal().setColor(hud.leftBottle.dumpHue(1.0));
						checkPortalActivation();
					}
				});
			else if (FlxG.mouse.pressedRight && hud.rightBottle.getHue() >= 0.0 && !hud.rightBottle.isLocked())
				crystalHolders.forEach(holder ->
				{
					if (holder.checkCrystalClicked(player))
					{
						holder.getCrystal().setColor(hud.rightBottle.dumpHue(1.0));
						checkPortalActivation();
					}
				});

			if (FlxG.mouse.pressed && hud.leftBottle.getHue() < 0.0 && !hud.leftBottle.isLocked())
			{
				colorBuckets.forEach(bucket ->
				{
					if (bucket.checkClicked(player))
					{
						hud.leftBottle.setColor(bucket.getHue());
					}
				});
			}
			else if (FlxG.mouse.pressedRight && hud.rightBottle.getHue() < 0.0 && !hud.rightBottle.isLocked())
			{
				colorBuckets.forEach(bucket ->
				{
					if (bucket.checkClicked(player))
					{
						hud.rightBottle.setColor(bucket.getHue());
					}
				});
			}
		}

		if (FlxG.keys.anyPressed([Q]))
			hud.leftBottle.mixWith(hud.rightBottle.dumpHue(hud.leftBottle.getHue()));
		else if (FlxG.keys.anyPressed([E]))
			hud.rightBottle.mixWith(hud.leftBottle.dumpHue(hud.rightBottle.getHue()));
	}
}
