package simple.display;

import openfl.display.DisplayObject;
import openfl.display.Sprite;

using simple.extension.SpriteExtension;

class SPState implements ISPDestroyable
{
	public var gameContainer(default, null): Sprite;
	public var uiContainer(default, null): Sprite;
	public var camera(default, null): SPCamera;

	private var _overlays: Array<SPOverlay>;
	private var _updatables: Array<ISPUpdatable>;

	public function new()
	{
		_overlays = [];
		_updatables = [];
		
		camera = new SPCamera();
		camera.name = '${getName()}.camera';

		gameContainer = new Sprite();
		gameContainer.name = '${getName()}.gameContainer';

		uiContainer = new Sprite();
		uiContainer.name = '${getName()}.uiContainer';

		gameContainer.addChild(camera);
	}

	private function getName()
	{
		return "SPState";
	}

	public function init()
	{
		
	}
	
	@:access(simple.display.SPOverlay)
	function __internalUpdate(elapsed: Int, deltaTime: Int)
	{
		camera.update(elapsed, deltaTime);

		update(elapsed, deltaTime);

		for (overlay in _overlays)
			overlay.__internalUpdate(elapsed, deltaTime);

		for (updatable in _updatables)
			updatable.update(elapsed, deltaTime);
	}

	public function update(elapsed: Int, deltaTime: Int) {} // Not meant to have any code

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
		_overlays.push(overlay);
		
		overlay.__internalStart(this);

		SPEngine.mouseManager.resetClicks();
	}
	
	private function closeOverlay(overlay: SPOverlay)
	{
		uiContainer.removeChild(overlay);
		_overlays.remove(overlay);

		overlay.destroy();
	}

	public function destroy()
	{
		_updatables = null;
		
		camera.destroy();
		uiContainer.destroyChildren();
	}
}