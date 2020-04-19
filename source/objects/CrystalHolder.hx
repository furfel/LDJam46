package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;

class CrystalHolder extends FlxSprite
{
	private var originalColor:FlxColor;

	public function new(crystal:Crystal)
	{
		super(crystal.x, crystal.y);
		loadGraphic("assets/images/crystalholder.png", 72, 72);
		setSize(72 - 32, 72 - 32);
		offset.set(28, 28);
		x += 16;
		y += 16;
		solid = true;
		immovable = true;
		this.originalColor = color;
	}

	private var tweenAnimation:FlxTween = null;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (tweenAnimation == null && FlxG.mouse.getWorldPosition().inCoords(this.x, this.y, this.width, this.height))
		{
			tweenAnimation = FlxTween.color(this, 0.33, FlxColor.fromRGB(220, 220, 170), FlxColor.fromRGB(220, 170, 170),
				{ease: FlxEase.circIn, type: PINGPONG});
			trace("Tween started");
		}
		else if (tweenAnimation != null && !FlxG.mouse.getWorldPosition().inCoords(this.x, this.y, this.width, this.height))
		{
			tweenAnimation.cancel();
			color = originalColor;
			alpha = 1;
			tweenAnimation = null;
			trace("Tween canceled");
		}
	}
}
