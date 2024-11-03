package simple.extension;

import haxe.Exception;
import haxe.io.Path;
import json2object.JsonParser;
import openfl.Assets;
import openfl.display.BitmapData;
import simple.display.SPAnimatedSprite;
import sys.FileSystem;
import sys.io.File;

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

class SPAnimatedSpriteTexturePackagerExtension
{
	public static function loadFramesFromTexturePackerJsonAsset(self: SPAnimatedSprite, texturePackerJsonPath: String): Void
	{
		if(!Assets.exists(texturePackerJsonPath))
			throw new Exception('Asset $texturePackerJsonPath doesn\'t exist');

		var json = Assets.getText(texturePackerJsonPath);
		
		var parser = new JsonParser<TexturePackerData>();
		var data = parser.fromJson(json);

		var dir = Path.directory(texturePackerJsonPath);

		var bitmapData = Assets.getBitmapData('${dir}/${data.meta.image}');

		var framesData = loadFramesFromTexturePackerJson(json, data.frames);

		self.loadFrames(bitmapData, framesData);
	}

	public static function loadFramesFromTexturePackerJsonFile(self: SPAnimatedSprite, texturePackerJsonPath: String): Void
	{
		var absolutePath: String = FileSystem.absolutePath(texturePackerJsonPath);

		if (!FileSystem.exists(absolutePath))
			throw new Exception('Asset $texturePackerJsonPath doesn\'t exist');

		var json = File.getContent(texturePackerJsonPath);

		var parser = new JsonParser<TexturePackerData>();
		var data = parser.fromJson(json);

		var dir = Path.directory(texturePackerJsonPath);

		var bitmapData = SPEngine.getExternalBitmapDataFromFile('${dir}/${data.meta.image}');
		
		var framesData = loadFramesFromTexturePackerJson(json, data.frames);

		self.loadFrames(bitmapData, framesData);
	}

	private static function loadFramesFromTexturePackerJson(json: String, frames: Array<TexturePackerFrameData>)
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
				duration: 0
			};

			framesData.push(frameData);
		}

		return framesData;
	}
}