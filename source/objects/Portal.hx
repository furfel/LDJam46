package objects;

import Math;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class Portal extends FlxSprite
{
	public static function CreateFromObject(o:TiledObject):Portal
	{
		return new Portal(o.x, o.y);
	}

	private var portalHolder:PortalHolder;
	private var crystals:FlxTypedGroup<Crystal>;

	private static final ANGLE_SPEED = 45.0;
	private static final ALPHA_SPEED_RAD = 1.2;
	private static final CENTER_ALPHA = 0.75; // The amount in the center of sin()
	private static final DELTA_ALPHA = 0.15; // The amount that we can move with the sin()
	private static final MIN_SATURATION = 0.5; // The minimal saturation we can have
	private static final DELTA_SATURATION = 0.4; // The maximal addition for the saturation
	private static final WEIGHT_NORMALIZATION = 4.5; // I don't know maths behind this :|

	private var alphaRadiansSin = 0.0;
	private var hue:Float = 0;
	private var activated:Bool = false;

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
		if (!activated)
		{
			alpha = 0;
			return;
		}

		angle += elapsed * ANGLE_SPEED;
		if (angle >= 360)
			angle -= 360;
		hue += ANGLE_SPEED * elapsed;
		if (hue >= 360)
			hue -= 360;
		color = FlxColor.fromHSL(hue, 0.75, 0.75);

		alphaRadiansSin += ALPHA_SPEED_RAD * elapsed;
		alpha = CENTER_ALPHA + Math.sin(alphaRadiansSin) * DELTA_ALPHA;
	}

	public function activate(crystals:FlxTypedGroup<Crystal>)
	{
		this.crystals = crystals;
		activated = true;
	}

	function getCurrentSaturation():Float
	{
		if (crystals != null) {}
		return MIN_SATURATION;
	}

	private inline function hueWeight(hue:Float, crystal:Crystal)
	{
		return (360.0 - Math.abs(crystal.getTargetHue() - hue)) / 360.0;
	}
}
