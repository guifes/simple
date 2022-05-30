package simple;

import guifes.collection.HashSet;
import openfl.Assets;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import simple.debug.SPDebugWidget;
import simple.display.SPBitmapCache;
import simple.display.SPState;
import simple.display.shader.SPShaderHub;
import simple.input.SPMouseManager;

#if mobile
import simple.input.SPTouchManager;
#end

#if SP_DEBUG
import simple.debug.SPDebugContainer;
#end

class SPEngine
{
	public static var gameWidth(default, null): Int;
	public static var gameHeight(default, null): Int;
    public static var gameZoom(default, null): Float;
    public static var shaderHub(default, null): SPShaderHub;
    public static var root(default, null): Sprite;
	public static var mouseManager(default, null): SPMouseManager;
#if mobile
    public static var touchManager(default, null): SPTouchManager;
#end
    
	static var _uiContainer: Sprite;
    static var _gameContainer: Sprite;

#if SP_DEBUG
	static var _debugContainer: SPDebugContainer;
#end
	static var _currentState: SPState;
    static var _timeStarted: Int;
	static var _nextState: SPState;

	public static function start(appContainer: Sprite, gameWidth_: Int, initialState: Void -> SPState)
	{
        root = appContainer;
		root.name = "root";
		
        shaderHub = new SPShaderHub();
#if mobile
        touchManager = new SPTouchManager();
#end
        mouseManager = new SPMouseManager();

		gameWidth = gameWidth_;
        gameHeight = getGameHeight(gameWidth);
		gameZoom = getGameZoomForTargetWidth(gameWidth);

		// Initialize game
        {
            _gameContainer = new Sprite();
			_gameContainer.name = "gameContainer";
			_gameContainer.scaleX = SPEngine.gameZoom;
			_gameContainer.scaleY = SPEngine.gameZoom;
			
			root.addChild(_gameContainer);
			
            _uiContainer = new Sprite();
			_uiContainer.name = "uiContainer";
			
			root.addChild(_uiContainer);
			
#if SP_DEBUG
			_debugContainer = new SPDebugContainer();
			_debugContainer.name = "debugContainer";
			
			root.addChild(_debugContainer);
#end
		}

        // Handling input events
        {
#if mobile
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchManager.onTouchMove);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, touchManager.onTouchBegin);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, touchManager.onTouchEnd);
#end
			_gameContainer.addEventListener(MouseEvent.MOUSE_MOVE, mouseManager.worldMouse.onMouseMove);
			_gameContainer.addEventListener(MouseEvent.MOUSE_WHEEL, mouseManager.worldMouse.onMouseWheel);
			_gameContainer.addEventListener(MouseEvent.MOUSE_UP, mouseManager.worldMouse.onMouseUp);
			_gameContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseManager.worldMouse.onMouseDown);
			_gameContainer.addEventListener(MouseEvent.RELEASE_OUTSIDE, mouseManager.worldMouse.onMouseUp);

			Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseManager.screenMouse.onMouseMove);
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseManager.screenMouse.onMouseWheel);
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, mouseManager.screenMouse.onMouseUp);
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseManager.screenMouse.onMouseDown);
			Lib.current.stage.addEventListener(MouseEvent.RELEASE_OUTSIDE, mouseManager.screenMouse.onMouseUp);
        }
        
#if SP_DEBUG
		// Initialize Debugger
		
		_debugContainer.menuBar.visible = false;

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP,
			event ->
			{
				if(event.charCode == 96)
					_debugContainer.menuBar.visible = !_debugContainer.menuBar.visible;
			}
		);
#end
        
		// Intitial state

		__internalSwitchState(initialState());

		// Main loop

		_timeStarted = 0;

		Lib.current.stage.addEventListener(Event.ENTER_FRAME, mainUpdate);
	}

	@:access(simple.display.SPState)
	static function mainUpdate(e:Event)
    {
		var elapsed = Lib.getTimer();
		var deltaTime = elapsed - _timeStarted;
		_timeStarted = elapsed;

#if mobile
		touchManager.update(elapsed);
#end
		mouseManager.update(elapsed);

		for (shader in shaderHub.shaders)
			shader.update(elapsed);

		Lib.current.stage.invalidate();
		
		_currentState.__internalUpdate(elapsed, deltaTime);
		
		if (_nextState != null)
		{
			__internalSwitchState(_nextState);
			_nextState = null;
		}
    }
	
	static function __internalSwitchState(state: SPState)
	{
		if (_currentState != null)
			_currentState.destroy();

		// Clear previous state
		_gameContainer.removeChildren();
		_uiContainer.removeChildren();

		// Changing state
		_currentState = state;

		mouseManager.resetClicks();

#if mobile
		touchManager.setCamera(_currentState.camera);
#end
		mouseManager.setCamera(_currentState.camera);

		_gameContainer.addChild(_currentState.gameContainer);
		_uiContainer.addChild(_currentState.uiContainer);

		// Initialize new state
		_currentState.init();
	}

    //////////////////////
    // Public Interface //
    //////////////////////

    public static function switchState(state: SPState)
    {
		_nextState = state;
    }

	public static function addDebugWidget(label: String, widget: Void -> SPDebugWidget)
	{
#if SP_DEBUG
		_debugContainer.addDebugWidget(label, widget);
#end
	}

	////////////
	// Static //
	////////////

	static function getGameHeight(gameWidth: Int): Int
	{
		var stageWidth: Int = Lib.current.stage.stageWidth;
		var stageHeight: Int = Lib.current.stage.stageHeight;
		var ratio: Float = stageHeight / stageWidth;
		var gameHeight = Math.ceil(gameWidth * ratio);

		return gameHeight;
	}

	public static function getGameZoomForTargetWidth(gameWidth: Int): Float
	{
		return Lib.current.stage.stageWidth / gameWidth;
	}
}