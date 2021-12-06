package simple.input;

import simple.display.SPCamera;
import openfl.geom.Point;
import openfl.Lib;
import openfl.events.MouseEvent;

class SPMouse implements ISPDestroyable
{
    public var left(default, null): SPButton;
    public var wheel(default, null): SPWheel;
    public var screen_position(get, never): Point;
    public var game_screen_position(get, never): Point;
    public var world_position(get, never): Point;
    
    var _pointer: SPPointer;
    var _camera: SPCamera;

    public function new()
    {
        left = new SPButton();
        wheel = new SPWheel();
        _pointer = new SPPointer();

        Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
    }

    public function setCamera(value: SPCamera)
    {
        removeListeners();
        _camera = value;
        addListeners();
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

    function onMouseUp(e: MouseEvent)
    {
        left.release();
    }

    function onMouseDown(e: MouseEvent)
    {
        left.press();
    }

    function onMouseMove(e: MouseEvent)
    {
        _pointer.move(e.stageX, e.stageY, _camera);
    }

    function onMouseWheel(e: MouseEvent)
	{
        wheel.rotate(e.delta);
	}
    
    function addListeners()
    {
        if(_camera != null)
        {
            // _camera.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            // _camera.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            // _camera.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
        }
    }

    function removeListeners()
    {
        if(_camera != null)
        {
            // _camera.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
            // _camera.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            // _camera.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
        }
    }

    public function destroy()
    {
        Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
        Lib.current.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
        Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        Lib.current.stage.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);

        removeListeners();
    }
}