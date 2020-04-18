package objects;

import Math;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.util.FlxColor;

class Portal extends FlxSprite
{
	public static function CreateFromObject(o:TiledObject):Portal
	{
		return new Portal(o.x, o.y);
	}

	private var portalHolder:PortalHolder;
	private var waveEffect:FlxWaveEffect;

	private static final AngleSpeed = 45.0;
	private static final AlphaSpeedRadians = 1.2;
	private static final CenterAlpha = 0.75; // The amount in the center of sin()
	private static final DeltaAlpha = 0.15; // The amount that we can move with the sin()

	private var alphaRadiansSin = 0.0;
	private var hue:Float = 0;

	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/portal.png", false, 256, 256);
		portalHolder = new PortalHolder(X, Y);
	}

	public function getPortalHolder():PortalHolder
	{
		return portalHolder;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		angle += elapsed * AngleSpeed;
		if (angle >= 360)
			angle -= 360;
		hue += AngleSpeed * elapsed;
		if (hue >= 360)
			hue -= 360;
		color = FlxColor.fromHSL(hue, 0.75, 0.75);

		alphaRadiansSin += AlphaSpeedRadians * elapsed;
		alpha = CenterAlpha + Math.sin(alphaRadiansSin) * DeltaAlpha;
	}
}
