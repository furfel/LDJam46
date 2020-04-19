package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class HUD2 extends FlxTypedGroup<FlxSprite>
{
	public function new()
	{
		super();

		forEach(sprite -> sprite.scrollFactor.set(0, 0));
	}
}
