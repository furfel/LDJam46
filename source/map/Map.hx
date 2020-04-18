package map;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.editors.tiled.*;
import flixel.addons.tile.FlxTilemapExt;
import objects.Player;
import objects.Portal;

class Map
{
	private var map:TiledMap;
	private var objects:TiledObjectLayer;
	private var tiles:TiledTileLayer;
	private var decors:TiledTileLayer;

	public function new(state:PlayState)
	{
		map = new TiledMap("assets/data/map1.tmx");
		FlxG.worldBounds.set(0, 0, map.fullWidth, map.fullHeight);
		objects = cast map.getLayer("objects");

		tiles = cast map.getLayer("tiles");
		var tilesExt = new FlxTilemapExt();
		tilesExt.loadMapFromArray(tiles.tileArray, map.width, map.height, "assets/images/sprites.png", 32, 32, OFF, 1, 0);
		state.add(tilesExt);
		decors = cast map.getLayer("decors");
		var decorsExt = new FlxTilemapExt();
		decorsExt.loadMapFromArray(tiles.tileArray, map.width, map.height, "assets/images/sprites.png", 32, 32, OFF, 1, 0);
		state.add(decorsExt);

		for (o in objects.objects)
		{
			if (o.type == "player")
				state.setPlayer(Player.CreateFromObject(o));
			else if (o.type == "portal")
				state.setPortal(Portal.CreateFromObject(o));
			else if (o.type == "portal_collide")
				state.addCollision(new FlxObject(o.x, o.y, o.width, o.height));
		}
	}
}
