package simple;

import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import simple.debug.SPPerformanceWidget;
import simple.display.SPBitmapCache;
import simple.display.SPState;
import simple.display.shader.SPShaderHub;
import simple.input.SPMouse;
#if mobile
import simple.input.SPTouchManager;
#end

class SPEngine
{
	public static var gameWidth(default, null): Int;
	public static var gameHeight(default, null): Int;
    public static var gameZoom(default, null): Float;
    public static var shaderHub(default, null): SPShaderHub;
    public static var root(default, null): Sprite;
#if mobile
    public static var touchManager(default, null): SPTouchManager;
#end
    public static var mouse(default, null): SPMouse;

	static var _uiContainer: Sprite;
    static var _gameContainer: Sprite;
	static var _currentState: SPState;

    @:access(simple.display.SPState)
	public static function start(appContainer: Sprite, gameWidth_: Int, initialState: Void -> SPState, debug: Bool = true)
	{
        root = appContainer;
        shaderHub = new SPShaderHub();
#if mobile
        touchManager = new SPTouchManager();
#end
        mouse = new SPMouse();

		gameWidth = gameWidth_;
        gameHeight = getGameHeight(gameWidth);

        gameZoom = Lib.current.stage.stageWidth / gameWidth;

		// Initialize game
        {
            _gameContainer = new Sprite();
            _uiContainer = new Sprite();

            _uiContainer.scaleX = SPEngine.gameZoom;
            _uiContainer.scaleY = SPEngine.gameZoom;

            _gameContainer.scaleX = SPEngine.gameZoom;
            _gameContainer.scaleY = SPEngine.gameZoom;

			root.addChild(_gameContainer);
			root.addChild(_uiContainer);

#if mobile
			_gameContainer.addEventListener(TouchEvent.TOUCH_MOVE, touchManager.onTouchMove);
			_gameContainer.addEventListener(TouchEvent.TOUCH_BEGIN, touchManager.onTouchBegin);
			_gameContainer.addEventListener(TouchEvent.TOUCH_END, touchManager.onTouchEnd);
#else
			_gameContainer.addEventListener(MouseEvent.MOUSE_MOVE, mouse.onMouseMove);
			_gameContainer.addEventListener(MouseEvent.MOUSE_WHEEL, mouse.onMouseWheel);
			_gameContainer.addEventListener(MouseEvent.MOUSE_UP, mouse.onMouseUp);
			_gameContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouse.onMouseDown);
			_gameContainer.addEventListener(MouseEvent.MOUSE_OUT, mouse.onMouseUp);
#end
        }
        
#if debug
		// Initialize overlay stuff
        if(debug)
        {
            var fps = new SPPerformanceWidget(10, 10, 0x00ffff);

			root.addChild(fps);
        }
#end
        
		// Intitial state

		switchState(initialState());

		// Main loop

		var timeStarted = 0;

		Lib.current.stage.addEventListener(Event.ENTER_FRAME, (e: Event) ->
		{
			var elapsed = Lib.getTimer();
			var deltaTime = elapsed - timeStarted;
			timeStarted = elapsed;

#if mobile
            touchManager.update(elapsed);
#end
            mouse.update(elapsed);

            for(shader in shaderHub.shaders)
                shader.update(elapsed);

            Lib.current.stage.invalidate();

			_currentState.__internalUpdate(elapsed, deltaTime);
		});
	}

	static function getGameHeight(gameWidth: Int): Int
	{
		var stageWidth: Int = Lib.current.stage.stageWidth;
		var stageHeight: Int = Lib.current.stage.stageHeight;
		var ratio: Float = stageHeight / stageWidth;
		var gameHeight = Math.ceil(gameWidth * ratio);

		return gameHeight;
	}

    public static function switchState(state: SPState)
    {
        for(i in 0..._gameContainer.numChildren)
        {
            var child = _gameContainer.getChildAt(i);

            if(Std.is(child, ISPDestroyable))
            {
                cast(child, ISPDestroyable).destroy();
            }
        }
        
        // Clear previous state
        _gameContainer.removeChildren();
        _uiContainer.removeChildren();

        // Changing state
        _currentState = state;

         mouse.resetClicks();

#if mobile
        touchManager.setCamera(_currentState.camera);
#else
        mouse.setCamera(_currentState.camera);
#end
        _gameContainer.addChild(_currentState.gameContainer);
        _uiContainer.addChild(_currentState.uiContainer);

        // Initialize new state
        _currentState.init();
    }
}