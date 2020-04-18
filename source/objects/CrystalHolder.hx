package objects;

import flixel.FlxSprite;

class CrystalHolder extends FlxSprite
{
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
	}
}
