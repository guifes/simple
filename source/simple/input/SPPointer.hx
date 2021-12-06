package simple.input;

import simple.display.SPCamera;
import openfl.geom.Point;

class SPPointer
{
    public var screen_position(default, null): Point;
    public var game_screen_position(default, null): Point;
    public var world_position(default, null): Point;

    public function new()
    {
        reset();
    }

    public function reset()
    {
        screen_position = new Point(0, 0);
        game_screen_position = new Point(0, 0);
        world_position = new Point(0, 0);
    }

    public function get_screen_position()
    {
        return screen_position;
    }

    public function get_game_screen_position()
    {
        return game_screen_position;
    }

    public function get_world_position()
    {
        return world_position;
    }

    public function move(x: Float, y: Float, camera: SPCamera)
    {
        screen_position.x = x;
        screen_position.y = y;
        
        game_screen_position.x = screen_position.x / SPEngine.gameZoom;
        game_screen_position.y = screen_position.y / SPEngine.gameZoom;

        world_position.x = (game_screen_position.x + camera.scrollX) / camera.zoom;
        world_position.y = (game_screen_position.y + camera.scrollY) / camera.zoom;

        // trace('Mouse Move | Zoom: { ${camera.zoom} }');
        // trace('Mouse Move | Scroll: { ${camera.scrollX}, ${camera.scrollY} }');
        // trace('Mouse Move | Screen: { ${screen_position.x}, ${screen_position.y} }');
        // trace('Mouse Move | Game Screen: { ${game_screen_position.x}, ${game_screen_position.y} }');
        // trace('Mouse Move | World: { ${world_position.x}, ${world_position.y} }');
    }
}