package simple.debug;

import haxe.ui.containers.VBox;
import haxe.ui.dragdrop.DragManager;

@:build(haxe.ui.macros.ComponentMacros.build("assets/haxeui/xml/simple/debug/widget_base.xml"))
class SPDebugWidget extends VBox
{
	public function new(title: String)
	{
		super();

		this.nameLabel.text = title;
		this.closeButton.onClick = e -> this.parentComponent.removeComponent(this);
		this.showToggle.onClick = e -> this.containerBox.visible = !this.containerBox.visible;
	}

	public override function onReady()
	{
		super.onReady();

		DragManager.instance.registerDraggable(this, {
			mouseTarget: topBar
		});
	}
}