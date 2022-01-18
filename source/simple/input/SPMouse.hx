package simple.input;

import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import simple.display.SPCamera;

class SPMouse
{
    public var left(default, null): SPButton;
    public var wheel(default, null): SPWheel;
    public var screen_position(get, never): Point;
    public var game_screen_position(get, never): Point;
    public var world_position(get, never): Point;
    
    var _pointer: SPPointer;

    public function new()
    {
        left = new SPButton();
        wheel = new SPWheel();
        _pointer = new SPPointer();
    }

    public function setCamera(camera: SPCamera)
    {
		_pointer.setCamera(camera);
    }

    public function update(elapsed: Float)
    {
        left.update(elapsed);
        wheel.update(elapsed);
    }

    public function resetClicks()
    {
        left.reset();
    }

    public function get_screen_position()
    {
        return _pointer.screen_position.clone();
    }

    public function get_game_screen_position()
    {
        return _pointer.game_screen_position.clone();
    }

    public function get_world_position()
    {
        return _pointer.world_position.clone();
    }

	/////////////////
	// Mouse Events //
	/////////////////

	public function onMouseUp(e:MouseEvent)
    {
		left.release();
	}

	public function onMouseDown(e:MouseEvent)
    {
		left.press();
	}

	public function onMouseMove(e:MouseEvent)
    {
		_pointer.move(e.stageX, e.stageY);
	}

	public function onMouseWheel(e:MouseEvent)
    {
		wheel.rotate(e.delta);
	}
}