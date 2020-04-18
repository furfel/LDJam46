package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.system.debug.console.ConsoleUtil;
import objects.*;

class PlayState extends FlxState
{
	private var player:Player;
	private var portal:Portal;
	private var portalHolder:PortalHolder;

	override public function create()
	{
		super.create();
		add(player = new Player(20, 20));
		add(portal = new Portal(100, 100));
		add(portalHolder = new PortalHolder(100, 100));
		FlxG.camera.follow(player);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
