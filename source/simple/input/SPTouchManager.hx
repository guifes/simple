package simple.input;

import openfl.Lib;
import openfl.events.TouchEvent;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;
import simple.display.SPCamera;

class SPTouchManager
{
    public var touches(default, null): Array<SPTouch>;

    private var _touchesMap: Map<Int, SPTouch>;
    private var _inactiveTouches: Array<SPTouch>;

    var _camera: SPCamera;

    public function new()
    {
        touches = new Array<SPTouch>();

        _touchesMap = new Map<Int, SPTouch>();
        _inactiveTouches = new Array<SPTouch>();

        Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
    }

    public function setCamera(camera: SPCamera)
    {
		_camera = camera;
    }

    public function update(elapsed: Float)
    {
        var i = touches.length - 1;

        while(i >= 0)
        {
            var touch = touches[i];

            if(!touch.update(elapsed))
            {
                touches.splice(i, 1);
                
                touch.destroy();
                _inactiveTouches.push(touch);
            }

            i--;
        }
    }

    //////////////////
    // Touch Events //
    //////////////////

    public function onTouchBegin(e: TouchEvent)
    {
        var touch: SPTouch;

        if(_inactiveTouches.length > 0)
        {
            touch = _inactiveTouches.pop();
            touch.reset(e.touchPointID);
        }
        else
        {
            touch = new SPTouch(e.touchPointID);
        }
        
		touch.setCamera(_camera);

        touches.push(touch);
        _touchesMap.set(e.touchPointID, touch);
        
        touch.press(e.stageX, e.stageY);
    }

    public function onTouchEnd(e: TouchEvent)
    {
        var touch = _touchesMap.get(e.touchPointID);

        if(touch != null)
            touch.release(e.stageX, e.stageY);
    }

    public function onTouchMove(e: TouchEvent)
    {
        var touch = _touchesMap.get(e.touchPointID);

        if(touch != null)
            touch.move(e.stageX, e.stageY);
    }
}