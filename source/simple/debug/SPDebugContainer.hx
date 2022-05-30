package simple.debug;

import haxe.ui.containers.Box;
import haxe.ui.containers.menus.MenuItem;
import haxe.ui.events.UIEvent;
import openfl.display.DisplayObject;
import simple.debug.SPDebugWidget;

#if cpp
import cpp.vm.Profiler;
#end

@:build(haxe.ui.macros.ComponentMacros.build("simple/debug/xml/main_container.xml"))
class SPDebugContainer extends Box
{
	var _profilingMenuItem: MenuItem;
	var _isProfiling: Bool = false;
	
	public function new()
	{
		super();
		
		addDebugWidget("Display List", () -> new SPDisplayListWidget());
		addDebugWidget("Performance", () -> new SPPerformanceGraphWidget());
		
#if cpp
		{
			_profilingMenuItem = new MenuItem();
			_profilingMenuItem.text = "Start Profiling";
			_profilingMenuItem.onClick = e ->
			{
				if (_isProfiling)
				{
					_profilingMenuItem.text = "Start Profiling";

					Profiler.stop();
				}
				else
				{
					_profilingMenuItem.text = "Stop Profiling";
					
					Profiler.start('dump.txt');
				}

				_isProfiling = !_isProfiling;
			};
			
			this.profilerMenu.addComponent(_profilingMenuItem);
		}
#end
		
		this.clearWidgets.onClick = onClearWidgets;
	}
	
	private function onClearWidgets(e: UIEvent)
	{
		this.widgetsContainer.removeAllComponents();
	}
	
	public function addDebugWidget(label: String, widgetCreator: Void -> SPDebugWidget)
	{
		var menuItem = new MenuItem();
		menuItem.text = label;
		menuItem.onClick = e ->
		{
			var widget = widgetCreator();
			this.widgetsContainer.addComponent(widget);
		};

		this.widgetsMenu.addComponent(menuItem);
	}
}