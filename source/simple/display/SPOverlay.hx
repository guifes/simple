package simple.display;

import openfl.display.Sprite;

class SPOverlay extends Sprite implements ISPDestroyable
{
	var _state: SPState;

	public function new()
	{
        super();

        graphics.clear();
        graphics.beginFill(SPColor.BLACK, 0.7);
        graphics.drawRect(0, 0, SPEngine.gameWidth, SPEngine.gameHeight);
        graphics.endFill();
	}

	function __internalStart(state: SPState)
	{
		_state = state;

		start();
	}

	function start()
	{
		
	}

	function close()
	{
		_state.remove(this);
	}

	public function destroy()
	{
		
	}
}