package simple.input;

import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import simple.display.SPCamera;

class SPMouseManager
{
    public var worldMouse(default, null): SPMouse;
    public var screenMouse(default, null): SPMouse;


    public function new()
    {
        worldMouse = new SPMouse();
        screenMouse = new SPMouse();
    }

    public function setCamera(camera: SPCamera)
    {
        worldMouse.setCamera(camera);
        screenMouse.setCamera(camera);
    }

    public function update(elapsed: Float)
    {
        worldMouse.update(elapsed);
        screenMouse.update(elapsed);
    }

    public function resetClicks()
    {
        worldMouse.resetClicks();
        screenMouse.resetClicks();
    }
}