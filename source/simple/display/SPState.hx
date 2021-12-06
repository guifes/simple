package simple.display;

import openfl.display.DisplayObject;
import openfl.display.Sprite;

class SPState implements ISPDestroyable
{
	public var gameContainer(default, null): Sprite;
	public var uiContainer(default, null): Sprite;
	public var camera(default, null): SPCamera;

	// var pause: Bool;

	public function new()
	{
		camera = new SPCamera();

		gameContainer = new Sprite();
		uiContainer = new Sprite();

		gameContainer.addChild(camera);
	}

	public function init()
	{
		
	}

	function __internalUpdate(elapsed: Int, deltaTime: Int)
	{
		camera.update(elapsed, deltaTime);

		// if(!pause)
			update(elapsed, deltaTime);
	}

	public function update(elapsed: Int, deltaTime: Int)
	{
		
	}

	public function add(component: DisplayObject)
	{
		camera.add(component);
	}

	public function remove(component: DisplayObject)
	{
		camera.remove(component);
	}

	public function addUI(component: DisplayObject)
	{
		uiContainer.addChild(component);
	}

	public function removeUI(component: DisplayObject)
	{
		uiContainer.removeChild(component);
	}

	@:access(simple.display.SPOverlay)
	public function showOverlay(overlay: SPOverlay)
	{
		uiContainer.addChild(overlay);
		overlay.__internalStart(this);
	}

	public function destroy()
	{
		camera.destroy();
	}
}