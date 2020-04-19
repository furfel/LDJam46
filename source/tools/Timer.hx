package tools;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Timer extends FlxTypedGroup<FlxSprite>
{
	private var box = new FlxSprite(0, 0);
	private var text:FlxText;

	public function new()
	{
		super();

		box.makeGraphic(256, 64, FlxColor.fromRGB(0, 0, 80));
		box.screenCenter(X);

		add(box);
		add(text = new FlxText(box.x + 8, box.y + 8, box.width - 16, "OFF", 32));
		text.alignment = CENTER;

		forEach(s -> s.scrollFactor.set(0, 0));
	}

	public function updateTime(s:Int)
	{
		var st = "";
		var m = Math.floor(s / 60);

		if (m < 10)
			st = "0" + m;
		else
			st = "" + m;
		st += (s % 2 == 0) ? ":" : " ";
		var sc = Math.ceil(s % 60);
		if (sc < 10)
			st += "0" + sc;
		else
			st += "" + sc;

		text.text = st;
	}
}
