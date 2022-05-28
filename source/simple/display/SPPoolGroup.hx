package simple.display;

import haxe.Constraints.Constructible;
import haxe.Exception;
import openfl.display.DisplayObject;
import polygonal.ds.Hashable;

@:generic
class SPPoolGroup<T: DisplayObject & Hashable> extends SPSpriteGroup
{
    var _pool: SPPool<T>;

	public function new(allocator: Void -> T, initialCapacity: Int = 0)
    {
        super();

		_pool = new SPPool(allocator, initialCapacity);
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