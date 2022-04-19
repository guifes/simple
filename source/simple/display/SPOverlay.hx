package simple.display;

import openfl.display.Sprite;

using simple.extension.SpriteExtension;

class SPOverlay extends Sprite implements ISPDestroyable
{
	var _state: SPState;
	var _updatables:Array<ISPUpdatable>;
	var _shouldClose: Bool;

	public function new(background: Bool = true, alpha: Float = 0.7)
	{
        super();

		_updatables = [];

		if(background)
		{
			graphics.clear();
			graphics.beginFill(SPColor.BLACK, alpha);
			graphics.drawRect(0, 0, SPEngine.gameWidth, SPEngine.gameHeight);
			graphics.endFill();
		}
	}

	//////////////
	// Internal //
	//////////////

	function __internalStart(state: SPState)
	{
		_state = state;

		start();
	}

	@:access(simple.display.SPState)
	function __internalUpdate(elapsed: Int, deltaTime: Int)
	{
		update(elapsed, deltaTime);
		
		for (updatable in _updatables)
			updatable.update(elapsed, deltaTime);

		if (_shouldClose)
			_state.closeOverlay(this);
	}

	///////////////
	// SPOverlay //
	///////////////

	function close()
	{
		_shouldClose = true;
	}

	/////////////////////////////////
	// SPOverlay Virtual Interface //
	/////////////////////////////////

	function start() {} // Not meant to have any code
	function update(elapsed:Int, deltaTime:Int) {} // Not meant to have any code

	////////////////////
	// ISPDestroyable //
	////////////////////

	public function destroy()
	{
		_updatables = null;
		
		this.destroyChildren();
	}
}