package simple.addons;

import haxe.Exception;
import json2object.JsonParser;
import haxe.io.Path;
import openfl.Assets;
import simple.display.SPAnimatedSprite;

typedef TexturePackerSize =  { w: Int, h: Int }

typedef TexturePackerRect = { x: Int, y: Int, w: Int, h: Int }

typedef TexturePackerFrameData =
{
	filename: String,
	frame: TexturePackerRect,
	rotated: Bool,
	trimmed: Bool,
	spriteSourceSize: TexturePackerRect,
	sourceSize: TexturePackerSize
}

typedef TexturePackerMeta =
{
	app: String,
	version: String,
	image: String,
	format: String,
	size: TexturePackerSize,
	scale: Int,
	smartupdate: String
}

typedef TexturePackerData =
{
	frames: Array<TexturePackerFrameData>,
	meta: TexturePackerMeta
}

typedef AnimationData =
{
	public var frames: Array<String>;
	public var looped: Bool;
	public var flipX: Bool;
	public var flipY: Bool;
	public var frameRate: Int;
}

typedef AnimationsData =
{
	animations: Map<String, AnimationData>,
	texturePackerJson: String
}

class SPAnimatedSpriteExtension
{
	static public function loadAnimationFromFlixelAnimationEditorJson(self: SPAnimatedSprite, animationsJsonPath: String)
	{
		if(!Assets.exists(animationsJsonPath))
			throw new Exception('Asset $animationsJsonPath doesn\'t exist');

		var json = Assets.getText(animationsJsonPath);
		var parser = new JsonParser<AnimationsData>();
		var data = parser.fromJson(json);

		var animationsData = new Map<String, SPAnimationNameData>();
		
		for(key in data.animations.keys())
		{
			var animation = data.animations.get(key);
			
			var animationData: SPAnimationNameData = 
			{
				frames: animation.frames,
				repeatCount: animation.looped ? -1 : 0,
				frameRate: animation.frameRate
			};

			animationsData.set(key, animationData);
		}

		self.loadNameAnimations(animationsData);
	}
	
	public static function loadFramesFromTexturePacker(self: SPAnimatedSprite, texturePackerJsonPath: String): Void
	{
		if(!Assets.exists(texturePackerJsonPath))
			throw new Exception('Asset $texturePackerJsonPath doesn\'t exist');

		var json = Assets.getText(texturePackerJsonPath);
		var parser = new JsonParser<TexturePackerData>();
		var data = parser.fromJson(json);
	
		var dir = Path.directory(texturePackerJsonPath);

		var bitmapData = Assets.getBitmapData('${dir}/${data.meta.image}');

		var framesData = new Array<SPFrameData>();

		for(frame in data.frames)
		{
			var frameData: SPFrameData =
			{
				name: frame.filename,
				sourceX: frame.frame.x,
				sourceY: frame.frame.y,
				sourceWidth: frame.frame.w,
				sourceHeight: frame.frame.h,
				x: frame.spriteSourceSize.x,
				y: frame.spriteSourceSize.y,
				width: frame.sourceSize.w,
				height: frame.sourceSize.h,
				rotation: 0
			};

			framesData.push(frameData);
		}

		self.loadFrames(bitmapData, framesData);
	}
}