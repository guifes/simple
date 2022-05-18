package simple.debug;

import haxe.ui.containers.VBox;
import haxe.ui.dragdrop.DragManager;
import haxe.ui.geom.Rectangle;

@:build(haxe.ui.macros.ComponentMacros.build("simple/debug/xml/widget_base.xml"))
class SPDebugWidget extends VBox
{
	public function new(title: String)
	{
		super();

		this.nameLabel.text = title;
		this.includeInLayout = false;
		this.closeButton.onClick = e -> this.parentComponent.removeComponent(this);
		this.showToggle.onClick = e -> this.containerBox.visible = !this.containerBox.visible;
	}

	public override function onReady()
	{
		super.onReady();
		
		var bounds = this.parentComponent.getBounds(this);

		DragManager.instance.registerDraggable(this, {
			mouseTarget: topBar,
			dragBounds: new Rectangle(
				bounds.left,
				bounds.top,
				bounds.width,
				bounds.height
			)
		});
	}
}