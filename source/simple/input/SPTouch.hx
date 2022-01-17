package simple.input;

import openfl.geom.Point;
import simple.display.SPCamera;

class SPTouch implements ISPDestroyable
{
    public var just_pressed(get, never): Bool;
    public var pressed(get, never): Bool;
    public var just_released(get, never): Bool;
    public var screen_position(get, never): Point;
    public var game_screen_position(get, never): Point;
    public var world_position(get, never): Point;
    public var id(default, null): Int;
    
    var _pointer: SPPointer;
    var _button: SPButton;

    public function new(id: Int)
    {
        reset(id);
    }

    public function setCamera(camera: SPCamera)
    {
        _pointer.setCamera(camera);
    }

    public function reset(id: Int)
    {
        this.id = id;

        _pointer = new SPPointer();
        _button = new SPButton();
    }

    public function destroy()
    {
        this.id = -1;
        
        _pointer = null;
        _button = null;
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

    public function get_just_pressed()
    {
        return _button.just_pressed;
    }

    public function get_pressed()
    {
        return _button.pressed;
    }
    
    public function get_just_released()
    {
        return _button.just_released;
    }

    public function update(elapsed: Float)
    {
        _button.update(elapsed);

        return !(_button.released && !just_released);
    }

    public function press(x: Float, y: Float)
    {
        _button.press();
        _pointer.move(x, y);
    }

    public function release(x: Float, y: Float)
    {
        _button.release();
        _pointer.move(x, y);
    }

    public function move(x: Float, y: Float)
    {
        _pointer.move(x, y);
    }
}