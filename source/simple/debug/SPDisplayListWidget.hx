package simple.debug;

import haxe.ui.containers.TreeView;
import haxe.ui.containers.TreeViewNode;
import haxe.ui.macros.ComponentMacros;
import openfl.Lib;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

using guifes.extension.ArrayExtension;

class SPDisplayListWidget extends SPDebugWidget
{
	private static inline var DEFAULT_WIDTH:Float = 200;
	private static inline var NAME: String = "Display List";
	
	private var contentView: TreeView;

	public function new() 
	{
		super(NAME);

		this.width = DEFAULT_WIDTH;

		this.contentView = ComponentMacros.buildComponent("assets/haxeui/xml/simple/debug/display_list.xml");
		
		this.containerBox.addComponent(this.contentView);

		buildTree(Lib.current.stage);
	}

	private function buildTree(node: DisplayObject, parentTreeNode: TreeViewNode = null)
	{
		if(node.name == NAME)
			return;

		var treeNode: TreeViewNode;

		if(parentTreeNode == null)
			treeNode = this.contentView.addNode({ text: getNormalizedNodeName(node) });
		else
			treeNode = parentTreeNode.addNode({ text: getNormalizedNodeName(node) });
		
		if(!Std.isOfType(node, DisplayObjectContainer))
			return;
		
		var containerNode: DisplayObjectContainer = cast node;

		for (i in 0...containerNode.numChildren)
		{
			var child = containerNode.getChildAt(i);
			
			buildTree(child, treeNode);
		}
	}

	////////////
	// Static //
	////////////

	private static function getNormalizedNodeName(node: DisplayObject)
	{
		if (node.name.substr(0, 8) == "instance")
		{
			var typeName = Type.getClassName(Type.getClass(node));
			var pieces: Array<String> = typeName.split(".");
			return pieces[pieces.length - 1];
		}

		return node.name;
	}
}