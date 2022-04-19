package simple.display.text;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import simple.display.shader.SPTextFieldShader;

class SPTypeTextField extends SPOutlineTextField implements ISPUpdatable
{
    public var delay: Int;

    private var _finalText: String;
    private var _startTime: Int;
    private var _typing: Bool;
    private var _currentCharIndex: Int;

    public override function set_text(value: String): String
    {
		var buffer = new StringBuf();
		
		this._textfield.text = value;

		for(line in 0...this._textfield.numLines)
		{
			var lineOffset = this._textfield.getLineOffset(line);
			var lineLength = this._textfield.getLineLength(line);
			var lineText = this._textfield.getLineText(line);
			var lastChar = lineText.charAt(lineLength - 1);

			if (lastChar != '\n')
			{
				buffer.add(lineText);
				buffer.add('\n');
			}
		}

		_finalText = buffer.toString();

		return super.text = "";
    }

    public function start()
    {
		_typing = true;
		_startTime = 0;
		_currentCharIndex = 0;
    }
    
    /////////////////
    // ISUpdatable //
    /////////////////
    
    public function update(elapsed: Int, deltaTime: Int)
    {
		if (_typing)
		{
            if(_startTime == 0)
            {
                _startTime = elapsed;
                return;
            }
            
            var delta = elapsed - _startTime;
            var charIndex = Std.int(delta / delay);

			if (charIndex >= _finalText.length)
			{
				_typing = false;
				charIndex = _finalText.length - 1;
			}

            if(charIndex > _currentCharIndex)
            {
				super.appendText(_finalText.substr(_currentCharIndex, charIndex - _currentCharIndex));

				_currentCharIndex = charIndex;
            }
        }
    }
}