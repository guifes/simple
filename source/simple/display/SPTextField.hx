package simple.display;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;
import shader.FxSpriteShader;

class SPTextField extends Bitmap
{
    // TextField
    
    public var textColor(get, set):Int;
    public var multiline(get, set):Bool;
    public var wordWrap(get, set):Bool;
    public var defaultTextFormat(get, set):TextFormat;
    public var htmlText(get, set):String;
    public var text(get, set):String;

    private function get_textColor():Int
    {
        return _textField.textColor;
    }
    
    private function set_textColor(value:Int):Int
    {
        return _textField.textColor = value;
    }

    private function get_multiline():Bool
    {
        return _textField.multiline;
    }

    private function set_multiline(value:Bool):Bool
    {
        return _textField.multiline = value;
    }

    private function get_wordWrap():Bool
    {
        return _textField.wordWrap;
    }

    private function set_wordWrap(value:Bool):Bool
    {
        return _textField.wordWrap = value;
    }

    private function get_defaultTextFormat():TextFormat
    {
        return _textField.defaultTextFormat;
    }

    private function set_defaultTextFormat(value:TextFormat):TextFormat
    {
        return _textField.defaultTextFormat = value;
    }

    private function get_text():String
    {
        return _textField.text;
    }

    private function set_text(value:String):String
    {
        var v = _textField.text = value;

        generateGraphic();

        return v;
    }
    
    private function get_htmlText():String
    {
        return _textField.htmlText;
    }

    private function set_htmlText(value:String):String
    {
        var v = _textField.htmlText = value;

        generateGraphic();

        return v;
    }

    public function setTextFormat(format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void
    {
        _textField.setTextFormat(format, beginIndex, endIndex);

        generateGraphic();
    }

    // SPTextField

    public var outlineColor(default, set): SPColor;

    private var _textField: TextField;

    public function new()
    {
        super();
        
        this.smoothing = true;
        this.shader = new FxSpriteShader();
        
        this._textField = new TextField();
    }

    private function set_outlineColor(value: SPColor): SPColor
    {
        var s: FxSpriteShader = cast this.shader;
        s.setBorderColor(value);
        return outlineColor = value;
    }

    private function generateGraphic()
    {
        var intWidth: Int = cast _textField.width;
        var intHeight: Int = cast _textField.height;
        
        if(this.bitmapData != null && (this.bitmapData.width != intWidth || this.bitmapData.height != intHeight))
        {
            this.bitmapData.dispose();
        }

        if(this.bitmapData == null)
            this.bitmapData = new BitmapData(intWidth, intHeight, true, SPColor.TRANSPARENT);   
        else
            this.bitmapData.fillRect(new Rectangle(0, 0, intWidth, intHeight), SPColor.TRANSPARENT);

        this.bitmapData.draw(_textField);
    }
}