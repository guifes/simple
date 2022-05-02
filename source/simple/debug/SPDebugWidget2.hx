package simple.debug;

import openfl.Lib;
import openfl.Vector;
import openfl.display.DisplayObjectContainer;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;

class SPDebugWidget2 extends Sprite
{
	private static inline var TOP_BAR_HEIGHT: Float = 20;
	
	private var _topBar: Sprite;
	private var _contentView: Sprite;
	private var _toggle: Sprite;

	private var _targetWidth: Float;
	private var _targetHeight: Float;

	public function new(title: String, inX: Float = 10.0, inY: Float = 10.0, withWidth: Float, withHeight: Float)
	{
		super();

		this.x = inX;
		this.y = inY;
		this.mouseEnabled = false;

		_targetWidth = withWidth;
		_targetHeight = withHeight;

		// Top Bar
		{
			_topBar = new Sprite();
			
			generateTopBarGraphics(_topBar.graphics, SPColor.GREEN, 0.5);
			
			_topBar.scrollRect = new Rectangle(0, 0, _targetWidth, TOP_BAR_HEIGHT);

#if mobile
			_topBar.addEventListener(TouchEvent.TOUCH_BEGIN, e -> this.startDrag());
			_topBar.addEventListener(TouchEvent.TOUCH_END, e -> this.stopDrag());
#else
			_topBar.addEventListener(MouseEvent.MOUSE_DOWN, e -> this.startDrag());
			_topBar.addEventListener(MouseEvent.MOUSE_UP, e -> this.stopDrag());
#end

			// Title Label

			var titleLabel = new TextField();
			titleLabel.text = title;
			titleLabel.mouseEnabled = false;
			titleLabel.defaultTextFormat = new TextFormat("_sans", 12, SPColor.WHITE);

			_topBar.addChild(titleLabel);

			// Show/Hide Toggle
			
			_toggle = new Sprite();
			_toggle.buttonMode = true;
			_toggle.x = withWidth - 18;
			_toggle.y = 2;
			
			generateToggleGraphics(_toggle.graphics, true);

			_toggle.addEventListener(MouseEvent.MOUSE_UP, onToggleContent);

			_topBar.addChild(_toggle);
		}
		
		// Content View
		{
			_contentView = new Sprite();
			_contentView.graphics.beginFill(SPColor.GREEN, 0.25);
			_contentView.graphics.drawRect(0, 0, withWidth, withHeight);
			_contentView.graphics.endFill();
			
			_contentView.y = TOP_BAR_HEIGHT;
			_contentView.scrollRect = new Rectangle(0, 0, withWidth, withHeight);
			_contentView.mouseEnabled = false;
		}
		
		// Staging
		
		addChild(_contentView);
		addChild(_topBar);
	}

	private function generateTopBarGraphics(graphics: Graphics, color: SPColor, alpha: Float)
	{
		graphics.clear();
		graphics.beginFill(color, alpha);
		graphics.drawRect(0, 0, _targetWidth, TOP_BAR_HEIGHT);
		graphics.endFill();
	}

	private function generateToggleGraphics(graphics: Graphics, open: Bool)
	{
		graphics.clear();
		graphics.beginFill(SPColor.GREEN);
		graphics.drawRect(0, 0, 16, 16);
		graphics.endFill();
		graphics.beginFill(SPColor.WHITE);
		if(open) graphics.drawTriangles(new Vector<Float>(6, true, [8, 2, 2, 14, 14, 14]));
		else graphics.drawTriangles(new Vector<Float>(6, true, [8, 14, 2, 2, 14, 2]));
		graphics.endFill();
	}

	private function onToggleContent(event: MouseEvent)
	{
		_contentView.visible = !_contentView.visible;

		generateToggleGraphics(_toggle.graphics, _contentView.visible);
	}
}