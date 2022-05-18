package simple;

import guifes.math.MathUtil;
import haxe.Exception;
import polygonal.ds.HashSet;
import polygonal.ds.Hashable;

class SPPool<T: Hashable>
{
    var _dead: Array<T>;
    var _alive: HashSet<T>;
    var _allocator: Void -> T;
    var _counter: Int;

    public function new(allocator: Void -> T, initialCapacity: Int = 0)
    {
		_allocator = allocator;
		_dead = [for (_ in 0...initialCapacity) _allocator()];
        _alive = new HashSet<T>(32, initialCapacity);

        _counter = initialCapacity;
    }

    public function get(): T
    {
        if(_dead.length > 0)
        {
            var item = _dead.pop();
            _alive.set(item);
            return item;
        }
        else
        {
            _counter++;
            var item = _allocator();
            _alive.set(item);
            return item;
        }
    }

    public function putBack(item: T)
    {
        _dead.push(item);
        _alive.remove(item);
    }

    public function alive()
    {
        return _alive.iterator();
    }
    
    public function dead()
    {
        return _dead.iterator();
    }

    public function getLength()
    {
        if(_counter != _dead.length + _alive.size)
            throw new Exception("This shouldn't happen!");

        return _dead.length + _alive.size;
    }

    public function getAliveCount()
    {
        return _alive.size;
    }

    public function getDeadCount()
    {
        return _dead.length;
    }
}