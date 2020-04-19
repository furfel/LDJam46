package tools;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class BottleWithFluid extends FlxTypedGroup<FlxSprite>
{
	public var fluid:FlxSprite;
	public var bottle:FlxSprite;

	private var hue:Float = -1.0;

	public function new(X:Float, Y:Float, flip:Bool)
	{
		super();
		add(fluid = new FlxSprite(X + 24, Y + 64));
		fluid.loadGraphic("assets/images/bottlefluid.png", true, 80, 48);
		fluid.animation.add("move", [0, 1, 2, 3, 4, 5, 6, 7], 15);
		fluid.animation.play("move");
		fluid.flipX = flip;
		fluid.alpha = 0;
		// fluid.angle = flip ? -30 : 30;
		add(bottle = new FlxSprite(X, Y));
		bottle.loadGraphic("assets/images/bottle.png", false, 128, 128);
		// bottle.angle = flip ? -30 : 30;
		bottle.flipX = flip;
		forEach(sprite -> sprite.scrollFactor.set(0, 0));
		originX = X;
		originY = Y;
	}

	private var newColor:Float;

	public function setColor(hue:Float)
	{
		if (!locked)
		{
			newColor = hue;
			newAlpha = 1;
			animate1();
		}
	}

	private var originX = 0.0;
	private var originY = 0.0;
	private var locked:Bool = false;

	public function mixWith(hue:Float)
	{
		if (!locked && hue >= 0.0 && this.hue >= 0.0)
		{
			var colorset = (this.hue + hue) / 2.0;
			if (Math.abs(this.hue - hue) > 180.0)
			{
				colorset = 180.0 - colorset;
				if (colorset < 0.0)
					colorset += 360.0;
				setColor(colorset);
			}
			else
				setColor(colorset);
			trace("Mixing " + hue + " + " + this.hue + " = " + newColor);
		}
	}

	private function animate1()
	{
		if (locked)
			return;
		locked = true;
		FlxTween.linearMotion(fluid, fluid.x, fluid.y, fluid.x, FlxG.height + 32.0 + 64.0, 1.0, true, {ease: FlxEase.backIn, type: ONESHOT});
		FlxTween.linearMotion(bottle, bottle.x, bottle.y, bottle.x, FlxG.height + 32.0, 1.0, true, {
			ease: FlxEase.backIn,
			type: ONESHOT,
			onComplete: animate2
		});
	}

	private function animate2(tween:FlxTween)
	{
		hue = newColor;
		fluid.color = FlxColor.fromHSL(hue, 0.8, 0.8);
		fluid.alpha = newAlpha;
		FlxTween.linearMotion(fluid, fluid.x, fluid.y, fluid.x, originY + 64.0, 1.0, true, {ease: FlxEase.backIn, type: ONESHOT});
		FlxTween.linearMotion(bottle, bottle.x, bottle.y, bottle.x, originY, true, {ease: FlxEase.backIn, onComplete: animate3, type: ONESHOT});
	}

	private var newAlpha = 0.0;

	private function animate3(tween:FlxTween)
	{
		locked = false;
	}

	public function dumpHue(targetHue:Float):Float
	{
		if (!locked && hue >= 0.0 && targetHue >= 0.0)
		{
			var oldhue = hue;
			this.newColor = -1.0;
			newAlpha = 0;
			animate1();
			return oldhue;
		}
		return -1.0;
	}

	public function getHue():Float
	{
		return hue;
	}

	public function isLocked():Bool
	{
		return locked;
	}
}
