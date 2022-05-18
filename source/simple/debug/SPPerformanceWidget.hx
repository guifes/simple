package simple.debug;

import haxe.Timer;
import haxe.ui.components.Label;
import haxe.ui.containers.VBox;
import haxe.ui.macros.ComponentMacros;
import openfl.events.Event;
import openfl.system.System;

class SPPerformanceWidget extends SPDebugWidget
{
	private static inline var DEFAULT_WIDTH: Float = 110;
	private static inline var NAME:String = "Performance";

	private var times: Array<Float>;
	private var memPeak: Float = 0;
	private var fpsLabel: Label;
	private var memLabel: Label;
	private var memPeakLabel: Label;

	public function new(inX: Float = 10.0, inY: Float = 10.0) 
	{
		super(NAME);

		this.width = DEFAULT_WIDTH;
		
		this.times = [];
		
		this.addEventListener(Event.ENTER_FRAME, onEnter);

		var root = ComponentMacros.buildComponent("simple/debug/xml/performance.xml");

		fpsLabel = root.findComponent("fpsLabel", Label, true, "id");
		memLabel = root.findComponent("memLabel", Label, true, "id");
		memPeakLabel = root.findComponent("memPeakLabel", Label, true, "id");
		
		// this.containerBox.styleString = 'min-width: ${DEFAULT_WIDTH}px;';
		this.containerBox.addComponent(root);
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
		{
			this.fpsLabel.text = 'FPS: ${this.times.length}';
			this.memLabel.text = 'MEM: ${mem} MB';
			this.memPeakLabel.text = 'MEM peak: ${this.memPeak} MB';
		}
	}

	public override function onDestroy()
	{
		super.onDestroy();
		
		this.removeEventListener(Event.ENTER_FRAME, onEnter);
	}
}