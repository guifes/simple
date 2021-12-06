package simple.display;

import haxe.Exception;
import openfl.display.BitmapData;

class SPBitmapCache
{
    var _cache: Map<String, BitmapData>;

    public function new()
    {
        _cache = new Map<String, BitmapData>();
    }

    public function add(key: String, bitmapData: BitmapData)
    {
        if(!_cache.exists(key))
        {
            _cache.set(key, bitmapData);
        }
    }

    public function get(key: String)
    {
        if(_cache.exists(key))
            return _cache.get(key);
        else
            throw new Exception('Bitmap key $key doesn\'t exist in the cache.');
    }

    public function check(key: String)
    {
        return _cache.exists(key);
    }

    public function clear()
    {
        _cache.clear();
    }
}