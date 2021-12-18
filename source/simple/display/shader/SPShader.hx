package simple.display.shader;

import haxe.Exception;
import openfl.display.DisplayObjectShader;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

class SPShader extends DisplayObjectShader
{
    public function new(code:ByteArray = null)
	{
		super(code);
		
        SPEngine.shaderHub.registerShader(this);
	}

    public function update(elapsed: Float)
    {
		
    }
}