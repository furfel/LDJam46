package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.debug.console.ConsoleUtil;
import objects.*;

class PlayState extends FlxState
{
	private var player:Player;
	private var portal:Portal;
	private var portalHolder:PortalHolder;

	public var collisions:FlxTypedGroup<FlxObject> = new FlxTypedGroup<FlxObject>(1000);

	override public function create()
	{
		super.create();
		new map.Map(this);
		add(collisions);
	}

	public function setPlayer(player:Player)
	{
		add(this.player = player);
		this.player.allowCollisions = FlxObject.ANY;
		FlxG.camera.follow(player);
	}

	public function setPortal(portal:Portal)
	{
		add(this.portal = portal);
		add(this.portal.getPortalHolder());
	}

	public function addCollision(object:FlxObject)
	{
		object.solid = true;
		object.immovable = true;
		collisions.add(object);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, collisions);
	}
}
