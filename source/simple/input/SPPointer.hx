package simple.input;

import haxe.Exception;
import openfl.geom.Point;
import simple.display.SPCamera;

class SPPointer
{
    public var screen_position(default, null): Point;
    public var game_screen_position(get, never): Point;
    public var world_position(get, never): Point;

    private var _camera: SPCamera;

    public function new()
    {
        reset();
    }

    public function setCamera(camera: SPCamera)
    {
        _camera = camera;
    }

    public function reset()
    {
        screen_position = new Point(0, 0);
    }

    public function get_game_screen_position()
	{
		var position = new Point();

		position.x = screen_position.x / SPEngine.gameZoom;
		position.y = screen_position.y / SPEngine.gameZoom;
        
		return position;
    }

    public function get_world_position()
    {
        if(_camera == null)
            throw new Exception("SPPointer has no camera to calculate world_position.");
        
        var position = new Point();
        
		position.x = (game_screen_position.x + _camera.scrollX) / _camera.zoom;
		position.y = (game_screen_position.y + _camera.scrollY) / _camera.zoom;
        
		return position;
    }

    public function move(x: Float, y: Float)
    {
        screen_position.x = x;
        screen_position.y = y;
    }
}