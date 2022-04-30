package simple.debug;

import haxe.ui.events.MouseEvent;
import openfl.Lib;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

using guifes.extension.ArrayExtension;

class SPDisplayListWidget extends SPDebugWidget
{
	private static inline var DEFAULT_WIDTH:Float = 200;
	private static inline var DEFAULT_HEIGHT:Float = 400;
	
	private var _textfield: TextField;
	
	public function new(inX: Float = 10.0, inY: Float = 10.0) 
	{
		super("Display List", inX, inY, DEFAULT_WIDTH, DEFAULT_HEIGHT);

		_textfield = new TextField();

		_textfield.selectable = false;
		_textfield.width = DEFAULT_WIDTH;
		_textfield.height = DEFAULT_HEIGHT;
		_textfield.text = "";
		_textfield.defaultTextFormat = new TextFormat("_sans", 12, SPColor.WHITE);
		_textfield.mouseEnabled = true;
		_textfield.mouseWheelEnabled = true;

		_textfield.addEventListener(MouseEvent.MOUSE_WHEEL, e ->
		{
			trace(e.delta);
			_textfield.scrollV += e.delta * 10;
		});

		_contentView.addChild(_textfield);
		
		Lib.current.stage.addEventListener(Event.ADDED, onAddedToStage);
		Lib.current.stage.addEventListener(Event.REMOVED, onRemovedFromStage);
	}

	private function buildTreeString(root: DisplayObjectContainer, recursion: Int = 0)
	{
		if (visible && recursion < 10)
		{
			var treeString = new StringBuf();

			for (i in 0...root.numChildren)
			{
				var child = root.getChildAt(i);
				
				if (i > 0)
					treeString.add("\n");

				for(r in 0...recursion)
					treeString.add(" ");

				if (child.name.substr(0, 8) == "instance")
				{
					var typeName = Type.getClassName(Type.getClass(child));
					var pieces: Array<String> = typeName.split(".");
					treeString.add(pieces[pieces.length - 1]);
				}
				else
				{
					treeString.add(child.name);
				}
				
				if(Std.isOfType(child, DisplayObjectContainer))
				{
					var containerChild = cast(child, DisplayObjectContainer);

					if (containerChild.numChildren > 0)
					{
						treeString.add("\n");
						treeString.add(buildTreeString(containerChild, recursion + 1));
					}
				}
			}

			return treeString.toString();
		}

		return "";
	}

	private function onAddedToStage(event: Event)
	{
		var mainSprite: DisplayObjectContainer = cast Lib.current.stage.getChildAt(0);
		var root: DisplayObjectContainer = cast mainSprite.getChildByName("root");

		var output = buildTreeString(root);
		_textfield.text = output;
	}

	private function onRemovedFromStage(event: Event)
	{
		var mainSprite: DisplayObjectContainer = cast Lib.current.stage.getChildAt(0);
		var root: DisplayObjectContainer = cast mainSprite.getChildByName("root");

		var output = buildTreeString(root);
		_textfield.text = output;
	}
}