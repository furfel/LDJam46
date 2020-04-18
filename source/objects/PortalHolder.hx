package objects;

import flixel.FlxSprite;

class PortalHolder extends FlxSprite
{
	public function new(X:Float, Y:Float)
	{
		super(X, Y);
		loadGraphic("assets/images/portalholder.png", false, 256, 256);
	}
}
