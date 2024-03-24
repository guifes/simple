package simple.extension;

import haxe.Exception;
import haxe.io.Path;
import json2object.JsonParser;
import openfl.Assets;
import simple.display.SPAnimatedSprite;
import sys.FileSystem;
import sys.io.File;

typedef AnimationData =
{
	public var frames: Array<String>;
	public var flipX: Bool;
	public var flipY: Bool;
	public var frameRate: Int;
	public var repeatCount: Bool;
}

typedef AnimationsData =
{
	animations: Map<String, AnimationData>,
	texturePackerJson: String
}

class SPAnimatedSpriteAnimationEditorExtension
{
	static public function loadAnimationFromFlixelAnimationEditorJsonAsset(self: SPAnimatedSprite, animationsJsonPath: String)
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
				frameRate: animation.frameRate,
				repeatCount: animation.repeatCount,
				flipX: animation.flipX,
				flipY: animation.flipY
			};

			animationsData.set(key, animationData);
		}

		self.loadNameAnimations(animationsData);
	}
}