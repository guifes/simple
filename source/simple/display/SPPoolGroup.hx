package simple.display;

import haxe.Constraints.Constructible;
import haxe.Exception;
import openfl.display.DisplayObject;
import polygonal.ds.Hashable;

@:generic
class SPPoolGroup<T: DisplayObject & Constructible<Void -> Void> & Hashable> extends SPSpriteGroup
{
    var _pool: SPPool<T>;

    public function new(initialCapacity: Int = 0)
    {
        super();

		_pool = new SPPool(allocate, initialCapacity);
    }

    function allocate()
    {
        return new T();
    }
    
    public function get(): T
    {
        var item = _pool.get();
        this.add(item);
        
        return item;
    }
    
    public function putBack(item: T)
    {
        if(!this.contains(item))
            throw new Exception("Trying to recycle item from outside of the pool.");
        
        this.remove(item);
        _pool.putBack(item);
    }
}