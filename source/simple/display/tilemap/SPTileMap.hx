package simple.display.tilemap;

import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;

#if debug
import openfl.display.Shape;
#end

class SPTileMap extends Sprite
{
    var _tilemap: Tilemap;
    var _widthInTiles: Int;
    var _heightInTiles: Int;
    var _data: Array<Int>;
    var _autoTilePolicy: SPAutoTilingPolicy;
    var _mapping: Array<Int>;
    var _startingIndex: Int;

#if debug
    public var debug(default, set): Bool;

    var _debugSprite: Shape;
#end

	public function new()
	{
        super();

#if debug
        _debugSprite = new Shape();
        _debugSprite.visible = false;

        addChild(_debugSprite);
#end
	}

    public function loadMapFromArray
    (
        data: Array<Int>,
        widthInTiles:Int,
        heightInTiles: Int,
        bitmapData: BitmapData,
        tileWidth: Int = 0,
        tileHeight: Int = 0,
        startingIndex: Int = 0,
        drawIndex: Int = 1,
        collideIndex: Int = 1,
        autoTilePolicy: SPAutoTilingPolicy = OFF,
        ?mapping: Array<Int>
    )
    {
        _widthInTiles = widthInTiles;
        _heightInTiles = heightInTiles;
        _data = data;
		_autoTilePolicy = autoTilePolicy;
        _startingIndex = startingIndex;

        var rects = new Array<Rectangle>();

        var tilesetWidthInTiles = Std.int(bitmapData.width / tileWidth);
        var tilesetHeightInTiles = Std.int(bitmapData.height / tileHeight);
        
        for(y in 0...tilesetHeightInTiles)
        {   
            for(x in 0...tilesetWidthInTiles)
            {
                var rect = new Rectangle(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
                rects.push(rect);
            }
        }

        var widthInPixel = tileWidth * widthInTiles;
        var heightInPixel = tileHeight * heightInTiles;

        var tileset = new Tileset(bitmapData, rects);
        _tilemap = new Tilemap(widthInPixel, heightInPixel, tileset, false);
        
        for(i in 0...data.length)
        {
            var x: Int = (i % widthInTiles) * tileWidth;
            var y: Int = Std.int(i / widthInTiles) * tileHeight;
            var tile = new Tile(SPAutoTiling.getIdWithAutoTilingSettings(i, _startingIndex, _autoTilePolicy, _widthInTiles, _heightInTiles, _data), x, y);

            _tilemap.addTile(tile);
        }

        addChild(_tilemap);

#if debug
        updateDebug(_tilemap, tileWidth, tileHeight, widthInTiles, heightInTiles);
#end
    }

    function pointToIndex(x: Int, y: Int)
    {
        return (y * _widthInTiles) + x;
    }

    public function getTile(x: Int, y: Int)
    {
        var index = pointToIndex(x, y);
        return _tilemap.getTileAt(index).id;
    }

    public function setTile(x: Int, y: Int, id: Int)
    {
        var index = pointToIndex(x, y);

        _data[index] = id > 0 ? 1 : 0;

        var ids = [index];

        if(_autoTilePolicy != OFF)
        {
            ids.push(pointToIndex(x + 1, y));
            ids.push(pointToIndex(x - 1, y));
            ids.push(pointToIndex(x, y + 1));
            ids.push(pointToIndex(x, y - 1));
        }

        if(_autoTilePolicy == FULL)
        {
            ids.push(pointToIndex(x + 1, y + 1));
            ids.push(pointToIndex(x + 1, y - 1));
            ids.push(pointToIndex(x - 1, y + 1));
            ids.push(pointToIndex(x - 1, y - 1));
        }

        for(i in ids)
        {
            var tile = _tilemap.getTileAt(i);
            tile.id = SPAutoTiling.getIdWithAutoTilingSettings(i, _startingIndex, _autoTilePolicy, _widthInTiles, _heightInTiles, _data);
        }
    }

//#if debug

    function updateDebug(tilemap: Tilemap, tileWidth: Int, tileHeight: Int, widthInTiles: Int, heightInTiles: Int)
    {
        _debugSprite.graphics.clear();
        _debugSprite.graphics.lineStyle(1, 0xFF0000, 0.5);

        for(x in 1...widthInTiles)
        {
            var pos_x = x * tileWidth;
            _debugSprite.graphics.moveTo(pos_x, 0);
            _debugSprite.graphics.lineTo(pos_x, tilemap.height);
        }

        for(y in 0...heightInTiles)
        {
            var pos_y = y * tileHeight;
            _debugSprite.graphics.moveTo(0, pos_y);
            _debugSprite.graphics.lineTo(tilemap.width, pos_y);    
        }
        
        _debugSprite.graphics.drawRect(0, 0, tilemap.width, tilemap.height);

		// var format = new TextFormat(null, 4);

		// for (index in 0...tilemap.numTiles)
        // {
		// 	var tile = _tilemap.getTileAt(index);

        //     var textfield = new TextField();
		// 	textfield.text = '${Std.int(index % widthInTiles)}, ${Std.int(index / widthInTiles)}';
        //     textfield.selectable = false;
        //     textfield.x = tile.x;
        //     textfield.y = tile.y;
        //     textfield.textColor = SPColor.RED;
		// 	textfield.setTextFormat(format);
        //     textfield.visible = true;
            
        //     addChild(textfield);
        // }
    }

    public function set_debug(value: Bool)
    {
        _debugSprite.visible = value;
        return debug = value;
    }

//#end
}