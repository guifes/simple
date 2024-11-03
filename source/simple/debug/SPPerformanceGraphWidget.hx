package simple.debug;

import guifes.math.MathUtil;
import haxe.Timer;
import haxe.ds.Vector;
import haxe.ui.components.Label;
import haxe.ui.containers.Box;
import haxe.ui.containers.VBox;
import haxe.ui.ComponentBuilder;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.System;

class SPPerformanceGraphWidget extends SPDebugWidget
{
	private static inline var GRAPH_WIDTH: Int = 100;
	private static inline var GRAPH_HEIGHT: Int = 100;
	private static inline var DEFAULT_WIDTH: Float = 110;
	private static inline var NAME: String = "Performance";

	private var times: Array<Float>;
	private var fpsHistoryIndex: Int;
	private var fpsHistory: Vector<Int>;
	private var memPeak: Float = 0;
	private var fpsLabel: Label;
	private var fpsPeak: Int = 0;
	private var memLabel: Label;
	private var memPeakLabel: Label;
	private var graph: Graphics;

	public function new(inX: Float = 10.0, inY: Float = 10.0) 
	{
		super(NAME);

		this.width = DEFAULT_WIDTH;
		
		this.times = [];
		this.fpsHistory = new Vector<Int>(GRAPH_WIDTH);
		this.fpsHistoryIndex = 0;
		
		this.addEventListener(Event.ENTER_FRAME, onEnter);

		var root = ComponentBuilder.fromFile("simple/debug/xml/performance.xml");

		fpsLabel = root.findComponent("fpsLabel", Label, true, "id");
		memLabel = root.findComponent("memLabel", Label, true, "id");
		memPeakLabel = root.findComponent("memPeakLabel", Label, true, "id");
		
		var graphContainer: Box = root.findComponent("graphContainer", Box, true, "id");
		
		var graphSprite = new Sprite();

		graph = graphSprite.graphics;

		graphContainer.addChild(graphSprite);
		
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
		
		var current = this.times.length;
		
		this.fpsHistory[fpsHistoryIndex] = current;
		this.fpsPeak = MathUtil.imax(this.fpsPeak, current);

		this.graph.clear();
		this.graph.lineStyle(1, SPColor.BLACK);
				
		var t = GRAPH_WIDTH / (this.fpsPeak + 5);
		
		this.graph.moveTo(0, GRAPH_HEIGHT - Std.int(this.fpsHistory[fpsHistoryIndex] * t));

		for (i in 1...GRAPH_WIDTH)
		{
			var index = (this.fpsHistoryIndex + i + 1) % GRAPH_WIDTH;
			this.graph.lineTo(i, GRAPH_HEIGHT - Std.int(this.fpsHistory[index] * t));
		}

		this.fpsHistoryIndex = (this.fpsHistoryIndex + 1) % GRAPH_WIDTH;
		
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