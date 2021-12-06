package simple;

import simple.display.shader.SPShaderHub;
import simple.display.SPBitmapCache;
import simple.display.SPState;
import simple.input.SPMouse;
import fx.FxHub;
import simple.debug.SPPerformanceWidget;
import haxe.Resource;
import openfl.Assets;
import openfl.events.Event;
import openfl.Lib;
import haxe.ui.Toolkit;
import openfl.display.Sprite;
#if mobile
import simple.input.SPTouchManager;
#end

class SPEngine
{
    public static var bitmapCache(default, null): SPBitmapCache;
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
	public static function start(appContainer: Sprite, gameWidth: Int, initialState: SPState, debug: Bool)
	{
        SPEngine.root = appContainer;
        SPEngine.bitmapCache = new SPBitmapCache();
        SPEngine.shaderHub = new SPShaderHub();
#if mobile
        SPEngine.touchManager = new SPTouchManager();
#end
        SPEngine.mouse = new SPMouse();

        SPEngine.gameWidth = gameWidth;
        SPEngine.gameHeight = getGameHeight(gameWidth);

        SPEngine.gameZoom = Lib.current.stage.stageWidth / gameWidth;

        {
		    FxHub.initilize();
        }

		// HaxeUI
        {
            Toolkit.autoScale = false;
            Toolkit.scale = SPEngine.gameZoom;
            Toolkit.init();
            Toolkit.styleSheet.parse(Assets.getText(AssetPaths.main__css));
            Toolkit.styleSheet.parse(Assets.getText(AssetPaths.shop__css));
            Toolkit.styleSheet.parse(Assets.getText(AssetPaths.stats__css));
        }
		
        // CastleDB initialization
        {
		    Data.load(Resource.getString("general.cdb"));
		    ImageData.load(Resource.getString("general.img"));
        }

		// Initialize game
        {
            _gameContainer = new Sprite();
            _uiContainer = new Sprite();

            _uiContainer.scaleX = SPEngine.gameZoom;
            _uiContainer.scaleY = SPEngine.gameZoom;

            _gameContainer.scaleX = SPEngine.gameZoom;
            _gameContainer.scaleY = SPEngine.gameZoom;

            appContainer.addChild(_gameContainer);
            appContainer.addChild(_uiContainer);
        }
        
#if debug
		// Initialize overlay stuff
        if(debug)
        {
            var fps = new SPPerformanceWidget(10, 10, 0x00ffff);

            appContainer.addChild(fps);
        }
#end
        
		// Intitial state

		switchState(initialState);

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

        // Clear cache
        bitmapCache.clear();

        // Changing state
        _currentState = state;

         SPEngine.mouse.resetClicks();

#if mobile
        SPEngine.touchManager.setCamera(_currentState.camera);
#end
        SPEngine.mouse.setCamera(_currentState.camera);

        _gameContainer.addChild(_currentState.gameContainer);
        _uiContainer.addChild(_currentState.uiContainer);

        // Initialize new state
        _currentState.init();
    }
}