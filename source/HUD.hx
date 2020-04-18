package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import tools.BottleWithFluid;

class HUD extends FlxTypedGroup<BottleWithFluid>
{
	public var leftBottle:BottleWithFluid;
	public var rightBottle:BottleWithFluid;

	public function new()
	{
		super();
		add(leftBottle = new BottleWithFluid(64, FlxG.height - 96, false));
		add(rightBottle = new BottleWithFluid(FlxG.width - 128 - 64, FlxG.height - 96, true));
	}
}
