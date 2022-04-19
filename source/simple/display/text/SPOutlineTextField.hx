package simple.display.text;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

class SPOutlineTextField extends Sprite
{
	var _textfield: TextField;
	var _tu: TextField;
	var _td: TextField;
	var _tl: TextField;
	var _tr: TextField;

	// TextField
    
    public var textColor(get, set):Int;
    public var multiline(get, set):Bool;
    public var wordWrap(get, set):Bool;
    public var defaultTextFormat(get, set):TextFormat;
    public var htmlText(get, set):String;
    public var text(get, set):String;
	public var autoSize(get, set):TextFieldAutoSize;
	public var background(get, set):Bool;
	public var backgroundColor(get, set):Int;
	public var border(get, set):Bool;
	public var borderColor(get, set):Int;
	public var selectable(get, set):Bool;
	
	private override function get_width():Float
	{
		return _textfield.width;
	}

	private override function set_width(value: Float):Float
	{
		if (outline)
		{
			_tu.width = value;
			_td.width = value;
			_tl.width = value;
			_tr.width = value;
		}

		return _textfield.width = value;
	}

	private override function get_height():Float
	{
		return _textfield.height;
	}

	private override function set_height(value:Float):Float
	{
		if (outline)
		{
			_tu.height = value;
			_td.height = value;
			_tl.height = value;
			_tr.height = value;
		}
		
		return _textfield.height = value;
	}

    private function get_textColor():Int
    {
        return _textfield.textColor;
    }
    
    private function set_textColor(value:Int):Int
    {
        return _textfield.textColor = value;
    }

    private function get_multiline():Bool
    {
        return _textfield.multiline;
    }

    private function set_multiline(value:Bool):Bool
    {
		if(outline)
		{
			_tu.multiline = value;
			_td.multiline = value;
			_tl.multiline = value;
			_tr.multiline = value;
		}
		
        return _textfield.multiline = value;
    }

    private function get_wordWrap():Bool
    {
        return _textfield.wordWrap;
    }

    private function set_wordWrap(value:Bool):Bool
    {
		if(outline)
		{
			_tu.wordWrap = value;
			_td.wordWrap = value;
			_tl.wordWrap = value;
			_tr.wordWrap = value;
		}
		
        return _textfield.wordWrap = value;
    }

    private function get_defaultTextFormat():TextFormat
    {
        return _textfield.defaultTextFormat;
    }

    private function set_defaultTextFormat(value:TextFormat):TextFormat
    {
		if(outline)
		{
			_tu.defaultTextFormat = value;
			_td.defaultTextFormat = value;
			_tl.defaultTextFormat = value;
			_tr.defaultTextFormat = value;
		}
		
        return _textfield.defaultTextFormat = value;
    }

	private function get_autoSize():TextFieldAutoSize
    {
		return _textfield.autoSize;
	}

	private function set_autoSize(value:TextFieldAutoSize):TextFieldAutoSize
    {
		if(outline)
		{
			_tu.autoSize = value;
			_td.autoSize = value;
			_tl.autoSize = value;
			_tr.autoSize = value;
		}
		
		return _textfield.autoSize = value;
	}

	private function get_background():Bool
    {
		return _textfield.background;
	}

	private function set_background(value:Bool):Bool
	{
		return _textfield.background = value;
	}

	private function get_backgroundColor():Int
    {
		return _textfield.backgroundColor;
	}

	private function set_backgroundColor(value:Int):Int
    {
		return _textfield.backgroundColor = value;
	}

	private function get_border():Bool
    {
		return _textfield.border;
	}

	private function set_border(value:Bool):Bool
    {
		return _textfield.border = value;
	}

	private function get_borderColor():Int
    {
		return _textfield.borderColor;
	}

	private function set_borderColor(value:Int):Int
    {
		return _textfield.borderColor = value;
	}

	private function get_selectable():Bool
	{
		return _textfield.selectable;
	}

	private function set_selectable(value:Bool):Bool
	{
		return _textfield.selectable = value;
	}

	private function get_text():String
	{
		return _textfield.text;
	}

    private function set_text(value:String):String
    {
		if(outline)
		{
			_tu.text = value;
			_td.text = value;
			_tl.text = value;
			_tr.text = value;
		}
		
        var v = _textfield.text = value;

        return v;
    }
    
    private function get_htmlText():String
    {
        return _textfield.htmlText;
    }

    private function set_htmlText(value:String):String
    {
        var v = _textfield.htmlText = value;

		if(outline)
		{
			this._tu.htmlText = formatOutlineHtmlText(value);
			this._td.htmlText = formatOutlineHtmlText(value);
			this._tl.htmlText = formatOutlineHtmlText(value);
			this._tr.htmlText = formatOutlineHtmlText(value);
		}

        return v;
    }

    public function setTextFormat(format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void
    {
		if(outline)
		{
			this._tu.setTextFormat(format, beginIndex, endIndex);
			this._td.setTextFormat(format, beginIndex, endIndex);
			this._tl.setTextFormat(format, beginIndex, endIndex);
			this._tr.setTextFormat(format, beginIndex, endIndex);
		}

        _textfield.setTextFormat(format, beginIndex, endIndex);
    }

	public function appendText(value: String)
	{
		if (outline)
		{
			_tu.appendText(value);
			_td.appendText(value);
			_tl.appendText(value);
			_tr.appendText(value);
		}

		_textfield.appendText(value);
	}

    // SPTextField

	public var outline(default, set): Bool;
    public var outlineColor(default, set): SPColor;

    public function new()
    {
        super();
        
        this._textfield = new TextField();
		
		addChild(this._textfield);
    }

	private function set_outline(value: Bool): Bool
	{
		if(value)
		{
			this._tu = this._tu == null ? new TextField() : this._tu;
			this._td = this._td == null ? new TextField() : this._td;
			this._tl = this._tl == null ? new TextField() : this._tl;
			this._tr = this._tr == null ? new TextField() : this._tr;

			this._tu.y = -1;
			this._td.y = 1;
			this._tl.x = -1;
			this._tr.x = 1;

			this._tu.width = this._textfield.width;
			this._tu.height = this._textfield.height;
			this._tu.multiline = this._textfield.multiline;
			this._tu.wordWrap = this._textfield.wordWrap;
			this._tu.defaultTextFormat = this._textfield.defaultTextFormat;
			this._tu.text = this._textfield.text;
			this._tu.autoSize = this._textfield.autoSize;
			this._tu.htmlText = formatOutlineHtmlText(this._textfield.htmlText);
			this._tu.selectable = false;
			
			this._td.width = this._textfield.width;
			this._td.height = this._textfield.height;
			this._td.multiline = this._textfield.multiline;
			this._td.wordWrap = this._textfield.wordWrap;
			this._td.defaultTextFormat = this._textfield.defaultTextFormat;
			this._td.text = this._textfield.text;
			this._td.autoSize = this._textfield.autoSize;
			this._td.htmlText = formatOutlineHtmlText(this._textfield.htmlText);
			this._td.selectable = false;
			
			this._tl.width = this._textfield.width;
			this._tl.height = this._textfield.height;
			this._tl.multiline = this._textfield.multiline;
			this._tl.wordWrap = this._textfield.wordWrap;
			this._tl.defaultTextFormat = this._textfield.defaultTextFormat;
			this._tl.text = this._textfield.text;
			this._tl.autoSize = this._textfield.autoSize;
			this._tl.htmlText = formatOutlineHtmlText(this._textfield.htmlText);
			this._tl.selectable = false;
			
			this._tr.width = this._textfield.width;
			this._tr.height = this._textfield.height;
			this._tr.multiline = this._textfield.multiline;
			this._tr.wordWrap = this._textfield.wordWrap;
			this._tr.defaultTextFormat = this._textfield.defaultTextFormat;
			this._tr.text = this._textfield.text;
			this._tr.autoSize = this._textfield.autoSize;
			this._tr.htmlText = formatOutlineHtmlText(this._textfield.htmlText);
			this._tr.selectable = false;
			
			addChildAt(this._tu, 0);
			addChildAt(this._td, 0);
			addChildAt(this._tl, 0);
			addChildAt(this._tr, 0);

			// Retrigger setter
			outlineColor = outlineColor;
		}
		else
		{
			removeChild(this._tu);
			removeChild(this._td);
			removeChild(this._tl);
			removeChild(this._tr);
		}
		
		return outline = value;
	}

	private function set_outlineColor(value: SPColor): SPColor
	{
		if(outline)
		{
			this._tu.textColor = value;
			this._td.textColor = value;
			this._tl.textColor = value;
			this._tr.textColor = value;
		}

		return outlineColor = value;
	}

	private function formatOutlineHtmlText(htmlText: String): String
	{
		var r = ~/color=("|')([0-9]|[A-F]|#)*("|')/g;
		var replaced = r.replace(htmlText, "");

		return replaced;
	}
}