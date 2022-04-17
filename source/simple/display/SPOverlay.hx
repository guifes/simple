package simple.display;

import openfl.display.Sprite;

using simple.extension.SpriteExtension;

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

	public function update(elapsed:Int, deltaTime:Int)
	{
		
	}

	@:access(simple.display.SPState)
	function close()
	{
		_state.closeOverlay(this);
	}

	public function destroy()
	{
		this.destroyChildren();
	}
}