package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;

class CrystalHolder extends FlxSprite
{
	public static final MIN_DISTANCE = 128.0;

	private var originalColor:FlxColor;
	private var crystal:Crystal;

	private var centralPoint:FlxPoint = new FlxPoint(-10000, -10000);

	public function new(crystal:Crystal)
	{
		super(crystal.x, crystal.y);
		centralPoint.set(crystal.x + 72 / 2, crystal.y + 72 / 2);
		loadGraphic("assets/images/crystalholder.png", 72, 72);
		setSize(72 - 32, 72 - 32);
		offset.set(28, 28);
		x += 16;
		y += 16;
		solid = true;
		immovable = true;
		this.originalColor = color;
		this.crystal = crystal;
	}

	private var tweenAnimation:FlxTween = null;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (tweenAnimation == null && inCoords())
		{
			tweenAnimation = FlxTween.color(this, 0.33, FlxColor.fromRGB(220, 220, 170), FlxColor.fromRGB(220, 170, 170),
				{ease: FlxEase.circIn, type: PINGPONG});
		}
		else if (tweenAnimation != null && !inCoords())
		{
			tweenAnimation.cancel();
			color = originalColor;
			alpha = 1;
			tweenAnimation = null;
		}
	}

	private function inCoords():Bool
	{
		return FlxG.mouse.getWorldPosition().inCoords(this.x, this.y, this.width, this.height);
	}

	public function checkCrystalClicked(player:Player):Bool
	{
		return inCoords() && centralPoint.distanceTo(player.getCentralPoint()) < MIN_DISTANCE;
	}

	public function getCrystal():Crystal
	{
		return crystal;
	}
}
