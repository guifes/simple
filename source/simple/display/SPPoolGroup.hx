package simple.display;

import simple.ISPDestroyable;
import haxe.Constraints.Constructible;
import haxe.Exception;
import openfl.display.DisplayObject;

@:generic
class SPPoolGroup<T: DisplayObject & Constructible<Void->Void> & ISPDestroyable> extends SPSpriteGroup
{
    var _generator: Void -> T;
    var _dead: Array<T>;

    public function new(initialCapacity: Int = 0)
    {
        super();

        _dead = [for(_ in 0...initialCapacity) new T()];
    }

    public function get(): T
    {
        var item = _dead.length > 0 ? _dead.pop() : new T();
        this.add(item);
        
        return item;
    }

    public function recycle(item: T)
    {
        if(!this.contains(item))
            throw new Exception("Trying to recycle item from outside of the pool.");

        item.destroy();
        this.remove(item);
        _dead.push(item);
    }
}