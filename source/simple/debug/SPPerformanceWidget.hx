package simple.debug;

import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class SPPerformanceWidget extends TextField
{
	private var times: Array<Float>;
	private var memPeak: Float = 0;

	public function new(inX: Float = 10.0, inY: Float = 10.0, inColor: Int = 0x000000) 
	{
		super();

		this.mouseEnabled = false;

		this.x = inX;
		this.y = inY;

		this.selectable = false;

		this.defaultTextFormat = new TextFormat("_sans", 12, inColor);

		this.text = "FPS: ";

		this.times = [];

		this.addEventListener(Event.ENTER_FRAME, onEnter);

		this.width = 150;
		this.height = 70;
	}

	private function onEnter(_)
	{	
		var now = Timer.stamp();

		this.times.push(now);

		while(times[0] < now - 1)
			this.times.shift();

		var mem: Float = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;

		if (mem > this.memPeak)
            memPeak = mem;

		if(visible)
			this.text = "FPS: " + this.times.length + "\nMEM: " + mem + " MB\nMEM peak: " + this.memPeak + " MB";	
	}
}