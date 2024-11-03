package simple.extension;

import haxe.Exception;
import haxe.io.Path;
import json2object.JsonParser;
import openfl.Assets;
import openfl.display.BitmapData;
import simple.display.SPAnimatedSprite;
import sys.FileSystem;
import sys.io.File;

typedef AsepriteSize =  { w: Int, h: Int }

typedef AsepriteRect = { x: Int, y: Int, w: Int, h: Int }

typedef AsepriteData =
{
	frames: Array<AsepriteFrame>,
    meta: AsepriteMeta
}

typedef AsepriteFrame = 
{
    filename: String,
    frame: AsepriteRect,
    rotated: Bool,
    trimmed: Bool,
    spriteSourceSize: AsepriteRect,
    sourceSize: AsepriteSize,
    duration: Int
}

typedef AsepriteMeta = 
{
    image: String,
    size: AsepriteSize,
    frameTags: Array<AsepriteFrameTag>
}

typedef AsepriteFrameTag = 
{
    name: String,
    from: Int,
    to: Int,
    direction: String,
    repeat: Int
}

class SPAnimatedSpriteAsepriteExtension
{
	public static function loadFramesAndAnimationsFromAsepriteJsonAsset(self: SPAnimatedSprite, path: String): Void
	{
		if(!Assets.exists(path))
			throw new Exception('Asset $path doesn\'t exist');

		var json: String = Assets.getText(path);
		
		var parser = new JsonParser<AsepriteData>();
		var data: AsepriteData = parser.fromJson(json);

		var dir: String = Path.directory(path);

		var bitmapData: BitmapData = Assets.getBitmapData('${dir}/${data.meta.image}');

		var framesData: Array<SPFrameData> = loadFrames(data.frames);
        var animations: Map<String, SPAnimationIdData> = loadAnimations(data.meta);

		self.loadFrames(bitmapData, framesData);
        self.loadIdAnimations(animations);
	}

	private static function loadFrames(frames: Array<AsepriteFrame>): Array<SPFrameData>
	{
		var framesData = new Array<SPFrameData>();

		for (frame in frames)
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
				rotation: 0,
				duration: frame.duration
			};

			framesData.push(frameData);
		}

		return framesData;
	}

    private static function loadAnimations(meta: AsepriteMeta): Map<String, SPAnimationIdData>
    {
        var animations = new Map<String, SPAnimationIdData>();

        for (tag in meta.frameTags)
        {
            var animation: SPAnimationIdData =
            {
                frames: [for (i in tag.from...tag.to + 1) i],
                repeat: tag.repeat
            };

            animations.set(tag.name, animation);
        }

        return animations;
    }
}