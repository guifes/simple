package simple.input;

import openfl.ui.MultitouchInputMode;
import openfl.ui.Multitouch;
import openfl.events.TouchEvent;
import simple.display.SPCamera;
import openfl.Lib;

class SPTouchManager implements ISPDestroyable
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

        Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
        Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
        Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
    }

    public function setCamera(value: SPCamera)
    {
        removeListeners();
        _camera = value;
        addListeners();
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

    function onTouchBegin(e: TouchEvent)
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

        touches.push(touch);
        _touchesMap.set(e.touchPointID, touch);
        
        touch.press(e.stageX, e.stageY, _camera);
    }

    function onTouchEnd(e: TouchEvent)
    {
        var touch = _touchesMap.get(e.touchPointID);

        if(touch != null)
            touch.release(e.stageX, e.stageY, _camera);
    }

    function onTouchMove(e: TouchEvent)
    {
        var touch = _touchesMap.get(e.touchPointID);

        if(touch != null)
            touch.move(e.stageX, e.stageY, _camera);
    }

    function addListeners()
    {
        if(_camera != null)
        {
            // _camera.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
            // _camera.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
        }
    }

    function removeListeners()
    {
        if(_camera != null)
        {
            // _camera.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
            // _camera.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
        }
    }

    public function destroy()
    {
        Lib.current.stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
        Lib.current.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
        Lib.current.stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);

        removeListeners();
    }
}