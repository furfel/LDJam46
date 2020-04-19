package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.chainable.FlxRainbowEffect;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.TransitionFade;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.debug.console.ConsoleUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
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
	private var timer:tools.Timer;
	private var targetTime:Float;

	public var collisions:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>(1000);

	override public function new(time:Int, bucketsCount:Int)
	{
		super();
		targetTime = time;
		bucketsAmount = bucketsCount;
	}

	override public function create()
	{
		super.create();
		new map.Map(this);
		add(collisions);

		add(hud = new HUD());
		add(timer = new tools.Timer());
		add(message = new tools.Message());
		message.showMessage("First, fill the crystals to activate the portal.");
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
			message.showMessage("Portal is now activated. Keep it alive by refilling crystals with proper colors!");
			stage2 = true;
		}
	}

	private var gameOver = false;
	private var gameOverCountdown = 5.0;

	private function updateStage2(elapsed:Float)
	{
		if (!stage2 || gameOver || winned)
			return;

		targetTime -= elapsed;
		timer.updateTime(Math.ceil(targetTime));
		if (targetTime <= 0.0)
		{
			winGame();
		}

		if (portal.checkDeath())
		{
			message.showMessage("The portal died :(.");
			gameOver = true;
			player.kill();
		}
	}

	private var winned:Bool = false;

	private function winGame()
	{
		var ivee = new FlxSprite(portal.getMidpoint().x - 192 / 2, portal.getMidpoint().y - 192 / 2);
		ivee.loadGraphic("assets/images/ivee.png", false, 192, 192);
		ivee.alpha = 0;
		ivee.scale.x = 0.75;
		ivee.scale.y = 0.75;
		add(ivee);
		FlxTween.tween(ivee, {alpha: 0.75, "scale.x": 1, "scale.y": 1}, 5.0, {ease: FlxEase.cubeIn, type: ONESHOT, onComplete: postIvee});
		winned = true;
		player.lock();
	}

	private function postIvee(tw:FlxTween)
	{
		message.showMessage("Thank you for saving me oh dear!");
		var overlay = new FlxSprite(0, 0);
		overlay.scrollFactor.set(0, 0);
		overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		overlay.alpha = 0;
		add(overlay);
		FlxTween.tween(overlay, {alpha: 1}, 3.0, {
			ease: FlxEase.backIn,
			type: ONESHOT,
			onComplete: tw ->
			{
				FlxG.switchState(new MenuState());
			}
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		updateStage2(elapsed);

		if (gameOver)
		{
			gameOverCountdown -= elapsed;
			if (gameOverCountdown <= 0.0)
				FlxG.switchState(new MenuState());
			FlxG.camera.follow(null);
			return;
		}
		else if (winned)
		{
			FlxG.camera.follow(null);
			FlxG.camera.focusOn(portal.getMidpoint());
			return;
		}

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
						FlxG.sound.play("assets/sounds/takewater.ogg");
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
}
