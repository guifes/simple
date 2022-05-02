package simple.debug;

import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class SPPerformanceWidget2 extends SPDebugWidget2
{
	private static inline var DEFAULT_WIDTH: Float = 150;
	private static inline var DEFAULT_HEIGHT: Float = 70;

	private var textField: TextField;
	private var times: Array<Float>;
	private var memPeak: Float = 0;

	public function new(inX: Float = 10.0, inY: Float = 10.0) 
	{
		super("Performance", inX, inY, DEFAULT_WIDTH, DEFAULT_HEIGHT);

		this.textField = new TextField();
		this.textField.width = DEFAULT_WIDTH;
		this.textField.height = DEFAULT_HEIGHT;
		this.textField.mouseEnabled = false;
		this.textField.selectable = false;
		this.textField.defaultTextFormat = new TextFormat("_sans", 12, SPColor.WHITE);
		this.textField.text = "FPS: ";

		this._contentView.addChild(this.textField);
		
		this.times = [];
		
		this.addEventListener(Event.ENTER_FRAME, onEnter);
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
			this.textField.text = "FPS: " + this.times.length + "\nMEM: " + mem + " MB\nMEM peak: " + this.memPeak + " MB";	
	}
}