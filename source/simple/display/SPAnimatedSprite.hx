package simple.display;

import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.events.TimerEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.Timer;

#if debug
import openfl.display.Shape;
#end

typedef SPAnimationNameData =
{
	frames: Array<String>,
	frameRate: Int,
	repeatCount: Int
}

typedef SPAnimationIdData = SPAnimation;

typedef SPAnimation =
{
	frames: Array<Int>,
	frameRate: Int,
	repeatCount: Int
}

typedef SPFrameData =
{
	name: String,
	sourceX: Int,
	sourceY: Int,
	sourceWidth: Int,
	sourceHeight: Int,
	x: Int,
	y: Int,
	rotation: Float,
	width: Int,
	height: Int
}

typedef SPFrame =
{
	id: Int,
	x: Int,
	y: Int,
	rotation: Float,
	width: Int,
	height: Int
}

class SPAnimatedSprite extends Sprite implements ISPDestroyable
{
	public var currentAnimation(default, null): String;
	public var position(never, set): Point;

	// Structure
	private var _tilemap: Tilemap;
	private var _tile: Tile;
	
	// Frames
	private var _frames: Array<SPFrame>;
	private var _frameMap: Map<String, Int>;
	
	// Animation
	private var _timer: Timer;
	private var _animations: Map<String, SPAnimation>;
	private var _currentAnimation: SPAnimation;
	private var _currentFrameIndex: Int;
	private var _currentRepeatCount: Int;
	private var _currentAnimationFinishCallback: Noise -> Void;

#if debug
	public var debug(default, set): Bool;

    var _debugSprite: Shape;
#end

	public function new()
	{
		super();

		_timer = new Timer(0, 0);

		_timer.addEventListener(TimerEvent.TIMER, onTimerTick);

#if debug
		_debugSprite = new Shape();
        _debugSprite.visible = false;

        addChild(_debugSprite);
#end
	}

	public function set_position(point: Point)
	{
		this.x = point.x;
		this.y = point.y;
		return point;
	}

	public function getMidpoint()
	{
		return new Point(
			this.x + this.width * 0.5,
			this.y + this.height * 0.5
		);
	}

	public function loadFrames(bitmapData: BitmapData, framesData: Array<SPFrameData>)
	{
		_frames = new Array<SPFrame>();
		_frameMap = new Map<String, Int>();
		
		var rects = new Array<Rectangle>();

		for(i in 0...framesData.length)
		{
			var frameData = framesData[i];

			var rect = new Rectangle(
				frameData.sourceX,
				frameData.sourceY,
				frameData.sourceWidth,
				frameData.sourceHeight
			);

			var frame: SPFrame = {
				id: i,
				x: frameData.x,
				y: frameData.y,
				rotation: frameData.rotation,
				width: frameData.width,
				height: frameData.height
			};

			_frames.push(frame);
			_frameMap.set(frameData.name, i);

			rects.push(rect);
		}
		
		var firstFrame = _frames[0];
		var tileset = new Tileset(bitmapData, rects);

        _tilemap = new Tilemap(Std.int(firstFrame.width), Std.int(firstFrame.height), tileset, false);
        _tile = new Tile(firstFrame.id, firstFrame.x, firstFrame.y);

        _tilemap.addTile(_tile);

		addChild(_tilemap);

#if debug
		updateDebug(_tilemap);
#end
	}

	public function loadNameAnimations(animations: Map<String, SPAnimationNameData>)
	{
		_animations = new Map<String, SPAnimation>();

		for(key in animations.keys())
		{
			var animation = animations.get(key);

			var spAnimation: SPAnimation =
			{
				frameRate: animation.frameRate,
				repeatCount: animation.repeatCount,
				frames: [for(frame in animation.frames) _frameMap.get(frame)]
			};

			_animations.set(key, spAnimation);
		}
	}

	public function loadIdAnimations(animations: Map<String, SPAnimationIdData>)
	{
		_animations = animations;
	}

	public function setFrameByIndex(id: Int)
	{
		var frame = _frames[id];

		_tile.id = id;
		_tile.x = frame.x;
		_tile.y = frame.y;
		_tile.rotation = frame.rotation;

		_tilemap.width = frame.width;
		_tilemap.height = frame.height;
	}

	public function setFrameByName(name: String)
	{
		if(_frameMap.exists(name))
		{
			var id = _frameMap.get(name);

			setFrameByIndex(id);
		}
	}

	public function playAnimation(animationName:String)
	{
		currentAnimation = animationName;

		_currentAnimation = _animations.get(animationName);

		_currentFrameIndex = 0;
		_currentRepeatCount = 0;

		var id = _currentAnimation.frames[_currentFrameIndex];

		setFrameByIndex(id);

		_timer.stop();
		_timer.delay = 1000 / _currentAnimation.frameRate;
		_timer.start();
	}

	public function playAwaitableAnimation(animationName: String): Future<Noise>
	{
		return new Future(
			cb ->
			{
				playAnimation(animationName);
				
				if(_currentAnimation.repeatCount < 0)
					cb(Noise);
				else
					_currentAnimationFinishCallback = cb;
				
				return null;
			}
		);
	}

	// Timer

	function onTimerTick(e: TimerEvent)
	{
		if(_currentFrameIndex == _currentAnimation.frames.length - 1)
		{
			if(_currentAnimation.repeatCount < 0 || _currentRepeatCount < _currentAnimation.repeatCount)
			{
				_currentRepeatCount++;
			}
			else
			{
				_timer.stop();
				
				if(_currentAnimationFinishCallback != null)
				{
					var temp = _currentAnimationFinishCallback;
					_currentAnimationFinishCallback = null;
					temp(Noise);
				}

				return;
			}
		}

		_currentFrameIndex = (_currentFrameIndex + 1) % _currentAnimation.frames.length;

		_tile.id = _currentAnimation.frames[_currentFrameIndex];
	}

	// SPDestroyable

	public function destroy()
	{
		_timer.stop();
		_timer.removeEventListener(TimerEvent.TIMER, onTimerTick);
	}

#if debug

	function updateDebug(tilemap: Tilemap)
	{
		_debugSprite.graphics.clear();
        _debugSprite.graphics.lineStyle(1, 0x0000FF, 0.5);
		_debugSprite.graphics.drawRect(0, 0, tilemap.width, tilemap.height);
		_debugSprite.graphics.lineStyle(1, 0xFFFF00, 0.5);
		_debugSprite.graphics.drawRect(_tile.x, _tile.y, _tile.width, _tile.height);
	}

    public function set_debug(value: Bool)
    {
        _debugSprite.visible = value;
        return debug = value;
    }

#end
}