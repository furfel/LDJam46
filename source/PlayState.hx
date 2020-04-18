package;

import flixel.FlxG;
import flixel.FlxState;
import objects.Player;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();
		add(new Player(20, 20));
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
