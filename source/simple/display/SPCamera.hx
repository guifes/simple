package simple.display;

import de.polygonal.core.math.Mathematics;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;

using simple.extension.SpriteExtension;

class SPCamera extends Sprite implements ISPDestroyable
{
    public var backgroundColor(default, set): SPColor;
    public var minZoom(default, default): Float = 1;
    public var maxZoom(default, default): Float = 8;
    public var bounds(default, set): Rectangle;

    public var scroll(get, never): Point;
    public var scrollX(get, set): Float;
    public var scrollY(get, set): Float;
    public var zoom(default, set): Float;

    private var _background: Sprite;
    private var _content: Sprite;
    private var _innerContent: Sprite;
    private var _bounds: Rectangle;
    private var _followTarget: Sprite;

    public function new()
    {
        super();

        _background = new Sprite();
        _content = new Sprite();
        _innerContent = new Sprite();
        
        _content.scrollRect = new Rectangle(0, 0, SPEngine.gameWidth, SPEngine.gameHeight);
        
        addChild(_background);
        addChild(_content);
        
        _content.addChild(_innerContent);
        
        zoom = 1;
        scrollX = 0;
        scrollY = 0;
    }

    override function removeChildren(beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF)
    {
        super.removeChildren(beginIndex, endIndex);
    }

    public function update(elapsed: Int, deltaTime: Int)
    {
        if(_followTarget != null)
        {
            scrollX = ((_followTarget.x + (_followTarget.width * 0.5)) * zoom) - (_content.scrollRect.width * 0.5);
            scrollY = ((_followTarget.y + (_followTarget.height * 0.5)) * zoom) - (_content.scrollRect.height * 0.5);
        }
    }

    public function set_backgroundColor(value: SPColor)
    {
        _background.graphics.clear();
        _background.graphics.beginFill(value, 1);
        _background.graphics.drawRect(0, 0, SPEngine.gameWidth, SPEngine.gameHeight);
        _background.graphics.endFill();

        return backgroundColor = value;
    }

    public function get_scroll()
    {
        return new Point(scrollX, scrollY);
    }

    public function get_scrollX()
    {
        return _content.scrollRect.x;
    }

    public function set_scrollX(value: Float)
    {
        var rect = _content.scrollRect;

        rect.x = boundScrollX(value, zoom);
        
        _content.scrollRect = rect;

        return value;
    }

    public function get_scrollY()
    {
        return _content.scrollRect.y;
    }

    public function set_scrollY(value: Float)
    {
        var rect = _content.scrollRect;

        rect.y = boundScrollY(value, zoom);

        _content.scrollRect = rect;

        return value;
    }

    public function set_zoom(value: Float)
    {
        var c_value = Mathematics.fclamp(value, minZoom, maxZoom);

        _innerContent.scaleX = c_value;
        _innerContent.scaleY = c_value;
        
        var zoomBefore = zoom;

        zoom = c_value;
        
        var z_scroll = centerScrollInZoom(scrollX, scrollY, zoomBefore, zoom);

        scrollX = z_scroll.x;
        scrollY = z_scroll.y;

        return c_value;
    }

    public function centerScrollInZoom(scrollX_: Float, scrollY_: Float, zoomBefore: Float, zoomAfter: Float)
    {
        var offsetX = ((scrollX_ + (SPEngine.gameWidth * 0.5)) * (zoomAfter / zoomBefore)) - (SPEngine.gameWidth * 0.5);
        var offsetY = ((scroll.y + (SPEngine.gameHeight * 0.5)) * (zoomAfter / zoomBefore)) - (SPEngine.gameHeight * 0.5);

        if(_bounds != null)
        {
            return new Point(
                (_bounds.width * zoomAfter < SPEngine.gameWidth) ? boundScrollX(scrollX_, zoomAfter) : offsetX,
                (_bounds.height * zoomAfter < SPEngine.gameHeight) ? boundScrollY(scrollY_, zoomAfter) : offsetY
            );
        }

        return new Point(offsetX, offsetY);
    }

    public function boundScrollX(x: Float, zoom_: Float)
    {
        if(_bounds == null)
        {
            return x;
        }
        else 
        {
            if((_bounds.width * zoom_) - SPEngine.gameWidth < 0)
                return -(SPEngine.gameWidth - (_bounds.width * zoom_)) * 0.5;
            else
                return Mathematics.fclamp(x, _bounds.x * zoom_, (_bounds.width * zoom_) - SPEngine.gameWidth);
        }
    }

    public function boundScrollY(y: Float, zoom_: Float)
    {
        if(_bounds == null)
        {
            return y;
        }
        else 
        {
            if((_bounds.height * zoom_) - SPEngine.gameHeight < 0)
                return -(SPEngine.gameHeight - (_bounds.height * zoom_)) * 0.5;
            else 
                return Mathematics.fclamp(y, _bounds.y * zoom_, (_bounds.height * zoom_) - SPEngine.gameHeight);
        }
    }

    public function set_bounds(value: Rectangle)
    {
        _bounds = value;

        scrollX = scrollX;
        scrollY = scrollY;

        return value;
    }

    public function follow(target: Sprite)
    {
        _followTarget = target;
    }

    public function add(child: DisplayObject): DisplayObject
    {
        return _innerContent.addChild(child);
    }

    public function remove(child: DisplayObject)
    {
        return _innerContent.removeChild(child);
    }

    ////////////////////
    // ISPDestroyable //
    ////////////////////

    public function destroy()
    {
        this.destroyChildren();
    }
}