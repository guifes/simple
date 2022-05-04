package simple.debug;

import haxe.ui.containers.Box;
import haxe.ui.containers.menus.MenuItem;
import haxe.ui.events.UIEvent;
import openfl.display.DisplayObject;
import simple.debug.SPDebugWidget;

@:build(haxe.ui.macros.ComponentMacros.build("assets/haxeui/xml/simple/debug/main_container.xml"))
class SPDebugContainer extends Box
{
	var _widgetCount: Int;

	public function new()
	{
		super();
		
		addDebugWidget("Display List", () -> new SPDisplayListWidget());
		addDebugWidget("Performance", () -> new SPPerformanceWidget());

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