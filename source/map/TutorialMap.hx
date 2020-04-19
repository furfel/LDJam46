package map;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.editors.tiled.*;
import flixel.addons.tile.FlxTilemapExt;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRandom;
import objects.ColorBucket;
import objects.Crystal;
import objects.CrystalHolder;
import objects.CrystalTargetPointer;
import objects.Player;
import objects.Portal;

class TutorialMap
{
	private var map:TiledMap;
	private var objects:TiledObjectLayer;
	private var tiles:TiledTileLayer;
	private var decors:TiledTileLayer;

	public function new(state:TutorialState)
	{
		map = new TiledMap("assets/data/mapt.tmx");
		FlxG.worldBounds.set(0, 0, map.fullWidth, map.fullHeight);
		objects = cast map.getLayer("objects");

		tiles = cast map.getLayer("tiles");
		var tilesExt = new FlxTilemapExt();
		tilesExt.loadMapFromArray(tiles.tileArray, map.width, map.height, "assets/images/sprites.png", 32, 32, OFF, 1, 0);
		state.add(tilesExt);

		var buckets = new FlxTypedGroup<ColorBucket>(2);
		state.add(buckets);

		for (o in objects.objects)
		{
			if (o.type == "player")
				state.setPlayer(Player.CreateFromObject(o));
			else if (o.type == "portal_collide")
				state.addCollision(new FlxObject(o.x, o.y, o.width, o.height));
			else if (o.type == "bucket1")
				buckets.add(new ColorBucket(o.x, o.y, 270.0));
			else if (o.type == "bucket2")
				buckets.add(new ColorBucket(o.x, o.y, 180.0));
			else if (o.type == "crystal")
			{
				var tp:CrystalTargetPointer = new CrystalTargetPointer(o.x, o.y - 64.0, (180.0 + 270.0) / 2.0, 270.0);
				var cr:Crystal = new Crystal(o.x, o.y + 20.0, (270.0 + 180.0) / 2.0, tp);
				state.add(tp);
				state.addCrystal(cr, new CrystalHolder(cr));
			}
		}
	}
}
